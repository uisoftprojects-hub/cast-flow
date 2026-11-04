import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';

import '../../../../core/l10n.dart';

const _steps = [
  (
    Iconsax.wifi_copy,
    'Join the same Wi-Fi',
    'Connect your phone and your TV to the same Wi-Fi network.',
    _WifiVisual(),
  ),
  (
    Iconsax.monitor_copy,
    'Turn on casting on your TV',
    'Enable Screen Mirroring, Miracast or Google Cast in the TV settings.',
    _TvSettingVisual(),
  ),
  (
    Iconsax.radar_2_copy,
    'Scan for devices',
    'Open Devices in CastFlow and wait a few seconds for your TV to appear.',
    _ScanVisual(),
  ),
  (
    Iconsax.tick_circle_copy,
    'Tap Connect',
    'Accept the prompt on your TV if one appears. That’s it!',
    _ConnectVisual(),
  ),
];

Future<void> showConnectionGuide(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => const SafeArea(top: false, child: ConnectionGuideSheet()),
  );
}

/// "How to connect": four illustrated steps, each with a small animated
/// picture of what the user should see on the phone and the TV.
class ConnectionGuideSheet extends StatelessWidget {
  const ConnectionGuideSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(AppSpace.xl, 0, AppSpace.xl, AppSpace.xxl),
        children: [
          Text(context.l10n.howToConnect, style: context.text.headlineMedium),
          const SizedBox(height: AppSpace.xs),
          Text(context.l10n.fourQuickStepsTo, style: context.text.bodyMedium),
          const SizedBox(height: AppSpace.xl),
          for (final (i, (icon, title, body, visual)) in _steps.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.lg),
              child: _StepCard(
                number: i + 1,
                icon: icon,
                title: context.tr(title),
                body: context.tr(body),
                visual: visual,
              ),
            ).animate(delay: (90 * i).ms).fadeIn().slideY(begin: 0.06, end: 0),
          GradientButton(label: context.l10n.gotIt, expand: true, onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
    required this.visual,
  });

  final int number;
  final IconData icon;
  final String title;
  final String body;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      container: true,
      label: context.l10n.step(number, title, body),
      child: ExcludeSemantics(
        child: Container(
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: p.divider),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 168,
                color: p.primaryTint,
                alignment: Alignment.center,
                child: FittedBox(
                  child: Padding(padding: const EdgeInsets.all(AppSpace.md), child: visual),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(gradient: AppColors.mainGradient, shape: BoxShape.circle),
                      child: Text('$number', style: context.text.labelLarge?.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, size: 18, color: p.primary),
                              const SizedBox(width: 6),
                              Expanded(child: Text(title, style: context.text.titleSmall)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(body, style: context.text.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small drawn devices shared by the step pictures.

const _bezel = Color(0xFF1B1D2E);
const _tvScreen = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF2A2E4A), Color(0xFF0E1022)],
);

class _Phone extends StatelessWidget {
  const _Phone({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 140,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: _bezel, borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // Long translations (e.g. Arabic) shrink to fit instead of overflowing.
        child: ColoredBox(
          color: context.palette.surface,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 66), child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tv extends StatelessWidget {
  const _Tv({required this.child, this.width = 150});
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: width * 0.6,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: _bezel, borderRadius: BorderRadius.circular(8)),
          child: Container(
            decoration: BoxDecoration(gradient: _tvScreen, borderRadius: BorderRadius.circular(5)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width - 12),
                child: child,
              ),
            ),
          ),
        ),
        Container(width: 10, height: 8, color: const Color(0xFF2B2E45)),
        Container(
          width: width * 0.36,
          height: 5,
          decoration: BoxDecoration(color: const Color(0xFF2B2E45), borderRadius: BorderRadius.circular(3)),
        ),
      ],
    );
  }
}

