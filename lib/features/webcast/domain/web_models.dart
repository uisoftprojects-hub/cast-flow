import 'package:flutter/foundation.dart';

@immutable
class WebLink {
  const WebLink({required this.title, required this.url, this.visitedAt});
  final String title;
  final String url;
  final DateTime? visitedAt;

  Map<String, Object> toMap() => {
    'title': title,
    'url': url,
    'at': (visitedAt ?? DateTime.now()).millisecondsSinceEpoch,
  };

  factory WebLink.fromMap(Map m) => WebLink(
    title: m['title'] as String,
    url: m['url'] as String,
    visitedAt: DateTime.fromMillisecondsSinceEpoch(m['at'] as int),
  );
}

/// Bookmarks and browsing history, stored on-device.
abstract interface class BrowserRepository {
  List<WebLink> bookmarks();
  List<WebLink> history();
  Future<void> addBookmark(WebLink link);
  Future<void> removeBookmark(String url);
  Future<void> addHistory(WebLink link);
  Future<void> clearHistory();
  Future<void> clearBookmarks();
}

@immutable
class DetectedMedia {
  const DetectedMedia({
    required this.title,
    required this.url,
    required this.format,
    required this.quality,
    required this.duration,
    required this.seed,
  });

  final String title;
  final String url;
  final String format;
  final String quality;
  final Duration duration;
  final int seed;
}

/// In production this injects a script into the WebView that reports
/// <video> sources and HLS/DASH manifests found on the page.
abstract interface class MediaDetector {
  Future<List<DetectedMedia>> load(String url);
}

/// Normalizes user input into a URL or a search URL.
String normalizeUrl(String input) {
  final t = input.trim();
  if (t.isEmpty) return t;
  if (t.startsWith('http://') || t.startsWith('https://')) return t;
  if (t.contains('.') && !t.contains(' ')) return 'https://$t';
  return 'https://www.google.com/search?q=${Uri.encodeQueryComponent(t)}';
}

String hostOf(String url) => Uri.tryParse(url)?.host.replaceFirst('www.', '') ?? url;
