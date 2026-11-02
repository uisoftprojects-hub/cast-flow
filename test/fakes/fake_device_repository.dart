import 'dart:async';

import 'package:castflow/features/devices/domain/network_status.dart';
import 'package:castflow/core/app_providers.dart';
import 'package:castflow/features/devices/domain/cast_device.dart';

/// Pretends to discover devices on the LAN, one at a time, so the radar UI
/// can be reviewed before real mDNS / SSDP / Cast discovery is wired in.
class FakeDeviceRepository implements DeviceRepository {
  FakeDeviceRepository(this._mode);

  final PreviewMode Function() _mode;

  static const devices = [
    CastDevice(id: 'tv-1', name: 'Samsung TV', type: DeviceType.smartTv, address: '192.168.1.24', model: 'QLED Q80C', signal: 0.95),
    CastDevice(id: 'cc-1', name: 'Living Room', type: DeviceType.chromecast, address: '192.168.1.31', model: 'Chromecast with Google TV', signal: 0.8),
    CastDevice(id: 'fire-1', name: 'Bedroom Fire TV', type: DeviceType.fireTv, address: '192.168.1.40', model: 'Fire TV Stick 4K', signal: 0.62),
    CastDevice(id: 'roku-1', name: 'Roku Ultra', type: DeviceType.roku, address: '192.168.1.52', signal: 0.55),
    CastDevice(id: 'dlna-1', name: 'Kitchen Speaker', type: DeviceType.dlna, address: '192.168.1.60', model: 'DLNA MediaRenderer', signal: 0.4),
    CastDevice(id: 'mira-1', name: 'LG Display', type: DeviceType.miracast, address: 'Wi-Fi Direct', model: 'Miracast sink', signal: 0.7),
  ];

  @override
  int unidentifiedClients = 0;

  @override
  Stream<List<CastDevice>> discover({NetworkStatus? network}) async* {
    final mode = _mode();
    final found = <CastDevice>[];
    if (mode == PreviewMode.error) {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      throw const FakeServiceException('Local network permission denied or Wi-Fi is off.');
    }
    if (mode == PreviewMode.empty) {
      await Future<void>.delayed(const Duration(seconds: 4));
      yield const [];
      return;
    }
    for (final d in devices) {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      found.add(d);
      yield List.unmodifiable(found);
    }
  }

  @override
  Future<CastDevice?> findById(String id) async => devices.where((d) => d.id == id).firstOrNull;

  @override
  Future<void> connect(CastDevice device) async {
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (_mode() == PreviewMode.error) {
      throw FakeServiceException('${device.name} did not respond.');
    }
  }

  @override
  Future<void> disconnect() => Future<void>.delayed(const Duration(milliseconds: 300));
}
