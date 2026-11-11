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
class NativeAdManager {
  // ignore: prefer_initializing_formals
  NativeAdManager({required AdAdapter adapter}) : _adapter = adapter;

  final AdAdapter _adapter;

  LoadedNativeAd? _preloadedLanguageAd;
  bool _isLoadingLanguage = false;

  LoadedNativeAd? _preloadedOnboardingAd;
  bool _isLoadingOnboarding = false;

  LoadedNativeAd? _activeOnboardingAd;

  LoadedNativeAd? get preloadedLanguageAd => _preloadedLanguageAd;
  LoadedNativeAd? get activeOnboardingAd => _activeOnboardingAd;

  /// Preloads the Language native ad during splash after the splash interstitial is requested
  Future<void> preloadLanguageAd({required bool isPremium}) async {
    if (isPremium || _isLoadingLanguage || _preloadedLanguageAd != null) return;
    _isLoadingLanguage = true;
    AdLogger.i(
      AdState.preloadStart,
      placement: AdPlacement.languageFirstRun,
      adType: 'Native',
      message: 'Preloading Language native ad during startup.',
    );
    try {
      final ad = await _adapter.loadNative(
        AdPlacement.languageFirstRun,
        medium: true,
        onImpression: () {},
        onClicked: () {},
      );
      if (isPremium) {
        ad.dispose();
      } else {
        _preloadedLanguageAd = ad;
        AdLogger.i(
          AdState.preloadSuccess,
          placement: AdPlacement.languageFirstRun,
          adType: 'Native',
          message: 'Language native ad preloaded and cached.',
        );
      }
    } catch (e) {
      AdLogger.w(
        AdState.preloadFailed,
        placement: AdPlacement.languageFirstRun,
        adType: 'Native',
        message: 'Language native ad preload failed: $e',
      );
    } finally {
      _isLoadingLanguage = false;
    }
  }

  /// Retrieves preloaded Language ad or loads a fresh one (e.g. from Settings)
  Future<LoadedNativeAd?> getOrLoadLanguageAd({
    required bool isPremium,
    required bool fromSettings,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    if (isPremium) return null;

    if (!fromSettings && _preloadedLanguageAd != null) {
      AdLogger.i(
        AdState.preloadConsumed,
        placement: AdPlacement.languageFirstRun,
        adType: 'Native',
        message: 'Consuming cached preloaded Language native ad.',
      );
      final ad = _preloadedLanguageAd;
      _preloadedLanguageAd = null;
      return ad;
    }

    // Fresh load
    final placement = fromSettings ? AdPlacement.languageSettings : AdPlacement.languageFirstRun;
    AdLogger.i(
      AdState.requestStart,
      placement: placement,
      adType: 'Native',
      message: 'Loading fresh Language native ad (fromSettings: $fromSettings).',
    );
    try {
      return await _adapter.loadNative(
        placement,
        medium: true,
        onImpression: onImpression ?? () {},
        onClicked: onClicked ?? () {},
      );
    } catch (e) {
      AdLogger.w(
        AdState.loadFailed,
        placement: placement,
        adType: 'Native',
        message: 'Fresh load failed for Language native ad: $e',
      );
      return null;
    }
  }

  /// Preloads the Onboarding native ad on the Paywall screen
  Future<void> preloadOnboardingAd({required bool isPremium}) async {
    if (isPremium || _isLoadingOnboarding || _preloadedOnboardingAd != null || _activeOnboardingAd != null) {
      return;
    }
    _isLoadingOnboarding = true;
    AdLogger.i(
      AdState.preloadStart,
      placement: AdPlacement.onboarding,
      adType: 'Native',
      message: 'Preloading Onboarding native ad.',
    );
    try {
      final ad = await _adapter.loadNative(AdPlacement.onboarding, medium: true, onImpression: () {}, onClicked: () {});
      if (isPremium) {
        ad.dispose();
      } else {
        _preloadedOnboardingAd = ad;
        AdLogger.i(
          AdState.preloadSuccess,
          placement: AdPlacement.onboarding,
          adType: 'Native',
          message: 'Onboarding native ad preloaded and cached.',
        );
      }
    } catch (e) {
      AdLogger.w(
        AdState.preloadFailed,
        placement: AdPlacement.onboarding,
        adType: 'Native',
        message: 'Onboarding native ad preload failed: $e',
      );
    } finally {
      _isLoadingOnboarding = false;
    }
  }

  /// Retrieves the single persistent native ad instance for Onboarding
  Future<LoadedNativeAd?> getOrLoadOnboardingAd({
    required bool isPremium,
    VoidCallback? onImpression,
    VoidCallback? onClicked,
  }) async {
    if (isPremium) return null;

    if (_activeOnboardingAd != null) {
      AdLogger.d(
        AdState.preloadConsumed,
        placement: AdPlacement.onboarding,
        adType: 'Native',
        message: 'Reusing existing active Onboarding native ad instance.',
      );
      return _activeOnboardingAd;
    }

    if (_preloadedOnboardingAd != null) {
      AdLogger.i(
        AdState.preloadConsumed,
        placement: AdPlacement.onboarding,
        adType: 'Native',
        message: 'Promoting preloaded Onboarding native ad to active instance.',
      );
      _activeOnboardingAd = _preloadedOnboardingAd;
      _preloadedOnboardingAd = null;
      return _activeOnboardingAd;
    }

    AdLogger.i(
      AdState.requestStart,
      placement: AdPlacement.onboarding,
      adType: 'Native',
      message: 'Loading fresh Onboarding native ad instance.',
    );
    try {
      _activeOnboardingAd = await _adapter.loadNative(
        AdPlacement.onboarding,
        medium: true,
        onImpression: onImpression ?? () {},
        onClicked: onClicked ?? () {},
      );
      return _activeOnboardingAd;
    } catch (e) {
      AdLogger.w(
        AdState.loadFailed,
        placement: AdPlacement.onboarding,
        adType: 'Native',
        message: 'Failed to load Onboarding native ad: $e',
      );
      return null;
    }
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
      message: 'Disposing all preloaded and active native ads due to premium purchase.',
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
