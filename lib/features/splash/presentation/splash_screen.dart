import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_logo.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../devices/presentation/device_providers.dart';
import '../../settings/presentation/settings_controller.dart';

import '../../../core/l10n.dart';

const _splashDuration = Duration(milliseconds: 2400);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) ref.read(appFlowProvider.notifier).splashShown();
    });
    Future<void>.delayed(_splashDuration, () {
      if (!mounted) return;
      if (ref.read(settingsProvider).firstLaunchCompleted) {
        ref.read(connectionProvider.notifier).autoConnect();
      }
      context.go(ref.read(appFlowProvider.notifier).start());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.mainGradient),
          child: Stack(
            children: [
              // Soft floating blobs.
              PositionedDirectional(top: -60, end: -40, child: _Blob(220, Colors.white.withValues(alpha: 0.12))),
              PositionedDirectional(
                bottom: -80,
                start: -60,
                child: _Blob(260, AppColors.secondary.withValues(alpha: 0.25)),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLogo(size: 112)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack, duration: 700.ms),
                    const SizedBox(height: 24),
                    Text(
                      'CastFlow',
                      style: context.text.headlineLarge?.copyWith(color: Colors.white),
                    ).animate(delay: 300.ms).fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.mirrorCastBeautifullySimple,
                      style: context.text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                    ).animate(delay: 500.ms).fadeIn(duration: 600.ms),
                  ],
                ),
              ),
              // Smooth progress bar filling over the splash time, with the
              // ads notice under it.
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(48, 0, 48, 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: _splashDuration,
                            curve: Curves.easeInOutCubic,
                            builder: (context, v, _) => LinearProgressIndicator(
                              value: v,
                              minHeight: 6,
                              backgroundColor: Colors.white.withValues(alpha: 0.22),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.thisActionMayContain,
                          style: context.text.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob(this.size, this.color);
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        )
        .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
        .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08), duration: 3.seconds, curve: Curves.easeInOut);
  }
}
