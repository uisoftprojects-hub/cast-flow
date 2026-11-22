import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ad_adapter.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';
import 'ad_manager.dart';

/// Centralized manager for native advertisements.
/// Handles preloading for Language and Onboarding screens, and guarantees a single
/// native ad instance across the entire Onboarding sequence.
///
/// Every placement has at most one request in flight; anyone asking while it is
/// loading joins it, and anyone asking after it finished gets the cached ad. So a
/// screen that is left and reopened mid-load never triggers a second request.
class NativeAdManager {
  // ignore: prefer_initializing_formals
  NativeAdManager({required AdAdapter adapter}) : _adapter = adapter;

  final AdAdapter _adapter;

  LoadedNativeAd? _preloadedLanguageAd;
  DateTime? _languageAdLoadedAt;
  static const _languageAdMaxAge = Duration(minutes: 45);
  Future<LoadedNativeAd?>? _languageInFlight;
  bool _languageImpressed = false;

  LoadedNativeAd? _preloadedOnboardingAd;
  Future<LoadedNativeAd?>? _onboardingInFlight;

  LoadedNativeAd? _activeOnboardingAd;

  LoadedNativeAd? get preloadedLanguageAd => _preloadedLanguageAd;
  LoadedNativeAd? get activeOnboardingAd => _activeOnboardingAd;

  /// Preloads the Language native ad during splash after the splash interstitial is requested
  Future<void> preloadLanguageAd({required bool isPremium}) async {
    if (isPremium || _preloadedLanguageAd != null) return;
    AdLogger.i(
      AdState.preloadStart,
      placement: AdPlacement.languageFirstRun,
      adType: 'Native',
      message: 'Preloading Language native ad during startup.',
    );
    await _loadLanguage(AdPlacement.languageFirstRun, isPremium: isPremium);
  }

