import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/tap_scale.dart';
import '../../domain/cast_device.dart';
import '../device_providers.dart';

/// "Not connected" / "Connected to Samsung TV" status pill. Shown on every
/// screen; tapping it opens the device picker.
class ConnectionChip extends ConsumerWidget {
  const ConnectionChip({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conn = ref.watch(connectionProvider);
    final p = context.palette;

    final (Color color, String label) = switch (conn.status) {
      ConnectionStatus.connected => (p.success, compact ? conn.device!.name : 'Connected to ${conn.device!.name}'),
      ConnectionStatus.connecting => (p.warning, 'Connecting…'),
      ConnectionStatus.failed => (p.error, 'Connection failed'),
      ConnectionStatus.disconnected => (p.textSecondary, 'Not connected'),
    };

    final dot = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    return Semantics(
      liveRegion: true,
      label: '$label. Tap to manage devices',
      child: TapScale(
        onTap: () => context.push('/connect'),
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
              if (conn.isConnecting || conn.isConnected)
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
                  style: context.text.labelMedium?.copyWith(
                    color: conn.isConnected ? p.textPrimary : p.textSecondary,
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

const _tabRoots = {'/home', '/devices', '/history', '/settings'};

/// Standard top bar for pushed screens: back button, title and the
/// connection chip so the connection state is always visible.
class CastAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CastAppBar({super.key, required this.title, this.actions = const [], this.showChip = true, this.bottom});

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
      automaticallyImplyLeading: false,
      titleSpacing: showBack ? 0 : AppSpace.page,
      leading: showBack
          ? Padding(
              padding: const EdgeInsetsDirectional.only(start: 12),
              child: Center(
                child: SoftIconButton(
                  icon: Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 44,
                  tooltip: 'Back',
                  onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                ),
              ),
            )
          : null,
      leadingWidth: showBack ? 68 : null,
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        ...actions,
        if (showChip)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpace.page, start: AppSpace.sm),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 170),
                child: const ConnectionChip(compact: true),
              ),
            ),
          ),
      ],
      bottom: bottom,
    );
  }
}
