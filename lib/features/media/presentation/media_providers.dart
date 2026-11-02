import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_providers.dart';
import '../data/device_media_repository.dart';
import '../domain/media_models.dart';

final mediaRepositoryProvider = Provider<MediaRepository>(
  (ref) => DeviceMediaRepository(),
);

// Each provider watches the preview mode so switching it refetches.
final albumsProvider = FutureProvider<List<PhotoAlbum>>((ref) {
  ref.watch(previewModeProvider);
  return ref.watch(mediaRepositoryProvider).albums();
});

final photosProvider = FutureProvider.family<List<PhotoItem>, String>((ref, albumId) {
  ref.watch(previewModeProvider);
  return ref.watch(mediaRepositoryProvider).photos(albumId);
});

final videosProvider = FutureProvider<List<VideoItem>>((ref) {
  ref.watch(previewModeProvider);
  return ref.watch(mediaRepositoryProvider).videos();
});

final songsProvider = FutureProvider<List<SongItem>>((ref) {
  ref.watch(previewModeProvider);
  return ref.watch(mediaRepositoryProvider).songs();
});
