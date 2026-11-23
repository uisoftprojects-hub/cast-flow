import 'package:hive_ce/hive.dart';

import '../../../core/app_providers.dart';
import '../../../core/storage/local_store.dart';
import '../domain/history_entry.dart';

/// Casting history kept on-device as a bounded list.
class HiveHistoryRepository implements HistoryRepository {
  HiveHistoryRepository(this._box, this._mode);

  final Box<Map> _box;
  final PreviewMode Function() _mode;

  static const maxEntries = 200;

  /// Hive string keys are limited to 255 chars; web-cast media ids are URLs and can exceed that.
  static String keyFor(String id) {
    if (id.length <= 200) return id;
    var h = 0x811c9dc5; // FNV-1a: stable across runs, unlike String.hashCode
    for (final c in id.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
    }
    return '${id.substring(0, 120)}-${h.toRadixString(16)}';
  }

  @override
  Future<List<HistoryEntry>> list() => simulateFetch(
    _mode(),
    () => _box.values.map(HistoryEntry.fromMap).toList()..sort((a, b) => b.castAt.compareTo(a.castAt)),
    delay: const Duration(milliseconds: 250),
  );

  @override
  Future<void> add(HistoryEntry entry) async {
    await _box.put(keyFor(entry.id), entry.toMap());
    await trimBox(_box, maxEntries, 'castAt');
  }

  @override
  Future<void> remove(String id) => _box.delete(keyFor(id));

  @override
  Future<void> clear() => _box.clear();
}
