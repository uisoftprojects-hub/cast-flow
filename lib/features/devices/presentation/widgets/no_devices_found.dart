import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/effects.dart';
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
  (Iconsax.location_copy, 'Local network access', 'Allow Cast to TV to find devices on your network when asked.'),
];

/// Shown when a scan finishes without finding any TV: a clear picture of
/// what is missing plus a checklist and a way to scan again.
///
/// Used in a bottom sheet / scroll view (everything stacked). The Devices
/// screen lays the three parts out itself so the text sits in the middle.
class NoDevicesFound extends StatelessWidget {
  const NoDevicesFound({super.key, required this.onRetry, this.compact = false});

  final VoidCallback onRetry;

  /// Tighter spacing for use inside a bottom sheet.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 0 : AppSpace.page, vertical: AppSpace.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const NoDevicesHero(),
          const SizedBox(height: AppSpace.md),
          const NoDevicesContent(),
          const SizedBox(height: AppSpace.sm),
          NoDevicesActions(onRetry: onRetry),
        ],
      ),
    );
  }
}

/// Animated picture at the top: a calm radar pulse around the phone with a
/// "no link" badge. Keeps moving so the screen never looks frozen.
class NoDevicesHero extends StatelessWidget {
  const NoDevicesHero({super.key, this.size = 176});

  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ExcludeSemantics(
      child: PulseRipple(
        size: size,
        rings: 3,
        sweep: true,
        child: SizedBox(
          width: size * 0.42,
          height: size * 0.42,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size * 0.42,
                height: size * 0.42,
                decoration: BoxDecoration(
                  gradient: AppColors.mainGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.glow(AppColors.primary),
                ),
                child: Icon(Iconsax.monitor_copy, color: Colors.white, size: size * 0.18),
              ),
              PositionedDirectional(
                end: -2,
                bottom: -2,
                child: Container(
                  width: size * 0.17,
                  height: size * 0.17,
                  decoration: BoxDecoration(
                    color: p.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: p.surface, width: 2),
                  ),
                  child: Icon(Icons.close_rounded, color: Colors.white, size: size * 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "No TV found" title, hint and the plain bullet checklist.
class NoDevicesContent extends StatelessWidget {
  const NoDevicesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.l10n.noTvFound, style: context.text.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 2),
        Text(
          context.l10n.checkThatYourPhone,
          textAlign: TextAlign.center,
          style: context.text.bodySmall?.copyWith(fontSize: 12.5),
        ),
        const SizedBox(height: AppSpace.md),
        for (final (_, title, body) in _checks)
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
          ),
      ],
    );
  }
}

/// Hotspot text link plus the Scan again / How to connect buttons.
class NoDevicesActions extends StatelessWidget {
  const NoDevicesActions({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const StillCantFindCard(),
        const SizedBox(height: AppSpace.xs),
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
    );
  }
}
