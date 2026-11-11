import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/ad_side_layout.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/state_views.dart';
import '../domain/cast_device.dart';
import 'device_providers.dart';
import 'widgets/connection_chip.dart';
import 'widgets/connection_guide_sheet.dart';
import 'widgets/discovery_permission_cards.dart';
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
  AppLifecycleListener? _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () {
        ref.read(discoveryProvider.notifier).recheckPermissions();
      },
    );
  }

  /// The Devices tab lives in an IndexedStack, so initState only runs once.
  /// Watching the ticker state tells us each time the tab is shown again.
  bool _wasShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shown = TickerMode.valuesOf(context).enabled;
    if (shown && !_wasShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scanOnShow();
      });
    }
    _wasShown = shown;
  }

  /// Every time Devices opens with no TV connected it starts a fresh scan,
  /// instead of leaving an old error or an old "no TV found" screen up.
  void _scanOnShow() {
    final conn = ref.read(connectionProvider);
    if (conn.isConnected || conn.isConnecting) return;
    if (conn.status == ConnectionStatus.failed) ref.read(connectionProvider.notifier).clearFailure();
    final d = ref.read(discoveryProvider);
    if (d.scanning && d.phase != DiscoveryPhase.stopped) return;
    ref.read(discoveryProvider.notifier).grantPermission();
  }

  @override
  void dispose() {
    _lifecycle?.dispose();
    super.dispose();
  }

  Future<void> _connect(CastDevice device) async {
    final ok = await ref.read(connectionProvider.notifier).connect(device);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.connectedTo(device.name))));
      if (widget.standalone && context.canPop()) {
        await Future<void>.delayed(const Duration(milliseconds: 700));
        if (mounted && context.canPop()) context.pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final discovery = ref.watch(discoveryProvider);
    final conn = ref.watch(connectionProvider);
    final notifier = ref.read(discoveryProvider.notifier);
    final l = context.l10n;

    final isPermissionBlocked =
        discovery.phase == DiscoveryPhase.permissionDenied ||
        discovery.phase == DiscoveryPhase.permissionPermanentlyDenied ||
        discovery.phase == DiscoveryPhase.locationServicesDisabled;
    final isPermissionPhase =
        isPermissionBlocked ||
        discovery.phase == DiscoveryPhase.permissionRequired ||
        discovery.phase == DiscoveryPhase.checkingConnectivity;

    final failed = conn.status == ConnectionStatus.failed && conn.device != null;
    final blocked = failed || discovery.networkRequired;
    final showHotspotHelp = !discovery.scanning && !discovery.hotspot && !conn.isConnected;
    final showEmpty =
        !blocked &&
        !isPermissionPhase &&
        !discovery.scanning &&
        discovery.devices.isEmpty &&
        discovery.error == null &&
        !discovery.hotspot &&
        discovery.phase != DiscoveryPhase.stopped;

    final String status;
    if (discovery.phase == DiscoveryPhase.permissionDenied ||
        discovery.phase == DiscoveryPhase.permissionPermanentlyDenied) {
      status = l.permissionNeededToDiscover;
    } else if (discovery.phase == DiscoveryPhase.locationServicesDisabled) {
      status = l.locationServicesDisabled;
    } else if (discovery.phase == DiscoveryPhase.checkingConnectivity) {
      status = l.checkingNetwork;
    } else if (discovery.phase == DiscoveryPhase.stopped) {
      status = l.discoveryStopped;
    } else if (discovery.devices.isNotEmpty) {
      status = l.devicesFound(discovery.devices.length);
    } else if (discovery.hotspot) {
      status = l.waitingForTvOnHotspot;
    } else {
      status = l.searchingDevices;
    }

    return Scaffold(
      appBar: CastAppBar(
        title: widget.standalone ? context.l10n.chooseADevice : context.l10n.devices,
        actions: [
          SoftIconButton(
            icon: Iconsax.message_question_copy,
            tooltip: context.l10n.connectionGuide,
            size: 44,
            onPressed: () => showConnectionGuide(context),
          ),
        ],
      ),
      // No TV found: everything on one screen in portrait, no scrolling.
      body: showEmpty && !isLandscape(context)
          ? _EmptyOneScreen(reason: widget.reason, onRetry: notifier.scan)
          : CustomScrollView(
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
                  if (discovery.phase == DiscoveryPhase.stopped)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.sm),
                        child: SoftCard(
                          color: context.palette.surfaceHigh,
                          child: Row(
                            children: [
                              Icon(Iconsax.info_circle_copy, color: context.palette.textSecondary),
                              const SizedBox(width: AppSpace.md),
                              Expanded(child: Text(l.discoveryStoppedHint, style: context.text.bodyMedium)),
                              const SizedBox(width: AppSpace.sm),
                              TintedButton(
                                label: l.search,
                                icon: Iconsax.refresh_copy,
                                compact: true,
                                onPressed: notifier.grantPermission,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                    child: _Radar(
                      scanning: discovery.scanning,
                      devices: discovery.devices,
                      connectedId: conn.device?.id,
                      // Permission problems are explained once, in the banner below.
                      statusOverride: isPermissionBlocked
                          ? ''
                          : (discovery.phase == DiscoveryPhase.checkingConnectivity
                                ? l.checkingNetwork
                                : (discovery.phase == DiscoveryPhase.stopped ? l.discoveryStopped : null)),
                    ),
                  ),
                  if (isPermissionBlocked)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpace.page, 0, AppSpace.page, AppSpace.md),
                        child: DiscoveryPermissionBanner(
                          phase: discovery.phase,
                          onGrant: notifier.grantPermission,
                          onOpenSettings: notifier.openSettings,
                          onOpenLocationSettings: notifier.openLocationSettings,
                        ),
                      ),
                    )
                  else
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
                              ],
                            ),
                            // Buttons sit on their own row so long translations of the
                            // status text never get squeezed into a few characters per line.
                            const SizedBox(height: AppSpace.sm),
                            Row(
                              children: [
                                if (discovery.scanning) ...[
                                  Expanded(
                                    child: TintedButton(
                                      label: l.stop,
                                      icon: Iconsax.stop_circle_copy,
                                      compact: true,
                                      onPressed: notifier.stop,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpace.sm),
                                ],
                                Expanded(
                                  child: TintedButton(
                                    label: l.retry,
                                    icon: Iconsax.refresh_copy,
                                    compact: true,
                                    onPressed: notifier.grantPermission,
                                  ),
                                ),
                              ],
                            ),
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
                      itemCount: discovery.devices.length + (discovery.scanning || showHotspotHelp ? 1 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpace.md),
                      itemBuilder: (context, i) {
                        if (i >= discovery.devices.length) {
                          return discovery.scanning ? const _DeviceSkeleton() : const StillCantFindCard();
                        }
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
  const _Radar({required this.scanning, required this.devices, this.connectedId, this.statusOverride});

  final bool scanning;
  final List<CastDevice> devices;
  final String? connectedId;
  final String? statusOverride;

  int get found => devices.length;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final label =
        statusOverride ??
        (scanning
            ? (found == 0 ? context.l10n.lookingForTvsOn : context.l10n.foundSoFar(found))
            : context.l10n.deviceFound(found, found == 1 ? '' : 's'));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
      child: Column(
        children: [
          TvRadar(scanning: scanning, devices: devices, connectedId: connectedId),
          const SizedBox(height: AppSpace.sm),
          AnimatedSwitcher(
            duration: AppDurations.medium,
            child: Text(
              label,
              key: ValueKey('$scanning$found$statusOverride'),
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
      action = TintedButton(label: context.l10n.disconnect, compact: true, color: p.error, onPressed: onDisconnect);
    } else if (connecting) {
      action = const _ConnectingLink();
    } else {
      action = GradientButton(label: context.l10n.connect, compact: true, onPressed: busyElsewhere ? null : onConnect);
    }

    final bubble = IconBubble(icon: device.type.icon, size: 52, color: connected ? p.success : null);

    return SoftCard(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Row(
        children: [
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
          AnimatedSwitcher(
            duration: AppDurations.medium,
            child: KeyedSubtree(key: ValueKey('$connected$connecting'), child: action),
          ),
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
      label: context.l10n.signalOf4(level),
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
                children: [ShimmerBox(height: 14, width: 140), SizedBox(height: 8), ShimmerBox(height: 10, width: 80)],
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
      label: context.l10n.connecting2,
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
                    ? Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                      )
                    : Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                          )
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
      'remote' => context.l10n.theTvRemoteNeeds,
      _ => context.l10n.connectToATv,
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
            Expanded(
              child: Text(text, style: context.text.bodyMedium?.copyWith(color: context.palette.textPrimary)),
            ),
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

/// "No TV found": the animation sits at the top, the message is centred in
/// the free space, and the actions stay at the bottom. Scrolls only when the
/// screen is too short to fit everything.
class _EmptyOneScreen extends StatelessWidget {
  const _EmptyOneScreen({required this.reason, required this.onRetry});
  final String? reason;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (reason != null) _ReasonBanner(reason!),
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) => SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, navBottomPadding(context)),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight - AppSpace.sm - navBottomPadding(context)),
                child: IntrinsicHeight(
                  child: Column(
                    // Hero on top, actions at the bottom, message centred between them.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NoDevicesHero(),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpace.lg),
                        child: NoDevicesContent(),
                      ),
                      NoDevicesActions(onRetry: onRetry),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
