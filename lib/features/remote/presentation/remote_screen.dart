import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/domain/cast_device.dart';
import '../../devices/domain/receiver_capabilities.dart';
import '../../devices/presentation/device_providers.dart';
import '../../devices/presentation/widgets/network_widgets.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../mirroring/presentation/mirroring_controller.dart';
import '../../player/presentation/player_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';
import 'remote_controller.dart';

import '../../../core/l10n.dart';

/// Dedicated TV remote. Buttons follow the connected receiver's capability
/// matrix; unsupported ones are disabled rather than pretending to work.
/// Shown when no TV is connected: every button looks available and leads
/// to device discovery.
const _noTv = CastDevice(id: '_none', name: 'TV', type: DeviceType.smartTv, address: '');

class RemoteScreen extends ConsumerWidget {
  const RemoteScreen({super.key});

  Future<void> _disconnect(BuildContext context, WidgetRef ref) async {
    final active = ref.read(playerProvider).isActive || ref.read(mirroringProvider).isLive;
    if (active) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.disconnectFromTv),
          content: Text(context.l10n.thisStopsWhatIs),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.cancel)),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.disconnect, style: TextStyle(color: context.palette.error)),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    await ref.read(mirroringProvider.notifier).stop();
    await ref.read(connectionProvider.notifier).disconnect();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(connectionProvider.select((c) => c.isConnected ? c.device : null));
    ref.listen(remoteProvider.select((s) => s.error), (_, error) {
      if (error != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    });

    // Without a TV the full remote is still shown; any button opens device
    // discovery so the user can connect, then comes back here.
    final connected = device != null;
    final shown = device ?? _noTv;
    final layout = ref.watch(settingsProvider.select((s) => s.remoteLayout));
    final Future<void> Function(RemoteCommand) send = connected
        ? ref.read(remoteProvider.notifier).send
        : (_) => _chooseDevice(context);
    final missing = RemoteCommand.values.length - shown.capabilities.length;

    final dpad = layout == RemoteLayout.dpad;

    // Single, non-scrolling screen: fixed rows top and bottom, and the D-pad /
    // touchpad scales to whatever height is left.
    return Scaffold(
      appBar: CastAppBar(
        title: context.l10n.tvRemote,
        showChip: false,
        actions: [
          SoftIconButton(
            icon: dpad ? Iconsax.finger_scan_copy : Iconsax.element_3_copy,
            tooltip: dpad ? context.l10n.useTouchpad : context.l10n.useDPad,
            size: 44,
            onPressed: () =>
                ref.read(settingsProvider.notifier).setRemoteLayout(dpad ? RemoteLayout.touchpad : RemoteLayout.dpad),
          ),
          if (connected) ...[
            const SizedBox(width: AppSpace.sm),
            SoftIconButton(
              icon: Iconsax.logout_copy,
              tooltip: context.l10n.disconnect,
              size: 44,
              color: context.palette.error,
              onPressed: () => _disconnect(context, ref),
            ),
          ],
          const SizedBox(width: AppSpace.page),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.page, 0, AppSpace.page, AppSpace.md),
          child: Column(
            children: [
              _LcdPanel(device: shown, connected: connected),
              if (connected && missing > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    device.capabilities.isEmpty
                        ? context.l10n.receiversDontAcceptRemote(device.type.label)
                        : context.l10n.someButtonsAreUnavailable(device.type.label),
                    textAlign: TextAlign.center,
                    style: context.text.bodySmall,
                  ),
                ),
              const SizedBox(height: AppSpace.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _KeyButton(
                    shown,
                    RemoteCommand.back,
                    Iconsax.arrow_left_copy,
                    send,
                    label: context.l10n.browserBack,
                    size: 48,
                  ),
                  _KeyButton(shown, RemoteCommand.home, Iconsax.home_2_copy, send, label: context.l10n.home, size: 48),
                  _KeyButton(shown, RemoteCommand.menu, Iconsax.menu_copy, send, label: context.l10n.menu, size: 48),
                  _KeyButton(
                    shown,
                    RemoteCommand.input,
                    Iconsax.import_1_copy,
                    send,
                    label: context.l10n.input,
                    size: 48,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.sm),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AnimatedSwitcher(
                      duration: AppDurations.medium,
                      child: dpad
                          ? _DPad(key: const ValueKey('dpad'), device: shown, send: send)
                          : SizedBox(
                              key: const ValueKey('pad'),
                              width: 330,
                              child: _Touchpad(device: shown, send: send),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.sm),
              _PlaybackRow(device: shown, send: send),
              const SizedBox(height: AppSpace.md),
              _VolumeRow(device: shown, send: send),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact display: current media / last action, playback state, volume.
/// Shows only what the app actually knows.
class _LcdPanel extends ConsumerWidget {
  const _LcdPanel({required this.device, required this.connected});
  final CastDevice device;
  final bool connected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remote = ref.watch(remoteProvider);
    final player = ref.watch(playerProvider);
    const lcd = Color(0xFFA5B4FC);
    final mono = context.text.labelMedium?.copyWith(
      color: lcd,
      letterSpacing: 1.2,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    if (!connected) return const _NoTvBar();
    final status = player.media == null
        ? context.l10n.idle
        : (player.playing ? context.l10n.playing : context.l10n.paused);
    final showVolume = connected && device.supports(RemoteCommand.volumeUp);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B0D1A), Color(0xFF1E1B4B)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFF2E3157)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (connected ? (player.media?.title ?? device.name) : context.l10n.noTvConnected).toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mono?.copyWith(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  remote.lastAction == null ? status : '$status · ${context.tr(remote.lastAction!).toUpperCase()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mono,
                ),
              ],
            ),
          ),
          if (showVolume) ...[
            const SizedBox(width: AppSpace.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 1; i <= 10; i++)
                      AnimatedContainer(
                        duration: AppDurations.fast,
                        width: 4,
                        height: 6.0 + i * 1.6,
                        margin: const EdgeInsetsDirectional.only(start: 2),
                        decoration: BoxDecoration(
                          color: !remote.muted && remote.volume >= i * 10 ? lcd : lcd.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(remote.muted ? context.l10n.mute2 : context.l10n.vol(remote.volume), style: mono),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Not connected: a tappable bar that opens "Choose a device".
class _NoTvBar extends StatelessWidget {
  const _NoTvBar();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return TapScale(
      onTap: () => _chooseDevice(context),
      semanticLabel: context.l10n.noTvConnectedTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.md),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: p.warning.withValues(alpha: 0.5), width: 1.5),
          boxShadow: AppShadows.soft(p),
        ),
        child: Row(
          children: [
            Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: p.warning.withValues(alpha: 0.16), shape: BoxShape.circle),
                  child: const Icon(Iconsax.monitor_copy, color: Color(0xFFD97706), size: 22),
                )
                .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08), duration: 900.ms),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.noTvConnected, style: context.text.titleSmall),
                  Text(context.l10n.tapToChooseA, style: context.text.bodySmall),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.mainGradient,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(context.l10n.connect, style: context.text.labelMedium?.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

typedef _Send = Future<void> Function(RemoteCommand);

class _KeyButton extends StatelessWidget {
  const _KeyButton(this.device, this.command, this.icon, this.send, {this.label, this.size = 56, this.filled = false});

  final CastDevice device;
  final RemoteCommand command;
  final IconData icon;
  final _Send send;
  final String? label;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final supported = device.supports(command);
    final button = Opacity(
      opacity: supported ? 1 : 0.35,
      child: SoftIconButton(
        icon: icon,
        size: size,
        filled: filled,
        tooltip: supported ? command.label : context.l10n.isntSupportedBy(command.label, device.type.label),
        onPressed: supported ? () => send(command) : null,
      ),
    );
    if (label == null) return button;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 6),
        Text(label!, style: context.text.labelSmall),
      ],
    );
  }
}

