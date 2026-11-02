import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'tap_scale.dart';

/// Segmented pill selector (e.g. Auto / 480p / 720p / 1080p).
class SegmentedPills<T> extends StatelessWidget {
  const SegmentedPills({
    super.key,
    required this.values,
    required this.selected,
    required this.onChanged,
    required this.labelOf,
  });

  final List<T> values;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T) labelOf;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppShadows.soft(p),
      ),
      child: Row(
        children: [
          for (final v in values)
            Expanded(
              child: Semantics(
                selected: v == selected,
                button: true,
                label: labelOf(v),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(v),
                  child: AnimatedContainer(
                    duration: AppDurations.medium,
                    curve: Curves.easeOutCubic,
                    constraints: const BoxConstraints(minHeight: 44),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: v == selected ? AppColors.mainGradient : null,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      labelOf(v),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelMedium?.copyWith(
                        color: v == selected ? Colors.white : p.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// On/off chip with an icon (Audio, Auto-rotate, …).
class ToggleChip extends StatelessWidget {
  const ToggleChip({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.offIcon,
  });

  final String label;
  final IconData icon;
  final IconData? offIcon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      toggled: value,
      child: TapScale(
        onTap: () => onChanged(!value),
        semanticLabel: label,
        child: AnimatedContainer(
          duration: AppDurations.medium,
          constraints: const BoxConstraints(minHeight: kMinTap),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: value ? p.primaryTint : p.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: value ? p.primary.withValues(alpha: 0.35) : p.divider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(value ? icon : (offIcon ?? icon), size: 18, color: value ? p.primary : p.textSecondary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: context.text.labelMedium?.copyWith(color: value ? p.primary : p.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small rounded label (badges such as "Best value", "4K", "Live").
class SoftBadge extends StatelessWidget {
  const SoftBadge(this.label, {super.key, this.color, this.textColor, this.icon});

  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: textColor ?? AppColors.textPrimary), const SizedBox(width: 4)],
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: textColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
