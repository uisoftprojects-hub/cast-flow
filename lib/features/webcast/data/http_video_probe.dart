import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../domain/video_rules.dart';
import '../domain/web_video.dart';

/// Checks a candidate video URL with the page's headers: follows redirects to
/// the absolute final URL, reads type / size, and parses manifests for
/// quality, duration and DRM.
abstract interface class VideoProbe {
  Future<ProbeResult> probe(String url, Map<String, String> headers);
}

class HttpVideoProbe implements VideoProbe {
  static const _timeout = Duration(seconds: 6);
  static const _manifestBytes = 256 * 1024;

  @override
  Future<ProbeResult> probe(String url, Map<String, String> headers) async {
    final client = HttpClient()..connectionTimeout = _timeout;
    try {
      final guess = videoTypeFromUrl(url);
      final req = await client.getUrl(Uri.parse(url)).timeout(_timeout);
      req.followRedirects = true;
      req.maxRedirects = 6;
      headers.forEach((k, v) {
        if (v.isNotEmpty) req.headers.set(k, v);
      });
      // Files: one byte is enough for type + total size. Manifests: the text.
      req.headers.set(
        HttpHeaders.rangeHeader,
        guess != null && guess.isManifest ? 'bytes=0-${_manifestBytes - 1}' : 'bytes=0-0',
      );
      final res = await req.close().timeout(_timeout);
      var finalUrl = Uri.parse(url);
      for (final r in res.redirects) {
        finalUrl = finalUrl.resolveUri(r.location);
      }
      final mime = res.headers.contentType?.mimeType;
      final type = videoTypeFromMime(mime) ?? guess ?? videoTypeFromUrl(finalUrl.toString());
      final length = _totalLength(res);
      if (type == null || !type.isManifest || res.statusCode >= 400) {
        unawaited(res.drain<void>().catchError((_) {}));
        return ProbeResult(
          status: res.statusCode,
          finalUrl: finalUrl.toString(),
          mime: mime,
          length: length,
          type: type,
        );
      }
      final body = await _readText(res);
      final info = type == VideoType.hls ? parseHls(body) : parseDash(body);
      return ProbeResult(
        status: res.statusCode,
        finalUrl: finalUrl.toString(),
        mime: mime,
        type: type,
        height: info.height,
        duration: info.duration,
        protected: info.protected,
        master: info.master,
        mediaPlaylist: info.mediaPlaylist,
      );
    } on Exception {
      return ProbeResult(status: 0, finalUrl: url);
    } finally {
      client.close(force: true);
    }
  }

  int? _totalLength(HttpClientResponse res) {
    final range = res.headers.value(HttpHeaders.contentRangeHeader);
    if (range != null && range.contains('/')) return int.tryParse(range.split('/').last);
    return res.contentLength > 1 ? res.contentLength : null;
  }

  Future<String> _readText(HttpClientResponse res) async {
    final bytes = <int>[];
    await for (final chunk in res.timeout(_timeout)) {
      bytes.addAll(chunk);
      if (bytes.length >= _manifestBytes) break;
    }
    return utf8.decode(bytes, allowMalformed: true);
  }
}
