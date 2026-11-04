import 'package:hive_ce/hive.dart';

import '../domain/cast_device.dart';

class HiveSavedDevicesRepository implements SavedDevicesRepository {
  HiveSavedDevicesRepository(this._box);

  final Box<Map> _box;

  @override
  List<CastDevice> all() =>
      _box.values.map(CastDevice.fromMap).toList()
        ..sort((a, b) => (b.lastSeen ?? DateTime(0)).compareTo(a.lastSeen ?? DateTime(0)));

  @override
  CastDevice? findById(String id) {
    final m = _box.get(id);
    return m == null ? null : CastDevice.fromMap(m);
  }

  @override
  Future<void> save(CastDevice device) => _box.put(device.id, device.toMap());

  @override
  Future<void> delete(String id) => _box.delete(id);
}
