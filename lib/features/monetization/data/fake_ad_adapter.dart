import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../domain/ad_adapter.dart';
import '../domain/ad_config.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';
import '../presentation/native_ad_card.dart';

/// Simulated ad network for previews (web, desktop) and tests. Follows the
/// current [PreviewMode]: "Error states" makes every load fail (no fill).
class FakeAdAdapter implements AdAdapter {
  FakeAdAdapter(this._navigator, this._mode);

  final GlobalKey<NavigatorState> _navigator;
  final PreviewMode Function() _mode;

  Future<void> _load(Duration d, {required String adType, AdPlacement? placement}) async {
    AdLogger.i(
      AdState.requestStart,
      placement: placement,
      adType: adType,
      message: 'Simulating $adType load (delay: ${d.inMilliseconds}ms)',
    );
    await Future<void>.delayed(d);
    if (_mode() != PreviewMode.live) {
      AdLogger.w(
        AdState.loadFailed,
        placement: placement,
        adType: adType,
        message: 'FakeAdAdapter simulated No fill (preview mode)',
      );
      throw const FakeServiceException('No fill (preview mode)');
    }
    AdLogger.i(
      AdState.loaded,
      placement: placement,
      adType: adType,
      message: 'FakeAdAdapter simulated ad loaded successfully',
    );
  }

  @override
  Future<void> initialize() async {
    AdLogger.i(AdState.sdkInitSuccess, adType: 'FakeAdAdapter', message: 'FakeAdAdapter initialized.');
  }

  @override
  Future<bool> canRequestAds() async => true;

  @override
  Future<LoadedNativeAd> loadNative(
    AdPlacement placement, {
    required bool medium,
    required VoidCallback onImpression,
    required VoidCallback onClicked,
  }) async {
    await _load(const Duration(milliseconds: 900), adType: 'Native', placement: placement);
    return _FakeNative(medium, onImpression, onClicked, placement);
  }

  @override
  Future<LoadedFullScreenAd> loadInterstitial([AdPlacement placement = AdPlacement.clickInterstitial]) async {
    await _load(const Duration(milliseconds: 1500), adType: 'Interstitial', placement: placement);
    return _FakeFullScreen(_navigator, 'Test interstitial (${placement.name})', placement);
  }

  @override
  Future<LoadedFullScreenAd> loadAppOpen() async {
    await _load(const Duration(milliseconds: 1200), adType: 'AppOpen', placement: AdPlacement.appOpen);
    return _FakeFullScreen(_navigator, 'Test App Open ad', AdPlacement.appOpen);
  }
}

class _FakeNative extends LoadedNativeAd {
  _FakeNative(this.medium, this.onImpression, this.onClicked, this.placement);
  final bool medium;
  final VoidCallback onImpression;
  final VoidCallback onClicked;
  final AdPlacement placement;
  bool _impressed = false;

  @override
  Widget build(BuildContext context) {
    if (!_impressed) {
      _impressed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AdLogger.i(
          AdState.impression,
          placement: placement,
          adType: 'Native',
          message: 'FakeNative ad impression recorded',
        );
        onImpression();
      });
    }
    return NativeAdCard(
      title: 'Test AD: Smart Screen Mirroring & TV Cast',
      description: 'Stream movies, videos, photos and music straight to your TV.',
      ctaText: 'Learn More',
      height: medium ? AdMobConfig.nativeMediumHeight : AdMobConfig.nativeSmallHeight,
      onCtaPressed: () {
        AdLogger.i(AdState.clicked, placement: placement, adType: 'Native', message: 'FakeNative ad clicked');
        onClicked();
      },
      iconWidget: const Center(child: MediaArt(seed: 78, icon: Iconsax.image_copy, iconSize: 36)),
    );
  }

  @override
  void dispose() {
    AdLogger.d(AdState.disposed, placement: placement, adType: 'Native', message: 'FakeNative ad disposed');
  }
}

class _FakeFullScreen extends LoadedFullScreenAd {
  _FakeFullScreen(this._navigator, this.title, this.placement);
  final GlobalKey<NavigatorState> _navigator;
  final String title;
  final AdPlacement placement;

  @override
  Future<void> show({required VoidCallback onImpression, VoidCallback? onClicked}) async {
    final nav = _navigator.currentState;
    if (nav == null) return;
    AdLogger.i(
      AdState.showing,
      placement: placement,
      adType: 'FullScreen',
      message: 'Showing FakeFullScreen ad: $title',
    );
    onImpression();
    await nav.push(
      PageRouteBuilder<void>(
        opaque: true,
        pageBuilder: (context, _, _) => _FakeAdPage(title: title, onClicked: onClicked, placement: placement),
        transitionsBuilder: (_, a, _, child) => FadeTransition(opacity: a, child: child),
      ),
    );
    AdLogger.i(
      AdState.dismissed,
      placement: placement,
      adType: 'FullScreen',
      message: 'FakeFullScreen ad dismissed: $title',
    );
  }

  @override
  void dispose() {
    AdLogger.d(AdState.disposed, placement: placement, adType: 'FullScreen', message: 'FakeFullScreen ad disposed');
  }
}

class _FakeAdPage extends StatefulWidget {
  const _FakeAdPage({required this.title, this.onClicked, this.placement});
  final String title;
  final VoidCallback? onClicked;
  final AdPlacement? placement;

  @override
  State<_FakeAdPage> createState() => _FakeAdPageState();
}

class _FakeAdPageState extends State<_FakeAdPage> {
  bool _canClose = false;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer(const Duration(seconds: 2), () => mounted ? setState(() => _canClose = true) : null);
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canClose,
      child: Scaffold(
        backgroundColor: const Color(0xFF111327),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.xxl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 240,
                        height: 160,
                        child: MediaArt(seed: 91, icon: Iconsax.video_play_copy, iconSize: 48, radius: AppRadius.lg),
                      ),
                      const SizedBox(height: AppSpace.xl),
                      Text(widget.title, style: context.text.headlineMedium?.copyWith(color: Colors.white)),
                      const SizedBox(height: AppSpace.sm),
                      Text(
                        'Fake ad for previews and tests.',
                        style: context.text.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: AppSpace.xl),
                      GradientButton(
                        label: 'Learn more',
                        onPressed: () {
                          AdLogger.i(
                            AdState.clicked,
                            placement: widget.placement,
                            adType: 'FullScreen',
                            message: 'FakeFullScreen CTA clicked',
                          );
                          widget.onClicked?.call();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              PositionedDirectional(
                top: AppSpace.md,
                end: AppSpace.md,
                child: AnimatedOpacity(
                  duration: AppDurations.fast,
                  opacity: _canClose ? 1 : 0.3,
                  child: IconButton(
                    tooltip: 'Close ad',
                    onPressed: _canClose ? () => Navigator.of(context).pop() : null,
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
