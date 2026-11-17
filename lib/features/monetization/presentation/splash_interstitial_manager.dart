import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ad_adapter.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';
import 'ad_display_coordinator.dart';
import 'ad_manager.dart';

/// Manages the splash interstitial advertisement loading and display lifecycle.
/// Strictly enforces maximum of ONE display opportunity during the startup flow:
/// 1. Language screen completion transition.
/// 2. Paywall screen close transition (if not shown at Language).
/// Never shows on Home. Never delays navigation indefinitely.
class SplashInterstitialManager {
  // ignore: prefer_initializing_formals
  SplashInterstitialManager({
    required this._adapter,
    required this._coordinator,
  });

  final AdAdapter _adapter;
  final AdDisplayCoordinator _coordinator;

  LoadedFullScreenAd? _loadedAd;
  bool _isLoading = false;
  bool _hasShown = false;
  bool _isDismissed = false;

  /// Placement of the current splash interstitial (1st launch vs returning), used in every log line.
  AdPlacement _placement = AdPlacement.splashInterstitialFirst;

  bool get isLoaded => _loadedAd != null;
  bool get hasShown => _hasShown;
  bool get isDismissed => _isDismissed;

  /// Starts loading the splash interstitial concurrently with the splash timer.
  /// First launch uses [AdPlacement.splashInterstitialFirst]; returning user uses [AdPlacement.splashInterstitialSecond].
  /// Clears the previous startup's state so every splash run gets its own request
  /// (the manager outlives a single launch; without this a returning launch would
  /// inherit "dismissed"/"shown" and never load the second interstitial).
  void resetForNewSession({bool isReturning = false}) {
    _loadedAd?.dispose();
    _loadedAd = null;
    _hasShown = false;
    _isDismissed = false;
    _isLoading = false;
    _loadDone = null;
    _placement = isReturning
        ? AdPlacement.splashInterstitialSecond
        : AdPlacement.splashInterstitialFirst;
  }

