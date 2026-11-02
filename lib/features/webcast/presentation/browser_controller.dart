import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../data/hive_browser_repository.dart';
import '../domain/web_models.dart';

final browserRepositoryProvider = Provider<BrowserRepository>((ref) {
  final store = ref.watch(localStoreProvider);
  return HiveBrowserRepository(store.bookmarks, store.webHistory);
});

@immutable
class BrowserData {
  const BrowserData({this.bookmarks = const [], this.history = const []});
  final List<WebLink> bookmarks;
  final List<WebLink> history;
}

class BrowserController extends Notifier<BrowserData> {
  BrowserRepository get _repo => ref.read(browserRepositoryProvider);

  @override
  BrowserData build() {
    final repo = ref.watch(browserRepositoryProvider);
    return BrowserData(bookmarks: repo.bookmarks(), history: repo.history());
  }

  void _reload() => state = BrowserData(bookmarks: _repo.bookmarks(), history: _repo.history());

  bool isBookmarked(String url) => state.bookmarks.any((b) => b.url == url);

  Future<void> toggleBookmark(WebLink link) async {
    isBookmarked(link.url) ? await _repo.removeBookmark(link.url) : await _repo.addBookmark(link);
    _reload();
  }

  Future<void> removeBookmark(String url) async {
    await _repo.removeBookmark(url);
    _reload();
  }

  Future<void> visit(WebLink link) async {
    await _repo.addHistory(link);
    _reload();
  }

  Future<void> clearHistory() async {
    await _repo.clearHistory();
    _reload();
  }

  Future<void> clearBookmarks() async {
    await _repo.clearBookmarks();
    _reload();
  }
}

final browserProvider = NotifierProvider<BrowserController, BrowserData>(BrowserController.new);
