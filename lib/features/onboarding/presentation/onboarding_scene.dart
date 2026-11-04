import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

enum SceneKind { mirror, media, web, hotspot }

/// Animated onboarding artwork: a phone sending content to a TV. Each slide
/// shows its own story (mirroring, media flying over, a web video cast).
class OnboardingScene extends StatefulWidget {
  const OnboardingScene({super.key, required this.kind, required this.size, this.playing = true});

  final SceneKind kind;
  final double size;

  /// False shows a still, finished frame.
  final bool playing;

  @override
  State<OnboardingScene> createState() => _OnboardingSceneState();
}

class _OnboardingSceneState extends State<OnboardingScene> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(OnboardingScene old) {
    super.didUpdateWidget(old);
    if (old.playing != widget.playing) _sync();
  }

  void _sync() {
    if (!widget.playing || context.reduceMotion) {
      _c
        ..stop()
        ..value = 0.85; // a calm, finished frame
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return ExcludeSemantics(
      child: SizedBox(
        width: s,
        height: s * 0.86,
        child: AnimatedBuilder(animation: _c, builder: (context, _) => _frame(context, _c.value, s)),
      ),
    );
  }

  Widget _frame(BuildContext context, double t, double s) {
    final p = context.palette;
    final tvW = s * 0.66, tvH = tvW * 0.6;
    final tvLeft = s - tvW - s * 0.02, tvTop = s * 0.04;
    final phW = s * 0.25, phH = phW * 1.95;
    final phLeft = s * 0.04, phTop = s * 0.86 - phH - s * 0.02;
    final from = Offset(phLeft + phW * 0.7, phTop + phH * 0.2);
    final to = Offset(tvLeft + tvW * 0.35, tvTop + tvH * 0.9);
    final ctrl = Offset((from.dx + to.dx) / 2 - s * 0.02, math.min(from.dy, to.dy) - s * 0.02);

    // Phase within a cycle: send (0–0.45), arrive (0.45–0.6), show (0.6–1).
    final arrived = Curves.easeOut.transform(((t - 0.45) / 0.15).clamp(0.0, 1.0));
    final glow = 0.5 + 0.5 * math.sin(t * math.pi * 2);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Soft pulsing halo behind the devices.
        Positioned(
          left: s * 0.12,
          top: s * 0.02,
          child: Container(
            width: s * 0.8,
            height: s * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  p.primary.withValues(alpha: 0.10 + 0.08 * glow),
                  p.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        // TV
        Positioned(
          left: tvLeft,
          top: tvTop,
          child: _Tv(width: tvW, height: tvH, lit: arrived, child: _tvContent(context, t, arrived, tvW, tvH)),
        ),
        // Beam: travelling dots along a curve from phone to TV.
        Positioned.fill(
          child: CustomPaint(
            painter: _BeamPainter(from: from, ctrl: ctrl, to: to, t: t, color: p.primary),
          ),
        ),
        if (widget.kind == SceneKind.media && t < 0.5) _flyingCard(t, from, ctrl, to, s),
        // Phone
        Positioned(
          left: phLeft,
          top: phTop,
          child: _Phone(width: phW, height: phH, child: _phoneContent(context, t, phW, phH)),
        ),
        // Connected badge pops in when content arrives.
        Positioned(
          left: tvLeft + tvW - s * 0.07,
          top: tvTop - s * 0.04,
          child: Transform.scale(
            scale: Curves.easeOutBack.transform(arrived),
            child: Container(
              width: s * 0.1,
              height: s * 0.1,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: p.surface, width: 3),
              ),
              child: Icon(Icons.check_rounded, color: Colors.white, size: s * 0.055),
            ),
          ),
        ),
      ],
    );
  }

  static const _media = [
    (Iconsax.gallery_copy, [Color(0xFFFF9F7A), Color(0xFFF0603A)]),
    (Iconsax.video_play_copy, [Color(0xFF818CF8), Color(0xFF6D28D9)]),
    (Iconsax.music_copy, [Color(0xFF34D399), Color(0xFF0E9F6E)]),
  ];

  int get _mediaIndex => (_c.lastElapsedDuration?.inMilliseconds ?? 0) ~/ 2800 % _media.length;

  Widget _flyingCard(double t, Offset from, Offset ctrl, Offset to, double s) {
    final k = Curves.easeInOut.transform((t / 0.5).clamp(0.0, 1.0));
    final pos = _bezier(from, ctrl, to, k);
    final size = s * (0.12 + 0.05 * k);
    final m = _media[_mediaIndex];
    return Positioned(
      left: pos.dx - size / 2,
      top: pos.dy - size / 2,
      child: Transform.rotate(
        angle: (1 - k) * -0.3,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: m.$2),
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [BoxShadow(color: m.$2.last.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Icon(m.$1, color: Colors.white, size: size * 0.5),
        ),
      ),
    );
  }

  Widget _phoneContent(BuildContext context, double t, double w, double h) {
    switch (widget.kind) {
      case SceneKind.mirror:
        return _MiniUi(scale: w / 70, highlight: t);
      case SceneKind.media:
        return Padding(
          padding: EdgeInsets.all(w * 0.08),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: w * 0.06,
            crossAxisSpacing: w * 0.06,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 0; i < 6; i++)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _media[i % 3].$2),
                    borderRadius: BorderRadius.circular(w * 0.06),
                  ),
                  child: Opacity(
                    opacity: i == _mediaIndex && t < 0.5 ? 0.3 : 1,
                    child: Icon(_media[i % 3].$1, color: Colors.white, size: w * 0.18),
                  ),
                ),
            ],
          ),
        );
      case SceneKind.web:
        final pulse = 1 + 0.12 * math.sin(t * math.pi * 4).abs();
        return Column(
          children: [
            Container(
              margin: EdgeInsets.all(w * 0.07),
              height: h * 0.07,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(h)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: w * 0.07),
              height: h * 0.28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFE62117)]),
                borderRadius: BorderRadius.circular(w * 0.06),
              ),
              child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: w * 0.3),
            ),
            for (var i = 0; i < 3; i++)
              Container(
                margin: EdgeInsets.fromLTRB(w * 0.07, h * 0.04, w * (0.07 + 0.12 * i), 0),
                height: h * 0.035,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(h)),
              ),
            const Spacer(),
            // The browser's Cast button, pulsing with a "1 video" badge.
            Padding(
              padding: EdgeInsets.only(bottom: h * 0.05),
              child: Transform.scale(
                scale: pulse,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.12, vertical: h * 0.02),
                      decoration: BoxDecoration(
                        gradient: AppColors.mainGradient,
                        borderRadius: BorderRadius.circular(h),
                      ),
                      child: Icon(Iconsax.screenmirroring_copy, color: Colors.white, size: w * 0.16),
                    ),
                    Positioned(
                      right: -w * 0.05,
                      top: -w * 0.05,
                      child: Container(
                        width: w * 0.14,
                        height: w * 0.14,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                        child: Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: w * 0.09, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case SceneKind.hotspot:
        // Hotspot switch flips on, then the hotspot icon starts broadcasting.
        final on = t > 0.18;
        final wave = (t * 3) % 1;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: w * 0.7,
              height: w * 0.7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (on)
                    for (final k in [0.0, 0.5])
                      Container(
                        width: w * (0.3 + 0.4 * ((wave + k) % 1)),
                        height: w * (0.3 + 0.4 * ((wave + k) % 1)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 1 - (wave + k) % 1), width: 1.5),
                        ),
                      ),
                  Icon(Icons.wifi_tethering_rounded, color: Colors.white, size: w * 0.3),
                ],
              ),
            ),
            SizedBox(height: h * 0.05),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: w * 0.42,
              height: w * 0.22,
              padding: EdgeInsets.all(w * 0.025),
              alignment: on ? Alignment.centerRight : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: on ? const Color(0xFF22C55E) : Colors.white24,
                borderRadius: BorderRadius.circular(w),
              ),
              child: Container(
                width: w * 0.17,
                height: w * 0.17,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ],
        );
    }
  }

  Widget _tvContent(BuildContext context, double t, double arrived, double w, double h) {
    final Widget content;
    switch (widget.kind) {
      case SceneKind.mirror:
        content = _MiniUi(scale: w / 120, highlight: t, wide: true);
      case SceneKind.media:
        final m = _media[_mediaIndex];
        content = Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: m.$2)),
          child: Icon(m.$1, color: Colors.white, size: h * 0.4),
        );
      case SceneKind.web:
        final progress = ((t - 0.55) / 0.45).clamp(0.0, 1.0);
        content = Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1F2340), Color(0xFF0B0D1A)])),
          child: Stack(
            children: [
              Center(
                child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: h * 0.36),
              ),
              Positioned(
                left: w * 0.06,
                right: w * 0.06,
                bottom: h * 0.08,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: h * 0.04,
                    backgroundColor: Colors.white24,
                    color: const Color(0xFFE62117),
                  ),
                ),
              ),
            ],
          ),
        );
      case SceneKind.hotspot:
        content = Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1F2340), Color(0xFF0B0D1A)])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_rounded, color: Colors.white, size: h * 0.3),
              SizedBox(height: h * 0.04),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: const Color(0xFF22C55E), size: h * 0.14),
                  SizedBox(width: w * 0.02),
                  Text(
                    'CastFlow',
                    style: TextStyle(color: Colors.white, fontSize: h * 0.1, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        );
    }
    return Opacity(
      opacity: arrived,
      child: Transform.scale(scale: 0.9 + 0.1 * arrived, child: content),
    );
  }
}

