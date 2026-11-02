import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/soft_card.dart';
import 'connection_guide_sheet.dart';

const _checks = [
  (Iconsax.wifi_copy, 'Same Wi-Fi network', 'Your phone and TV must be connected to the same Wi-Fi.'),
  (Iconsax.monitor_copy, 'TV is on and ready', 'Turn on Screen Mirroring, Cast or Miracast on the TV.'),
  (Iconsax.shield_tick_copy, 'No VPN or guest network', 'VPNs and guest / isolated Wi-Fi hide devices from each other.'),
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
      padding: EdgeInsets.symmetric(horizontal: compact ? 0 : AppSpace.page, vertical: AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _NoLinkPicture(),
          const SizedBox(height: AppSpace.lg),
          Text('No TV found', style: context.text.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            'Check that your phone and TV are connected to the same Wi-Fi, then scan again.',
            textAlign: TextAlign.center,
            style: context.text.bodyMedium,
          ),
          const SizedBox(height: AppSpace.xl),
          SoftCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.sm),
            child: Column(
              children: [
                for (final (i, (icon, title, body)) in _checks.indexed) ...[
                  if (i > 0) Divider(color: p.divider, height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconBubble(icon: icon, size: 38, color: i == 0 ? p.warning : p.primary),
                        const SizedBox(width: AppSpace.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: context.text.titleSmall),
                              Text(body, style: context.text.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: (80 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          GradientButton(label: 'Scan again', icon: Iconsax.refresh_copy, expand: true, onPressed: onRetry),
          const SizedBox(height: AppSpace.sm),
          TintedButton(
            label: 'How to connect',
            icon: Iconsax.message_question_copy,
            expand: true,
            onPressed: () => showConnectionGuide(context),
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
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: p.divider),
            boxShadow: AppShadows.soft(p),
          ),
          child: Icon(icon, color: p.primary, size: 30),
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
