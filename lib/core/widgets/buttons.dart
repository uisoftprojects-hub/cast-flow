import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'tap_scale.dart';

/// Primary pill button with the main gradient fill.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.gradient = AppColors.mainGradient,
    this.foreground = Colors.white,
    this.loading = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final Gradient gradient;
  final Color foreground;
  final bool loading;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return TapScale(
      onTap: enabled ? onPressed : null,
      semanticLabel: label,
      child: AnimatedOpacity(
        duration: AppDurations.fast,
        opacity: enabled || loading ? 1 : 0.5,
        child: Container(
          constraints: BoxConstraints(minHeight: compact ? 40 : 54, minWidth: kMinTap),
          padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 26, vertical: compact ? 8 : 14),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: enabled && !compact ? AppShadows.glow(AppColors.primary) : null,
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: foreground))
              else if (icon != null)
                Icon(icon, color: foreground, size: 20),
              if (loading || icon != null) const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: (compact ? context.text.labelMedium : context.text.labelLarge)?.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Secondary pill button: tinted background with primary text.
class TintedButton extends StatelessWidget {
  const TintedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.color,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final Color? color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final fg = color ?? p.primary;
    final bg = color == null ? p.primaryTint : color!.withValues(alpha: 0.16);
    return TapScale(
      onTap: onPressed,
      semanticLabel: label,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1,
        child: Container(
          constraints: BoxConstraints(minHeight: compact ? 40 : 52, minWidth: kMinTap),
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 24, vertical: compact ? 8 : 13),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.pill)),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, color: fg, size: compact ? 16 : 20), const SizedBox(width: 8)],
              Flexible(
                child: Text(label, style: context.text.labelMedium?.copyWith(color: fg)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Round icon-only button with a 48px minimum tap target.
class SoftIconButton extends StatelessWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = kMinTap,
    this.filled = false,
    this.color,
    this.background,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final double size;
  final bool filled;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Tooltip(
      message: tooltip,
      child: TapScale(
        onTap: onPressed,
        semanticLabel: tooltip,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: filled ? AppColors.mainGradient : null,
            color: filled ? null : (background ?? p.surface),
            boxShadow: filled ? AppShadows.glow(AppColors.primary) : AppShadows.soft(p),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: size * 0.44, color: filled ? Colors.white : (color ?? p.textPrimary)),
        ),
      ),
    );
  }
}
