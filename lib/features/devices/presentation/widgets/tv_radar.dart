import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/effects.dart';
import '../../domain/cast_device.dart';

/// Radar scan around the phone. Each TV that is found pops onto the radar
/// ring at its own position, so the user sees discovery happen.
class TvRadar extends StatelessWidget {
  const TvRadar({super.key, required this.scanning, required this.devices, this.size = 220, this.connectedId});

  final bool scanning;
  final List<CastDevice> devices;
  final double size;
  final String? connectedId;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final center = size / 2;
    final ring = size * 0.38;
    const blip = 38.0;

    return Semantics(
      label: scanning ? 'Searching for TVs. ${devices.length} found.' : '${devices.length} TVs found',
      liveRegion: true,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            PulseRipple(
              size: size,
              active: scanning,
              sweep: true,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  gradient: AppColors.mainGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.glow(AppColors.primary),
                ),
                child: Icon(Iconsax.mobile_copy, color: Colors.white, size: size * 0.13),
              ),
            ),
            for (final (i, d) in devices.take(6).indexed)
              Positioned(
                key: ValueKey(d.id),
                // Spread blips around the ring, starting top-right.
                left: center + ring * math.cos(-math.pi / 3 + i * math.pi / 3) - blip / 2,
                top: center + ring * math.sin(-math.pi / 3 + i * math.pi / 3) - blip / 2,
                child: Container(
                  width: blip,
                  height: blip,
                  decoration: BoxDecoration(
                    color: d.id == connectedId ? p.success : p.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: d.id == connectedId ? p.success : p.primary, width: 1.5),
                    boxShadow: AppShadows.soft(p),
                  ),
                  child: Icon(d.type.icon, size: 18, color: d.id == connectedId ? Colors.white : p.primary),
                )
                    .animate()
                    .scale(begin: const Offset(0.2, 0.2), curve: Curves.elasticOut, duration: 700.ms)
                    .fadeIn(duration: 200.ms),
              ),
          ],
        ),
      ),
    );
  }
}
