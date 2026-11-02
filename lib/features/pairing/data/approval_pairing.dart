import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../devices/domain/cast_device.dart';
import '../domain/pairing.dart';

/// Shared plumbing for "Allow on TV" protocols over a WebSocket.
abstract class _WsSession implements PairingSession {
  final _steps = StreamController<PairingStep>();
  WebSocket? _ws;
  bool _closed = false;

  @override
  Stream<PairingStep> get steps => _steps.stream;

  void emit(PairingStep s) {
    if (!_closed && !_steps.isClosed) _steps.add(s);
  }

  Future<void> open(Uri uri, {bool allowSelfSigned = false}) async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 6);
      if (allowSelfSigned) client.badCertificateCallback = (_, _, _) => true; // TVs use self-signed certs
      _ws = await WebSocket.connect(uri.toString(), customClient: client);
      _ws!.listen(
        (data) => onMessage(jsonDecode(data as String) as Map<String, dynamic>),
        onError: (_) => emit(const PairingFailed('connection')),
        onDone: () {
          if (!_closed) emit(const PairingFailed('connection'));
        },
      );
      onOpen();
    } catch (_) {
      emit(const PairingFailed('connection'));
    }
  }

  void send(Map<String, Object?> msg) => _ws?.add(jsonEncode(msg));

  void onOpen() {}
  void onMessage(Map<String, dynamic> msg);

  @override
  Future<void> submitCode(String code) async {}

  @override
  Future<void> close() async {
    _closed = true;
    await _ws?.close();
    await _steps.close();
  }
}

/// Samsung Tizen TVs: the remote-control channel shows "Allow" on the TV and
/// returns a token to reuse next time.
class SamsungPairing implements PairingProtocol {
  @override
  bool handles(CastDevice d) =>
      d.type == DeviceType.smartTv && (d.port == 8001 || d.port == 8002 || (d.model ?? '').toLowerCase().contains('samsung'));

  @override
  PairingSession start(CastDevice device, {String? saved}) => _SamsungSession(device, saved);
}

class _SamsungSession extends _WsSession {
  _SamsungSession(CastDevice d, String? token) {
    final name = base64.encode(utf8.encode('CastFlow'));
    final query = 'name=$name${token == null || token.isEmpty ? '' : '&token=$token'}';
    open(Uri.parse('wss://${d.address}:8002/api/v2/channels/samsung.remote.control?$query'), allowSelfSigned: true);
  }

  Timer? _promptTimer;

  @override
  void onOpen() {
    // A valid token connects at once; otherwise the TV shows its prompt.
    _promptTimer = Timer(const Duration(milliseconds: 1200), () => emit(const AwaitingApproval()));
  }

  @override
  void onMessage(Map<String, dynamic> msg) {
    switch (msg['event']) {
      case 'ms.channel.connect':
        _promptTimer?.cancel();
        emit(PairingDone(((msg['data'] as Map?)?['token'] as String?) ?? ''));
      case 'ms.channel.unauthorized':
        _promptTimer?.cancel();
        emit(const PairingRejected());
      case 'ms.channel.timeOut':
        emit(const PairingFailed('timeout'));
    }
  }

  @override
  Future<void> close() {
    _promptTimer?.cancel();
    return super.close();
  }
}

/// LG webOS TVs: register with a PROMPT pairing; the TV asks the user and
/// returns a client key.
class LgPairing implements PairingProtocol {
  @override
  bool handles(CastDevice d) =>
      d.type == DeviceType.smartTv && (d.port == 3000 || d.port == 3001 || (d.model ?? '').toLowerCase().startsWith('lg'));

  @override
  PairingSession start(CastDevice device, {String? saved}) => _LgSession(device, saved);
}

class _LgSession extends _WsSession {
  _LgSession(CastDevice d, this._key) {
    open(Uri.parse('ws://${d.address}:3000'));
  }

  final String? _key;

  @override
  void onOpen() {
    send({
      'type': 'register',
      'id': 'register_0',
      'payload': {
        'forcePairing': false,
        'pairingType': 'PROMPT',
        if (_key != null && _key.isNotEmpty) 'client-key': _key,
        'manifest': {
          'manifestVersion': 1,
          'appVersion': '1.0',
          'appId': 'com.castflow.castflow',
          'vendorId': 'com.castflow',
          'localizedAppNames': {'': 'CastFlow'},
          'permissions': [
            'LAUNCH',
            'CONTROL_AUDIO',
            'CONTROL_DISPLAY',
            'CONTROL_INPUT_MEDIA_PLAYBACK',
            'CONTROL_POWER',
            'READ_INSTALLED_APPS',
            'CONTROL_INPUT_JOYSTICK',
            'CONTROL_MOUSE_AND_KEYBOARD',
            'READ_CURRENT_CHANNEL',
            'READ_RUNNING_APPS',
          ],
        },
      },
    });
  }

  @override
  void onMessage(Map<String, dynamic> msg) {
    final payload = msg['payload'] as Map?;
    final prompt = payload != null && payload['pairingType'] == 'PROMPT';
    switch (msg['type']) {
      case 'response' when prompt:
        emit(const AwaitingApproval());
      case 'registered':
        emit(PairingDone((payload?['client-key'] as String?) ?? ''));
      case 'error':
        final err = '${msg['error']}'.toLowerCase();
        emit(err.contains('denied') || err.contains('reject') || err.contains('cancel')
            ? const PairingRejected()
            : PairingFailed(err));
    }
  }
}