class _DPad extends StatelessWidget {
  const _DPad({super.key, required this.device, required this.send});
  final CastDevice device;
  final _Send send;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final okSupported = device.supports(RemoteCommand.ok);
    Widget arrow(RemoteCommand c, IconData icon, Alignment a) => Align(
      alignment: a,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Opacity(
          opacity: device.supports(c) ? 1 : 0.3,
          child: IconButton(
            tooltip: context.tr(c.label),
            iconSize: 30,
            constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
            onPressed: device.supports(c) ? () => send(c) : null,
            icon: Icon(icon, color: p.textPrimary),
          ),
        ),
      ),
    );

    return Center(
      child: Container(
        width: 248,
        height: 248,
        decoration: BoxDecoration(
          color: p.surface,
          shape: BoxShape.circle,
          border: Border.all(color: p.divider),
          boxShadow: AppShadows.soft(p),
        ),
        child: Stack(
          children: [
            arrow(RemoteCommand.up, Icons.keyboard_arrow_up_rounded, Alignment.topCenter),
            arrow(RemoteCommand.down, Icons.keyboard_arrow_down_rounded, Alignment.bottomCenter),
            arrow(RemoteCommand.left, Icons.keyboard_arrow_left_rounded, Alignment.centerLeft),
            arrow(RemoteCommand.right, Icons.keyboard_arrow_right_rounded, Alignment.centerRight),
            Center(
              child: TapScale(
                onTap: okSupported ? () => send(RemoteCommand.ok) : null,
                semanticLabel: context.l10n.ok,
                child: Opacity(
                  opacity: okSupported ? 1 : 0.35,
                  child: Container(
                    width: 92,
                    height: 92,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.mainGradient,
                      shape: BoxShape.circle,
                      boxShadow: okSupported ? AppShadows.glow(AppColors.primary) : null,
                    ),
                    child: Text(context.l10n.ok, style: context.text.titleLarge?.copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Touchpad extends StatefulWidget {
  const _Touchpad({required this.device, required this.send});
  final CastDevice device;
  final _Send send;

  @override
  State<_Touchpad> createState() => _TouchpadState();
}

class _TouchpadState extends State<_Touchpad> {
  Offset? _ripple;
  int _rippleKey = 0;

  void _swipe(DragEndDetails d) {
    final v = d.velocity.pixelsPerSecond;
    if (v.distance < 200) return;
    final c = v.dx.abs() > v.dy.abs()
        ? (v.dx > 0 ? RemoteCommand.right : RemoteCommand.left)
        : (v.dy > 0 ? RemoteCommand.down : RemoteCommand.up);
    widget.send(c);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final enabled = widget.device.supports(RemoteCommand.ok);
    return Semantics(
      label: context.l10n.touchpadSwipeToMove,
      child: GestureDetector(
        onPanEnd: enabled ? _swipe : null,
        onTapUp: enabled
            ? (d) {
                setState(() {
                  _ripple = d.localPosition;
                  _rippleKey++;
                });
                widget.send(RemoteCommand.ok);
              }
            : null,
        child: Container(
          height: 248,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: p.divider),
            boxShadow: AppShadows.soft(p),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.finger_scan_copy, size: 32, color: p.textSecondary),
                    const SizedBox(height: AppSpace.sm),
                    Text(
                      enabled ? context.l10n.swipeToMoveTap : context.l10n.navigationIsntSupportedBy,
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              if (_ripple != null)
                Positioned(
                  key: ValueKey(_rippleKey),
                  left: _ripple!.dx - 40,
                  top: _ripple!.dy - 40,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: p.primary.withValues(alpha: 0.25)),
                  ).animate().scale(begin: const Offset(0.2, 0.2), duration: 350.ms).fadeOut(duration: 400.ms),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaybackRow extends ConsumerWidget {
  const _PlaybackRow({required this.device, required this.send});
  final CastDevice device;
  final _Send send;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playing = ref.watch(playerProvider.select((s) => s.playing));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _KeyButton(device, RemoteCommand.previous, Iconsax.previous_copy, send, size: 48),
        _KeyButton(device, RemoteCommand.rewind, Iconsax.backward_10_seconds_copy, send, size: 48),
        _KeyButton(
          device,
          RemoteCommand.playPause,
          playing ? Iconsax.pause_copy : Iconsax.play_copy,
          send,
          size: 64,
          filled: true,
        ),
        _KeyButton(device, RemoteCommand.fastForward, Iconsax.forward_10_seconds_copy, send, size: 48),
        _KeyButton(device, RemoteCommand.next, Iconsax.next_copy, send, size: 48),
      ],
    );
  }
}

class _VolumeRow extends ConsumerWidget {
  const _VolumeRow({required this.device, required this.send});
  final CastDevice device;
  final _Send send;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final muted = ref.watch(remoteProvider.select((s) => s.muted));
    final volume = device.supports(RemoteCommand.volumeUp);

    Widget half(RemoteCommand c, IconData icon) => Expanded(
      child: InkWell(
        onTap: volume ? () => send(c) : null,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: SizedBox(
          height: 56,
          child: Tooltip(
            message: context.tr(c.label),
            child: Icon(icon, color: volume ? p.textPrimary : p.textSecondary),
          ),
        ),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Opacity(
            opacity: volume ? 1 : 0.35,
            child: Container(
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: p.divider),
                boxShadow: AppShadows.soft(p),
              ),
              child: Row(
                children: [
                  half(RemoteCommand.volumeDown, Icons.remove_rounded),
                  Text(context.l10n.vol2, style: context.text.labelMedium?.copyWith(color: p.textSecondary)),
                  half(RemoteCommand.volumeUp, Icons.add_rounded),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpace.md),
        _KeyButton(device, RemoteCommand.mute, muted ? Iconsax.volume_slash_copy : Iconsax.volume_high_copy, send),
      ],
    );
  }
}

/// No TV yet: open the device list, after checking for Wi-Fi or hotspot.
Future<void> _chooseDevice(BuildContext context) async {
  if (!await requireNetwork(context, source: 'tv_remote')) return;
  if (context.mounted) await context.push<bool>('/connect?reason=remote');
}
