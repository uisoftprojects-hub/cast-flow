import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/webcast/data/http_video_probe.dart';
import 'package:castflow/features/webcast/domain/video_rules.dart';
import 'package:castflow/features/webcast/domain/web_video.dart';
import 'package:castflow/features/webcast/presentation/page_videos_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers probes from a table; unknown URLs are 404.
class FakeProbe implements VideoProbe {
  final results = <String, ProbeResult>{};
  final calls = <String>[];

  @override
  Future<ProbeResult> probe(String url, Map<String, String> headers) async {
    calls.add(url);
    return results[url] ?? ProbeResult(status: 404, finalUrl: url);
  }
}

const _headers = {'Referer': 'https://site.test/watch', 'Cookie': 'a=1', 'User-Agent': 'UA'};

void main() {
  group('rules', () {
    test('types from extension and content type', () {
      expect(videoTypeFromUrl('https://x.test/a/master.m3u8?sig=1'), VideoType.hls);
      expect(videoTypeFromUrl('https://x.test/m.mpd'), VideoType.dash);
      expect(videoTypeFromUrl('https://x.test/v.MOV'), VideoType.mov);
      expect(videoTypeFromUrl('https://x.test/page'), isNull);
      expect(videoTypeFromMime('application/x-mpegURL'), VideoType.hls);
      expect(videoTypeFromMime('application/dash+xml'), VideoType.dash);
      expect(videoTypeFromMime('video/webm; codecs=vp9'), VideoType.webm);
      expect(videoTypeFromMime('text/html'), isNull);
    });

    test('ads, trackers, blob and data URLs are not candidates', () {
      expect(isCandidateUrl('https://pubads.g.doubleclick.net/x.mp4'), isFalse);
      expect(isCandidateUrl('https://cdn.test/ads/preroll.mp4'), isFalse);
      expect(isCandidateUrl('https://cdn.test/vast/creative.mp4'), isFalse);
      expect(isCandidateUrl('blob:https://site.test/1234'), isFalse);
      expect(isCandidateUrl('data:video/mp4;base64,AAAA'), isFalse);
      expect(isCandidateUrl('https://cdn.test/uploads/movie.mp4'), isTrue);
    });

    test('tiny files and short clips are hidden', () {
      expect(shouldHide(const WebVideo(url: 'u', type: VideoType.mp4, size: 50 * 1024)), isTrue);
      expect(shouldHide(const WebVideo(url: 'u', type: VideoType.mp4, duration: Duration(seconds: 6))), isTrue);
      expect(shouldHide(const WebVideo(url: 'u', type: VideoType.mp4, size: 30 << 20)), isFalse);
    });

    test('HLS and DASH manifests give quality, duration and DRM', () {
      final master = parseHls(
        '#EXTM3U\n#EXT-X-STREAM-INF:BANDWIDTH=1,RESOLUTION=1280x720\na.m3u8\n'
        '#EXT-X-STREAM-INF:BANDWIDTH=2,RESOLUTION=1920x1080\nb.m3u8\n',
      );
      expect(master.master, isTrue);
      expect(master.height, 1080);
      final media = parseHls('#EXTM3U\n#EXTINF:10.0,\na.ts\n#EXTINF:5.5,\nb.ts\n#EXT-X-ENDLIST\n');
      expect(media.mediaPlaylist, isTrue);
      expect(media.duration, const Duration(milliseconds: 15500));
      expect(
        parseHls('#EXT-X-KEY:METHOD=SAMPLE-AES,URI="skd://x",KEYFORMAT="com.apple.streamingkeydelivery"').protected,
        isTrue,
      );
      expect(parseHls('#EXT-X-KEY:METHOD=AES-128,URI="k"').protected, isFalse);
      final dash = parseDash(
        '<MPD mediaPresentationDuration="PT1H2M3.5S"><Representation height="720"/>'
        '<ContentProtection schemeIdUri="urn:uuid:edef8ba9-79d6-4ace-a3c8-27dcd51d21ed"/></MPD>',
      );
      expect(dash.height, 720);
      expect(dash.duration, const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 500));
      expect(dash.protected, isTrue);
    });

    test('receiver format support', () {
      const cc = CastDevice(id: 'c', name: 'Living room', type: DeviceType.chromecast, address: '1');
      const dlna = CastDevice(id: 'd', name: 'Renderer', type: DeviceType.dlna, address: '2');
      expect(deviceSupports(cc, VideoType.dash), isTrue);
      expect(deviceSupports(cc, VideoType.mkv), isFalse);
      expect(deviceSupports(dlna, VideoType.hls), isFalse);
      expect(deviceSupports(dlna, VideoType.mp4), isTrue);
    });
  });

  group('page videos', () {
    late FakeProbe probe;
    late ProviderContainer c;
    late PageVideosController ctl;

    setUp(() {
      probe = FakeProbe();
      c = ProviderContainer(overrides: [videoProbeProvider.overrideWithValue(probe)]);
      addTearDown(c.dispose);
      c.listen(pageVideosProvider, (_, _) {}); // keep the autoDispose provider alive
      ctl = c.read(pageVideosProvider.notifier)..navigated('https://site.test/watch', 1);
    });

    Future<void> settle() => Future<void>.delayed(Duration.zero);

    test('network video is probed, keeps headers, follows redirects', () async {
      probe.results['https://cdn.test/v.mp4'] = const ProbeResult(
        status: 206,
        finalUrl: 'https://edge.test/v.mp4',
        mime: 'video/mp4',
        length: 80 << 20,
        type: VideoType.mp4,
      );
      ctl.addResource('https://cdn.test/v.mp4', _headers, 1);
      expect(c.read(pageVideosProvider).count, 0, reason: 'hidden until probed');
      await settle();
      final v = c.read(pageVideosProvider).videos.single;
      expect(v.url, 'https://edge.test/v.mp4');
      expect(v.headers['Cookie'], 'a=1');
    });

    test('dedupes by URL and ignores stale page tokens', () async {
      probe.results['https://cdn.test/v.mp4'] = const ProbeResult(
        status: 200,
        finalUrl: 'https://cdn.test/v.mp4',
        length: 80 << 20,
        type: VideoType.mp4,
      );
      ctl.addResource('https://cdn.test/v.mp4', _headers, 1);
      ctl.addResource('https://cdn.test/v.mp4#t=10', _headers, 1);
      ctl.addDom({'url': 'https://cdn.test/v.mp4', 'poster': 'https://cdn.test/p.jpg', 'duration': 120.0}, 1);
      ctl.addResource('https://cdn.test/other.mp4', _headers, 0); // previous page
      await settle();
      final list = c.read(pageVideosProvider).videos;
      expect(list, hasLength(1));
      expect(list.single.poster, 'https://cdn.test/p.jpg');
      expect(list.single.duration, const Duration(minutes: 2));
      expect(probe.calls, ['https://cdn.test/v.mp4']);
    });

    test('navigation clears the list', () async {
      probe.results['https://cdn.test/v.mp4'] = const ProbeResult(
        status: 200,
        finalUrl: 'https://cdn.test/v.mp4',
        length: 80 << 20,
        type: VideoType.mp4,
      );
      ctl.addResource('https://cdn.test/v.mp4', _headers, 1);
      await settle();
      expect(c.read(pageVideosProvider).count, 1);
      ctl.navigated('https://site.test/next', 2);
      expect(c.read(pageVideosProvider).count, 0);
      expect(c.read(pageVideosProvider).promptShown, isFalse);
    });

    test('tiny files, failed probes and non-video range requests are dropped', () async {
      probe.results['https://cdn.test/tiny.mp4'] = const ProbeResult(
        status: 200,
        finalUrl: 'https://cdn.test/tiny.mp4',
        length: 20 * 1024,
        type: VideoType.mp4,
      );
      probe.results['https://cdn.test/stream'] = const ProbeResult(
        status: 206,
        finalUrl: 'https://cdn.test/stream',
        mime: 'audio/mpeg',
      );
      ctl
        ..addResource('https://cdn.test/tiny.mp4', _headers, 1)
        ..addResource('https://cdn.test/gone.mp4', _headers, 1)
        ..addResource('https://cdn.test/stream', _headers, 1, probe: true);
      await settle();
      expect(c.read(pageVideosProvider).count, 0);
    });

    test('blob video lends poster to the network manifest; master hides variants', () async {
      probe.results['https://cdn.test/v/720.m3u8'] = const ProbeResult(
        status: 200,
        finalUrl: 'https://cdn.test/v/720.m3u8',
        type: VideoType.hls,
        mediaPlaylist: true,
      );
      probe.results['https://cdn.test/v/master.m3u8'] = const ProbeResult(
        status: 200,
        finalUrl: 'https://cdn.test/v/master.m3u8',
        type: VideoType.hls,
        master: true,
        height: 1080,
      );
      ctl.addResource('https://cdn.test/v/720.m3u8', _headers, 1);
      ctl.addResource('https://cdn.test/v/master.m3u8', _headers, 1);
      await settle();
      ctl.addDom({'url': 'blob:https://site.test/abc', 'poster': 'https://site.test/poster.jpg', 'title': 'Movie'}, 1);
      final list = c.read(pageVideosProvider).videos;
      expect(list, hasLength(1));
      expect(list.single.url, 'https://cdn.test/v/master.m3u8');
      expect(list.single.quality, '1080p');
      expect(list.single.poster, 'https://site.test/poster.jpg');
    });

    test('DRM pages mark manifests protected', () async {
      probe.results['https://cdn.test/m.mpd'] = const ProbeResult(
        status: 200,
        finalUrl: 'https://cdn.test/m.mpd',
        type: VideoType.dash,
      );
      ctl.addResource('https://cdn.test/m.mpd', _headers, 1);
      await settle();
      expect(c.read(pageVideosProvider).videos.single.protected, isFalse);
      ctl.markDrm(1);
      expect(c.read(pageVideosProvider).videos.single.protected, isTrue);
    });

    test('expired link reloads the page and picks the fresh video', () async {
      const old = WebVideo(url: 'https://cdn.test/old.mp4', type: VideoType.mp4, headers: _headers);
      probe.results['https://cdn.test/old.mp4'] = const ProbeResult(status: 403, finalUrl: 'https://cdn.test/old.mp4');
      probe.results['https://cdn.test/new.mp4'] = const ProbeResult(
        status: 200,
        finalUrl: 'https://cdn.test/new.mp4',
        length: 80 << 20,
        type: VideoType.mp4,
      );
      final fresh = await ctl.ensureFresh(
        old,
        reload: () async {
          ctl.navigated('https://site.test/watch', 2);
          ctl.addResource('https://cdn.test/new.mp4', _headers, 2);
        },
      );
      expect(fresh?.url, 'https://cdn.test/new.mp4');
    });

    test('expired link with nothing new gives up', () async {
      const old = WebVideo(url: 'https://cdn.test/old.mp4', type: VideoType.mp4);
      probe.results['https://cdn.test/old.mp4'] = const ProbeResult(status: 410, finalUrl: 'https://cdn.test/old.mp4');
      final fresh = await ctl.ensureFresh(old, reload: () async {}, wait: const Duration(milliseconds: 500));
      expect(fresh, isNull);
    });
  });
}
