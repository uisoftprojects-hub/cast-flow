import 'dart:math' as math;

import 'package:photo_manager/photo_manager.dart';

import '../domain/media_models.dart';

/// Thrown when the user hasn't allowed access to photos / videos / music.
class MediaPermissionDenied implements Exception {
  const MediaPermissionDenied();

  @override
  String toString() => 'Allow access to your media to cast it. You can change this in Settings.';
}

/// Real media from the phone's gallery and music library (MediaStore).
class DeviceMediaRepository implements MediaRepository {
  static const _maxItems = 600;

  Future<void> _ensureAccess() async {
    final state = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(type: RequestType.all, mediaLocation: false),
      ),
    );
    if (!state.hasAccess) throw const MediaPermissionDenied();
  }

  Future<List<AssetEntity>> _all(RequestType type) async {
    await _ensureAccess();
    final paths = await PhotoManager.getAssetPathList(type: type, onlyAll: true);
    if (paths.isEmpty) return const [];
    final count = await paths.first.assetCountAsync;
    return paths.first.getAssetListRange(start: 0, end: math.min(count, _maxItems));
  }

  @override
  Future<List<PhotoAlbum>> albums() async {
    await _ensureAccess();
    final paths = await PhotoManager.getAssetPathList(type: RequestType.image);
    final albums = <PhotoAlbum>[];
    for (final p in paths) {
      final count = await p.assetCountAsync;
      if (count == 0) continue;
      albums.add(PhotoAlbum(id: p.id, name: p.isAll ? 'All photos' : p.name, count: count));
    }
    return albums;
  }

  @override
  Future<List<PhotoItem>> photos(String albumId) async {
    await _ensureAccess();
    final paths = await PhotoManager.getAssetPathList(type: RequestType.image);
    final path = paths.where((p) => p.id == albumId).firstOrNull ?? paths.where((p) => p.isAll).firstOrNull;
    if (path == null) return const [];
    final count = await path.assetCountAsync;
    final assets = await path.getAssetListRange(start: 0, end: math.min(count, _maxItems));
    return [
      for (final a in assets) PhotoItem(id: a.id, albumId: path.id, seed: a.id.hashCode, takenAt: a.createDateTime),
    ];
  }

  @override
  Future<List<VideoItem>> videos() async => [
    for (final a in await _all(RequestType.video))
      VideoItem(
        id: a.id,
        title: a.title?.isNotEmpty == true ? a.title! : 'Video',
        duration: a.videoDuration,
        sizeBytes: 0,
        resolution: a.height > 0 ? '${math.min(a.width, a.height)}p' : '',
        seed: a.id.hashCode,
      ),
  ];

  @override
  Future<List<SongItem>> songs() async => [
    for (final a in await _all(RequestType.audio))
      SongItem(
        id: a.id,
        title: (a.title ?? 'Track').replaceAll(RegExp(r'\.[a-z0-9]{2,4}$', caseSensitive: false), ''),
        artist: a.relativePath?.split('/').where((s) => s.isNotEmpty).lastOrNull ?? 'Music',
        album: '',
        duration: a.videoDuration,
        seed: a.id.hashCode,
      ),
  ];
}
