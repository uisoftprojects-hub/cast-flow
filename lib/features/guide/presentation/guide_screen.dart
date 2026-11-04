import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/illustrations.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../onboarding/presentation/onboarding_scene.dart';

import '../../../core/l10n.dart';
part 'mirroring_guide.dart';

class _Guide {
  const _Guide(this.title, this.visual, this.steps);
  final String title;
  final Widget visual;
  final List<String> steps;
}

/// Visual, step-by-step guide for every feature.
class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key, this.topic});

  /// 'mirroring' shows the screen-mirroring walkthrough only.
  final String? topic;

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final _pages = PageController();
  int _page = 0;

  late final _guides = widget.topic == 'mirroring' ? mirroringGuides : _allGuides;

  static final _allGuides = [
    _Guide('Connect to your TV', const _ConnectVisual(), const [
      'Connect your phone and TV to the same Wi-Fi network.',
      'Turn on the TV and open its Screen Mirroring / Cast input.',
      'Tap the connection bar on Home to find your TV.',
      'Tap Connect and accept the prompt on the TV if one appears.',
    ]),
    _Guide('Mirror your screen', const CastIllustration(kind: IllustrationKind.mirror, size: 200), const [
      'Connect to your TV first.',
      'Open Screen Mirroring from Home.',
      'Pick a quality and tap Start.',
      'Allow screen capture when Android asks.',
    ]),
    _Guide('Cast photos, videos & music', const CastIllustration(kind: IllustrationKind.media, size: 200), const [
      'Open Photos, Videos or Music on Home.',
      'Pick what you want to show.',
      'It plays on the TV; control it from your phone or the notification.',
    ]),
    _Guide('Use the TV remote', const _RemoteVisual(), const [
      'Open TV Remote on Home.',
      'Use the D-pad or swipe on the touchpad to move, tap OK to select.',
      'Buttons a TV doesn’t support are greyed out.',
    ]),
    _Guide('Cast from the web & apps', const CastIllustration(kind: IllustrationKind.web, size: 200), const [
      'Tap the browser bar or an app on Home.',
      'Play a video on the site.',
      'Tap “Cast this video” to send it to your TV.',
    ]),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final last = _page == _guides.length - 1;
    return Scaffold(
      appBar: CastAppBar(
        title: widget.topic == 'mirroring' ? context.l10n.screenMirroringHelp : context.l10n.howToConnect,
        showChip: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pages,
              itemCount: _guides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final g = _guides[i];
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.md, AppSpace.page, AppSpace.lg),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 220,
                        child: Center(child: g.visual),
                      ).animate(key: ValueKey(i)).fadeIn(duration: 400.ms).scale(begin: const Offset(0.92, 0.92)),
                      const SizedBox(height: AppSpace.lg),
                      Text(context.tr(g.title), style: context.text.headlineMedium, textAlign: TextAlign.center),
                      const SizedBox(height: AppSpace.xl),
                      for (final (n, step) in g.steps.indexed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpace.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  gradient: AppColors.mainGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: Text('${n + 1}', style: context.text.labelMedium?.copyWith(color: Colors.white)),
                              ),
                              const SizedBox(width: AppSpace.md),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(context.tr(step), style: context.text.bodyLarge),
                                ),
                              ),
                            ],
                          ),
                        ).animate(key: ValueKey('$i$n'), delay: (120 + 80 * n).ms).fadeIn().slideX(begin: 0.05, end: 0),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.lg),
              child: Row(
                children: [
                  for (var i = 0; i < _guides.length; i++)
                    AnimatedContainer(
                      duration: AppDurations.medium,
                      margin: const EdgeInsetsDirectional.only(end: 6),
                      width: i == _page ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: i == _page ? AppColors.mainGradient : null,
                        color: i == _page ? null : p.primaryTint,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  const Spacer(),
                  GradientButton(
                    label: last ? context.l10n.gotIt : context.l10n.next,
                    onPressed: () => last
                        ? Navigator.of(context).maybePop()
                        : _pages.nextPage(duration: AppDurations.slow, curve: Curves.easeOutCubic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectVisual extends StatelessWidget {
  const _ConnectVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PulseRipple(
          size: 150,
          sweep: true,
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(gradient: AppColors.mainGradient, shape: BoxShape.circle),
            child: const Icon(Iconsax.mobile_copy, color: Colors.white),
          ),
        ),
        Icon(Iconsax.wifi_copy, color: p.primary, size: 28),
        const SizedBox(width: AppSpace.md),
        Container(
          width: 72,
          height: 52,
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.primary, width: 2),
          ),
          child: Icon(Iconsax.monitor_copy, color: p.primary),
        ),
      ],
    );
  }
}

class _RemoteVisual extends StatelessWidget {
  const _RemoteVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: p.surface,
        shape: BoxShape.circle,
        border: Border.all(color: p.divider),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final (a, icon) in [
            (Alignment.topCenter, Icons.keyboard_arrow_up_rounded),
            (Alignment.bottomCenter, Icons.keyboard_arrow_down_rounded),
            (Alignment.centerLeft, Icons.keyboard_arrow_left_rounded),
            (Alignment.centerRight, Icons.keyboard_arrow_right_rounded),
          ])
            Align(
              alignment: a,
              child: Padding(padding: const EdgeInsets.all(10), child: Icon(icon, size: 30)),
            ),
          Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: const BoxDecoration(gradient: AppColors.mainGradient, shape: BoxShape.circle),
                child: Text(context.l10n.ok, style: context.text.titleMedium?.copyWith(color: Colors.white)),
              )
              .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(0.9, 0.9), duration: 700.ms),
        ],
      ),
    );
  }
}
