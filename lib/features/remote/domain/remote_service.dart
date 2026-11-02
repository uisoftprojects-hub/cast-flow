import '../../devices/domain/cast_device.dart';
import '../../devices/domain/receiver_capabilities.dart';

/// Sends key / media / volume commands to the connected receiver
/// (Roku ECP, Cast media session, DLNA AVTransport, smart-TV APIs…).
abstract interface class RemoteService {
  Future<void> send(CastDevice device, RemoteCommand command);
}
