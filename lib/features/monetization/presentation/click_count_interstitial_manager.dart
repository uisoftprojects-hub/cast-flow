import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../premium/domain/premium_status_service.dart';
import '../domain/ad_adapter.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';
import 'ad_display_coordinator.dart';
import 'ad_manager.dart';
import 'splash_interstitial_manager.dart';

/// Manages click interstitial advertisements throughout the app.
///
/// Features:
/// - Counts every tap anywhere in the app (see AnyTapListener): 1st tap loads, 2nd tap shows,
///   whatever it was on. Nothing is excluded by action or screen; the only limits are the ones
///   that keep ads from covering the startup flow (splash, language, onboarding, paywall), a
///   Premium user, an ad already on screen, and one click interstitial per session.
/// - Proactively preloads interstitials so ads are ready when the user clicks.
/// - Reloads after display so clicks throughout the session can show ads when ready.
class ClickCountInterstitialManager {
  ClickCountInterstitialManager({
    required AdAdapter adapter,
    required AdDisplayCoordinator coordinator,
    SplashInterstitialManager? splash,
  }) : _adapter = adapter,
       _coordinator = coordinator,
       _splash = splash;

  final AdAdapter _adapter;
  final AdDisplayCoordinator _coordinator;
  final SplashInterstitialManager? _splash;

  int _clickCount = 0;
  bool _sessionInterstitialDisplayed = false;
  LoadedFullScreenAd? _loadedAd;
  bool _isLoading = false;

  int get clickCount => _clickCount;
  bool get sessionInterstitialDisplayed => _sessionInterstitialDisplayed;
  bool get isLoaded => _loadedAd != null;
  bool get isLoading => _isLoading;

  /// Proactively preloads the click interstitial so it is already ready in memory.
  void preload({required bool isPremium}) {
    if (isPremium || _isLoading || _loadedAd != null) return;
    _loadInterstitial(isPremium: isPremium);
  }

  /// Completes once no full-screen ad is on screen (right away when none is).
  /// A screen that starts something right after the tap (the Cast picker, a
  /// new screen) waits on this so it doesn't open behind the interstitial the
  /// tap itself triggered.
  Future<void> waitUntilAdClosed() async {
    if (!_coordinator.isFullScreenShowing) return;
    await _coordinator.onDisplayStateChanged
        .firstWhere((showing) => !showing)
        .timeout(const Duration(minutes: 2), onTimeout: () => false);
  }

