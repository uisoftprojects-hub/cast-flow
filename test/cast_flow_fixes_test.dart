import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/domain/network_status.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/history/presentation/history_controller.dart';
import 'package:castflow/features/mirroring/domain/mirroring.dart';
import 'package:castflow/features/mirroring/presentation/mirroring_controller.dart';
import 'package:castflow/features/mirroring/presentation/mirroring_screen.dart';
import 'package:castflow/features/devices/presentation/network_controller.dart';
import 'package:castflow/features/monetization/domain/ad_adapter.dart';
import 'package:castflow/features/monetization/domain/ad_models.dart';
import 'package:castflow/features/monetization/domain/ad_suppression.dart';
import 'package:castflow/features/monetization/presentation/ad_display_coordinator.dart';
import 'package:castflow/features/monetization/presentation/ad_manager.dart';
import 'package:castflow/features/monetization/presentation/click_count_interstitial_manager.dart';
import 'package:castflow/features/player/data/media_caster.dart';
import 'package:castflow/features/player/data/media_converter.dart';
import 'package:castflow/features/player/data/media_server.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/player/domain/tv_formats.dart';
import 'package:castflow/features/player/presentation/player_controller.dart';
import 'package:castflow/features/remote/data/dlna_client.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'helpers.dart';

// ------------------------------------------------------------------ ads fakes

/// An interstitial that stays on screen until [dismiss] is called.
class _HeldAd extends LoadedFullScreenAd {
  final _dismissed = Completer<void>();
  int shows = 0;

  void dismiss() {
    if (!_dismissed.isCompleted) _dismissed.complete();
  }

  @override
  Future<void> show({required VoidCallback onImpression, VoidCallback? onClicked}) {
    shows++;
    onImpression();
    return _dismissed.future;
  }

  @override
  void dispose() {}
}

class _Adapter implements AdAdapter {
  final interstitialLoads = <Completer<LoadedFullScreenAd>>[];

  @override
  Future<void> initialize() async {}
  @override
  Future<bool> canRequestAds() async => true;
  @override
  Future<LoadedNativeAd> loadNative(
    AdPlacement p, {
    required bool medium,
    required VoidCallback onImpression,
    required VoidCallback onClicked,
  }) => Completer<LoadedNativeAd>().future;
  @override
  Future<LoadedFullScreenAd> loadInterstitial([AdPlacement placement = AdPlacement.clickInterstitial]) {
    final c = Completer<LoadedFullScreenAd>();
    interstitialLoads.add(c);
    return c.future;
  }

  @override
  Future<LoadedFullScreenAd> loadAppOpen() => Completer<LoadedFullScreenAd>().future;
}

// ---------------------------------------------------------------- cast fakes

class _Dlna extends DlnaClient {
  _Dlna(this.sink);
  final String sink;
  final loads = <({String url, String mime})>[];

  @override
  Future<TvFormats> formats(CastDevice device) async => TvFormats.parse(sink);

  @override
  Future<void> load(
    CastDevice device, {
    required String url,
    required String title,
    required String mime,
    required String kind,
  }) async => loads.add((url: url, mime: mime));
}

class _Converter extends MediaConverter {
  _Converter(this.dir);
  final Directory dir;
  final calls = <String>[];

  @override
  bool get available => true;

  @override
  Future<MediaProbe?> probe(String path) async => const MediaProbe(mime: 'video/mp4', videoCodec: 'video/hevc');

  @override
  Future<String> toJpeg(String path) async {
    calls.add('jpeg');
    return (File('${dir.path}/out.jpg')..writeAsBytesSync([1, 2, 3])).path;
  }

  @override
  Future<String> toMp4(String path, {required String id, void Function(double)? onProgress}) async {
    calls.add('mp4');
    onProgress?.call(0.5);
    onProgress?.call(1);
    return (File('${dir.path}/out.mp4')..writeAsBytesSync([4, 5, 6])).path;
  }

  @override
  Future<void> clearCache() async => calls.add('clear');
}

class _Caster implements MediaCaster {
  final calls = <String>[];
  Object? failLoad;

