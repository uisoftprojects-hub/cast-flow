import 'dart:convert';
import 'dart:io';

import 'package:castflow/features/devices/data/protocol_prober.dart';
import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/domain/receiver_capabilities.dart';
import 'package:castflow/features/pairing/data/android_tv_pairing.dart';
import 'package:castflow/features/pairing/data/approval_pairing.dart';
import 'package:castflow/features/pairing/domain/pairing.dart';
import 'package:castflow/features/remote/data/cast_volume_client.dart';
import 'package:castflow/features/remote/data/network_remote_service.dart';
import 'package:castflow/features/remote/domain/remote_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _Creds implements CredentialStore {
  final map = <String, String>{};
  @override
  Future<String?> read(String id) async => map[id];
  @override
  Future<void> write(String id, String c) async => map[id] = c;
  @override
  Future<void> delete(String id) async => map.remove(id);
}

/// A brand no list has ever heard of, found by SSDP as a bare DLNA renderer.
const _unknownBrand = CastDevice(
  id: 'uuid:zz-1',
  name: 'Zorbix Living Room',
  type: DeviceType.dlna,
  address: '127.0.0.1',
  port: 49152,
  model: 'Zorbix ZX-55',
);

/// Ports that nothing listens on, so only the fake TV under test answers.
const _closed = ProbePorts(roku: 1, androidRemote: 1, androidPairing: 1, samsung: 1, lg: 1, lgTls: 1, samsungTls: 1);

ProtocolProber _prober(ProbePorts p) =>
    ProtocolProber(ports: p, timeout: const Duration(milliseconds: 600), lookupRenderer: false);

ProbePorts _with({int? roku, int? atv, int? samsung, int? lg, int? lgTls}) => ProbePorts(
  roku: roku ?? _closed.roku,
  androidRemote: atv ?? _closed.androidRemote,
  androidPairing: _closed.androidPairing,
  samsung: samsung ?? _closed.samsung,
  lg: lg ?? _closed.lg,
  lgTls: lgTls ?? _closed.lgTls,
  samsungTls: _closed.samsungTls,
);

