import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ad_adapter.dart';
import '../domain/ad_config.dart';
import '../domain/ad_models.dart';

/// Google Mobile Ads (AdMob) + UMP consent. Android/iOS only.
class GoogleAdAdapter implements AdAdapter {
  @override
  Future<void> initialize() async {
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
    if (await canRequestAds()) await MobileAds.instance.initialize();
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
    NativeAd(
      adUnitId: AdConfig.unitId(placement),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: medium ? TemplateType.medium : TemplateType.small,
        cornerRadius: 16,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) => c.complete(_Native(ad as NativeAd)),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          c.completeError(error.message);
        },
        onAdImpression: (_) => onImpression(),
        onAdClicked: (_) => onClicked(),
      ),
    ).load();
    return c.future;
  }

  @override
  Future<LoadedFullScreenAd> loadInterstitial() {
    final c = Completer<LoadedFullScreenAd>();
    InterstitialAd.load(
      adUnitId: AdConfig.unitId(AdPlacement.interstitial),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => c.complete(_Interstitial(ad)),
        onAdFailedToLoad: (error) => c.completeError(error.message),
      ),
    );
    return c.future;
  }

  @override
  Future<LoadedFullScreenAd> loadAppOpen() {
    final c = Completer<LoadedFullScreenAd>();
    AppOpenAd.load(
      adUnitId: AdConfig.unitId(AdPlacement.appOpen),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => c.complete(_AppOpen(ad)),
        onAdFailedToLoad: (error) => c.completeError(error.message),
      ),
    );
    return c.future;
  }
}

class _Native extends LoadedNativeAd {
  _Native(this.ad);
  final NativeAd ad;

  @override
  Widget build(BuildContext context) => AdWidget(ad: ad);

  @override
  void dispose() => ad.dispose();
}

class _Interstitial extends LoadedFullScreenAd {
  _Interstitial(this.ad);
  final InterstitialAd ad;

  @override
  Future<void> show({required VoidCallback onImpression, VoidCallback? onClicked}) {
    final c = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdImpression: (_) => onImpression(),
      onAdClicked: (_) => onClicked?.call(),
      onAdDismissedFullScreenContent: (_) => c.complete(),
      onAdFailedToShowFullScreenContent: (_, _) => c.complete(),
    );
    ad.show();
    return c.future;
  }

  @override
  void dispose() => ad.dispose();
}

class _AppOpen extends LoadedFullScreenAd {
  _AppOpen(this.ad);
  final AppOpenAd ad;

  @override
  Future<void> show({required VoidCallback onImpression, VoidCallback? onClicked}) {
    final c = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdImpression: (_) => onImpression(),
      onAdClicked: (_) => onClicked?.call(),
      onAdDismissedFullScreenContent: (_) => c.complete(),
      onAdFailedToShowFullScreenContent: (_, _) => c.complete(),
    );
    ad.show();
    return c.future;
  }

  @override
  void dispose() => ad.dispose();
}
