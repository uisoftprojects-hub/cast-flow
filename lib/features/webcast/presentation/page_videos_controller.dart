import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/http_video_probe.dart';
import '../domain/video_rules.dart';
import '../domain/web_video.dart';

final videoProbeProvider = Provider<VideoProbe>((ref) => HttpVideoProbe());

@immutable
class PageVideos {
  const PageVideos({
    this.pageUrl,
    this.token = -1,
    this.title,
    this.image,
    this.all = const [],
    this.drm = false,
    this.promptShown = false,
  });

  final String? pageUrl;

  /// Native page token; reports carrying another token are stale.
  final int token;
  final String? title;

  /// og:image, used when a network-only video has no poster.
  final String? image;
  final List<WebVideo> all;

  /// The page asked for a DRM key system.
  final bool drm;

  /// The "Video found" prompt was shown (or dismissed) for this page.
  final bool promptShown;

  /// What the user sees: probed or DOM-confirmed, not filtered out,
  /// manifests first, then by quality.
  List<WebVideo> get videos {
    final list = all.where((v) => !v.hidden).map(_withFallbacks).toList();
    list.sort((a, b) {
      if (a.protected != b.protected) return a.protected ? 1 : -1;
      if (a.type.isManifest != b.type.isManifest) return a.type.isManifest ? -1 : 1;
      return (b.height ?? 0).compareTo(a.height ?? 0);
    });
    return list;
  }

  int get count => videos.length;

  WebVideo _withFallbacks(WebVideo v) => v.copyWith(
    title: (v.title?.trim().isNotEmpty ?? false) ? v.title : title,
    poster: v.poster ?? image,
    // A page using DRM: its manifests are protected even if the probe
    // couldn't see the key system.
    protected: v.protected || (drm && v.type.isManifest),
  );

  PageVideos copyWith({String? title, String? image, List<WebVideo>? all, bool? drm, bool? promptShown}) => PageVideos(
    pageUrl: pageUrl,
    token: token,
    title: title ?? this.title,
    image: image ?? this.image,
    all: all ?? this.all,
    drm: drm ?? this.drm,
    promptShown: promptShown ?? this.promptShown,
  );
}

/// Videos detected on the browser's current page, merged from network
/// interception and the injected DOM script. Cleared on every navigation.
class PageVideosController extends Notifier<PageVideos> {
  @override
  PageVideos build() => const PageVideos();

  VideoProbe get _probe => ref.read(videoProbeProvider);

  void navigated(String url, int token) => state = PageVideos(pageUrl: url, token: token);

  void setTitle(String title, int token) {
    if (token == state.token && title.trim().isNotEmpty && !title.startsWith('http')) {
      state = state.copyWith(title: title.trim());
    }
  }

  void markDrm(int token) {
    if (token == state.token && !state.drm) state = state.copyWith(drm: true);
  }

  void markPromptShown() {
    if (!state.promptShown) state = state.copyWith(promptShown: true);
  }

  /// A media request from shouldInterceptRequest. [probe] means the URL has
  /// no media extension and must be confirmed by its content type.
  void addResource(String url, Map<String, String> headers, int token, {bool probe = false}) {
    if (token != state.token || !isCandidateUrl(url)) return;
    final type = videoTypeFromUrl(url);
    if (type == null && !probe) return;
    final key = videoKey(url);
    if (state.all.any((v) => videoKey(v.url) == key)) return;
    // Placeholder until probed: hidden so half-checked links never show.
    final v = WebVideo(url: key, type: type ?? VideoType.mp4, headers: headers, hidden: true);
    state = state.copyWith(all: [...state.all, v]);
    unawaited(_check(key, token, mustBeVideo: type == null));
  }

  /// A <video>/<source> from the injected script.
  void addDom(Map<String, Object?> r, int token) {
    if (token != state.token) return;
    final url = r['url'] as String? ?? '';
    final poster = r['poster'] as String?;
    final image = r['image'] as String?;
    final seconds = (r['duration'] as num?)?.toDouble();
    final duration = seconds == null || seconds <= 0 ? null : Duration(milliseconds: (seconds * 1000).round());
    final height = (r['height'] as int?) ?? 0;
    final title = r['title'] as String?;
    if (image != null && state.image == null) state = state.copyWith(image: image);
    if (r['drm'] == true) markDrm(token);

    if (!isCandidateUrl(url)) {
      // blob: (MSE players). The real source is the manifest seen on the
      // network; lend it this element's poster / duration / title.
      if (url.startsWith('blob:')) _lendMetadata(poster: poster, duration: duration, height: height, title: title);
      return;
    }
    final key = videoKey(url);
    final i = state.all.indexWhere((v) => videoKey(v.url) == key);
    if (i >= 0) {
      final old = state.all[i];
      final merged = old.copyWith(
        poster: old.poster ?? poster,
        duration: duration ?? old.duration,
        height: height > 0 ? height : old.height,
        title: old.title ?? title,
      );
      _replace(
        i,
        merged.probed ? merged.copyWith(hidden: shouldHide(merged) || merged.mediaPlaylist && _hasMaster()) : merged,
      );
      return;
    }
    final v = WebVideo(
      url: key,
      type: videoTypeFromUrl(url) ?? VideoType.mp4,
      title: title,
      poster: poster,
      duration: duration,
      height: height > 0 ? height : null,
      headers: (r['headers'] as Map?)?.cast<String, String>() ?? const {},
      hidden: true,
    );
    state = state.copyWith(all: [...state.all, v]);
    unawaited(_check(key, token, mustBeVideo: false));
  }

