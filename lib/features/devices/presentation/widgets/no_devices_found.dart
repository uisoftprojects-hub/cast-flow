import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/l10n.dart';
import 'connection_guide_sheet.dart';
import 'network_widgets.dart';

const _checks = [
  (Iconsax.wifi_copy, 'Same Wi-Fi network', 'Your phone and TV must be connected to the same Wi-Fi.'),
  (Iconsax.monitor_copy, 'TV is on and ready', 'Turn on Screen Mirroring, Cast or Miracast on the TV.'),
  (
    Iconsax.shield_tick_copy,
    'No VPN or guest network',
    'VPNs and guest / isolated Wi-Fi hide devices from each other.',
  ),
  (Iconsax.location_copy, 'Local network access', 'Allow CastFlow to find devices on your network when asked.'),
];

/// Shown when a scan finishes without finding any TV: a clear picture of
/// what is missing plus a checklist and a way to scan again.
class NoDevicesFound extends StatelessWidget {
  const NoDevicesFound({super.key, required this.onRetry, this.compact = false});

  final VoidCallback onRetry;

  /// Tighter spacing for use inside a bottom sheet.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 0 : AppSpace.page, vertical: AppSpace.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _NoLinkPicture(),
          const SizedBox(height: AppSpace.md),
          Text(context.l10n.noTvFound, style: context.text.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(
            context.l10n.checkThatYourPhone,
            textAlign: TextAlign.center,
            style: context.text.bodySmall?.copyWith(fontSize: 12.5),
          ),
          const SizedBox(height: AppSpace.md),
          // Plain bullet list, no card around it.
          for (final (i, (_, title, body)) in _checks.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${context.tr(title)}. ',
                            style: context.text.labelLarge?.copyWith(fontSize: 12.5),
                          ),
                          TextSpan(text: context.tr(body)),
                        ],
                      ),
                      style: context.text.bodySmall?.copyWith(fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ).animate(delay: (80 * i).ms).fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpace.sm),
          const _HotspotCard(),
          const SizedBox(height: AppSpace.md),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  label: context.l10n.scanAgain,
                  icon: Iconsax.refresh_copy,
                  expand: true,
                  compact: true,
                  onPressed: onRetry,
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: TintedButton(
                  label: context.l10n.howToConnect,
                  icon: Iconsax.message_question_copy,
                  expand: true,
                  compact: true,
                  onPressed: () => showConnectionGuide(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The other way to connect: the TV joins the phone's own hotspot. Kept small:
/// a title, one line of help and a single button.
class _HotspotCard extends StatelessWidget {
  const _HotspotCard();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(color: p.primaryTint, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.mobile_copy, size: 16, color: p.primary),
              const SizedBox(width: 6),
              Expanded(child: Text(context.l10n.noWiFiRouter, style: context.text.labelLarge?.copyWith(fontSize: 13))),
            ],
          ),
          const SizedBox(height: 2),
          Text(l.hotspotInstruction, style: context.text.bodySmall?.copyWith(fontSize: 12)),
          const SizedBox(height: AppSpace.sm),
          GradientButton(
            label: l.useMobileHotspot,
            icon: Iconsax.mobile_copy,
            expand: true,
            compact: true,
            onPressed: () => showHotspotGuide(context),
          ),
        ],
      ),
    );
  }
}

/// Phone and TV with a broken Wi-Fi link between them.
class _NoLinkPicture extends StatelessWidget {
  const _NoLinkPicture();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget device(IconData icon) => Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: p.divider),
        boxShadow: AppShadows.soft(p),
      ),
      child: Icon(icon, color: p.primary, size: 24),
    );
    Widget dot() => Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(color: p.divider, shape: BoxShape.circle),
    );

    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          device(Iconsax.mobile_copy),
          const SizedBox(width: AppSpace.sm),
          dot(),
          dot(),
          Container(
                width: 34,
                height: 34,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(color: p.error.withValues(alpha: 0.14), shape: BoxShape.circle),
                child: Icon(Iconsax.wifi_square_copy, color: p.error, size: 18),
              )
              .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.12, 1.12), duration: 900.ms),
          dot(),
          dot(),
          const SizedBox(width: AppSpace.sm),
          device(Iconsax.monitor_copy),
        ],
      ),
    );
  }
}
