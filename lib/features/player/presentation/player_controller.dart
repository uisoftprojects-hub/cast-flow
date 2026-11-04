import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../devices/presentation/device_providers.dart';
import '../../devices/presentation/widgets/network_widgets.dart';
import '../../history/domain/history_entry.dart';
import '../../history/presentation/history_controller.dart';
import '../domain/cast_media.dart';

/// Fake remote-playback session: advances the position with a timer the way
/// a receiver's media status updates would.
class PlayerController extends Notifier<PlaybackState> {
  Timer? _ticker;

  @override
  PlaybackState build() {
    ref.onDispose(() => _ticker?.cancel());
    // Losing the receiver ends the session.
    ref.listen(connectionProvider, (prev, next) {
      if (prev?.isConnected == true && !next.isConnected) stop();
    });
    return const PlaybackState();
  }

  void play(List<CastMedia> queue, {int index = 0, Duration? slideshowInterval}) {
    if (queue.isEmpty) return;
    ref.read(analyticsProvider).log(AnalyticsEvent.castStart, {
      AnalyticsParam.mediaType: queue[index].kind,
      AnalyticsParam.itemCount: queue.length,
      AnalyticsParam.deviceType: ref.read(connectionProvider).device?.type,
      AnalyticsParam.source: slideshowInterval == null ? null : 'slideshow',
    });
    state = PlaybackState(
      queue: queue,
      index: index,
      playing: true,
      volume: state.volume,
      slideshowInterval: slideshowInterval,
    );
    _startTicker();
    _record(queue[index]);
  }

  void toggle() {
    state = state.copyWith(playing: !state.playing);
    state.playing ? _startTicker() : _ticker?.cancel();
  }

  void seek(Duration to) {
    final media = state.media;
    if (media == null) return;
    final clamped = to < Duration.zero ? Duration.zero : (to > _length(media) ? _length(media) : to);
    state = state.copyWith(position: clamped);
  }

  void skip(int seconds) => seek(state.position + Duration(seconds: seconds));

  void next() {
    if (!state.hasNext) return;
    state = state.copyWith(index: state.index + 1, position: Duration.zero);
  }

  void previous() {
    if (state.position > const Duration(seconds: 3) || !state.hasPrevious) {
      seek(Duration.zero);
      return;
    }
    state = state.copyWith(index: state.index - 1, position: Duration.zero);
  }

  void setVolume(double v) => state = state.copyWith(volume: v.clamp(0, 1));

  /// Plays the queue item at [index] (from the "Up next" list).
  void jumpTo(int index) {
    if (index < 0 || index >= state.queue.length) return;
    state = state.copyWith(index: index, position: Duration.zero, playing: true);
    _startTicker();
    _record(state.queue[index]);
  }

  /// Appends items picked by the user to the end of the queue.
  void enqueue(List<CastMedia> items) {
    if (items.isEmpty) return;
    if (!state.isActive) return play(items);
    state = state.copyWith(queue: [...state.queue, ...items]);
  }

  void stop() {
    _ticker?.cancel();
    state = PlaybackState(volume: state.volume);
  }

  Duration _length(CastMedia m) => m.isTimed ? m.duration : (state.slideshowInterval ?? const Duration(seconds: 5));

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final media = state.media;
      if (media == null || !state.playing) return;
      final next = state.position + const Duration(seconds: 1);
      if (next >= _length(media)) {
        if (state.hasNext) {
          state = state.copyWith(index: state.index + 1, position: Duration.zero);
        } else if (state.slideshowInterval != null) {
          state = state.copyWith(index: 0, position: Duration.zero);
        } else {
          state = state.copyWith(position: _length(media), playing: false);
          _ticker?.cancel();
        }
      } else {
        state = state.copyWith(position: next);
      }
    });
  }

  void _record(CastMedia m) {
    final device = ref.read(connectionProvider).device;
    ref
        .read(historyProvider.notifier)
        .add(
          HistoryEntry(
            id: '${m.id}-${DateTime.now().microsecondsSinceEpoch}',
            title: m.title,
            kind: m.kind,
            deviceName: device?.name ?? 'Unknown device',
            castAt: DateTime.now(),
            seed: m.seed,
          ),
        );
  }
}

final playerProvider = NotifierProvider<PlayerController, PlaybackState>(PlayerController.new);

/// Makes sure a receiver is connected (opening the device picker if needed),
/// returns whether the caller may proceed.
Future<bool> ensureConnected(BuildContext context, WidgetRef ref, {String? reason}) async {
  if (ref.read(connectionProvider).isConnected) return true;
  // Pre-cast check: no Wi-Fi and no hotspot means no TV can be reached.
  if (!await requireNetwork(context, source: reason ?? 'cast')) return false;
  if (!context.mounted) return false;
  final ok = await context.push<bool>(reason == null ? '/connect' : '/connect?reason=$reason');
  return ok == true || ref.read(connectionProvider).isConnected;
}

/// Connects if needed, starts casting [queue] and opens the remote.
Future<void> castAndOpenRemote(
  BuildContext context,
  WidgetRef ref,
  List<CastMedia> queue, {
  int index = 0,
  Duration? slideshowInterval,
}) async {
  if (!await ensureConnected(context, ref)) return;
  ref.read(playerProvider.notifier).play(queue, index: index, slideshowInterval: slideshowInterval);
  if (context.mounted) context.push('/player');
}
