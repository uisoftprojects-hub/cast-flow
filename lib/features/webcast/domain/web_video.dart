import 'package:flutter/foundation.dart';

enum VideoType {
  hls('HLS'),
  dash('DASH'),
  mp4('MP4'),
  webm('WebM'),
  mkv('MKV'),
  mov('MOV');

  const VideoType(this.label);
  final String label;

  bool get isManifest => this == hls || this == dash;
}

/// A playable video found on the current browser page, with everything the
/// TV needs to fetch it (the page's Referer / Cookie / User-Agent).
@immutable
class WebVideo {
  const WebVideo({
    required this.url,
    required this.type,
    this.title,
    this.poster,
    this.height,
    this.duration,
    this.size,
    this.headers = const {},
    this.protected = false,
    this.probed = false,
    this.hidden = false,
    this.mediaPlaylist = false,
  });

  /// Absolute URL (after redirects once probed).
  final String url;
  final VideoType type;
  final String? title;
  final String? poster;

  /// Vertical resolution, e.g. 720.
  final int? height;
  final Duration? duration;

  /// Content-Length in bytes for progressive files.
  final int? size;
  final Map<String, String> headers;

  /// DRM (Widevine / FairPlay / PlayReady): can't be cast.
  final bool protected;
  final bool probed;

  /// Filtered out after probing (too small, preroll, a variant of a master
  /// playlist…). Kept so the same URL isn't reconsidered.
  final bool hidden;

  /// An HLS media (variant) playlist rather than a master playlist.
  final bool mediaPlaylist;

  String? get quality => height == null || height == 0 ? null : '${height}p';

  WebVideo copyWith({
    String? url,
    VideoType? type,
    String? title,
    String? poster,
    int? height,
    Duration? duration,
    int? size,
    Map<String, String>? headers,
    bool? protected,
    bool? probed,
    bool? hidden,
    bool? mediaPlaylist,
  }) {
    return WebVideo(
      url: url ?? this.url,
      type: type ?? this.type,
      title: title ?? this.title,
      poster: poster ?? this.poster,
      height: height ?? this.height,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      headers: headers ?? this.headers,
      protected: protected ?? this.protected,
      probed: probed ?? this.probed,
      hidden: hidden ?? this.hidden,
      mediaPlaylist: mediaPlaylist ?? this.mediaPlaylist,
    );
  }
}

/// What a quick HTTP look at a candidate URL told us.
@immutable
class ProbeResult {
  const ProbeResult({
    required this.status,
    required this.finalUrl,
    this.mime,
    this.length,
    this.type,
    this.height,
    this.duration,
    this.protected = false,
    this.master = false,
    this.mediaPlaylist = false,
  });

  final int status;
  final String finalUrl;
  final String? mime;
  final int? length;
  final VideoType? type;
  final int? height;
  final Duration? duration;
  final bool protected;
  final bool master;
  final bool mediaPlaylist;

  bool get ok => status >= 200 && status < 400;

  /// The link is gone or signed URL expired.
  bool get expired => status == 401 || status == 403 || status == 404 || status == 410;
}
