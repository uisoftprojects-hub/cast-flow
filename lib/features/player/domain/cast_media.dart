import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

enum CastKind {
  photo('Photo', Iconsax.gallery_copy),
  video('Video', Iconsax.video_copy),
  music('Music', Iconsax.music_copy),
  web('Web video', Iconsax.global_copy),
  youtube('YouTube', Iconsax.youtube_copy),
  link('Link', Iconsax.link_2_copy),
  mirror('Screen mirroring', Iconsax.screenmirroring_copy);

  const CastKind(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Anything that can be sent to a receiver and controlled from the remote.
@immutable
class CastMedia {
  const CastMedia({
    required this.id,
    required this.title,
    required this.kind,
    required this.seed,
    this.subtitle,
    this.duration = Duration.zero,
    this.url,
    this.headers = const {},
    this.thumbnail,
  });

  final String id;
  final String title;
  final String? subtitle;
  final CastKind kind;
  final Duration duration;
  final int seed;
  final String? url;

  /// HTTP headers the receiver must send (Referer / Cookie / User-Agent of
  /// the page a web video came from).
  final Map<String, String> headers;
  final String? thumbnail;

  bool get isTimed => duration > Duration.zero;
}

@immutable
class PlaybackState {
  const PlaybackState({
    this.queue = const [],
    this.index = 0,
    this.playing = false,
    this.position = Duration.zero,
    this.volume = 0.6,
    this.slideshowInterval,
  });

  final List<CastMedia> queue;
  final int index;
  final bool playing;
  final Duration position;
  final double volume;

  /// Non-null when photos are cast as a slideshow.
  final Duration? slideshowInterval;

  CastMedia? get media => queue.isEmpty ? null : queue[index];
  bool get isActive => media != null;
  bool get hasNext => index < queue.length - 1;
  bool get hasPrevious => index > 0;

  PlaybackState copyWith({
    List<CastMedia>? queue,
    int? index,
    bool? playing,
    Duration? position,
    double? volume,
    Duration? slideshowInterval,
  }) {
    return PlaybackState(
      queue: queue ?? this.queue,
      index: index ?? this.index,
      playing: playing ?? this.playing,
      position: position ?? this.position,
      volume: volume ?? this.volume,
      slideshowInterval: slideshowInterval ?? this.slideshowInterval,
    );
  }
}
