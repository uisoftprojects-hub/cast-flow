import 'dart:convert';
import 'dart:io';

import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/history/presentation/history_controller.dart';
import 'package:castflow/features/player/data/media_caster.dart';
import 'package:castflow/features/player/data/media_server.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/player/presentation/player_controller.dart';
import 'package:castflow/features/remote/data/dlna_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

/// A DLNA renderer: serves its description, records SOAP actions, and (like a
/// real TV) fetches the media URL it is given.
class _FakeRenderer {
  late HttpServer server;
  final actions = <String>[];
  String? uri;
  String? meta;
  String state = 'STOPPED';
  final fetched = <int>[];

  Future<void> start() async {
    server = await HttpServer.bind('127.0.0.1', 0);
    server.listen((req) async {
      if (req.method == 'GET') {
        req.response
          ..headers.contentType = ContentType('text', 'xml')
          ..write('''<root><device><serviceList>
            <service><serviceType>urn:schemas-upnp-org:service:AVTransport:1</serviceType><controlURL>/avt</controlURL></service>
            <service><serviceType>urn:schemas-upnp-org:service:RenderingControl:1</serviceType><controlURL>/rc</controlURL></service>
          </serviceList></device></root>''');
        await req.response.close();
        return;
      }
      final body = await utf8.decoder.bind(req).join();
      final action = (req.headers.value('soapaction') ?? '').replaceAll('"', '').split('#').last;
      actions.add(action);
      var out = '';
      switch (action) {
        case 'SetAVTransportURI':
          uri = _unesc(RegExp('<CurrentURI>(.*?)</CurrentURI>', dotAll: true).firstMatch(body)![1]!);
          meta = _unesc(RegExp('<CurrentURIMetaData>(.*?)</CurrentURIMetaData>', dotAll: true).firstMatch(body)![1]!);
        case 'Play':
          state = 'PLAYING';
        case 'Pause':
          state = 'PAUSED_PLAYBACK';
        case 'Stop':
          state = 'STOPPED';
        case 'GetTransportInfo':
          out = '<CurrentTransportState>$state</CurrentTransportState>';
        case 'GetPositionInfo':
          out = '<RelTime>00:00:42</RelTime><TrackDuration>00:03:00</TrackDuration>';
      }
      req.response
        ..headers.contentType = ContentType('text', 'xml')
        ..write('<s:Envelope xmlns:s="x"><s:Body><u:${action}Response xmlns:u="y">$out</u:${action}Response></s:Body></s:Envelope>');
      await req.response.close();
    });
  }

  static String _unesc(String s) => s.replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&amp;', '&');

  CastDevice get tv => CastDevice(
    id: 'tv-1',
    name: 'Talha TV',
    type: DeviceType.dlna,
    address: '127.0.0.1',
    protocol: RemoteProtocol.dlna,
    location: 'http://127.0.0.1:${server.port}/desc.xml',
  );

  Future<void> stop() => server.close(force: true);
}

class _FakeCaster implements MediaCaster {
  final calls = <String>[];
  Object? failLoad;
  String state = 'PLAYING';
  Duration position = const Duration(seconds: 5);

  @override
  bool canCast(CastDevice d) => d.location != null;
  @override
  Future<void> load(CastDevice d, CastMedia m, {bool forceConvert = false, PrepareProgress? onPrepare}) async {
    calls.add(forceConvert ? 'convert:${m.id}' : 'load:${m.id}');
    if (failLoad != null) throw failLoad!;
  }

  @override
  Future<void> endSession() async => calls.add('end');

  @override
  Future<void> play(CastDevice d) async => calls.add('play');
  @override
  Future<void> pause(CastDevice d) async => calls.add('pause');
  @override
  Future<void> seek(CastDevice d, Duration to) async => calls.add('seek:${to.inSeconds}');
  @override
  Future<void> stop(CastDevice d) async => calls.add('stop');
  @override
  Future<void> setVolume(CastDevice d, double level) async => calls.add('vol:${(level * 100).round()}');
  @override
  Future<CasterStatus?> status(CastDevice d) async =>
      (state: state, position: position, length: const Duration(minutes: 3));
}

