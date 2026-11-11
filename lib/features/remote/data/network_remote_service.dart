import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../devices/domain/cast_device.dart';
import '../../devices/domain/receiver_capabilities.dart';
import '../../pairing/data/android_tv_pairing.dart';
import '../../pairing/data/approval_pairing.dart';
import '../../pairing/domain/pairing.dart';
import '../domain/remote_service.dart';

/// Real remote control over the local network:
/// - Roku: External Control Protocol (HTTP, port 8060).
/// - Android TV / Google TV: remote protocol v2 (TLS 6466, paired certificate).
/// - Samsung Tizen: remote-control WebSocket (paired token).
/// Anything else throws a clear "not supported" error instead of pretending.
class NetworkRemoteService implements RemoteService {
  NetworkRemoteService(this._credentials, {this.rokuPort = 8060, this.samsungUri = _samsungDefaultUri});

  /// Overridable so tests can talk to a local fake TV.
  final int rokuPort;
  final Uri Function(CastDevice device, String name, String token) samsungUri;

  static Uri _samsungDefaultUri(CastDevice d, String name, String token) =>
      Uri.parse('wss://${d.address}:8002/api/v2/channels/samsung.remote.control?name=$name$token');

  final CredentialStore _credentials;
  final _android = <String, _AndroidTvChannel>{};
  final _samsung = <String, _SamsungChannel>{};

  @override
  Future<void> send(CastDevice device, RemoteCommand command) async {
    if (device.type == DeviceType.roku) return _roku(device, command);
    if (AndroidTvPairing().handles(device)) return _androidTv(device, command);
    if (SamsungPairing().handles(device)) return _samsungTv(device, command);
    throw UnsupportedError('${command.label} isn’t supported by ${device.name}.');
  }

  // ------------------------------------------------------------------ Roku

  @visibleForTesting
  static const rokuKeys = {
    RemoteCommand.up: 'Up',
    RemoteCommand.down: 'Down',
    RemoteCommand.left: 'Left',
    RemoteCommand.right: 'Right',
    RemoteCommand.ok: 'Select',
    RemoteCommand.back: 'Back',
    RemoteCommand.home: 'Home',
    RemoteCommand.menu: 'Info',
    RemoteCommand.input: 'InputHDMI1',
    RemoteCommand.playPause: 'Play',
    RemoteCommand.previous: 'InstantReplay',
    RemoteCommand.next: 'Fwd',
    RemoteCommand.rewind: 'Rev',
    RemoteCommand.fastForward: 'Fwd',
    RemoteCommand.volumeUp: 'VolumeUp',
    RemoteCommand.volumeDown: 'VolumeDown',
    RemoteCommand.mute: 'VolumeMute',
  };

  Future<void> _roku(CastDevice d, RemoteCommand c) async {
    final key = rokuKeys[c];
    if (key == null) throw UnsupportedError('${c.label} isn’t supported by ${d.name}.');
    final uri = Uri.parse('http://${d.address}:$rokuPort/keypress/$key');
    final res = await http.post(uri).timeout(const Duration(seconds: 3));
    if (res.statusCode != 200) throw HttpException('${d.name} didn’t respond (${res.statusCode}).');
  }

  // ------------------------------------------------------------ Android TV

  @visibleForTesting
  static const androidKeyCodes = {
    RemoteCommand.up: 19,
    RemoteCommand.down: 20,
    RemoteCommand.left: 21,
    RemoteCommand.right: 22,
    RemoteCommand.ok: 23,
    RemoteCommand.back: 4,
    RemoteCommand.home: 3,
    RemoteCommand.menu: 82,
    RemoteCommand.input: 178,
    RemoteCommand.playPause: 85,
    RemoteCommand.previous: 88,
    RemoteCommand.next: 87,
    RemoteCommand.rewind: 89,
    RemoteCommand.fastForward: 90,
    RemoteCommand.volumeUp: 24,
    RemoteCommand.volumeDown: 25,
    RemoteCommand.mute: 164,
  };

  Future<void> _androidTv(CastDevice d, RemoteCommand c) async {
    final code = androidKeyCodes[c];
    if (code == null) throw UnsupportedError('${c.label} isn’t supported by ${d.name}.');
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final ch = _android[d.id] ??= _AndroidTvChannel(d, await _credentials.read(d.id));
        await ch.press(code);
        return;
      } catch (_) {
        _android.remove(d.id)?.close();
        if (attempt == 1) throw HttpException('${d.name} didn’t respond. Pair it again from Devices.');
      }
    }
  }

  // --------------------------------------------------------------- Samsung

  @visibleForTesting
  static const samsungKeys = {
    RemoteCommand.up: 'KEY_UP',
    RemoteCommand.down: 'KEY_DOWN',
    RemoteCommand.left: 'KEY_LEFT',
    RemoteCommand.right: 'KEY_RIGHT',
    RemoteCommand.ok: 'KEY_ENTER',
    RemoteCommand.back: 'KEY_RETURN',
    RemoteCommand.home: 'KEY_HOME',
    RemoteCommand.menu: 'KEY_MENU',
    RemoteCommand.input: 'KEY_SOURCE',
    RemoteCommand.playPause: 'KEY_PLAY',
    RemoteCommand.previous: 'KEY_REWIND',
    RemoteCommand.next: 'KEY_FF',
    RemoteCommand.rewind: 'KEY_REWIND',
    RemoteCommand.fastForward: 'KEY_FF',
    RemoteCommand.volumeUp: 'KEY_VOLUP',
    RemoteCommand.volumeDown: 'KEY_VOLDOWN',
    RemoteCommand.mute: 'KEY_MUTE',
  };

  Future<void> _samsungTv(CastDevice d, RemoteCommand c) async {
    final key = samsungKeys[c];
    if (key == null) throw UnsupportedError('${c.label} isn’t supported by ${d.name}.');
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final ch = _samsung[d.id] ??= _SamsungChannel(d, await _credentials.read(d.id), samsungUri);
        await ch.press(key);
        return;
      } catch (_) {
        _samsung.remove(d.id)?.close();
        if (attempt == 1) throw HttpException('${d.name} didn’t respond. Pair it again from Devices.');
      }
    }
  }

  void dispose() {
    for (final c in _android.values) {
      c.close();
    }
    for (final c in _samsung.values) {
      c.close();
    }
    _android.clear();
    _samsung.clear();
  }
}

