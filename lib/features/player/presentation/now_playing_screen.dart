import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/presentation/device_providers.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../media/presentation/asset_thumbnail.dart';
import '../domain/cast_media.dart';
import 'player_controller.dart';

/// Casting preview, shared by photos, videos, music and web: the media on
/// top, playback controls in the center, and the queue at the bottom.
/// Laid out to fit one screen.
class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(playerProvider);
    final device = ref.watch(connectionProvider.select((c) => c.device?.name));
    final ctrl = ref.read(playerProvider.notifier);
    final media = s.media;
    final l = context.l10n;

    return Scaffold(
      appBar: CastAppBar(
        title: l.nowCasting,
        actions: [
          if (media != null)
            SoftIconButton(
              icon: Iconsax.stop_circle_copy,
              tooltip: l.stopCasting,
              size: 44,
              color: context.palette.error,
              onPressed: () {
                ctrl.stop();
                if (context.canPop()) context.pop();
              },
            ),
        ],
      ),
      body: media == null
          ? EmptyState(
              icon: Iconsax.screenmirroring_copy,
              title: l.nothingIsCasting,
              message: l.pickAPhotoVideo,
              actionLabel: l.backToHome,
              onAction: () => context.go('/home'),
            )
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.md),
                child: Column(
                  children: [
                    // Top: the media itself.
                    Expanded(
                      child: Center(
                        child: _Preview(media: media, playing: s.playing),
                      ),
                    ),
                    const SizedBox(height: AppSpace.lg),
                    Text(
                      media.title,
                      textAlign: TextAlign.center,
                      style: context.text.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.monitor_copy, size: 15, color: context.palette.primary),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            device ?? l.notConnected,
                            style: context.text.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (s.queue.length > 1)
                          Text('  ·  ${s.index + 1}/${s.queue.length}', style: context.text.bodySmall),
                      ],
                    ),
                    const SizedBox(height: AppSpace.lg),
                    // Center: seek bar and previous / play-pause / next.
                    _Controls(state: s, media: media, ctrl: ctrl),
                    const SizedBox(height: AppSpace.lg),
                    // Bottom: the queue.
                    _QueueBar(state: s, ctrl: ctrl),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Real preview of what's on the TV: gallery thumbnail, picked file, or a
/// themed placeholder for streams and music.
class _Preview extends StatelessWidget {
  const _Preview({required this.media, required this.playing});
  final CastMedia media;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    final wide = media.kind != CastKind.music;
    final url = media.url ?? '';
    final Widget image;
    if (url.startsWith('asset:')) {
      image = AssetThumbnail(assetId: url.substring(6), radius: AppRadius.xl);
    } else if (!kIsWeb && media.kind == CastKind.photo && url.isNotEmpty && File(url).existsSync()) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Image.file(File(url), fit: BoxFit.cover),
      );
    } else {
      image = MediaArt(seed: media.seed, icon: media.kind.icon, iconSize: 56, radius: AppRadius.xl);
    }

    return AnimatedScale(
      duration: AppDurations.slow,
      curve: Curves.easeOutBack,
      scale: playing ? 1 : 0.95,
      child: AspectRatio(
        aspectRatio: wide ? 16 / 10 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppShadows.glow(AppColors.primary),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              KeyedSubtree(key: ValueKey(media.id), child: image).animate().fadeIn(duration: 350.ms),
              if (media.kind == CastKind.video || media.kind == CastKind.web || media.kind == CastKind.youtube)
                Center(
                  child: AnimatedOpacity(
                    duration: AppDurations.medium,
                    opacity: playing ? 0 : 1,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.state, required this.media, required this.ctrl});
  final PlaybackState state;
  final CastMedia media;
  final PlayerController ctrl;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final length = media.isTimed ? media.duration : (state.slideshowInterval ?? const Duration(seconds: 5));
    final progress = length.inSeconds == 0 ? 0.0 : (state.position.inSeconds / length.inSeconds).clamp(0.0, 1.0);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(trackHeight: 4, overlayShape: SliderComponentShape.noOverlay),
          child: Slider(
            value: progress,
            semanticFormatterCallback: (_) => '${formatDuration(state.position)} / ${formatDuration(length)}',
            onChanged: media.isTimed ? (v) => ctrl.seek(length * v) : null,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(formatDuration(state.position), style: context.text.bodySmall),
            const Spacer(),
            Text(
              media.isTimed ? formatDuration(length) : l.slide2(formatDuration(length)),
              style: context.text.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: AppSpace.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RoundControl(
              icon: Iconsax.previous_copy,
              tooltip: l.previous,
              onTap: state.hasPrevious || state.position > Duration.zero ? ctrl.previous : null,
            ),
            const SizedBox(width: AppSpace.xxl),
            TapScale(
              onTap: ctrl.toggle,
              semanticLabel: state.playing ? l.pause : l.play,
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: AppColors.mainGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.glow(AppColors.primary),
                ),
                child: AnimatedSwitcher(
                  duration: AppDurations.fast,
                  transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                  child: Icon(
                    state.playing ? Iconsax.pause_copy : Iconsax.play_copy,
                    key: ValueKey(state.playing),
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpace.xxl),
            _RoundControl(icon: Iconsax.next_copy, tooltip: l.next, onTap: state.hasNext ? ctrl.next : null),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.06, end: 0);
  }
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({required this.icon, required this.tooltip, required this.onTap});
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.4 : 1,
      child: SoftIconButton(icon: icon, tooltip: tooltip, size: 56, onPressed: onTap),
    );
  }
}

