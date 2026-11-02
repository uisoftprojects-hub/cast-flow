import 'dart:math';

import '../../../core/app_providers.dart';
import '../../settings/domain/app_settings.dart';
import '../domain/mirroring.dart';

class FakeMirroringService implements MirroringService {
  FakeMirroringService(this._mode);

  final PreviewMode Function() _mode;
  final _rnd = Random();

  @override
  Future<void> start({required String deviceId, required MirrorQuality quality, required bool audio}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (_mode() == PreviewMode.error) {
      throw const FakeServiceException('Screen capture permission was denied.');
    }
  }

  @override
  Future<void> stop() => Future<void>.delayed(const Duration(milliseconds: 400));

  @override
  Stream<int> latency() => Stream.periodic(const Duration(seconds: 2), (_) => 38 + _rnd.nextInt(70));
}
