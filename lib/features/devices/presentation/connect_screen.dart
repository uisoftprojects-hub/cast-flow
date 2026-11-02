import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/state_views.dart';
import '../domain/cast_device.dart';
import 'device_providers.dart';
import 'widgets/connection_chip.dart';
import 'widgets/connection_guide_sheet.dart';
import '../../../core/l10n.dart';
import 'widgets/network_widgets.dart';
import 'widgets/no_devices_found.dart';
import 'widgets/tv_radar.dart';

/// Device discovery. Used both as the "Devices" tab and as a pushed picker
/// ([standalone]) that pops with `true` once a device is connected.
class ConnectScreen extends ConsumerStatefulWidget {
  const ConnectScreen({super.key, this.standalone = false, this.reason});

  final bool standalone;

  /// Why the picker was opened (e.g. "remote"), shown as a short banner.
  final String? reason;

  @override
  ConsumerState<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends ConsumerState<ConnectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final d = ref.read(discoveryProvider);
      if (!d.scanning && d.devices.isEmpty) ref.read(discoveryProvider.notifier).scan();
    });
  }

  Future<void> _connect(CastDevice device) async {
    final ok = await ref.read(connectionProvider.notifier).connect(device);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connected to ${device.name}')));
      if (widget.standalone && context.canPop()) {
        // Let the connected pulse play before returning.
        await Future<void>.delayed(const Duration(milliseconds: 700));
        if (mounted && context.canPop()) context.pop(true);
      }
    }
    // Failure is shown inline by ConnectFailedCard.
  }

  @override
  Widget build(BuildContext context) {
    final discovery = ref.watch(discoveryProvider);
    final conn = ref.watch(connectionProvider);
    final notifier = ref.read(discoveryProvider.notifier);
    final l = context.l10n;

    final failed = conn.status == ConnectionStatus.failed && conn.device != null;
    final blocked = failed || discovery.networkRequired;
    final showEmpty =
        !blocked && !discovery.scanning && discovery.devices.isEmpty && discovery.error == null && !discovery.hotspot;
    final status = discovery.devices.isNotEmpty
        ? l.devicesFound(discovery.devices.length)
        : (discovery.hotspot ? l.waitingForTvOnHotspot : l.searchingDevices);

    return Scaffold(
      appBar: CastAppBar(
        title: widget.standalone ? 'Choose a device' : 'Devices',
        actions: [
          SoftIconButton(
            icon: Iconsax.message_question_copy,
            tooltip: 'Connection guide',
            size: 44,
            onPressed: () => showConnectionGuide(context),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          if (widget.reason != null) SliverToBoxAdapter(child: _ReasonBanner(widget.reason!)),
          if (failed)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.xl, AppSpace.page, AppSpace.xl),
                child: ConnectFailedCard(onRetry: () => _connect(conn.device!), onScanAgain: notifier.scan),
              ),
            )
          else if (discovery.networkRequired)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(AppSpace.page, AppSpace.xl, AppSpace.page, AppSpace.xl),
                child: NetworkRequiredCard(),
              ),
            ),
          if (!showEmpty && !blocked) ...[
            if (discovery.hotspot)
              SliverToBoxAdapter(
                child: Center(
                  child: Chip(
                    avatar: Icon(Iconsax.mobile_copy, size: 16, color: context.palette.primary),
                    label: Text(l.usingHotspot),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: _Radar(scanning: discovery.scanning, devices: discovery.devices, connectedId: conn.device?.id),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.page, 0, AppSpace.page, AppSpace.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        if (discovery.scanning) ...[
                          SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: context.palette.primary),
                          ),
                          const SizedBox(width: AppSpace.sm),
                        ],
                        Expanded(child: Text(status, style: context.text.titleSmall)),
                        TintedButton(label: l.retry, icon: Iconsax.refresh_copy, compact: true, onPressed: notifier.scan),
                      ],
                    ),
                    if (!discovery.hotspot) ...[
                      const SizedBox(height: AppSpace.sm),
                      TintedButton(
                        label: l.useMobileHotspot,
                        icon: Iconsax.mobile_copy,
                        expand: true,
                        onPressed: () => showHotspotGuide(context),
                      ),
                    ],
                    if (discovery.isolationSuspected) ...[
                      const SizedBox(height: AppSpace.md),
                      const IsolationHint(),
                    ],
                  ],
                ),
              ),
            ),
          ],
          if (blocked)
            const SliverToBoxAdapter(child: SizedBox.shrink())
          else if (discovery.error != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: ErrorState(message: discovery.error, onRetry: notifier.scan),
            )
          else if (showEmpty)
            SliverPadding(
              padding: EdgeInsets.only(bottom: navBottomPadding(context)),
              sliver: SliverToBoxAdapter(child: NoDevicesFound(onRetry: notifier.scan)),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(AppSpace.page, 0, AppSpace.page, navBottomPadding(context)),
              sliver: SliverList.separated(
                itemCount: discovery.devices.length + (discovery.scanning ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: AppSpace.md),
                itemBuilder: (context, i) {
                  if (i >= discovery.devices.length) return const _DeviceSkeleton();
                  final d = discovery.devices[i];
                  return _DeviceTile(
                    device: d,
                    connection: conn,
                    onConnect: () => _connect(d),
                    onDisconnect: () => ref.read(connectionProvider.notifier).disconnect(),
                  ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Radar extends StatelessWidget {
  const _Radar({required this.scanning, required this.devices, this.connectedId});
  final bool scanning;
  final List<CastDevice> devices;
  final String? connectedId;

  int get found => devices.length;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
      child: Column(
        children: [
          TvRadar(scanning: scanning, devices: devices, connectedId: connectedId),
          const SizedBox(height: AppSpace.sm),
          AnimatedSwitcher(
            duration: AppDurations.medium,
            child: Text(
              scanning
                  ? (found == 0 ? 'Looking for TVs on your Wi-Fi' : '$found found so far')
                  : '$found device${found == 1 ? '' : 's'} found',
              key: ValueKey('$scanning$found'),
              style: context.text.bodyMedium?.copyWith(color: p.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.device,
    required this.connection,
    required this.onConnect,
    required this.onDisconnect,
  });

  final CastDevice device;
  final CastConnection connection;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isThis = connection.device == device;
    final connected = isThis && connection.isConnected;
    final connecting = isThis && connection.isConnecting;
    final busyElsewhere = connection.isConnecting && !isThis;

    Widget action;
    if (connected) {
      action = TintedButton(label: 'Disconnect', compact: true, color: p.error, onPressed: onDisconnect);
    } else if (connecting) {
      action = const _ConnectingLink();
    } else {
      action = GradientButton(label: 'Connect', compact: true, onPressed: busyElsewhere ? null : onConnect);
    }

    final bubble = IconBubble(icon: device.type.icon, size: 52, color: connected ? p.success : null);

    return SoftCard(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Row(
        children: [
          // Brief connected pulse, then it settles.
          connected
              ? bubble.animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut, duration: 700.ms)
              : bubble,
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _SignalBars(device.signal),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        connected ? context.l10n.connected : '${device.type.label} · ${device.address}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(color: connected ? p.success : null),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          AnimatedSwitcher(duration: AppDurations.medium, child: KeyedSubtree(key: ValueKey('$connected$connecting'), child: action)),
          _ForgetMenu(device: device),
        ],
      ),
    );
  }
}

class _SignalBars extends StatelessWidget {
  const _SignalBars(this.signal);
  final double signal;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final level = (signal * 4).ceil();
    return Semantics(
      label: 'Signal $level of 4',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 1; i <= 4; i++)
            Container(
              width: 3,
              height: 4.0 + i * 2.5,
              margin: const EdgeInsetsDirectional.only(end: 2),
              decoration: BoxDecoration(
                color: i <= level ? p.primary : p.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

class _DeviceSkeleton extends StatelessWidget {
  const _DeviceSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(AppSpace.md),
      child: SoftShimmer(
        child: Row(
          children: [
            const ShimmerBox(width: 52, height: 52, radius: 26),
            const SizedBox(width: AppSpace.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 14, width: 140),
                  SizedBox(height: 8),
                  ShimmerBox(height: 10, width: 80),
                ],
              ),
            ),
            ShimmerBox(width: 88, height: 40, radius: AppRadius.pill),
          ],
        ),
      ),
    );
  }
}

/// Phone → TV link shown while a connection is being set up.
class _ConnectingLink extends StatelessWidget {
  const _ConnectingLink();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: 'Connecting',
      liveRegion: true,
      child: SizedBox(
        width: 96,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.mobile_copy, size: 18, color: p.primary),
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: reduce
                    ? Container(width: 5, height: 5, decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle))
                    : Container(width: 5, height: 5, decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle))
                        .animate(onPlay: (c) => c.repeat(), delay: (150 * i).ms)
                        .fade(begin: 0.2, end: 1, duration: 450.ms)
                        .then()
                        .fade(begin: 1, end: 0.2, duration: 450.ms),
              ),
            Icon(Iconsax.monitor_copy, size: 18, color: p.primary),
          ],
        ),
      ),
    );
  }
}