/// Bottom bar showing what's next; opens the full queue sheet.
class _QueueBar extends StatelessWidget {
  const _QueueBar({required this.state, required this.ctrl});
  final PlaybackState state;
  final PlayerController ctrl;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    final next = state.hasNext ? state.queue[state.index + 1] : null;
    return TapScale(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const SafeArea(top: false, child: _QueueSheet()),
      ),
      semanticLabel: l.queue,
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: p.divider),
          boxShadow: AppShadows.soft(p),
        ),
        child: Row(
          children: [
            const IconBubble(icon: Iconsax.music_playlist_copy, size: 40),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l.queue} · ${state.queue.length}', style: context.text.titleSmall),
                  Text(
                    next != null ? '${l.upNext}: ${next.title}' : l.nothingElseInThe,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_up_rounded, color: p.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Full queue: tap an item to play it; the add button opens the picker that
/// matches what's being cast (photos, videos or music).
class _QueueSheet extends ConsumerWidget {
  const _QueueSheet();

  static Future<void> _add(BuildContext context, WidgetRef ref, CastKind kind) async {
    final l = context.l10n;
    final picked = <(String path, String name)>[];
    switch (kind) {
      case CastKind.photo:
        for (final f in await ImagePicker().pickMultiImage()) {
          picked.add((f.path, f.name));
        }
      case CastKind.video:
        final v = await ImagePicker().pickVideo(source: ImageSource.gallery);
        if (v != null) picked.add((v.path, v.name));
      case CastKind.music:
        for (final f in await FilePicker.pickFiles(type: FileType.audio)) {
          if (f.path != null) picked.add((f.path!, f.name));
        }
      default:
        return;
    }
    ref.read(playerProvider.notifier).enqueue([
      for (final (path, name) in picked)
        CastMedia(
          id: path,
          title: name.replaceAll(RegExp(r'\.[a-z0-9]{2,4}$', caseSensitive: false), ''),
          subtitle: switch (kind) {
            CastKind.photo => l.photo2,
            CastKind.video => l.video,
            _ => l.addMusic,
          },
          kind: kind,
          seed: path.hashCode,
          url: path,
        ),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(playerProvider);
    final ctrl = ref.read(playerProvider.notifier);
    final l = context.l10n;
    final p = context.palette;
    final kind = s.media?.kind;
    final (String? addLabel, IconData addIcon) = switch (kind) {
      CastKind.photo => (l.addPhotos, Iconsax.gallery_add_copy),
      CastKind.video => (l.addVideos, Iconsax.video_add_copy),
      CastKind.music => (l.addMusic, Iconsax.music_square_add_copy),
      _ => (null, Iconsax.add_copy),
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpace.xl, 0, AppSpace.xl, AppSpace.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(l.queue, style: context.text.headlineSmall)),
                if (addLabel != null)
                  TintedButton(
                    label: addLabel,
                    icon: addIcon,
                    compact: true,
                    onPressed: () => _add(context, ref, kind!),
                  ),
              ],
            ),
            const SizedBox(height: AppSpace.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: s.queue.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpace.sm),
                itemBuilder: (context, i) {
                  final m = s.queue[i];
                  final current = i == s.index;
                  final url = m.url ?? '';
                  return TapScale(
                    onTap: current ? null : () => ctrl.jumpTo(i),
                    semanticLabel: l.play2(m.title),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpace.sm),
                      decoration: BoxDecoration(
                        color: current ? p.primaryTint : p.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: current ? p.primary : p.divider),
                      ),
                      child: Row(
                        children: [
                          SizedBox.square(
                            dimension: 52,
                            child: url.startsWith('asset:')
                                ? AssetThumbnail(assetId: url.substring(6), radius: AppRadius.sm)
                                : MediaArt(seed: m.seed, icon: m.kind.icon, iconSize: 20, radius: AppRadius.sm),
                          ),
                          const SizedBox(width: AppSpace.md),
                          Expanded(
                            child: Text(
                              m.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.titleSmall?.copyWith(color: current ? p.primary : null),
                            ),
                          ),
                          if (current)
                            Icon(s.playing ? Iconsax.sound_copy : Iconsax.pause_copy, color: p.primary, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
