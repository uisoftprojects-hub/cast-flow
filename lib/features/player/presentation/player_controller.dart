import '../../../core/debug_log.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/platform/cast_session_channel.dart';
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

  /// The current item was already re-sent converted (only tried once).
  bool _converted = false;
  DateTime? _loadedAt;

  /// How long a TV may sit "stopped" after a load before it counts as "can't
  /// play this format" and the item is converted and sent again.
  static const notPlayingGrace = Duration(seconds: 7);

  /// True while a real TV is playing; the remote then must not also drive the
  /// player (the TV already got the command).
  bool get hasRealSession => _device != null;

  MediaCaster get _caster => ref.read(mediaCasterProvider);

  @override
  PlaybackState build() {
    ref.onDispose(() => _ticker?.cancel());
    // Losing the receiver ends the session.
    ref.listen(connectionProvider, (prev, next) {
      if (prev?.isConnected == true && !next.isConnected) {
        // Lost because the network dropped: remember what was playing so it
        // carries on by itself when the network and the TV are back.
        if (next.error == ConnectionController.networkLost && state.isActive) {
          _resume = (
            deviceId: prev?.device?.id,
            queue: state.queue,
            index: state.index,
            position: state.position,
            slideshow: state.slideshowInterval,
          );
        }
        stop();
      } else if (next.isConnected && _resume != null) {
        final r = _resume!;
        _resume = null;
        // Only the TV that was lost: a different TV starts from scratch.
        if (r.deviceId == next.device?.id) {
          _resumeSeek = r.position;
          play(r.queue, index: r.index, slideshowInterval: r.slideshow);
        }
      }
    });
    // The notification's buttons and seek bar drive the player like the screen does.
    CastSessionChannel.onCommand = _onSessionCommand;
    ref.onDispose(() => CastSessionChannel.onCommand = null);
    listenSelf((_, next) => _syncSession(next));
    return const PlaybackState();
  }

  // ------------------------------------------------- notification session

  void _onSessionCommand(String name, Duration position) {
    switch (name) {
      case 'play':
        if (state.isActive && !state.playing) toggle();
      case 'pause':
        if (state.isActive && state.playing) toggle();
      case 'next':
        next();
      case 'previous':
        previous();
      case 'seek':
        seek(position);
      case 'stop':
        stop();
    }
  }

  /// What was playing when the network dropped (see build).
  ({String? deviceId, List<CastMedia> queue, int index, Duration position, Duration? slideshow})? _resume;

  /// Position to seek to once the resumed item is on the TV.
  Duration? _resumeSeek;

  PlaybackState? _lastSynced;
  DateTime _lastSyncAt = DateTime.now();

  /// Pushes what changed to the notification. Not every second: Android moves
  /// the seek bar itself; only a real change (item, play/pause, a seek or the
  /// TV correcting the position) is sent.
  void _syncSession(PlaybackState s) {
    final media = s.media;
    if (media == null || _device == null) return;
    final prev = _lastSynced;
    final now = DateTime.now();
    var changed = prev == null ||
        prev.media?.id != media.id ||
        prev.media?.duration != media.duration ||
        prev.playing != s.playing ||
        prev.hasNext != s.hasNext ||
        prev.hasPrevious != s.hasPrevious ||
        prev.preparing != s.preparing;
    if (!changed) {
      final expected = prev.position + (prev.playing ? now.difference(_lastSyncAt) : Duration.zero);
      changed = (s.position - expected).abs() > const Duration(seconds: 3);
    }
    if (!changed) return;
    _lastSynced = s;
    _lastSyncAt = now;
    final length = media.isTimed ? media.duration : Duration.zero;
    unawaited(
      CastSessionChannel.update(
        title: media.title,
        subtitle: media.subtitle,
        playing: s.playing,
        position: s.position,
        duration: length,
        hasPrevious: s.hasPrevious,
        hasNext: s.hasNext || (s.playMode == PlayMode.repeatAll && s.queue.length > 1),
        preparing: s.preparing,
      ),
    );
  }

  void play(
    List<CastMedia> queue, {
    int index = 0,
    Duration? slideshowInterval,
  }) {
    if (queue.isEmpty) return;
    _resume = null; // a new cast replaces anything waiting to resume
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
      playMode: state.playMode,
      slideshowInterval: slideshowInterval,
    );
    final tv = ref.read(connectionProvider).device;
    if (tv != null && _caster.canCast(tv)) {
      _device = tv;
      _loadCurrent();
      // Screen off mid-cast must not freeze the server the TV streams from.
      unawaited(
        CastSessionChannel.start(queue[index].title).then((_) {
          // The service is up now: show the current state in its notification.
          _lastSynced = null;
          if (ref.mounted) _syncSession(state);
        }),
      );
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
    final clamped = to < Duration.zero
        ? Duration.zero
        : (to > _length(media) ? _length(media) : to);
    state = state.copyWith(position: clamped);
    final tv = _device;
    if (tv != null && _isStream(media)) _run(_caster.seek(tv, clamped));
  }

  void skip(int seconds) => seek(state.position + Duration(seconds: seconds));

  /// Sets what happens when an item ends (play once, autoplay, repeat all / one).
  void setPlayMode(PlayMode mode) => state = state.copyWith(playMode: mode);

  /// The loop button: steps through the modes.
  void cyclePlayMode() => setPlayMode(state.playMode.next);

  void next() {
    // Repeat all: next on the last item wraps to the first.
    if (!state.hasNext && state.playMode == PlayMode.repeatAll && state.queue.length > 1) {
      jumpTo(0);
      return;
    }
    if (!state.hasNext) return;
    state = state.copyWith(
      index: state.index + 1,
      position: Duration.zero,
      clearError: true,
    );
    _loadCurrent();
  }

  void previous() {
    if (state.position > const Duration(seconds: 3) || !state.hasPrevious) {
      seek(Duration.zero);
      return;
    }
    state = state.copyWith(
      index: state.index - 1,
      position: Duration.zero,
      clearError: true,
    );
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
    state = state.copyWith(
      index: index,
      position: Duration.zero,
      playing: true,
      clearError: true,
    );
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
    final hadReal = _device != null;
    _endReal();
    state = PlaybackState(volume: state.volume, playMode: state.playMode);
    if (hadReal) {
      // Session over: drop published URLs, delete converted temp files, and
      // let Android stop keeping the app alive.
      unawaited(_caster.endSession().catchError((_) {}));
      _lastSynced = null;
      unawaited(CastSessionChannel.stop());
    }
  }

  // ------------------------------------------------------------ real TV

  /// Photos are driven by the slideshow timer; everything else by the TV.
  bool _isStream(CastMedia? m) => m != null && m.kind != CastKind.photo;

  /// Sends the current item to the TV (no-op when simulating).
  ///
  /// When the TV refuses the item (or never starts it), it is converted to a
  /// format every TV plays (MP4 H.264/AAC, JPEG) and sent once more, with a
  /// "Converting for your TV" state on screen meanwhile.
  void _loadCurrent({bool forceConvert = false}) {
    final tv = _device;
    final media = state.media;
    if (tv == null || media == null) return;
    final gen = ++_loadGen;
    _sawPlaying = false;
    _loadedAt = null;
    _converted = forceConvert;
    if (forceConvert)
      state = state.copyWith(
        preparing: true,
        clearProgress: true,
        clearError: true,
      );
    // A local file is checked against what the TV can play before it is sent. If
    // that takes a moment, say so instead of leaving a frozen-looking preview.
    Timer? slow;
    if (!forceConvert && _canConvert(media)) {
      slow = Timer(const Duration(milliseconds: 600), () {
        if (gen == _loadGen && _loadedAt == null && state.media == media && !state.preparing) {
          state = state.copyWith(preparing: true, clearProgress: true);
        }
      });
    }
    _caster
        .load(
          tv,
          media,
          forceConvert: forceConvert,
          onPrepare: (p, [detail]) {
            if (gen != _loadGen || state.media != media) return;
            state = state.copyWith(
              preparing: true,
              prepareProgress: p,
              prepareDetail: detail,
              clearProgress: p == null,
              clearError: true,
            );
          },
        )
        .then((_) {
          slow?.cancel();
          if (gen != _loadGen || state.media != media) return;
          _loadedAt = DateTime.now();
          final seekTo = _resumeSeek;
          _resumeSeek = null;
          if (seekTo != null && seekTo > const Duration(seconds: 3) && _isStream(media)) seek(seekTo);
          state = state.copyWith(
            playing: true,
            clearError: true,
            preparing: false,
          );
        })
        .catchError((Object e) {
          slow?.cancel();
          if (gen != _loadGen) return;
          dlog('[Player] cast failed: $e');
          if (!forceConvert && _canConvert(media) && e is HttpException) {
            // The TV rejected the item itself (e.g. UPnP 714 "illegal MIME
            // type"): convert it and try again.
            _loadCurrent(forceConvert: true);
            return;
          }
          state = state.copyWith(
            playing: false,
            error: _message(e, tv),
            preparing: false,
          );
          _ticker?.cancel();
        });
  }

  /// Local photos and videos can be converted; web streams can't.
  static bool _canConvert(CastMedia m) {
    final url = m.url ?? '';
    return (m.kind == CastKind.photo || m.kind == CastKind.video || m.kind == CastKind.music) &&
        url.isNotEmpty &&
        !url.startsWith('http://') &&
        !url.startsWith('https://');
  }

  /// Fire-and-forget TV command; a failure is shown, not thrown.
  void _run(Future<void> command) {
    command.catchError((Object e) {
      final tv = _device;
      if (tv != null) state = state.copyWith(error: _message(e, tv));
    });
  }

  static String _message(Object e, CastDevice tv) {
    if (e is UnsupportedError)
      return e.message ?? '${tv.name} can’t play this.';
    if (e is StateError) return e.message;
    if (e is TimeoutException)
      return '${tv.name} didn’t respond. Check it is on and on the same Wi-Fi.';
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

    // Loaded fine but the TV never started it: most often a codec it can't
    // decode. Convert and send it again (once).
    final loadedAt = _loadedAt;
    if (!_sawPlaying &&
        !_converted &&
        loadedAt != null &&
        _canConvert(media) &&
        (s.state == 'STOPPED' || s.state == 'NO_MEDIA_PRESENT') &&
        DateTime.now().difference(loadedAt) > notPlayingGrace) {
      dlog('[Player] ${tv.name} did not start ${media.title}; converting');
      _loadCurrent(forceConvert: true);
      return;
    }
    final ended =
        _sawPlaying && (s.state == 'STOPPED' || s.state == 'NO_MEDIA_PRESENT');

    if (ended) {
      _onItemEnded(media);
      return;
    }
    var queue = state.queue;
    if (media.duration == Duration.zero && s.length > Duration.zero) {
      queue = [...queue]..[state.index] = media.withDuration(s.length);
    }
    state = state.copyWith(
      queue: queue,
      position: s.position,
      playing: playing || s.state == 'PAUSED_PLAYBACK'
          ? playing
          : state.playing,
    );
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
        if (state.preparing) return;
        if (state.playing)
          state = state.copyWith(
            position: state.position + const Duration(seconds: 1),
          );
        if (++_tick % 2 == 0) unawaited(_poll());
        return;
      }
      // A photo still being converted doesn't count down its slideshow time.
      if (!state.playing || state.preparing) return;
      final next = state.position + const Duration(seconds: 1);
      if (next >= _length(media)) {
        _onItemEnded(media);
      } else {
        state = state.copyWith(position: next);
      }
    });
  }

  /// An item finished by itself: do what the play mode says.
  void _onItemEnded(CastMedia media) {
    void finish() {
      state = state.copyWith(position: _length(media), playing: false);
      if (_device == null) _ticker?.cancel();
    }

    void again() {
      state = state.copyWith(position: Duration.zero, playing: true, clearError: true);
      _loadCurrent();
    }

    switch (state.playMode) {
      case PlayMode.once:
        finish();
      case PlayMode.repeatOne:
        again();
      case PlayMode.repeatAll:
        if (state.hasNext) {
          next();
        } else if (state.queue.length > 1) {
          jumpTo(0);
        } else {
          again();
        }
      case PlayMode.autoplay:
        if (state.hasNext) {
          next();
        } else if (state.slideshowInterval != null && state.queue.length > 1) {
          jumpTo(0); // a slideshow keeps going round
        } else if (state.slideshowInterval != null) {
          again();
        } else {
          finish();
        }
    }
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

final playerProvider = NotifierProvider<PlayerController, PlaybackState>(
  PlayerController.new,
);

/// Makes sure a receiver is connected (opening the device picker if needed),
/// returns whether the caller may proceed.
Future<bool> ensureConnected(
  BuildContext context,
  WidgetRef ref, {
  String? reason,
}) async {
  if (ref.read(connectionProvider).isConnected) return true;
  // Pre-cast check: no Wi-Fi and no hotspot means no TV can be reached.
  if (!await requireNetwork(context, source: reason ?? 'cast')) return false;
  if (!context.mounted) return false;
  final ok = await context.push<bool>(
    reason == null ? '/connect' : '/connect?reason=$reason',
  );
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
  ref
      .read(playerProvider.notifier)
      .play(queue, index: index, slideshowInterval: slideshowInterval);
  if (context.mounted) context.push('/player');
}
