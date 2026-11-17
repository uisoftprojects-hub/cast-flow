import '../../../core/debug_log.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

/// Serves the phone's files (and header-protected web videos) to a TV over the
/// local network. The TV pulls the media from here, with Range support so it
/// can seek. Only items that were published are reachable, each behind an
/// unguessable token.
class MediaServer {
  MediaServer({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  HttpServer? _server;
  final _entries = <String, _Entry>{};
  final _random = Random.secure();

  static const _mimeByExt = {
    'mp4': 'video/mp4',
    'm4v': 'video/mp4',
    'mkv': 'video/x-matroska',
    'mov': 'video/quicktime',
    'webm': 'video/webm',
    'avi': 'video/x-msvideo',
    '3gp': 'video/3gpp',
    'ts': 'video/mp2t',
    'm3u8': 'application/vnd.apple.mpegurl',
    'mp3': 'audio/mpeg',
    'm4a': 'audio/mp4',
    'aac': 'audio/aac',
    'wav': 'audio/wav',
    'flac': 'audio/flac',
    'ogg': 'audio/ogg',
    'opus': 'audio/ogg',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'webp': 'image/webp',
    'bmp': 'image/bmp',
  };

  /// MIME type from a file name or URL; [fallback] when the extension is unknown.
  static String mimeFor(String nameOrUrl, {required String fallback}) {
    final path = Uri.tryParse(nameOrUrl)?.path ?? nameOrUrl;
    final dot = path.lastIndexOf('.');
    if (dot < 0) return fallback;
    return _mimeByExt[path.substring(dot + 1).toLowerCase()] ?? fallback;
  }

  /// This phone's LAN address as the TV at [tvHost] can reach it: the address
  /// on the same /24 as the TV, otherwise any private IPv4 (hotspot included).
  static Future<String?> lanIpFor(String tvHost) async {
    try {
      final ifaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      final all = [for (final i in ifaces) ...i.addresses.where((a) => !a.isLoopback)].map((a) => a.address).toList();
      final prefix = tvHost.split('.').take(3).join('.');
      for (final a in all) {
        if (a.startsWith('$prefix.')) return a;
      }
      for (final a in all) {
        if (_isPrivate(a)) return a;
      }
    } catch (_) {}
    return null;
  }

  static bool _isPrivate(String a) {
    final p = a.split('.').map(int.tryParse).toList();
    if (p.length != 4 || p.contains(null)) return false;
    return p[0] == 10 || (p[0] == 172 && p[1]! >= 16 && p[1]! <= 31) || (p[0] == 192 && p[1] == 168);
  }

  /// Makes a local file reachable and returns the URL the TV should open.
  Future<Uri> publishFile(String path, {required String host, String? mime}) async {
    final file = File(path);
    if (!await file.exists()) throw FileSystemException('The file is no longer available.', path);
    final name = path.split(RegExp(r'[\\/]')).last;
    return _publish(_Entry(file: file, mime: mime ?? mimeFor(name, fallback: 'application/octet-stream')), name, host);
  }

  /// Makes a web URL reachable through this phone, so request headers the
  /// page needs (Referer, Cookie, User-Agent) are attached for the TV.
  Future<Uri> publishProxy(String url, Map<String, String> headers, {required String host, String? mime}) {
    final name = Uri.parse(url).pathSegments.lastWhere((s) => s.isNotEmpty, orElse: () => 'media');
    return _publish(_Entry(url: url, headers: headers, mime: mime ?? mimeFor(url, fallback: 'video/mp4')), name, host);
  }

  Future<Uri> _publish(_Entry entry, String name, String host) async {
    final server = _server ??= await _start();
    final token = List.generate(16, (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
    _entries[token] = entry;
    // The file name's extension helps TVs choose a decoder.
    return Uri(scheme: 'http', host: host, port: server.port, pathSegments: ['m', token, Uri.encodeComponent(name)]);
  }

  Future<HttpServer> _start() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    server.listen(_handle, onError: (Object e) => dlog('[MediaServer] $e'));
    dlog('[MediaServer] listening on port ${server.port}');
    return server;
  }

  Future<void> stop() async {
    final s = _server;
    _server = null;
    _entries.clear();
    await s?.close(force: true);
  }

  // ------------------------------------------------------------- handling

  Future<void> _handle(HttpRequest req) async {
    final res = req.response;
    try {
      final seg = req.uri.pathSegments;
      final entry = seg.length >= 2 && seg[0] == 'm' ? _entries[seg[1]] : null;
      if (entry == null || (req.method != 'GET' && req.method != 'HEAD')) {
        res.statusCode = HttpStatus.notFound;
        await res.close();
        return;
      }
      if (entry.file != null) {
        await _serveFile(req, entry);
      } else {
        await _serveProxy(req, entry);
      }
    } catch (e) {
      dlog('[MediaServer] ${req.uri.path}: $e');
      try {
        await res.close();
      } catch (_) {}
    }
  }

  void _dlnaHeaders(HttpResponse res, String mime) {
    res.headers
      ..set('Accept-Ranges', 'bytes')
      ..set('transferMode.dlna.org', mime.startsWith('image/') ? 'Interactive' : 'Streaming')
      ..set('contentFeatures.dlna.org', 'DLNA.ORG_OP=01;DLNA.ORG_CI=0;DLNA.ORG_FLAGS=01700000000000000000000000000000')
      ..contentType = ContentType.parse(mime);
  }

  Future<void> _serveFile(HttpRequest req, _Entry e) async {
    final res = req.response;
    final length = await e.file!.length();
    var start = 0;
    var end = length - 1;
    final range = req.headers.value(HttpHeaders.rangeHeader);
    var partial = false;
    if (range != null) {
      final m = RegExp(r'bytes=(\d*)-(\d*)').firstMatch(range);
      if (m != null) {
        final a = m.group(1)!, b = m.group(2)!;
        if (a.isEmpty && b.isNotEmpty) {
          start = max(0, length - int.parse(b)); // suffix range: last N bytes
        } else if (a.isNotEmpty) {
          start = int.parse(a);
          if (b.isNotEmpty) end = min(end, int.parse(b));
        }
        if (start > end || start >= length) {
          res.statusCode = HttpStatus.requestedRangeNotSatisfiable;
          res.headers.set(HttpHeaders.contentRangeHeader, 'bytes */$length');
          await res.close();
          return;
        }
        partial = true;
      }
    }
    _dlnaHeaders(res, e.mime);
    res.statusCode = partial ? HttpStatus.partialContent : HttpStatus.ok;
    if (partial) res.headers.set(HttpHeaders.contentRangeHeader, 'bytes $start-$end/$length');
    res.contentLength = end - start + 1;
    if (req.method == 'HEAD') {
      await res.close();
      return;
    }
    await res.addStream(e.file!.openRead(start, end + 1));
    await res.close();
  }

  Future<void> _serveProxy(HttpRequest req, _Entry e) async {
    final res = req.response;
    final upstream = http.Request(req.method, Uri.parse(e.url!))..headers.addAll(e.headers);
    final range = req.headers.value(HttpHeaders.rangeHeader);
    if (range != null) upstream.headers['Range'] = range;
    final r = await _client.send(upstream);
    res.statusCode = r.statusCode;
    _dlnaHeaders(res, e.mime);
    for (final h in const ['content-length', 'content-range']) {
      final v = r.headers[h];
      if (v != null) res.headers.set(h, v);
    }
    if (req.method == 'HEAD') {
      await res.close();
      return;
    }
    await res.addStream(r.stream);
    await res.close();
  }
}

class _Entry {
  _Entry({this.file, this.url, this.headers = const {}, required this.mime});
  final File? file;
  final String? url;
  final Map<String, String> headers;
  final String mime;
}
