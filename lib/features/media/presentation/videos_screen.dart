import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/selectors.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../player/domain/cast_media.dart';
import '../../player/presentation/player_controller.dart';
import '../../monetization/presentation/click_count_interstitial_manager.dart';
import '../domain/media_models.dart';
import 'asset_thumbnail.dart';
import 'media_permission_view.dart';
import 'media_preview.dart';
import 'media_providers.dart';

import '../../../core/l10n.dart';

class VideosScreen extends ConsumerWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(videosProvider);
    return Scaffold(
      appBar: CastAppBar(title: context.l10n.castVideos),
      body: AsyncView<List<VideoItem>>(
        value: videos,
        loading: const ShimmerList(leadingSize: 96),
        onRetry: () => ref.invalidate(videosProvider),
        errorBuilder: (e) => MediaPermissionView.forError(
          e,
          Iconsax.video_play_copy,
          () => ref.invalidate(videosProvider),
        ),
        isEmpty: (v) => v.isEmpty,
        empty: EmptyState(
          icon: Iconsax.video_add_copy,
          title: context.l10n.noVideosYet,
          message: context.l10n.videosYouRecordOr,
        ),
        data: (items) {
          // Built once per list, not once per row.
          final queue = [
            for (final x in items)
              CastMedia(
                id: x.id,
                title: x.title,
                subtitle: context.l10n.video2(x.resolution),
                kind: CastKind.video,
                seed: x.seed,
                duration: x.duration,
                url: 'asset:${x.id}',
              ),
          ];
          return RefreshIndicator(
            onRefresh: () => ref.refresh(videosProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.page,
                AppSpace.sm,
                AppSpace.page,
                AppSpace.xxxl,
              ),
              itemCount: items.length,
              // Build well ahead of the viewport so fast scrolling doesn't reveal blank rows.
              cacheExtent: 1500,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpace.md),
              itemBuilder: (context, i) {
                final v = items[i];
                return _VideoTile(
                  video: v,
                  onTap: () {
                    ClickCountInterstitialManager.recordClick(
                      context,
                      contextTag: 'video_cast',
                    );
                    castAndOpenRemote(context, ref, queue, index: i);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  const _VideoTile({required this.video, required this.onTap});

  final VideoItem video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(AppSpace.sm),
      onTap: onTap,
      semanticLabel: context.l10n.cast2(
        video.title,
        formatDuration(video.duration),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 116,
            height: 76,
            child: AssetThumbnail(
              assetId: video.id,
              radius: AppRadius.sm,
              child: Stack(
                children: [
                  PositionedDirectional(
                    top: 4,
                    start: 4,
                    child: PreviewButton(
                      onTap: () => showVideoPreview(context, video.id),
                    ),
                  ),
                  PositionedDirectional(
                    end: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        formatDuration(video.duration),
                        style: context.text.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (video.resolution.isNotEmpty)
                      SoftBadge(
                        video.resolution,
                        color: context.palette.primaryTint,
                        textColor: context.palette.primary,
                      ),
                    if (video.sizeBytes > 0)
                      Text(
                        formatBytes(video.sizeBytes),
                        style: context.text.bodySmall,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          IconBubble(icon: Iconsax.screenmirroring_copy, size: 40),
          const SizedBox(width: AppSpace.xs),
        ],
      ),
    );
  }
}
