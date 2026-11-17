import '../../../core/debug_log.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../devices/domain/cast_device.dart';
import '../../devices/domain/receiver_capabilities.dart';
import '../../devices/presentation/device_providers.dart';
import '../../player/presentation/player_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../../pairing/presentation/pairing_controller.dart';
import '../data/dlna_client.dart';
import '../data/network_remote_service.dart';
import '../domain/remote_service.dart';

final remoteServiceProvider = Provider<RemoteService>((ref) {
  final service = NetworkRemoteService(ref.watch(credentialStoreProvider), dlna: ref.watch(dlnaClientProvider));
  ref.onDispose(service.dispose);
  return service;
});

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

/// A readable message without the Dart exception type in front of it.
String _friendly(Object e) => switch (e) {
  HttpException(:final message) => message,
  UnsupportedError(:final message) => message ?? 'This TV can’t do that.',
  TimeoutException() => 'The TV didn’t respond in time.',
  _ => e.toString().replaceFirst(RegExp(r'^\w*(Exception|Error): '), ''),
};

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
    HapticFeedback.lightImpact();
    if (settings.buttonSound) SystemSound.play(SystemSoundType.click);

    // A smart TV that only showed DLNA/Cast is controlled through the Android TV
    // remote service for channel keys; once that works, the whole remote is too.
    final viaAndroidTv = device.protocol == RemoteProtocol.dlna && RemoteCommand.keys.contains(command);
    final androidTvCopy = device.copyWith(protocol: RemoteProtocol.androidTv);
    try {
      try {
        await ref.read(remoteServiceProvider).send(device, command);
      } on NotPairedException {
        // Connected without a pairing credential (pairing was skipped or the TV
        // forgot this phone): pair now, with the TV's code/Allow prompt, then retry.
        final target = viaAndroidTv ? androidTvCopy : device;
        final ok = await ref.read(pairingProvider.notifier).pair(target, userInitiated: true);
        if (!ok) {
          state = state.copyWith(error: 'Pairing was cancelled, so the remote can’t control ${device.name}.');
          return;
        }
        await ref.read(remoteServiceProvider).send(target, command);
      }
      if (viaAndroidTv) ref.read(connectionProvider.notifier).adopt(androidTvCopy);
    } catch (e) {
      dlog('[Remote] ${command.label} on ${device.name} failed: $e');
      state = state.copyWith(error: _friendly(e));
      return;
    }

    final player = ref.read(playerProvider.notifier);
    // A real TV session already got this command from the remote service and
    // reports its own state back; driving the player too would toggle twice.
    final playing = ref.read(playerProvider).isActive && !player.hasRealSession;
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
