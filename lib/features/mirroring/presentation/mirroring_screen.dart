import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/selectors.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/domain/network_status.dart';
import '../../home/presentation/media_shortcuts.dart';
import '../../devices/presentation/network_controller.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../devices/presentation/widgets/network_widgets.dart';
import '../../settings/domain/app_settings.dart';
import '../domain/mirroring.dart';
import 'mirroring_controller.dart';

import '../../../core/l10n.dart';

/// Screen mirroring: Start / Stop and its status on top, live details right
/// under it, then plain-text tips and the quality choice, all on one screen.
class MirroringScreen extends ConsumerWidget {
  const MirroringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = ref.watch(mirroringProvider);
    final net = ref.watch(networkProvider);
    final ctrl = ref.read(mirroringProvider.notifier);
    final p = context.palette;
    final l = context.l10n;

    // Came back from Android's cast picker without starting: no device chosen.
    final noDevice = !m.isLive && !m.isBusy && (m.phase == MirrorPhase.error || m.error == mirrorNotStarted);

    return Scaffold(
      appBar: CastAppBar(title: l.screenMirroring),
      // Everything fits one screen: the Start animation takes whatever height
      // the rest of the content leaves, so it is as large as it can be.
      body: LayoutBuilder(
        builder: (context, c) {
          final rest = m.isLive ? 270.0 : (noDevice ? 400.0 : 380.0);
          final startSize = (c.maxHeight - rest - 24).clamp(190.0, 320.0).clamp(0.0, c.maxWidth - 2 * AppSpace.page);
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpace.page, 0, AppSpace.page, AppSpace.lg),
            child: Column(
              children: [
                _StartArea(
                  size: startSize,
                  state: m,
                  onTap: m.isLive
                      ? ctrl.stop
                      : () async {
                          // Mirroring needs Wi-Fi or the phone's hotspot.
                          if (await requireNetwork(context, source: 'mirroring')) ctrl.start();
                        },
                ),
                AnimatedSize(
                  duration: AppDurations.medium,
                  curve: Curves.easeOutCubic,
                  child: m.isLive ? _LiveStatus(state: m) : const SizedBox(width: double.infinity),
                ),
                if (noDevice) ...[
                  const SizedBox(height: AppSpace.md),
                  _NoDevice(message: m.error == mirrorNotStarted ? l.mirroringDidntStartTap : l.openSmartViewOr),
                  const SizedBox(height: AppSpace.lg),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(l.castPhotosVideosMusic, style: context.text.labelLarge),
                  ),
                  const SizedBox(height: 8),
                  const MediaShortcuts(),
                ] else if (!m.isLive) ...[
                  const SizedBox(height: AppSpace.md),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _Tips(network: net),
                  ),
                ],
                const SizedBox(height: AppSpace.md),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(l.quality, style: context.text.labelLarge),
                ),
                const SizedBox(height: 6),
                IgnorePointer(
                  ignoring: m.isLive || m.isBusy,
                  child: Opacity(
                    opacity: m.isLive || m.isBusy ? 0.6 : 1,
                    child: SegmentedPills<MirrorQuality>(
                      values: MirrorQuality.values,
                      selected: m.quality,
                      labelOf: (q) => context.tr(q.label),
                      onChanged: ctrl.setQuality,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    m.quality == MirrorQuality.auto ? l.adjustsToYourWi : l.upToLowerIt(m.quality.label),
                    style: context.text.bodySmall?.copyWith(fontSize: 12),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/guide?topic=mirroring'),
                  icon: Icon(Iconsax.message_question_copy, size: 16, color: p.primary),
                  label: Text(l.stillNeedHelp, style: context.text.labelMedium?.copyWith(color: p.primary)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Status line, the round Start / Stop button and what it is doing.
///
/// The button always animates: a slow ripple invites a tap while ready, a fast
/// ripple with a spinner shows it is starting, a red ripple means live.
class _StartArea extends StatelessWidget {
  const _StartArea({required this.size, required this.state, required this.onTap});

  /// Diameter of the ripple; the button is half of it.
  final double size;
  final MirrorState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    final live = state.isLive;
    final starting = state.phase == MirrorPhase.starting;
    final stopping = state.phase == MirrorPhase.stopping;
    final busy = state.isBusy;
    final color = live ? p.error : p.primary;

    final label = switch (state.phase) {
      MirrorPhase.starting => l.startingScreenMirroring,
      MirrorPhase.live => l.mirroringTo(state.tvName ?? 'TV'),
      MirrorPhase.stopping => l.stopping,
      _ => l.readyToMirror,
    };

    final button = TapScale(
      onTap: busy ? null : onTap,
      semanticLabel: live ? l.stopMirroring : l.startMirroring2,
      child: AnimatedContainer(
        duration: AppDurations.medium,
        width: size * 0.52,
        height: size * 0.52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: live ? LinearGradient(colors: [p.error.withValues(alpha: 0.85), p.error]) : AppColors.mainGradient,
          boxShadow: AppShadows.glow(color),
        ),
        child: Center(
          child: busy
              ? const SizedBox.square(
                  dimension: 38,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.5),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      live ? Iconsax.stop_copy : Iconsax.screenmirroring_copy,
                      color: Colors.white,
                      size: size * 0.17,
                    ),
                    const SizedBox(height: 2),
                    Text(live ? l.stop : l.start, style: context.text.titleSmall?.copyWith(color: Colors.white)),
                  ],
                ),
        ),
      ),
    );

    return Column(
      children: [
        PulseRipple(
          size: size,
          rings: 3,
          // Never still: it invites a tap when ready, and speeds up while starting.
          active: !stopping,
          color: color,
          sweep: starting,
          duration: Duration(milliseconds: starting ? 1100 : (live ? 1800 : 2600)),
          child: button,
        ),
        AnimatedSwitcher(
          duration: AppDurations.medium,
          child: Row(
            key: ValueKey(label),
            mainAxisSize: MainAxisSize.min,
            children: [
              if (live)
                Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    )
                    .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                    .fade(begin: 1, end: 0.2, duration: 700.ms),
              if (live) const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelMedium?.copyWith(color: live ? color : p.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Before you start": plain bullet lines on the screen, no card. The Wi-Fi
/// and VPN lines show a live tick or cross.
class _Tips extends StatelessWidget {
  const _Tips({required this.network});
  final NetworkStatus? network;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    final n = network;
    Widget bullet(String text, bool? ok) => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(color: p.textSecondary, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: context.text.bodySmall?.copyWith(fontSize: 13, color: p.textPrimary)),
          ),
          if (ok != null) ...[
            const SizedBox(width: 6),
            Icon(ok ? Iconsax.tick_circle_copy : Iconsax.close_circle_copy, size: 16, color: ok ? p.success : p.error),
          ],
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.beforeYouStart, style: context.text.labelLarge),
        bullet(l.phoneAndTvAre, n?.ready),
        bullet(l.noVpnIsConnected, n == null ? null : !n.vpn),
        bullet(l.tvIsOnWith, null),
        bullet(l.phoneIsCloseTo, null),
      ],
    );
  }
}

/// Live details in one small row of plain text, right under the button.
class _LiveStatus extends StatelessWidget {
  const _LiveStatus({required this.state});
  final MirrorState state;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    Widget stat(IconData icon, String label, String value) => Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: p.textSecondary),
          const SizedBox(height: 2),
          Text(
            value,
            style: context.text.labelLarge?.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(label, style: context.text.bodySmall?.copyWith(fontSize: 11)),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.md),
      child: Row(
        children: [
          stat(Iconsax.timer_1_copy, l.duration, formatDuration(state.elapsed)),
          stat(Iconsax.monitor_copy, l.tv, state.tvName ?? l.tv),
          stat(Iconsax.setting_4_copy, l.quality, state.quality.label),
        ],
      ),
    ).animate().fadeIn();
  }
}

/// Shown when the Android cast picker was closed without choosing a TV.
class _NoDevice extends StatelessWidget {
  const _NoDevice({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: p.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Iconsax.monitor_copy, size: 20, color: p.warning),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.noTvFound, style: context.text.labelLarge),
                const SizedBox(height: 2),
                Text(message, style: context.text.bodySmall?.copyWith(fontSize: 12.5, color: p.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    ).animate().shakeX(hz: 3, amount: 4, duration: 400.ms);
  }
}
