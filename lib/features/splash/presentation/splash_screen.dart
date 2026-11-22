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
import '../../monetization/presentation/ad_manager.dart';import '../../monetization/presentation/splash_interstitial_manager.dart';
import '../../premium/domain/premium_status_service.dart';
import '../../premium/presentation/billing_controller.dart';
import '../../settings/presentation/settings_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;

  /// Progress bar: runs 0 -> 100% in exactly [AdMobConfig.splashTimeout] (9s),
  /// started together with the navigation timer so both end at the same moment.
  late final AnimationController _bar = AnimationController(
    vsync: this,
    duration: AdMobConfig.splashTimeout,
  );

  @override
  void initState() {
    super.initState();
    // Consent, premium verification and other startup services run first; the
    // splash clock and the interstitial request then start together (_runStartup).
    Future.microtask(_runStartup);
  }

  /// Starts the splash clock (progress bar + navigation timer).
  void _startClock() {
    if (_timer != null || !mounted) return;
    _bar.forward();
    _timer = Timer(AdMobConfig.splashTimeout, () async {
      // An ad that is already on screen finishes the splash itself when closed.
      if (_showingAd) return;
      final premium = await _entitlement;
      if (!mounted || _showingAd) return;
      // Loaded during the splash -> shown on the splash, then move on.
      if (!premium) await _showSplashAd();
      _finish();
    });
  }

  bool _showingAd = false;
  bool _finished = false;

  /// Shows the splash interstitial if it is loaded. Returns once it is closed.
  Future<void> _showSplashAd() async {
    if (_showingAd || _finished) return;
    _showingAd = true;
    try {
      await ref
          .read(splashInterstitialManagerProvider)
          .tryShowOnSplash(isPremium: false);
    } finally {
      _showingAd = false;
    }
  }

  /// Leaves the splash exactly once.
  void _finish() {
    if (_finished || !mounted) return;
    _finished = true;
    _timer?.cancel();
    _navigateNext();
  }

  /// Interstitial finished loading: show it right away (no waiting for the splash
  /// timer); when the user closes it, move straight on to the next screen.
  Future<void> _onSplashAdLoaded() async {
    if (!mounted || _finished || _showingAd) return;
    final splash = ref.read(splashInterstitialManagerProvider);
    if (!splash.isLoaded) return;
    await _showSplashAd();
    if (!mounted) return;
    await _entitlement;
    _finish();
  }

  late final Future<bool> _entitlement = ref
      .read(premiumStatusServiceProvider)
      .verifyStartupEntitlement();

  Future<void> _runStartup() async {
    ref.read(appFlowProvider.notifier).splashShown();

    // A cached Premium user never loads ads; if billing later proves Premium,
    // everything is purged.
    final premiumFuture = _entitlement.then((premium) {
      if (premium && mounted) {
        ref.read(adManagerProvider.notifier).onPremiumPurchased();
      }
      return premium;
    });
    final cachedPremium = ref.read(premiumStatusServiceProvider).isPremium;

    // Consent (UMP / ads init) + premium verification, bounded so a slow service
    // can never hold the splash forever.
    final consent = cachedPremium
        ? Future<void>.value()
        : ref
              .read(consentManagerProvider)
              .gatherConsentAndInitialize(isPremium: false);
    // Paywall prices load now, inside the same window, so the paywall opens with
    // them ready (no loader there).
    final prices = cachedPremium
        ? Future<void>.value()
        : _preloadPaywallPrices();
    try {
      await Future.wait<Object?>([
        consent,
        premiumFuture,
        prices,
      ]).timeout(const Duration(seconds: 6));
    } catch (_) {}
    if (!mounted) return;

    // Right after the services are ready: splash timer + interstitial request
    // start together.
    _startClock();
    if (ref.read(premiumStatusServiceProvider).isPremium) return;

    final isReturning = ref.read(settingsProvider).firstLaunchCompleted;
    final splashMgr = ref.read(splashInterstitialManagerProvider)
      ..resetForNewSession(isReturning: isReturning);
    unawaited(
      splashMgr
          .startSplashLoad(isPremium: false, isReturning: isReturning)
          .whenComplete(_onSplashAdLoaded),
    );
    // No native preload: the Language / Onboarding ads are requested only when the
    // user lands on those screens.
  }

  Future<void> _preloadPaywallPrices() async {
    try {
      ref.read(purchaseStateProvider);
      await ref.read(storeProductsProvider.future);
    } catch (_) {}
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
                PositionedDirectional(
                  top: -60,
                  end: -40,
                  child: _Blob(220, Colors.white.withValues(alpha: 0.12)),
                ),
                PositionedDirectional(
                  bottom: -80,
                  start: -60,
                  child: _Blob(
                    260,
                    AppColors.secondary.withValues(alpha: 0.25),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Shimmer always sweeps left to right, even in RTL languages.
                      const _ShimmerLogo(size: 112)
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(
                            begin: const Offset(0.85, 0.85),
                            curve: Curves.easeOutBack,
                            duration: 700.ms,
                          ),
                      const SizedBox(height: 24),
                      Text(
                            context.l10n.appName,
                            style: context.text.headlineLarge?.copyWith(
                              color: Colors.white,
                            ),
                          )
                          .animate(delay: 300.ms)
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),
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
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.22,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (showAdNote) ...[
                            const SizedBox(height: 12),
                            Text(
                              context.l10n.thisActionMayContain,
                              style: context.text.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
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

/// App icon with a glossy highlight sweeping diagonally from the top-left
/// corner to the bottom-right corner, on repeat. Own controller (not
/// flutter_animate) so it always runs, even if system animations are scaled
/// down; always LTR so RTL languages sweep the same way.
class _ShimmerLogo extends StatefulWidget {
  const _ShimmerLogo({required this.size});
  final double size;

  @override
  State<_ShimmerLogo> createState() => _ShimmerLogoState();
}

class _ShimmerLogoState extends State<_ShimmerLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnimatedBuilder(
        animation: _c,
        child: AppLogo(size: widget.size),
        builder: (context, child) {
          // Band centre travels from -0.5 (before the corner) to 1.5 (past it).
          final t = -0.5 + 2.0 * Curves.easeInOut.transform(_c.value);
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0),
                Colors.white.withValues(alpha: 0.85),
                Colors.white.withValues(alpha: 0),
              ],
              stops: [
                (t - 0.18).clamp(0.0, 1.0),
                t.clamp(0.0, 1.0),
                (t + 0.18).clamp(0.0, 1.0),
              ],
            ).createShader(rect),
            child: child,
          );
        },
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
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.08, 1.08),
          duration: 3.seconds,
          curve: Curves.easeInOut,
        );
  }
}
