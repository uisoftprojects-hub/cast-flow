import '../../../core/debug_log.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../devices/domain/cast_device.dart';
import '../../devices/presentation/device_providers.dart';
import '../../devices/presentation/widgets/network_widgets.dart';
import '../../history/domain/history_entry.dart';
import '../../history/presentation/history_controller.dart';
import '../data/media_caster.dart';
import '../domain/cast_media.dart';

/// Playback session. When the connected TV can receive media (DLNA), the item
/// is really sent to it and the TV is the source of truth (position and state
/// are polled from it). Otherwise it is a local simulation that advances the
/// position with a timer, as a receiver's media status updates would.
class PlayerController extends Notifier<PlaybackState> {
  Timer? _ticker;

  /// The TV playing for real, or null when simulating.
  CastDevice? _device;
  int _loadGen = 0;
  int _tick = 0;
  bool _sawPlaying = false;

  /// True while a real TV is playing; the remote then must not also drive the
  /// player (the TV already got the command).
  bool get hasRealSession => _device != null;

  MediaCaster get _caster => ref.read(mediaCasterProvider);

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
    _endReal();
    state = PlaybackState(
      queue: queue,
      index: index,
      playing: true,
      volume: state.volume,
      slideshowInterval: slideshowInterval,
    );
    final tv = ref.read(connectionProvider).device;
    if (tv != null && _caster.canCast(tv)) {
      _device = tv;
      _loadCurrent();
    }
    _startTicker();
    _record(queue[index]);
  }

  void toggle() {
    final playing = !state.playing;
    state = state.copyWith(playing: playing);
    final tv = _device;
    if (tv != null && _isStream(state.media)) {
      _run(playing ? _caster.play(tv) : _caster.pause(tv));
      // Keep polling while paused so a resume from the TV's own remote shows up.
      _startTicker();
      return;
    }
    playing ? _startTicker() : _ticker?.cancel();
  }

  void seek(Duration to) {
    final media = state.media;
    if (media == null) return;
    final clamped = to < Duration.zero ? Duration.zero : (to > _length(media) ? _length(media) : to);
    state = state.copyWith(position: clamped);
    final tv = _device;
    if (tv != null && _isStream(media)) _run(_caster.seek(tv, clamped));
  }

  void skip(int seconds) => seek(state.position + Duration(seconds: seconds));

  void next() {
    if (!state.hasNext) return;
    state = state.copyWith(index: state.index + 1, position: Duration.zero, clearError: true);
    _loadCurrent();
  }

  void previous() {
    if (state.position > const Duration(seconds: 3) || !state.hasPrevious) {
      seek(Duration.zero);
      return;
    }
    state = state.copyWith(index: state.index - 1, position: Duration.zero, clearError: true);
    _loadCurrent();
  }

  void setVolume(double v) {
    state = state.copyWith(volume: v.clamp(0, 1));
    final tv = _device;
    if (tv != null) _run(_caster.setVolume(tv, state.volume));
  }

  /// Plays the queue item at [index] (from the "Up next" list).
  void jumpTo(int index) {
    if (index < 0 || index >= state.queue.length) return;
    state = state.copyWith(index: index, position: Duration.zero, playing: true, clearError: true);
    _loadCurrent();
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
    _endReal();
    state = PlaybackState(volume: state.volume);
  }

  // ------------------------------------------------------------ real TV

  /// Photos are driven by the slideshow timer; everything else by the TV.
  bool _isStream(CastMedia? m) => m != null && m.kind != CastKind.photo;

  /// Sends the current item to the TV (no-op when simulating).
  void _loadCurrent() {
    final tv = _device;
    final media = state.media;
    if (tv == null || media == null) return;
    final gen = ++_loadGen;
    _sawPlaying = false;
    _caster
        .load(tv, media)
        .then((_) {
          if (gen == _loadGen && state.media == media) state = state.copyWith(playing: true, clearError: true);
        })
        .catchError((Object e) {
          if (gen != _loadGen) return;
          dlog('[Player] cast failed: $e');
          state = state.copyWith(playing: false, error: _message(e, tv));
          _ticker?.cancel();
        });
  }

  /// Fire-and-forget TV command; a failure is shown, not thrown.
  void _run(Future<void> command) {
    command.catchError((Object e) {
      final tv = _device;
      if (tv != null) state = state.copyWith(error: _message(e, tv));
    });
  }

  static String _message(Object e, CastDevice tv) {
    if (e is UnsupportedError) return e.message ?? '${tv.name} can’t play this.';
    if (e is TimeoutException) return '${tv.name} didn’t respond. Check it is on and on the same Wi-Fi.';
    return '${tv.name} couldn’t play this. Try another file or format.';
  }

  void _endReal() {
    final tv = _device;
    _device = null;
    _loadGen++;
    if (tv != null) _caster.stop(tv).catchError((_) {});
  }

  /// Pulls position and play state from the TV (a TV-side pause, the end of an
  /// item or a stop from its own remote all show up here).
  Future<void> _poll() async {
    final tv = _device;
    final media = state.media;
    if (tv == null || media == null || !_isStream(media)) return;
    final gen = _loadGen;
    final s = await _caster.status(tv);
    if (s == null || gen != _loadGen || _device == null) return;

    final playing = s.state == 'PLAYING' || s.state == 'TRANSITIONING';
    if (playing) _sawPlaying = true;
    final ended = _sawPlaying && (s.state == 'STOPPED' || s.state == 'NO_MEDIA_PRESENT');

    if (ended) {
      if (state.hasNext) {
        next();
      } else {
        state = state.copyWith(playing: false, position: _length(media));
      }
      return;
    }
    var queue = state.queue;
    if (media.duration == Duration.zero && s.length > Duration.zero) {
      queue = [...queue]..[state.index] = media.withDuration(s.length);
    }
    state = state.copyWith(queue: queue, position: s.position, playing: playing || s.state == 'PAUSED_PLAYBACK' ? playing : state.playing);
  }

  Duration _length(CastMedia m) {
    if (m.isTimed) return m.duration;
    // A real stream whose length the TV hasn't reported yet is not "5 seconds".
    if (_device != null && _isStream(m)) return const Duration(hours: 24);
    return state.slideshowInterval ?? const Duration(seconds: 5);
  }

  void _startTicker() {
    _ticker?.cancel();
    _tick = 0;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final media = state.media;
      if (media == null) return;
      if (_device != null && _isStream(media)) {
        // The TV is in charge: advance the clock between polls, then correct it.
        if (state.playing) state = state.copyWith(position: state.position + const Duration(seconds: 1));
        if (++_tick % 2 == 0) unawaited(_poll());
        return;
      }
      if (!state.playing) return;
      final next = state.position + const Duration(seconds: 1);
      if (next >= _length(media)) {
        if (state.hasNext) {
          state = state.copyWith(index: state.index + 1, position: Duration.zero);
          _loadCurrent();
        } else if (state.slideshowInterval != null) {
          state = state.copyWith(index: 0, position: Duration.zero);
          _loadCurrent();
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
