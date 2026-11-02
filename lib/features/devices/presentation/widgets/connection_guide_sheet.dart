import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';

const _steps = [
  (Iconsax.wifi_copy, 'Join the same Wi-Fi', 'Connect your phone and your TV to the same Wi-Fi network.'),
  (Iconsax.monitor_copy, 'Turn on casting on your TV', 'Enable Screen Mirroring, Miracast or Google Cast in the TV settings.'),
  (Iconsax.radar_2_copy, 'Scan for devices', 'Open Devices in CastFlow and wait a few seconds for your TV to appear.'),
  (Iconsax.tick_circle_copy, 'Tap Connect', 'Accept the prompt on your TV if one appears. That’s it!'),
];

Future<void> showConnectionGuide(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const SafeArea(top: false, child: ConnectionGuideSheet()),
  );
}

class ConnectionGuideSheet extends StatelessWidget {
  const ConnectionGuideSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xxl),
        children: [
          Text('How to connect', style: context.text.headlineMedium),
          const SizedBox(height: AppSpace.xs),
          Text('Four quick steps to get on the big screen.', style: context.text.bodyMedium),
          const SizedBox(height: AppSpace.xxl),
          for (final (i, (icon, title, body)) in _steps.indexed)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(gradient: AppColors.mainGradient, shape: BoxShape.circle),
                        child: Text('${i + 1}', style: context.text.labelLarge?.copyWith(color: Colors.white)),
                      ),
                      if (i < _steps.length - 1)
                        Expanded(child: Container(width: 2, margin: const EdgeInsets.symmetric(vertical: 4), color: p.primaryTint)),
                    ],
                  ),
                  const SizedBox(width: AppSpace.lg),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, size: 18, color: p.primary),
                              const SizedBox(width: 8),
                              Expanded(child: Text(title, style: context.text.titleSmall)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(body, style: context.text.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: (90 * i).ms).fadeIn().slideX(begin: 0.05, end: 0),
          const SizedBox(height: AppSpace.sm),
          GradientButton(label: 'Got it', expand: true, onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
