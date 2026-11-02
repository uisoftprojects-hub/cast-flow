import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../domain/ad_adapter.dart';
import '../domain/ad_models.dart';

/// Simulated ad network for previews (web, desktop) and tests. Follows the
/// current [PreviewMode]: "Error states" makes every load fail (no fill).
class FakeAdAdapter implements AdAdapter {
  FakeAdAdapter(this._navigator, this._mode);

  final GlobalKey<NavigatorState> _navigator;
  final PreviewMode Function() _mode;

  Future<void> _load(Duration d) async {
    await Future<void>.delayed(d);
    if (_mode() != PreviewMode.live) throw const FakeServiceException('No fill (preview mode)');
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> canRequestAds() async => true;

  @override
  Future<LoadedNativeAd> loadNative(
    AdPlacement placement, {
    required bool medium,
    required VoidCallback onImpression,
    required VoidCallback onClicked,
  }) async {
    await _load(const Duration(milliseconds: 900));
    return _FakeNative(medium, onImpression, onClicked);
  }

  @override
  Future<LoadedFullScreenAd> loadInterstitial() async {
    await _load(const Duration(milliseconds: 1500));
    return _FakeFullScreen(_navigator, 'Test interstitial');
  }

  @override
  Future<LoadedFullScreenAd> loadAppOpen() async {
    await _load(const Duration(milliseconds: 1200));
    return _FakeFullScreen(_navigator, 'Test App Open ad');
  }
}

class _FakeNative extends LoadedNativeAd {
  _FakeNative(this.medium, this.onImpression, this.onClicked);
  final bool medium;
  final VoidCallback onImpression;
  final VoidCallback onClicked;
  bool _impressed = false;

  @override
  Widget build(BuildContext context) {
    if (!_impressed) {
      _impressed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => onImpression());
    }
    final row = Row(
      children: [
        const SizedBox.square(dimension: 44, child: MediaArt(seed: 77, icon: Iconsax.star_1_copy, iconSize: 18)),
        const SizedBox(width: AppSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sample advertiser', style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text('Test native ad · ${medium ? 'medium' : 'small'}',
                  style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        TintedButton(label: 'Open', compact: true, onPressed: onClicked),
      ],
    );
    if (!medium) return Padding(padding: const EdgeInsets.all(AppSpace.md), child: row);
    return Padding(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Column(
        children: [
          const Expanded(child: MediaArt(seed: 78, icon: Iconsax.image_copy, iconSize: 32)),
          const SizedBox(height: AppSpace.md),
          row,
        ],
      ),
    );
  }

  @override
  void dispose() {}
}

class _FakeFullScreen extends LoadedFullScreenAd {
  _FakeFullScreen(this._navigator, this.title);
  final GlobalKey<NavigatorState> _navigator;
  final String title;

  @override
  Future<void> show({required VoidCallback onImpression, VoidCallback? onClicked}) async {
    final nav = _navigator.currentState;
    if (nav == null) return;
    onImpression();
    await nav.push(
      PageRouteBuilder<void>(
        opaque: true,
        pageBuilder: (context, _, _) => _FakeAdPage(title: title, onClicked: onClicked),
        transitionsBuilder: (_, a, _, child) => FadeTransition(opacity: a, child: child),
      ),
    );
  }

  @override
  void dispose() {}
}

class _FakeAdPage extends StatefulWidget {
  const _FakeAdPage({required this.title, this.onClicked});
  final String title;
  final VoidCallback? onClicked;

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
                      Text('Fake ad for previews and tests.',
                          style: context.text.bodyMedium?.copyWith(color: Colors.white70)),
                      const SizedBox(height: AppSpace.xl),
                      GradientButton(label: 'Learn more', onPressed: widget.onClicked),
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
