import '../../../core/debug_log.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../domain/cast_device.dart';

/// Control ports to try. Overridable so tests can run fake TVs on local ports.
@immutable
class ProbePorts {
  const ProbePorts({
    this.roku = 8060,
    this.androidRemote = 6466,
    this.androidPairing = 6467,
    this.samsung = 8001,
    this.lg = 3000,
    this.lgTls = 3001,
    this.samsungTls = 8002,
  });

  final int samsungTls;
  final int roku;
  final int androidRemote;
  final int androidPairing;
  final int samsung;
  final int lg;
  final int lgTls;
}

/// Finds out how a TV can be controlled by asking it: each known control
/// protocol is tried on its own port, in parallel. The TV's brand is never
/// consulted for the decision, so a brand that is not in any list (TCL, Hisense,
/// Xiaomi, Sharp, an unknown white-label set…) is controlled by whatever it
/// actually answers to.
class ProtocolProber {
  ProtocolProber({
    this.ports = const ProbePorts(),
    this.timeout = const Duration(milliseconds: 1500),
    this.lookupRenderer = true,
  });

  final ProbePorts ports;
  final Duration timeout;

  /// Search the network for the TV's DLNA renderer when discovery didn't keep it.
  final bool lookupRenderer;

  /// Every key protocol the TV at [device] answers to, best first (a TCL Roku
  /// TV also runs DLNA; a Google TV also runs Cast, so the key protocol wins).
  Future<List<RemoteProtocol>> detect(CastDevice device) async {
    final host = device.address;
    final brand = '${device.name} ${device.model ?? ''}'.toLowerCase();

    final found = await Future.wait([
      _roku(host),
      _tcpOpen(host, ports.androidRemote),
      _tcpOpen(host, ports.androidPairing),
      _samsung(host),
      _tcpOpen(host, ports.lg),
      _tcpOpen(host, ports.lgTls),
      _tcpOpen(host, ports.samsungTls),
    ]);
    final roku = found[0];
    final androidTv = found[1] || found[2];
    // Newer Samsung models answer on the TLS port (8002) even when 8001's API doesn't.
    final samsung = found[3] || found[6];
    // Port 3000 is common on unrelated dev servers; trust it only with 3001
    // (webOS TLS) or an LG/webOS hint in what the TV told us about itself.
    final lg = found[5] || (found[4] && (brand.contains('lg') || brand.contains('webos')));

    final detected = <RemoteProtocol>[
      if (roku) RemoteProtocol.roku,
      if (androidTv) RemoteProtocol.androidTv,
      if (samsung) RemoteProtocol.samsung,
      if (lg) RemoteProtocol.lg,
    ];
    dlog(
      '[ProtocolProber] ${device.name} @$host '
      'roku=$roku androidTv=$androidTv samsung=$samsung lg=$lg '
      '(type=${device.type.name}, model=${device.model})',
    );
    return detected;
  }

  /// Returns [device] tagged with its best protocol, with a corrected type.
  /// Never throws.
  Future<CastDevice> identify(CastDevice device) async {
    if (device.address.isEmpty || device.type == DeviceType.miracast) return device;
    try {
      // Detection and the renderer lookup are independent: run them together.
      final results = await Future.wait<Object?>([detect(device), _renderer(device)]);
      final detected = results[0]! as List<RemoteProtocol>;
      final withLocation = device.copyWith(location: results[1] as String?);

      // A TV that really answers one of the key protocols keeps exactly the
      // behaviour listed TVs always had (same protocol, same pairing, same keys).
      // Only a TV that answers none of them gets the DLNA path; a stale saved
      // port or brand guess is not proof that a protocol exists.
      final RemoteProtocol? best;
      if (detected.isNotEmpty) {
        best = detected.first;
      } else if (withLocation.type == DeviceType.dlna || withLocation.type == DeviceType.smartTv) {
        // No key channel at all: only what DLNA offers (play, seek, volume, casting).
        best = RemoteProtocol.dlna;
      } else {
        best = null; // Chromecast / Fire TV with nothing else open: unchanged
      }
      dlog('[ProtocolProber] -> ${best?.name ?? 'unchanged'}, renderer=${withLocation.location}');
      if (best == null) return withLocation;
      return withLocation.copyWith(protocol: best, type: _typeFor(best, withLocation.type));
    } catch (e) {
      dlog('[ProtocolProber] failed for ${device.name}: $e');
      return device;
    }
  }

