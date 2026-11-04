import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/cast_device.dart';
import '../device_providers.dart';
import '../../../../core/l10n.dart';
import 'network_widgets.dart';
import 'no_devices_found.dart';
import 'tv_radar.dart';

/// Opens the quick "Find your TV" sheet used by the Home connection bar.
Future<void> showFindTvSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const SafeArea(top: false, child: FindTvSheet()),
  );
}

class FindTvSheet extends ConsumerStatefulWidget {
  const FindTvSheet({super.key});

  @override
  ConsumerState<FindTvSheet> createState() => _FindTvSheetState();
}

class _FindTvSheetState extends ConsumerState<FindTvSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final conn = ref.read(connectionProvider);
      final d = ref.read(discoveryProvider);
      // Start finding TVs as soon as the sheet opens.
      if (!conn.isConnected && !d.scanning) ref.read(discoveryProvider.notifier).scan();
    });
  }

  Future<void> _connect(CastDevice device) async {
    final ok = await ref.read(connectionProvider.notifier).connect(device);
    if (!mounted) return;
    if (ok) {
      // Let the connected pulse play, then close.
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.of(context).pop();
    }
    // Failure is shown inline by ConnectFailedCard.
  }

  @override
  Widget build(BuildContext context) {
    final discovery = ref.watch(discoveryProvider);
    final conn = ref.watch(connectionProvider);
    final scan = ref.read(discoveryProvider.notifier).scan;
    final l = context.l10n;

    final Widget body;
    if (conn.isConnected) {
      body = _Connected(device: conn.device!);
    } else if (conn.status == ConnectionStatus.failed && conn.device != null) {
      body = ConnectFailedCard(onRetry: () => _connect(conn.device!), onScanAgain: scan);
    } else if (discovery.networkRequired) {
      body = const NetworkRequiredCard();
    } else if (discovery.error != null) {
      body = ErrorState(message: discovery.error, onRetry: scan);
    } else if (!discovery.scanning && discovery.devices.isEmpty) {
      body = NoDevicesFound(onRetry: scan, compact: true);
    } else {
      final status = discovery.devices.isNotEmpty
          ? l.devicesFound(discovery.devices.length)
          : (discovery.hotspot ? l.waitingForTvOnHotspot : l.searchingDevices);
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (discovery.hotspot)
            Center(
              child: Chip(
                avatar: Icon(Iconsax.mobile_copy, size: 16, color: context.palette.primary),
                label: Text(l.usingHotspot),
              ),
            ),
          Center(
            child: TvRadar(scanning: discovery.scanning, devices: discovery.devices, size: 210),
          ),
          const SizedBox(height: AppSpace.md),
          AnimatedSwitcher(
            duration: AppDurations.medium,
            child: Row(
              key: ValueKey(status),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (discovery.scanning) ...[
                  SizedBox.square(
                    dimension: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: context.palette.primary),
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(child: Text(status, style: context.text.bodyMedium)),
              ],
            ),
          ),
          if (discovery.isolationSuspected) ...[const SizedBox(height: AppSpace.md), const IsolationHint()],
          const SizedBox(height: AppSpace.lg),
          for (final d in discovery.devices)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.sm),
              child: _DeviceRow(device: d, connection: conn, onConnect: () => _connect(d)),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.15, end: 0),
          const SizedBox(height: AppSpace.sm),
          TintedButton(label: l.retry, icon: Iconsax.refresh_copy, onPressed: scan),
          // Once the search is done, hotspot help sits at the bottom.
          if (!discovery.scanning && !discovery.hotspot) ...[
            const SizedBox(height: AppSpace.lg),
            const StillCantFindCard(),
          ],
        ],
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.88),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpace.xl, 0, AppSpace.xl, AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(conn.isConnected ? context.l10n.yourTv : context.l10n.findYourTv, style: context.text.headlineMedium),
            const SizedBox(height: AppSpace.md),
            AnimatedSize(
              duration: AppDurations.medium,
              curve: Curves.easeOutCubic,
              child: AnimatedSwitcher(
                duration: AppDurations.medium,
                child: KeyedSubtree(key: ValueKey(body.runtimeType), child: body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device, required this.connection, required this.onConnect});

  final CastDevice device;
  final CastConnection connection;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final connecting = connection.isConnecting && connection.device == device;
    final busy = connection.isConnecting && !connecting;
    return SoftCard(
      padding: const EdgeInsets.all(AppSpace.md),
      onTap: connecting || busy ? null : onConnect,
      semanticLabel: context.l10n.connectTo(device.name),
      child: Row(
        children: [
          IconBubble(icon: device.type.icon, size: 44),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${context.tr(device.type.label)} · ${device.address}', style: context.text.bodySmall),
              ],
            ),
          ),
          if (connecting)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2, color: p.primary)),
                const SizedBox(width: 8),
                Text(context.l10n.connecting2, style: context.text.labelMedium?.copyWith(color: p.primary)),
              ],
            )
          else
            GradientButton(label: context.l10n.connect, compact: true, onPressed: busy ? null : onConnect),
        ],
      ),
    );
  }
}

class _Connected extends ConsumerWidget {
  const _Connected({required this.device});
  final CastDevice device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpace.sm),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(color: p.success, shape: BoxShape.circle, boxShadow: AppShadows.glow(p.success)),
          child: Icon(device.type.icon, color: Colors.white, size: 40),
        ).animate().scale(begin: const Offset(0.6, 0.6), curve: Curves.elasticOut, duration: 800.ms),
        const SizedBox(height: AppSpace.lg),
        Text(device.name, style: context.text.headlineSmall),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: p.success, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(context.l10n.connected2(device.type.label), style: context.text.bodyMedium),
          ],
        ),
        const SizedBox(height: AppSpace.xl),
        GradientButton(
          label: context.l10n.openTvRemote,
          icon: Iconsax.mobile_copy,
          expand: true,
          onPressed: () {
            Navigator.of(context).pop();
            context.push('/remote');
          },
        ),
        const SizedBox(height: AppSpace.sm),
        TintedButton(
          label: context.l10n.disconnect,
          icon: Iconsax.logout_copy,
          color: p.error,
          expand: true,
          onPressed: () => ref.read(connectionProvider.notifier).disconnect(),
        ),
      ],
    );
  }
}
