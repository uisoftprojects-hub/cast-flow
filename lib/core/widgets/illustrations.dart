import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum IllustrationKind { mirror, media, web }

/// Soft vector illustrations built from widgets (no image assets needed).
class CastIllustration extends StatelessWidget {
  const CastIllustration({super.key, required this.kind, this.size = 280, this.onGradient = false});

  final IllustrationKind kind;
  final double size;

  /// Draw for placement on the gradient hero card (white strokes).
  final bool onGradient;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final tvColor = onGradient ? Colors.white.withValues(alpha: 0.25) : p.surface;
    final s = size;

    Widget bubble(IconData icon, Color color, double d) => Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: p.surface,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Icon(icon, color: color, size: d * 0.45),
    );

    final tv = Container(
      width: s * 0.66,
      height: s * 0.42,
      decoration: BoxDecoration(
        color: tvColor,
        borderRadius: BorderRadius.circular(s * 0.06),
        border: Border.all(color: onGradient ? Colors.white.withValues(alpha: 0.6) : p.primaryTint, width: 4),
        boxShadow: onGradient ? null : [BoxShadow(color: p.shadow, blurRadius: 30, offset: const Offset(0, 12))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(s * 0.04),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: onGradient
                ? null
                : LinearGradient(
                    colors: switch (kind) {
                      IllustrationKind.mirror => [p.primaryTint, AppColors.gradientStart.withValues(alpha: 0.5)],
                      IllustrationKind.media => [AppColors.secondary.withValues(alpha: 0.4), p.primaryTint],
                      IllustrationKind.web => [AppColors.accent.withValues(alpha: 0.35), p.primaryTint],
                    },
                  ),
          ),
          child: Center(
            child: Icon(
              switch (kind) {
                IllustrationKind.mirror => Iconsax.mobile_copy,
                IllustrationKind.media => Iconsax.play_circle_copy,
                IllustrationKind.web => Iconsax.global_copy,
              },
              size: s * 0.14,
              color: onGradient ? Colors.white : p.primary,
            ),
          ),
        ),
      ),
    );

    final stand = Container(
      width: s * 0.2,
      height: 6,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: onGradient ? Colors.white.withValues(alpha: 0.5) : p.primaryTint,
        borderRadius: BorderRadius.circular(4),
      ),
    );

    final phone = Container(
      width: s * 0.2,
      height: s * 0.36,
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(s * 0.045),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: AppShadowsLite.of(p.shadow),
      ),
      child: Center(
        child: Icon(Iconsax.screenmirroring_copy, color: Colors.white, size: s * 0.08),
      ),
    );

    final floaters = switch (kind) {
      IllustrationKind.mirror => <(Alignment, Widget)>[
        (const Alignment(-0.15, -0.95), bubble(Iconsax.wifi_copy, AppColors.primary, s * 0.15)),
      ],
      IllustrationKind.media => [
        (const Alignment(-0.95, -0.85), bubble(Iconsax.gallery_copy, AppColors.primary, s * 0.16)),
        (const Alignment(0.95, -0.95), bubble(Iconsax.music_copy, const Color(0xFF12B886), s * 0.15)),
        (const Alignment(0.85, 0.75), bubble(Iconsax.video_copy, const Color(0xFFFF7A59), s * 0.15)),
      ],
      IllustrationKind.web => [
        (const Alignment(-0.95, -0.8), bubble(Iconsax.youtube_copy, const Color(0xFFFF7A59), s * 0.16)),
        (const Alignment(0.95, -0.9), bubble(Iconsax.link_2_copy, AppColors.primary, s * 0.14)),
      ],
    };

    return SizedBox.square(
      dimension: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!onGradient)
            Container(
              width: s * 0.92,
              height: s * 0.92,
              decoration: BoxDecoration(shape: BoxShape.circle, color: p.primaryTint.withValues(alpha: 0.6)),
            ),
          Align(
            alignment: const Alignment(0.2, -0.25),
            child: Column(mainAxisSize: MainAxisSize.min, children: [tv, stand]),
          ),
          if (kind != IllustrationKind.media)
            Align(
              alignment: const Alignment(-0.72, 0.62),
              child: phone
                  .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                  .moveY(begin: 0, end: -6, duration: 1800.ms, curve: Curves.easeInOut),
            ),
          for (final (i, (align, w)) in floaters.indexed)
            Align(
              alignment: align,
              child: w
                  .animate(onPlay: (c) => context.loopMotion(c, reverse: true), delay: (i * 300).ms)
                  .moveY(begin: 0, end: -8, duration: 2200.ms, curve: Curves.easeInOut),
            ),
        ],
      ),
    );
  }
}

abstract final class AppShadowsLite {
  static List<BoxShadow> of(Color c) => [BoxShadow(color: c, blurRadius: 20, offset: const Offset(0, 8))];
}