CastMedia _video(String id, String path) => CastMedia(
  id: id,
  title: 'Holiday & Fun',
  kind: CastKind.video,
  seed: 1,
  url: path,
);

void main() {
  setUpAll(() => HttpOverrides.global = null);

  group('MediaServer', () {
    late Directory dir;
    late File file;
    late MediaServer server;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('castflow_media');
      file = File('${dir.path}/clip.mp4')..writeAsBytesSync(List.generate(100, (i) => i));
      server = MediaServer();
    });
    tearDown(() async {
      await server.stop();
      await dir.delete(recursive: true);
    });

    Future<HttpClientResponse> get(Uri u, {String? range, String method = 'GET'}) async {
      final c = HttpClient();
      final r = await c.openUrl(method, u);
      if (range != null) r.headers.set('Range', range);
      return r.close();
    }

    test('serves the whole file with the right type', () async {
      final url = await server.publishFile(file.path, host: '127.0.0.1');
      expect(url.path, endsWith('/clip.mp4'));
      final r = await get(url);
      expect(r.statusCode, 200);
      expect(r.headers.contentType?.mimeType, 'video/mp4');
      expect(r.headers.value('accept-ranges'), 'bytes');
      expect((await r.fold<List<int>>([], (a, b) => a..addAll(b))).length, 100);
    });

    test('Range requests return exactly the asked bytes (so the TV can seek)', () async {
      final url = await server.publishFile(file.path, host: '127.0.0.1');
      final part = await get(url, range: 'bytes=10-19');
      expect(part.statusCode, 206);
      expect(part.headers.value('content-range'), 'bytes 10-19/100');
      expect(await part.fold<List<int>>([], (a, b) => a..addAll(b)), List.generate(10, (i) => 10 + i));

      final tail = await get(url, range: 'bytes=-5');
      expect(await tail.fold<List<int>>([], (a, b) => a..addAll(b)), [95, 96, 97, 98, 99]);

      final open = await get(url, range: 'bytes=98-');
      expect(await open.fold<List<int>>([], (a, b) => a..addAll(b)), [98, 99]);

      final bad = await get(url, range: 'bytes=500-600');
      expect(bad.statusCode, 416);
      await bad.drain<void>();
    });

    test('HEAD returns the length without a body', () async {
      final url = await server.publishFile(file.path, host: '127.0.0.1');
      final r = await get(url, method: 'HEAD');
      expect(r.statusCode, 200);
      expect(r.contentLength, 100);
    });

    test('unpublished paths and wrong tokens are not served', () async {
      final url = await server.publishFile(file.path, host: '127.0.0.1');
      final wrong = url.replace(pathSegments: ['m', 'deadbeef', 'clip.mp4']);
      final r1 = await get(wrong);
      expect(r1.statusCode, 404);
      await r1.drain<void>();
      final r2 = await get(url.replace(pathSegments: ['etc', 'passwd']));
      expect(r2.statusCode, 404);
      await r2.drain<void>();
    });

    test('a missing file is an error, not a silent empty cast', () async {
      expect(() => server.publishFile('${dir.path}/gone.mp4', host: '127.0.0.1'), throwsA(isA<FileSystemException>()));
    });

    test('MIME types come from the extension', () {
      expect(MediaServer.mimeFor('/a/b/song.MP3', fallback: 'x'), 'audio/mpeg');
      expect(MediaServer.mimeFor('http://h/v.m3u8?x=1', fallback: 'x'), 'application/vnd.apple.mpegurl');
      expect(MediaServer.mimeFor('noext', fallback: 'video/mp4'), 'video/mp4');
    });
  });

  test('end to end: the TV is told the phone URL, plays it, and can fetch the real bytes', () async {
    final tv = _FakeRenderer();
    await tv.start();
    addTearDown(tv.stop);
    final dir = await Directory.systemTemp.createTemp('castflow_media');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/Holiday Fun.mp4')..writeAsBytesSync(List.generate(50, (i) => i));

    final server = MediaServer();
    addTearDown(server.stop);
    final caster = DlnaMediaCaster(DlnaClient(), server, hostFor: (_) async => '127.0.0.1');
    await caster.load(tv.tv, _video('v1', file.path));

    expect(tv.actions, ['Stop', 'SetAVTransportURI', 'Play']);
    expect(tv.uri, startsWith('http://127.0.0.1:'));
    expect(tv.meta, contains('object.item.videoItem'));
    expect(tv.meta, contains('protocolInfo="http-get:*:video/mp4:*"'));
    expect(tv.meta, contains('Holiday &amp; Fun')); // title is XML-escaped

    // What a real TV does next: open the URL it was given.
    final c = HttpClient();
    final res = await (await c.getUrl(Uri.parse(tv.uri!))).close();
    expect((await res.fold<List<int>>([], (a, b) => a..addAll(b))).length, 50);

    final st = await caster.status(tv.tv);
    expect(st!.state, 'PLAYING');
    expect(st.position, const Duration(seconds: 42));
    expect(st.length, const Duration(minutes: 3));
  });

  test('a media item with no source says so instead of casting nothing', () async {
    final tv = _FakeRenderer();
    await tv.start();
    addTearDown(tv.stop);
    final caster = DlnaMediaCaster(DlnaClient(), MediaServer(), hostFor: (_) async => '127.0.0.1');
    const nothing = CastMedia(id: 'n', title: 'Demo', kind: CastKind.video, seed: 1);
    expect(() => caster.load(tv.tv, nothing), throwsA(isA<UnsupportedError>()));
  });

  group('PlayerController drives a real TV', () {
    late _FakeCaster caster;
    late ProviderContainer c;
    final tv = CastDevice(
      id: 'tv-1',
      name: 'Talha TV',
      type: DeviceType.dlna,
      address: '127.0.0.1',
      protocol: RemoteProtocol.dlna,
      location: 'http://127.0.0.1/desc.xml',
    );

    setUp(() async {
      caster = _FakeCaster();
      c = await makeContainer(overrides: [mediaCasterProvider.overrideWithValue(caster)]);
      await c.read(connectionProvider.notifier).connect(tv);
      await c.read(historyProvider.future);
    });

    test('play sends the item; pause, resume, seek, volume reach the TV', () async {
      final p = c.read(playerProvider.notifier);
      p.play([_video('a', '/x/a.mp4'), _video('b', '/x/b.mp4')]);
      await Future<void>.delayed(Duration.zero);
      expect(caster.calls, ['load:a']);
      expect(p.hasRealSession, isTrue);

      p.toggle();
      p.toggle();
      p.seek(const Duration(seconds: 30));
      p.setVolume(0.4);
      p.next();
      await Future<void>.delayed(Duration.zero);
      expect(caster.calls, ['load:a', 'pause', 'play', 'seek:30', 'vol:40', 'load:b']);
    });

    test('a failed load shows why and stops pretending to play', () async {
      caster.failLoad = UnsupportedError('Talha TV exposes no DLNA controls.');
      final p = c.read(playerProvider.notifier);
      p.play([_video('a', '/x/a.mp4')]);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final s = c.read(playerProvider);
      expect(s.playing, isFalse);
      expect(s.error, contains('no DLNA controls'));
    });

    test('stop tells the TV to stop', () async {
      final p = c.read(playerProvider.notifier);
      p.play([_video('a', '/x/a.mp4')]);
      await Future<void>.delayed(Duration.zero);
      p.stop();
      await Future<void>.delayed(Duration.zero);
      expect(caster.calls, contains('stop'));
      expect(p.hasRealSession, isFalse);
      expect(c.read(playerProvider).isActive, isFalse);
    });
  });
}
