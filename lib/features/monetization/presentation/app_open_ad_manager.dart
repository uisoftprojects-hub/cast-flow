import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../../core/navigation.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/ad_adapter.dart';
import '../domain/ad_config.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';
import '../domain/ad_suppression.dart';
import 'ad_display_coordinator.dart';
import 'ad_manager.dart';

/// Manages Google AdMob App Open advertisements on background-to-foreground transitions.
/// Rules:
/// - Loads App Open ads only on the dedicated transparent Ad Loading screen.
/// - Ad Loading screen has a hard maximum limit of 6 seconds; it also closes at once on a load error.
/// - Delayed show: an ad that finishes loading after the overlay closed is kept and used FIRST on the next
///   eligible foreground event (no second request is made while one is still in flight).
/// - Returning from permission prompts, system settings and external links never shows an App Open ad.
/// - Freshness: expired ads (> 4 hours) are discarded and reloaded.
/// - Never shows to premium users.
class AppOpenAdManager {
  // ignore: prefer_initializing_formals
  AppOpenAdManager({required this._adapter, required this._coordinator});

  final AdAdapter _adapter;
  final AdDisplayCoordinator _coordinator;

  LoadedFullScreenAd? _loadedAd;
  DateTime? _loadedAt;
  DateTime? _backgroundedAt;
  bool _suppressThisBackground = false;
  Future<LoadedFullScreenAd?>? _inFlight;
  int _epoch = 0;
  bool _overlayActive = false;
  Route<void>? _overlayRoute;

  bool get isOverlayActive => _overlayActive;
  bool get hasLoadedAd => _loadedAd != null && isAdFresh;

  /// Checks Google App Open freshness guidance (ads expire after 4 hours)
  bool get isAdFresh {
    if (_loadedAd == null || _loadedAt == null) return false;
    return DateTime.now().difference(_loadedAt!) < AdMobConfig.appOpenFreshness;
  }

  void onBackgrounded() {
    // pause + hide both fire for one background trip: keep the first.
    if (_backgroundedAt != null) return;
    _suppressThisBackground = AdSuppression.take();
    _backgroundedAt = DateTime.now();
    AdLogger.i(
      AdState.backgrounded,
      placement: AdPlacement.appOpen,
      adType: 'AppOpen',
      message: 'App backgrounded at $_backgroundedAt',
    );
  }

  /// Called upon a genuine background -> foreground transition
  Future<void> onResumed({
    required bool isPremium,
    required bool isAppEligible,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    final backgroundedTime = _backgroundedAt;
    _backgroundedAt = null;

    if (backgroundedTime == null) return;

    // Came back from a permission prompt / system settings / external link.
    final suppressed = _suppressThisBackground;
    _suppressThisBackground = false;
    if (suppressed) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: AdPlacement.appOpen,
        adType: 'AppOpen',
        message: 'App Open skipped: returned from an in-app launched permission/settings/link.',
      );
      return;
    }

    // No minimum background time and no gap between App Open ads: every genuine resume is eligible.
    AdLogger.i(
      AdState.resumed,
      placement: AdPlacement.appOpen,
      adType: 'AppOpen',
      message: 'App resumed | background: ${DateTime.now().difference(backgroundedTime).inMilliseconds}ms',
    );

