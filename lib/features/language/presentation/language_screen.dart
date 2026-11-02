import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../app_flow/domain/flow_config.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../monetization/domain/ad_models.dart';
import '../../monetization/presentation/native_ad_slot.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';

/// Same screen for first-run setup and Settings → Language. The selection
/// is applied only when the user taps the Done icon.
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key, this.fromSettings = false});

  final bool fromSettings;

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  late String _selected = ref.read(settingsProvider).languageCode;

  Future<void> _done() async {
    await ref.read(settingsProvider.notifier).confirmLanguage(_selected);
    if (!mounted) return;
    if (widget.fromSettings) {
      context.pop();
    } else {
      final next = ref.read(appFlowProvider.notifier).advance(FlowStep.language);
      if (next != null) context.go(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = widget.fromSettings && context.canPop();
    return PopScope(
      // First run can't go back to a finished step.
      canPop: widget.fromSettings,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          automaticallyImplyLeading: false,
          titleSpacing: canGoBack ? 0 : AppSpace.page,
          leading: canGoBack
              ? Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12),
                  child: Center(
                    child: SoftIconButton(
                      icon: Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.arrow_back_ios_new_rounded,
                      size: 44,
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                    ),
                  ),
                )
              : null,
          leadingWidth: canGoBack ? 68 : null,
          title: const Text('Language'),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpace.page),
              child: SoftIconButton(
                icon: Icons.check_rounded,
                tooltip: 'Done',
                filled: true,
                size: 44,
                onPressed: _done,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.lg),
                itemCount: supportedLanguages.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpace.sm),
                itemBuilder: (context, i) {
                  final entry = supportedLanguages.entries.elementAt(i);
                  return _LanguageRow(
                    native: entry.value.$1,
                    english: entry.value.$2,
                    flag: entry.value.$3,
                    selected: entry.key == _selected,
                    onTap: () => setState(() => _selected = entry.key),
                  ).animate(delay: ((i > 10 ? 10 : i) * 30).ms).fadeIn(duration: 250.ms);
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.page, 0, AppSpace.page, AppSpace.md),
                child: NativeAdSlot(
                  placement: widget.fromSettings ? AdPlacement.languageSettings : AdPlacement.languageFirstRun,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.native,
    required this.english,
    required this.flag,
    required this.selected,
    required this.onTap,
  });

  final String native;
  final String english;
  final String flag;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: TapScale(
        onTap: onTap,
        semanticLabel: '$english, $native',
        child: AnimatedContainer(
          duration: AppDurations.medium,
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.md),
          decoration: BoxDecoration(
            color: selected ? p.primaryTint : p.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: selected ? p.primary : p.divider, width: selected ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(native, style: context.text.titleSmall),
                    if (native != english) Text(english, style: context.text.bodySmall),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: AppDurations.medium,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: selected ? AppColors.mainGradient : null,
                  border: selected ? null : Border.all(color: p.divider, width: 2),
                ),
                child: selected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
