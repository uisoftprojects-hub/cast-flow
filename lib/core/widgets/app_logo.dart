import 'package:flutter/material.dart';

import '../l10n.dart';

/// CastFlow mark: a phone sending waves to a TV.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96, this.color = Colors.white, this.background});

  final double size;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.castflowLogo,
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background ?? Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(size * 0.3),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.2),
        ),
        child: CustomPaint(painter: _LogoPainter(color)),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round;

    // TV
    final tv = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.36, w * 0.24, w * 0.44, w * 0.32),
      Radius.circular(w * 0.06),
    );
    canvas.drawRRect(tv, stroke);
    canvas.drawLine(Offset(w * 0.50, w * 0.64), Offset(w * 0.66, w * 0.64), stroke);

    // Phone
    final phone = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, w * 0.42, w * 0.18, w * 0.34),
      Radius.circular(w * 0.05),
    );
    canvas.drawRRect(phone, Paint()..color = color);
    canvas.drawCircle(Offset(w * 0.27, w * 0.70), w * 0.018, Paint()..color = const Color(0xFF4F46E5));

    // Waves
    for (var i = 0; i < 2; i++) {
      final r = w * (0.08 + i * 0.07);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(w * 0.36, w * 0.42), radius: r),
        -1.45,
        1.15,
        false,
        stroke..color = color.withValues(alpha: 1 - i * 0.35),
      );
    }
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.color != color;
}
