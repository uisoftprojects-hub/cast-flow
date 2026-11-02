import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/soft_card.dart';
import '../../devices/presentation/device_providers.dart';
import '../../player/presentation/player_controller.dart';
import '../domain/web_video.dart';

/// Browser bottom navigation: back, forward, Cast (with count badge) and the
/// start page.
class BrowserBottomBar extends StatelessWidget {
  const BrowserBottomBar({
    super.key,
    required this.count,
    required this.onBack,
    required this.onForward,
    required this.onCast,
    required this.onStartPage,
  });

  final int count;
  final VoidCallback? onBack;
  final VoidCallback? onForward;
  final VoidCallback onCast;
  final VoidCallback onStartPage;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    Widget item(IconData icon, String label, VoidCallback? onTap) => IconButton(
      tooltip: label,
      onPressed: onTap,
      constraints: const BoxConstraints(minWidth: kMinTap, minHeight: kMinTap),
      icon: Icon(icon, size: 22, color: onTap == null ? p.textSecondary.withValues(alpha: 0.35) : p.textPrimary),
    );
    return Container(
      decoration: BoxDecoration(color: p.surface, boxShadow: AppShadows.soft(p)),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              item(Iconsax.arrow_left_2_copy, l.browserBack, onBack),
              item(Iconsax.arrow_right_3_copy, l.browserForward, onForward),
              CastNavButton(count: count, onTap: onCast),
              item(Iconsax.home_2_copy, l.browserStartPage, onStartPage),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dimmed until a video is found; then active with a count badge and a
/// subtle pulse.
class CastNavButton extends StatelessWidget {
  const CastNavButton({super.key, required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final active = count > 0;
    final icon = AnimatedContainer(
      duration: AppDurations.medium,
      width: 52,
      height: 40,
      decoration: BoxDecoration(
        gradient: active ? AppColors.mainGradient : null,
        color: active ? null : p.primaryTint.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: active ? AppShadows.glow(AppColors.primary) : null,
      ),
      alignment: Alignment.center,
      child: Icon(
        Iconsax.screenmirroring_copy,
        size: 22,
        color: active ? Colors.white : p.textSecondary.withValues(alpha: 0.55),
      ),
    );
    return Semantics(
      button: true,
      label: active ? context.l10n.castVideoCount(count) : context.l10n.castVideo,
      child: Tooltip(
        message: context.l10n.castVideo,
        child: InkResponse(
          onTap: onTap,
          radius: 32,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (active)
                  icon
                      .animate(key: const ValueKey('pulse'), onPlay: (c) => context.loopMotion(c, reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.07, 1.07),
                        duration: 900.ms,
                        curve: Curves.easeInOut,
                      )
                else
                  icon,
                if (active)
                  PositionedDirectional(
                    top: -6,
                    end: -6,
                    child: ExcludeSemantics(
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 20),
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: p.surface, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          count > 9 ? '9+' : '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ),
                    ).animate(key: ValueKey(count)).scale(begin: const Offset(0.4, 0.4), curve: Curves.easeOutBack),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small non-blocking "Video found" prompt above the bottom bar.
class VideoFoundBanner extends StatelessWidget {
  const VideoFoundBanner({super.key, required this.onCast, required this.onDismiss});

  final VoidCallback onCast;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    return Dismissible(
      key: const ValueKey('video-found'),
      onDismissed: (_) => onDismiss(),
      child: SoftCard(
        padding: const EdgeInsetsDirectional.fromSTEB(AppSpace.md, AppSpace.sm, AppSpace.xs, AppSpace.sm),
        child: Row(
          children: [
            IconBubble(icon: Iconsax.video_play_copy, color: p.primary, size: 40),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.videoFound, style: context.text.titleSmall),
                  Text(l.videoFoundMessage, style: context.text.bodySmall),
                ],
              ),
            ),
            GradientButton(label: l.castAction, icon: Iconsax.screenmirroring_copy, compact: true, onPressed: onCast),
            IconButton(
              tooltip: l.dismiss,
              onPressed: onDismiss,
              icon: Icon(Iconsax.close_circle_copy, color: p.textSecondary, size: 20),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: AppDurations.fast).slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack);
  }
}

/// "Videos found (N)" sheet. Pops with the picked video.
Future<WebVideo?> showVideosSheet(BuildContext context, List<WebVideo> videos) {
  return showModalBottomSheet<WebVideo>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
    builder: (_) => SafeArea(top: false, child: _VideosSheet(videos: videos)),
  );
}

class _VideosSheet extends StatelessWidget {
  const _VideosSheet({required this.videos});
  final List<WebVideo> videos;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final single = videos.length == 1;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.videosFound(videos.length), style: context.text.headlineMedium),
            const SizedBox(height: AppSpace.lg),
            for (final v in videos)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.md),
                child: _VideoRow(video: v, showButton: !single),
              ),
            if (single) ...[
              const SizedBox(height: AppSpace.sm),
              GradientButton(
                label: l.castToTv,
                icon: Iconsax.screenmirroring_copy,
                expand: true,
                onPressed: videos.first.protected ? null : () => Navigator.of(context).pop(videos.first),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VideoRow extends StatelessWidget {
  const _VideoRow({required this.video, required this.showButton});
  final WebVideo video;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    final details = [
      video.type.label,
      ?video.quality,
      if (video.duration != null && video.duration! > Duration.zero) formatDuration(video.duration!),
    ].join(' · ');
    return SoftCard(
      padding: const EdgeInsets.all(AppSpace.sm),
      child: Row(
        children: [
          VideoThumb(video: video, width: 104, height: 62),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title ?? video.url,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(details, style: context.text.bodySmall),
                if (video.protected)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Icon(Iconsax.lock_copy, size: 13, color: p.textSecondary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            l.protectedVideo,
                            style: context.text.labelSmall?.copyWith(color: p.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (showButton && !video.protected)
            GradientButton(label: l.castAction, compact: true, onPressed: () => Navigator.of(context).pop(video)),
        ],
      ),
    );
  }
}

/// Poster / og:image thumbnail, loaded with the page's Referer; falls back
/// to generated art.
class VideoThumb extends StatelessWidget {
  const VideoThumb({super.key, required this.video, required this.width, required this.height});
  final WebVideo video;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fallback = MediaArt(seed: video.url.hashCode, icon: Iconsax.play_copy, iconSize: 20, radius: AppRadius.sm);
    final referer = video.headers['Referer'];
    return Semantics(
      image: true,
      label: context.l10n.videoThumbnail,
      child: SizedBox(
        width: width,
        height: height,
        child: video.poster == null
            ? fallback
            : ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Image.network(
                  video.poster!,
                  fit: BoxFit.cover,
                  headers: {'Referer': ?referer},
                  errorBuilder: (_, _, _) => fallback,
                ),
              ),
      ),
    );
  }
}

/// "Casting to [device]" bar over the browser with stop, expandable into a
/// mini controller (play/pause, seek, volume). The page stays usable.
class BrowserCastBar extends ConsumerStatefulWidget {
  const BrowserCastBar({super.key, this.poster});

  final WebVideo? poster;

  @override
  ConsumerState<BrowserCastBar> createState() => _BrowserCastBarState();
}

class _BrowserCastBarState extends ConsumerState<BrowserCastBar> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(playerProvider);
    final device = ref.watch(connectionProvider.select((c) => c.device?.name)) ?? 'TV';
    final media = s.media;
    final p = context.palette;
    final l = context.l10n;
    final player = ref.read(playerProvider.notifier);
    if (media == null) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.soft(p)),
      child: GlassPanel(
        radius: AppRadius.lg,
        padding: const EdgeInsets.all(AppSpace.sm),
        child: AnimatedSize(
          duration: AppDurations.fast,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (widget.poster != null) ...[
                    VideoThumb(video: widget.poster!, width: 54, height: 36),
                    const SizedBox(width: AppSpace.sm),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.castingTo(device),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.labelLarge,
                        ),
                        Text(media.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: s.playing ? l.pause : l.play,
                    onPressed: player.toggle,
                    icon: Icon(s.playing ? Iconsax.pause_copy : Iconsax.play_copy, color: p.primary),
                  ),
                  IconButton(
                    tooltip: _expanded ? l.hideControls : l.showControls,
                    onPressed: () => setState(() => _expanded = !_expanded),
                    icon: Icon(_expanded ? Iconsax.arrow_down_1_copy : Iconsax.arrow_up_2_copy, color: p.textSecondary),
                  ),
                  IconButton(
                    tooltip: l.stopCasting,
                    onPressed: player.stop,
                    icon: Icon(Iconsax.stop_circle_copy, color: p.textSecondary),
                  ),
                ],
              ),
              if (_expanded) ...[
                if (media.isTimed)
                  Row(
                    children: [
                      Text(formatDuration(s.position), style: context.text.labelSmall),
                      Expanded(
                        child: Semantics(
                          label: l.seekPosition,
                          child: Slider(
                            value: s.position.inSeconds.clamp(0, media.duration.inSeconds).toDouble(),
                            max: media.duration.inSeconds.toDouble(),
                            onChanged: (v) => player.seek(Duration(seconds: v.round())),
                          ),
                        ),
                      ),
                      Text(formatDuration(media.duration), style: context.text.labelSmall),
                    ],
                  ),
                Row(
                  children: [
                    const SizedBox(width: AppSpace.sm),
                    Icon(Iconsax.volume_low_copy, size: 18, color: p.textSecondary),
                    Expanded(
                      child: Semantics(
                        label: l.volume,
                        child: Slider(value: s.volume, onChanged: player.setVolume),
                      ),
                    ),
                    Icon(Iconsax.volume_high_copy, size: 18, color: p.textSecondary),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: AppDurations.fast).slideY(begin: 0.3, end: 0);
  }
}
