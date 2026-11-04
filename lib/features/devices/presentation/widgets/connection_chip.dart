import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/tap_scale.dart';
import '../../domain/cast_device.dart';
import '../device_providers.dart';
import 'network_widgets.dart';

import '../../../../core/l10n.dart';

/// "Not connected" / "Connected to Samsung TV" status pill. Shown on every
/// screen; tapping it opens the device picker.
class ConnectionChip extends ConsumerWidget {
  const ConnectionChip({super.key, this.compact = false, this.icon = false, this.iconOnly = false});

  final bool compact;

  /// Just a round TV button coloured by the status (no text). Used in app bars
  /// so the title and other buttons keep their full width.
  final bool iconOnly;

  /// Show a TV icon in front of the status instead of the status dot.
  final bool icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conn = ref.watch(connectionProvider);
    final p = context.palette;

    final (Color color, String label) = switch (conn.status) {
      ConnectionStatus.connected => (
        p.success,
        compact ? conn.device!.name : context.l10n.connectedTo(conn.device!.name),
      ),
      ConnectionStatus.connecting => (p.warning, context.l10n.connecting),
      ConnectionStatus.failed => (p.error, context.l10n.connectionFailed2),
      ConnectionStatus.disconnected => (p.textSecondary, context.l10n.notConnected),
    };

    final dot = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    Future<void> open() async {
      if (await requireNetwork(context, source: 'connection_chip') && context.mounted) context.push('/connect');
    }

    if (iconOnly) {
      return Semantics(
        liveRegion: true,
        button: true,
        label: context.l10n.tapToManageDevices(label),
        excludeSemantics: true,
        child: Tooltip(
          message: label,
          child: TapScale(
            onTap: open,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: p.surface, shape: BoxShape.circle, boxShadow: AppShadows.soft(p)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Iconsax.monitor_copy, size: 20, color: color),
                  PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: p.surface, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      liveRegion: true,
      label: context.l10n.tapToManageDevices(label),
      child: TapScale(
        onTap: open,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 14, 8),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: AppShadows.soft(p),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon)
                Icon(Iconsax.monitor_copy, size: 18, color: color)
              else if (conn.isConnecting || conn.isConnected)
                dot
                    .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                    .fade(begin: 1, end: 0.35, duration: 900.ms)
              else
                dot,
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelMedium?.copyWith(color: conn.isConnected ? p.textPrimary : p.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _tabRoots = {'/home', '/devices', '/history', '/settings'};

/// Standard top bar for pushed screens: back button, title and the
/// connection chip so the connection state is always visible.
class CastAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CastAppBar({super.key, required this.title, this.actions = const [], this.showChip = false, this.bottom});

  final String title;
  final List<Widget> actions;
  final bool showChip;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(68 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    // Tab roots have no back button. Any other screen gets one, falling back
    // to Home when it was opened directly (deep link) with nothing to pop.
    final path = GoRouterState.of(context).uri.path;
    final showBack = context.canPop() || !_tabRoots.contains(path);
    return AppBar(
      toolbarHeight: 68,
      // Lets the round buttons' shadows show instead of being cut off square.
      clipBehavior: Clip.none,
      automaticallyImplyLeading: false,
      titleSpacing: showBack ? 0 : AppSpace.page,
      leading: showBack
          ? Padding(
              padding: const EdgeInsetsDirectional.only(start: 12),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Directionality.of(context) == TextDirection.rtl ? Iconsax.arrow_right_copy : Iconsax.arrow_left_copy,
                    size: 26,
                  ),
                  tooltip: context.l10n.browserBack,
                  onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                ),
              ),
            )
          : null,
      leadingWidth: showBack ? 68 : null,
      // The whole title always shows: it scales down a little instead of being cut.
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: Text(title, maxLines: 1),
      ),
      actions: [
        ...actions,
        if (showChip)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpace.page, start: AppSpace.sm),
            child: const Center(child: ConnectionChip(compact: true, iconOnly: true)),
          ),
      ],
      bottom: bottom,
    );
  }
}
