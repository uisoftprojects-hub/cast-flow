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
import 'find_tv_sheet.dart';

/// Slim connection bar at the top of Home. "Not connected" → tap to find a
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
      _BarState.connected => (p.success, conn.device!.name, conn.device!.type.label),
      _BarState.connecting => (p.warning, 'Connecting…', conn.device?.name ?? ''),
      _BarState.searching => (p.primary, 'Finding TVs…', 'Make sure your TV is on'),
      _BarState.failed => conn.error == ConnectionController.networkLost
          ? (p.error, context.l10n.networkLostTitle, context.l10n.tapToReconnect)
          : (p.error, context.l10n.connectionFailed, context.l10n.tapToReconnect),
      _BarState.disconnected => (p.textSecondary, 'Not connected', 'Tap to find your TV'),
    };

    final Widget trailing = switch (state) {
      _BarState.connected => _Pill(
          color: p.success,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 7, height: 7, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))
                  .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                  .fade(begin: 1, end: 0.4, duration: 900.ms),
              const SizedBox(width: 6),
              Text('Connected', style: context.text.labelMedium?.copyWith(color: Colors.white)),
            ],
          ),
        ),
      _BarState.connecting || _BarState.searching => SizedBox.square(
          dimension: 18,
          child: CircularProgressIndicator(strokeWidth: 2.2, color: tone),
        ),
      _ => _Pill(
          color: p.primaryTint,
          child: Text('Connect', style: context.text.labelMedium?.copyWith(color: p.primary)),
        ),
    };

    return Semantics(
      liveRegion: true,
      button: true,
      label: '$title. $subtitle',
      excludeSemantics: true,
      child: TapScale(
        onTap: () => showFindTvSheet(context),
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
                    state == _BarState.searching ? Iconsax.radar_2_copy : (conn.device?.type.icon ?? Iconsax.monitor_copy),
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
              AnimatedSwitcher(duration: AppDurations.medium, child: KeyedSubtree(key: ValueKey(state), child: trailing)),
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