  void _lendMetadata({String? poster, Duration? duration, int height = 0, String? title}) {
    final i = state.all.indexWhere((v) => v.type.isManifest && !v.hidden && !v.mediaPlaylist);
    if (i < 0) return;
    final v = state.all[i];
    _replace(
      i,
      v.copyWith(
        poster: v.poster ?? poster,
        duration: v.duration ?? duration,
        height: v.height ?? (height > 0 ? height : null),
        title: v.title ?? title,
      ),
    );
  }

  bool _hasMaster() => state.all.any((v) => v.probed && v.type.isManifest && !v.mediaPlaylist && !v.hidden);

  void _replace(int i, WebVideo v) {
    final all = [...state.all]..[i] = v;
    state = state.copyWith(all: all);
  }

  Future<void> _check(String key, int token, {required bool mustBeVideo}) async {
    final v = state.all.firstWhere((v) => v.url == key);
    final r = await _probe.probe(v.url, v.headers);
    if (!ref.mounted || token != state.token) return;
    final i = state.all.indexWhere((x) => x.url == key);
    if (i < 0) return;
    final current = state.all[i];
    // Range requests without an extension must turn out to be video/*.
    if (!r.ok ||
        r.type == null ||
        (mustBeVideo && videoTypeFromMime(r.mime) == null && videoTypeFromUrl(r.finalUrl) == null)) {
      _replace(i, current.copyWith(probed: true, hidden: true));
      return;
    }
    final finalUrl = r.finalUrl;
    if (finalUrl != current.url && state.all.any((x) => x.url == finalUrl || videoKey(x.url) == videoKey(finalUrl))) {
      _replace(i, current.copyWith(probed: true, hidden: true)); // redirect to one we already have
      return;
    }
    var probed = current.copyWith(
      url: finalUrl,
      type: r.type,
      size: r.length,
      height: current.height ?? r.height,
      duration: current.duration ?? r.duration,
      protected: current.protected || r.protected,
      mediaPlaylist: r.mediaPlaylist,
      probed: true,
    );
    probed = probed.copyWith(hidden: shouldHide(probed) || (probed.mediaPlaylist && _hasMaster()));
    _replace(i, probed);
    // A master playlist supersedes the variant playlists it points to.
    if (r.master && r.type == VideoType.hls) {
      final host = Uri.parse(finalUrl).host;
      state = state.copyWith(
        all: [
          for (final x in state.all)
            x.mediaPlaylist && Uri.tryParse(x.url)?.host == host ? x.copyWith(hidden: true) : x,
        ],
      );
    }
  }

  /// Makes sure [v] still plays before casting. Signed links expire: then
  /// the page is reloaded and the matching fresh video is used.
  Future<WebVideo?> ensureFresh(
    WebVideo v, {
    required Future<void> Function() reload,
    Duration wait = const Duration(seconds: 10),
  }) async {
    final r = await _probe.probe(v.url, v.headers);
    if (r.ok) return v.copyWith(url: r.finalUrl);
    if (!r.expired && r.status != 0) return v; // let the TV try; it reports its own error
    final before = state.token;
    await reload();
    final deadline = DateTime.now().add(wait);
    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!ref.mounted) return null;
      if (state.token == before) continue;
      final fresh = state.videos.where((x) => x.type == v.type && !x.protected).toList();
      if (fresh.isNotEmpty) {
        fresh.sort(
          (a, b) => ((a.height ?? 0) - (v.height ?? 0)).abs().compareTo(((b.height ?? 0) - (v.height ?? 0)).abs()),
        );
        return fresh.first;
      }
    }
    return null;
  }
}

final pageVideosProvider = NotifierProvider.autoDispose<PageVideosController, PageVideos>(PageVideosController.new);
