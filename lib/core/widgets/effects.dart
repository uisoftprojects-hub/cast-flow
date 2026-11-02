import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Expanding concentric rings — used for the device radar and the live pulse.
class PulseRipple extends StatefulWidget {
  const PulseRipple({
    super.key,
    required this.child,
    this.size = 260,
    this.color,
    this.rings = 3,
    this.active = true,
    this.duration = const Duration(milliseconds: 2400),
    this.sweep = false,
  });

  final Widget child;
  final double size;
  final Color? color;
  final int rings;
  final bool active;
  final Duration duration;

  /// Draws a rotating radar sweep on top of the rings.
  final bool sweep;

  @override
  State<PulseRipple> createState() => _PulseRippleState();
}

class _PulseRippleState extends State<PulseRipple> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration);

  /// Loops only while active, and never when the OS asks for reduced motion
  /// (the rings then stay visible but still).
  void _sync() {
    final animate = widget.active && !MediaQuery.disableAnimationsOf(context);
    if (animate && !_c.isAnimating) {
      _c.repeat();
    } else if (!animate && _c.isAnimating) {
      _c.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(PulseRipple old) {
    super.didUpdateWidget(old);
    _sync();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.palette.primary;
    return SizedBox.square(
      dimension: widget.size,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _RipplePainter(_c, color, widget.rings, widget.active, widget.sweep),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter(this.anim, this.color, this.rings, this.active, this.sweep) : super(repaint: anim);

  final Animation<double> anim;
  final Color color;
  final int rings;
  final bool active;
  final bool sweep;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxR = size.shortestSide / 2;

    // Static guide circles.
    final guide = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color.withValues(alpha: 0.12);
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, maxR * i / 3, guide);
    }
    if (!active) return;

    for (var i = 0; i < rings; i++) {
      final t = (anim.value + i / rings) % 1.0;
      final r = maxR * (0.25 + 0.75 * t);
      canvas.drawCircle(
        center,
        r,
        Paint()..color = color.withValues(alpha: (1 - t) * 0.18),
      );
    }

    if (sweep) {
      final angle = anim.value * 2 * math.pi;
      final rect = Rect.fromCircle(center: center, radius: maxR);
      final shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi / 2,
        colors: [color.withValues(alpha: 0), color.withValues(alpha: 0.28)],
        transform: GradientRotation(angle - math.pi / 2),
      ).createShader(rect);
      canvas.drawArc(rect, angle - math.pi / 2, math.pi / 2, true, Paint()..shader = shader);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.active != active || old.color != color;
}

/// Frosted glass panel (blur + translucent surface).
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.xl),
    this.radius = AppRadius.xl,
    this.blur = 20,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: p.glass,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: context.isDark ? 0.06 : 0.6)),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Soft gradient placeholder artwork generated from a seed. Stands in for
/// real thumbnails until media comes from photo_manager / the network.
class MediaArt extends StatelessWidget {
  const MediaArt({
    super.key,
    required this.seed,
    this.icon,
    this.radius = AppRadius.md,
    this.iconSize = 28,
    this.child,
  });

  final int seed;
  final IconData? icon;
  final double radius;
  final double iconSize;
  final Widget? child;

  static const _pairs = [
    [Color(0xFF6366F1), Color(0xFF4338CA)],
    [Color(0xFF34D399), Color(0xFF0E9F6E)],
    [Color(0xFFFF9F7A), Color(0xFFF0603A)],
    [Color(0xFF818CF8), Color(0xFF6D28D9)],
    [Color(0xFFFBBF24), Color(0xFFEA8A06)],
    [Color(0xFF38BDF8), Color(0xFF0369A1)],
    [Color(0xFFC084FC), Color(0xFF7E22CE)],
    [Color(0xFFF472B6), Color(0xFFBE185D)],
  ];

  @override
  Widget build(BuildContext context) {
    final pair = _pairs[seed.abs() % _pairs.length];
    final rnd = math.Random(seed);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1 + rnd.nextDouble(), -1),
            end: Alignment(1, 1 - rnd.nextDouble()),
            colors: pair,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -20 + rnd.nextDouble() * 20,
              bottom: -30 + rnd.nextDouble() * 20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.18)),
              ),
            ),
            Positioned(
              left: -14,
              top: -14 + rnd.nextDouble() * 10,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.14)),
              ),
            ),
            if (icon != null) Center(child: Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: iconSize)),
            ?child,
          ],
        ),
      ),
    );
  }
}
