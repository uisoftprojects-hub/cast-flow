import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';

/// Shared body of the Photos / Videos / Music screens: a prompt and a button
/// that opens the system picker (no storage permission required).
class PickerBody extends StatelessWidget {
  const PickerBody({
    super.key,
    required this.icon,
    required this.message,
    required this.label,
    required this.onPick,
    this.secondaryLabel,
    this.secondaryIcon,
    this.onSecondary,
  });

  final IconData icon;
  final String message;
  final String label;
  final VoidCallback onPick;
  final String? secondaryLabel;
  final IconData? secondaryIcon;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: context.palette.primary),
            const SizedBox(height: AppSpace.lg),
            Text(message, textAlign: TextAlign.center, style: context.text.bodyLarge),
            const SizedBox(height: AppSpace.xl),
            GradientButton(label: label, icon: Iconsax.add_copy, expand: true, onPressed: onPick),
            if (onSecondary != null) ...[
              const SizedBox(height: AppSpace.md),
              TintedButton(label: secondaryLabel!, icon: secondaryIcon, onPressed: onSecondary),
            ],
          ],
        ),
      ),
    );
  }
}
