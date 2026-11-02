import '../../../core/app_providers.dart';
import '../domain/web_models.dart';

class MockMediaDetector implements MediaDetector {
  MockMediaDetector(this._mode);

  final PreviewMode Function() _mode;

  static const _videoHosts = ['youtube', 'facebook', 'vimeo', 'dailymotion', 'twitch', 'instagram', 'm.facebook'];

  @override
  Future<List<DetectedMedia>> load(String url) async {
    await Future<void>.delayed(const Duration(milliseconds: 1300));
    final mode = _mode();
    if (mode == PreviewMode.error) {
      throw const FakeServiceException('This page couldn’t be loaded. Check your connection.');
    }
    final host = hostOf(url);
    if (mode == PreviewMode.empty || !_videoHosts.any(host.contains)) return const [];
    // "m.youtube.com" → "youtube"
    final parts = host.split('.');
    final site = parts.length >= 2 ? parts[parts.length - 2] : parts.first;
    final seed = site.hashCode;
    return [
      DetectedMedia(
        title: 'Featured video on ${site[0].toUpperCase()}${site.substring(1)}',
        url: '$url/video/main.m3u8',
        format: 'HLS',
        quality: '1080p',
        duration: const Duration(minutes: 9, seconds: 32),
        seed: seed,
      ),
      DetectedMedia(
        title: 'Trailer clip',
        url: '$url/video/clip.mp4',
        format: 'MP4',
        quality: '720p',
        duration: const Duration(minutes: 1, seconds: 48),
        seed: seed + 1,
      ),
    ];
  }
}

const quickSites = [
  WebLink(title: 'YouTube', url: 'https://m.youtube.com'),
  WebLink(title: 'Google', url: 'https://www.google.com'),
  WebLink(title: 'Facebook', url: 'https://m.facebook.com/watch'),
  WebLink(title: 'Instagram', url: 'https://www.instagram.com'),
  WebLink(title: 'Vimeo', url: 'https://vimeo.com'),
  WebLink(title: 'Dailymotion', url: 'https://www.dailymotion.com'),
  WebLink(title: 'Twitch', url: 'https://m.twitch.tv'),
];
