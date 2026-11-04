import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../devices/domain/cast_device.dart';
import '../../devices/presentation/network_controller.dart';
import '../data/android_tv_pairing.dart';
import '../data/approval_pairing.dart';
import '../data/secure_credential_store.dart';
import '../domain/pairing.dart';

final credentialStoreProvider = Provider<CredentialStore>((ref) => SecureCredentialStore());

final pairingProtocolsProvider = Provider<List<PairingProtocol>>(
  (ref) => [AndroidTvPairing(), SamsungPairing(), LgPairing()],
);

enum PairingPhase {
  /// Waiting for the user to type the code shown on the TV.
  enterCode,

  /// Waiting for the user to tap Allow on the TV.
  approval,
  verifying,
  success,
  wrongCode,
  timeout,
  rejected,

  /// Too many wrong codes; the user must request a new one.
  cooldown,
  networkLost,
  failed,
}

@immutable
class PairingUi {
  const PairingUi({
    required this.device,
    required this.phase,
    this.codeLength = 6,
    this.hex = false,
    this.attempts = 0,
    this.cooldownUntil,
  });

  final CastDevice device;
  final PairingPhase phase;
  final int codeLength;
  final bool hex;
  final int attempts;
  final DateTime? cooldownUntil;

  bool get isCode => phase != PairingPhase.approval && codeLength > 0;

  PairingUi copyWith({PairingPhase? phase, int? codeLength, bool? hex, int? attempts, DateTime? cooldownUntil}) =>
      PairingUi(
        device: device,
        phase: phase ?? this.phase,
        codeLength: codeLength ?? this.codeLength,
        hex: hex ?? this.hex,
        attempts: attempts ?? this.attempts,
        cooldownUntil: cooldownUntil ?? this.cooldownUntil,
      );
}

/// Runs pairing for a device and drives the pairing sheet. `null` state means
/// no sheet; the sheet appears only when the TV actually asks for something.
class PairingController extends Notifier<PairingUi?> {
  static const timeout = Duration(seconds: 45);
  static const maxAttempts = 3;
  static const cooldown = Duration(seconds: 30);

  PairingSession? _session;
  StreamSubscription<PairingStep>? _sub;
  Timer? _timeout;
  Completer<bool>? _result;
  CastDevice? _device;
  PairingProtocol? _protocol;
  bool _waitingForUi = false;

  @override
  PairingUi? build() {
    ref.onDispose(_closeSession);
    ref.listen(networkProvider, (prev, next) {
      if (next != null && !next.ready && _result != null && state != null) {
        _closeSession();
        state = state!.copyWith(phase: PairingPhase.networkLost);
      }
    });
    return null;
  }

  /// Pairs [device] if its protocol needs it. Resolves true when connected,
  /// false when cancelled. Concurrent calls share one session.
  Future<bool> pair(CastDevice device) {
    if (_result != null) return _device?.id == device.id ? _result!.future : Future.value(false);
    final protocol = ref.read(pairingProtocolsProvider).where((p) => p.handles(device)).firstOrNull;
    if (protocol == null) return Future.value(true); // Chromecast, Roku, DLNA…
    _device = device;
    _protocol = protocol;
    _result = Completer<bool>();
    _start(useSaved: true);
    return _result!.future;
  }

  Future<void> _start({required bool useSaved}) async {
    _closeSession();
    final store = ref.read(credentialStoreProvider);
    final saved = useSaved ? await store.read(_device!.id).catchError((_) => null) : null;
    if (_result == null) return;
    _waitingForUi = true;
    final session = _protocol!.start(_device!, saved: saved);
    _session = session;
    _sub = session.steps.listen(_onStep);
  }

