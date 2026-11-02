import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_providers.dart';
import '../../../core/storage/local_store.dart';
import '../data/hive_history_repository.dart';
import '../domain/history_entry.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HiveHistoryRepository(ref.watch(localStoreProvider).history, () => ref.read(previewModeProvider)),
);

class HistoryController extends AsyncNotifier<List<HistoryEntry>> {
  @override
  Future<List<HistoryEntry>> build() {
    ref.watch(previewModeProvider);
    return ref.read(historyRepositoryProvider).list();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(historyRepositoryProvider).list());
  }

  Future<void> add(HistoryEntry entry) async {
    final current = state.value;
    if (current != null) state = AsyncData([entry, ...current]);
    await ref.read(historyRepositoryProvider).add(entry);
  }

  /// Removes optimistically; returns the entry so it can be restored (undo).
  Future<HistoryEntry?> remove(String id) async {
    final current = state.value ?? const [];
    final entry = current.where((e) => e.id == id).firstOrNull;
    state = AsyncData(current.where((e) => e.id != id).toList());
    await ref.read(historyRepositoryProvider).remove(id);
    return entry;
  }

  Future<void> restore(HistoryEntry entry) async {
    await ref.read(historyRepositoryProvider).add(entry);
    final current = [...?state.value, entry]..sort((a, b) => b.castAt.compareTo(a.castAt));
    state = AsyncData(current);
  }

  Future<void> clear() async {
    await ref.read(historyRepositoryProvider).clear();
    state = const AsyncData([]);
  }
}

final historyProvider = AsyncNotifierProvider<HistoryController, List<HistoryEntry>>(HistoryController.new);
