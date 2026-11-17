import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ad_adapter.dart';
import '../domain/ad_config.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';

/// Google Mobile Ads (AdMob) + UMP consent. Android/iOS only.
class GoogleAdAdapter implements AdAdapter {
  @override
  Future<void> initialize() async {
    AdLogger.i(
      AdState.consentCheckStart,
      adType: 'UMP_Consent',
      message: 'GoogleAdAdapter initializing consent and MobileAds SDK.',
    );
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => ConsentForm.loadAndShowConsentFormIfRequired((_) {
        if (!done.isCompleted) done.complete();
      }),
      (_) {
        if (!done.isCompleted) done.complete();
      },
    );
    await done.future;
    if (await canRequestAds()) {
      AdLogger.i(
        AdState.sdkInitStart,
        adType: 'GoogleMobileAds',
        message: 'Initializing MobileAds.instance.',
      );
      await MobileAds.instance.initialize();
      AdLogger.i(
        AdState.sdkInitSuccess,
        adType: 'GoogleMobileAds',
        message: 'MobileAds.instance initialized.',
      );
    }
  }

  @override
  Future<bool> canRequestAds() => ConsentInformation.instance.canRequestAds();

  @override
  Future<LoadedNativeAd> loadNative(
    AdPlacement placement, {
    required bool medium,
    required VoidCallback onImpression,
    required VoidCallback onClicked,
  }) {
    final c = Completer<LoadedNativeAd>();
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isDark = AdMobConfig.nativeAdIsDark;
    final unitId = AdMobConfig.unitId(placement);

    AdLogger.i(
      AdState.requestStart,
      placement: placement,
      adType: 'Native',
      unitId: unitId,
      message:
          'Dispatching NativeAd.load() | isDark: $isDark | medium: $medium',
    );

    NativeAd(
      adUnitId: unitId,
      factoryId: isAndroid ? AdMobConfig.nativeFactoryId : null,
      customOptions: isAndroid ? {'isDark': isDark} : null,
      nativeTemplateStyle: isAndroid
          ? null
          : NativeTemplateStyle(
              templateType: medium ? TemplateType.medium : TemplateType.small,
              cornerRadius: 16,
            ),
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          AdLogger.i(
            AdState.loaded,
            placement: placement,
            adType: 'Native',
            unitId: unitId,
            message: 'NativeAd loaded successfully.',
          );
          c.complete(_Native(ad as NativeAd, placement));
        },
        onAdFailedToLoad: (ad, error) {
          AdLogger.w(
            AdState.loadFailed,
            placement: placement,
            adType: 'Native',
            unitId: unitId,
            message:
                'NativeAd failed to load: [${error.code}] ${error.message} (domain: ${error.domain})',
          );
          ad.dispose();
          c.completeError(error.message);
        },
        onAdImpression: (_) {
          AdLogger.i(
            AdState.impression,
            placement: placement,
            adType: 'Native',
            unitId: unitId,
            message: 'NativeAd impression recorded.',
          );
          onImpression();
        },
        onAdClicked: (_) {
          AdLogger.i(
            AdState.clicked,
            placement: placement,
            adType: 'Native',
            unitId: unitId,
            message: 'NativeAd clicked by user.',
          );
          onClicked();
        },
        onAdOpened: (_) {
          AdLogger.d(
            AdState.opened,
            placement: placement,
            adType: 'Native',
            message: 'NativeAd opened full-screen overlay.',
          );
        },
        onAdClosed: (_) {
          AdLogger.d(
            AdState.dismissed,
            placement: placement,
            adType: 'Native',
            message: 'NativeAd full-screen overlay closed.',
          );
        },
      ),
    ).load();
    return c.future;
  }

  @override
  Future<LoadedFullScreenAd> loadInterstitial([
    AdPlacement placement = AdPlacement.clickInterstitial,
  ]) {
    final c = Completer<LoadedFullScreenAd>();
    final unitId = AdMobConfig.unitId(placement);

    AdLogger.i(
      AdState.requestStart,
      placement: placement,
      adType: 'Interstitial',
      unitId: unitId,
      message: 'Dispatching InterstitialAd.load()',
    );

    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          AdLogger.i(
            AdState.loaded,
            placement: placement,
            adType: 'Interstitial',
            unitId: unitId,
            message: 'InterstitialAd loaded successfully.',
          );
          c.complete(_Interstitial(ad, placement));
        },
        onAdFailedToLoad: (error) {
          AdLogger.w(
            AdState.loadFailed,
            placement: placement,
            adType: 'Interstitial',
            unitId: unitId,
            message:
                'InterstitialAd failed to load: [${error.code}] ${error.message} (domain: ${error.domain})',
          );
          c.completeError(error.message);
        },
      ),
    );
    return c.future;
  }

  @override
  Future<LoadedFullScreenAd> loadAppOpen() {
    final c = Completer<LoadedFullScreenAd>();
    final unitId = AdMobConfig.unitId(AdPlacement.appOpen);

    AdLogger.i(
      AdState.requestStart,
      placement: AdPlacement.appOpen,
      adType: 'AppOpen',
      unitId: unitId,
      message: 'Dispatching AppOpenAd.load()',
    );

    AppOpenAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          AdLogger.i(
            AdState.loaded,
            placement: AdPlacement.appOpen,
            adType: 'AppOpen',
            unitId: unitId,
            message: 'AppOpenAd loaded successfully.',
          );
          c.complete(_AppOpen(ad));
        },
        onAdFailedToLoad: (error) {
          AdLogger.w(
            AdState.loadFailed,
            placement: AdPlacement.appOpen,
            adType: 'AppOpen',
            unitId: unitId,
            message:
                'AppOpenAd failed to load: [${error.code}] ${error.message} (domain: ${error.domain})',
          );
          c.completeError(error.message);
        },
      ),
    );
    return c.future;
  }
}

