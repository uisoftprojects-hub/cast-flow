import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/l10n.dart';
import '../../../../core/platform/network_channel.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/soft_card.dart';
import '../device_providers.dart';
import '../network_controller.dart';

/// "Not on Wi-Fi" state: explains the requirement and offers Wi-Fi settings
/// or the phone's own hotspot. Used inline on cast screens and in a dialog.
class NetworkRequiredCard extends StatelessWidget {
  const NetworkRequiredCard({super.key, this.onHotspot});

  /// Override for the hotspot button (defaults to opening the guide).
  final VoidCallback? onHotspot;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(color: p.warning.withValues(alpha: 0.14), shape: BoxShape.circle),
          child: Icon(Iconsax.wifi_square_copy, size: 38, color: p.warning),
        )
            .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(1.06, 1.06), duration: 900.ms),
        const SizedBox(height: AppSpace.lg),
        Text(l.networkRequiredTitle, style: context.text.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(l.networkRequiredMessage, style: context.text.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: AppSpace.xl),
        GradientButton(
          label: l.openWifiSettings,
          icon: Iconsax.wifi_copy,
          expand: true,
          onPressed: NetworkChannel.openWifiSettings,
        ),
        const SizedBox(height: AppSpace.sm),
        TintedButton(
          label: l.useMobileHotspot,
          icon: Iconsax.mobile_copy,
          expand: true,
          onPressed: onHotspot ?? () => showHotspotGuide(context),
        ),
      ],
    );
  }
}

/// Shows [NetworkRequiredCard] as a dialog. Returns once dismissed.
Future<void> showNetworkRequiredDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.all(AppSpace.xxl),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: NetworkRequiredCard(
          onHotspot: () {
            Navigator.of(dialogContext).pop();
            showHotspotGuide(context);
          },
        ),
      ),
    ),
  );
}

/// Step-by-step hotspot guide. Opens the system tethering screen; when the
/// user comes back and the hotspot is on, it closes and starts searching.
Future<void> showHotspotGuide(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => const SafeArea(top: false, child: _HotspotGuide()),
  );
}

class _HotspotGuide extends ConsumerStatefulWidget {
  const _HotspotGuide();

  @override
  ConsumerState<_HotspotGuide> createState() => _HotspotGuideState();
}

class _HotspotGuideState extends ConsumerState<_HotspotGuide> {
  bool _closing = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    // Re-checked automatically on resume; close as soon as the hotspot is on.
    ref.listen(networkProvider, (prev, next) {
      if (next != null && next.hotspot && !_closing) {
        _closing = true;
        final navigator = Navigator.of(context);
        final discovery = ref.read(discoveryProvider.notifier);
        Future<void>.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          navigator.pop();
          discovery.scan();
        });
        setState(() {});
      }
    });
    final steps = [l.hotspotStep1, l.hotspotStep2, l.hotspotStep3];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.useMobileHotspot, style: context.text.headlineMedium),
          const SizedBox(height: 4),
          Text(l.hotspotInstruction, style: context.text.bodyMedium),
          const SizedBox(height: AppSpace.xl),
          for (final (i, step) in steps.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.md),
              child: SoftCard(
                padding: const EdgeInsets.all(AppSpace.md),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(gradient: AppColors.mainGradient, shape: BoxShape.circle),
                      child: Text('${i + 1}', style: context.text.labelMedium?.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Icon([Iconsax.mobile_copy, Iconsax.monitor_copy, Iconsax.arrow_left_copy][i], color: p.primary, size: 20),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(child: Text(step, style: context.text.titleSmall)),
                  ],
                ),
              ).animate(delay: (80 * i).ms).fadeIn().slideX(begin: 0.05, end: 0),
            ),
          const SizedBox(height: AppSpace.sm),
          AnimatedSwitcher(
            duration: AppDurations.medium,
            child: _closing
                ? Row(
                    key: const ValueKey('ok'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, color: p.success),
                      const SizedBox(width: 8),
                      Flexible(child: Text(l.hotspotDetected, style: context.text.titleSmall)),
                    ],
                  )
                : GradientButton(
                    key: const ValueKey('open'),
                    label: l.openHotspotSettings,
                    icon: Iconsax.setting_2_copy,
                    expand: true,
                    onPressed: NetworkChannel.openHotspotSettings,
                  ),
          ),
          const SizedBox(height: AppSpace.sm),
          Text(l.hotspotAutoCheck, style: context.text.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Hint shown when hotspot clients exist but none respond.
class IsolationHint extends StatelessWidget {
  const IsolationHint({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SoftCard(
      color: p.warning.withValues(alpha: 0.12),
      shadow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Iconsax.shield_cross_copy, color: p.warning),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.isolationTitle, style: context.text.titleSmall),
                const SizedBox(height: 2),
                Text(context.l10n.isolationHint, style: context.text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Failed / network-lost state for a TV, with Retry (or Reconnect) and a hint
/// to check that both devices share a network.
class ConnectFailedCard extends ConsumerWidget {
  const ConnectFailedCard({super.key, required this.onRetry, required this.onScanAgain});

  final VoidCallback onRetry;
  final VoidCallback onScanAgain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final l = context.l10n;
    final conn = ref.watch(connectionProvider);
    final lost = conn.error == ConnectionController.networkLost;
    final hotspot = ref.watch(discoveryProvider.select((d) => d.hotspot));
    final name = conn.device?.name ?? '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(color: p.error.withValues(alpha: 0.14), shape: BoxShape.circle),
          child: Icon(lost ? Iconsax.wifi_square_copy : Iconsax.danger_copy, size: 38, color: p.error),
        ).animate().shakeX(hz: 3, amount: 4, duration: 400.ms),
        const SizedBox(height: AppSpace.lg),
        Text(lost ? l.networkLostTitle : l.connectionFailed, style: context.text.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(
          lost ? l.networkLostMessage : (hotspot ? l.hotspotConnectHint : l.connectFailedHint),
          style: context.text.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpace.xl),
        GradientButton(
          label: lost && name.isNotEmpty ? l.reconnectTo(name) : l.retry,
          icon: Iconsax.refresh_copy,
          expand: true,
          onPressed: onRetry,
        ),
        const SizedBox(height: AppSpace.sm),
        if (lost)
          TintedButton(label: l.openWifiSettings, icon: Iconsax.wifi_copy, expand: true, onPressed: NetworkChannel.openWifiSettings)
        else
          TintedButton(label: l.scanAgain, icon: Iconsax.radar_2_copy, expand: true, onPressed: onScanAgain),
      ],
    );
  }
}
