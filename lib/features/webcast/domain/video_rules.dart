import '../../devices/domain/cast_device.dart';
import 'web_video.dart';

/// Progressive files below this are thumbnails, previews or ad stingers.
const minVideoBytes = 400 * 1024;

/// Clips this short are prerolls / hover previews, not the page's video.
const minVideoDuration = Duration(seconds: 12);

const _extensions = {
  '.m3u8': VideoType.hls,
  '.mpd': VideoType.dash,
  '.mp4': VideoType.mp4,
  '.m4v': VideoType.mp4,
  '.webm': VideoType.webm,
  '.mkv': VideoType.mkv,
  '.mov': VideoType.mov,
};

VideoType? videoTypeFromUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;
  final path = uri.path.toLowerCase();
  for (final e in _extensions.entries) {
    if (path.endsWith(e.key)) return e.value;
  }
  return null;
}

VideoType? videoTypeFromMime(String? mime) {
  if (mime == null) return null;
  final m = mime.toLowerCase().split(';').first.trim();
  return switch (m) {
    'application/x-mpegurl' || 'application/vnd.apple.mpegurl' || 'audio/mpegurl' || 'audio/x-mpegurl' => VideoType.hls,
    'application/dash+xml' => VideoType.dash,
    'video/mp4' || 'video/x-m4v' => VideoType.mp4,
    'video/webm' => VideoType.webm,
    'video/x-matroska' => VideoType.mkv,
    'video/quicktime' => VideoType.mov,
    _ => m.startsWith('video/') ? VideoType.mp4 : null,
  };
}

const _adHosts = [
  'doubleclick.net',
  'googlesyndication.com',
  'googleadservices.com',
  'imasdk.googleapis.com',
  'adservice.',
  'adsystem',
  'adnxs.com',
  'moatads.com',
  'springserve',
  'spotxchange',
  'teads.tv',
  'innovid.com',
  'serving-sys.com',
  'flashtalking.com',
  'adform.net',
  'criteo',
  'taboola',
  'outbrain',
  'scorecardresearch',
  'jwpltx.com',
];

final _adPath = RegExp(r'(^|[/_.\-])(ads?|adv|vast|vpaid|preroll|pre-roll|midroll|pixel|beacon)([/_.\-]|$)');

/// Ads, trackers and preroll creatives by host or path.
bool looksLikeAd(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return true;
  final host = uri.host.toLowerCase();
  if (_adHosts.any(host.contains) || host.startsWith('ads.') || host.startsWith('ad.')) return true;
  return _adPath.hasMatch(uri.path.toLowerCase());
}

/// URLs worth considering at all: http(s) only (blob:/data: have no real
/// source the TV could fetch) and not an ad.
bool isCandidateUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https')) || uri.host.isEmpty) return false;
  return !looksLikeAd(url);
}

/// Dedupe key: the URL without its fragment.
String videoKey(String url) {
  final i = url.indexOf('#');
  return i < 0 ? url : url.substring(0, i);
}

/// Hides probed results that aren't the page's main video.
bool shouldHide(WebVideo v) {
  if (!v.type.isManifest && v.size != null && v.size! > 0 && v.size! < minVideoBytes) return true;
  if (v.duration != null && v.duration! > Duration.zero && v.duration! < minVideoDuration) return true;
  return false;
}

/// Facts read from an HLS playlist or DASH manifest.
class ManifestInfo {
  const ManifestInfo({
    this.height,
    this.duration,
    this.protected = false,
    this.master = false,
    this.mediaPlaylist = false,
  });
  final int? height;
  final Duration? duration;
  final bool protected;
  final bool master;
  final bool mediaPlaylist;
}

final _resolution = RegExp(r'RESOLUTION=\d+x(\d+)');
final _extinf = RegExp(r'#EXTINF:([\d.]+)');
final _dashHeight = RegExp(r'''\bheight="(\d+)"''');
final _dashDuration = RegExp(r'''mediaPresentationDuration="PT(?:(\d+)H)?(?:(\d+)M)?(?:([\d.]+)S)?"''');

ManifestInfo parseHls(String body) {
  final master = body.contains('#EXT-X-STREAM-INF');
  final heights = _resolution.allMatches(body).map((m) => int.parse(m.group(1)!));
  final seconds = _extinf.allMatches(body).fold<double>(0, (s, m) => s + (double.tryParse(m.group(1)!) ?? 0));
  // Encrypted with a DRM key system (AES-128 alone is castable).
  final drm = RegExp(
    r'#EXT-X-(SESSION-)?KEY:[^\n]*(SAMPLE-AES|KEYFORMAT="(com\.apple\.streamingkeydelivery|com\.widevine|urn:uuid))',
  ).hasMatch(body);
  return ManifestInfo(
    master: master,
    mediaPlaylist: !master && body.contains('#EXTINF'),
    height: heights.isEmpty ? null : heights.reduce((a, b) => a > b ? a : b),
    duration: seconds > 0 && body.contains('#EXT-X-ENDLIST') ? Duration(milliseconds: (seconds * 1000).round()) : null,
    protected: drm,
  );
}

ManifestInfo parseDash(String body) {
  final heights = _dashHeight.allMatches(body).map((m) => int.parse(m.group(1)!));
  final d = _dashDuration.firstMatch(body);
  Duration? duration;
  if (d != null) {
    final h = int.tryParse(d.group(1) ?? '') ?? 0;
    final m = int.tryParse(d.group(2) ?? '') ?? 0;
    final s = double.tryParse(d.group(3) ?? '') ?? 0;
    duration = Duration(milliseconds: ((h * 3600 + m * 60 + s) * 1000).round());
  }
  return ManifestInfo(
    master: true,
    height: heights.isEmpty ? null : heights.reduce((a, b) => a > b ? a : b),
    duration: duration,
    protected:
        RegExp(r'<ContentProtection[^>]*urn:uuid:', caseSensitive: false).hasMatch(body) || body.contains('cenc:pssh'),
  );
}

/// Formats each receiver family can play from a URL.
/// - Google Cast default receiver: HLS, DASH, MP4, WebM.
/// - Roku: HLS, DASH, MP4, MKV, MOV.
/// - DLNA renderers: progressive files (HLS on some models only).
/// - Smart TVs (Tizen / webOS / Android TV media players): HLS + files.
/// - Miracast is a screen-mirroring sink with no URL playback.
const formatSupport = <DeviceType, Set<VideoType>>{
  DeviceType.chromecast: {VideoType.hls, VideoType.dash, VideoType.mp4, VideoType.webm},
  DeviceType.roku: {VideoType.hls, VideoType.dash, VideoType.mp4, VideoType.mkv, VideoType.mov},
  DeviceType.fireTv: {...VideoType.values},
  DeviceType.dlna: {VideoType.mp4, VideoType.mkv, VideoType.mov},
  DeviceType.smartTv: {VideoType.hls, VideoType.mp4, VideoType.mkv, VideoType.mov, VideoType.webm},
  DeviceType.miracast: {},
};

bool deviceSupports(CastDevice d, VideoType t) => formatSupport[d.type]?.contains(t) ?? false;
