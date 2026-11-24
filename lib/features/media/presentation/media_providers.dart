import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_providers.dart';
import '../data/device_media_repository.dart';
import '../domain/media_models.dart';

final mediaRepositoryProvider = Provider<MediaRepository>(
  (ref) => DeviceMediaRepository(),
);

// Each provider watches the preview mode so switching it refetches. They are
// auto-dispose: opening a screen always reads the gallery again, so access that
// was just allowed (from this or another screen) shows up at once.
final albumsProvider = FutureProvider.autoDispose<List<PhotoAlbum>>((ref) {
  ref.watch(previewModeProvider);
  return ref.watch(mediaRepositoryProvider).albums();
});

final photosProvider = FutureProvider.autoDispose.family<List<PhotoItem>, String>((
  ref,
  albumId,
) {
  ref.watch(previewModeProvider);
  return ref.watch(mediaRepositoryProvider).photos(albumId);
});

final videosProvider = FutureProvider.autoDispose<List<VideoItem>>((ref) {
  ref.watch(previewModeProvider);
  return ref.watch(mediaRepositoryProvider).videos();
});

final songsProvider = FutureProvider.autoDispose<List<SongItem>>((ref) {
  ref.watch(previewModeProvider);
  return ref.watch(mediaRepositoryProvider).songs();
});
