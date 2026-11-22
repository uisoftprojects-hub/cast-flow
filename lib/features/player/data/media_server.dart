import '../../../core/debug_log.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../../core/platform/network_channel.dart';
import '../../devices/domain/network_status.dart';

/// Serves the phone's files (and header-protected web videos) to a TV over the
/// local network. The TV pulls the media from here, with Range support so it
/// can seek and reconnect. Only items that were published are reachable, each
/// behind an unguessable token.
///
/// Browser casting goes through [publishProxy]: the TV gets a URL on this
/// phone, and the phone fetches the page's video with the page's headers.
/// HLS playlists are rewritten so their segments go through the phone too.
class MediaServer {
  MediaServer({http.Client? client, this.preferredPorts = const [8765, 8766, 8767, 8768, 8769]})
    : _client = client ?? http.Client();

  final http.Client _client;

  /// Tried in order before falling back to any free port: a stable port keeps
  /// the URL a TV already has valid across a server restart.
  final List<int> preferredPorts;

  HttpServer? _server;
  Future<HttpServer>? _starting;
  final _entries = <String, _Entry>{};
  final _random = Random.secure();

  /// Largest playlist that is rewritten in memory.
  static const _maxPlaylistBytes = 4 * 1024 * 1024;

  static const _mimeByExt = {
    'mp4': 'video/mp4',
    'm4v': 'video/mp4',
    'mkv': 'video/x-matroska',
    'mov': 'video/quicktime',
    'webm': 'video/webm',
    'avi': 'video/x-msvideo',
    '3gp': 'video/3gpp',
    'ts': 'video/mp2t',
    'm2ts': 'video/mp2t',
    'mts': 'video/mp2t',
    'm4s': 'video/iso.segment',
    'm3u8': 'application/vnd.apple.mpegurl',
    'mpd': 'application/dash+xml',
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
    'heic': 'image/heic',
    'heif': 'image/heif',
    'avif': 'image/avif',
    'vtt': 'text/vtt',
    'key': 'application/octet-stream',
  };

  /// MIME type from a file name or URL; [fallback] when the extension is unknown.
  static String mimeFor(String nameOrUrl, {required String fallback}) {
    final path = Uri.tryParse(nameOrUrl)?.path ?? nameOrUrl;
    final dot = path.lastIndexOf('.');
    if (dot < 0) return fallback;
    return _mimeByExt[path.substring(dot + 1).toLowerCase()] ?? fallback;
  }

  static bool isPlaylistMime(String mime) {
    final m = mime.toLowerCase();
    return m == 'application/vnd.apple.mpegurl' || m == 'application/x-mpegurl' || m == 'audio/mpegurl';
  }

  /// This phone's LAN address as the TV at [tvHost] can reach it.
  ///
  /// Uses what Android reports for Wi-Fi (wlan0) and the hotspot (the AP
  /// interface, e.g. ap0 / swlan0), with their real subnet sizes: on the
  /// hotspot the TV must be given the AP address, never wlan0, mobile data
  /// (often a private 10.x address too) or a VPN tunnel. Falls back to the
  /// interface list where the platform reports nothing (tests, desktop).
  static Future<String?> lanIpFor(String tvHost) async {
    try {
      final status = NetworkStatus.fromMap(await NetworkChannel.networkStatus());
      final ip = status.addressFor(tvHost);
      if (ip != null) return ip;
    } catch (_) {}
    try {
      final ifaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      return pickLanAddress(tvHost, [
        for (final i in ifaces)
          for (final a in i.addresses.where((a) => !a.isLoopback)) (iface: i.name, ip: a.address),
      ]);
    } catch (_) {}
    return null;
  }

  /// Interfaces that never reach a TV on the LAN.
  static final _notLan = RegExp(r'^(rmnet|r_rmnet|ccmni|pdp|tun|ppp|ipsec|dummy|clat|v4-|utun|wwan)');

