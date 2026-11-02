import 'package:castflow/core/app_providers.dart';
import 'fakes/fake_device_repository.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/history/domain/history_entry.dart';
import 'package:castflow/features/history/presentation/history_controller.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/player/presentation/player_controller.dart';
import 'package:castflow/features/settings/presentation/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

const _song = CastMedia(id: 's', title: 'Song', kind: CastKind.music, seed: 1, duration: Duration(seconds: 30));
const _song2 = CastMedia(id: 's2', title: 'Song 2', kind: CastKind.music, seed: 2, duration: Duration(seconds: 30));

HistoryEntry _entry(String id, int minutesAgo) => HistoryEntry(
      id: id,
      title: 'Item $id',
      kind: CastKind.video,
      deviceName: 'TV',
      castAt: DateTime.now().subtract(Duration(minutes: minutesAgo)),
      seed: 1,
    );

void main() {
  test('connecting saves the device and auto-connect restores it', () async {
    final c = await makeContainer();
    final device = FakeDeviceRepository.devices.first;

    final ok = await c.read(connectionProvider.notifier).connect(device);
    expect(c.read(connectionProvider).error, isNull);
    expect(ok, isTrue);
    expect(c.read(settingsProvider).lastDeviceId, device.id);
    expect(c.read(savedDevicesProvider).findById(device.id)?.lastSeen, isNotNull);

    await c.read(connectionProvider.notifier).disconnect();
    expect(c.read(connectionProvider).isConnected, isFalse);

    await c.read(connectionProvider.notifier).autoConnect();
    expect(c.read(connectionProvider).device, device);
  });

  test('connect fails in error preview mode', () async {
    final c = await makeContainer();
    c.read(previewModeProvider.notifier).set(PreviewMode.error);
    final ok = await c.read(connectionProvider.notifier).connect(FakeDeviceRepository.devices.first);
    expect(ok, isFalse);
    expect(c.read(connectionProvider).error, isNotNull);
  });

  test('player seeks within bounds, skips tracks and stops on disconnect', () async {
    final c = await makeContainer();
    await c.read(connectionProvider.notifier).connect(FakeDeviceRepository.devices.first);
    await c.read(historyProvider.future);

    final player = c.read(playerProvider.notifier);
    player.play([_song, _song2]);
    expect(c.read(playerProvider).media, _song);

    player.skip(-10);
    expect(c.read(playerProvider).position, Duration.zero);
    player.skip(100);
    expect(c.read(playerProvider).position, const Duration(seconds: 30));

    player.next();
    expect(c.read(playerProvider).media, _song2);

    // Casting is recorded in history.
    expect(c.read(historyProvider).value!.first.title, 'Song');

    await c.read(connectionProvider.notifier).disconnect();
    expect(c.read(playerProvider).isActive, isFalse);
  });

  test('history remove and restore keep order', () async {
    final c = await makeContainer();
    final repo = c.read(historyRepositoryProvider);
    for (final e in [_entry('a', 1), _entry('b', 5), _entry('c', 9)]) {
      await repo.add(e);
    }
    final items = await c.read(historyProvider.future);
    expect(items.map((e) => e.id), ['a', 'b', 'c']);

    final ctrl = c.read(historyProvider.notifier);
    final removed = await ctrl.remove('b');
    expect(c.read(historyProvider).value!.length, 2);

    await ctrl.restore(removed!);
    expect(c.read(historyProvider).value!.map((e) => e.id), ['a', 'b', 'c']);
  });

  test('discovery finds every fake device without blocking', () async {
    final c = await makeContainer();
    final sub = c.listen(discoveryProvider, (_, _) {});
    c.read(discoveryProvider.notifier).scan();
    expect(c.read(discoveryProvider).scanning, isTrue);
    await Future<void>.delayed(const Duration(seconds: 5));
    expect(c.read(discoveryProvider).scanning, isFalse);
    expect(c.read(discoveryProvider).devices.length, FakeDeviceRepository.devices.length);
    sub.close();
  });
}
