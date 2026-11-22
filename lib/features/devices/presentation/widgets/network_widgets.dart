import 'dart:async';

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
import '../../../../core/widgets/effects.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../../../core/widgets/tap_scale.dart';
import '../device_providers.dart';
import '../network_controller.dart';

/// "No Wi-Fi and no hotspot" state, used inline (Devices tab, Find TV sheet)
/// and as the full [NoNetworkScreen]. A calm animated picture, then two ways
/// forward: turn on Wi-Fi, or share the phone's hotspot. Nothing here shows a
/// "Finding TV" loader: there is nothing to find until a network is up, and
/// the caller switches to discovery by itself when one appears.
class NetworkRequiredCard extends StatelessWidget {
  const NetworkRequiredCard({super.key, this.compact = false});

  /// Smaller picture for bottom sheets.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NoNetworkHero(size: compact ? 150 : 190),
        const SizedBox(height: AppSpace.lg),
        Text(l.networkRequiredTitle, style: context.text.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(l.noNetworkMessage, style: context.text.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: AppSpace.xl),
        GradientButton(
          label: l.turnOnWifi,
          icon: Iconsax.wifi_copy,
          expand: true,
          onPressed: NetworkChannel.openWifiPanel,
        ),
        const SizedBox(height: AppSpace.sm),
        TintedButton(
          label: l.useMobileHotspot,
          icon: Iconsax.mobile_copy,
          expand: true,
          onPressed: NetworkChannel.openHotspotSettings,
        ),
        const SizedBox(height: AppSpace.md),
        // Live hint: discovery starts on its own once a network is up.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                )
                .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                .fade(begin: 1, end: 0.25, duration: 800.ms),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l.waitingForNetwork,
                style: context.text.bodySmall?.copyWith(color: p.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () => showHotspotGuide(context),
          child: Text(l.howHotspotWorks, style: context.text.labelMedium?.copyWith(color: p.primary)),
        ),
      ],
    ).animate().fadeIn(duration: AppDurations.slow).slideY(begin: 0.04, end: 0);
  }
}

/// Animated picture for the no-network state: slow warning-coloured ripples
/// around a disc whose icon alternates between Wi-Fi and hotspot, the two
/// ways out of this state. Still (but complete) when the OS asks for reduced
/// motion.
class NoNetworkHero extends StatefulWidget {
  const NoNetworkHero({super.key, this.size = 190});

  final double size;

  @override
  State<NoNetworkHero> createState() => _NoNetworkHeroState();
}

