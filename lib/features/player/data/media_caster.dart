import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/debug_log.dart';

import '../../devices/domain/cast_device.dart';
import '../../remote/data/dlna_client.dart';
import '../domain/cast_media.dart';
import '../domain/tv_formats.dart';
import 'media_converter.dart';
import 'media_server.dart';

/// What a receiver reports while it plays.
typedef CasterStatus = ({String state, Duration position, Duration length});

/// Progress of getting an item ready for the TV: null = preparing (no
/// percentage), 0..1 = converting.
/// [detail] says what is converted into what (e.g. "MKV · H.265 / DTS → MP4 · H.264 / AAC").
typedef PrepareProgress = void Function(double? progress, [String? detail]);

/// A gallery item resolved to a real file.
typedef LocalMedia = ({String path, String? mime});

/// Sends media to a receiver and controls its playback.
abstract interface class MediaCaster {
  /// Whether [device] can receive media from this caster.
  bool canCast(CastDevice device);

  /// Sends [media] to [device] and starts it. With [forceConvert] the item is
  /// converted to MP4 / JPEG first whatever the TV claims (the fallback after
  /// the TV failed to play the original). [onPrepare] reports conversion.
  Future<void> load(CastDevice device, CastMedia media, {bool forceConvert = false, PrepareProgress? onPrepare});
  Future<void> play(CastDevice device);
  Future<void> pause(CastDevice device);
  Future<void> seek(CastDevice device, Duration to);
  Future<void> stop(CastDevice device);

  /// [level] is 0..1.
  Future<void> setVolume(CastDevice device, double level);
  Future<CasterStatus?> status(CastDevice device);

  /// The cast session is over: forget published items, delete converted files.
  Future<void> endSession();
}

/// Resolves `asset:<id>` (a gallery item from photo_manager) to its file.
Future<LocalMedia?> resolveGalleryAsset(String id) async {
  final asset = await AssetEntity.fromId(id);
  if (asset == null) return null;
  final file = await asset.originFile ?? await asset.file;
  if (file == null) return null;
  return (path: file.path, mime: asset.mimeType);
}

/// DLNA/UPnP casting: the phone serves the file, the TV is told its URL.
class DlnaMediaCaster implements MediaCaster {
  DlnaMediaCaster(
    this._dlna,
    this._server, {
    Future<String?> Function(String tvHost)? hostFor,
    this._converter,
    Future<LocalMedia?> Function(String assetId)? resolveAsset,
  }) : _hostFor = hostFor ?? MediaServer.lanIpFor,
       _resolveAsset = resolveAsset ?? resolveGalleryAsset;

  final DlnaClient _dlna;
  final MediaServer _server;

  /// This phone's address as seen from the TV (overridable for tests).
  final Future<String?> Function(String tvHost) _hostFor;

  /// Null where conversion isn't available (tests, non-Android).
  final MediaConverter? _converter;
  final Future<LocalMedia?> Function(String assetId) _resolveAsset;

  static const _assetScheme = 'asset:';

  @override
  bool canCast(CastDevice d) => d.location != null && d.type != DeviceType.chromecast && d.type != DeviceType.miracast;

  @override
  Future<void> load(CastDevice device, CastMedia media, {bool forceConvert = false, PrepareProgress? onPrepare}) async {
    final source = media.url;
    if (source == null || source.isEmpty) throw UnsupportedError('There is nothing to send for “${media.title}”.');
    final host = await _hostFor(device.address);
    if (host == null) throw StateError('This phone has no Wi-Fi or hotspot address the TV can reach.');

    final fallbackMime = switch (media.kind) {
      CastKind.photo => 'image/jpeg',
      CastKind.music => 'audio/mpeg',
      _ => 'video/mp4',
    };

    final String url;
    var mime = MediaServer.mimeFor(source, fallback: fallbackMime);
    if (source.startsWith('http://') || source.startsWith('https://')) {
      // TVs can't send the page's Referer/Cookie, and many can't do TLS, so
      // anything but a plain header-free http:// URL goes through the phone.
      // HLS playlists are rewritten there so their segments do too.
      url = media.headers.isEmpty && source.startsWith('http://')
          ? source
          : (await _server.publishProxy(source, media.headers, host: host, mime: mime)).toString();
    } else {
      var path = source;
      if (source.startsWith(_assetScheme)) {
        final local = await _resolveAsset(source.substring(_assetScheme.length));
        if (local == null) throw StateError('“${media.title}” is no longer on this phone.');
        path = local.path;
        mime = local.mime ?? MediaServer.mimeFor(path, fallback: fallbackMime);
      } else {
        mime = MediaServer.mimeFor(path, fallback: fallbackMime);
      }
      final prepared = await _prepare(device, media, path, mime, forceConvert: forceConvert, onPrepare: onPrepare);
      path = prepared.path;
      mime = prepared.mime;
      url = (await _server.publishFile(path, host: host, mime: mime)).toString();
    }
    await _dlna.load(device, url: url, title: media.title, mime: mime, kind: media.kind.name);
  }