  /// Picks our address for [tvHost] from [addresses]: the one on the TV's
  /// /24, otherwise the first private address on a LAN-type interface.
  static String? pickLanAddress(String tvHost, List<({String iface, String ip})> addresses) {
    final lan = addresses.where((a) => !_notLan.hasMatch(a.iface)).toList();
    final prefix = tvHost.split('.').take(3).join('.');
    for (final a in lan) {
      if (a.ip.startsWith('$prefix.')) return a.ip;
    }
    for (final a in lan) {
      if (_isPrivate(a.ip)) return a.ip;
    }
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

  /// Forgets every published item (the cast session ended) and stops the
  /// server; the next publish starts it again.
  Future<void> reset() => stop();

  Future<Uri> _publish(_Entry entry, String name, String host) async {
    final server = await _ensureStarted();
    final token = List.generate(16, (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
    _entries[token] = entry;
    // The file name's extension helps TVs choose a decoder.
    return Uri(scheme: 'http', host: host, port: server.port, pathSegments: ['m', token, name]);
  }

  /// One server at a time; a server that died (closed by the OS, a network
  /// change) is replaced on the next publish.
  Future<HttpServer> _ensureStarted() {
    final running = _server;
    if (running != null) return Future.value(running);
    return _starting ??= _start().whenComplete(() => _starting = null);
  }

  Future<HttpServer> _start() async {
    HttpServer? server;
    for (final port in preferredPorts) {
      try {
        server = await HttpServer.bind(InternetAddress.anyIPv4, port);
        break;
      } on SocketException {
        // In use (another app, or a previous instance still closing): next one.
      }
    }
    server ??= await HttpServer.bind(InternetAddress.anyIPv4, 0);
    // TVs open several connections and keep them around between Range requests.
    server.idleTimeout = const Duration(seconds: 60);
    server.autoCompress = false;
    final s = server;
    final port = s.port; // unreadable once the socket is closed
    _server = s;
    s.listen(
      _handle,
      onError: (Object e) => dlog('[MediaServer] $e'),
      onDone: () {
        if (identical(_server, s)) _server = null;
        dlog('[MediaServer] stopped (port $port)');
      },
    );
    dlog('[MediaServer] listening on port $port');
    return s;
  }

  Future<void> stop() async {
    final s = _server;
    _server = null;
    _entries.clear();
    await s?.close(force: true);
  }

  // ------------------------------------------------------------- handling

  /// Lets TV browsers / web receivers (which send CORS preflights) read the media.
  void _cors(HttpResponse res) {
    res.headers
      ..set('Access-Control-Allow-Origin', '*')
      ..set('Access-Control-Allow-Methods', 'GET, HEAD, OPTIONS')
      ..set('Access-Control-Allow-Headers', 'Range, Content-Type, Origin, Accept')
      ..set('Access-Control-Expose-Headers', 'Content-Length, Content-Range, Accept-Ranges, Content-Type');
  }

  Future<void> _handle(HttpRequest req) async {
    final res = req.response;
    try {
      _cors(res);
      if (req.method == 'OPTIONS') {
        res.statusCode = HttpStatus.noContent;
        await res.close();
        return;
      }
      final seg = req.uri.pathSegments;
      final entry = seg.length >= 2 && seg[0] == 'm' ? _entries[seg[1]] : null;
      if (entry == null || (req.method != 'GET' && req.method != 'HEAD')) {
        res.statusCode = HttpStatus.notFound;
        await res.close();
        return;
      }
      if (entry.file != null) {
        await _serveFile(req, entry);
      } else if (seg.length >= 4 && seg[2] == 'x') {
        // A segment / variant / key referenced by a rewritten playlist.
        final target = _decodeTarget(seg[3]);
        if (target == null) {
          res.statusCode = HttpStatus.notFound;
          await res.close();
          return;
        }
        await _serveProxy(req, entry, target, seg[1]);
      } else {
        await _serveProxy(req, entry, entry.url!, seg[1]);
      }
    } catch (e) {
      // Usually the TV closing a connection mid-transfer (seek / stop). It
      // simply reconnects with a new Range request.
      dlog('[MediaServer] ${req.uri.path}: $e');
      try {
        await res.close();
      } catch (_) {}
    }
  }

  void _dlnaHeaders(HttpResponse res, String mime, {bool seekable = true}) {
    res.headers
      ..set('Accept-Ranges', seekable ? 'bytes' : 'none')
      ..set('transferMode.dlna.org', mime.startsWith('image/') ? 'Interactive' : 'Streaming')
      ..set(
        'contentFeatures.dlna.org',
        'DLNA.ORG_OP=${seekable ? '01' : '00'};DLNA.ORG_CI=0;DLNA.ORG_FLAGS=01700000000000000000000000000000',
      )
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

  /// Opens [url] upstream with the page's headers. One retry on a dropped
  /// connection: a TV that reconnects (seek, buffer) shouldn't fail because
  /// the first attempt hit a stale keep-alive socket.
  Future<http.StreamedResponse> _fetch(String method, String url, Map<String, String> headers, String? range) async {
    Object? last;
    for (var attempt = 0; attempt < 2; attempt++) {
      final upstream = http.Request(method, Uri.parse(url))
        ..followRedirects = true
        ..headers.addAll(headers)
        // The byte counts must match what the TV is told: no gzip in between.
        ..headers['Accept-Encoding'] = 'identity';
      if (range != null) upstream.headers['Range'] = range;
      try {
        return await _client.send(upstream).timeout(const Duration(seconds: 20));
      } on TimeoutException {
        rethrow;
      } catch (e) {
        last = e;
      }
    }
    throw last!;
  }

  Future<void> _serveProxy(HttpRequest req, _Entry e, String url, String token) async {
    final res = req.response;
    final range = req.headers.value(HttpHeaders.rangeHeader);
    final r = await _fetch(req.method, url, e.headers, range);
    final upstreamType = r.headers['content-type']?.split(';').first.trim().toLowerCase();
    final mime = _bestMime(upstreamType, url, url == e.url ? e.mime : null);

    if (isPlaylistMime(mime) && r.statusCode < 300) {
      await _servePlaylist(req, r, url, token, mime);
      return;
    }

    res.statusCode = r.statusCode;
    _dlnaHeaders(res, mime, seekable: r.headers['accept-ranges'] != 'none');
    for (final h in const ['content-length', 'content-range']) {
      final v = r.headers[h];
      if (v != null) res.headers.set(h, v);
    }
    if (req.method == 'HEAD') {
      await r.stream.listen((_) {}).cancel();
      await res.close();
      return;
    }
    await res.addStream(r.stream);
    await res.close();
  }

  /// The upstream's own media type when it says something useful, else the
  /// published one, else a guess from the URL.
  static String _bestMime(String? upstream, String url, String? published) {
    const vague = {'application/octet-stream', 'binary/octet-stream', 'text/plain', 'text/html', ''};
    if (upstream != null && !vague.contains(upstream)) return upstream;
    final byUrl = mimeFor(url, fallback: '');
    if (byUrl.isNotEmpty) return byUrl;
    return published ?? 'video/mp4';
  }

  /// Rewrites an HLS playlist so every URI in it (variants, segments, keys,
  /// init maps, alternate renditions) points back at this server under the
  /// same token: segments then get the page's headers too, and relative URIs
  /// no longer resolve against the phone's URL (which used to 404).
  Future<void> _servePlaylist(HttpRequest req, http.StreamedResponse r, String url, String token, String mime) async {
    final res = req.response;
    final bytes = <int>[];
    await for (final chunk in r.stream) {
      bytes.addAll(chunk);
      if (bytes.length > _maxPlaylistBytes) throw const HttpException('Playlist too large');
    }
    final base = Uri.parse(url);
    final origin = req.requestedUri;
    String proxied(String ref) {
      final abs = base.resolve(ref.trim()).toString();
      final name = Uri.parse(abs).pathSegments.lastWhere((s) => s.isNotEmpty, orElse: () => 'media');
      return Uri(
        scheme: 'http',
        host: origin.host,
        port: origin.port,
        pathSegments: ['m', token, 'x', _encodeTarget(abs), name],
      ).toString();
    }

    final text = rewritePlaylist(utf8.decode(bytes, allowMalformed: true), proxied);
    final body = utf8.encode(text);
    res.statusCode = HttpStatus.ok;
    res.headers
      ..contentType = ContentType.parse(mime)
      ..set('Cache-Control', 'no-cache');
    res.contentLength = body.length;
    if (req.method != 'HEAD') res.add(body);
    await res.close();
  }

  /// Applies [map] to every URI of an M3U8 playlist: plain URI lines and
  /// URI="..." attributes of tags (EXT-X-KEY, EXT-X-MAP, EXT-X-MEDIA, ...).
  static String rewritePlaylist(String playlist, String Function(String uri) map) {
    final attr = RegExp(r'URI="([^"]*)"');
    return const LineSplitter()
        .convert(playlist)
        .map((line) {
          final t = line.trim();
          if (t.isEmpty) return line;
          if (t.startsWith('#')) {
            return t.contains('URI="')
                ? line.replaceAllMapped(attr, (m) => m.group(1)!.startsWith('data:') ? m.group(0)! : 'URI="${map(m.group(1)!)}"')
                : line;
          }
          return map(t);
        })
        .join('\n');
  }

  static String _encodeTarget(String url) => base64Url.encode(utf8.encode(url)).replaceAll('=', '');

  static String? _decodeTarget(String s) {
    try {
      final padded = s.padRight((s.length + 3) ~/ 4 * 4, '=');
      final url = utf8.decode(base64Url.decode(padded));
      final u = Uri.parse(url);
      return (u.scheme == 'http' || u.scheme == 'https') ? url : null;
    } catch (_) {
      return null;
    }
  }
}

class _Entry {
  _Entry({this.file, this.url, this.headers = const {}, required this.mime});
  final File? file;
  final String? url;
  final Map<String, String> headers;
  final String mime;
}
