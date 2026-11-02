import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/domain/network_status.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/devices/presentation/network_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_device_repository.dart';
import 'helpers.dart';

void main() {
  test('network status: ready on Wi-Fi or own hotspot, Wi-Fi preferred', () {
    expect(const NetworkStatus().ready, isFalse);
    expect(const NetworkStatus(hotspot: true, hotspotIp: '192.168.43.1').mode, NetworkMode.hotspot);
    expect(const NetworkStatus(wifi: true, hotspot: true).mode, NetworkMode.wifi);
    expect(
      NetworkStatus.fromMap({'wifi': false, 'hotspot': true, 'hotspotIp': '192.168.43.1', 'hotspotInterface': 'ap0'}),
      const NetworkStatus(hotspot: true, hotspotIp: '192.168.43.1', hotspotInterface: 'ap0'),
    );
  });

  test('without Wi-Fi or hotspot, discovery asks for a network instead of scanning', () async {
    final c = await makeContainer(network: () => const NetworkStatus());
    c.listen(discoveryProvider, (_, _) {});
    await c.read(discoveryProvider.notifier).scan();
    final s = c.read(discoveryProvider);
    expect(s.networkRequired, isTrue);
    expect(s.scanning, isFalse);
  });

  test('on the hotspot, discovery keeps searching and the list updates live', () async {
    final c = await makeContainer(network: () => const NetworkStatus(hotspot: true, hotspotIp: '192.168.43.1'));
    c.listen(discoveryProvider, (_, _) {});
    await c.read(discoveryProvider.notifier).scan();
    await Future<void>.delayed(const Duration(seconds: 5));
    final s = c.read(discoveryProvider);
    expect(s.hotspot, isTrue);
    expect(s.scanning, isTrue, reason: 'hotspot discovery repeats');
    expect(s.devices.length, FakeDeviceRepository.devices.length);
  });

  test('losing the network mid-cast marks the connection as network-lost', () async {
    var net = const NetworkStatus(wifi: true);
    final c = await makeContainer(network: () => net);
    c.listen(connectionProvider, (_, _) {});
    c.listen(networkProvider, (_, _) {});
    expect(await c.read(connectionProvider.notifier).connect(FakeDeviceRepository.devices.first), isTrue);

    net = const NetworkStatus();
    await c.read(networkProvider.notifier).refresh();
    final conn = c.read(connectionProvider);
    expect(conn.status, ConnectionStatus.failed);
    expect(conn.error, ConnectionController.networkLost);
    expect(conn.device, FakeDeviceRepository.devices.first, reason: 'kept for one-tap reconnect');
  });
}
