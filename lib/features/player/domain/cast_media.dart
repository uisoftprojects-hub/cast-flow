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
    this.convert = false,
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

  /// A web video the TV can't play as it is (e.g. HLS on a DLNA TV): the user
  /// chose "Convert this", so it is downloaded through the phone and converted
  /// to MP4 (H.264 + AAC) before it is sent.
  final bool convert;

  bool get isTimed => duration > Duration.zero;

  CastMedia withDuration(Duration d) => CastMedia(
    id: id,
    title: title,
    kind: kind,
    seed: seed,
    subtitle: subtitle,
    duration: d,
    url: url,
    headers: headers,
    thumbnail: thumbnail,
    convert: convert,
  );
}

/// What happens when an item ends.
enum PlayMode {
  /// Play the current item once, then stop.
  once,

  /// Play on through the queue, stop after the last item (slideshows loop).
  autoplay,

  /// Play on through the queue and start again from the first item.
  repeatAll,

  /// Play the current item again and again.
  repeatOne;

  /// The next mode when the user taps the loop button.
  PlayMode get next => PlayMode.values[(index + 1) % PlayMode.values.length];
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
    this.error,
    this.preparing = false,
    this.prepareProgress,
    this.prepareDetail,
    this.playMode = PlayMode.autoplay,
  });

  final List<CastMedia> queue;

  /// The current item is being made ready for the TV (e.g. converted to a
  /// format it plays). [prepareProgress] is 0..1 when known.
  final bool preparing;
  final double? prepareProgress;

  /// What is converted into what, e.g. "MKV · H.265 / DTS → MP4 · H.264 / AAC".
  final String? prepareDetail;

  /// What happens when an item ends (loop / autoplay / play once).
  final PlayMode playMode;

  /// Why the TV could not play the current item (shown to the user), or null.
  final String? error;
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
    String? error,
    bool clearError = false,
    bool? preparing,
    double? prepareProgress,
    String? prepareDetail,
    PlayMode? playMode,
    bool clearProgress = false,
  }) {
    final isPreparing = preparing ?? this.preparing;
    return PlaybackState(
      queue: queue ?? this.queue,
      index: index ?? this.index,
      playing: playing ?? this.playing,
      position: position ?? this.position,
      volume: volume ?? this.volume,
      slideshowInterval: slideshowInterval ?? this.slideshowInterval,
      error: clearError ? null : (error ?? this.error),
      preparing: isPreparing,
      prepareProgress: !isPreparing || clearProgress
          ? null
          : (prepareProgress ?? this.prepareProgress),
      prepareDetail: !isPreparing ? null : (prepareDetail ?? this.prepareDetail),
      playMode: playMode ?? this.playMode,
    );
  }
}
