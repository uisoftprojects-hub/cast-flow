import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ad_models.dart';

/// Centralized AdMob Configuration supporting strict Debug vs Release separation.
/// Debug builds use Google's official test IDs.
/// Release builds use production IDs configured via native Android resValues / BuildConfig.
class AdMobConfig {
  static const MethodChannel _channel = MethodChannel('castflow/admob_config');

  /// Force fake ads in tests or previews: --dart-define=FAKE_ADS=true
  static const bool forceFakeAds = bool.fromEnvironment('FAKE_ADS');

  // Override flags for testing
  static bool? debugOverrideIsRelease;
  static Map<String, String>? debugOverrideNativeIds;

  /// Whether native ads should render their dark layout. Set from the app theme
  /// (not the OS theme) in app.dart before any native ad is requested.
  static bool nativeAdIsDark = false;

  static const MethodChannel _themeChannel = MethodChannel(
    'castflow/native_ad_theme',
  );

  /// Sets the native-ad theme and re-colours ads that are already on screen.
  static void syncNativeTheme(bool dark) {
    if (dark == nativeAdIsDark) return;
    nativeAdIsDark = dark;
    if (kIsWeb) return;
    _themeChannel
        .invokeMethod<void>('setDark', {'dark': dark})
        .catchError((_) {});
  }

  static bool get isRelease => debugOverrideIsRelease ?? kReleaseMode;

  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  // Official Google AdMob Test App IDs
  static const String testAppIdAndroid =
      'ca-app-pub-3940256099942544~3347511713';
  static const String testAppIdIOS = 'ca-app-pub-3940256099942544~1458002511';

  // Official Google AdMob Test Ad Unit IDs
  static const String testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialIOS =
      'ca-app-pub-3940256099942544/4411468910';

  static const String testNativeAndroid =
      'ca-app-pub-3940256099942544/2247696110';

  /// Google's video native test unit (Android) for the media-layout screens.
  static const String testNativeVideoAndroid =
      'ca-app-pub-3940256099942544/1044960115';
  static const String testNativeIOS = 'ca-app-pub-3940256099942544/3986624511';

  static const String testAppOpenAndroid =
      'ca-app-pub-3940256099942544/9257395921';
  static const String testAppOpenIOS = 'ca-app-pub-3940256099942544/5575463023';

  // Real Production AdMob Credentials for Cast to TV (com.smarttvcast.screenmirror)
  static const String prodAppIdAndroid =
      'ca-app-pub-3116238716336403~3352823507';
  static const String prodAppOpen = 'ca-app-pub-3116238716336403/1820249985';
  static const String prodLanguageNative =
      'ca-app-pub-3116238716336403/7288199082';
  static const String prodOnboardingNative =
      'ca-app-pub-3116238716336403/4343692730';
  static const String prodSplashInterstitialFirst =
      'ca-app-pub-3116238716336403/9914362422';
  static const String prodSplashInterstitialSecond =
      'ca-app-pub-3116238716336403/5787415153';
  static const String prodClickInterstitial =
      'ca-app-pub-3116238716336403/9252192456';
  static const String prodHomeNative = 'ca-app-pub-3116238716336403/2742624427';

  // Suggested centralized AdMob configuration getters
  static String get appOpenAdUnitId => unitId(AdPlacement.appOpen);
  static String get languageNativeAdUnitId =>
      unitId(AdPlacement.languageFirstRun);
  static String get onboardingNativeAdUnitId => unitId(AdPlacement.onboarding);
  static String get splashInterstitialFirstAdUnitId =>
      unitId(AdPlacement.splashInterstitialFirst);
  static String get splashInterstitialSecondAdUnitId =>
      unitId(AdPlacement.splashInterstitialSecond);
  static String get clickInterstitialAdUnitId =>
      unitId(AdPlacement.clickInterstitial);
  static String get homeNativeAdUnitId => unitId(AdPlacement.homeNative);

  // Cached native config from Android BuildConfig / resValues
  static Map<String, dynamic>? _nativeConfig;

  /// Fetches native Android/iOS ad unit configuration via platform channel
  static Future<void> initializeNativeConfig() async {
    if (kIsWeb) return;
    try {
      final res = await _channel.invokeMapMethod<String, dynamic>(
        'getAdConfig',
      );
      _nativeConfig = res;
    } catch (_) {
      // Running on test or unsupported platform
    }
  }

  /// Registered NativeAdFactory identifier on Android
  static const String nativeFactoryId = 'castflow_native_ad';

