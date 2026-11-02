import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/state_views.dart';
import '../../devices/presentation/device_providers.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../domain/cast_media.dart';
import 'player_controller.dart';

/// Cast remote shared by photo, video, music and web casting.
class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(playerProvider);
    final conn = ref.watch(connectionProvider);
    final ctrl = ref.read(playerProvider.notifier);
    final media = s.media;

    return Scaffold(
      appBar: const CastAppBar(title: 'Now casting'),
      body: media == null
          ? EmptyState(
              icon: Iconsax.screenmirroring_copy,
              title: 'Nothing is casting',
              message: 'Pick a photo, video, song or web video to send it to your TV.',
              actionLabel: 'Back to home',
              onAction: () => context.go('/home'),
            )
          : Stack(
              children: [
                // Soft color wash from the artwork.
                Positioned.fill(
                  child: Opacity(
                    opacity: context.isDark ? 0.18 : 0.28,
                    child: MediaArt(seed: media.seed, radius: 0),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.palette.background.withValues(alpha: 0.2),
                          context.palette.background,
                        ],
                        stops: const [0, 0.65],
                      ),
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, c) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.xl),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight - AppSpace.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Artwork(media: media, playing: s.playing),
                          const SizedBox(height: AppSpace.xxl),
                          Text(media.title,
                              textAlign: TextAlign.center, style: context.text.headlineMedium, maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Iconsax.monitor_copy, size: 16, color: context.palette.primary),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '${media.subtitle ?? media.kind.label} · ${conn.device?.name ?? 'Not connected'}',
                                  style: context.text.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (s.queue.length > 1) ...[
                            const SizedBox(height: 4),
                            Text('${s.index + 1} of ${s.queue.length}', style: context.text.bodySmall),
                          ],
                          const SizedBox(height: AppSpace.xxl),
                          _ControlPanel(state: s, media: media, ctrl: ctrl),
                          const SizedBox(height: AppSpace.lg),
                          _UpNext(state: s, ctrl: ctrl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({required this.media, required this.playing});
  final CastMedia media;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    final isVideo = media.kind != CastKind.music;
    return AnimatedScale(
      duration: AppDurations.slow,
      curve: Curves.easeOutBack,
      scale: playing ? 1 : 0.94,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isVideo ? 480 : 320),
        child: AspectRatio(
        aspectRatio: isVideo ? 16 / 10 : 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppShadows.glow(AppColors.primary),
          ),
          child: MediaArt(
            key: ValueKey(media.id),
            seed: media.seed,
            icon: media.kind.icon,
            iconSize: 56,
            radius: AppRadius.xl,
          ).animate().fadeIn(duration: 400.ms),
        ),
      ),
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({required this.state, required this.media, required this.ctrl});
  final PlaybackState state;
  final CastMedia media;
  final PlayerController ctrl;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final length = media.isTimed ? media.duration : (state.slideshowInterval ?? const Duration(seconds: 5));
    final progress = length.inSeconds == 0 ? 0.0 : (state.position.inSeconds / length.inSeconds).clamp(0.0, 1.0);

    return GlassPanel(
      child: Column(
        children: [
          Slider(
            value: progress,
            semanticFormatterCallback: (_) => '${formatDuration(state.position)} of ${formatDuration(length)}',
            onChanged: media.isTimed ? (v) => ctrl.seek(length * v) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
            child: Row(
              children: [
                Text(formatDuration(state.position), style: context.text.bodySmall),
                const Spacer(),
                Text(media.isTimed ? formatDuration(length) : 'Slide ${formatDuration(length)}',
                    style: context.text.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Ctl(icon: Iconsax.previous_copy, tooltip: 'Previous', onTap: ctrl.previous),
              _Ctl(
                icon: Iconsax.backward_10_seconds_copy,
                tooltip: 'Back 10 seconds',
                onTap: media.isTimed ? () => ctrl.skip(-10) : null,
              ),
              SoftIconButton(
                icon: state.playing ? Iconsax.pause_copy : Iconsax.play_copy,
                tooltip: state.playing ? 'Pause' : 'Play',
                filled: true,
                size: 72,
                onPressed: ctrl.toggle,
              ),
              _Ctl(
                icon: Iconsax.forward_10_seconds_copy,
                tooltip: 'Forward 10 seconds',
                onTap: media.isTimed ? () => ctrl.skip(10) : null,
              ),
              _Ctl(icon: Iconsax.next_copy, tooltip: 'Next', onTap: state.hasNext ? ctrl.next : null),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Row(
            children: [
              Icon(state.volume == 0 ? Iconsax.volume_slash_copy : Iconsax.volume_low_copy, size: 20, color: p.textSecondary),
              Expanded(
                child: Slider(
                  value: state.volume,
                  label: 'TV volume',
                  semanticFormatterCallback: (v) => 'TV volume ${(v * 100).round()} percent',
                  onChanged: ctrl.setVolume,
                ),
              ),
              Icon(Iconsax.volume_high_copy, size: 20, color: p.textSecondary),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          TintedButton(
            label: 'Stop casting',
            icon: Iconsax.stop_circle_copy,
            color: p.error,
            expand: true,
            onPressed: () {
              ctrl.stop();
              if (context.canPop()) context.pop();
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.08, end: 0);
  }
}

class _Ctl extends StatelessWidget {
  const _Ctl({required this.icon, required this.tooltip, required this.onTap});
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      constraints: const BoxConstraints(minWidth: kMinTap, minHeight: kMinTap),
      icon: Icon(icon, size: 26),
      color: context.palette.textPrimary,
      disabledColor: context.palette.textSecondary.withValues(alpha: 0.4),
    );
  }
}

/// Queue preview at the bottom of the player, with a button that opens the
/// phone's photo or video picker (matching what is playing) to add more.
class _UpNext extends StatelessWidget {
  const _UpNext({required this.state, required this.ctrl});
  final PlaybackState state;
  final PlayerController ctrl;

  bool get _photos => state.media?.kind == CastKind.photo;

  Future<void> _add(BuildContext context) async {
    final picker = ImagePicker();
    final List<XFile> files;
    if (_photos) {
      files = await picker.pickMultiImage();
    } else {
      final v = await picker.pickVideo(source: ImageSource.gallery);
      files = [?v];
    }
    ctrl.enqueue([
      for (final f in files)
        CastMedia(
          id: f.path,
          title: f.name,
          subtitle: _photos ? 'Photo' : 'Video',
          kind: _photos ? CastKind.photo : CastKind.video,
          seed: f.path.hashCode,
          url: f.path,
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final next = [for (var i = state.index + 1; i < state.queue.length; i++) (i, state.queue[i])];
    final canAdd = state.media?.kind == CastKind.photo || state.media?.kind == CastKind.video;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text('Up next', style: context.text.titleLarge)),
            if (canAdd)
              TintedButton(
                label: _photos ? 'Add photos' : 'Add videos',
                icon: _photos ? Iconsax.gallery_add_copy : Iconsax.video_add_copy,
                compact: true,
                onPressed: () => _add(context),
              ),
          ],
        ),
        const SizedBox(height: AppSpace.sm),
        if (next.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.md),
            child: Text('Nothing else in the queue.', style: context.text.bodyMedium),
          )
        else
          SizedBox(
            height: 128,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: next.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpace.md),
              itemBuilder: (context, j) {
                final (i, m) = next[j];
                return GestureDetector(
                  onTap: () => ctrl.jumpTo(i),
                  child: Semantics(
                    button: true,
                    label: 'Play ${m.title}',
                    child: SizedBox(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: MediaArt(seed: m.seed, icon: m.kind.icon, radius: AppRadius.sm)),
                          const SizedBox(height: 6),
                          Text(m.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelMedium),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
