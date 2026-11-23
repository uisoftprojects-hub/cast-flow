import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n.dart';
import '../../../core/widgets/ad_side_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../app_flow/domain/flow_config.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../monetization/domain/ad_models.dart';
import '../../monetization/presentation/native_ad_manager.dart';
import '../../monetization/presentation/native_ad_slot.dart';
import '../../monetization/presentation/splash_interstitial_manager.dart';
import '../../premium/domain/premium_status_service.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';

/// Language screen for first-run setup and Settings → Language.
/// Selection is applied when user taps the check icon.
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key, this.fromSettings = false});

  final bool fromSettings;

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  late String _selected = ref.read(settingsProvider).languageCode;
  late final _nativeMgr = ref.read(nativeAdManagerProvider);
  bool _closing = false;
  bool _firstRunBusy = false;

  /// Done icon shows a spinner (primary colour) while the native ad loads.
  bool _adLoading = false;

  @override
  void initState() {
    super.initState();
    _nativeMgr; // resolve now: ref can't be read during dispose
    _startLandingLoader();
  }

  /// Default loader on landing: the ad request goes out as the screen opens and a
  /// 3s spinner (dimmed screen, taps blocked) gives it time to load and be seen.
  static const _landingLoader = Duration(seconds: 3);
  Timer? _loaderTimer;

  void _startLandingLoader() {
    if (ref.read(isPremiumProvider)) return;
    _adLoading = true;
    _loaderTimer = Timer(_landingLoader, () {
      if (mounted) setState(() => _adLoading = false);
    });
  }

  @override
  void dispose() {
    _loaderTimer?.cancel();
    // Shown ad is spent (disposed); an unshown / still-loading one is kept for next time.
    _nativeMgr.releaseLanguageAdIfShown();
    super.dispose();
  }

  final _adKey = GlobalKey<NativeAdSlotState>();

  /// Settings: back leaves without applying the language.
  void _back() {
    // Loader showing (ad loading): back is disabled until it finishes.
    if (_closing || _adLoading) return;
    _closing = true;
    context.pop();
  }

  Future<void> _done() async {
    if (_adLoading || _firstRunBusy) return;
    if (widget.fromSettings) {
      // Leave the screen first, then switch the locale, so the whole app does not
      // rebuild around this screen (and its native ad view) while it is closing.
      final notifier = ref.read(settingsProvider.notifier);
      final code = _selected;
      if (_closing) return; // double-tap on the check icon
      _closing = true;
      if (!mounted) return;
      context.pop();
      // Wait for the exit transition to finish (320ms) and then for a frame
      // boundary: changing the locale rebuilds every Localizations dependent, and
      // doing that while this route's elements are still being torn down trips
      // the "really is our descendant" framework assertion.
      Future<void>.delayed(const Duration(milliseconds: 500), () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => notifier.confirmLanguage(code),
        );
        WidgetsBinding.instance.scheduleFrame();
      });
    } else {
      _firstRunBusy = true; // back / repeat taps ignored while finishing
      await ref.read(settingsProvider.notifier).confirmLanguage(_selected);
      if (!mounted) return;
      // First run: Splash Interstitial Opportunity 1
      final isPremium = ref.read(isPremiumProvider);
      if (!isPremium) {
        await ref
            .read(splashInterstitialManagerProvider)
            .tryShowAtLanguageCompletion(isPremium: isPremium);
      }
      if (!mounted) return;
      final next = ref
          .read(appFlowProvider.notifier)
          .advance(FlowStep.language);
      if (next != null) context.go(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = widget.fromSettings && context.canPop();
    return PopScope(
      canPop: false,
      // First run: back acts like Continue (shows the splash ad if ready, then moves on).
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        widget.fromSettings ? _back() : _done();
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              systemOverlayStyle: context.systemOverlayStyle(),
              toolbarHeight: 68,
              clipBehavior: Clip.none,
              automaticallyImplyLeading: false,
              titleSpacing: canGoBack ? 0 : AppSpace.page,
              leading: canGoBack
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, size: 26),
                          tooltip: context.l10n.browserBack,
                          onPressed: _back,
                        ),
                      ),
                    )
                  : null,
              leadingWidth: canGoBack ? 68 : null,
              title: Text(context.l10n.language),
              actions: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpace.page),
                  child: IconButton(
                    icon: _adLoading
                        ? SizedBox.square(
                            dimension: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: context.palette.primary,
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 30),
                    tooltip: context.l10n.done,
                    color: context.palette.primary,
                    onPressed: _adLoading ? null : _done,
                  ),
                ),
              ],
            ),
            body: AdSideLayout(
              content: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.page,
                  AppSpace.sm,
                  AppSpace.page,
                  AppSpace.lg,
                ),
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
                  );
                },
              ),
              // Medium native ad at bottom, full available width, ZERO horizontal padding
              ad: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: NativeAdSlot(
                    placement: widget.fromSettings
                        ? AdPlacement.languageSettings
                        : AdPlacement.languageFirstRun,
                    key: _adKey,
                    onSettled: (loaded) {
                      if (mounted && _adLoading) {
                        setState(() => _adLoading = false);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.lg,
            vertical: AppSpace.md,
          ),
          decoration: BoxDecoration(
            color: selected ? p.primaryTint : p.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected ? p.primary : p.divider,
              width: selected ? 1.5 : 1,
            ),
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
                    if (native != english)
                      Text(english, style: context.text.bodySmall),
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
                  border: selected
                      ? null
                      : Border.all(color: p.divider, width: 2),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
