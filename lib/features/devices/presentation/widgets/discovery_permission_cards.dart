import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../domain/cast_device.dart';

/// Cards explaining and handling each permission and system service state:
/// - Permission required (explains before prompting)
/// - Permission denied (with retry)
/// - Permission permanently denied (with open app settings)
/// - Location services disabled (with open location settings)
class DiscoveryPermissionCard extends StatelessWidget {
  const DiscoveryPermissionCard({
    super.key,
    required this.phase,
    required this.requiresLocation,
    required this.onGrant,
    required this.onOpenSettings,
    required this.onOpenLocationSettings,
    required this.onRecheck,
  });

  final DiscoveryPhase phase;
  final bool requiresLocation;
  final VoidCallback onGrant;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenLocationSettings;
  final VoidCallback onRecheck;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;

    return switch (phase) {
      DiscoveryPhase.permissionRequired => _CardLayout(
        icon: requiresLocation ? Iconsax.location_copy : Iconsax.wifi_square_copy,
        iconColor: p.primary,
        title: l.permissionNeeded,
        message: l.permissionNeededToDiscover,
        primaryAction: GradientButton(
          label: l.allowPermission,
          icon: Iconsax.shield_tick_copy,
          expand: true,
          onPressed: onGrant,
        ),
      ),
      DiscoveryPhase.permissionDenied => _CardLayout(
        icon: Iconsax.danger_copy,
        iconColor: p.warning,
        title: l.permissionNeeded,
        message: l.permissionNeededToDiscover,
        // Android can still show the prompt: ask again.
        primaryAction: GradientButton(
          label: l.allowPermission,
          icon: Iconsax.shield_tick_copy,
          expand: true,
          onPressed: onGrant,
        ),
      ),
      DiscoveryPhase.permissionPermanentlyDenied => _CardLayout(
        icon: Iconsax.security_safe_copy,
        iconColor: p.error,
        title: l.permissionBlockedInSettings,
        message: l.permissionNeededToDiscover,
        // "Don't ask again": only the app's Settings page can turn it on.
        primaryAction: GradientButton(
          label: l.openSettings,
          icon: Iconsax.setting_2_copy,
          expand: true,
          onPressed: onOpenSettings,
        ),
        secondaryAction: TintedButton(
          label: l.checkAgain,
          icon: Iconsax.refresh_copy,
          expand: true,
          onPressed: onRecheck,
        ),
      ),
      DiscoveryPhase.locationServicesDisabled => _CardLayout(
        icon: Iconsax.location_slash_copy,
        iconColor: p.warning,
        title: l.locationServicesDisabled,
        message: l.permissionNeededToDiscover,
        primaryAction: GradientButton(
          label: l.openLocationSettings,
          icon: Iconsax.location_copy,
          expand: true,
          onPressed: onOpenLocationSettings,
        ),
        secondaryAction: TintedButton(
          label: l.checkAgain,
          icon: Iconsax.refresh_copy,
          expand: true,
          onPressed: onRecheck,
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _CardLayout extends StatelessWidget {
  const _CardLayout({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.primaryAction,
    this.secondaryAction,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final Widget primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(AppSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.14), shape: BoxShape.circle),
            child: Icon(icon, size: 34, color: iconColor),
          ).animate().scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack, duration: 400.ms),
          const SizedBox(height: AppSpace.lg),
          Text(title, style: context.text.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: AppSpace.sm),
          Text(message, style: context.text.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: AppSpace.xl),
          primaryAction,
          if (secondaryAction != null) ...[const SizedBox(height: AppSpace.sm), secondaryAction!],
        ],
      ),
    );
  }
}

/// Compact permission indicator for the Devices screen: one icon, one title,
/// one message and one clear action. Replaces the old stack of repeated
/// "permission required" lines.
class DiscoveryPermissionBanner extends StatelessWidget {
  const DiscoveryPermissionBanner({
    super.key,
    required this.phase,
    required this.onGrant,
    required this.onOpenSettings,
    required this.onOpenLocationSettings,
  });

  final DiscoveryPhase phase;
  final VoidCallback onGrant;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenLocationSettings;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;

    final (
      IconData icon,
      Color color,
      String title,
      String actionLabel,
      IconData actionIcon,
      VoidCallback action,
    ) = switch (phase) {
      DiscoveryPhase.permissionPermanentlyDenied => (
        Iconsax.security_safe_copy,
        p.error,
        l.permissionBlockedInSettings,
        l.openSettings,
        Iconsax.setting_2_copy,
        onOpenSettings,
      ),
      DiscoveryPhase.locationServicesDisabled => (
        Iconsax.location_slash_copy,
        p.warning,
        l.locationServicesDisabled,
        l.openLocationSettings,
        Iconsax.location_copy,
        onOpenLocationSettings,
      ),
      _ => (Iconsax.danger_copy, p.warning, l.permissionNeeded, l.allowPermission, Iconsax.shield_tick_copy, onGrant),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.16), shape: BoxShape.circle),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.text.titleSmall),
                    const SizedBox(height: 2),
                    Text(l.permissionNeededToDiscover, style: context.text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          GradientButton(label: actionLabel, icon: actionIcon, expand: true, compact: true, onPressed: action),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.06, end: 0);
  }
}
