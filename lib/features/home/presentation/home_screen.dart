import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/illustrations.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/presentation/device_providers.dart';
import '../../devices/presentation/widgets/connection_bar.dart';
import '../../settings/presentation/settings_controller.dart';

class _Tile {
  const _Tile(this.title, this.subtitle, this.icon, this.color, this.route);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}

const _media = [
  _Tile('Photos', 'Albums', Iconsax.gallery_copy, AppColors.primary, '/photos'),
  _Tile('Videos', 'Gallery', Iconsax.video_play_copy, Color(0xFFFF7A59), '/videos'),
  _Tile('Music', 'Songs', Iconsax.music_copy, Color(0xFF12B886), '/music'),
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Fixed header: never scrolls with the content.
            const Padding(
              padding: EdgeInsets.fromLTRB(AppSpace.page, AppSpace.lg, AppSpace.page, AppSpace.md),
              child: _Header(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, navBottomPadding(context)),
                children: [
                  const _MirrorCard(),
                  const SizedBox(height: AppSpace.md),
                  const _RemoteAndApps(),
                  const SizedBox(height: AppSpace.xxl),
                  const SectionHeader('Media'),
                  const _MediaRow(),
                  const SizedBox(height: AppSpace.xxl),
                  const SectionHeader('Browse the web'),
                  const _BrowserBar(),
                  const SizedBox(height: AppSpace.xxl),
                  const _HelpBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premium = ref.watch(settingsProvider.select((s) => s.isPremium));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting(), style: context.text.bodyMedium),
                  Text('CastFlow', style: context.text.headlineLarge),
                ],
              ),
            ),
            if (!premium)
              TapScale(
                onTap: () => context.push('/premium'),
                semanticLabel: 'Go Pro',
                child: Container(
                  constraints: const BoxConstraints(minHeight: kMinTap),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1E8),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: const Color(0xFFFFD3BD)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.crown_1_copy, size: 18, color: Color(0xFFE8590C)),
                      const SizedBox(width: 6),
                      Text('PRO', style: context.text.labelMedium?.copyWith(color: const Color(0xFFE8590C))),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpace.md),
        const ConnectionBar(),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _MediaRow extends StatelessWidget {
  const _MediaRow();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, m) in _media.indexed) ...[
            if (i > 0) const SizedBox(width: AppSpace.md),
            Expanded(
              child: SoftCard(
                padding: const EdgeInsets.all(AppSpace.md),
                onTap: () => context.push(m.route),
                semanticLabel: 'Cast ${m.title}',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconBubble(icon: m.icon, color: m.color, size: 44, filled: true),
                    const SizedBox(height: AppSpace.md),
                    Text(m.title, style: context.text.titleSmall),
                    Text(m.subtitle, style: context.text.bodySmall),
                  ],
                ),
              ).animate(delay: (40 * i).ms).fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0),
            ),
          ],
        ],
      ),
    );
  }
}

/// Screen mirroring card.
class _MirrorCard extends ConsumerWidget {
  const _MirrorCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(connectionProvider.select((c) => c.isConnected ? c.device?.name : null));
    return TapScale(
      onTap: () => context.push('/mirror'),
      semanticLabel: 'Screen Mirroring. Start mirroring',
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1B4B), Color(0xFF4338CA)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.glow(const Color(0xFF312E81)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.xl),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Screen Mirroring', style: context.text.headlineMedium?.copyWith(color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(
                      device != null ? 'Ready to mirror to $device' : 'Show your phone on the TV in real time.',
                      style: context.text.bodySmall?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpace.lg),
                    GradientButton(
                      label: 'Start Mirroring',
                      icon: Iconsax.screenmirroring_copy,
                      gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
                      foreground: const Color(0xFF312E81),
                      compact: true,
                      onPressed: () => context.push('/mirror'),
                    ),
                  ],
                ),
              ),
              const ExcludeSemantics(
                child: CastIllustration(kind: IllustrationKind.mirror, size: 96, onGradient: true),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 350.ms);
  }
}

/// Remote and Apps side by side. The remote opens even without a TV (its
/// buttons then lead to device discovery).
class _RemoteAndApps extends ConsumerWidget {
  const _RemoteAndApps();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(connectionProvider.select((c) => c.isConnected ? c.device?.name : null));
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ActionCard(
              icon: Iconsax.mobile_copy,
              color: AppColors.primary,
              title: 'TV Remote',
              subtitle: device ?? 'Control your TV',
              onTap: () => context.push('/remote'),
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: _ActionCard(
              icon: Iconsax.element_3_copy,
              color: const Color(0xFFFF7A59),
              title: 'Apps',
              subtitle: 'YouTube & more',
              onTap: () => context.push('/apps'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(AppSpace.md),
      onTap: onTap,
      semanticLabel: '$title. $subtitle',
      child: Row(
        children: [
          IconBubble(icon: icon, color: color, size: 44, filled: true),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: context.text.titleSmall),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens the browser screen.
class _BrowserBar extends StatelessWidget {
  const _BrowserBar();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return TapScale(
      onTap: () => context.push('/web'),
      semanticLabel: 'Open the browser',
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsetsDirectional.only(start: 16, end: 6),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: p.divider),
          boxShadow: AppShadows.soft(p),
        ),
        child: Row(
          children: [
            Icon(Iconsax.global_copy, size: 20, color: p.textSecondary),
            const SizedBox(width: AppSpace.md),
            Expanded(child: Text('Search or type a website', style: context.text.bodyMedium)),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(gradient: AppColors.mainGradient, shape: BoxShape.circle),
              child: const Icon(Iconsax.search_normal_1_copy, color: Colors.white, size: 19),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpBanner extends StatelessWidget {
  const _HelpBanner();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: () => context.push('/guide'),
      semanticLabel: 'How to connect. Open the visual guide',
      child: Row(
        children: [
          const IconBubble(icon: Iconsax.message_question_copy, color: Color(0xFF12B886), size: 44),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to connect', style: context.text.titleSmall),
                Text('Visual guide for every feature', style: context.text.bodySmall),
              ],
            ),
          ),
          const ForwardChevron(),
        ],
      ),
    );
  }
}
