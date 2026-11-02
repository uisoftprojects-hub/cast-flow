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

  @override
  Future<List<HistoryEntry>> list() => simulateFetch(
        _mode(),
        () => _box.values.map(HistoryEntry.fromMap).toList()..sort((a, b) => b.castAt.compareTo(a.castAt)),
        delay: const Duration(milliseconds: 250),
      );

  @override
  Future<void> add(HistoryEntry entry) async {
    await _box.put(entry.id, entry.toMap());
    await trimBox(_box, maxEntries, 'castAt');
  }

  @override
  Future<void> remove(String id) => _box.delete(id);

  @override
  Future<void> clear() => _box.clear();
}
