import '../../devices/domain/cast_device.dart';

/// What the TV asks for.
sealed class PairingStep {
  const PairingStep();
}

/// A code is shown on the TV; the user types it into the app.
class NeedsCode extends PairingStep {
  const NeedsCode({this.length = 6, this.hex = false});
  final int length;

  /// Android TV codes are hexadecimal (0-9, A-F).
  final bool hex;
}

/// The TV shows an Allow / Deny prompt; the app just waits.
class AwaitingApproval extends PairingStep {
  const AwaitingApproval();
}

/// Paired. [credential] is stored for next time (may be empty).
class PairingDone extends PairingStep {
  const PairingDone(this.credential);
  final String credential;
}

class PairingWrongCode extends PairingStep {
  const PairingWrongCode();
}

/// The user tapped Deny on the TV.
class PairingRejected extends PairingStep {
  const PairingRejected();
}

/// The saved credential no longer works (e.g. the TV was reset).
class SavedCredentialRejected extends PairingStep {
  const SavedCredentialRejected();
}

class PairingFailed extends PairingStep {
  const PairingFailed(this.message);
  final String message;
}

/// One live pairing attempt with a TV.
abstract interface class PairingSession {
  Stream<PairingStep> get steps;
  Future<void> submitCode(String code);
  Future<void> close();
}

/// Pairing for one receiver protocol.
abstract interface class PairingProtocol {
  bool handles(CastDevice device);

  /// Starts pairing. With a still-valid [saved] credential the first step is
  /// [PairingDone] and no UI is needed.
  PairingSession start(CastDevice device, {String? saved});
}

/// Stores pairing credentials securely, keyed by device ID.
abstract interface class CredentialStore {
  Future<String?> read(String deviceId);
  Future<void> write(String deviceId, String credential);
  Future<void> delete(String deviceId);
}
