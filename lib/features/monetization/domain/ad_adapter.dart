import 'package:flutter/widgets.dart';

import 'ad_models.dart';

/// A loaded native ad that a screen can render. Disposed by AdManager.
abstract class LoadedNativeAd {
  Widget build(BuildContext context);
  void dispose();

  /// Height (dp) the ad needs at [widthDp], measured by the native view once it is
  /// on screen. Null when unknown (not rendered yet, or no native measuring).
  Future<double?> measuredHeight(double widthDp) async => null;
}

/// A loaded interstitial / App Open ad.
abstract class LoadedFullScreenAd {
  /// Presents the ad; completes when it is dismissed or fails to show.
  Future<void> show({
    required VoidCallback onImpression,
    VoidCallback? onClicked,
  });
  void dispose();
}

/// Ad network boundary. AdManager owns all timing decisions; adapters only
/// load and present. Swappable for a fake in tests and previews.
abstract interface class AdAdapter {
  /// Gathers consent (UMP) and initializes the SDK.
  Future<void> initialize();

  Future<bool> canRequestAds();

  Future<LoadedNativeAd> loadNative(
    AdPlacement placement, {
    required bool medium,
    required VoidCallback onImpression,
    required VoidCallback onClicked,
  });

  Future<LoadedFullScreenAd> loadInterstitial([
    AdPlacement placement = AdPlacement.clickInterstitial,
  ]);

  Future<LoadedFullScreenAd> loadAppOpen();
}
