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
class NativeAdSlot extends ConsumerStatefulWidget {
  const NativeAdSlot({super.key, required this.placement});

  final AdPlacement placement;

  @override
  ConsumerState<NativeAdSlot> createState() => _NativeAdSlotState();
}

class _NativeAdSlotState extends ConsumerState<NativeAdSlot> {
  LoadedNativeAd? _ad;
  bool _finished = false;

  /// Longest the placeholder shimmer may show before the slot hides itself.
  static const _loadLimit = Duration(seconds: 10);

  double get _height =>
      widget.placement == AdPlacement.onboarding ? AdMobConfig.nativeMediumHeight : AdMobConfig.nativeMediumHeight;

  final int _generation = 0;

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The slot's own Theme is the truth for what the user sees (not the OS theme),
    // so ads are requested with, and re-coloured to, the on-screen brightness.
    AdMobConfig.syncNativeTheme(Theme.of(context).brightness == Brightness.dark);
    if (!_started) {
      _started = true;
      _fetchAd();
    }
  }

  Future<void> _fetchAd() async {
    final gen = _generation;
    final isPremium = ref.read(isPremiumProvider);
    if (isPremium) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: widget.placement,
        adType: 'Native',
        message: 'NativeAdSlot fetch skipped: premium user protected.',
      );
      if (mounted) setState(() => _finished = true);
      return;
    }

    AdLogger.i(
      AdState.requestLoading,
      placement: widget.placement,
      adType: 'Native',
      message: 'NativeAdSlot requesting native ad for display.',
    );

    final nativeMgr = ref.read(nativeAdManagerProvider);
    LoadedNativeAd? ad;
    try {
      final Future<LoadedNativeAd?> request;
      if (widget.placement == AdPlacement.onboarding) {
        request = nativeMgr.getOrLoadOnboardingAd(isPremium: isPremium);
      } else if (widget.placement == AdPlacement.languageFirstRun) {
        request = nativeMgr.getOrLoadLanguageAd(isPremium: isPremium, fromSettings: false);
      } else if (widget.placement == AdPlacement.languageSettings) {
        request = nativeMgr.getOrLoadLanguageAd(isPremium: isPremium, fromSettings: true);
      } else {
        request = ref.read(adManagerProvider.notifier).loadNative(widget.placement);
      }
      // Never shimmer forever: no ad within the limit (or any error) hides the slot.
      ad = await request.timeout(_loadLimit);
    } catch (e) {
      AdLogger.w(
        AdState.loadFailed,
        placement: widget.placement,
        adType: 'Native',
        message: 'NativeAdSlot failed or timed out: $e',
      );
      ad = null;
    }

    if (!mounted || gen != _generation) {
      if (widget.placement != AdPlacement.onboarding) {
        ad?.dispose();
      }
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
    final hidden = isPremium || (_finished && _ad == null);

    return AnimatedSize(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
      child: hidden
          ? const SizedBox.shrink()
          : Padding(
              // Small gap between the screen content and the ad.
              padding: const EdgeInsets.only(top: AppSpace.sm),
              child: SizedBox(
              height: _height,
              width: double.infinity,
              child:
                  _ad?.build(context) ??
                  Container(
                    height: _height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.palette.surface,
                      borderRadius: BorderRadius.zero,
                      border: Border.all(color: context.palette.divider),
                    ),
                    padding: const EdgeInsets.all(AppSpace.md),
                    child: const SoftShimmer(
                      child: ShimmerBox(height: double.infinity, radius: AppRadius.sm),
                    ),
                  ),
            ),
          ),
    );
  }
}
