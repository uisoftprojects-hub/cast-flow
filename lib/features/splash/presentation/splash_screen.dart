import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_logo.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../devices/presentation/device_providers.dart';
import '../../monetization/domain/ad_config.dart';
import '../../monetization/presentation/ad_manager.dart';
import '../../monetization/presentation/native_ad_manager.dart';
import '../../monetization/presentation/splash_interstitial_manager.dart';
import '../../premium/domain/premium_status_service.dart';
import '../../settings/presentation/settings_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;

  /// Progress bar: runs 0 -> 100% in exactly [AdMobConfig.splashTimeout] (6s),
  /// started together with the navigation timer so both end at the same moment.
  late final AnimationController _bar = AnimationController(vsync: this, duration: AdMobConfig.splashTimeout);

  @override
  void initState() {
    super.initState();
    // The 6 second clock starts the moment the splash appears and never waits
    // for consent, billing or ads: those run alongside it.
    _bar.forward();
    // Navigation waits for the splash clock AND the entitlement check, so a
    // returning/reinstalled subscriber never sees a paywall flash. The check
    // itself is time-bounded (PremiumStatusService.restoreTimeout).
    _timer = Timer(AdMobConfig.splashTimeout, () async {
      await _entitlement;
      if (mounted) _navigateNext();
    });
    Future.microtask(_runStartup);
  }

  late final Future<bool> _entitlement = ref.read(premiumStatusServiceProvider).verifyStartupEntitlement();

  Future<void> _runStartup() async {
    ref.read(appFlowProvider.notifier).splashShown();

    // Ads must not wait for the (up to 8s) billing check, otherwise the splash
    // interstitial is not ready by the time the user leaves Language / Paywall.
    // A cached Premium user (isPremium already true) never loads ads; if billing
    // later proves Premium, everything is purged below.
    unawaited(_entitlement.then((premium) {
      if (premium && mounted) ref.read(adManagerProvider.notifier).onPremiumPurchased();
    }));
    if (ref.read(premiumStatusServiceProvider).isPremium) return;

    // Fresh interstitial opportunity for this launch (first vs returning placement).
    final isReturning = ref.read(settingsProvider).firstLaunchCompleted;
    final splashMgr = ref.read(splashInterstitialManagerProvider)..resetForNewSession(isReturning: isReturning);

    // Request Google UMP consent; the interstitial is already "in flight" while it runs.
    final consent = ref.read(consentManagerProvider).gatherConsentAndInitialize(isPremium: false);
    final load = splashMgr.startSplashLoad(isPremium: false, isReturning: isReturning, prerequisite: consent);
    await consent;
    if (!mounted) return;

    // Language native ad loads while the splash is still running
    ref.read(nativeAdManagerProvider).preloadLanguageAd(isPremium: false);
    unawaited(load);
  }

  void _navigateNext() {
    if (!mounted) return;
    if (ref.read(settingsProvider).firstLaunchCompleted) {
      ref.read(connectionProvider.notifier).autoConnect();
    }
    final nextRoute = ref.read(appFlowProvider.notifier).start();
    context.go(nextRoute);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // "This action may contain ads" only once the user is verified as Free, so a
    // Premium user never sees it while the entitlement check is still running.
    final showAdNote = ref.watch(shouldShowPremiumPromotionProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.gradientEnd,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: PopScope(
        // Back does nothing on the splash screen.
        canPop: false,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(gradient: AppColors.mainGradient),
            child: Stack(
              children: [
                // Soft floating blobs.
                PositionedDirectional(top: -60, end: -40, child: _Blob(220, Colors.white.withValues(alpha: 0.12))),
                PositionedDirectional(
                  bottom: -80,
                  start: -60,
                  child: _Blob(260, AppColors.secondary.withValues(alpha: 0.25)),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(size: 112)
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack, duration: 700.ms),
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.appName,
                        style: context.text.headlineLarge?.copyWith(color: Colors.white),
                      ).animate(delay: 300.ms).fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                      const SizedBox(height: 6),
                      Text(
                        context.l10n.mirrorCastBeautifullySimple,
                        style: context.text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                      ).animate(delay: 500.ms).fadeIn(duration: 600.ms),
                    ],
                  ),
                ),
                // Smooth progress bar filling over the 6-second splash time
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(48, 0, 48, 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AnimatedBuilder(
                              animation: _bar,
                              builder: (context, _) => LinearProgressIndicator(
                                value: _bar.value,
                                minHeight: 6,
                                backgroundColor: Colors.white.withValues(alpha: 0.22),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (showAdNote) ...[
                            const SizedBox(height: 12),
                            Text(
                              context.l10n.thisActionMayContain,
                              style: context.text.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob(this.size, this.color);
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        )
        .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
        .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08), duration: 3.seconds, curve: Curves.easeInOut);
  }
}