Offset _bezier(Offset a, Offset c, Offset b, double t) {
  final u = 1 - t;
  return a * (u * u) + c * (2 * u * t) + b * (t * t);
}

class _BeamPainter extends CustomPainter {
  _BeamPainter({required this.from, required this.ctrl, required this.to, required this.t, required this.color});

  final Offset from, ctrl, to;
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..quadraticBezierTo(ctrl.dx, ctrl.dy, to.dx, to.dy);
    // Faint dashed track.
    final track = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (final m in path.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 10) {
        canvas.drawPath(m.extractPath(d, d + 5), track);
      }
    }
    // Five glowing dots streaming towards the TV.
    for (var i = 0; i < 5; i++) {
      final k = (t * 1.6 - i * 0.12) % 1.0;
      if (k < 0 || k > 1) continue;
      final pos = _bezier(from, ctrl, to, k);
      final fade = math.sin(k * math.pi);
      canvas.drawCircle(pos, 8, Paint()..color = color.withValues(alpha: 0.15 * fade));
      canvas.drawCircle(pos, 4, Paint()..color = color.withValues(alpha: 0.9 * fade));
    }
  }

  @override
  bool shouldRepaint(_BeamPainter old) => old.t != t || old.color != color;
}

class _Tv extends StatelessWidget {
  const _Tv({required this.width, required this.height, required this.child, required this.lit});
  final double width, height, lit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      children: [
        Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(width * 0.03),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1D2E),
            borderRadius: BorderRadius.circular(width * 0.05),
            boxShadow: [
              BoxShadow(
                color: p.primary.withValues(alpha: 0.1 + 0.25 * lit),
                blurRadius: 24,
                spreadRadius: 2 * lit,
              ),
              BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 6)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width * 0.03),
            child: ColoredBox(
              color: const Color(0xFF0B0D1A),
              child: SizedBox.expand(child: child),
            ),
          ),
        ),
        Container(width: width * 0.06, height: height * 0.1, color: const Color(0xFF2B2E45)),
        Container(
          width: width * 0.34,
          height: height * 0.05,
          decoration: BoxDecoration(color: const Color(0xFF2B2E45), borderRadius: BorderRadius.circular(8)),
        ),
      ],
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.width, required this.height, required this.child});
  final double width, height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(width * 0.06),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1D2E),
        borderRadius: BorderRadius.circular(width * 0.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.22), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * 0.15),
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.mainGradient),
          child: child,
        ),
      ),
    );
  }
}

/// A tiny app screen (header, card, rows) drawn the same on phone and TV.
class _MiniUi extends StatelessWidget {
  const _MiniUi({required this.scale, required this.highlight, this.wide = false});
  final double scale;
  final double highlight;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final bar = Color.lerp(Colors.white24, Colors.white54, (math.sin(highlight * math.pi * 2) + 1) / 2)!;
    Widget row(double widthFactor) => FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 5 * scale,
        margin: EdgeInsets.only(top: 5 * scale),
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
      ),
    );
    return Container(
      decoration: wide ? const BoxDecoration(gradient: AppColors.mainGradient) : null,
      padding: EdgeInsets.all(7 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10 * scale,
                height: 10 * scale,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
              SizedBox(width: 5 * scale),
              Expanded(
                child: Container(
                  height: 5 * scale,
                  decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ),
          SizedBox(height: 7 * scale),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: bar, borderRadius: BorderRadius.circular(6 * scale)),
              child: Icon(Iconsax.play_circle_copy, color: Colors.white, size: 18 * scale),
            ),
          ),
          row(0.9),
          row(0.6),
          if (!wide) row(0.75),
        ],
      ),
    );
  }
}
