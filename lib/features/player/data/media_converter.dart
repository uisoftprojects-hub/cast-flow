import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../domain/tv_formats.dart';

/// Converts media a TV can't play (Android: MediaConvert.kt, media3
/// Transformer / JPEG). The work runs on native background threads; this
/// class only waits for it. Converted files are cached for the cast session
/// and deleted by [clearCache].
class MediaConverter {
  MediaConverter() {
    if (available) _channel.setMethodCallHandler(_onCall);
  }

  static const _channel = MethodChannel('castflow/media_convert');

  final _progress = <String, void Function(double)>{};

  bool get available =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<Object?> _onCall(MethodCall call) async {
    if (call.method == 'progress') {
      final args = call.arguments as Map<Object?, Object?>;
      final p = (args['progress'] as num?)?.toDouble();
      final cb = _progress[args['id']];
      if (cb != null && p != null) cb(p.clamp(0, 1));
    }
    return null;
  }

  /// Container and codecs of a local file, or null when unknown.
  Future<MediaProbe?> probe(String path) async {
    if (!available) return null;
    try {
      final raw = await _channel.invokeMethod<Map<Object?, Object?>>('probe', {
        'path': path,
      });
      return raw == null ? null : MediaProbe.fromMap(raw);
    } catch (_) {
      return null;
    }
  }

  /// Returns the path of a JPEG copy of the image at [path].
  Future<String> toJpeg(String path) async {
    final out = await _channel.invokeMethod<String>('convertImage', {
      'path': path,
    });
    if (out == null) throw StateError('The photo couldn’t be converted.');
    return out;
  }

  /// Returns the path of an MP4 (H.264 + AAC) copy of the video at [path].
  /// [onProgress] gets 0..1 while it runs.
  Future<String> toMp4(
    String path, {
    required String id,
    void Function(double)? onProgress,
  }) async {
    if (onProgress != null) _progress[id] = onProgress;
    try {
      final out = await _channel.invokeMethod<String>('convertVideo', {
        'path': path,
        'id': id,
      });
      if (out == null) throw StateError('The video couldn’t be converted.');
      return out;
    } finally {
      _progress.remove(id);
    }
  }

  /// Returns the path of an M4A (AAC) copy of the audio file at [path].
  Future<String> toAac(String path, {required String id, void Function(double)? onProgress}) async {
    if (onProgress != null) _progress[id] = onProgress;
    try {
      final out = await _channel.invokeMethod<String>('convertAudio', {'path': path, 'id': id});
      if (out == null) throw StateError('The audio couldn’t be converted.');
      return out;
    } finally {
      _progress.remove(id);
    }
  }

  /// Stops any running conversion (its future fails).
  Future<void> cancelAll() async {
    if (!available) return;
    await _channel.invokeMethod<bool>('cancel').catchError((_) => false);
  }

  /// Cancels running work and deletes every converted file.
  Future<void> clearCache() async {
    if (!available) return;
    await _channel.invokeMethod<bool>('clearCache').catchError((_) => false);
  }
}
