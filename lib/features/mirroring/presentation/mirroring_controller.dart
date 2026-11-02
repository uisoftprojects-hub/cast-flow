import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_providers.dart';
import '../../devices/presentation/device_providers.dart';
import '../../history/domain/history_entry.dart';
import '../../history/presentation/history_controller.dart';
import '../../player/domain/cast_media.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/fake_mirroring_service.dart';
import '../domain/mirroring.dart';

final mirroringServiceProvider = Provider<MirroringService>(
  (ref) => FakeMirroringService(() => ref.read(previewModeProvider)),
);

class MirroringController extends Notifier<MirrorState> {
  Timer? _clock;
  StreamSubscription<int>? _latency;

  @override
  MirrorState build() {
    ref.onDispose(_teardown);
    ref.listen(connectionProvider, (prev, next) {
      if (prev?.isConnected == true && !next.isConnected && state.isLive) {
        _teardown();
        state = state.copyWith(phase: MirrorPhase.idle, elapsed: Duration.zero);
      }
    });
    return MirrorState(quality: ref.read(settingsProvider).defaultQuality);
  }

  void setQuality(MirrorQuality q) => state = state.copyWith(quality: q);
  void setAudio(bool v) => state = state.copyWith(audio: v);
  void setAutoRotate(bool v) => state = state.copyWith(autoRotate: v);

  Future<void> start() async {
    final device = ref.read(connectionProvider).device;
    if (device == null || state.isBusy || state.isLive) return;
    state = state.copyWith(phase: MirrorPhase.starting);
    try {
      final service = ref.read(mirroringServiceProvider);
      await service.start(deviceId: device.id, quality: state.quality, audio: state.audio);
      state = state.copyWith(phase: MirrorPhase.live, elapsed: Duration.zero, latencyMs: 52);
      _clock = Timer.periodic(const Duration(seconds: 1), (_) {
        state = state.copyWith(elapsed: state.elapsed + const Duration(seconds: 1));
      });
      _latency = service.latency().listen((ms) => state = state.copyWith(latencyMs: ms));
      ref.read(historyProvider.notifier).add(
            HistoryEntry(
              id: 'mirror-${DateTime.now().microsecondsSinceEpoch}',
              title: 'Screen mirroring session',
              kind: CastKind.mirror,
              deviceName: device.name,
              castAt: DateTime.now(),
              seed: 6,
            ),
          );
    } catch (e) {
      state = state.copyWith(phase: MirrorPhase.error, error: e.toString());
    }
  }

  Future<void> stop() async {
    if (!state.isLive) return;
    state = state.copyWith(phase: MirrorPhase.stopping);
    _teardown();
    await ref.read(mirroringServiceProvider).stop();
    state = state.copyWith(phase: MirrorPhase.idle, elapsed: Duration.zero, latencyMs: 0);
  }

  void _teardown() {
    _clock?.cancel();
    _latency?.cancel();
  }
}

final mirroringProvider = NotifierProvider<MirroringController, MirrorState>(MirroringController.new);
