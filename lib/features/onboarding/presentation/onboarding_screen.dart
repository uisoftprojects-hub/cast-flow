import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/widgets/ad_side_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import 'onboarding_scene.dart';
import '../../app_flow/domain/flow_config.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../monetization/domain/ad_models.dart';
import '../../monetization/presentation/native_ad_slot.dart';
import '../../settings/presentation/settings_controller.dart';

import '../../../core/l10n.dart';

class _Slide {
  const _Slide(this.kind, this.title, this.body);
  final SceneKind kind;
  final String title;
  final String body;
}

const _slides = [
  _Slide(
    SceneKind.mirror,
    'Mirror your screen to any TV',
    'Show your phone on the big screen in one tap — no cables, no fuss.',
  ),
  _Slide(
    SceneKind.media,
    'Cast photos, videos & music',
    'Share memories with the whole room and keep control from your phone.',
  ),
  _Slide(
    SceneKind.web,
    'Cast from web & apps',
    'Send videos from YouTube, Facebook and any website straight to your TV.',
  ),
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

  /// Persists completion once the user finishes the last slide.
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
    final landscape = isLandscape(context);
    final pages = PageView.builder(
      controller: _controller,
      itemCount: _slides.length,
      onPageChanged: (i) => setState(() => _page = i),
      itemBuilder: (context, i) => LayoutBuilder(builder: (context, c) => _slide(context, i, c)),
    );
    final controls = Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.xxl,
        landscape ? AppSpace.sm : AppSpace.lg,
        AppSpace.xxl,
        landscape ? AppSpace.md : AppSpace.xxl,
      ),
      child: Row(
        children: [
          Semantics(
            label: context.l10n.pageOf(_page + 1, _slides.length),
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
            label: _isLast ? context.l10n.getStarted : context.l10n.next,
            icon: _isLast ? Iconsax.tick_circle_copy : Iconsax.arrow_right_3_copy,
            onPressed: _next,
          ),
        ],
      ),
    );
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: landscape
              // Landscape: slides and controls on the left, the ad in its own
              // column on the right.
              ? AdSideLayout(
                  content: Column(
                    children: [
                      Expanded(child: pages),
                      controls,
                    ],
                  ),
                  ad: const NativeAdSlot(placement: AdPlacement.onboarding),
                )
              : Column(
                  children: [
                    const SizedBox(height: AppSpace.xl),
                    Expanded(child: pages),
                    // Separate region between content and controls so the ad
                    // never covers artwork, text, dots or navigation.
                    const Padding(
                      padding: EdgeInsets.fromLTRB(AppSpace.xxl, AppSpace.md, AppSpace.xxl, 0),
                      child: NativeAdSlot(placement: AdPlacement.onboarding),
                    ),
                    controls,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _slide(BuildContext context, int i, BoxConstraints c) {
    final s = _slides[i];
    final wide = c.maxWidth > c.maxHeight;
    final scene = OnboardingScene(
      kind: s.kind,
      size: wide ? (c.maxHeight * 1.05).clamp(180, 320) : (c.maxWidth * 0.92).clamp(240, 360),
    ).animate(key: ValueKey(i)).fadeIn(duration: 450.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
    final text = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          context.tr(s.title),
          textAlign: wide ? TextAlign.start : TextAlign.center,
          style: context.text.headlineLarge,
        ),
        const SizedBox(height: AppSpace.md),
        Text(context.tr(s.body), textAlign: wide ? TextAlign.start : TextAlign.center, style: context.text.bodyMedium),
        const SizedBox(height: AppSpace.lg),
        // Every slide also tells the user hotspot works when there is no Wi-Fi.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: context.palette.primaryTint,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.mobile_copy, size: 14, color: context.palette.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  context.l10n.onboardHotspotTitle,
                  style: context.text.labelMedium?.copyWith(color: context.palette.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    if (wide) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
        child: Row(
          children: [
            scene,
            const SizedBox(width: AppSpace.xl),
            Expanded(child: SingleChildScrollView(child: text)),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.xxl),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: c.maxHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scene,
            const SizedBox(height: AppSpace.xxxl),
            text,
          ],
        ),
      ),
    );
  }
}
