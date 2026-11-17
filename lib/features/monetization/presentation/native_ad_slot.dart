import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/state_views.dart';
import '../../premium/domain/premium_status_service.dart';
import '../domain/ad_adapter.dart';
import '../domain/ad_config.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';
import 'ad_manager.dart';
import 'native_ad_manager.dart';

/// Screen-scoped native ad slot.
/// Integrates with [NativeAdManager] to leverage preloaded ads and single-instance onboarding ad.
/// Zero horizontal screen padding, full width, and collapses cleanly if no ad fill so no empty hole remains.
///
/// The ad is requested when the slot first appears (the user landing on the
/// screen). [onSettled] fires once the request is over (loaded, no fill or
/// timeout) so the screen can drop its loading overlay. A no-fill gets one
/// automatic re-request within the same [loadLimit].
class NativeAdSlot extends ConsumerStatefulWidget {
  const NativeAdSlot({
    super.key,
    required this.placement,
    this.onSettled,
    this.loadLimit = const Duration(seconds: 6),
  });

  final AdPlacement placement;

  /// Called when the initial request finishes; `true` if an ad is showing.
  final ValueChanged<bool>? onSettled;

  /// Longest the slot waits for an ad (including the one retry).
  final Duration loadLimit;

  @override
  ConsumerState<NativeAdSlot> createState() => NativeAdSlotState();
}

class NativeAdSlotState extends ConsumerState<NativeAdSlot> {
  LoadedNativeAd? _ad;
  bool _finished = false;
  bool _started = false;
  Future<void>? _initial;

  /// Height the native view says it needs (title / description / CTA), at the
  /// width it was measured for. Until known, a safe estimate is used.
  double? _measured;
  String? _measureKey;

  /// Keeps the one AdWidget in place across rebuilds / re-layouts so the ad is never
  /// mounted twice ("AdWidget is already in the widget tree").
  final _adHostKey = GlobalKey();

  bool get hasAd => _ad != null;

  /// The landing request is over (ad, no fill or timeout).
  bool get settled => _finished;

  /// Grows with the user's font size so the title / CTA are never cut off.
  double _height(BuildContext context) =>
      _measured ??
      AdMobConfig.nativeHeightFor(MediaQuery.textScalerOf(context).scale(1));

  /// Asks the native view for its real height once it is on screen (it is created
  /// when the platform view builds, so poll briefly), then resizes the container.
  Future<void> _measure(double width, String key) async {
    for (var i = 0; i < 12; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      final ad = _ad;
      if (!mounted || ad == null || _measureKey != key) return;
      final h = await ad.measuredHeight(width);
      if (!mounted || _measureKey != key) return;
      if (h != null && h > 0) {
        // Floor keeps the icon a decent size next to very short text.
        setState(() => _measured = h < 96 ? 96 : h.ceilToDouble());
        return;
      }
    }
  }

  void _scheduleMeasure(double width) {
    if (_ad == null || width <= 0 || !width.isFinite) return;
    final key = '${width.round()}|${MediaQuery.textScalerOf(context).scale(1)}';
    if (key == _measureKey) return;
    _measureKey = key;
    _measure(width, key);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The slot's own Theme is the truth for what the user sees (not the OS theme),
    // so ads are requested with, and re-coloured to, the on-screen brightness.
    AdMobConfig.syncNativeTheme(
      Theme.of(context).brightness == Brightness.dark,
    );
    if (!_started) {
      _started = true;
      _initial = _fetchAd();
    }
  }

  Future<LoadedNativeAd?> _request() {
    final isPremium = ref.read(isPremiumProvider);
    final nativeMgr = ref.read(nativeAdManagerProvider);
    switch (widget.placement) {
      case AdPlacement.onboarding:
        return nativeMgr.getOrLoadOnboardingAd(isPremium: isPremium);
      case AdPlacement.languageFirstRun:
        return nativeMgr.getOrLoadLanguageAd(
          isPremium: isPremium,
          fromSettings: false,
        );
      case AdPlacement.languageSettings:
        return nativeMgr.getOrLoadLanguageAd(
          isPremium: isPremium,
          fromSettings: true,
        );
      default:
        return ref
            .read(adManagerProvider.notifier)
            .loadNative(widget.placement);
    }
  }