    // Rule: Never show ads to premium users
    if (isPremium || !isAppEligible) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: AdPlacement.appOpen,
        adType: 'AppOpen',
        message: 'App Open skipped: isPremium=$isPremium, isAppEligible=$isAppEligible',
      );
      return;
    }

    // Rule: Never show if another full-screen ad is active or purchase in progress
    if (!_coordinator.canShow(isPremium: isPremium)) {
      AdLogger.d(
        AdState.coordinatorLockRejected,
        placement: AdPlacement.appOpen,
        adType: 'AppOpen',
        message: 'App Open presentation rejected: coordinator is locked with another full-screen ad.',
      );
      return;
    }

    // Check freshness: discard expired ad
    if (_loadedAd != null && !isAdFresh) {
      AdLogger.w(
        AdState.expiredDiscarded,
        placement: AdPlacement.appOpen,
        adType: 'AppOpen',
        message: 'Cached App Open ad expired (> 4 hours); discarding.',
      );
      _loadedAd?.dispose();
      _loadedAd = null;
      _loadedAt = null;
    }

    // If a valid fresh ad is already ready: display it immediately
    if (_loadedAd != null) {
      AdLogger.i(
        AdState.showRequested,
        placement: AdPlacement.appOpen,
        adType: 'AppOpen',
        message: 'Fresh cached App Open ad is ready; displaying immediately without loading screen.',
      );
      await _displayLoadedAd(isPremium: isPremium, onImpression: onImpression, onClicked: onClicked);
      return;
    }

    // If no ad is ready, activate the dedicated 6-second Ad Loading overlay
    AdLogger.i(
      AdState.overlayShowing,
      placement: AdPlacement.appOpen,
      adType: 'AppOpen',
      message: 'No ad cached; displaying dedicated transparent 6-second Ad Loading overlay.',
    );
    await _showAdLoadingOverlayAndLoad(isPremium: isPremium, onImpression: onImpression, onClicked: onClicked);
  }

  Future<void> _displayLoadedAd({required bool isPremium, VoidCallback? onImpression, VoidCallback? onClicked}) async {
    final ad = _loadedAd;
    if (ad == null) return;
    _loadedAd = null;
    _loadedAt = null;

    AdLogger.i(
      AdState.showRequested,
      placement: AdPlacement.appOpen,
      adType: 'AppOpen',
      message: 'Presenting App Open ad via AdDisplayCoordinator.',
    );

    // Full-screen backdrop behind the ad so the app never shows through it.
    final backdrop = _pushBackdrop();
    try {
      await _coordinator.present(
        adType: 'app_open',
        placement: AdPlacement.appOpen,
        isPremium: isPremium,
        displayAction: () async {
          await ad.show(onImpression: () => onImpression?.call(), onClicked: onClicked);
        },
      );
    } finally {
      if (backdrop != null && backdrop.isActive) backdrop.navigator?.removeRoute(backdrop);
      ad.dispose();
    }
  }

  Route<void>? _pushBackdrop() {
    final nav = rootNavigatorKey.currentState;
    if (nav == null) return null;
    final route = PageRouteBuilder<void>(
      settings: const RouteSettings(name: '/ad-backdrop'),
      opaque: true,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, _, _) => PopScope(
        canPop: false,
        child: ColoredBox(
          color: context.isDark ? Colors.black : Colors.white,
          child: const SizedBox.expand(),
        ),
      ),
    );
    nav.push(route);
    return route;
  }

  /// Starts (or joins) the single in-flight App Open request. The ad is cached
  /// the moment it arrives, even when the overlay is already gone, so the next
  /// foreground uses it first instead of requesting another one.
  Future<LoadedFullScreenAd?> _requestAd() {
    final running = _inFlight;
    if (running != null) return running;
    final epoch = _epoch;
    final future = () async {
      try {
        final ad = await _adapter.loadAppOpen();
        if (epoch != _epoch) {
          ad.dispose();
          return null;
        }
        _loadedAd?.dispose();
        _loadedAd = ad;
        _loadedAt = DateTime.now();
        return ad;
      } catch (e) {
        AdLogger.w(
          AdState.loadFailed,
          placement: AdPlacement.appOpen,
          adType: 'AppOpen',
          message: 'App Open ad failed to load: $e',
        );
        return null;
      } finally {
        _inFlight = null;
      }
    }();
    _inFlight = future;
    return future;
  }

  /// Displays the transparent Ad Loading overlay (max [AdMobConfig.appOpenLoadTimeout]).
  /// It closes immediately on error or timeout instead of loading forever.
  Future<void> _showAdLoadingOverlayAndLoad({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    if (_overlayActive) return;

    final nav = rootNavigatorKey.currentState;
    if (nav == null) return;

    _overlayActive = true;
    final route = PageRouteBuilder<void>(
      settings: const RouteSettings(name: '/ad-loading'),
      opaque: false,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, _, _) => const AdLoadingOverlayWidget(),
      transitionsBuilder: (_, a, _, child) => FadeTransition(opacity: a, child: child),
    );
    _overlayRoute = route;
    nav.push(route);

    var timedOut = false;
    LoadedFullScreenAd? loaded;
    try {
      loaded = await _requestAd().timeout(
        AdMobConfig.appOpenLoadTimeout,
        onTimeout: () {
          timedOut = true;
          return null;
        },
      );
    } catch (_) {
      loaded = null;
    }

    _dismissOverlay();

    if (timedOut) {
      AdLogger.w(
        AdState.overlayTimeout,
        placement: AdPlacement.appOpen,
        adType: 'AppOpen',
        message: 'Ad Loading overlay timed out; hidden. A late ad is cached for the next foreground.',
      );
      return;
    }
    if (loaded == null) return;
    if (isPremium) {
      onPremiumPurchased();
      return;
    }

    if (_coordinator.canShow(isPremium: isPremium)) {
      await _displayLoadedAd(isPremium: isPremium, onImpression: onImpression, onClicked: onClicked);
    }
  }

  void _dismissOverlay() {
    if (_overlayActive) {
      AdLogger.d(
        AdState.overlayDismissed,
        placement: AdPlacement.appOpen,
        adType: 'AppOpen',
        message: 'Dismissing Ad Loading screen overlay.',
      );
    }
    _overlayActive = false;
    final route = _overlayRoute;
    _overlayRoute = null;
    if (route != null && route.isActive) {
      route.navigator?.removeRoute(route);
    }
  }

  /// Immediately disposes ad and closes loading overlay when premium is purchased
  void onPremiumPurchased() {
    AdLogger.d(
      AdState.premiumPurge,
      placement: AdPlacement.appOpen,
      adType: 'AppOpen',
      message: 'Disposing App Open ad and dismissing overlay due to premium purchase.',
    );
    _epoch++;
    _dismissOverlay();
    _loadedAd?.dispose();
    _loadedAd = null;
    _loadedAt = null;
  }

  void dispose() {
    _epoch++;
    _dismissOverlay();
    _loadedAd?.dispose();
    _loadedAd = null;
    _loadedAt = null;
  }
}

/// Dedicated transparent Ad Loading overlay matching Section 9 visual specifications:
/// - Full-screen transparent overlay; app remains visible behind it.
/// - Semi-transparent dark/light overlay according to theme.
/// - Centered circular progress indicator.
/// - "Ad is loading..." text below progress indicator.
class AdLoadingOverlayWidget extends StatelessWidget {
  const AdLoadingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return PopScope(
      canPop: false,
      child: Material(
        color: isDark ? Colors.black.withValues(alpha: 0.60) : Colors.black.withValues(alpha: 0.38),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox.square(
                dimension: 42,
                child: CircularProgressIndicator(strokeWidth: 3.5, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.adIsLoading,
                style: context.text.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final appOpenAdManagerProvider = Provider<AppOpenAdManager>((ref) {
  final adapter = ref.watch(adAdapterProvider);
  final coordinator = ref.watch(adDisplayCoordinatorProvider);
  final manager = AppOpenAdManager(adapter: adapter, coordinator: coordinator);
  ref.onDispose(manager.dispose);
  return manager;
});
