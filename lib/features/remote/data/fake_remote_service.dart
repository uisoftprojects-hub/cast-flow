import '../../../core/app_providers.dart';
import '../../devices/domain/cast_device.dart';
import '../../devices/domain/receiver_capabilities.dart';
import '../domain/remote_service.dart';

class FakeRemoteService implements RemoteService {
  FakeRemoteService(this._mode);

  final PreviewMode Function() _mode;

  @override
  Future<void> send(CastDevice device, RemoteCommand command) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    if (_mode() == PreviewMode.error) throw FakeServiceException('${device.name} didn’t respond.');
    if (!device.supports(command)) throw UnsupportedError('${command.label} isn’t supported by ${device.type.label}.');
  }
}