  /// One request, plus one re-request if it came back empty before [limit] ran out.
  Future<LoadedNativeAd?> _loadWithRetry(
    Duration limit, {
    int maxAttempts = 1,
  }) async {
    final watch = Stopwatch()..start();
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final left = limit - watch.elapsed;
      if (left <= Duration.zero) break;
      try {
        final ad = await _request().timeout(left);
        if (ad != null) return ad;
      } catch (e) {
        AdLogger.w(
          AdState.loadFailed,
          placement: widget.placement,
          adType: 'Native',
          message:
              'NativeAdSlot attempt ${attempt + 1} failed or timed out: $e',
        );
      }
      // Don't hammer the ad server: brief pause before the single retry.
      if (attempt == 0 && watch.elapsed < limit - const Duration(seconds: 1)) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
    }
    return null;
  }

  Future<void> _fetchAd() async {
    if (ref.read(isPremiumProvider)) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: widget.placement,
        adType: 'Native',
        message: 'NativeAdSlot fetch skipped: premium user protected.',
      );
      if (mounted) setState(() => _finished = true);
      widget.onSettled?.call(false);
      return;
    }

    AdLogger.i(
      AdState.requestLoading,
      placement: widget.placement,
      adType: 'Native',
      message: 'NativeAdSlot requesting native ad on screen landing.',
    );

    final ad = await _loadWithRetry(
      widget.loadLimit,
    ); // no fill = final: no retry
    _settle(ad);
    widget.onSettled?.call(_ad != null);
  }

  /// Makes sure an ad is showing: waits for the landing request if it is still in
  /// flight, otherwise re-requests once. Total wait is capped at [limit].
  Future<bool> ensureLoaded({
    Duration limit = const Duration(seconds: 6),
  }) async {
    if (_ad != null) return true;
    final watch = Stopwatch()..start();
    final initial = _initial;
    if (initial != null) {
      try {
        await initial.timeout(limit);
      } catch (_) {}
    }
    if (_ad != null) return true;
    final left = limit - watch.elapsed;
    if (left < const Duration(seconds: 1)) return false;
    return retry(limit: left);
  }

  /// Re-requests the ad (e.g. "Get Started" tapped while there was still no ad).
  /// Resolves to whether an ad is now showing.
  Future<bool> retry({Duration limit = const Duration(seconds: 6)}) async {
    if (_ad != null) return true;
    if (mounted) setState(() => _finished = false);
    final ad = await _loadWithRetry(limit);
    _settle(ad);
    return _ad != null;
  }

  void _settle(LoadedNativeAd? ad) {
    if (!mounted) {
      if (widget.placement != AdPlacement.onboarding) ad?.dispose();
      return;
    }
    if (ad != null) {
      AdLogger.i(
        AdState.showing,
        placement: widget.placement,
        adType: 'Native',
        message: 'NativeAdSlot rendering ad in widget tree.',
      );
    } else {
      AdLogger.w(
        AdState.noFill,
        placement: widget.placement,
        adType: 'Native',
        message: 'NativeAdSlot received no ad; collapsing slot cleanly.',
      );
    }
    setState(() {
      _ad = ad;
      _finished = true;
    });
  }

  @override
  void dispose() {
    // For onboarding, the single instance is retained until onboarding is finished
    if (widget.placement != AdPlacement.onboarding) {
      AdLogger.d(
        AdState.disposed,
        placement: widget.placement,
        adType: 'Native',
        message: 'NativeAdSlot disposed; releasing ad.',
      );
      _ad?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);
    final height = _height(context);
    final hidden = isPremium || (_finished && _ad == null);

    return AnimatedSize(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
      child: hidden
          ? const SizedBox.shrink()
          : Padding(
              // Small gap between the screen content and the ad.
              padding: const EdgeInsets.only(top: AppSpace.sm),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _scheduleMeasure(constraints.maxWidth);
                  return SizedBox(
                    height: height,
                    width: double.infinity,
                    child:
                        (_ad == null
                            ? null
                            : KeyedSubtree(
                                key: _adHostKey,
                                child: _ad!.build(context),
                              )) ??
                        Container(
                          height: height,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.palette.surface,
                            borderRadius: BorderRadius.zero,
                            border: Border.all(color: context.palette.divider),
                          ),
                          padding: const EdgeInsets.all(AppSpace.md),
                          child: const SoftShimmer(
                            child: ShimmerBox(
                              height: double.infinity,
                              radius: AppRadius.sm,
                            ),
                          ),
                        ),
                  );
                },
              ),
            ),
    );
  }
}
