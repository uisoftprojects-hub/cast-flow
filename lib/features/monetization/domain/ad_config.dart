import 'package:flutter/foundation.dart';

import 'ad_models.dart';

/// Local ad configuration (no remote config in the no-backend baseline).
/// Ad unit IDs below are Google's public TEST IDs — replace them with the
/// real AdMob IDs before release.
abstract final class AdConfig {
  /// Force the fake adapter even on Android/iOS: --dart-define=FAKE_ADS=true
  static const forceFakeAds = bool.fromEnvironment('FAKE_ADS');

  static bool get _ios => defaultTargetPlatform == TargetPlatform.iOS;

  static String unitId(AdPlacement p) => switch (p) {
        AdPlacement.languageFirstRun ||
        AdPlacement.languageSettings ||
        AdPlacement.onboarding =>
          _ios ? 'ca-app-pub-3940256099942544/3986624511' : 'ca-app-pub-3940256099942544/2247696110',
        AdPlacement.interstitial =>
          _ios ? 'ca-app-pub-3940256099942544/4411468910' : 'ca-app-pub-3940256099942544/1033173712',
        AdPlacement.appOpen =>
          _ios ? 'ca-app-pub-3940256099942544/5575463023' : 'ca-app-pub-3940256099942544/9257395921',
      };

  // Five-click interstitial.
  static const loadAtClick = 3;
  static const showAtClick = 5;

  /// Wait after a no-fill / load error before counting clicks again.
  static const failureCooldown = Duration(seconds: 60);

  /// Settle time after the click-5 navigation before presenting.
  static const showDelay = Duration(milliseconds: 400);

  // App Open.
  static const appOpenMinBackground = Duration(seconds: 3);
  static const appOpenMinInterval = Duration(minutes: 30);
  static const appOpenLoadTimeout = Duration(seconds: 5);

  // Native.
  static const nativeFailureCooldown = Duration(seconds: 30);
  static const nativeMediumHeight = 300.0;
  static const nativeSmallHeight = 112.0;

  static const maxLoggedEvents = 100;
}
