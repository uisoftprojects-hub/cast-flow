import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../player/domain/cast_media.dart';
import '../../player/presentation/mini_player_bar.dart';
import '../../player/presentation/player_controller.dart';
import '../domain/media_models.dart';
import 'media_providers.dart';

import '../../../core/l10n.dart';

class MusicScreen extends ConsumerWidget {
  const MusicScreen({super.key});

  List<CastMedia> _queue(List<SongItem> songs) => [
    for (final s in songs)
      CastMedia(id: s.id, title: s.title, subtitle: s.artist, kind: CastKind.music, seed: s.seed, duration: s.duration),
  ];

  Future<void> _play(BuildContext context, WidgetRef ref, List<SongItem> songs, int index) async {
    if (!await ensureConnected(context, ref)) return;
    ref.read(playerProvider.notifier).play(_queue(songs), index: index);
    // Open the full preview, not just the mini bar.
    if (context.mounted) context.push('/player');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final current = ref.watch(playerProvider.select((s) => s.media?.id));
    final playing = ref.watch(playerProvider.select((s) => s.playing));

    return Scaffold(
      appBar: CastAppBar(title: context.l10n.castMusic),
      body: Stack(
        children: [
          AsyncView<List<SongItem>>(
            value: songs,
            onRetry: () => ref.invalidate(songsProvider),
            isEmpty: (s) => s.isEmpty,
            empty: EmptyState(
              icon: Iconsax.music_square_search_copy,
              title: context.l10n.noMusicFound,
              message: context.l10n.addSongsToYour,
            ),
            data: (items) => ListView(
              padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, 140),
              children: [
                Row(
                  children: [
                    Expanded(child: Text('${items.length} songs', style: context.text.titleLarge)),
                    TintedButton(
                      label: context.l10n.shuffle,
                      icon: Iconsax.shuffle_copy,
                      compact: true,
                      onPressed: () => _play(context, ref, [...items]..shuffle(), 0),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    GradientButton(
                      label: context.l10n.playAll,
                      icon: Iconsax.play_copy,
                      compact: true,
                      onPressed: () => _play(context, ref, items, 0),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.lg),
                for (final (i, s) in items.indexed)
                  _SongRow(
                    song: s,
                    active: s.id == current,
                    playing: playing && s.id == current,
                    onTap: () => _play(context, ref, items, i),
                  ).animate(delay: (40 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0),
              ],
            ),
          ),
          const PositionedDirectional(
            start: AppSpace.page,
            end: AppSpace.page,
            bottom: AppSpace.xl,
            child: SafeArea(top: false, child: MiniPlayerBar()),
          ),
        ],
      ),
    );
  }
}

class _SongRow extends StatelessWidget {
  const _SongRow({required this.song, required this.active, required this.playing, required this.onTap});
  final SongItem song;
  final bool active;
  final bool playing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return TapScale(
      onTap: onTap,
      semanticLabel: '${song.title} by ${song.artist}',
      child: AnimatedContainer(
        duration: AppDurations.medium,
        margin: const EdgeInsets.only(bottom: AppSpace.sm),
        padding: const EdgeInsets.all(AppSpace.sm),
        decoration: BoxDecoration(
          color: active ? p.primaryTint : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 56,
              child: MediaArt(seed: song.seed, icon: Iconsax.musicnote_copy, iconSize: 20, radius: AppRadius.sm),
            ),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall?.copyWith(color: active ? p.primary : null),
                  ),
                  Text(
                    '${song.artist} · ${song.album}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            if (playing)
              Icon(Iconsax.sound_copy, color: p.primary, size: 20)
                  .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                  .scaleY(begin: 0.7, end: 1.1, duration: 500.ms)
            else
              Text(formatDuration(song.duration), style: context.text.bodySmall),
          ],
        ),
      ),
    );
  }
}
