import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../../devices/domain/cast_device.dart';
import '../../devices/domain/receiver_capabilities.dart';

/// Real TV volume and mute over the Google Cast receiver channel (TLS 8009).
/// Any TV with Chromecast built-in answers it, whatever the brand, and it needs
/// no pairing. DLNA's own volume is often a player-only value that doesn't
/// change the TV, which is why this exists.
class CastVolumeClient {
  CastVolumeClient({this.port = 8009, this.timeout = const Duration(seconds: 4)});

  final int port;
  final Duration timeout;

  static const step = 0.05;

  /// Devices whose Cast port refused us; not retried (every press would wait).
  final _unreachable = <String>{};

  static const supported = {RemoteCommand.volumeUp, RemoteCommand.volumeDown, RemoteCommand.mute};

  /// Whether this client may handle [device] (it has not refused us before).
  bool available(CastDevice device) => !_unreachable.contains(device.address);

  /// Sends [command]. Throws [SocketException]/[TimeoutException] when the TV
  /// has no Cast receiver, after remembering that.
  Future<void> send(CastDevice device, RemoteCommand command) async {
    if (!supported.contains(command)) throw UnsupportedError('${command.label} isn’t a volume command.');
    try {
      await _session(device.address, (ch) async {
        final status = await ch.request('urn:x-cast:com.google.cast.receiver', {'type': 'GET_STATUS'});
        final vol = ((status['status'] as Map?)?['volume'] as Map?) ?? const {};
        final level = (vol['level'] as num?)?.toDouble() ?? 0.3;
        final muted = vol['muted'] == true;
        switch (command) {
          case RemoteCommand.volumeUp:
            await ch.request('urn:x-cast:com.google.cast.receiver', {
              'type': 'SET_VOLUME',
              'volume': {'level': (level + step).clamp(0.0, 1.0), 'muted': false},
            });
          case RemoteCommand.volumeDown:
            await ch.request('urn:x-cast:com.google.cast.receiver', {
              'type': 'SET_VOLUME',
              'volume': {'level': (level - step).clamp(0.0, 1.0)},
            });
          default:
            await ch.request('urn:x-cast:com.google.cast.receiver', {
              'type': 'SET_VOLUME',
              'volume': {'muted': !muted},
            });
        }
      });
    } on SocketException {
      _unreachable.add(device.address);
      rethrow;
    }
  }

  Future<T> _session<T>(String host, Future<T> Function(_Channel) body) async {
    final socket = await SecureSocket.connect(host, port, onBadCertificate: (_) => true, timeout: timeout);
    final ch = _Channel(socket);
    try {
      ch.send('urn:x-cast:com.google.cast.tp.connection', {'type': 'CONNECT'});
      return await body(ch).timeout(timeout);
    } finally {
      socket.destroy();
    }
  }

  // ------------------------------------------------------ wire format

  /// `CastMessage` protobuf, length-prefixed (4 bytes, big endian).
  @visibleForTesting
  static Uint8List encode(String namespace, String payload, {String source = 'sender-0', String dest = 'receiver-0'}) {
    final body = <int>[
      0x08, 0x00, // protocol_version = CASTV2_1_0
      ..._str(2, source),
      ..._str(3, dest),
      ..._str(4, namespace),
      0x28, 0x00, // payload_type = STRING
      ..._str(6, payload),
    ];
    final out = BytesBuilder()
      ..add([(body.length >> 24) & 0xff, (body.length >> 16) & 0xff, (body.length >> 8) & 0xff, body.length & 0xff])
      ..add(body);
    return out.toBytes();
  }

  /// Reads the namespace (field 4) and string payload (field 6) of a CastMessage.
  @visibleForTesting
  static ({String namespace, String payload}) decode(List<int> m) {
    var i = 0;
    int varint() {
      var v = 0, shift = 0;
      while (true) {
        final b = m[i++];
        v |= (b & 0x7f) << shift;
        if (b < 0x80) return v;
        shift += 7;
      }
    }

    var ns = '', payload = '';
    while (i < m.length) {
      final tag = varint();
      if ((tag & 7) == 0) {
        varint();
      } else {
        final n = varint();
        final s = utf8.decode(m.sublist(i, i + n), allowMalformed: true);
        i += n;
        if (tag >> 3 == 4) ns = s;
        if (tag >> 3 == 6) payload = s;
      }
    }
    return (namespace: ns, payload: payload);
  }

  static List<int> _str(int field, String s) {
    final b = utf8.encode(s);
    final len = <int>[];
    var n = b.length;
    while (n >= 0x80) {
      len.add((n & 0x7f) | 0x80);
      n >>= 7;
    }
    len.add(n);
    return [(field << 3) | 2, ...len, ...b];
  }
}

class _Channel {
  _Channel(this._socket) {
    _socket.listen(_onData, onError: (Object e) => _failAll(e), onDone: () => _failAll(const SocketException('closed')));
  }

  final SecureSocket _socket;
  final _buffer = <int>[];
  final _pending = <int, Completer<Map<String, dynamic>>>{};
  int _next = 0;

  void send(String namespace, Map<String, Object?> payload) =>
      _socket.add(CastVolumeClient.encode(namespace, jsonEncode(payload)));

  Future<Map<String, dynamic>> request(String namespace, Map<String, Object?> payload) {
    final id = ++_next;
    final c = _pending[id] = Completer<Map<String, dynamic>>();
    send(namespace, {...payload, 'requestId': id});
    return c.future;
  }

  void _onData(List<int> data) {
    _buffer.addAll(data);
    while (_buffer.length >= 4) {
      final len = (_buffer[0] << 24) | (_buffer[1] << 16) | (_buffer[2] << 8) | _buffer[3];
      if (_buffer.length < 4 + len) return;
      final msg = _buffer.sublist(4, 4 + len);
      _buffer.removeRange(0, 4 + len);
      try {
        final m = CastVolumeClient.decode(msg);
        final json = jsonDecode(m.payload) as Map<String, dynamic>;
        if (json['type'] == 'PING') {
          send('urn:x-cast:com.google.cast.tp.heartbeat', {'type': 'PONG'});
        }
        final id = json['requestId'];
        if (id is int) _pending.remove(id)?.complete(json);
      } catch (_) {}
    }
  }

  void _failAll(Object e) {
    for (final c in _pending.values) {
      if (!c.isCompleted) c.completeError(e);
    }
    _pending.clear();
  }
}
