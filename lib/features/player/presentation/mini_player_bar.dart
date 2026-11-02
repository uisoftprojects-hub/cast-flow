import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/presentation/device_providers.dart';
import 'player_controller.dart';

/// Compact "now casting" bar. Hidden when nothing is being cast.
class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(playerProvider);
    final device = ref.watch(connectionProvider.select((c) => c.device?.name));
    final media = s.media;
    final p = context.palette;

    return AnimatedSwitcher(
      duration: AppDurations.medium,
      transitionBuilder: (child, a) => SizeTransition(sizeFactor: a, child: FadeTransition(opacity: a, child: child)),
      child: media == null
          ? const SizedBox(width: double.infinity, key: ValueKey('none'))
          : TapScale(
              key: const ValueKey('bar'),
              onTap: () => context.push('/player'),
              semanticLabel: 'Now casting ${media.title}. Open remote',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.soft(p),
                ),
                child: GlassPanel(
                  radius: AppRadius.lg,
                  padding: const EdgeInsets.all(AppSpace.sm),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox.square(
                            dimension: 44,
                            child: MediaArt(seed: media.seed, icon: media.kind.icon, iconSize: 18, radius: AppRadius.sm),
                          ),
                          const SizedBox(width: AppSpace.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(media.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelLarge),
                                Text('Casting to ${device ?? 'TV'}',
                                    maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.bodySmall),
                              ],
                            ),
                          ),
                          SoftIconButton(
                            icon: s.playing ? Iconsax.pause_copy : Iconsax.play_copy,
                            tooltip: s.playing ? 'Pause' : 'Play',
                            filled: true,
                            size: kMinTap,
                            onPressed: ref.read(playerProvider.notifier).toggle,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Stop casting',
                            constraints: const BoxConstraints(minWidth: kMinTap, minHeight: kMinTap),
                            onPressed: ref.read(playerProvider.notifier).stop,
                            icon: Icon(Iconsax.close_circle_copy, color: p.textSecondary),
                          ),
                        ],
                      ),
                      if (media.isTimed)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 6, 4, 2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              minHeight: 3,
                              value: media.duration.inSeconds == 0
                                  ? 0
                                  : s.position.inSeconds / media.duration.inSeconds,
                              backgroundColor: p.primaryTint,
                              color: p.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ).animate().slideY(begin: 0.3, end: 0, duration: AppDurations.medium),
    );
  }
}