class _NoNetworkHeroState extends State<NoNetworkHero> {
  Timer? _swap;
  bool _hotspot = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _swap?.cancel();
    if (!context.reduceMotion) {
      _swap = Timer.periodic(const Duration(milliseconds: 1800), (_) {
        if (mounted) setState(() => _hotspot = !_hotspot);
      });
    }
  }

  @override
  void dispose() {
    _swap?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final size = widget.size;
    final disc = size * 0.46;
    return ExcludeSemantics(
      child: PulseRipple(
        size: size,
        rings: 3,
        color: p.warning,
        duration: const Duration(milliseconds: 2800),
        child: Container(
          width: disc,
          height: disc,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: p.warning.withValues(alpha: 0.16),
            border: Border.all(color: p.warning.withValues(alpha: 0.35), width: 1.5),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedSwitcher(
                duration: AppDurations.slow,
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: ScaleTransition(scale: Tween(begin: 0.8, end: 1.0).animate(a), child: child),
                ),
                child: Icon(
                  _hotspot ? Iconsax.mobile_copy : Iconsax.wifi_square_copy,
                  key: ValueKey(_hotspot),
                  size: disc * 0.42,
                  color: p.warning,
                ),
              ),
              PositionedDirectional(
                end: disc * 0.04,
                bottom: disc * 0.06,
                child: Container(
                  width: disc * 0.3,
                  height: disc * 0.3,
                  decoration: BoxDecoration(
                    color: p.surface,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.soft(p),
                  ),
                  child: Icon(Icons.close_rounded, size: disc * 0.18, color: p.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full screen shown instead of "Finding TV" when a cast feature is opened
/// with neither Wi-Fi nor the phone's hotspot. Pops with `true` by itself as
/// soon as either comes up (network changes are pushed by Android), so the
/// feature carries on straight into discovery.
class NoNetworkScreen extends ConsumerStatefulWidget {
  const NoNetworkScreen({super.key});

  static const routeName = '/no-network';

  @override
  ConsumerState<NoNetworkScreen> createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends ConsumerState<NoNetworkScreen> {
  bool _done = false;

  void _finish() {
    if (_done || !mounted) return;
    _done = true;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkProvider, (prev, next) {
      if (next != null && next.ready) _finish();
    });
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: context.systemOverlayStyle(),
        toolbarHeight: 68,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 26),
          tooltip: context.l10n.browserBack,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, c) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.md, AppSpace.page, AppSpace.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: (c.maxHeight - AppSpace.md - AppSpace.xl).clamp(0.0, double.infinity)),
              child: const Center(child: NetworkRequiredCard()),
            ),
          ),
        ),
      ),
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
/// [NoNetworkScreen] and returns true once the user has connected from there
/// (the screen closes by itself), false if they backed out.
Future<bool> requireNetwork(BuildContext context, {required String source}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final network = await container.read(networkProvider.notifier).refresh();
  if (network.ready) return true;
  container.read(analyticsProvider).log(AnalyticsEvent.networkNoWifi, {AnalyticsParam.source: source});
  if (!context.mounted) return false;
  final connected = await showNetworkRequiredDialog(context);
  return connected && (container.read(networkProvider)?.ready ?? false);
}

/// Opens the [NoNetworkScreen]. Completes with true when it closed because
/// Wi-Fi or the hotspot came up.
Future<bool> showNetworkRequiredDialog(BuildContext context) async {
  final ok = await Navigator.of(context, rootNavigator: true).push<bool>(
    MaterialPageRoute(
      settings: const RouteSettings(name: NoNetworkScreen.routeName),
      builder: (_) => const NoNetworkScreen(),
    ),
  );
  return ok == true;
}

/// Step-by-step hotspot guide. Opens the system tethering screen; when the
/// user comes back and the hotspot is on, it closes and starts searching.
///
/// Never shown when the hotspot is already on: discovery starts right away
/// instead, with the usual "Finding TV" radar.
Future<void> showHotspotGuide(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final network = await container.read(networkProvider.notifier).refresh();
  if (network.hotspot) {
    final d = container.read(discoveryProvider);
    if (!d.scanning) container.read(discoveryProvider.notifier).scan();
    return;
  }
  if (!context.mounted) return;
  analyticsOf(context).log(AnalyticsEvent.hotspotGuideOpen);
  return showModalBottomSheet<void>(
    useRootNavigator: true,
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.useMobileHotspot, style: context.text.headlineMedium),
          const SizedBox(height: 4),
          Text(l.hotspotInstruction, style: context.text.bodyMedium),
          const SizedBox(height: AppSpace.xl),
          const HotspotSteps(),
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
                    label: l.continueWithHotspot,
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

/// One quiet line instead of a card: "Still can't find your TV? Continue with
/// hotspot". Tapping it opens the hotspot guide in a bottom sheet.
class StillCantFindCard extends StatelessWidget {
  const StillCantFindCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    return Semantics(
      button: true,
      label: '${l.stillCantFindTitle} ${l.continueWithHotspot}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: () => showHotspotGuide(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.md),
          child: Center(
            child: Text.rich(
              TextSpan(
                text: '${l.stillCantFindTitle} ',
                children: [
                  TextSpan(
                    text: l.continueWithHotspot,
                    style: TextStyle(
                      color: p.primary,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(color: p.textSecondary),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
