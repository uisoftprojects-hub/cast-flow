import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../devices/domain/cast_device.dart';
import '../../remote/data/dlna_client.dart';
import '../domain/cast_media.dart';
import 'media_server.dart';

/// What a receiver reports while it plays.
typedef CasterStatus = ({String state, Duration position, Duration length});

/// Sends media to a receiver and controls its playback.
abstract interface class MediaCaster {
  /// Whether [device] can receive media from this caster.
  bool canCast(CastDevice device);

  Future<void> load(CastDevice device, CastMedia media);
  Future<void> play(CastDevice device);
  Future<void> pause(CastDevice device);
  Future<void> seek(CastDevice device, Duration to);
  Future<void> stop(CastDevice device);

  /// [level] is 0..1.
  Future<void> setVolume(CastDevice device, double level);
  Future<CasterStatus?> status(CastDevice device);
}

/// DLNA/UPnP casting: the phone serves the file, the TV is told its URL.
class DlnaMediaCaster implements MediaCaster {
  DlnaMediaCaster(this._dlna, this._server, {Future<String?> Function(String tvHost)? hostFor})
    : _hostFor = hostFor ?? MediaServer.lanIpFor;

  final DlnaClient _dlna;
  final MediaServer _server;

  /// This phone's address as seen from the TV (overridable for tests).
  final Future<String?> Function(String tvHost) _hostFor;

  @override
  bool canCast(CastDevice d) => d.location != null && d.type != DeviceType.chromecast && d.type != DeviceType.miracast;

  @override
  Future<void> load(CastDevice device, CastMedia media) async {
    final source = media.url;
    if (source == null || source.isEmpty) throw UnsupportedError('There is nothing to send for “${media.title}”.');
    final host = await _hostFor(device.address);
    if (host == null) throw StateError('This phone has no Wi-Fi address the TV can reach.');

    final fallbackMime = switch (media.kind) {
      CastKind.photo => 'image/jpeg',
      CastKind.music => 'audio/mpeg',
      _ => 'video/mp4',
    };
    final mime = MediaServer.mimeFor(source, fallback: fallbackMime);

    final String url;
    if (source.startsWith('http://') || source.startsWith('https://')) {
      // TVs can't send the page's Referer/Cookie, so those go through the phone.
      // Plain https files also go through it (many renderers can't do TLS), but
      // HLS/DASH manifests can't: their relative segment URLs would break.
      final manifest = mime == 'application/vnd.apple.mpegurl' || source.toLowerCase().contains('.mpd');
      url = media.headers.isEmpty && (source.startsWith('http://') || manifest)
          ? source
          : (await _server.publishProxy(source, media.headers, host: host, mime: mime)).toString();
    } else {
      url = (await _server.publishFile(source, host: host, mime: mime)).toString();
    }
    await _dlna.load(device, url: url, title: media.title, mime: mime, kind: media.kind.name);
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
    } catch (_) {
      return null;
    }
  }
}

final mediaServerProvider = Provider<MediaServer>((ref) {
  final server = MediaServer();
  ref.onDispose(server.stop);
  return server;
});

final mediaCasterProvider = Provider<MediaCaster>(
  (ref) => DlnaMediaCaster(ref.watch(dlnaClientProvider), ref.watch(mediaServerProvider)),
);
