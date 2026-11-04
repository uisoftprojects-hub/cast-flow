import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_providers.dart';
import '../../devices/domain/receiver_capabilities.dart';
import '../../devices/presentation/device_providers.dart';
import '../../player/presentation/player_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/fake_remote_service.dart';
import '../domain/remote_service.dart';

final remoteServiceProvider = Provider<RemoteService>((ref) => FakeRemoteService(() => ref.read(previewModeProvider)));

@immutable
class TvRemoteState {
  const TvRemoteState({this.volume = 30, this.muted = false, this.lastAction, this.error});

  /// 0..100 as last reported/set; only shown when the receiver supports it.
  final int volume;
  final bool muted;
  final String? lastAction;
  final String? error;

  TvRemoteState copyWith({int? volume, bool? muted, String? lastAction, String? error}) => TvRemoteState(
    volume: volume ?? this.volume,
    muted: muted ?? this.muted,
    lastAction: lastAction ?? this.lastAction,
    error: error,
  );
}

class RemoteController extends Notifier<TvRemoteState> {
  @override
  TvRemoteState build() {
    // Reset when the receiver changes.
    ref.watch(connectionProvider.select((c) => c.device?.id));
    return const TvRemoteState();
  }

  Future<void> send(RemoteCommand command) async {
    final device = ref.read(connectionProvider).device;
    if (device == null || !device.supports(command)) return;

    final settings = ref.read(settingsProvider);
    if (settings.hapticsEnabled) HapticFeedback.lightImpact();
    if (settings.buttonSound) SystemSound.play(SystemSoundType.click);

    try {
      await ref.read(remoteServiceProvider).send(device, command);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return;
    }

    final player = ref.read(playerProvider.notifier);
    final playing = ref.read(playerProvider).isActive;
    switch (command) {
      case RemoteCommand.volumeUp:
        state = state.copyWith(volume: (state.volume + 5).clamp(0, 100), muted: false);
        if (playing) player.setVolume(state.volume / 100);
      case RemoteCommand.volumeDown:
        state = state.copyWith(volume: (state.volume - 5).clamp(0, 100));
        if (playing) player.setVolume(state.volume / 100);
      case RemoteCommand.mute:
        state = state.copyWith(muted: !state.muted);
      case RemoteCommand.playPause when playing:
        player.toggle();
      case RemoteCommand.next when playing:
        player.next();
      case RemoteCommand.previous when playing:
        player.previous();
      case RemoteCommand.rewind when playing:
        player.skip(-10);
      case RemoteCommand.fastForward when playing:
        player.skip(10);
      default:
        break;
    }
    state = state.copyWith(lastAction: command.label);
  }
}

final remoteProvider = NotifierProvider<RemoteController, TvRemoteState>(RemoteController.new);
