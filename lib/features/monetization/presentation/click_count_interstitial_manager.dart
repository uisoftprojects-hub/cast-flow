import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ad_adapter.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';
import 'ad_display_coordinator.dart';
import 'ad_manager.dart';
import 'splash_interstitial_manager.dart';

/// Manages bottom navigation click-count interstitial advertisements.
/// Main rule: In one application session, user can see a maximum of ONE click-count interstitial advertisement.
///
/// Flow:
/// 1st click: Record click, request load if no ready ad exists, continue navigation normally, do not show ad.
/// 2nd click: If ad loaded, show it. Otherwise continue navigation and retry loading.
/// On successful display: Mark session interstitial completed. Never show another for rest of session.
/// On failure to load or show: Keep opportunity open and retry.
class ClickCountInterstitialManager {
  // ignore: prefer_initializing_formals
  ClickCountInterstitialManager({
    required this._adapter,
    required this._coordinator,
    this._splash,
  });

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

  /// Handles an eligible bottom navigation item tap.
  Future<void> onBottomNavClick({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    // Exclude premium users and completed session
    if (isPremium) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message: 'Bottom nav click ignored: user is premium.',
      );
      return;
    }

    if (_sessionInterstitialDisplayed) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'Bottom nav click ignored: session-scoped interstitial has already completed.',
      );
      return;
    }

    // Exclude clicks while another full-screen ad is already showing
    if (_coordinator.isFullScreenShowing) {
      AdLogger.d(
        AdState.coordinatorLockRejected,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'Bottom nav click ignored: another full-screen ad is actively presenting.',
      );
      return;
    }

    // A splash interstitial that hasn't been shown yet takes the first Home click.
    // The click-count ad is only requested after it is dismissed.
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
    AdLogger.i(
      AdState.clickCounterIncremented,
      placement: AdPlacement.clickInterstitial,
      adType: 'ClickInterstitial',
      message:
          'Bottom nav click registered | count: $_clickCount (load threshold: 1, show threshold: 2)',
    );

    if (_clickCount == 1) {
      // 1st eligible click: record click, request load, do not show
      if (_loadedAd == null && !_isLoading) {
        AdLogger.i(
          AdState.requestStart,
          placement: AdPlacement.clickInterstitial,
          adType: 'ClickInterstitial',
          message:
              '1st eligible click: initiating background load; navigation proceeds without showing ad.',
        );
        _loadInterstitial(isPremium: isPremium);
      }
      return;
    }

    if (_clickCount >= 2) {
      // 2nd eligible click (or retry subsequent clicks): show if ready, else retry loading
      if (_loadedAd != null) {
        final ad = _loadedAd!;
        _loadedAd = null;

        AdLogger.i(
          AdState.showRequested,
          placement: AdPlacement.clickInterstitial,
          adType: 'ClickInterstitial',
          message:
              '2nd eligible click: interstitial is ready; requesting presentation lock and display.',
        );

        final shown = await _coordinator.present(
          adType: 'bottom_nav_click_interstitial',
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
            AdState.sessionCompleted,
            placement: AdPlacement.clickInterstitial,
            adType: 'ClickInterstitial',
            message:
                'Session-scoped interstitial displayed; maximum 1 per session rule enforced.',
          );
        } else {
          AdLogger.w(
            AdState.showFailed,
            placement: AdPlacement.clickInterstitial,
            adType: 'ClickInterstitial',
            message:
                'Interstitial presentation failed or was rejected; retrying background load.',
          );
          // If ad failed to show, restore ability to try again and request another ad
          _loadInterstitial(isPremium: isPremium);
        }
      } else {
        AdLogger.d(
          AdState.requestLoading,
          placement: AdPlacement.clickInterstitial,
          adType: 'ClickInterstitial',
          message:
              '2nd eligible click: ad not ready yet; navigation proceeds and background load requested.',
        );
        // Not ready yet: continue navigation and ensure loading is requested
        if (!_isLoading) {
          _loadInterstitial(isPremium: isPremium);
        }
      }
    }
  }

  Future<void> _loadInterstitial({required bool isPremium}) async {
    if (isPremium ||
        _sessionInterstitialDisplayed ||
        _isLoading ||
        _loadedAd != null) {
      return;
    }

    _isLoading = true;
    AdLogger.i(
      AdState.requestLoading,
      placement: AdPlacement.clickInterstitial,
      adType: 'ClickInterstitial',
      message: 'Loading click-count interstitial.',
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
            'Click-count interstitial loaded successfully and ready for next click.',
      );
    } catch (e) {
      _isLoading = false;
      AdLogger.w(
        AdState.loadFailed,
        placement: AdPlacement.clickInterstitial,
        adType: 'ClickInterstitial',
        message:
            'Click-count interstitial failed to load; keeping opportunity open for retry.',
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
      message: 'Disposing click-count interstitial due to premium purchase.',
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
