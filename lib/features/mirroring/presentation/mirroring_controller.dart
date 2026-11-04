import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/platform/network_channel.dart';
import '../../history/domain/history_entry.dart';
import '../../history/presentation/history_controller.dart';
import '../../player/domain/cast_media.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/mirroring.dart';

/// Reads whether the system is mirroring the screen (overridable in tests).
final mirroringStatusReaderProvider = Provider<Future<({bool active, String? name})> Function()>(
  (ref) => NetworkChannel.mirroringStatus,
);

/// Opens the system Smart View / Cast picker (overridable in tests).
final castSettingsOpenerProvider = Provider<Future<bool> Function()>((ref) => NetworkChannel.openCastSettings);

/// Error marker: the user came back from the cast picker without starting.
const mirrorNotStarted = 'not-started';

/// Screen mirroring runs through Android's own Smart View / Cast (apps can't
/// start Miracast themselves). This tracks the real state: it watches for the
/// presentation display the system adds while mirroring.
class MirroringController extends Notifier<MirrorState> {
  Timer? _clock;
  Timer? _poll;
  AppLifecycleListener? _lifecycle;

  @override
  MirrorState build() {
    ref.onDispose(_teardown);
    _lifecycle = AppLifecycleListener(onResume: refresh);
    ref.onDispose(() => _lifecycle?.dispose());
    Future.microtask(refresh); // already mirroring when the app opens
    return MirrorState(quality: ref.read(settingsProvider).defaultQuality);
  }

  /// Quality is remembered as the default for next time.
  void setQuality(MirrorQuality q) {
    state = state.copyWith(quality: q);
    ref.read(settingsProvider.notifier).setDefaultQuality(q);
  }

  void setAudio(bool v) => state = state.copyWith(audio: v);
  void setAutoRotate(bool v) => state = state.copyWith(autoRotate: v);

  /// Shows the "starting" state and opens the system picker; the result is
  /// read when the app comes back.
  Future<void> start() async {
    ref.read(analyticsProvider).log(AnalyticsEvent.mirrorStartTap, {AnalyticsParam.quality: state.quality.label});
    if (state.isBusy || state.isLive) return;
    state = state.copyWith(phase: MirrorPhase.starting);
    // Let the start animation play before leaving the app.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!ref.mounted) return;
    final opened = await ref.read(castSettingsOpenerProvider)();
    if (!ref.mounted) return;
    if (!opened) state = state.copyWith(phase: MirrorPhase.error, error: 'no-picker');
  }

  /// Mirroring can only be ended from the system: open the picker.
  Future<void> stop() async {
    if (!state.isLive) return;
    await ref.read(castSettingsOpenerProvider)();
  }

  Future<void> refresh() async {
    final s = await ref.read(mirroringStatusReaderProvider)();
    if (!ref.mounted) return;
    if (s.active && !state.isLive) {
      _goLive(s.name);
    } else if (!s.active && state.isLive) {
      _teardown();
      state = MirrorState(quality: state.quality, audio: state.audio, autoRotate: state.autoRotate);
    } else if (!s.active && state.phase == MirrorPhase.starting) {
      // Came back from the picker without picking a TV.
      state = state.copyWith(phase: MirrorPhase.idle, error: mirrorNotStarted);
    }
  }

  void _goLive(String? name) {
    ref.read(analyticsProvider).log(AnalyticsEvent.mirrorLive, {AnalyticsParam.quality: state.quality.label});
    state = state.copyWith(phase: MirrorPhase.live, elapsed: Duration.zero, tvName: name ?? 'TV');
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsed: state.elapsed + const Duration(seconds: 1));
    });
    // Notice when mirroring ends from the notification shade or the TV.
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 3), (_) => refresh());
    ref
        .read(historyProvider.notifier)
        .add(
          HistoryEntry(
            id: 'mirror-${DateTime.now().microsecondsSinceEpoch}',
            title: 'Screen mirroring session',
            kind: CastKind.mirror,
            deviceName: name ?? 'TV',
            castAt: DateTime.now(),
            seed: 6,
          ),
        );
  }

  void _teardown() {
    _clock?.cancel();
    _poll?.cancel();
  }
}

final mirroringProvider = NotifierProvider<MirroringController, MirrorState>(MirroringController.new);