  @override
  bool canCast(CastDevice d) => true;
  @override
  Future<void> load(CastDevice d, CastMedia m, {bool forceConvert = false, PrepareProgress? onPrepare}) async {
    calls.add(forceConvert ? 'convert:${m.id}' : 'load:${m.id}');
    if (forceConvert) onPrepare?.call(0.3);
    if (failLoad != null) throw failLoad!;
  }

  @override
  Future<void> play(CastDevice d) async {}
  @override
  Future<void> pause(CastDevice d) async {}
  @override
  Future<void> seek(CastDevice d, Duration to) async {}
  @override
  Future<void> stop(CastDevice d) async => calls.add('stop');
  @override
  Future<void> setVolume(CastDevice d, double level) async {}
  @override
  Future<CasterStatus?> status(CastDevice d) async => null;
  @override
  Future<void> endSession() async => calls.add('end');
}

const _tv = CastDevice(
  id: 'tv-1',
  name: 'Living room',
  type: DeviceType.dlna,
  address: '127.0.0.1',
  protocol: RemoteProtocol.dlna,
  location: 'http://127.0.0.1/desc.xml',
);

Widget _app(ProviderContainer c, Widget home) => UncontrolledProviderScope(
  container: c,
  child: MaterialApp.router(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: GoRouter(
      navigatorKey: rootNavigatorKey,
      routes: [GoRoute(path: '/', builder: (_, _) => home)],
    ),
  ),
);

