import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:photo_manager/photo_manager.dart';

import '../../../core/utils/serial_runner.dart';
import '../../monetization/domain/ad_suppression.dart';
import '../domain/media_models.dart';

/// Thrown when the user hasn't allowed access to photos / videos / music.
class MediaPermissionDenied implements Exception {
  const MediaPermissionDenied({this.permanent = false});

  /// "Don't ask again" (or blocked by policy): Android won't show the prompt
  /// any more, so the only way forward is the app's page in system Settings.
  final bool permanent;

  @override
  String toString() =>
      'Allow access to your media to cast it. You can change this in Settings.';
}

/// Real media from the phone's gallery and music library (MediaStore).
class DeviceMediaRepository implements MediaRepository {
  /// Upper bound on items loaded per list. High on purpose: lists are built
  /// lazily, and a cap of a few hundred hid most of a real gallery.
  static const _maxItems = 20000;

  /// Permission prompts one at a time (the albums and the photo grid both ask
  /// when Photos opens, and Android refuses a second request while the first
  /// dialog is open).
  static final _permissionQueue = SerialRunner();

  int? _sdk;

  Future<int> _sdkInt() async {
    if (_sdk != null) return _sdk!;
    try {
      return _sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    } catch (_) {
      return _sdk = 33;
    }
  }

  /// The runtime permissions behind each kind of media on this Android
  /// version: READ_MEDIA_* on 13+ (14+ may grant only selected items, which
  /// counts as access), READ_EXTERNAL_STORAGE up to 12.
  Future<List<ph.Permission>> _permissionsFor(RequestType type) async {
    if (await _sdkInt() <= 32) return [ph.Permission.storage];
    // Photos and videos are one "photos and videos" prompt: ask for both
    // together whichever screen asked, so allowing it from Videos also opens
    // Photos (and the other way round), instead of leaving the other empty.
    final visual = type.containsImage() || type.containsVideo();
    return [
      if (visual) ...[ph.Permission.photos, ph.Permission.videos],
      if (type.containsAudio()) ph.Permission.audio,
    ];
  }

  /// Asks for access when it can still be asked for, and tells a plain
  /// "denied" (ask again) apart from "permanently denied" (open Settings).
  Future<void> _ensureAccess([RequestType type = RequestType.common]) =>
      _permissionQueue.run(() => _ensureAccessNow(type));

  Future<void> _ensureAccessNow(RequestType type) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final perms = await _permissionsFor(type);
      bool ok(ph.PermissionStatus s) => s.isGranted || s.isLimited;
      var statuses = [for (final p in perms) await p.status];
      if (!statuses.any(ok)) {
        try {
          final result = await AdSuppression.around(() => perms.request());
          statuses = [
            for (final p in perms) result[p] ?? ph.PermissionStatus.denied,
          ];
        } on PlatformException {
          // Another part of the app has a prompt open: wait a moment and read
          // what the user answered instead of failing with a generic error.
          await Future<void>.delayed(const Duration(milliseconds: 600));
          statuses = [for (final p in perms) await p.status];
        }
      }
      if (!statuses.any(ok)) {
        final permanent = statuses.every(
          (s) => s.isPermanentlyDenied || s.isRestricted,
        );
        throw MediaPermissionDenied(permanent: permanent);
      }
    }
    // Already allowed above on Android, so this shows no prompt there; on iOS
    // it is the real request.
    final state = await AdSuppression.around(
      () => PhotoManager.requestPermissionExtend(
        requestOption: PermissionRequestOption(
          androidPermission: AndroidPermission(
            // Photos and videos share one grant (see _permissionsFor).
            type: type.containsImage() || type.containsVideo() ? RequestType.common : type,
            mediaLocation: false,
          ),
        ),
      ),
    );
    if (!state.hasAccess) throw const MediaPermissionDenied();
  }

  Future<List<AssetEntity>> _all(RequestType type) async {
    await _ensureAccess(type);
    final paths = await PhotoManager.getAssetPathList(
      type: type,
      onlyAll: true,
    );
    if (paths.isEmpty) return const [];
    final count = await paths.first.assetCountAsync;
    return paths.first.getAssetListRange(
      start: 0,
      end: math.min(count, _maxItems),
    );
  }

  @override
  Future<List<PhotoAlbum>> albums() async {
    await _ensureAccess(RequestType.image);
    final paths = await PhotoManager.getAssetPathList(type: RequestType.image);
    final albums = <PhotoAlbum>[];
    for (final p in paths) {
      final count = await p.assetCountAsync;
      if (count == 0) continue;
      albums.add(
        PhotoAlbum(
          id: p.id,
          name: p.isAll ? 'All photos' : p.name,
          count: count,
        ),
      );
    }
    return albums;
  }

  @override
  Future<List<PhotoItem>> photos(String albumId) async {
    await _ensureAccess(RequestType.image);
    final paths = await PhotoManager.getAssetPathList(type: RequestType.image);
    final path =
        paths.where((p) => p.id == albumId).firstOrNull ??
        paths.where((p) => p.isAll).firstOrNull;
    if (path == null) return const [];
    final count = await path.assetCountAsync;
    final assets = await path.getAssetListRange(
      start: 0,
      end: math.min(count, _maxItems),
    );
    return [
      for (final a in assets)
        PhotoItem(
          id: a.id,
          albumId: path.id,
          seed: a.id.hashCode,
          takenAt: a.createDateTime,
        ),
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
        title: (a.title ?? 'Track').replaceAll(
          RegExp(r'\.[a-z0-9]{2,4}$', caseSensitive: false),
          '',
        ),
        artist:
            a.relativePath?.split('/').where((s) => s.isNotEmpty).lastOrNull ??
            'Music',
        album: '',
        duration: a.videoDuration,
        seed: a.id.hashCode,
      ),
  ];
}
