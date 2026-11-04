import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart' show RSAPrivateKey, RSAPublicKey, SHA256Digest;

import '../../devices/domain/cast_device.dart';
import '../domain/pairing.dart';

/// Android TV / Google TV remote pairing ("polo" protocol v2): TLS on port
/// 6467 with a client certificate; the TV shows a 6-character hex code.
/// The certificate is the credential reused on the remote port (6466).
class AndroidTvPairing implements PairingProtocol {
  @override
  bool handles(CastDevice d) => d.type == DeviceType.smartTv && d.port == 6466;

  @override
  PairingSession start(CastDevice device, {String? saved}) => _AtvSession(device, saved);
}

/// Client identity: self-signed RSA certificate + private key (PEM).
class _Identity {
  const _Identity(this.certPem, this.keyPem);
  final String certPem;
  final String keyPem;

  String toJson() => jsonEncode({'cert': certPem, 'key': keyPem});

  static _Identity? fromJson(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return _Identity(m['cert'] as String, m['key'] as String);
    } catch (_) {
      return null;
    }
  }

  SecurityContext get context => SecurityContext()
    ..useCertificateChainBytes(utf8.encode(certPem))
    ..usePrivateKeyBytes(utf8.encode(keyPem));

  RSAPublicKey get publicKey => _publicKeyOfCertDer(CryptoUtils.getBytesFromPEMString(certPem));
}

/// Generating a 2048-bit RSA key takes a few seconds; run off the UI isolate.
Future<_Identity> _newIdentity() => compute((_) {
  final pair = CryptoUtils.generateRSAKeyPair();
  final priv = pair.privateKey as RSAPrivateKey;
  final pub = pair.publicKey as RSAPublicKey;
  final csr = X509Utils.generateRsaCsrPem({'CN': 'CastFlow'}, priv, pub);
  final cert = X509Utils.generateSelfSignedCertificate(priv, csr, 3650);
  return _Identity(cert, CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(priv));
}, null);

/// Extracts the RSA public key from a DER certificate's SubjectPublicKeyInfo.
RSAPublicKey _publicKeyOfCertDer(Uint8List der) {
  final cert = ASN1Parser(der).nextObject() as ASN1Sequence;
  final tbs = cert.elements!.first as ASN1Sequence;
  final spki = tbs.elements!.whereType<ASN1Sequence>().firstWhere(
    (e) => e.elements!.length == 2 && e.elements![0] is ASN1Sequence && e.elements![1] is ASN1BitString,
  );
  return CryptoUtils.rsaPublicKeyFromDERBytes(spki.encode());
}

/// Unsigned big-endian bytes without a leading zero.
List<int> _unsigned(BigInt v) {
  final hex = v.toRadixString(16);
  final even = hex.length.isOdd ? '0$hex' : hex;
  return [for (var i = 0; i < even.length; i += 2) int.parse(even.substring(i, i + 2), radix: 16)];
}

// ---------------------------------------------------------- tiny protobuf

List<int> _varint(int v) {
  final out = <int>[];
  while (v >= 0x80) {
    out.add((v & 0x7f) | 0x80);
    v >>= 7;
  }
  out.add(v);
  return out;
}

List<int> _int(int field, int value) => [..._varint(field << 3), ..._varint(value)];
List<int> _bytes(int field, List<int> value) => [..._varint((field << 3) | 2), ..._varint(value.length), ...value];

/// `OuterMessage { protocol_version = 2; status = OK; message }`.
List<int> _outer(int field, List<int> message) {
  final body = [..._int(1, 2), ..._int(2, 200), ..._bytes(field, message)];
  return [..._varint(body.length), ...body];
}

const _hexEncoding = 3; // ENCODING_TYPE_HEXADECIMAL
const _roleInput = 1; // ROLE_TYPE_INPUT
List<int> get _encoding => [..._int(1, _hexEncoding), ..._int(2, 6)];

class _AtvSession implements PairingSession {
  _AtvSession(this._device, String? saved) {
    _run(_Identity.fromJson(saved));
  }

  final CastDevice _device;
  final _steps = StreamController<PairingStep>();
  SecureSocket? _socket;
  _Identity? _identity;
  RSAPublicKey? _serverKey;
  final _buffer = <int>[];
  bool _closed = false;
  Completer<int>? _secretAck;

  @override
  Stream<PairingStep> get steps => _steps.stream;

  void _emit(PairingStep s) {
    if (!_closed && !_steps.isClosed) _steps.add(s);
  }

