import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

/// On-device structured storage (Hive CE). Values are plain maps so no
/// generated type adapters are needed.
class LocalStore {
  LocalStore({required this.history, required this.devices, required this.bookmarks, required this.webHistory});

  final Box<Map> history;
  final Box<Map> devices;
  final Box<Map> bookmarks;
  final Box<Map> webHistory;

  static const _names = ['history', 'devices', 'bookmarks', 'web_history'];

  /// Opens all boxes. Call `Hive.initFlutter()` (app) or `Hive.init(path)`
  /// (tests) first.
  static Future<LocalStore> open() async {
    final boxes = [for (final n in _names) await Hive.openBox<Map>(n)];
    return LocalStore(history: boxes[0], devices: boxes[1], bookmarks: boxes[2], webHistory: boxes[3]);
  }
}

/// Removes devices (and their history) saved by the old demo build, whose
/// fake receivers no longer exist. Safe to run on every launch.
Future<void> purgeDemoDevices(LocalStore store, {required String? lastDeviceId, required void Function() clearLastDevice}) async {
  const ids = {'tv-1', 'cc-1', 'fire-1', 'roku-1', 'dlna-1', 'mira-1'};
  const names = {'Samsung TV', 'Living Room', 'Bedroom Fire TV', 'Roku Ultra', 'Kitchen Speaker', 'LG Display'};
  await store.devices.deleteAll(store.devices.keys.where(ids.contains).toList());
  await store.history.deleteAll(
    store.history.toMap().entries.where((e) => names.contains(e.value['deviceName'])).map((e) => e.key).toList(),
  );
  if (lastDeviceId != null && ids.contains(lastDeviceId)) clearLastDevice();
}

/// Overridden in `main()` with the opened store.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden'),
);

/// Keeps a box to at most [max] entries, dropping the oldest by [timeKey].
Future<void> trimBox(Box<Map> box, int max, String timeKey) async {
  if (box.length <= max) return;
  final entries = box.toMap().entries.toList()
    ..sort((a, b) => (a.value[timeKey] as int).compareTo(b.value[timeKey] as int));
  await box.deleteAll(entries.take(box.length - max).map((e) => e.key));
}