  /// Returns the ad unit ID for [placement], strictly observing debug vs release isolation.
  static String unitId(AdPlacement placement) {
    if (!isRelease) {
      // In debug mode: NEVER load production ads
      return switch (placement) {
        // Media layout screens: Google's VIDEO native test unit, so debug shows a real video.
        AdPlacement.languageFirstRun ||
        AdPlacement.languageSettings ||
        AdPlacement.onboarding =>
          isIOS ? testNativeIOS : testNativeVideoAndroid,
        AdPlacement.homeNative => isIOS ? testNativeIOS : testNativeAndroid,
        AdPlacement.splashInterstitialFirst ||
        AdPlacement.splashInterstitialSecond ||
        AdPlacement.clickInterstitial ||
        AdPlacement.interstitial =>
          isIOS ? testInterstitialIOS : testInterstitialAndroid,
        AdPlacement.appOpen => isIOS ? testAppOpenIOS : testAppOpenAndroid,
      };
    } else {
      // In release mode: use production IDs, NEVER load test ads
      if (debugOverrideNativeIds != null) {
        return debugOverrideNativeIds![placement.name] ??
            _productionFallback(placement);
      }
      if (_nativeConfig != null) {
        final id = switch (placement) {
          AdPlacement.languageFirstRun || AdPlacement.languageSettings =>
            _nativeConfig!['languageNativeId'] as String? ??
                _nativeConfig!['nativeId'] as String?,
          AdPlacement.onboarding =>
            _nativeConfig!['onboardingNativeId'] as String? ??
                _nativeConfig!['nativeId'] as String?,
          AdPlacement.homeNative =>
            _nativeConfig!['homeNativeId'] as String? ??
                _nativeConfig!['nativeId'] as String?,
          AdPlacement.splashInterstitialFirst =>
            _nativeConfig!['splashInterstitialFirstId'] as String? ??
                _nativeConfig!['interstitialId'] as String?,
          AdPlacement.splashInterstitialSecond =>
            _nativeConfig!['splashInterstitialSecondId'] as String? ??
                _nativeConfig!['interstitialId'] as String?,
          AdPlacement.clickInterstitial || AdPlacement.interstitial =>
            _nativeConfig!['clickInterstitialId'] as String? ??
                _nativeConfig!['interstitialId'] as String?,
          AdPlacement.appOpen => _nativeConfig!['appOpenId'] as String?,
        };
        if (id != null && id.isNotEmpty && !id.contains('3940256099942544')) {
          return id;
        }
      }
      return _productionFallback(placement);
    }
  }

  static String _productionFallback(AdPlacement placement) {
    // Production IDs from compile-time defines if provided, or the real production credentials
    const defineInterstitial = String.fromEnvironment(
      'ADMOB_PROD_INTERSTITIAL_ID',
    );
    const defineNative = String.fromEnvironment('ADMOB_PROD_NATIVE_ID');
    const defineAppOpen = String.fromEnvironment('ADMOB_PROD_APP_OPEN_ID');

    return switch (placement) {
      AdPlacement.languageFirstRun || AdPlacement.languageSettings =>
        defineNative.isNotEmpty ? defineNative : prodLanguageNative,
      AdPlacement.onboarding =>
        defineNative.isNotEmpty ? defineNative : prodOnboardingNative,
      AdPlacement.homeNative =>
        defineNative.isNotEmpty ? defineNative : prodHomeNative,
      AdPlacement.splashInterstitialFirst =>
        defineInterstitial.isNotEmpty
            ? defineInterstitial
            : prodSplashInterstitialFirst,
      AdPlacement.splashInterstitialSecond =>
        defineInterstitial.isNotEmpty
            ? defineInterstitial
            : prodSplashInterstitialSecond,
      AdPlacement.clickInterstitial || AdPlacement.interstitial =>
        defineInterstitial.isNotEmpty
            ? defineInterstitial
            : prodClickInterstitial,
      AdPlacement.appOpen =>
        defineAppOpen.isNotEmpty ? defineAppOpen : prodAppOpen,
    };
  }

  // ------------------------------------------------ Timing and policies

  /// Splash screen timer duration: exactly 9 seconds
  static const Duration splashTimeout = Duration(seconds: 9);

  /// App Open ad loading screen max duration: 6 seconds
  static const Duration appOpenLoadTimeout = Duration(seconds: 6);

  /// Google App Open ad freshness threshold: 4 hours
  static const Duration appOpenFreshness = Duration(hours: 4);

  /// Minimum background duration to qualify for App Open ad
  static const Duration appOpenMinBackground = Duration(seconds: 3);

  /// Cooldown after a failed ad load before retrying
  static const Duration failureCooldown = Duration(seconds: 60);

  /// Native failure cooldown
  static const Duration nativeFailureCooldown = Duration(seconds: 30);

  /// Settle duration before showing interstitial
  static const Duration showDelay = Duration(milliseconds: 400);

  // Native dimensions
  /// Height of the medium native ad at normal text size. The native layout is
  /// ~68dp of fixed parts (paddings, 12dp gap, CTA) + ~85dp of text (badge,
  /// 2-line title, 2-line description) which grows with the user's font scale, so this is
  /// only the worst-case estimate; the slot replaces it with the real measured
  /// height of the native view once the ad is on screen.
  static const double nativeMediumHeight = 157.0;

  /// Container height for the medium native ad at the given text scale factor.
  static double nativeHeightFor(double textScale) {
    final scale = textScale.clamp(1.0, 2.0);
    return (68 + 85 * scale + 4).ceilToDouble();
  }

  static const double nativeSmallHeight = 112.0;

  /// Estimate for the video layout (12 pad + 120 media + 10 + 53 info + 10 + 44 CTA + 12 pad)
  /// until the native view reports its measured height.
  static const double nativeMediaHeight = 264.0;

  /// Onboarding layout: 8 + 122 content + 8 = 138dp, fixed.
  static const double nativeOnboardingHeight = 138.0;

  static const int loadAtClick = 3;
  static const int showAtClick = 5;

  static const int maxLoggedEvents = 100;
}

/// Backward compatibility alias
typedef AdConfig = AdMobConfig;