  /// Static helper for any widget with [BuildContext] to record a user click.
  ///
  /// The returned future completes once the click has been handled: right
  /// away when no ad is shown, or only after an interstitial that this click
  /// triggered has been dismissed (or failed to show). Await it before
  /// navigating so the next screen never opens behind the ad.
  static Future<void> recordClick(
    BuildContext context, {
    String? targetRoute,
    String? contextTag,
  }) async {
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      await container
          .read(clickCountInterstitialManagerProvider)
          .onUserClick(
            isPremium: container.read(isPremiumProvider),
            targetRoute: targetRoute,
            contextTag: contextTag,
          );
    } catch (_) {}
  }

  /// Backward-compatible alias for bottom navigation clicks.
  Future<void> onBottomNavClick({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) => onUserClick(
    isPremium: isPremium,
    contextTag: 'bottom_nav',
    onImpression: onImpression,
    onClicked: onClicked,
  );

  /// Handles a user click anywhere in the app.
  Future<void> onUserClick({
    required bool isPremium,
    String? currentRoute,
    String? targetRoute,
    String? contextTag,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    // 1. Exclude premium users
    if (isPremium) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message: 'Click ignored: user is premium.',
      );
      return;
    }

    // 2. Exclude if single session click interstitial has already been displayed
    if (_sessionInterstitialDisplayed) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'Click ignored: 1 click interstitial per session limit already reached.',
      );
      return;
    }

    // 3. Exclude clicks while another full-screen ad is actively presenting
    if (_coordinator.isFullScreenShowing) {
      AdLogger.d(
        AdState.coordinatorLockRejected,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'Click ignored: another full-screen ad is actively presenting.',
      );
      return;
    }

    // 5. Pending splash interstitial takes priority on the first click
    final splash = _splash;
    if (splash != null && splash.isPending) {
      final shown = await splash.tryShowOnHomeClick(
        isPremium: isPremium,
        onImpression: onImpression,
        onClicked: onClicked,
      );
      if (shown) _loadInterstitial(isPremium: isPremium);
      return;
    }

    _clickCount++;
    final src = contextTag ?? targetRoute ?? currentRoute ?? 'general';
    AdLogger.i(
      AdState.clickCounterIncremented,
      placement: AdPlacement.clickInterstitial,
      adType: 'ClickInterstitial',
      message: 'click_inter_tap (tap#$_clickCount src=$src ready=$isLoaded)',
    );

    // 6. On 1st click: start loading interstitial in background; do not show yet
    if (_clickCount == 1) {
      if (!_isLoading && _loadedAd == null) {
        _loadInterstitial(isPremium: isPremium);
      } else if (_isLoading) {
        AdLogger.i(
          AdState.requestSkipped,
          placement: AdPlacement.clickInterstitial,
          adType: 'ClickInterstitial',
          message:
              'click_load_skipped (shown=$_sessionInterstitialDisplayed loading=$_isLoading ready=$isLoaded)',
        );
      }
      return;
    }

    // 7. On 2nd click (or subsequent clicks if 2nd click arrived while still loading):
    // Show ad if loaded. Once shown, mark session complete (1 ad per session limit).
    if (_loadedAd != null) {
      final ad = _loadedAd!;
      _loadedAd = null;

      AdLogger.i(
        AdState.showRequested,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'Click interstitial is ready; presenting on click $_clickCount.',
      );

      final shown = await _coordinator.present(
        adType: 'click_interstitial',
        placement: AdPlacement.clickInterstitial,
        isPremium: isPremium,
        displayAction: () async {
          await ad.show(
            onImpression: () => onImpression?.call(),
            onClicked: onClicked,
          );
        },
      );

      ad.dispose();

      if (shown) {
        _sessionInterstitialDisplayed = true;
        AdLogger.i(
          AdState.showing,
          placement: AdPlacement.clickInterstitial,
          adType: 'ClickInterstitial',
          message:
              'Click interstitial presented successfully. Session limit (1 ad) reached.',
        );
      }
    } else {
      // Ad is not ready yet: report not ready and retry loading if not already in flight
      AdLogger.i(
        AdState.loadFailed,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'click_inter_not_ready (tap#$_clickCount: ad not loaded yet, retrying load)',
      );
      if (!_isLoading) {
        _loadInterstitial(isPremium: isPremium);
      } else {
        AdLogger.i(
          AdState.requestSkipped,
          placement: AdPlacement.clickInterstitial,
          adType: 'ClickInterstitial',
          message:
              'click_load_skipped (shown=$_sessionInterstitialDisplayed loading=$_isLoading ready=$isLoaded)',
        );
      }
    }
  }

  Future<void> _loadInterstitial({required bool isPremium}) async {
    if (isPremium || _sessionInterstitialDisplayed || _loadedAd != null) {
      return;
    }

    if (_isLoading) {
      AdLogger.i(
        AdState.requestSkipped,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'click_load_skipped (shown=$_sessionInterstitialDisplayed loading=$_isLoading ready=$isLoaded)',
      );
      return;
    }

    _isLoading = true;
    AdLogger.i(
      AdState.requestLoading,
      placement: AdPlacement.clickInterstitial,
      adType: 'ClickInterstitial',
      message: 'Loading click interstitial in background.',
    );
    try {
      final ad = await _adapter.loadInterstitial(AdPlacement.clickInterstitial);
      _isLoading = false;

      if (isPremium || _sessionInterstitialDisplayed) {
        ad.dispose();
        return;
      }
      _loadedAd = ad;
      AdLogger.i(
        AdState.loaded,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'Click interstitial loaded successfully and ready for next click.',
      );
    } catch (e) {
      _isLoading = false;
      AdLogger.w(
        AdState.loadFailed,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'ad_no_fill / load failed ($e). Opportunity remains open for next click.',
        error: e,
      );
    }
  }

  /// Called when premium is purchased
  void onPremiumPurchased() {
    AdLogger.d(
      AdState.premiumPurge,
      placement: AdPlacement.clickInterstitial,
      adType: 'ClickInterstitial',
      message: 'Disposing click interstitial due to premium purchase.',
    );
    _loadedAd?.dispose();
    _loadedAd = null;
    _sessionInterstitialDisplayed = true;
  }

  void dispose() {
    _loadedAd?.dispose();
    _loadedAd = null;
  }
}

final clickCountInterstitialManagerProvider =
    Provider<ClickCountInterstitialManager>((ref) {
      final adapter = ref.watch(adAdapterProvider);
      final coordinator = ref.watch(adDisplayCoordinatorProvider);
      final manager = ClickCountInterstitialManager(
        adapter: adapter,
        coordinator: coordinator,
        splash: ref.read(splashInterstitialManagerProvider),
      );
      ref.onDispose(manager.dispose);
      return manager;
    });
