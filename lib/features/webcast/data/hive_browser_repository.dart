import 'package:hive_ce/hive.dart';

import '../../../core/storage/local_store.dart';
import '../domain/web_models.dart';

class HiveBrowserRepository implements BrowserRepository {
  HiveBrowserRepository(this._bookmarks, this._history);

  final Box<Map> _bookmarks;
  final Box<Map> _history;

  static const maxHistory = 100;

  List<WebLink> _sorted(Box<Map> box) =>
      box.values.map(WebLink.fromMap).toList()..sort((a, b) => b.visitedAt!.compareTo(a.visitedAt!));

  @override
  List<WebLink> bookmarks() => _sorted(_bookmarks);

  @override
  List<WebLink> history() => _sorted(_history);

  @override
  Future<void> addBookmark(WebLink link) => _bookmarks.put(link.url, link.toMap());

  @override
  Future<void> removeBookmark(String url) => _bookmarks.delete(url);

  @override
  Future<void> addHistory(WebLink link) async {
    // Keyed by URL so revisiting moves the page to the top.
    await _history.put(link.url, link.toMap());
    await trimBox(_history, maxHistory, 'at');
  }

  @override
  Future<void> clearHistory() => _history.clear();

  @override
  Future<void> clearBookmarks() => _bookmarks.clear();
}
