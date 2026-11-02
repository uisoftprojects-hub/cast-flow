import 'package:flutter/foundation.dart';

@immutable
class PhotoAlbum {
  const PhotoAlbum({required this.id, required this.name, required this.count});
  final String id;
  final String name;
  final int count;
}

@immutable
class PhotoItem {
  const PhotoItem({required this.id, required this.albumId, required this.seed, required this.takenAt});
  final String id;
  final String albumId;
  final int seed;
  final DateTime takenAt;
}

@immutable
class VideoItem {
  const VideoItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.sizeBytes,
    required this.resolution,
    required this.seed,
  });
  final String id;
  final String title;
  final Duration duration;
  final int sizeBytes;
  final String resolution;
  final int seed;
}

@immutable
class SongItem {
  const SongItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.seed,
  });
  final String id;
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final int seed;
}

/// Source of on-device media (photo_manager / media store in production).
abstract interface class MediaRepository {
  Future<List<PhotoAlbum>> albums();
  Future<List<PhotoItem>> photos(String albumId);
  Future<List<VideoItem>> videos();
  Future<List<SongItem>> songs();
}
