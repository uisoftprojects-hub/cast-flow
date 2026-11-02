import 'package:flutter/widgets.dart';

import 'ad_models.dart';

/// A loaded native ad that a screen can render. Disposed by AdManager.
abstract class LoadedNativeAd {
  Widget build(BuildContext context);
  void dispose();
}

/// A loaded interstitial / App Open ad.
abstract class LoadedFullScreenAd {
  /// Presents the ad; completes when it is dismissed or fails to show.
  Future<void> show({required VoidCallback onImpression, VoidCallback? onClicked});
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

  Future<LoadedFullScreenAd> loadInterstitial();

  Future<LoadedFullScreenAd> loadAppOpen();
}