class _ReasonBanner extends StatelessWidget {
  const _ReasonBanner(this.reason);
  final String reason;

  @override
  Widget build(BuildContext context) {
    final text = switch (reason) {
      'remote' => 'The TV remote needs a connected TV. Pick one below.',
      _ => 'Connect to a TV to continue.',
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, 0),
      child: SoftCard(
        color: context.palette.primaryTint,
        shadow: false,
        child: Row(
          children: [
            Icon(Iconsax.info_circle_copy, color: context.palette.primary),
            const SizedBox(width: AppSpace.md),
            Expanded(child: Text(text, style: context.text.bodyMedium?.copyWith(color: context.palette.textPrimary))),
          ],
        ),
      ),
    );
  }
}

/// Per-device menu with "Forget device" (clears saved pairing).
class _ForgetMenu extends ConsumerWidget {
  const _ForgetMenu({required this.device});
  final CastDevice device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PopupMenuButton<int>(
      tooltip: l.forgetDevice,
      icon: Icon(Iconsax.more_copy, color: context.palette.textSecondary),
      onSelected: (_) async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(l.forgetDevice),
            content: Text(l.forgetDeviceMessage(device.name)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
              TextButton(
                onPressed: () => Navigator.pop(c, true),
                child: Text(l.forget, style: TextStyle(color: context.palette.error)),
              ),
            ],
          ),
        );
        if (ok == true) await ref.read(connectionProvider.notifier).forget(device);
      },
      itemBuilder: (_) => [PopupMenuItem(value: 0, child: Text(l.forgetDevice))],
    );
  }
}