  /// [prerequisite] (e.g. consent) is awaited while the load is already marked
  /// in-flight, so closing the paywall early waits for it instead of giving up.
  Future<void> startSplashLoad({
    required bool isPremium,
    bool isReturning = false,
    Future<void>? prerequisite,
  }) async {
    if (isPremium ||
        _hasShown ||
        _isDismissed ||
        _isLoading ||
        _loadedAd != null) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: _placement,
        adType: 'SplashInterstitial',
        message:
            'Splash interstitial preload skipped (isPremium: $isPremium, hasShown: $_hasShown, isDismissed: $_isDismissed, isLoading: $_isLoading, isLoaded: ${_loadedAd != null})',
      );
      return;
    }

    _isLoading = true;
    final done = Completer<void>();
    _loadDone = done.future;
    try {
      if (prerequisite != null) {
        try {
          await prerequisite;
        } catch (_) {}
        if (_isDismissed || _hasShown) {
          _isLoading = false;
          return;
        }
      }
      await _load(isReturning);
    } finally {
      done.complete();
    }
  }

  Future<void>? _loadDone;

  /// Waits (bounded) for an in-flight preload, so a user who is fast to reach
  /// the paywall close still gets the ad instead of losing the opportunity.
  Future<void> _awaitInFlight() async {
    final f = _loadDone;
    if (!_isLoading || f == null) return;
    await f.timeout(const Duration(seconds: 3), onTimeout: () {});
  }

  Future<void> _load(bool isReturning) async {
    final placement = isReturning
        ? AdPlacement.splashInterstitialSecond
        : AdPlacement.splashInterstitialFirst;
    _placement = placement;
    AdLogger.i(
      AdState.preloadStart,
      placement: placement,
      adType: 'SplashInterstitial',
      message:
          'Starting splash interstitial preload concurrently with splash timer.',
    );
    try {
      final ad = await _adapter.loadInterstitial(placement);
      _isLoading = false;

      // If user purchased premium or opportunity passed while loading, dispose immediately
      if (_hasShown || _isDismissed) {
        AdLogger.d(
          AdState.disposed,
          placement: placement,
          adType: 'SplashInterstitial',
          message:
              'Splash interstitial loaded after dismissal or show; disposing immediately.',
        );
        ad.dispose();
        return;
      }
      _loadedAd = ad;
      AdLogger.i(
        AdState.preloadSuccess,
        placement: placement,
        adType: 'SplashInterstitial',
        message:
            'Splash interstitial preloaded successfully and cached for startup transition.',
      );
    } catch (e) {
      _isLoading = false;
      AdLogger.w(
        AdState.preloadFailed,
        placement: placement,
        adType: 'SplashInterstitial',
        message:
            'Splash interstitial preload failed; startup flow will continue without blocking.',
        error: e,
      );
    }
  }

  /// Opportunity 1: Language completion transition (first-time user)
  Future<bool> tryShowAtLanguageCompletion({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    if (isPremium || _hasShown || _isDismissed) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: _placement,
        adType: 'SplashInterstitial:Language',
        message:
            'Opportunity 1 skipped (isPremium: $isPremium, hasShown: $_hasShown, isDismissed: $_isDismissed)',
      );
      return false;
    }

    final ad = _loadedAd;
    if (ad == null) {
      AdLogger.d(
        AdState.showRequested,
        placement: _placement,
        adType: 'SplashInterstitial:Language',
        message:
            'Ad not ready yet at Language completion; preserving for Opportunity 2 (Paywall close).',
      );
      return false;
    }

    _loadedAd = null;
    AdLogger.i(
      AdState.showRequested,
      placement: _placement,
      adType: 'SplashInterstitial:Language',
      message: 'Opportunity 1 triggering presentation lock and display.',
    );
    final shown = await _coordinator.present(
      adType: 'splash_interstitial_language',
      placement: _placement,
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
      _hasShown = true;
      AdLogger.i(
        AdState.showing,
        placement: _placement,
        adType: 'SplashInterstitial:Language',
        message:
            'Splash interstitial displayed successfully at Language completion.',
      );
    } else {
      AdLogger.w(
        AdState.showFailed,
        placement: _placement,
        adType: 'SplashInterstitial:Language',
        message:
            'Splash interstitial presentation was rejected by coordinator or failed.',
      );
    }
    return shown;
  }

  /// Opportunity 2: Paywall close button transition (first-time user if not shown at Language, or returning user)
  Future<bool> tryShowAtPaywallClose({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    if (isPremium || _hasShown || _isDismissed) {
      dismiss();
      return false;
    }

    await _awaitInFlight();
    final ad = _loadedAd;
    if (ad == null) {
      // Keep the opportunity: Home will use it on the first click if it loads later.
      AdLogger.d(
        AdState.showRequested,
        placement: _placement,
        adType: 'SplashInterstitial:Paywall',
        message:
            'Ad not loaded before Paywall close; preserving for first Home click.',
      );
      return false;
    }

    _loadedAd = null;
    AdLogger.i(
      AdState.showRequested,
      placement: _placement,
      adType: 'SplashInterstitial:Paywall',
      message: 'Opportunity 2 triggering presentation lock and display.',
    );
    final shown = await _coordinator.present(
      adType: 'splash_interstitial_paywall',
      placement: _placement,
      isPremium: isPremium,
      displayAction: () async {
        await ad.show(
          onImpression: () => onImpression?.call(),
          onClicked: onClicked,
        );
      },
    );

    ad.dispose();
    _hasShown = true;
    _isDismissed = true;
    if (shown) {
      AdLogger.i(
        AdState.showing,
        placement: _placement,
        adType: 'SplashInterstitial:Paywall',
        message: 'Splash interstitial displayed successfully at Paywall close.',
      );
    }
    return shown;
  }

  /// True while the splash ad is still loading or cached and not yet shown.
  /// Other interstitials wait for it so the splash ad is the first one requested/shown.
  bool get isPending =>
      !_hasShown && !_isDismissed && (_isLoading || _loadedAd != null);

  /// Splash itself: if the interstitial finished loading while the splash was
  /// running, it is shown right there (before leaving the splash screen), never
  /// carried over to Language / Paywall. Not loaded yet -> returns false and the
  /// later opportunities stay available.
  Future<bool> tryShowOnSplash({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    final ad = _loadedAd;
    if (isPremium || _hasShown || _isDismissed || ad == null) return false;

    _loadedAd = null;
    AdLogger.i(
      AdState.showRequested,
      placement: _placement,
      adType: 'SplashInterstitial:Splash',
      message: 'Ad loaded during splash; showing it on the splash screen.',
    );
    final shown = await _coordinator.present(
      adType: 'splash_interstitial_splash',
      placement: _placement,
      isPremium: isPremium,
      displayAction: () async {
        await ad.show(
          onImpression: () => onImpression?.call(),
          onClicked: onClicked,
        );
      },
    );
    ad.dispose();
    _hasShown = true;
    _isDismissed = true;
    return shown;
  }

  /// Opportunity 3: first Home click, if the ad was not shown at Language/Paywall.
  Future<bool> tryShowOnHomeClick({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    final ad = _loadedAd;
    if (isPremium || _hasShown || _isDismissed || ad == null) return false;

    _loadedAd = null;
    AdLogger.i(
      AdState.showRequested,
      placement: _placement,
      adType: 'SplashInterstitial:Home',
      message: 'Home click triggering splash interstitial display.',
    );
    final shown = await _coordinator.present(
      adType: 'splash_interstitial_home',
      placement: _placement,
      isPremium: isPremium,
      displayAction: () async {
        await ad.show(
          onImpression: () => onImpression?.call(),
          onClicked: onClicked,
        );
      },
    );
    ad.dispose();
    _hasShown = true;
    _isDismissed = true;
    return shown;
  }

  /// Dismisses the splash interstitial request permanently when opportunities have expired.
  /// Prevents unexpected ads later on Home.
  void dismiss() {
    if (!_isDismissed) {
      AdLogger.d(
        AdState.dismissed,
        placement: _placement,
        adType: 'SplashInterstitial',
        message: 'Permanently dismissing splash interstitial opportunity.',
      );
    }
    _isDismissed = true;
    _loadedAd?.dispose();
    _loadedAd = null;
  }

  /// Called when premium is purchased at any point
  void onPremiumPurchased() {
    AdLogger.d(
      AdState.premiumPurge,
      placement: _placement,
      adType: 'SplashInterstitial',
      message: 'Disposing splash interstitial due to premium purchase.',
    );
    dismiss();
  }

  void dispose() {
    dismiss();
  }
}

final splashInterstitialManagerProvider = Provider<SplashInterstitialManager>((
  ref,
) {
  final adapter = ref.watch(adAdapterProvider);
  final coordinator = ref.watch(adDisplayCoordinatorProvider);
  final manager = SplashInterstitialManager(
    adapter: adapter,
    coordinator: coordinator,
  );
  ref.onDispose(manager.dispose);
  return manager;
});