void main() {
  setUpAll(() => HttpOverrides.global = null);

  // ------------------------------------------------------------ Task 2
  group('App Open suppression during permission flows', () {
    tearDown(() {
      AdSuppression.reset();
      AdSuppression.now = DateTime.now;
    });

    test('a held flow suppresses every trip until it is released', () {
      AdSuppression.hold('permission');
      expect(AdSuppression.take(), isTrue); // prompt
      expect(AdSuppression.take(), isTrue); // Settings and back
      AdSuppression.release('permission');
      expect(AdSuppression.take(), isFalse); // a real re-open
    });

    test('a forgotten hold expires instead of blocking App Open for the session', () {
      var t = DateTime(2026, 1, 1, 12);
      AdSuppression.now = () => t;
      AdSuppression.hold('permission');
      expect(AdSuppression.isHeld, isTrue);
      t = t.add(AdSuppression.holdLimit + const Duration(seconds: 1));
      expect(AdSuppression.isHeld, isFalse);
    });

    test('one-shot marks still work and are consumed once', () {
      AdSuppression.suppressNextAppOpen();
      expect(AdSuppression.take(), isTrue);
      expect(AdSuppression.take(), isFalse);
    });
  });

  // ------------------------------------------------------------ Task 3
  group('Interstitial on Start Mirroring', () {
    test('the click future completes only once the interstitial is dismissed', () async {
      final adapter = _Adapter();
      final manager = ClickCountInterstitialManager(adapter: adapter, coordinator: AdDisplayCoordinator());
      await manager.onUserClick(isPremium: false); // 1st click: loads
      final ad = _HeldAd();
      adapter.interstitialLoads.single.complete(ad);
      await Future<void>.delayed(Duration.zero);

      var done = false;
      final click = manager.onUserClick(isPremium: false).then((_) => done = true);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(ad.shows, 1);
      expect(done, isFalse, reason: 'navigation must wait for the ad');
      ad.dismiss();
      await click;
      expect(done, isTrue);
    });

    testWidgets('the Cast screen opens only after the ad closes, once, even on fast double taps', (tester) async {
      final adapter = _Adapter();
      var pickerOpened = 0;
      final c = await tester.runAsync(
        () => makeContainer(
          overrides: [
            adAdapterProvider.overrideWithValue(adapter),
            mirroringStatusReaderProvider.overrideWithValue(() async => (active: false, name: null)),
            castSettingsOpenerProvider.overrideWithValue(() async {
              pickerOpened++;
              return true;
            }),
          ],
        ),
      );
      // The session's first click loaded the interstitial already.
      final manager = c!.read(clickCountInterstitialManagerProvider);
      unawaited(manager.onUserClick(isPremium: false));
      final ad = _HeldAd();
      await tester.pump();
      adapter.interstitialLoads.last.complete(ad);
      await tester.pump();

      await tester.pumpWidget(_app(c, const MirroringScreen()));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('Start'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Start')); // impatient second tap
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(ad.shows, 1);
      expect(pickerOpened, 0, reason: 'nothing opens behind the ad');

      ad.dismiss();
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(pickerOpened, 1);
      expect(c.read(mirroringProvider).phase, MirrorPhase.starting);

      await tester.pumpWidget(const SizedBox.shrink());
      AdSuppression.reset();
      c.dispose();
      await tester.pump(const Duration(seconds: 5));
    });
  });

  // ------------------------------------------------------------ Task 5
  testWidgets('no Wi-Fi and no hotspot: no-network screen, then straight on once the hotspot comes up', (tester) async {
    var net = const NetworkStatus();
    var pickerOpened = 0;
    final c = await tester.runAsync(
      () => makeContainer(
        network: () => net,
        overrides: [
          mirroringStatusReaderProvider.overrideWithValue(() async => (active: false, name: null)),
          castSettingsOpenerProvider.overrideWithValue(() async {
            pickerOpened++;
            return true;
          }),
        ],
      ),
    );
    await tester.pumpWidget(_app(c!, const MirroringScreen()));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Start'));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Turn on Wi-Fi'), findsOneWidget);
    expect(find.text('Use Mobile Hotspot'), findsNothing, reason: 'mirroring offers Wi-Fi only');
    expect(find.text('Cast photos, videos & music'), findsOneWidget);
    expect(pickerOpened, 0);

    // The user turned the hotspot on in Settings; Android reports it.
    net = const NetworkStatus(hotspot: true, hotspotIp: '192.168.43.1', hotspotInterface: 'swlan0');
    await c.read(networkProvider.notifier).refresh();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Turn on Wi-Fi'), findsNothing, reason: 'the screen closes by itself');
    expect(pickerOpened, 1, reason: 'and the flow carries on');

    await tester.pumpWidget(const SizedBox.shrink());
    AdSuppression.reset();
    c.dispose();
    await tester.pump(const Duration(seconds: 5));
  });

  test('discovery never shows "Finding TV" while there is no network, and starts once there is', () async {
    var net = const NetworkStatus();
    final c = await makeContainer(network: () => net);
    final sub = c.listen(discoveryProvider, (_, _) {});
    await c.read(networkProvider.notifier).refresh();
    final seen = <DiscoveryState>[];
    c.listen(discoveryProvider, (_, next) => seen.add(next));

    await c.read(discoveryProvider.notifier).grantPermission();
    expect(seen.any((s) => s.scanning), isFalse);
    expect(c.read(discoveryProvider).networkRequired, isTrue);

    net = const NetworkStatus(wifi: true, wifiIp: '192.168.1.20');
    await c.read(networkProvider.notifier).refresh();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(c.read(discoveryProvider).networkRequired, isFalse);
    expect(c.read(discoveryProvider).scanning, isTrue);
    sub.close();
    c.dispose();
  });

  // ------------------------------------------------------- Tasks 6 & 7
  group('Which address the TV is given', () {
    test('hotspot: the AP address, never wlan0 or mobile data', () {
      const s = NetworkStatus(hotspot: true, hotspotIp: '10.94.12.1', hotspotPrefix: 24, hotspotInterface: 'ap0');
      expect(s.addressFor('10.94.12.57'), '10.94.12.1');
      expect(s.discoveryAddress?.ip, '10.94.12.1');
    });

    test('Wi-Fi and hotspot together: the network that holds the TV', () {
      const s = NetworkStatus(
        wifi: true,
        wifiIp: '192.168.1.20',
        wifiPrefix: 24,
        hotspot: true,
        hotspotIp: '192.168.43.1',
      );
      expect(s.addressFor('192.168.43.80'), '192.168.43.1');
      expect(s.addressFor('192.168.1.50'), '192.168.1.20');
    });

    test('a /22 Wi-Fi network still matches a TV outside our /24', () {
      const s = NetworkStatus(wifi: true, wifiIp: '10.0.4.20', wifiPrefix: 22);
      expect(s.addressFor('10.0.6.9'), '10.0.4.20');
    });

    test('interface fallback skips mobile data and VPN addresses', () {
      final ip = MediaServer.pickLanAddress('192.168.5.40', [
        (iface: 'rmnet_data0', ip: '10.33.1.5'),
        (iface: 'tun0', ip: '10.8.0.2'),
        (iface: 'wlan0', ip: '172.20.10.3'),
      ]);
      expect(ip, '172.20.10.3');
    });
  });

  group('Browser casting through the phone', () {
    test('HLS playlists are rewritten so segments and keys go through the phone too', () {
      const playlist = '#EXTM3U\n#EXT-X-KEY:METHOD=AES-128,URI="key.bin"\n#EXTINF:4,\nseg1.ts\n#EXTINF:4,\n/abs/seg2.ts';
      final out = MediaServer.rewritePlaylist(playlist, (u) => 'P($u)');
      expect(out, contains('URI="P(key.bin)"'));
      expect(out, contains('\nP(seg1.ts)\n'));
      expect(out, contains('\nP(/abs/seg2.ts)'));
      expect(out, startsWith('#EXTM3U'));
    });

    test('end to end: playlist, segment, page headers, CORS', () async {
      final seenReferers = <String?>[];
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => origin.close(force: true));
      origin.listen((req) async {
        seenReferers.add(req.headers.value('referer'));
        if (req.headers.value('referer') != 'https://page.example/') {
          req.response.statusCode = 403;
        } else if (req.uri.path.endsWith('.m3u8')) {
          req.response.headers.contentType = ContentType('application', 'vnd.apple.mpegurl');
          req.response.write('#EXTM3U\n#EXTINF:4,\nseg1.ts\n#EXT-X-ENDLIST');
        } else {
          req.response.headers.contentType = ContentType('video', 'mp2t');
          req.response.add(List.generate(100, (i) => i));
        }
        await req.response.close();
      });

      final server = MediaServer();
      addTearDown(server.stop);
      final url = await server.publishProxy(
        'http://127.0.0.1:${origin.port}/live/master.m3u8',
        {'Referer': 'https://page.example/'},
        host: '127.0.0.1',
      );
      final client = HttpClient();
      addTearDown(client.close);

      final pre = await (await client.openUrl('OPTIONS', url)).close();
      expect(pre.statusCode, HttpStatus.noContent);
      expect(pre.headers.value('access-control-allow-origin'), '*');
      await pre.drain<void>();

      final res = await (await client.getUrl(url)).close();
      expect(res.statusCode, 200);
      final body = await res.transform(utf8.decoder).join();
      final segUrl = body.split('\n').firstWhere((l) => l.startsWith('http://'));
      expect(segUrl, startsWith('http://127.0.0.1:${url.port}/m/'));

      final seg = await (await client.getUrl(Uri.parse(segUrl))).close();
      expect(seg.statusCode, 200);
      expect(seg.headers.contentType?.mimeType, 'video/mp2t');
      expect((await seg.fold<List<int>>([], (a, b) => a..addAll(b))).length, 100);
      expect(seenReferers, everyElement('https://page.example/'));
    });

    test('a server that was stopped starts again on the next item', () async {
      final dir = await Directory.systemTemp.createTemp('castflow_restart');
      addTearDown(() => dir.delete(recursive: true));
      final f = File('${dir.path}/a.mp4')..writeAsBytesSync([1, 2, 3]);
      final server = MediaServer();
      addTearDown(server.stop);
      await server.publishFile(f.path, host: '127.0.0.1');
      await server.reset();
      final url = await server.publishFile(f.path, host: '127.0.0.1');
      final c = HttpClient();
      addTearDown(c.close);
      final res = await (await c.getUrl(url)).close();
      expect(res.statusCode, 200);
      await res.drain<void>();
    });
  });

  // ------------------------------------------------------------ Task 4
  group('Converting what the TV cannot play', () {
    test('formats: the TV list decides; unknown lists only convert exotic photos', () {
      final tv = TvFormats.parse('http-get:*:video/mp4:DLNA.ORG_PN=AVC_MP4_BL,http-get:*:image/jpeg:*,http-get:*:image/png:*');
      expect(conversionFor(kind: CastKind.video, mime: 'video/x-matroska', formats: tv), Conversion.mp4);
      expect(conversionFor(kind: CastKind.video, mime: 'video/mp4', formats: tv), Conversion.none);
      expect(
        conversionFor(
          kind: CastKind.video,
          mime: 'video/mp4',
          formats: tv,
          probe: const MediaProbe(videoCodec: 'video/hevc'),
        ),
        Conversion.mp4,
      );
      expect(conversionFor(kind: CastKind.photo, mime: 'image/heic', formats: tv), Conversion.jpeg);
      expect(conversionFor(kind: CastKind.photo, mime: 'image/png', formats: tv), Conversion.none);
      const unknown = TvFormats([]);
      expect(conversionFor(kind: CastKind.photo, mime: 'image/heic', formats: unknown), Conversion.jpeg);
      expect(conversionFor(kind: CastKind.video, mime: 'video/x-matroska', formats: unknown), Conversion.none);
    });

    test('a gallery HEIC photo is sent as JPEG, an MKV video as MP4 with progress', () async {
      final dir = await Directory.systemTemp.createTemp('castflow_convert');
      addTearDown(() => dir.delete(recursive: true));
      final heic = File('${dir.path}/IMG_1.HEIC')..writeAsBytesSync([9]);
      final mkv = File('${dir.path}/clip.mkv')..writeAsBytesSync([8]);
      final dlna = _Dlna('http-get:*:video/mp4:*,http-get:*:image/jpeg:*');
      final converter = _Converter(dir);
      final server = MediaServer();
      addTearDown(server.stop);
      final caster = DlnaMediaCaster(
        dlna,
        server,
        hostFor: (_) async => '127.0.0.1',
        converter: converter,
        resolveAsset: (id) async => id == 'p1' ? (path: heic.path, mime: 'image/heic') : (path: mkv.path, mime: null),
      );

      await caster.load(_tv, const CastMedia(id: 'p1', title: 'Photo', kind: CastKind.photo, seed: 1, url: 'asset:p1'));
      expect(dlna.loads.last.mime, 'image/jpeg');
      expect(dlna.loads.last.url, endsWith('out.jpg'));

      final progress = <double?>[];
      await caster.load(
        _tv,
        const CastMedia(id: 'v1', title: 'Clip', kind: CastKind.video, seed: 1, url: 'asset:v1'),
        onPrepare: (p, [detail]) => progress.add(p),
      );
      expect(dlna.loads.last.mime, 'video/mp4');
      expect(dlna.loads.last.url, endsWith('out.mp4'));
      expect(progress, [0, 0.5, 1]);
      expect(converter.calls, ['jpeg', 'mp4']);

      await caster.endSession();
      expect(converter.calls.last, 'clear');
    });

    test('the TV rejects an item: it is converted and sent again once, then the error shows', () async {
      final caster = _Caster()..failLoad = const HttpException('SetAVTransportURI failed (500).');
      final c = await makeContainer(overrides: [mediaCasterProvider.overrideWithValue(caster)]);
      await c.read(connectionProvider.notifier).connect(_tv);
      await c.read(historyProvider.future);
      final states = <PlaybackState>[];
      c.listen(playerProvider, (_, s) => states.add(s));

      c.read(playerProvider.notifier).play([
        const CastMedia(id: 'a', title: 'Clip', kind: CastKind.video, seed: 1, url: 'asset:a'),
      ]);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(caster.calls.where((x) => x.contains(':a')), ['load:a', 'convert:a']);
      expect(states.any((s) => s.preparing && s.prepareProgress == 0.3), isTrue);
      expect(c.read(playerProvider).preparing, isFalse);
      expect(c.read(playerProvider).error, isNotNull);

      c.read(playerProvider.notifier).stop();
      await Future<void>.delayed(Duration.zero);
      expect(caster.calls, contains('end'), reason: 'temp files are deleted after the session');
      c.dispose();
    });

    test('web streams are never converted', () async {
      final caster = _Caster()..failLoad = const HttpException('failed (500).');
      final c = await makeContainer(overrides: [mediaCasterProvider.overrideWithValue(caster)]);
      await c.read(connectionProvider.notifier).connect(_tv);
      await c.read(historyProvider.future);
      c.read(playerProvider.notifier).play([
        const CastMedia(id: 'w', title: 'Web', kind: CastKind.web, seed: 1, url: 'https://x/v.mp4'),
      ]);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(caster.calls.where((x) => x.contains(':w')), ['load:w']);
      c.dispose();
    });
  });
}