  void _onStep(PairingStep step) {
    final device = _device;
    if (device == null) return;
    final ui = state ?? PairingUi(device: device, phase: PairingPhase.approval);
    switch (step) {
      case NeedsCode(:final length, :final hex):
        _waitingForUi = false;
        state = ui.copyWith(phase: PairingPhase.enterCode, codeLength: length, hex: hex);
        _armTimeout();
      case AwaitingApproval():
        _waitingForUi = false;
        state = ui.copyWith(phase: PairingPhase.approval, codeLength: 0);
        _armTimeout();
      case PairingDone(:final credential):
        _timeout?.cancel();
        if (credential.isNotEmpty) ref.read(credentialStoreProvider).write(device.id, credential);
        if (state == null) {
          _finish(true); // saved credentials worked: no sheet at all
        } else {
          state = ui.copyWith(phase: PairingPhase.success);
          Future<void>.delayed(const Duration(milliseconds: 900), () => _finish(true));
        }
      case PairingWrongCode():
        final attempts = ui.attempts + 1;
        if (attempts >= maxAttempts) {
          _timeout?.cancel();
          _closeSession();
          state = ui.copyWith(
            phase: PairingPhase.cooldown,
            attempts: attempts,
            cooldownUntil: DateTime.now().add(cooldown),
          );
        } else {
          state = ui.copyWith(phase: PairingPhase.wrongCode, attempts: attempts);
        }
      case PairingRejected():
        _timeout?.cancel();
        _closeSession();
        state = ui.copyWith(phase: PairingPhase.rejected);
      case SavedCredentialRejected():
        // TV was reset or forgot us: clear and pair from scratch.
        ref.read(credentialStoreProvider).delete(device.id);
        _start(useSaved: false);
      case PairingFailed(:final message):
        _timeout?.cancel();
        _closeSession();
        if (_waitingForUi && state == null && message == 'connection') {
          // The pairing port isn't reachable: treat as "no pairing needed"
          // rather than blocking the connection.
          _finish(true);
          return;
        }
        state = ui.copyWith(phase: message == 'timeout' ? PairingPhase.timeout : PairingPhase.failed);
    }
  }

  void _armTimeout() {
    _timeout?.cancel();
    _timeout = Timer(timeout, () {
      if (state == null) return;
      _closeSession();
      state = state!.copyWith(phase: PairingPhase.timeout);
    });
  }

  /// User typed a complete code.
  Future<void> submitCode(String code) async {
    final s = state;
    if (s == null || _session == null || s.phase == PairingPhase.verifying) return;
    state = s.copyWith(phase: PairingPhase.verifying);
    _armTimeout();
    await _session!.submitCode(code);
  }

  /// User started typing again after a wrong code.
  void clearError() {
    if (state?.phase == PairingPhase.wrongCode) state = state!.copyWith(phase: PairingPhase.enterCode);
  }

  /// "Try again" / "Request new code": restart pairing so the TV shows a new
  /// code or prompt. After a cooldown the attempt counter resets.
  Future<void> restart() async {
    final s = state;
    if (s == null || _device == null) return;
    if (s.phase == PairingPhase.cooldown && (s.cooldownUntil?.isAfter(DateTime.now()) ?? false)) return;
    state = PairingUi(
      device: s.device,
      phase: s.isCode ? PairingPhase.enterCode : PairingPhase.approval,
      codeLength: s.codeLength,
      hex: s.hex,
    );
    await _start(useSaved: false);
  }

  /// Cancel button, swipe-down or back: close the session cleanly.
  void cancel() => _finish(false);

  /// Removes the saved pairing for a device ("Forget device").
  Future<void> forget(String deviceId) => ref.read(credentialStoreProvider).delete(deviceId);

  void _finish(bool ok) {
    _timeout?.cancel();
    _closeSession();
    final r = _result;
    _result = null;
    _device = null;
    _protocol = null;
    state = null;
    if (r != null && !r.isCompleted) r.complete(ok);
  }

  void _closeSession() {
    _sub?.cancel();
    _sub = null;
    _session?.close();
    _session = null;
  }
}

final pairingProvider = NotifierProvider<PairingController, PairingUi?>(PairingController.new);
