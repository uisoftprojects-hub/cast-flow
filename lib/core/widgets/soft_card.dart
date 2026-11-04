import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'tap_scale.dart';

/// Big rounded white card with the soft diffused shadow.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.lg),
    this.radius = AppRadius.lg,
    this.onTap,
    this.color,
    this.gradient,
    this.shadow = true,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? color;
  final Gradient? gradient;
  final bool shadow;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? p.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: gradient == null && color == null ? Border.all(color: p.divider) : null,
        boxShadow: shadow ? AppShadows.soft(p) : null,
      ),
      child: child,
    );
    if (onTap == null) return card;
    return TapScale(onTap: onTap, semanticLabel: semanticLabel, child: card);
  }
}

/// An icon sitting in a tinted rounded square (solid when [filled]).
class IconBubble extends StatelessWidget {
  const IconBubble({super.key, required this.icon, this.color, this.size = 48, this.iconSize, this.filled = false});

  final IconData icon;
  final Color? color;
  final double size;
  final double? iconSize;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.palette.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        color: filled ? c : c.withValues(alpha: context.isDark ? 0.24 : 0.12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize ?? size * 0.46, color: filled ? Colors.white : c),
    );
  }
}

/// "Go forward" chevron: points right in LTR and left in RTL.
class ForwardChevron extends StatelessWidget {
  const ForwardChevron({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    // Icons.chevron_right already mirrors itself in RTL.
    return Icon(Icons.chevron_right_rounded, size: size + 4, color: context.palette.textSecondary);
  }
}

/// Section title with an optional trailing action ("See all").
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpace.md),
      child: Row(
        children: [
          Expanded(child: Text(title, style: context.text.titleLarge)),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(minimumSize: const Size(kMinTap, kMinTap)),
              child: Text(action!, style: context.text.labelMedium?.copyWith(color: context.palette.primary)),
            ),
        ],
      ),
    );
  }
}