  /// Starts (or joins) the single Language request and caches the result.
  Future<LoadedNativeAd?> _loadLanguage(
    AdPlacement placement, {
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) {
    final running = _languageInFlight;
    if (running != null) {
      AdLogger.i(
        AdState.preloadConsumed,
        placement: placement,
        adType: 'Native',
        message: 'Language native ad already loading; joining that request.',
      );
      return running;
    }
    final future = () async {
      try {
        _languageImpressed = false;
        final ad = await _adapter.loadNative(
          placement,
          medium: true,
          onImpression: () {
            _languageImpressed = true;
            onImpression?.call();
          },
          onClicked: onClicked ?? () {},
        );
        if (isPremium) {
          ad.dispose();
          return null;
        }
        _preloadedLanguageAd?.dispose();
        _preloadedLanguageAd = ad;
        _languageAdLoadedAt = DateTime.now();
        AdLogger.i(
          AdState.preloadSuccess,
          placement: placement,
          adType: 'Native',
          message: 'Language native ad loaded and cached.',
        );
        return ad;
      } catch (e) {
        AdLogger.w(
          AdState.loadFailed,
          placement: placement,
          adType: 'Native',
          message: 'Language native ad load failed: $e',
        );
        return null;
      } finally {
        _languageInFlight = null;
      }
    }();
    _languageInFlight = future;
    return future;
  }

  /// Retrieves preloaded Language ad or loads a fresh one (e.g. from Settings)
  Future<LoadedNativeAd?> getOrLoadLanguageAd({
    required bool isPremium,
    required bool fromSettings,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    if (isPremium) return null;

    // One Language ad is shared by first-run and Settings and reused while it is
    // still fresh, so reopening the screen never requests it again.
    final cached = _preloadedLanguageAd;
    if (cached != null) {
      final age = DateTime.now().difference(
        _languageAdLoadedAt ?? DateTime.now(),
      );
      if (age < _languageAdMaxAge) {
        AdLogger.i(
          AdState.preloadConsumed,
          placement: fromSettings
              ? AdPlacement.languageSettings
              : AdPlacement.languageFirstRun,
          adType: 'Native',
          message:
              'Reusing already loaded Language native ad (no new request).',
        );
        return cached;
      }
      cached.dispose();
      _preloadedLanguageAd = null;
    }

    return _loadLanguage(
      fromSettings ? AdPlacement.languageSettings : AdPlacement.languageFirstRun,
      isPremium: isPremium,
      onImpression: onImpression,
      onClicked: onClicked,
    );
  }

  /// Called when the Language screen is left. An ad that was never shown (still
  /// loading, or loaded but no impression) is kept for the next visit; one that
  /// already counted an impression is disposed so the next visit requests a new one.
  void releaseLanguageAdIfShown() {
    if (!_languageImpressed) return;
    final ad = _preloadedLanguageAd;
    _preloadedLanguageAd = null;
    _languageImpressed = false;
    if (ad == null) return;
    // Let the leaving route finish tearing down its AdWidget first.
    Future<void>.delayed(const Duration(milliseconds: 600), ad.dispose);
  }

  /// Preloads the Onboarding native ad on the Paywall screen
  Future<void> preloadOnboardingAd({required bool isPremium}) async {
    if (isPremium ||
        _preloadedOnboardingAd != null ||
        _activeOnboardingAd != null) {
      return;
    }
    AdLogger.i(
      AdState.preloadStart,
      placement: AdPlacement.onboarding,
      adType: 'Native',
      message: 'Preloading Onboarding native ad.',
    );
    await _loadOnboarding(isPremium: isPremium);
  }

  /// Starts (or joins) the single Onboarding request; the result is cached.
  Future<LoadedNativeAd?> _loadOnboarding({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) {
    final running = _onboardingInFlight;
    if (running != null) return running;
    final future = () async {
      try {
        final ad = await _adapter.loadNative(
          AdPlacement.onboarding,
          medium: true,
          onImpression: onImpression ?? () {},
          onClicked: onClicked ?? () {},
        );
        if (isPremium) {
          ad.dispose();
          return null;
        }
        _preloadedOnboardingAd?.dispose();
        _preloadedOnboardingAd = ad;
        AdLogger.i(
          AdState.preloadSuccess,
          placement: AdPlacement.onboarding,
          adType: 'Native',
          message: 'Onboarding native ad loaded and cached.',
        );
        return ad;
      } catch (e) {
        AdLogger.w(
          AdState.preloadFailed,
          placement: AdPlacement.onboarding,
          adType: 'Native',
          message: 'Onboarding native ad load failed: $e',
        );
        return null;
      } finally {
        _onboardingInFlight = null;
      }
    }();
    _onboardingInFlight = future;
    return future;
  }

  /// Retrieves the single persistent native ad instance for Onboarding
  Future<LoadedNativeAd?> getOrLoadOnboardingAd({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    if (isPremium) return null;

    if (_activeOnboardingAd != null) return _activeOnboardingAd;

    // Preloaded, or still loading from the preload: use that, never request again.
    if (_preloadedOnboardingAd == null) {
      await _loadOnboarding(
        isPremium: isPremium,
        onImpression: onImpression,
        onClicked: onClicked,
      );
    }
    if (_activeOnboardingAd != null) return _activeOnboardingAd;
    final ready = _preloadedOnboardingAd;
    if (ready == null) return null;
    AdLogger.i(
      AdState.preloadConsumed,
      placement: AdPlacement.onboarding,
      adType: 'Native',
      message: 'Promoting preloaded Onboarding native ad to active instance.',
    );
    _activeOnboardingAd = ready;
    _preloadedOnboardingAd = null;
    return ready;
  }

  /// Disposes the single Onboarding native ad when completing or skipping Onboarding
  void releaseOnboardingAd() {
    AdLogger.d(
      AdState.disposed,
      placement: AdPlacement.onboarding,
      adType: 'Native',
      message: 'Releasing and disposing active Onboarding native ad.',
    );
    _activeOnboardingAd?.dispose();
    _activeOnboardingAd = null;
    _preloadedOnboardingAd?.dispose();
    _preloadedOnboardingAd = null;
  }

  /// Immediately terminates and disposes all native ads when premium is purchased
  void onPremiumPurchased() {
    AdLogger.d(
      AdState.premiumPurge,
      adType: 'NativeManager',
      message:
          'Disposing all preloaded and active native ads due to premium purchase.',
    );
    _preloadedLanguageAd?.dispose();
    _preloadedLanguageAd = null;
    _preloadedOnboardingAd?.dispose();
    _preloadedOnboardingAd = null;
    _activeOnboardingAd?.dispose();
    _activeOnboardingAd = null;
  }

  void dispose() {
    _preloadedLanguageAd?.dispose();
    _preloadedLanguageAd = null;
    _preloadedOnboardingAd?.dispose();
    _preloadedOnboardingAd = null;
    _activeOnboardingAd?.dispose();
    _activeOnboardingAd = null;
  }
}

final nativeAdManagerProvider = Provider<NativeAdManager>((ref) {
  final adapter = ref.watch(adAdapterProvider);
  final manager = NativeAdManager(adapter: adapter);
  ref.onDispose(manager.dispose);
  return manager;
});
