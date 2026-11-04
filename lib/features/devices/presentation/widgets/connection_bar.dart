import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/effects.dart';
import '../../../../core/widgets/tap_scale.dart';
import '../../domain/cast_device.dart';
import '../../../../core/l10n.dart';
import '../device_providers.dart';
import 'network_widgets.dart';
import 'find_tv_sheet.dart';

/// Slim connection bar on Home: TV on the left, its status (Not connected /
/// Connecting / Connected) on the right. Tap to find a
/// TV (radar sheet) → shows the TV name with "Connected" on the right.
class ConnectionBar extends ConsumerWidget {
  const ConnectionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conn = ref.watch(connectionProvider);
    final scanning = ref.watch(discoveryProvider.select((d) => d.scanning));
    final p = context.palette;

    final state = switch (conn.status) {
      ConnectionStatus.connected => _BarState.connected,
      ConnectionStatus.connecting => _BarState.connecting,
      _ when scanning => _BarState.searching,
      ConnectionStatus.failed => _BarState.failed,
      _ => _BarState.disconnected,
    };

    final (Color tone, String title, String subtitle) = switch (state) {
      _BarState.connected => (p.success, conn.device!.name, context.tr(conn.device!.type.label)),
      _BarState.connecting => (p.warning, conn.device?.name ?? context.l10n.yourTv, context.l10n.connecting),
      _BarState.searching => (p.primary, context.l10n.yourTv, context.l10n.makeSureYourTv),
      _BarState.failed =>
        conn.error == ConnectionController.networkLost
            ? (p.error, conn.device?.name ?? context.l10n.yourTv, context.l10n.networkLostTitle)
            : (p.error, conn.device?.name ?? context.l10n.yourTv, context.l10n.connectionFailed),
      _BarState.disconnected => (p.textSecondary, context.l10n.yourTv, context.l10n.tapToFindYour),
    };

    // Status always sits on the right edge of the bar.
    final Widget trailing = switch (state) {
      _BarState.connected => _Pill(
        color: p.success,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ).animate(onPlay: (c) => context.loopMotion(c, reverse: true)).fade(begin: 1, end: 0.4, duration: 900.ms),
            const SizedBox(width: 6),
            Text(context.l10n.connected, style: context.text.labelMedium?.copyWith(color: Colors.white)),
          ],
        ),
      ),
      _BarState.connecting || _BarState.searching => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2, color: tone)),
          const SizedBox(width: 6),
          Text(
            state == _BarState.connecting ? context.l10n.connecting : context.l10n.findingTvs,
            style: context.text.labelMedium?.copyWith(color: tone),
          ),
        ],
      ),
      _ => _Pill(
        color: tone.withValues(alpha: 0.14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              state == _BarState.failed ? context.l10n.connectionFailed : context.l10n.notConnected,
              style: context.text.labelMedium?.copyWith(color: tone),
            ),
          ],
        ),
      ),
    };

    return Semantics(
      liveRegion: true,
      button: true,
      label: '$title. $subtitle',
      excludeSemantics: true,
      child: TapScale(
        onTap: () async {
          if (await requireNetwork(context, source: 'connection_bar') && context.mounted) showFindTvSheet(context);
        },
        child: AnimatedContainer(
          duration: AppDurations.medium,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 12, 8),
          decoration: BoxDecoration(
            color: state == _BarState.connected ? p.success.withValues(alpha: context.isDark ? 0.14 : 0.08) : p.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: state == _BarState.connected ? p.success.withValues(alpha: 0.4) : p.divider),
          ),
          child: Row(
            children: [
              // Mini radar while searching; device icon otherwise.
              PulseRipple(
                size: 40,
                rings: 2,
                active: state == _BarState.searching || state == _BarState.connecting,
                color: tone,
                duration: const Duration(milliseconds: 1400),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tone.withValues(alpha: state == _BarState.connected ? 1 : 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    state == _BarState.searching
                        ? Iconsax.radar_2_copy
                        : (conn.device?.type.icon ?? Iconsax.monitor_copy),
                    size: 17,
                    color: state == _BarState.connected ? Colors.white : tone,
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppDurations.medium,
                  child: Column(
                    key: ValueKey('$state$title'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(subtitle, style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              AnimatedSwitcher(
                duration: AppDurations.medium,
                child: KeyedSubtree(key: ValueKey(state), child: trailing),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _BarState { disconnected, searching, connecting, connected, failed }

class _Pill extends StatelessWidget {
  const _Pill({required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.pill)),
    child: child,
  );
}
