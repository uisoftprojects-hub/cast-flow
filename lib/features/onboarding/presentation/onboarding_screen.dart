import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/illustrations.dart';
import '../../app_flow/domain/flow_config.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../monetization/domain/ad_models.dart';
import '../../monetization/presentation/native_ad_slot.dart';
import '../../settings/presentation/settings_controller.dart';

class _Slide {
  const _Slide(this.kind, this.title, this.body);
  final IllustrationKind kind;
  final String title;
  final String body;
}

const _slides = [
  _Slide(IllustrationKind.mirror, 'Mirror your screen to any TV',
      'Show your phone on the big screen in one tap — no cables, no fuss.'),
  _Slide(IllustrationKind.media, 'Cast photos, videos & music',
      'Share memories with the whole room and keep control from your phone.'),
  _Slide(IllustrationKind.web, 'Cast from web & apps',
      'Send videos from YouTube, Facebook and any website straight to your TV.'),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == _slides.length - 1;

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(duration: AppDurations.slow, curve: Curves.easeOutCubic);
    }
  }

  /// Persists completion only once the user actually finishes or skips.
  Future<void> _finish() async {
    await ref.read(settingsProvider.notifier).completeOnboarding();
    if (!mounted) return;
    final next = ref.read(appFlowProvider.notifier).advance(FlowStep.onboarding);
    if (next != null) context.go(next);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return PopScope(
      canPop: false,
      child: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.md),
                child: AnimatedOpacity(
                  duration: AppDurations.medium,
                  opacity: _isLast ? 0 : 1,
                  child: TextButton(
                    onPressed: _isLast ? null : _finish,
                    style: TextButton.styleFrom(minimumSize: const Size(64, kMinTap)),
                    child: Text('Skip', style: context.text.labelLarge?.copyWith(color: p.textSecondary)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final s = _slides[i];
                  return LayoutBuilder(
                    builder: (context, c) => SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpace.xxl),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: c.maxHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CastIllustration(kind: s.kind, size: (c.maxWidth * 0.8).clamp(200, 320))
                                .animate(key: ValueKey(i))
                                .fadeIn(duration: 500.ms)
                                .scale(begin: const Offset(0.92, 0.92), curve: Curves.easeOutCubic),
                            const SizedBox(height: AppSpace.xxxl),
                            Text(s.title, textAlign: TextAlign.center, style: context.text.headlineLarge),
                            const SizedBox(height: AppSpace.md),
                            Text(s.body, textAlign: TextAlign.center, style: context.text.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Separate region between content and controls so the ad never
            // covers artwork, text, dots or navigation.
            const Padding(
              padding: EdgeInsets.fromLTRB(AppSpace.xxl, AppSpace.md, AppSpace.xxl, 0),
              child: NativeAdSlot(placement: AdPlacement.onboarding),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.xxl, AppSpace.lg, AppSpace.xxl, AppSpace.xxl),
              child: Row(
                children: [
                  Semantics(
                    label: 'Page ${_page + 1} of ${_slides.length}',
                    child: Row(
                      children: [
                        for (var i = 0; i < _slides.length; i++)
                          AnimatedContainer(
                            duration: AppDurations.medium,
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsetsDirectional.only(end: 6),
                            width: i == _page ? 26 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: i == _page ? AppColors.mainGradient : null,
                              color: i == _page ? null : p.primaryTint,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GradientButton(
                    label: _isLast ? 'Get started' : 'Next',
                    icon: _isLast ? Iconsax.tick_circle_copy : Iconsax.arrow_right_3_copy,
                    onPressed: _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