class _WifiTag extends StatelessWidget {
  const _WifiTag({this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = dark ? Colors.white : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: dark ? Colors.white12 : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      // Shrinks to fit the phone or TV screen in any language.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.wifi_copy, size: 10, color: color),
            const SizedBox(width: 3),
            Text(
              context.l10n.homeWiFi,
              maxLines: 1,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// Step 1: phone and TV both on "Home Wi-Fi", with the router between them.
class _WifiVisual extends StatelessWidget {
  const _WifiVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Phone(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.wifi_copy, size: 26, color: p.primary),
              const SizedBox(height: 6),
              const _WifiTag(),
              const SizedBox(height: 4),
              Icon(Icons.check_circle_rounded, size: 14, color: p.success),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.wifi_copy,
              size: 30,
              color: AppColors.primary,
            ).animate(onPlay: (c) => context.loopMotion(c, reverse: true)).fade(begin: 0.35, end: 1, duration: 800.ms),
            const SizedBox(height: 4),
            Container(
              width: 46,
              height: 16,
              decoration: BoxDecoration(color: _bezel, borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: const BoxDecoration(color: Color(0xFF3DDC97), shape: BoxShape.circle),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(context.l10n.router, style: context.text.labelSmall),
          ],
        ),
        const SizedBox(width: 14),
        _Tv(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.wifi_copy, size: 24, color: Colors.white),
              const SizedBox(height: 6),
              const _WifiTag(dark: true),
              const SizedBox(height: 4),
              Icon(Icons.check_circle_rounded, size: 14, color: p.success),
            ],
          ),
        ),
      ],
    );
  }
}

// Step 2: the TV's settings with Screen Mirroring switched on.
class _TvSettingVisual extends StatelessWidget {
  const _TvSettingVisual();

  @override
  Widget build(BuildContext context) {
    Widget row(IconData icon, String label, {bool on = false}) => Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: on ? Colors.white : Colors.white10, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 12, color: on ? AppColors.primary : Colors.white70),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: on ? AppColors.primary : Colors.white70,
              ),
            ),
          ),
          if (on)
            Container(
              width: 24,
              height: 13,
              padding: const EdgeInsets.all(2),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(gradient: AppColors.mainGradient, borderRadius: BorderRadius.circular(8)),
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );

    return _Tv(
      width: 230,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.settingsConnection,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 6),
            row(Iconsax.monitor_copy, context.l10n.inputHdmi1),
            row(Iconsax.screenmirroring_copy, context.l10n.screenMirroring, on: true)
                .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 700.ms),
            row(Iconsax.wifi_copy, context.l10n.networkHomeWiFi),
          ],
        ),
      ),
    );
  }
}

// Step 3: CastFlow scanning, with the TV showing up in the list.
class _ScanVisual extends StatelessWidget {
  const _ScanVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Phone(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                const SizedBox(height: 4),
                SizedBox(
                  width: 54,
                  height: 54,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: p.primary, width: 2),
                            ),
                          )
                          .animate(onPlay: (c) => context.loopMotion(c))
                          .scale(begin: const Offset(0.3, 0.3), end: const Offset(1, 1), duration: 1400.ms)
                          .fadeOut(duration: 1400.ms),
                      Icon(Iconsax.radar_2_copy, size: 22, color: p.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.primaryTint,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: p.primary),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.monitor_copy, size: 10, color: p.primary),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          context.l10n.livingRoomTv,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: p.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ).animate(onPlay: (c) => context.loopMotion(c, reverse: true)).fadeIn(duration: 900.ms),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 4; i++)
              Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                  )
                  .animate(onPlay: (c) => context.loopMotion(c, reverse: true), delay: (150 * i).ms)
                  .fade(begin: 0.2, end: 1, duration: 600.ms),
          ],
        ),
        const SizedBox(width: 18),
        const _Tv(
          child: Center(child: Icon(Iconsax.screenmirroring_copy, size: 30, color: Colors.white)),
        ),
      ],
    );
  }
}

// Step 4: tap Connect on the phone, then Allow on the TV if it asks.
class _ConnectVisual extends StatelessWidget {
  const _ConnectVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Phone(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.monitor_copy, size: 24, color: p.primary),
                const SizedBox(height: 4),
                Text(
                  context.l10n.livingRoomTv,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: p.textPrimary),
                ),
                const SizedBox(height: 8),
                Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: AppColors.mainGradient,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        context.l10n.connect,
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    )
                    .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(0.9, 0.9), duration: 700.ms),
                const SizedBox(height: 2),
                const Icon(Icons.touch_app_rounded, size: 18, color: Color(0xFFFFB020)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 22),
        _Tv(
          child: Center(
            child: Container(
              width: 104,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.allowCastflowToConnect,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: Color(0xFF1B1D2E)),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(context.l10n.deny, style: TextStyle(fontSize: 7, color: Color(0xFF8A8FA8))),
                      Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              gradient: AppColors.mainGradient,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              context.l10n.allow,
                              style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          )
                          .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                          .scale(begin: const Offset(1, 1), end: const Offset(1.12, 1.12), duration: 700.ms),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
