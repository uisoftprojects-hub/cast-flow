import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/platform/network_channel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/selectors.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/presentation/device_providers.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../settings/domain/app_settings.dart';
import '../domain/mirroring.dart';
import 'mirroring_controller.dart';

class MirroringScreen extends ConsumerWidget {
  const MirroringScreen({super.key});

  /// Screen mirroring runs through the phone's built-in Smart View / Cast,
  /// since Android doesn't let third-party apps start Miracast themselves.
  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final opened = await NetworkChannel.openCastSettings();
    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Open Smart View or Cast from your phone’s quick settings to mirror.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = ref.watch(mirroringProvider);
    final conn = ref.watch(connectionProvider);
    final ctrl = ref.read(mirroringProvider.notifier);

    return Scaffold(
      appBar: const CastAppBar(title: 'Screen Mirroring'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.xxxl),
        children: [
          _Preview(live: m.isLive, deviceName: conn.device?.name),
          const SizedBox(height: AppSpace.xxl),
          if (!conn.isConnected)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.xl),
              child: SoftCard(
                color: context.palette.warning.withValues(alpha: 0.16),
                shadow: false,
                child: Row(
                  children: [
                    IconBubble(icon: Iconsax.info_circle_copy, color: const Color(0xFFD97706), size: 42),
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: Text('Connect to a TV first — we’ll ask when you tap Start.',
                          style: context.text.bodyMedium?.copyWith(color: context.palette.textPrimary)),
                    ),
                  ],
                ),
              ),
            ),
          if (m.phase == MirrorPhase.error)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.xl),
              child: SoftCard(
                color: context.palette.error.withValues(alpha: 0.14),
                shadow: false,
                child: Row(
                  children: [
                    IconBubble(icon: Iconsax.danger_copy, color: context.palette.error, size: 42),
                    const SizedBox(width: AppSpace.md),
                    Expanded(child: Text(m.error ?? 'Mirroring failed.', style: context.text.bodyMedium)),
                    TintedButton(label: 'Retry', compact: true, color: context.palette.error, onPressed: ctrl.start),
                  ],
                ),
              ).animate().shakeX(hz: 3, amount: 4, duration: 400.ms),
            ),
          Text('Quality', style: context.text.titleSmall),
          const SizedBox(height: AppSpace.sm),
          IgnorePointer(
            ignoring: m.isLive,
            child: Opacity(
              opacity: m.isLive ? 0.6 : 1,
              child: SegmentedPills<MirrorQuality>(
                values: MirrorQuality.values,
                selected: m.quality,
                labelOf: (q) => q.label,
                onChanged: ctrl.setQuality,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.md,
            children: [
              ToggleChip(
                label: m.audio ? 'Audio on' : 'Audio off',
                icon: Iconsax.volume_high_copy,
                offIcon: Iconsax.volume_slash_copy,
                value: m.audio,
                onChanged: ctrl.setAudio,
              ),
              ToggleChip(
                label: 'Auto-rotate',
                icon: Iconsax.rotate_right_copy,
                value: m.autoRotate,
                onChanged: ctrl.setAutoRotate,
              ),
            ],
          ),
          const SizedBox(height: AppSpace.xxl),
          Center(child: _StartButton(state: m, onTap: () => _toggle(context, ref))),
          const SizedBox(height: AppSpace.lg),
          AnimatedSize(
            duration: AppDurations.medium,
            curve: Curves.easeOutCubic,
            child: m.isLive ? _LiveStatus(state: m, deviceName: conn.device?.name ?? '') : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.live, required this.deviceName});
  final bool live;
  final String? deviceName;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget screen(double w, double h, double r) => AnimatedContainer(
          duration: AppDurations.slow,
          width: w,
          height: h,
          decoration: BoxDecoration(
            gradient: live ? AppColors.mainGradient : null,
            color: live ? null : p.surfaceHigh,
            borderRadius: BorderRadius.circular(r),
          ),
          child: live
              ? GridView.count(
                  crossAxisCount: 3,
                  padding: EdgeInsets.all(w * 0.12),
                  mainAxisSpacing: w * 0.08,
                  crossAxisSpacing: w * 0.08,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    9,
                    (i) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.35 + (i % 3) * 0.15),
                        borderRadius: BorderRadius.circular(w * 0.06),
                      ),
                    ),
                  ),
                )
              : Icon(Iconsax.mobile_copy, color: p.textSecondary, size: w * 0.3),
        );

    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xxl, horizontal: AppSpace.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Phone
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: p.textPrimary.withValues(alpha: context.isDark ? 0.3 : 0.9),
              borderRadius: BorderRadius.circular(22),
            ),
            child: screen(78, 150, 18),
          ),
          // Waves
          Column(
            children: [
              Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: live
                          ? Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                            )
                              .animate(onPlay: (c) => context.loopMotion(c, reverse: true), delay: (200 * i).ms)
                              .fade(begin: 1, end: 0.25, duration: 600.ms)
                          : Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(color: p.divider, shape: BoxShape.circle),
                            ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(live ? 'Live' : 'Ready', style: context.text.labelSmall?.copyWith(color: live ? p.primary : null)),
            ],
          ),
          // TV
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: p.textPrimary.withValues(alpha: context.isDark ? 0.3 : 0.9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: live
                    ? screen(120, 72, 10)
                    : Container(
                        width: 120,
                        height: 72,
                        decoration: BoxDecoration(color: p.surfaceHigh, borderRadius: BorderRadius.circular(10)),
                        child: Icon(Iconsax.monitor_copy, color: p.textSecondary, size: 28),
                      ),
              ),
              const SizedBox(height: 6),
              Container(width: 40, height: 5, decoration: BoxDecoration(color: p.divider, borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 8),
              SizedBox(
                width: 130,
                child: Text(
                  deviceName ?? 'No TV',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.state, required this.onTap});
  final MirrorState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final live = state.isLive;
    final busy = state.isBusy;
    final button = TapScale(
      onTap: busy ? null : onTap,
      semanticLabel: live ? 'Stop mirroring' : 'Start mirroring',
      child: AnimatedContainer(
        duration: AppDurations.medium,
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: live
              ? LinearGradient(colors: [p.error.withValues(alpha: 0.85), p.error])
              : AppColors.mainGradient,
          boxShadow: AppShadows.glow(live ? p.error : AppColors.primary),
        ),
        child: Center(
          child: busy
              ? const SizedBox.square(
                  dimension: 34,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(live ? Iconsax.stop_copy : Iconsax.screenmirroring_copy, color: Colors.white, size: 34),
                    const SizedBox(height: 4),
                    Text(live ? 'Stop' : 'Start',
                        style: context.text.labelMedium?.copyWith(color: Colors.white)),
                  ],
                ),
        ),
      ),
    );
    return PulseRipple(
      size: 220,
      active: live || busy,
      color: live ? p.error : p.primary,
      duration: const Duration(milliseconds: 1800),
      child: button,
    );
  }
}

class _LiveStatus extends StatelessWidget {
  const _LiveStatus({required this.state, required this.deviceName});
  final MirrorState state;
  final String deviceName;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final ms = state.latencyMs;
    final (Color latencyColor, String latencyLabel) =
        ms < 70 ? (p.success, 'Excellent') : ms < 100 ? (p.warning, 'Good') : (p.error, 'Laggy');

    Widget stat(IconData icon, String label, String value, Color color) => Expanded(
          child: Column(
            children: [
              IconBubble(icon: icon, color: color, size: 40),
              const SizedBox(height: 8),
              Text(value, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(label, style: context.text.bodySmall),
            ],
          ),
        );

    return SoftCard(
      child: Row(
        children: [
          stat(Iconsax.timer_1_copy, 'Duration', formatDuration(state.elapsed), p.primary),
          stat(Iconsax.monitor_copy, 'Device', deviceName, const Color(0xFF12B886)),
          stat(Iconsax.flash_1_copy, latencyLabel, '$ms ms', latencyColor),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}
