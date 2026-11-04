import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/selectors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../player/domain/cast_media.dart';
import '../../player/presentation/player_controller.dart';
import '../domain/media_models.dart';
import 'asset_thumbnail.dart';
import 'media_providers.dart';

import '../../../core/l10n.dart';

class PhotosScreen extends ConsumerStatefulWidget {
  const PhotosScreen({super.key});

  @override
  ConsumerState<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends ConsumerState<PhotosScreen> {
  /// Selected album id; empty means the phone's "All photos" album.
  String _album = '';
  bool _selecting = false;
  final Set<String> _selected = {};

  List<CastMedia> _toMedia(List<PhotoItem> photos) => [
    for (final p in photos)
      CastMedia(
        id: p.id,
        title: context.l10n.photo(formatShortDate(p.takenAt)),
        subtitle: context.l10n.photo2,
        kind: CastKind.photo,
        seed: p.seed,
        url: 'asset:${p.id}',
      ),
  ];

  void _toggle(String id) => setState(() {
    _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    if (_selected.isEmpty) _selecting = false;
  });

  Future<void> _castSelected(List<PhotoItem> all, {Duration? interval}) async {
    final picked = all.where((p) => _selected.contains(p.id)).toList();
    await castAndOpenRemote(context, ref, _toMedia(picked.isEmpty ? all : picked), slideshowInterval: interval);
  }

  Future<void> _openSlideshow(List<PhotoItem> all) async {
    final interval = await showModalBottomSheet<Duration>(
      context: context,
      useSafeArea: true,
      builder: (_) => const SafeArea(top: false, child: _SlideshowSheet()),
    );
    if (interval != null && mounted) await _castSelected(all, interval: interval);
  }

  @override
  Widget build(BuildContext context) {
    final albums = ref.watch(albumsProvider);
    final photos = ref.watch(photosProvider(_album));

    return Scaffold(
      appBar: CastAppBar(
        title: context.l10n.castPhotos,
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _selecting = !_selecting;
              _selected.clear();
            }),
            style: TextButton.styleFrom(minimumSize: const Size(kMinTap, kMinTap)),
            child: Text(
              _selecting ? context.l10n.cancel : context.l10n.select,
              style: context.text.labelMedium?.copyWith(color: context.palette.primary),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: albums.when(
              loading: () => SoftShimmer(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.page, vertical: 6),
                  itemCount: 4,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, _) => const ShimmerBox(width: 96, height: 44, radius: AppRadius.pill),
                ),
              ),
              error: (_, _) => const SizedBox.shrink(),
              data: (list) => ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.page, vertical: 6),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) => _AlbumPill(
                  album: list[i],
                  selected: list[i].id == _album || (_album.isEmpty && i == 0),
                  onTap: () => setState(() {
                    _album = list[i].id;
                    _selected.clear();
                  }),
                ),
              ),
            ),
          ),
          Expanded(
            child: AsyncView<List<PhotoItem>>(
              value: photos,
              loading: const ShimmerGrid(),
              onRetry: () => ref.invalidate(photosProvider(_album)),
              isEmpty: (d) => d.isEmpty,
              empty: EmptyState(
                icon: Iconsax.gallery_add_copy,
                title: context.l10n.noPhotosHere,
                message: context.l10n.photosYouTakeOr,
              ),
              data: (items) => Stack(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, 120),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final photo = items[i];
                      final selected = _selected.contains(photo.id);
                      return _PhotoTile(
                            photo: photo,
                            selecting: _selecting,
                            selected: selected,
                            onTap: () {
                              if (_selecting) {
                                _toggle(photo.id);
                              } else {
                                castAndOpenRemote(context, ref, _toMedia(items), index: i);
                              }
                            },
                            onLongPress: () => setState(() {
                              _selecting = true;
                              _selected.add(photo.id);
                            }),
                          )
                          .animate(delay: (_stagger(i) * 20).ms)
                          .fadeIn(duration: 300.ms)
                          .scale(begin: const Offset(0.94, 0.94));
                    },
                  ),
                  PositionedDirectional(
                    start: AppSpace.page,
                    end: AppSpace.page,
                    bottom: AppSpace.xxl,
                    child: SafeArea(
                      top: false,
                      child: _ActionBar(
                        count: _selected.length,
                        onSlideshow: () => _openSlideshow(items),
                        onCast: () => _castSelected(items),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Caps staggered entrance delays so long grids don't wait forever.
  int _stagger(int i) => i > 15 ? 15 : i;
}

class _AlbumPill extends StatelessWidget {
  const _AlbumPill({required this.album, required this.selected, required this.onTap});
  final PhotoAlbum album;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      child: TapScale(
        onTap: onTap,
        semanticLabel: context.l10n.photos2(album.name, album.count),
        child: AnimatedContainer(
          duration: AppDurations.medium,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: selected ? AppColors.mainGradient : null,
            color: selected ? null : p.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: selected ? null : AppShadows.soft(p),
          ),
          child: Text(
            '${album.name}  ${album.count}',
            style: context.text.labelMedium?.copyWith(color: selected ? Colors.white : p.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.photo,
    required this.selecting,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  final PhotoItem photo;
  final bool selecting;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      label: context.l10n.photoFrom(formatShortDate(photo.takenAt)),
      child: TapScale(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedScale(
          duration: AppDurations.fast,
          scale: selected ? 0.92 : 1,
          child: AssetThumbnail(
            assetId: photo.id,
            child: selecting
                ? PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: AnimatedContainer(
                      duration: AppDurations.fast,
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? p.primary : Colors.white.withValues(alpha: 0.5),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: selected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.count, required this.onSlideshow, required this.onCast});
  final int count;
  final VoidCallback onSlideshow;
  final VoidCallback onCast;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpace.sm),
      radius: AppRadius.pill,
      child: Row(
        children: [
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Text(
              count == 0 ? context.l10n.allPhotos : '$count selected',
              style: context.text.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TintedButton(
            label: context.l10n.slideshow,
            icon: Iconsax.play_circle_copy,
            compact: true,
            onPressed: onSlideshow,
          ),
          const SizedBox(width: AppSpace.sm),
          GradientButton(
            label: context.l10n.castAction,
            icon: Iconsax.screenmirroring_copy,
            compact: true,
            onPressed: onCast,
          ),
        ],
      ),
    );
  }
}

enum _Transition { fade, slide, zoom }

class _SlideshowSheet extends StatefulWidget {
  const _SlideshowSheet();

  @override
  State<_SlideshowSheet> createState() => _SlideshowSheetState();
}

class _SlideshowSheetState extends State<_SlideshowSheet> {
  int _seconds = 5;
  _Transition _transition = _Transition.fade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.slideshow, style: context.text.headlineMedium),
          const SizedBox(height: AppSpace.xl),
          Text(context.l10n.interval, style: context.text.titleSmall),
          const SizedBox(height: AppSpace.sm),
          SegmentedPills<int>(
            values: const [3, 5, 10, 15],
            selected: _seconds,
            labelOf: (s) => '${s}s',
            onChanged: (s) => setState(() => _seconds = s),
          ),
          const SizedBox(height: AppSpace.xl),
          Text(context.l10n.transition, style: context.text.titleSmall),
          const SizedBox(height: AppSpace.sm),
          SegmentedPills<_Transition>(
            values: _Transition.values,
            selected: _transition,
            labelOf: (t) => switch (t) {
              _Transition.fade => context.l10n.fade,
              _Transition.slide => context.l10n.slide,
              _Transition.zoom => context.l10n.zoom,
            },
            onChanged: (t) => setState(() => _transition = t),
          ),
          const SizedBox(height: AppSpace.xxl),
          GradientButton(
            label: context.l10n.startSlideshow,
            icon: Iconsax.play_copy,
            expand: true,
            onPressed: () => Navigator.of(context).pop(Duration(seconds: _seconds)),
          ),
        ],
      ),
    );
  }
}
