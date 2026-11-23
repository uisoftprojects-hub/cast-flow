import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/domain/network_status.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/devices/presentation/network_controller.dart';
import 'package:castflow/features/history/presentation/history_controller.dart';
import 'package:castflow/features/player/data/media_caster.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/player/presentation/player_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class _Caster implements MediaCaster {
  final loads = <String>[];
  @override
  bool canCast(CastDevice d) => true;
  @override
  Future<void> load(CastDevice d, CastMedia m, {bool forceConvert = false, PrepareProgress? onPrepare}) async =>
      loads.add(m.id);
  @override
  Future<void> play(CastDevice d) async {}
  @override
  Future<void> pause(CastDevice d) async {}
  @override
  Future<void> seek(CastDevice d, Duration to) async {}
  @override
  Future<void> stop(CastDevice d) async {}
  @override
  Future<void> setVolume(CastDevice d, double level) async {}
  @override
  Future<CasterStatus?> status(CastDevice d) async => null;
  @override
  Future<void> endSession() async {}
}

const _tv = CastDevice(
  id: 'tv-1',
  name: 'Living room',
  type: DeviceType.dlna,
  address: '127.0.0.1',
  protocol: RemoteProtocol.dlna,
  location: 'http://127.0.0.1/desc.xml',
);

void main() {
  const wifi = NetworkStatus(wifi: true, wifiIp: '192.168.1.5');

  test('Wi-Fi drops mid-cast and comes back: the TV reconnects and the same cast carries on, no taps', () async {
    var net = wifi;
    final caster = _Caster();
    final c = await makeContainer(network: () => net, overrides: [mediaCasterProvider.overrideWithValue(caster)]);
    final subs = [
      c.listen(networkProvider, (_, _) {}),
      c.listen(connectionProvider, (_, _) {}),
      c.listen(playerProvider, (_, _) {}),
    ];
    await c.read(historyProvider.future);
    await c.read(networkProvider.notifier).refresh();
    await c.read(connectionProvider.notifier).connect(_tv);
    c.read(playerProvider.notifier).play([
      const CastMedia(id: 'a', title: 'A', kind: CastKind.video, seed: 1, url: '/x/a.mp4'),
      const CastMedia(id: 'b', title: 'B', kind: CastKind.video, seed: 2, url: '/x/b.mp4'),
    ], index: 1);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(caster.loads, ['b']);

    // Wi-Fi goes away.
    net = const NetworkStatus();
    await c.read(networkProvider.notifier).refresh();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(c.read(connectionProvider).error, ConnectionController.networkLost);
    expect(c.read(playerProvider).isActive, isFalse);

    // And returns.
    net = wifi;
    await c.read(networkProvider.notifier).refresh();
    // The (fake) TV takes a moment to answer, like a real one.
    for (var i = 0; i < 60 && !c.read(connectionProvider).isConnected; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(c.read(connectionProvider).isConnected, isTrue, reason: 'reconnected by itself');
    expect(c.read(playerProvider).isActive, isTrue, reason: 'the cast resumed');
    expect(c.read(playerProvider).index, 1);
    expect(caster.loads, ['b', 'b']);

    c.read(playerProvider.notifier).stop();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    for (final s in subs) {
      s.close();
    }
    c.dispose();
  });

  test('a different TV after the network comes back does not replay the old cast', () async {
    var net = wifi;
    final caster = _Caster();
    final c = await makeContainer(network: () => net, overrides: [mediaCasterProvider.overrideWithValue(caster)]);
    final subs = [
      c.listen(networkProvider, (_, _) {}),
      c.listen(connectionProvider, (_, _) {}),
      c.listen(playerProvider, (_, _) {}),
    ];
    await c.read(historyProvider.future);
    await c.read(networkProvider.notifier).refresh();
    await c.read(connectionProvider.notifier).connect(_tv);
    c.read(playerProvider.notifier).play([
      const CastMedia(id: 'a', title: 'A', kind: CastKind.video, seed: 1, url: '/x/a.mp4'),
    ]);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    net = const NetworkStatus();
    await c.read(networkProvider.notifier).refresh();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    // The user picks another TV before the old one is back.
    c.read(connectionProvider.notifier).clearFailure();
    net = wifi;
    await c.read(networkProvider.notifier).refresh();
    await c.read(connectionProvider.notifier).connect(const CastDevice(
        id: 'tv-2',
        name: 'Bedroom',
        type: DeviceType.dlna,
        address: '127.0.0.1',
        protocol: RemoteProtocol.dlna,
        location: 'http://127.0.0.1/desc.xml',
      ));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(c.read(playerProvider).isActive, isFalse);
    expect(caster.loads, ['a']);

    for (final s in subs) {
      s.close();
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    c.dispose();
  });

  test('device search that failed with no network restarts by itself when the network is back', () async {
    var net = const NetworkStatus();
    final c = await makeContainer(network: () => net);
    final sub = c.listen(discoveryProvider, (_, _) {});
    final sub2 = c.listen(networkProvider, (_, _) {});
    await c.read(networkProvider.notifier).refresh();
    await c.read(discoveryProvider.notifier).grantPermission();
    expect(c.read(discoveryProvider).networkRequired, isTrue);
    net = wifi;
    await c.read(networkProvider.notifier).refresh();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(c.read(discoveryProvider).networkRequired, isFalse);
    expect(c.read(discoveryProvider).scanning, isTrue);
    sub.close();
    sub2.close();
    c.dispose();
  });
}
