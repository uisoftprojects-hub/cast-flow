import 'package:flutter/foundation.dart';

import '../../settings/domain/app_settings.dart';

enum MirrorPhase { idle, starting, live, stopping, error }

@immutable
class MirrorState {
  const MirrorState({
    this.phase = MirrorPhase.idle,
    this.quality = MirrorQuality.auto,
    this.audio = true,
    this.autoRotate = true,
    this.elapsed = Duration.zero,
    this.latencyMs = 0,
    this.error,
    this.tvName,
  });

  final MirrorPhase phase;
  final MirrorQuality quality;
  final bool audio;
  final bool autoRotate;
  final Duration elapsed;
  final int latencyMs;
  final String? error;

  /// Name of the display the screen is mirrored to (from the system).
  final String? tvName;

  bool get isLive => phase == MirrorPhase.live;
  bool get isBusy => phase == MirrorPhase.starting || phase == MirrorPhase.stopping;

  MirrorState copyWith({
    MirrorPhase? phase,
    MirrorQuality? quality,
    bool? audio,
    bool? autoRotate,
    Duration? elapsed,
    int? latencyMs,
    String? error,
    String? tvName,
  }) {
    return MirrorState(
      phase: phase ?? this.phase,
      quality: quality ?? this.quality,
      audio: audio ?? this.audio,
      autoRotate: autoRotate ?? this.autoRotate,
      elapsed: elapsed ?? this.elapsed,
      latencyMs: latencyMs ?? this.latencyMs,
      error: error,
      tvName: tvName ?? this.tvName,
    );
  }
}
