import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/analytics/analytics_events.dart';
import '../../../../core/l10n.dart';
import '../../../../core/platform/network_channel.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../../../core/widgets/tap_scale.dart';
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
          label: l.connectWithWifi,
          icon: Iconsax.wifi_copy,
          expand: true,
          onPressed: () {
            NetworkChannel.openWifiSettings();
          },
        ),
        const SizedBox(height: AppSpace.xl),
        // The hotspot alternative, spelled out step by step.
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(l.castOverHotspot, style: context.text.titleSmall),
        ),
        const SizedBox(height: AppSpace.md),
        const HotspotSteps(),
        TintedButton(
          label: l.continueWithHotspot,
          icon: Iconsax.mobile_copy,
          expand: true,
          onPressed: onHotspot ?? () => showHotspotGuide(context),
        ),
      ],
    );
  }
}

/// Small card on Home, between the top options and Media, while the phone has
/// neither Wi-Fi nor a hotspot. Hides itself once connected.
class NoWifiBanner extends ConsumerWidget {
  const NoWifiBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final net = ref.watch(networkProvider);
    final p = context.palette;
    final l = context.l10n;
    final offline = net != null && !net.ready;
    return AnimatedSize(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
      child: !offline
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: AppSpace.md),
              child: Container(
                padding: const EdgeInsets.fromLTRB(AppSpace.md, 10, AppSpace.md, 10),
                decoration: BoxDecoration(
                  color: p.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.wifi_square_copy, size: 16, color: p.warning),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l.networkRequiredTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.labelLarge?.copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniAction(
                            icon: Iconsax.wifi_copy,
                            label: l.connectWithWifi,
                            onTap: NetworkChannel.openWifiSettings,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _MiniAction(
                            icon: Iconsax.mobile_copy,
                            label: l.continueWithHotspot,
                            onTap: () => showHotspotGuide(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),
    );
  }
}

/// Compact one-line action used inside the no-Wi-Fi card. The label shrinks
/// instead of wrapping, so both buttons stay one line in every language.
class _MiniAction extends StatelessWidget {
  const _MiniAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return TapScale(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(AppRadius.pill)),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: p.primary),
              const SizedBox(width: 5),
              Text(label, maxLines: 1, style: context.text.labelMedium?.copyWith(color: p.primary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gate for every wireless feature: returns true when the phone is on Wi-Fi
/// or sharing its hotspot. Otherwise (e.g. mobile data only) shows the
/// "Not connected to Wi-Fi" alert and returns false.
Future<bool> requireNetwork(BuildContext context, {required String source}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final network = await container.read(networkProvider.notifier).refresh();
  if (network.ready) return true;
  container.read(analyticsProvider).log(AnalyticsEvent.networkNoWifi, {AnalyticsParam.source: source});
  if (context.mounted) await showNetworkRequiredDialog(context);
  return false;
}

/// "Not connected to Wi-Fi" alert with two ways forward: join Wi-Fi, or use
/// the phone's own hotspot. Returns once dismissed.
Future<void> showNetworkRequiredDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final p = dialogContext.palette;
      final l = dialogContext.l10n;
      return Dialog(
        insetPadding: const EdgeInsets.all(AppSpace.xl),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: p.warning.withValues(alpha: 0.14), shape: BoxShape.circle),
                    child: Icon(Iconsax.wifi_square_copy, size: 34, color: p.warning),
                  )
                  .animate(onPlay: (c) => dialogContext.loopMotion(c, reverse: true))
                  .scale(begin: const Offset(1, 1), end: const Offset(1.06, 1.06), duration: 900.ms),
              const SizedBox(height: AppSpace.lg),
              Text(l.networkRequiredTitle, style: dialogContext.text.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(l.noWifiAlertMessage, style: dialogContext.text.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSpace.xl),
              GradientButton(
                label: l.connectWithWifi,
                icon: Iconsax.wifi_copy,
                expand: true,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  NetworkChannel.openWifiSettings();
                },
              ),
              const SizedBox(height: AppSpace.sm),
              TintedButton(
                label: l.continueWithHotspot,
                icon: Iconsax.mobile_copy,
                expand: true,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  showHotspotGuide(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Step-by-step hotspot guide. Opens the system tethering screen; when the
/// user comes back and the hotspot is on, it closes and starts searching.
Future<void> showHotspotGuide(BuildContext context) {
  analyticsOf(context).log(AnalyticsEvent.hotspotGuideOpen);
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
                    Icon(
                      [Iconsax.mobile_copy, Iconsax.monitor_copy, Iconsax.arrow_left_copy][i],
                      color: p.primary,
                      size: 20,
                    ),
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
        Text(
          lost ? l.networkLostTitle : l.connectionFailed,
          style: context.text.headlineSmall,
          textAlign: TextAlign.center,
        ),
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
          TintedButton(
            label: l.connectWithWifi,
            icon: Iconsax.wifi_copy,
            expand: true,
            onPressed: () {
              NetworkChannel.openWifiSettings();
            },
          )
        else
          TintedButton(label: l.scanAgain, icon: Iconsax.radar_2_copy, expand: true, onPressed: onScanAgain),
      ],
    );
  }
}

/// Numbered hotspot steps (turn on hotspot → connect TV → come back → retry).
class HotspotSteps extends StatelessWidget {
  const HotspotSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = [l.hotspotStep1, l.hotspotStep2, l.hotspotStep3, l.hotspotStep4];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, step) in steps.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpace.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(gradient: AppColors.mainGradient, shape: BoxShape.circle),
                  child: Text('${i + 1}', style: context.text.labelSmall?.copyWith(color: Colors.white)),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(step, style: context.text.bodyMedium?.copyWith(color: context.palette.textPrimary)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Shown under the device list once a search finishes: the TV may simply
/// not be on this Wi-Fi, so offer the phone's hotspot with the steps.
class StillCantFindCard extends StatelessWidget {
  const StillCantFindCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconBubble(icon: Icons.wifi_tethering_rounded, color: p.warning, size: 44),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.stillCantFindTitle, style: context.text.titleSmall),
                    Text(l.stillCantFindBody, style: context.text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          const HotspotSteps(),
          const SizedBox(height: AppSpace.xs),
          TintedButton(
            label: l.continueWithHotspot,
            icon: Iconsax.mobile_copy,
            expand: true,
            onPressed: () => showHotspotGuide(context),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0);
  }
}