void main() {
  channelTests();
  setUpAll(() => HttpOverrides.global = null);

  group('an unlisted brand is controlled by whatever protocol it answers to', () {
    test('answers Roku ECP -> roku, full roku keys', () async {
      final s = await HttpServer.bind('127.0.0.1', 0);
      addTearDown(() => s.close(force: true));
      s.listen((r) {
        r.response
          ..write('<device-info><vendor-name>Zorbix</vendor-name></device-info>')
          ..close();
      });
      final d = await _prober(_with(roku: s.port)).identify(_unknownBrand);
      expect(d.protocol, RemoteProtocol.roku);
      expect(d.type, DeviceType.roku);
      expect(d.supports(RemoteCommand.ok), isTrue);
      expect(d.supports(RemoteCommand.volumeUp), isTrue);
    });

    test('answers on the Android TV remote port -> androidTv, pairing handles it', () async {
      final s = await ServerSocket.bind('127.0.0.1', 0);
      addTearDown(s.close);
      final d = await _prober(_with(atv: s.port)).identify(_unknownBrand);
      expect(d.protocol, RemoteProtocol.androidTv);
      expect(d.type, DeviceType.smartTv);
      expect(d.supports(RemoteCommand.home), isTrue);
      expect(AndroidTvPairing().handles(d), isTrue);
      expect(SamsungPairing().handles(d), isFalse);
      expect(LgPairing().handles(d), isFalse);
    });

    test('answers the Samsung API -> samsung', () async {
      final s = await HttpServer.bind('127.0.0.1', 0);
      addTearDown(() => s.close(force: true));
      s.listen((r) {
        r.response
          ..write(jsonEncode({'device': {'name': 'x'}}))
          ..close();
      });
      final d = await _prober(_with(samsung: s.port)).identify(_unknownBrand);
      expect(d.protocol, RemoteProtocol.samsung);
      expect(SamsungPairing().handles(d), isTrue);
    });

    test('answers LG TLS port -> lg without any LG hint in its name', () async {
      final s = await ServerSocket.bind('127.0.0.1', 0);
      addTearDown(s.close);
      final d = await _prober(_with(lgTls: s.port)).identify(_unknownBrand);
      expect(d.protocol, RemoteProtocol.lg);
      expect(LgPairing().handles(d), isTrue);
    });

    test('plain port 3000 without an LG hint is NOT taken for LG', () async {
      final s = await ServerSocket.bind('127.0.0.1', 0);
      addTearDown(s.close);
      final d = await _prober(_with(lg: s.port)).identify(_unknownBrand);
      expect(d.protocol, isNot(RemoteProtocol.lg));
    });

    test('nothing answers -> dlna: transport and volume only, no navigation keys', () async {
      final d = await _prober(_closed).identify(_unknownBrand);
      expect(d.protocol, RemoteProtocol.dlna);
      expect(d.supports(RemoteCommand.playPause), isTrue);
      expect(d.supports(RemoteCommand.volumeUp), isTrue);
      expect(d.supports(RemoteCommand.ok), isFalse);
      expect(d.supports(RemoteCommand.home), isFalse);
    });

    test('a listed Samsung that answers only on its TLS port keeps its full remote', () async {
      final tls = await ServerSocket.bind('127.0.0.1', 0);
      addTearDown(tls.close);
      const samsung = CastDevice(
        id: 's1',
        name: 'Samsung TV',
        type: DeviceType.smartTv,
        address: '127.0.0.1',
        port: 8002,
        model: 'Samsung',
      );
      final ports = ProbePorts(
        roku: 1,
        androidRemote: 1,
        androidPairing: 1,
        samsung: 1,
        lg: 1,
        lgTls: 1,
        samsungTls: tls.port,
      );
      final d = await _prober(ports).identify(samsung);
      expect(d.protocol, RemoteProtocol.samsung);
      expect(d.supports(RemoteCommand.ok), isTrue);
      expect(SamsungPairing().handles(d), isTrue);
    });

    test('a stale saved Android TV port is not proof: a TV answering nothing gets the DLNA path', () async {
      // The real TCL: saved earlier with port 6466 from an old mDNS answer, but
      // its remote ports are closed.
      const stale = CastDevice(
        id: 'tcl',
        name: 'Talha TV',
        type: DeviceType.smartTv,
        address: '127.0.0.1',
        port: 6466,
        model: 'TCL UnionTV',
      );
      final d = await _prober(_closed).identify(stale);
      expect(d.protocol, RemoteProtocol.dlna);
      expect(AndroidTvPairing().handles(d), isFalse);
      expect(d.supports(RemoteCommand.playPause), isTrue);
      expect(d.supports(RemoteCommand.ok), isTrue);
    });

    test('several protocols: the key protocol beats DLNA, Roku beats Android TV', () async {
      final roku = await HttpServer.bind('127.0.0.1', 0);
      final atv = await ServerSocket.bind('127.0.0.1', 0);
      addTearDown(() => roku.close(force: true));
      addTearDown(atv.close);
      roku.listen((r) {
        r.response
          ..write('<device-info/>')
          ..close();
      });
      final detected = await _prober(_with(roku: roku.port, atv: atv.port)).detect(_unknownBrand);
      expect(detected, [RemoteProtocol.roku, RemoteProtocol.androidTv]);
    });
  });

  test('a TV probed once keeps its protocol when saved and reloaded', () {
    final d = _unknownBrand.copyWith(protocol: RemoteProtocol.lg, type: DeviceType.smartTv);
    final back = CastDevice.fromMap(d.toMap());
    expect(back.protocol, RemoteProtocol.lg);
    expect(back.type, DeviceType.smartTv);
  });

  test('every command a protocol advertises has a real mapping', () {
    for (final c in protocolCapabilities[RemoteProtocol.lg]!) {
      expect(
        NetworkRemoteService.lgButtons[c] ?? NetworkRemoteService.lgRequests[c],
        isNotNull,
        reason: 'lg ${c.label}',
      );
    }
    for (final c in protocolCapabilities[RemoteProtocol.roku]!) {
      expect(NetworkRemoteService.rokuKeys[c], isNotNull, reason: 'roku ${c.label}');
    }
    for (final c in protocolCapabilities[RemoteProtocol.androidTv]!) {
      expect(NetworkRemoteService.androidKeyCodes[c], isNotNull, reason: 'android ${c.label}');
    }
    for (final c in protocolCapabilities[RemoteProtocol.samsung]!) {
      expect(NetworkRemoteService.samsungKeys[c], isNotNull, reason: 'samsung ${c.label}');
    }
  });

  test('LG: registers with the saved key, sends buttons on the pointer socket and ssap requests', () async {
    final buttons = <String>[];
    final requests = <String>[];
    String? registeredKey;
    late HttpServer server;
    server = await HttpServer.bind('127.0.0.1', 0);
    addTearDown(() => server.close(force: true));
    server.listen((req) async {
      final ws = await WebSocketTransformer.upgrade(req);
      if (req.uri.path == '/pointer') {
        ws.listen((m) => buttons.add((m as String).split('\n')[1]));
        return;
      }
      ws.listen((raw) {
        final m = jsonDecode(raw as String) as Map<String, dynamic>;
        if (m['type'] == 'register') {
          registeredKey = (m['payload'] as Map)['client-key'] as String?;
          ws.add(jsonEncode({'type': 'registered', 'id': m['id'], 'payload': {}}));
        } else if (m['uri'] == 'ssap://com.webos.service.networkinput/getPointerInputSocket') {
          ws.add(
            jsonEncode({
              'type': 'response',
              'id': m['id'],
              'payload': {'socketPath': 'ws://127.0.0.1:${server.port}/pointer'},
            }),
          );
        } else {
          requests.add(m['uri'] as String);
          ws.add(jsonEncode({'type': 'response', 'id': m['id'], 'payload': {}}));
        }
      });
    });
    final creds = _Creds()..map['lg-1'] = 'KEY42';
    final service = NetworkRemoteService(creds, lgUri: (_) => Uri.parse('ws://127.0.0.1:${server.port}/'));
    addTearDown(service.dispose);
    final lg = _unknownBrand.copyWith(protocol: RemoteProtocol.lg, type: DeviceType.smartTv);
    final device = CastDevice(
      id: 'lg-1',
      name: lg.name,
      type: lg.type,
      address: lg.address,
      protocol: RemoteProtocol.lg,
    );
    for (final c in [RemoteCommand.up, RemoteCommand.ok, RemoteCommand.home, RemoteCommand.volumeUp]) {
      await service.send(device, c);
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(registeredKey, 'KEY42');
    expect(buttons, ['name:UP', 'name:ENTER', 'name:HOME']);
    expect(requests, ['ssap://audio/volumeUp']);
  });

  test('a DLNA-only TV refuses keys it cannot send instead of pretending', () {
    final service = NetworkRemoteService(_Creds());
    final d = _unknownBrand.copyWith(protocol: RemoteProtocol.dlna);
    expect(() => service.send(d, RemoteCommand.ok), throwsA(isA<UnsupportedError>()));
  });

  test('DLNA: finds control URLs from the description and sends real SOAP actions', () async {
    final calls = <String>[];
    var state = 'STOPPED';
    var volume = 30;
    var muted = '0';
    late HttpServer server;
    server = await HttpServer.bind('127.0.0.1', 0);
    addTearDown(() => server.close(force: true));
    server.listen((req) async {
      if (req.method == 'GET') {
        req.response
          ..headers.contentType = ContentType('text', 'xml')
          ..write('''<root><device><serviceList>
            <service><serviceType>urn:schemas-upnp-org:service:AVTransport:1</serviceType><controlURL>/avt/ctl</controlURL></service>
            <service><serviceType>urn:schemas-upnp-org:service:RenderingControl:1</serviceType><controlURL>/rc/ctl</controlURL></service>
          </serviceList></device></root>''');
        await req.response.close();
        return;
      }
      final body = await utf8.decoder.bind(req).join();
      final action = (req.headers.value('soapaction') ?? '').replaceAll('"', '').split('#').last;
      calls.add('${req.uri.path} $action');
      String out = '';
      switch (action) {
        case 'GetTransportInfo':
          out = '<CurrentTransportState>$state</CurrentTransportState>';
        case 'Play':
          state = 'PLAYING';
        case 'Pause':
          state = 'PAUSED_PLAYBACK';
        case 'GetPositionInfo':
          out = '<RelTime>00:01:00</RelTime><TrackDuration>00:10:00</TrackDuration>';
        case 'Seek':
          calls.add('target=${RegExp('<Target>(.*?)</Target>').firstMatch(body)![1]}');
        case 'GetVolume':
          out = '<CurrentVolume>$volume</CurrentVolume>';
        case 'SetVolume':
          volume = int.parse(RegExp('<DesiredVolume>(\\d+)').firstMatch(body)![1]!);
        case 'GetMute':
          out = '<CurrentMute>$muted</CurrentMute>';
        case 'SetMute':
          muted = RegExp('<DesiredMute>(\\d)').firstMatch(body)![1]!;
      }
      req.response
        ..headers.contentType = ContentType('text', 'xml')
        ..write(
          '<s:Envelope xmlns:s="x"><s:Body><u:${action}Response xmlns:u="y">$out</u:${action}Response></s:Body></s:Envelope>',
        );
      await req.response.close();
    });

    final tv = CastDevice(
      id: 'dlna-tv',
      name: 'Talha TV',
      type: DeviceType.dlna,
      address: '127.0.0.1',
      protocol: RemoteProtocol.dlna,
      location: 'http://127.0.0.1:${server.port}/desc.xml',
    );
    final service = NetworkRemoteService(_Creds());
    addTearDown(service.dispose);

    await service.send(tv, RemoteCommand.playPause); // stopped -> Play
    await service.send(tv, RemoteCommand.playPause); // playing -> Pause
    await service.send(tv, RemoteCommand.next);
    await service.send(tv, RemoteCommand.fastForward);
    await service.send(tv, RemoteCommand.rewind);
    await service.send(tv, RemoteCommand.volumeUp);
    await service.send(tv, RemoteCommand.mute);

    expect(calls, contains('/avt/ctl Play'));
    expect(calls, contains('/avt/ctl Pause'));
    expect(calls, contains('/avt/ctl Next'));
    expect(calls, contains('target=00:01:10'));
    expect(calls, contains('target=00:00:50'));
    expect(volume, 35);
    expect(muted, '1');
    expect(state, 'PAUSED_PLAYBACK');
  });

  test('Android TV with no pairing credential asks for pairing instead of failing as "no response"', () {
    final service = NetworkRemoteService(_Creds());
    final d = _unknownBrand.copyWith(protocol: RemoteProtocol.androidTv, type: DeviceType.smartTv);
    expect(() => service.send(d, RemoteCommand.home), throwsA(isA<NotPairedException>()));
  });

  test('Android TV that cannot be keyed still gets volume/play via DLNA, but not navigation keys', () async {
    final calls = <String>[];
    final server = await HttpServer.bind('127.0.0.1', 0);
    addTearDown(() => server.close(force: true));
    server.listen((req) async {
      if (req.method == 'GET') {
        req.response
          ..headers.contentType = ContentType('text', 'xml')
          ..write('<root><device><serviceList>'
              '<service><serviceType>urn:schemas-upnp-org:service:RenderingControl:1</serviceType><controlURL>/rc</controlURL></service>'
              '</serviceList></device></root>');
        await req.response.close();
        return;
      }
      await utf8.decoder.bind(req).join();
      final action = (req.headers.value('soapaction') ?? '').replaceAll('"', '').split('#').last;
      calls.add(action);
      req.response
        ..headers.contentType = ContentType('text', 'xml')
        ..write('<s:Envelope xmlns:s="x"><s:Body><u:${action}Response xmlns:u="y"><CurrentVolume>30</CurrentVolume><CurrentMute>0</CurrentMute></u:${action}Response></s:Body></s:Envelope>');
      await req.response.close();
    });
    // Unpaired Android TV (no credentials) with a DLNA description.
    final tv = CastDevice(
      id: 'atv',
      name: 'Talha TV',
      type: DeviceType.smartTv,
      address: '127.0.0.1',
      protocol: RemoteProtocol.androidTv,
      location: 'http://127.0.0.1:${server.port}/d.xml',
    );
    final service = NetworkRemoteService(_Creds(), cast: CastVolumeClient(port: 1));
    addTearDown(service.dispose);
    await service.send(tv, RemoteCommand.volumeUp); // falls back to DLNA
    expect(calls, containsAll(['GetVolume', 'SetVolume']));
    // A navigation key has no fallback: it asks for pairing.
    expect(() => service.send(tv, RemoteCommand.home), throwsA(isA<NotPairedException>()));
  });

  test('Cast volume messages round-trip through the CastMessage wire format', () {
    final frame = CastVolumeClient.encode(
      'urn:x-cast:com.google.cast.receiver',
      '{"type":"SET_VOLUME","volume":{"level":0.35},"requestId":2}',
    );
    final len = (frame[0] << 24) | (frame[1] << 16) | (frame[2] << 8) | frame[3];
    expect(len, frame.length - 4);
    final m = CastVolumeClient.decode(frame.sublist(4));
    expect(m.namespace, 'urn:x-cast:com.google.cast.receiver');
    expect(jsonDecode(m.payload)['volume']['level'], 0.35);
  });

  test('DLNA: a device without a description URL asks to be found again', () {
    final service = NetworkRemoteService(_Creds());
    final d = _unknownBrand.copyWith(protocol: RemoteProtocol.dlna);
    expect(() => service.send(d, RemoteCommand.volumeUp), throwsA(isA<UnsupportedError>()));
  });
}

void channelTests() {
  group('channel keys', () {
    test('a smart TV that showed only DLNA offers every button; a bare DLNA renderer stays limited', () {
      const tv = CastDevice(
        id: 't', name: 'Talha TV', type: DeviceType.smartTv, address: '1.1.1.1', protocol: RemoteProtocol.dlna,
      );
      final speaker = tv.copyWith(type: DeviceType.dlna);
      expect(tv.supports(RemoteCommand.channelUp), isTrue);
      expect(tv.supports(RemoteCommand.channelDown), isTrue);
      expect(tv.capabilities.length, RemoteCommand.values.length); // nothing is greyed out
      expect(speaker.supports(RemoteCommand.channelUp), isFalse);
      expect(speaker.supports(RemoteCommand.ok), isFalse);
    });

    test('every listed key protocol offers channel keys, and Cast/DLNA-only TVs are the exception', () {
      for (final p in [RemoteProtocol.roku, RemoteProtocol.androidTv, RemoteProtocol.samsung, RemoteProtocol.lg]) {
        expect(protocolCapabilities[p]!.containsAll(RemoteCommand.channel), isTrue, reason: p.name);
      }
      expect(protocolCapabilities[RemoteProtocol.dlna]!.contains(RemoteCommand.channelUp), isFalse);
    });

    test('a key on a DLNA smart TV says so when the Android TV service is off', () async {
      final service = NetworkRemoteService(_Creds(), androidTvPorts: const [1]);
      addTearDown(service.dispose);
      const tv = CastDevice(
        id: 't', name: 'Talha TV', type: DeviceType.smartTv, address: '127.0.0.1', protocol: RemoteProtocol.dlna,
      );
      expect(
        () => service.send(tv, RemoteCommand.channelUp),
        throwsA(isA<UnsupportedError>().having((e) => e.message, 'message', contains('Android TV remote service is off'))),
      );
    });

    test('channel on a DLNA smart TV asks for pairing when the service is on but unpaired', () async {
      final up = await ServerSocket.bind('127.0.0.1', 0);
      addTearDown(up.close);
      final service = NetworkRemoteService(_Creds(), androidTvPorts: [up.port]);
      addTearDown(service.dispose);
      const tv = CastDevice(
        id: 't', name: 'Talha TV', type: DeviceType.smartTv, address: '127.0.0.1', protocol: RemoteProtocol.dlna,
      );
      expect(() => service.send(tv, RemoteCommand.channelDown), throwsA(isA<NotPairedException>()));
    });

    test('channel keys have a real mapping on every key protocol', () {
      for (final c in RemoteCommand.channel) {
        expect(NetworkRemoteService.rokuKeys[c], isNotNull);
        expect(NetworkRemoteService.androidKeyCodes[c], isNotNull);
        expect(NetworkRemoteService.samsungKeys[c], isNotNull);
        expect(NetworkRemoteService.lgRequests[c], isNotNull);
      }
      expect(NetworkRemoteService.androidKeyCodes[RemoteCommand.channelUp], 166);
      expect(NetworkRemoteService.androidKeyCodes[RemoteCommand.channelDown], 167);
    });
  });
}
