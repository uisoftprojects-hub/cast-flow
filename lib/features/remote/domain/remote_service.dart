import '../../devices/domain/cast_device.dart';
import '../../devices/domain/receiver_capabilities.dart';

/// Sends key / media / volume commands to the connected receiver
/// (Roku ECP, Cast media session, DLNA AVTransport, smart-TV APIs…).
abstract interface class RemoteService {
  Future<void> send(CastDevice device, RemoteCommand command);
}

/// The TV needs pairing before it accepts keys and this app has no credential
/// for it (pairing was skipped, failed, or the TV forgot this phone).
class NotPairedException implements Exception {
  const NotPairedException(this.deviceName);
  final String deviceName;

  @override
  String toString() => '$deviceName needs to be paired before the remote works.';
}