  /// Converts the file when the TV can't play it (or after it failed to).
  Future<({String path, String mime})> _prepare(
    CastDevice device,
    CastMedia media,
    String path,
    String mime, {
    required bool forceConvert,
    PrepareProgress? onPrepare,
  }) async {
    final converter = _converter;
    if (converter == null || !converter.available) return (path: path, mime: mime);

    final Conversion conversion;
    MediaProbe? probe;
    if (forceConvert) {
      probe = media.kind == CastKind.video ? await converter.probe(path) : null;
      conversion = fallbackConversionFor(media.kind);
    } else if (media.kind == CastKind.photo || media.kind == CastKind.video || media.kind == CastKind.music) {
      final formats = await _dlna.formats(device);
      // Videos are always looked into: a sound the TV can't decode plays silent.
      probe = media.kind == CastKind.video ? await converter.probe(path) : null;
      conversion = conversionFor(kind: media.kind, mime: mime, probe: probe, formats: formats);
    } else {
      conversion = Conversion.none;
    }
    final detail = conversionLabel(conversion: conversion, mime: mime, probe: probe);

    switch (conversion) {
      case Conversion.none:
        return (path: path, mime: mime);
      case Conversion.jpeg:
        onPrepare?.call(null, detail);
        return (path: await converter.toJpeg(path), mime: 'image/jpeg');
      case Conversion.mp4:
        onPrepare?.call(0, detail);
        final out = await converter.toMp4(path, id: media.id, onProgress: (p) => onPrepare?.call(p, detail));
        return (path: out, mime: 'video/mp4');
      case Conversion.aac:
        onPrepare?.call(0, detail);
        final out = await converter.toAac(path, id: media.id, onProgress: (p) => onPrepare?.call(p, detail));
        return (path: out, mime: 'audio/mp4');
    }
  }

  @override
  Future<void> play(CastDevice d) => _dlna.play(d);
  @override
  Future<void> pause(CastDevice d) => _dlna.pause(d);
  @override
  Future<void> seek(CastDevice d, Duration to) => _dlna.seekTo(d, to);
  @override
  Future<void> stop(CastDevice d) => _dlna.stop(d);
  @override
  Future<void> setVolume(CastDevice d, double level) => _dlna.setVolumeLevel(d, level);

  @override
  Future<CasterStatus?> status(CastDevice d) async {
    try {
      return await _dlna.status(d);
    } catch (e) {
      dlog('[MediaCaster] status failed: $e');
      return null;
    }
  }

  @override
  Future<void> endSession() async {
    await _server.reset();
    await _converter?.clearCache();
  }
}

final mediaServerProvider = Provider<MediaServer>((ref) {
  final server = MediaServer();
  ref.onDispose(server.stop);
  return server;
});

final mediaConverterProvider = Provider<MediaConverter>((ref) {
  final converter = MediaConverter();
  ref.onDispose(converter.clearCache);
  return converter;
});

final mediaCasterProvider = Provider<MediaCaster>(
  (ref) => DlnaMediaCaster(
    ref.watch(dlnaClientProvider),
    ref.watch(mediaServerProvider),
    converter: ref.watch(mediaConverterProvider),
  ),
);
