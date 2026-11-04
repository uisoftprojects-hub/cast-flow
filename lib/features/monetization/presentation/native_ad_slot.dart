import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/state_views.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/ad_adapter.dart';
import '../domain/ad_config.dart';
import '../domain/ad_models.dart';
import 'ad_manager.dart';

import '../../../core/l10n.dart';

/// Reserved, clearly labelled space for a screen-scoped native ad. Requests
/// the ad when the screen mounts and disposes it when the screen is left.
/// Collapses if there is no fill so no empty hole is left behind.
class NativeAdSlot extends ConsumerStatefulWidget {
  const NativeAdSlot({super.key, required this.placement});

  final AdPlacement placement;

  @override
  ConsumerState<NativeAdSlot> createState() => _NativeAdSlotState();
}

class _NativeAdSlotState extends ConsumerState<NativeAdSlot> {
  LoadedNativeAd? _ad;
  bool _finished = false;
  late final AdManager _manager = ref.read(adManagerProvider.notifier);

  double get _height =>
      widget.placement == AdPlacement.onboarding ? AdConfig.nativeSmallHeight : AdConfig.nativeMediumHeight;

  @override
  void initState() {
    super.initState();
    _manager.loadNative(widget.placement).then((ad) {
      if (!mounted) return _manager.releaseNative(widget.placement, ad);
      setState(() {
        _ad = ad;
        _finished = true;
      });
    });
  }

  @override
  void dispose() {
    _manager.releaseNative(widget.placement, _ad);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premium = ref.watch(settingsProvider.select((s) => s.isPremium));
    final p = context.palette;
    final hidden = premium || (_finished && _ad == null);

    return AnimatedSize(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
      child: hidden
          ? const SizedBox(width: double.infinity)
          : Container(
              height: _height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: p.divider),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child:
                        _ad?.build(context) ??
                        const Padding(
                          padding: EdgeInsets.all(AppSpace.md),
                          child: SoftShimmer(
                            child: ShimmerBox(height: double.infinity, radius: AppRadius.sm),
                          ),
                        ),
                  ),
                  PositionedDirectional(
                    top: 6,
                    start: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        context.l10n.ad,
                        style: context.text.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