class _Native extends LoadedNativeAd {
  _Native(this.ad, this.placement);
  final NativeAd ad;
  final AdPlacement placement;

  @override
  Widget build(BuildContext context) {
    AdLogger.d(
      AdState.showing,
      placement: placement,
      adType: 'Native',
      message: 'Rendering AdWidget for Native ad.',
    );
    return AdWidget(ad: ad);
  }

  static const _sizeChannel = MethodChannel('castflow/native_ad_size');

  @override
  Future<double?> measuredHeight(double widthDp) async {
    final id = ad.responseInfo?.responseId;
    if (id == null || defaultTargetPlatform != TargetPlatform.android)
      return null;
    try {
      return await _sizeChannel.invokeMethod<double>('measure', {
        'responseId': id,
        'widthDp': widthDp,
      });
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    AdLogger.d(
      AdState.disposed,
      placement: placement,
      adType: 'Native',
      message: 'Disposing NativeAd instance.',
    );
    ad.dispose();
  }
}

class _Interstitial extends LoadedFullScreenAd {
  _Interstitial(this.ad, this.placement);
  final InterstitialAd ad;
  final AdPlacement placement;

  @override
  Future<void> show({
    required VoidCallback onImpression,
    VoidCallback? onClicked,
  }) {
    final c = Completer<void>();
    AdLogger.i(
      AdState.showRequested,
      placement: placement,
      adType: 'Interstitial',
      message: 'Presenting InterstitialAd.',
    );

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        AdLogger.i(
          AdState.showing,
          placement: placement,
          adType: 'Interstitial',
          message: 'InterstitialAd full screen content displayed.',
        );
      },
      onAdImpression: (_) {
        AdLogger.i(
          AdState.impression,
          placement: placement,
          adType: 'Interstitial',
          message: 'InterstitialAd impression recorded.',
        );
        onImpression();
      },
      onAdClicked: (_) {
        AdLogger.i(
          AdState.clicked,
          placement: placement,
          adType: 'Interstitial',
          message: 'InterstitialAd clicked.',
        );
        onClicked?.call();
      },
      onAdDismissedFullScreenContent: (_) {
        AdLogger.i(
          AdState.dismissed,
          placement: placement,
          adType: 'Interstitial',
          message: 'InterstitialAd dismissed by user.',
        );
        c.complete();
      },
      onAdFailedToShowFullScreenContent: (_, error) {
        AdLogger.e(
          AdState.showFailed,
          placement: placement,
          adType: 'Interstitial',
          message:
              'InterstitialAd failed to show: [${error.code}] ${error.message}',
        );
        c.complete();
      },
    );
    ad.show();
    return c.future;
  }

  @override
  void dispose() {
    AdLogger.d(
      AdState.disposed,
      placement: placement,
      adType: 'Interstitial',
      message: 'Disposing InterstitialAd instance.',
    );
    ad.dispose();
  }
}

class _AppOpen extends LoadedFullScreenAd {
  _AppOpen(this.ad);
  final AppOpenAd ad;

  @override
  Future<void> show({
    required VoidCallback onImpression,
    VoidCallback? onClicked,
  }) {
    final c = Completer<void>();
    AdLogger.i(
      AdState.showRequested,
      placement: AdPlacement.appOpen,
      adType: 'AppOpen',
      message: 'Presenting AppOpenAd.',
    );

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        AdLogger.i(
          AdState.showing,
          placement: AdPlacement.appOpen,
          adType: 'AppOpen',
          message: 'AppOpenAd full screen content displayed.',
        );
      },
      onAdImpression: (_) {
        AdLogger.i(
          AdState.impression,
          placement: AdPlacement.appOpen,
          adType: 'AppOpen',
          message: 'AppOpenAd impression recorded.',
        );
        onImpression();
      },
      onAdClicked: (_) {
        AdLogger.i(
          AdState.clicked,
          placement: AdPlacement.appOpen,
          adType: 'AppOpen',
          message: 'AppOpenAd clicked.',
        );
        onClicked?.call();
      },
      onAdDismissedFullScreenContent: (_) {
        AdLogger.i(
          AdState.dismissed,
          placement: AdPlacement.appOpen,
          adType: 'AppOpen',
          message: 'AppOpenAd dismissed by user.',
        );
        c.complete();
      },
      onAdFailedToShowFullScreenContent: (_, error) {
        AdLogger.e(
          AdState.showFailed,
          placement: AdPlacement.appOpen,
          adType: 'AppOpen',
          message: 'AppOpenAd failed to show: [${error.code}] ${error.message}',
        );
        c.complete();
      },
    );
    ad.show();
    return c.future;
  }

  @override
  void dispose() {
    AdLogger.d(
      AdState.disposed,
      placement: AdPlacement.appOpen,
      adType: 'AppOpen',
      message: 'Disposing AppOpenAd instance.',
    );
    ad.dispose();
  }
}