  Future<void> _run(_Identity? saved) async {
    if (saved != null) {
      // Reuse: an authorized client gets data on the remote port right away;
      // a forgotten one is disconnected.
      if (await _remoteAccepts(saved)) {
        _emit(PairingDone(saved.toJson()));
      } else {
        _emit(const SavedCredentialRejected());
      }
      return;
    }
    try {
      _identity = await _newIdentity();
      if (_closed) return;
      _socket = await SecureSocket.connect(
        _device.address,
        6467,
        context: _identity!.context,
        onBadCertificate: (_) => true, // TVs present self-signed certificates
        timeout: const Duration(seconds: 8),
      );
      _serverKey = _publicKeyOfCertDer(_socket!.peerCertificate!.der);
      _socket!.listen(
        _onData,
        onError: (_) => _emit(const PairingFailed('connection')),
        onDone: () {
          if (!_closed && !(_secretAck?.isCompleted ?? true)) _secretAck!.complete(-1);
          if (!_closed) _emit(const PairingFailed('connection'));
        },
      );
      _socket!.add(_outer(10, [..._bytes(1, utf8.encode('atvremote')), ..._bytes(2, utf8.encode('CastFlow'))]));
    } catch (_) {
      _emit(const PairingFailed('connection'));
    }
  }

  Future<bool> _remoteAccepts(_Identity id) async {
    try {
      final s = await SecureSocket.connect(
        _device.address,
        6466,
        context: id.context,
        onBadCertificate: (_) => true,
        timeout: const Duration(seconds: 6),
      );
      final got = Completer<bool>();
      s.listen(
        (_) => got.isCompleted ? null : got.complete(true),
        onError: (_) => got.isCompleted ? null : got.complete(false),
        onDone: () => got.isCompleted ? null : got.complete(false),
      );
      final ok = await got.future.timeout(const Duration(seconds: 4), onTimeout: () => false);
      s.destroy();
      return ok;
    } catch (_) {
      return false;
    }
  }

  void _onData(List<int> data) {
    _buffer.addAll(data);
    while (_buffer.isNotEmpty) {
      // Varint length prefix.
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
      _handle(_fields(msg));
    }
  }

  /// Top-level fields of an OuterMessage: number → varint value or bytes.
  Map<int, Object> _fields(List<int> m) {
    final out = <int, Object>{};
    var i = 0;
    int readVarint() {
      var v = 0, shift = 0;
      while (true) {
        final b = m[i++];
        v |= (b & 0x7f) << shift;
        if (b < 0x80) return v;
        shift += 7;
      }
    }

    while (i < m.length) {
      final tag = readVarint();
      if ((tag & 7) == 0) {
        out[tag >> 3] = readVarint();
      } else {
        final n = readVarint();
        out[tag >> 3] = m.sublist(i, i + n);
        i += n;
      }
    }
    return out;
  }

  void _handle(Map<int, Object> f) {
    final status = (f[2] as int?) ?? 200;
    if (f.containsKey(41) || _secretAck != null) {
      if (!(_secretAck?.isCompleted ?? true)) _secretAck!.complete(status);
      return;
    }
    if (status != 200) {
      _emit(PairingFailed('status $status'));
      return;
    }
    if (f.containsKey(11)) {
      // PairingRequestAck → offer hex codes of length 6, we enter the code.
      _socket!.add(_outer(20, [..._bytes(1, _encoding), ..._int(3, _roleInput)]));
    } else if (f.containsKey(20)) {
      _socket!.add(_outer(30, [..._bytes(1, _encoding), ..._int(2, _roleInput)]));
    } else if (f.containsKey(31)) {
      // ConfigurationAck: the TV now shows the code.
      _emit(const NeedsCode(length: 6, hex: true));
    }
  }

  @override
  Future<void> submitCode(String code) async {
    final c = code.trim().toUpperCase();
    if (c.length != 6 || _identity == null || _serverKey == null) {
      _emit(const PairingWrongCode());
      return;
    }
    final client = _identity!.publicKey;
    final server = _serverKey!;
    final digest = SHA256Digest();
    final input = Uint8List.fromList([
      ..._unsigned(client.modulus!),
      ..._unsigned(client.exponent!),
      ..._unsigned(server.modulus!),
      ..._unsigned(server.exponent!),
      int.parse(c.substring(2, 4), radix: 16),
      int.parse(c.substring(4, 6), radix: 16),
    ]);
    final hash = digest.process(input);
    // The first byte of the code is a checksum of the rest.
    if (hash[0] != int.parse(c.substring(0, 2), radix: 16)) {
      _emit(const PairingWrongCode());
      return;
    }
    _secretAck = Completer<int>();
    _socket!.add(_outer(40, _bytes(1, hash)));
    final status = await _secretAck!.future.timeout(const Duration(seconds: 10), onTimeout: () => -2);
    _secretAck = null;
    if (status == 200) {
      _emit(PairingDone(_identity!.toJson()));
    } else if (status == -2) {
      _emit(const PairingFailed('timeout'));
    } else {
      _emit(const PairingWrongCode());
    }
  }

  @override
  Future<void> close() async {
    _closed = true;
    _socket?.destroy();
    await _steps.close();
  }
}