  /// The DLNA description to use: the saved/discovered one if it really offers
  /// AVTransport, otherwise (a DIAL/Netflix description kept by mistake, or none)
  /// a fresh search for the renderer.
  Future<String?> _renderer(CastDevice device) async {
    final known = device.location;
    if (!lookupRenderer) return known;
    if (known != null && await _hasAvTransport(known)) return known;
    return findRenderer(device.address);
  }

  Future<bool> _hasAvTransport(String location) async {
    try {
      final uri = Uri.parse(location);
      final body = await _get(uri.host, uri.port, uri.path.isEmpty ? '/' : uri.path);
      return body != null && body.contains(':AVTransport:');
    } catch (_) {
      return false;
    }
  }

  /// Finds the DLNA MediaRenderer description of the TV at [host]. A TV can
  /// publish several UPnP devices on one IP (DIAL, Netflix, the renderer), and
  /// discovery may have kept the wrong one, so ask again for the renderer and
  /// keep only the answer that comes from this TV. Null when it has none.
  Future<String?> findRenderer(String host) async {
    RawDatagramSocket? socket;
    try {
      socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.multicastHops = 4;
      final found = Completer<String?>();
      socket.listen((event) {
        if (event != RawSocketEvent.read) return;
        final dg = socket!.receive();
        if (dg == null || dg.address.address != host || found.isCompleted) return;
        final text = String.fromCharCodes(dg.data);
        final st = RegExp(r'^st:\s*(.+)$', multiLine: true, caseSensitive: false).firstMatch(text)?.group(1) ?? '';
        final loc = RegExp(r'^location:\s*(.+)$', multiLine: true, caseSensitive: false).firstMatch(text)?.group(1);
        if (loc != null && (st.contains('MediaRenderer') || st.contains('AVTransport'))) found.complete(loc.trim());
      });
      final group = InternetAddress('239.255.255.250');
      for (var round = 0; round < 2; round++) {
        for (final st in const ['urn:schemas-upnp-org:device:MediaRenderer:1', 'urn:schemas-upnp-org:service:AVTransport:1']) {
          socket.send(
            'M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: "ssdp:discover"\r\nMX: 1\r\nST: $st\r\n\r\n'.codeUnits,
            group,
            1900,
          );
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      return await found.future.timeout(const Duration(milliseconds: 2200), onTimeout: () => null);
    } catch (e) {
      dlog('[ProtocolProber] renderer lookup failed: $e');
      return null;
    } finally {
      socket?.close();
    }
  }

  /// A TV that answers a key protocol is a TV, whatever SSDP called it.
  static DeviceType _typeFor(RemoteProtocol p, DeviceType current) => switch (p) {
    RemoteProtocol.roku => DeviceType.roku,
    RemoteProtocol.androidTv || RemoteProtocol.samsung || RemoteProtocol.lg =>
      current == DeviceType.chromecast || current == DeviceType.fireTv ? current : DeviceType.smartTv,
    RemoteProtocol.dlna => current,
  };

  Future<bool> _tcpOpen(String host, int port) async {
    try {
      final s = await Socket.connect(host, port, timeout: timeout);
      s.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> _get(String host, int port, String path) async {
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final req = await client.getUrl(Uri.parse('http://$host:$port$path')).timeout(timeout);
      final res = await req.close().timeout(timeout);
      if (res.statusCode != 200) {
        await res.drain<void>();
        return null;
      }
      final chunks = await res.timeout(timeout).fold<List<int>>([], (a, b) => a..addAll(b));
      return String.fromCharCodes(chunks);
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  Future<bool> _roku(String host) async {
    final body = await _get(host, ports.roku, '/query/device-info');
    return body != null && body.contains('<device-info');
  }

  Future<bool> _samsung(String host) async {
    final body = await _get(host, ports.samsung, '/api/v2/');
    if (body == null) return false;
    final b = body.toLowerCase();
    return b.contains('"device"') || b.contains('samsung') || b.contains('tizen');
  }
}