/// One persistent Android TV remote connection (reconnects on demand).
class _AndroidTvChannel {
  _AndroidTvChannel(this._device, this._saved);

  final CastDevice _device;
  final String? _saved;
  SecureSocket? _socket;
  Future<void>? _ready;
  final _buffer = <int>[];

  Future<void> _connect() async {
    final ctx = androidTvSecurityContext(_saved);
    if (ctx == null) throw StateError('not paired');
    final s = await SecureSocket.connect(
      _device.address,
      6466,
      context: ctx,
      onBadCertificate: (_) => true,
      timeout: const Duration(seconds: 5),
    );
    _socket = s;
    final configured = Completer<void>();
    s.listen(
      (data) {
        _buffer.addAll(data);
        _drain(configured);
      },
      onError: (_) {
        if (!configured.isCompleted) configured.completeError('connection');
        _socket = null;
        _ready = null;
      },
      onDone: () {
        if (!configured.isCompleted) configured.completeError('closed');
        _socket = null;
        _ready = null;
      },
    );
    await configured.future.timeout(const Duration(seconds: 5));
  }

  /// Reads length-prefixed RemoteMessages: answers configure and ping.
  void _drain(Completer<void> configured) {
    while (_buffer.isNotEmpty) {
      var len = 0, shift = 0, i = 0;
      while (true) {
        if (i >= _buffer.length) return;
        final b = _buffer[i++];
        len |= (b & 0x7f) << shift;
        if (b < 0x80) break;
        shift += 7;
      }
      if (_buffer.length < i + len) return;
      final msg = _buffer.sublist(i, i + len);
      _buffer.removeRange(0, i + len);
      // The first tag tells the message: field 1 = configure, 8 = ping request.
      final field = msg.isEmpty ? 0 : msg.first >> 3;
      if (field == 1) {
        final info = [
          ...atvBytes(1, utf8.encode('Cast to TV')),
          ...atvBytes(2, utf8.encode('Cast to TV')),
          ...atvInt(3, 1),
          ...atvBytes(4, utf8.encode('1')),
          ...atvBytes(5, utf8.encode('androidtv-remote')),
          ...atvBytes(6, utf8.encode('1.0.0')),
        ];
        _write(atvBytes(1, [...atvInt(1, 622), ...atvBytes(2, info)]));
        _write(atvBytes(2, atvInt(1, 622))); // set active
        if (!configured.isCompleted) configured.complete();
      } else if (field == 8) {
        _write(atvBytes(9, atvInt(1, 1))); // ping response
      }
    }
  }

  void _write(List<int> message) => _socket?.add([...atvVarint(message.length), ...message]);

  Future<void> press(int keyCode) async {
    await (_ready ??= _connect());
    // key_inject { key_code, direction = SHORT }
    _write(atvBytes(10, [...atvInt(1, keyCode), ...atvInt(2, 3)]));
  }

  void close() => _socket?.destroy();
}

/// One persistent Samsung remote WebSocket.
class _SamsungChannel {
  _SamsungChannel(this._device, this._token, this._uri);

  final Uri Function(CastDevice, String, String) _uri;

  final CastDevice _device;
  final String? _token;
  WebSocket? _ws;
  Future<void>? _ready;

  Future<void> _connect() async {
    final name = base64.encode(utf8.encode('Cast to TV'));
    final token = _token == null || _token.isEmpty ? '' : '&token=$_token';
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 5)
      ..badCertificateCallback = (_, _, _) => true;
    final ws = await WebSocket.connect(_uri(_device, name, token).toString(), customClient: client);
    _ws = ws;
    final connected = Completer<void>();
    ws.listen(
      (data) {
        try {
          final m = jsonDecode(data as String) as Map<String, dynamic>;
          if (m['event'] == 'ms.channel.connect' && !connected.isCompleted) connected.complete();
          if (m['event'] == 'ms.channel.unauthorized' && !connected.isCompleted) {
            connected.completeError('unauthorized');
          }
        } catch (_) {}
      },
      onError: (_) {
        if (!connected.isCompleted) connected.completeError('connection');
        _ws = null;
        _ready = null;
      },
      onDone: () {
        if (!connected.isCompleted) connected.completeError('closed');
        _ws = null;
        _ready = null;
      },
    );
    await connected.future.timeout(const Duration(seconds: 6));
  }

  Future<void> press(String key) async {
    await (_ready ??= _connect());
    _ws?.add(
      jsonEncode({
        'method': 'ms.remote.control',
        'params': {'Cmd': 'Click', 'DataOfCmd': key, 'Option': 'false', 'TypeOfRemote': 'SendRemoteKey'},
      }),
    );
  }

  void close() => _ws?.close();
}
