import 'dart:io';

import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/devices/presentation/widgets/connection_guide_sheet.dart';
import 'package:castflow/features/player/data/media_caster.dart';
import 'package:castflow/features/player/data/media_converter.dart';
import 'package:castflow/features/player/data/media_server.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/remote/data/dlna_client.dart';
import 'package:castflow/features/settings/presentation/faq_screen.dart';
import 'package:castflow/features/webcast/domain/video_rules.dart';
import 'package:castflow/features/webcast/domain/web_video.dart';
import 'package:castflow/features/webcast/presentation/browser_cast_widgets.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'helpers.dart';

const _dlna = CastDevice(
  id: 'tv-1',
  name: 'Living room',
  type: DeviceType.dlna,
  address: '127.0.0.1',
  protocol: RemoteProtocol.dlna,
  location: 'http://127.0.0.1/desc.xml',
);

const _mp4 = WebVideo(url: 'https://x/a.mp4', type: VideoType.mp4, title: 'Clip', duration: Duration(minutes: 2));
const _hls = WebVideo(
  url: 'https://x/a.m3u8',
  type: VideoType.hls,
  title: 'Show',
  probed: true,
  duration: Duration(minutes: 40),
);
const _live = WebVideo(url: 'https://x/live.m3u8', type: VideoType.hls, title: 'Live', probed: true);
const _drm = WebVideo(url: 'https://x/d.mpd', type: VideoType.dash, title: 'Movie', protected: true);

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? AppTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  setUpAll(() => HttpOverrides.global = null);
  browserBarTests();

  group('What can be done with a web video on the connected TV', () {
    test('no TV yet: everything not protected is castable (it is checked at cast time)', () {
      expect(videoStatusFor(_hls, null), VideoStatus.ok);
      expect(videoStatusFor(_drm, null), VideoStatus.protected);
    });

    test('a DLNA TV plays MP4; HLS is convertible; a live HLS can only be reported', () {
      expect(videoStatusFor(_mp4, _dlna), VideoStatus.ok);
      expect(videoStatusFor(_hls, _dlna), VideoStatus.convertible);
      expect(videoStatusFor(_live, _dlna), VideoStatus.live);
      expect(videoStatusFor(_drm, _dlna), VideoStatus.protected);
    });

    test('an unprobed manifest is not called live yet', () {
      const unknown = WebVideo(url: 'https://x/u.m3u8', type: VideoType.hls);
      expect(isLiveStream(unknown), isFalse);
      expect(videoStatusFor(unknown, _dlna), VideoStatus.convertible);
    });
  });

  group('Videos on this page sheet', () {
    Future<(ProviderContainer, GlobalKey)> open(WidgetTester tester, List<WebVideo> videos, VideoPick? Function() out) async {
      final c = await tester.runAsync(() => makeContainer());
      await tester.runAsync(() => c!.read(connectionProvider.notifier).connect(_dlna));
      final key = GlobalKey();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c!,
          child: MaterialApp(
            navigatorKey: rootNavigatorKey,
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  key: key,
                  onPressed: () => showVideosSheet(context, videos),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      return (c, key);
    }

    testWidgets('each row says what the TV can do; unsupported ones offer Convert this', (tester) async {
      final (c, _) = await open(tester, [_mp4, _hls, _live, _drm], () => null);
      expect(find.text("Living room can't play HLS directly"), findsOneWidget);
      expect(find.text('Convert this'), findsOneWidget, reason: 'only the HLS recording, not live or DRM');
      expect(find.textContaining("live streams can't be converted"), findsOneWidget);
      expect(find.text('This video cannot be cast from this page'), findsOneWidget);
      // The MP4 keeps its normal Cast button.
      expect(find.text('Cast'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
      c.dispose();
    });

    testWidgets('pressing Convert this returns the video with convert on', (tester) async {
      VideoPick? result;
      final c = await tester.runAsync(() => makeContainer());
      await tester.runAsync(() => c!.read(connectionProvider.notifier).connect(_dlna));
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c!,
          child: MaterialApp(
            navigatorKey: rootNavigatorKey,
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () async => result = await showVideosSheet(context, [_mp4, _hls]),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.tap(find.text('Convert this'));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(result?.video.url, _hls.url);
      expect(result?.convert, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
      c.dispose();
    });
  });

  testWidgets('the Cast to TV pill shows the number of videos and can be tapped', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(CastToTvPill(count: 6, onTap: () => taps++)));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Cast to TV'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    await tester.tap(find.text('Cast to TV'));
    expect(taps, 1);
  });

  group('Web video conversion ("Convert this")', () {
    test('the phone reads the video through its own server, converts it and serves the MP4 to the TV', () async {
      final seenReferer = <String?>[];
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => origin.close(force: true));
      origin.listen((req) async {
        seenReferer.add(req.headers.value('referer'));
        req.response
          ..headers.contentType = ContentType('video', 'webm')
          ..add(List.filled(300, 9));
        await req.response.close();
      });

      final dir = await Directory.systemTemp.createTemp('castflow_webconv');
      addTearDown(() => dir.delete(recursive: true));
      final converter = _FeedConverter(dir);
      final tv = _Tv();
      final server = MediaServer();
      addTearDown(server.stop);
      final caster = DlnaMediaCaster(tv, server, hostFor: (_) async => '127.0.0.1', converter: converter);

      final progress = <String?>[];
      await caster.load(
        _dlna,
        CastMedia(
          id: 'w',
          title: 'Web clip',
          kind: CastKind.web,
          seed: 1,
          url: 'http://127.0.0.1:${origin.port}/v.webm',
          headers: const {'Referer': 'https://page.example/'},
          convert: true,
        ),
        onPrepare: (p, [detail]) => progress.add(detail),
      );

      expect(converter.fed.single, startsWith('http://127.0.0.1:'), reason: 'converter reads the phone server, not the site');
      expect(converter.fed.single, contains('/m/'));
      expect(converter.fedBytes, 300, reason: 'the page video came through the proxy');
      expect(seenReferer, ['https://page.example/'], reason: 'with the page headers');
      expect(tv.loads.single.mime, 'video/mp4');
      expect(tv.loads.single.url, contains('out.mp4'));
      expect(progress.whereType<String>().first, 'WebM → MP4 · H.264 / AAC');
    });

    test('a web video is NOT converted unless the user pressed Convert this', () async {
      final dir = await Directory.systemTemp.createTemp('castflow_webconv2');
      addTearDown(() => dir.delete(recursive: true));
      final converter = _FeedConverter(dir);
      final tv = _Tv();
      final server = MediaServer();
      addTearDown(server.stop);
      final caster = DlnaMediaCaster(tv, server, hostFor: (_) async => '127.0.0.1', converter: converter);
      await caster.load(
        _dlna,
        const CastMedia(id: 'w', title: 'Web', kind: CastKind.web, seed: 1, url: 'http://127.0.0.1:9/v.mp4'),
      );
      expect(converter.fed, isEmpty);
      expect(tv.loads.single.url, 'http://127.0.0.1:9/v.mp4');
    });
  });

  group('Connection guides by TV brand', () {
    for (final brand in TvBrand.values) {
      for (final lang in ['en', 'ar', 'de']) {
        testWidgets('${brand.label} guide fits in $lang', (tester) async {
          tester.view.physicalSize = const Size(360, 800) * 2;
          tester.view.devicePixelRatio = 2;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.light,
              locale: Locale(lang),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(body: ConnectionGuideSheet(initialBrand: brand)),
            ),
          );
          for (var i = 0; i < 6; i++) {
            await tester.pump(const Duration(milliseconds: 300));
          }
          final ex = tester.takeException();
          if (ex is FlutterError) debugPrint(ex.toStringDeep());
          expect(ex, isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump(const Duration(seconds: 2));
        });
      }
    }

    testWidgets('the brand picker swaps in that brand\'s own steps', (tester) async {
      tester.view.physicalSize = const Size(400, 900) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_wrap(const ConnectionGuideSheet()));
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(find.text('Join the same Wi-Fi'), findsOneWidget);
      await tester.tap(find.text('Samsung'));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(find.text('Let your phone connect'), findsOneWidget);
      expect(find.textContaining('Device Connect Manager'), findsWidgets);
      expect(find.text('Tap Connect, then Allow'), findsOneWidget);
      await tester.tap(find.text('Roku'));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(find.text('Allow control from apps'), findsOneWidget);
      expect(find.text('Tap Connect, then Allow'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the FAQ lists the brands and opens the matching guide', (tester) async {
      tester.view.physicalSize = const Size(400, 900) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            navigatorKey: rootNavigatorKey,
            routes: [GoRoute(path: '/', builder: (_, _) => const FaqScreen())],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('How to connect with LG'), findsOneWidget);
      expect(find.text('How to connect with Samsung'), findsOneWidget);
      await tester.tap(find.text('How to connect with LG'));
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(find.textContaining('TV On With Mobile'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}

/// Records what the TV was told to play.
class _Tv extends DlnaClient {
  final loads = <({String url, String mime})>[];
  @override
  Future<void> load(
    CastDevice device, {
    required String url,
    required String title,
    required String mime,
    required String kind,
  }) async => loads.add((url: url, mime: mime));
}

/// "Converts" by reading the URL it is given (as Transformer would) and writing the bytes out.
class _FeedConverter extends MediaConverter {
  _FeedConverter(this.dir);
  final Directory dir;
  final fed = <String>[];
  int fedBytes = 0;

  @override
  bool get available => true;

  @override
  Future<String> toMp4(String path, {required String id, void Function(double)? onProgress}) async {
    fed.add(path);
    final c = HttpClient();
    try {
      final res = await (await c.getUrl(Uri.parse(path))).close();
      final bytes = await res.fold<List<int>>([], (a, b) => a..addAll(b));
      fedBytes = bytes.length;
      onProgress?.call(1);
      return (File('${dir.path}/out.mp4')..writeAsBytesSync(bytes)).path;
    } finally {
      c.close();
    }
  }
}

void browserBarTests() {
  testWidgets('the browser bottom bar has back, forward and home only: Cast to TV is the pill', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: BrowserBottomBar(onBack: null, onForward: () {}, onStartPage: () {})),
      ),
    );
    expect(find.byType(IconButton), findsNWidgets(3));
    expect(find.byIcon(Icons.cast_rounded), findsNothing);
  });
}
