import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../player/domain/cast_media.dart';
import '../../player/presentation/player_controller.dart';
import '../../../core/l10n.dart';
import '../../devices/presentation/device_providers.dart';
import '../data/cast_web_view.dart';
import '../data/mock_media_detector.dart';
import '../domain/video_rules.dart';
import '../domain/web_models.dart';
import '../domain/web_video.dart';
import 'browser_cast_widgets.dart';
import 'browser_controller.dart';
import 'page_videos_controller.dart';

final mediaDetectorProvider = Provider<MediaDetector>((ref) => MockMediaDetector(() => ref.read(previewModeProvider)));

IconData siteIcon(String host) {
  if (host.contains('youtube')) return Iconsax.youtube_copy;
  if (host.contains('google')) return Iconsax.google_copy;
  if (host.contains('facebook')) return Iconsax.facebook_copy;
  if (host.contains('instagram')) return Iconsax.instagram_copy;
  if (host.contains('twitch')) return Iconsax.twitch_copy;
  if (host.contains('vimeo')) return Iconsax.video_circle_copy;
  if (host.contains('dailymotion')) return Iconsax.video_square_copy;
  return Iconsax.global_copy;
}

Color siteColor(String host) {
  if (host.contains('youtube')) return const Color(0xFFE62117);
  if (host.contains('google')) return const Color(0xFF4285F4);
  if (host.contains('facebook')) return const Color(0xFF1877F2);
  if (host.contains('instagram')) return const Color(0xFFE1306C);
  if (host.contains('twitch')) return const Color(0xFF9146FF);
  if (host.contains('vimeo')) return const Color(0xFF1AB7EA);
  if (host.contains('dailymotion')) return const Color(0xFF0066DC);
  return AppColors.primary;
}

/// Built-in browser with video detection. The page body is simulated until
/// webview_flutter / flutter_inappwebview is wired in.
class WebCastScreen extends ConsumerStatefulWidget {
  const WebCastScreen({super.key, this.initialUrl});

  final String? initialUrl;

  @override
  ConsumerState<WebCastScreen> createState() => _WebCastScreenState();
}

class _WebCastScreenState extends ConsumerState<WebCastScreen> implements CastWebListener {
  final _input = TextEditingController();
  final _focus = FocusNode();
  late final _web = CastWebController(this);
  String? _url;
  AsyncValue<List<DetectedMedia>> _page = const AsyncData([]);

  // Native browser state.
  int _progress = 100;
  bool _canBack = false;
  bool _canForward = false;
  bool _banner = false;
  bool _preparing = false;
  Timer? _bannerTimer;
  WebVideo? _casting;

  bool get _native => CastWebView.supported;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) _open(widget.initialUrl!);
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _open(String raw) async {
    final url = normalizeUrl(raw);
    if (url.isEmpty) return;
    _focus.unfocus();
    final hadPage = _url != null;
    setState(() {
      _url = url;
      _input.text = url;
      _page = _native ? const AsyncData([]) : const AsyncLoading();
    });
    ref.read(browserProvider.notifier).visit(WebLink(title: hostOf(url), url: url, visitedAt: DateTime.now()));
    if (_native) {
      // A new view loads its initial URL itself.
      if (hadPage) await _web.loadUrl(url);
      return;
    }
    final result = await AsyncValue.guard(() => ref.read(mediaDetectorProvider).load(url));
    if (mounted && _url == url) setState(() => _page = result);
  }

  void _home() => setState(() {
    _url = null;
    _input.clear();
    _page = const AsyncData([]);
    _banner = false;
    _canBack = _canForward = false;
    ref.read(pageVideosProvider.notifier).navigated('', -1);
  });

  void _reload() => _native ? _web.reload() : _open(_url!);

  // ---- CastWebListener ----

  @override
  void onNavigated(String url, int token, {required bool canGoBack, required bool canGoForward}) {
    if (!mounted) return;
    ref.read(pageVideosProvider.notifier).navigated(url, token);
    _bannerTimer?.cancel();
    setState(() {
      _url = url;
      if (!_focus.hasFocus) _input.text = url;
      _canBack = canGoBack;
      _canForward = canGoForward;
      _banner = false;
    });
  }

  @override
  void onHistory({required bool canGoBack, required bool canGoForward}) {
    if (!mounted) return;
    setState(() {
      _canBack = canGoBack;
      _canForward = canGoForward;
    });
  }

  @override
  void onProgress(int value) {
    if (mounted && value != _progress) setState(() => _progress = value);
  }

  @override
  void onTitle(String title, int token) {
    if (mounted) ref.read(pageVideosProvider.notifier).setTitle(title, token);
  }

  @override
  void onFinished(String url, String title, int token) {
    if (!mounted) return;
    ref.read(pageVideosProvider.notifier).setTitle(title, token);
    if (title.isNotEmpty) {
      ref.read(browserProvider.notifier).visit(WebLink(title: title, url: url, visitedAt: DateTime.now()));
    }
  }

  @override
  void onResource(String url, Map<String, String> headers, int token, {required bool probe}) {
    if (mounted) ref.read(pageVideosProvider.notifier).addResource(url, headers, token, probe: probe);
  }

  @override
  void onDom(Map<String, Object?> report, int token) {
    if (mounted) ref.read(pageVideosProvider.notifier).addDom(report, token);
  }

  @override
  void onDrm(int token) {
    if (mounted) ref.read(pageVideosProvider.notifier).markDrm(token);
  }

  // ---- Casting ----

  /// First video on a page: show the "Video found" prompt once.
  void _onVideos(PageVideos? prev, PageVideos next) {
    if (next.count == 0 || next.promptShown || _url == null) return;
    ref.read(analyticsProvider).log(AnalyticsEvent.browserVideoFound, {
      AnalyticsParam.videoCount: next.count,
      AnalyticsParam.host: Uri.tryParse(_url!)?.host,
    });
    ref.read(pageVideosProvider.notifier).markPromptShown();
    setState(() => _banner = true);
    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) setState(() => _banner = false);
    });
  }

  void _dismissBanner() {
    _bannerTimer?.cancel();
    setState(() => _banner = false);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  Future<void> _onCastTap() async {
    _dismissBanner();
    final videos = ref.read(pageVideosProvider).videos;
    if (videos.isEmpty) return _snack(context.l10n.noVideoYet);
    final picked = await showVideosSheet(context, videos);
    if (picked != null && mounted) await _castVideo(picked);
  }

  Future<void> _castVideo(WebVideo v) async {
    final l = context.l10n;
    final analytics = ref.read(analyticsProvider);
    final host = Uri.tryParse(_url ?? v.url)?.host;
    analytics.log(AnalyticsEvent.browserCastTap, {
      AnalyticsParam.videoType: v.type,
      AnalyticsParam.quality: v.quality,
      AnalyticsParam.host: host,
    });
    if (v.protected) {
      return _snack(l.protectedVideo);
    }
    if (_preparing) return;
    // Network check → device list → pairing (when the TV asks for it).
    if (!await ensureConnected(context, ref)) return;
    if (!mounted) return;
    final device = ref.read(connectionProvider).device!;
    if (!deviceSupports(device, v.type)) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.formatUnsupportedTitle),
          content: Text(l.formatUnsupported(device.name, v.type.label)),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.ok))],
        ),
      );
      return;
    }
    setState(() => _preparing = true);
    _snack(l.refreshingVideo);
    final fresh = await ref.read(pageVideosProvider.notifier).ensureFresh(v, reload: _web.reload);
    if (!mounted) return;
    setState(() => _preparing = false);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (fresh == null) return _snack(l.videoExpired);
    ref.read(playerProvider.notifier).play([
      CastMedia(
        id: fresh.url,
        title: fresh.title ?? hostOf(_url ?? fresh.url),
        subtitle: [hostOf(_url ?? fresh.url), fresh.type.label, ?fresh.quality].join(' · '),
        kind: _url != null && hostOf(_url!).contains('youtube') ? CastKind.youtube : CastKind.web,
        seed: fresh.url.hashCode,
        duration: fresh.duration ?? Duration.zero,
        url: fresh.url,
        headers: fresh.headers,
        thumbnail: fresh.poster,
      ),
    ]);
    setState(() => _casting = fresh);
    // The TV plays it now; don't play it twice.
    await _web.pauseVideos();
    // Open the full preview, not just the mini bar.
    if (mounted) context.push('/player');
  }

  bool get _bookmarked => _url != null && ref.watch(browserProvider).bookmarks.any((b) => b.url == _url);

  void _toggleBookmark() => ref
      .read(browserProvider.notifier)
      .toggleBookmark(WebLink(title: hostOf(_url!), url: _url!, visitedAt: DateTime.now()));

  Future<void> _cast(DetectedMedia m) async {
    final media = CastMedia(
      id: m.url,
      title: m.title,
      subtitle: '${hostOf(_url ?? m.url)} · ${m.quality}',
      kind: _url != null && hostOf(_url!).contains('youtube') ? CastKind.youtube : CastKind.web,
      seed: m.seed,
      duration: m.duration,
      url: m.url,
    );
    await castAndOpenRemote(context, ref, [media]);
  }

  Future<void> _showDetected(List<DetectedMedia> items) async {
    final picked = await showModalBottomSheet<DetectedMedia>(
      context: context,
      useSafeArea: true,
      builder: (_) => SafeArea(top: false, child: _DetectedSheet(items: items)),
    );
    if (picked != null && mounted) await _cast(picked);
  }

  /// Real page in the native WebView, with the "Video found" prompt and the
  /// casting bar floating above it.
  Widget _nativePage(PageVideos videos) {
    final casting = ref.watch(playerProvider.select((s) => s.isActive));
    return Stack(
      children: [
        Positioned.fill(
          child: CastWebView(controller: _web, initialUrl: _url!),
        ),
        PositionedDirectional(
          start: AppSpace.md,
          end: AppSpace.md,
          bottom: AppSpace.md,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_banner && !casting && videos.count > 0)
                VideoFoundBanner(
                  onCast: () {
                    _dismissBanner();
                    final list = ref.read(pageVideosProvider).videos;
                    list.length == 1 ? _castVideo(list.first) : _onCastTap();
                  },
                  onDismiss: _dismissBanner,
                ),
              if (casting) BrowserCastBar(poster: _casting),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final detected = _page.value ?? const <DetectedMedia>[];
    final videos = ref.watch(pageVideosProvider);
    ref.listen(pageVideosProvider, _onVideos);
    final native = _native && _url != null;
    return PopScope(
      // Back walks the page history first; once there is none it always goes to
      // the previous screen (or Home), and never closes the app.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (native && _canBack) {
          _web.back();
        } else if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      },
      child: Scaffold(
        appBar: CastAppBar(title: context.l10n.webCast),
        bottomNavigationBar: native
            ? BrowserBottomBar(
                count: videos.count,
                onBack: _canBack ? _web.back : null,
                onForward: _canForward ? _web.forward : null,
                onCast: _onCastTap,
                onStartPage: _home,
              )
            : null,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.page, 0, AppSpace.page, AppSpace.sm),
              child: _UrlBar(
                controller: _input,
                focusNode: _focus,
                onSubmit: _open,
                onHome: _url == null ? null : _home,
                onReload: _url == null ? null : _reload,
                bookmarked: _bookmarked,
                onBookmark: _url == null ? null : _toggleBookmark,
              ),
            ),
            AnimatedSwitcher(
              duration: AppDurations.fast,
              child: _page.isLoading || (native && _progress < 100) || _preparing
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpace.page),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        child: LinearProgressIndicator(
                          minHeight: 3,
                          value: native && !_preparing && _progress > 0 ? _progress / 100 : null,
                        ),
                      ),
                    )
                  : const SizedBox(height: 3),
            ),
            Expanded(
              child: _url == null
                  ? _StartPage(
                      bookmarks: ref.watch(browserProvider).bookmarks,
                      history: ref.watch(browserProvider).history,
                      onOpen: _open,
                      onRemoveBookmark: (b) => ref.read(browserProvider.notifier).removeBookmark(b.url),
                    )
                  : native
                  ? _nativePage(videos)
                  : Stack(
                      children: [
                        _page.when(
                          skipLoadingOnRefresh: false,
                          loading: () => const _PageSkeleton(),
                          error: (e, _) => ErrorState(message: e.toString(), onRetry: () => _open(_url!)),
                          data: (_) => _SimulatedPage(url: _url!, detected: detected, onCast: _cast),
                        ),
                        if (_page.hasValue && !_page.isLoading)
                          PositionedDirectional(
                            bottom: AppSpace.xxl,
                            start: 0,
                            end: 0,
                            child: SafeArea(
                              top: false,
                              child: Center(
                                child: detected.isNotEmpty
                                    ? GradientButton(
                                            label: context.l10n.castThisVideo,
                                            icon: Iconsax.screenmirroring_copy,
                                            onPressed: () =>
                                                detected.length == 1 ? _cast(detected.first) : _showDetected(detected),
                                          )
                                          .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                                          .scale(
                                            begin: const Offset(1, 1),
                                            end: const Offset(1.04, 1.04),
                                            duration: 1200.ms,
                                          )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: context.palette.surface,
                                          borderRadius: BorderRadius.circular(AppRadius.pill),
                                          boxShadow: AppShadows.soft(context.palette),
                                        ),
                                        child: Text(
                                          context.l10n.noVideoYet,
                                          style: context.text.labelMedium?.copyWith(
                                            color: context.palette.textSecondary,
                                          ),
                                        ),
                                      ),
                              ).animate().fadeIn().slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrlBar extends StatelessWidget {
  const _UrlBar({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
    required this.onHome,
    required this.onReload,
    required this.bookmarked,
    required this.onBookmark,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onHome;
  final VoidCallback? onReload;
  final bool bookmarked;
  final VoidCallback? onBookmark;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppShadows.soft(p),
      ),
      child: Row(
        children: [
          if (onHome != null)
            IconButton(
              tooltip: context.l10n.browserStartPage,
              onPressed: onHome,
              icon: Icon(Iconsax.home_2_copy, color: p.textSecondary, size: 20),
            )
          else
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
              child: Icon(Iconsax.search_normal_1_copy, color: p.textSecondary, size: 20),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              autocorrect: false,
              onSubmitted: onSubmit,
              style: context.text.bodyLarge,
              decoration: InputDecoration(
                hintText: context.l10n.searchOrTypeAWeb,
                filled: false,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              ),
            ),
          ),
          if (onBookmark != null)
            IconButton(
              tooltip: bookmarked ? context.l10n.removeBookmark : context.l10n.bookmark,
              onPressed: onBookmark,
              icon: Icon(
                bookmarked ? Icons.bookmark_rounded : Iconsax.bookmark_copy,
                color: bookmarked ? p.primary : p.textSecondary,
                size: 20,
              ),
            ),
          if (onReload != null)
            IconButton(
              tooltip: context.l10n.browserReload,
              onPressed: onReload,
              icon: Icon(Iconsax.refresh_copy, color: p.textSecondary, size: 20),
            ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _StartPage extends StatelessWidget {
  const _StartPage({
    required this.bookmarks,
    required this.history,
    required this.onOpen,
    required this.onRemoveBookmark,
  });
  final List<WebLink> bookmarks;
  final List<WebLink> history;
  final ValueChanged<String> onOpen;
  final ValueChanged<WebLink> onRemoveBookmark;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.lg, AppSpace.page, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(context.l10n.quickAccess),
                  Wrap(
                    spacing: AppSpace.md,
                    runSpacing: AppSpace.lg,
                    children: [
                      for (final (i, s) in quickSites.indexed)
                        SizedBox(
                          width: 72,
                          child: TapScale(
                            onTap: () => onOpen(s.url),
                            semanticLabel: context.l10n.open2(s.title),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: p.surface,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    boxShadow: AppShadows.soft(p),
                                  ),
                                  child: Icon(siteIcon(hostOf(s.url)), color: siteColor(hostOf(s.url)), size: 28),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  s.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.text.labelSmall?.copyWith(color: p.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ).animate(delay: (40 * i).ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                    ],
                  ),
                  const SizedBox(height: AppSpace.xxl),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: p.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      boxShadow: AppShadows.soft(p),
                    ),
                    child: TabBar(
                      tabs: [
                        Tab(text: context.l10n.bookmarks, height: 40),
                        Tab(text: context.l10n.history, height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            bookmarks.isEmpty
                ? EmptyState(
                    icon: Iconsax.bookmark_copy,
                    title: context.l10n.noBookmarks,
                    message: context.l10n.tapTheBookmarkIcon,
                  )
                : _LinkList(links: bookmarks, onOpen: onOpen, onRemove: onRemoveBookmark),
            history.isEmpty
                ? EmptyState(
                    icon: Iconsax.clock_copy,
                    title: context.l10n.noHistory,
                    message: context.l10n.pagesYouVisitShow,
                  )
                : _LinkList(links: history, onOpen: onOpen),
          ],
        ),
      ),
    );
  }
}

class _LinkList extends StatelessWidget {
  const _LinkList({required this.links, required this.onOpen, this.onRemove});
  final List<WebLink> links;
  final ValueChanged<String> onOpen;
  final ValueChanged<WebLink>? onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.lg, AppSpace.page, AppSpace.xxxl),
      itemCount: links.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpace.sm),
      itemBuilder: (context, i) {
        final l = links[i];
        final host = hostOf(l.url);
        return SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
          onTap: () => onOpen(l.url),
          semanticLabel: context.l10n.open2(l.title),
          child: Row(
            children: [
              IconBubble(icon: siteIcon(host), color: siteColor(host), size: 42),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.titleSmall),
                    Text(
                      l.visitedAt != null ? '$host · ${formatTime(l.visitedAt!)}' : host,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              if (onRemove != null)
                IconButton(
                  tooltip: context.l10n.remove,
                  onPressed: () => onRemove!(l),
                  icon: Icon(Iconsax.trash_copy, size: 18, color: context.palette.textSecondary),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PageSkeleton extends StatelessWidget {
  const _PageSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpace.page),
        children: const [
          ShimmerBox(height: 200, radius: AppRadius.lg),
          SizedBox(height: AppSpace.lg),
          ShimmerBox(height: 18, width: 240),
          SizedBox(height: AppSpace.sm),
          ShimmerBox(height: 14),
          SizedBox(height: AppSpace.sm),
          ShimmerBox(height: 14, width: 180),
          SizedBox(height: AppSpace.xxl),
          ShimmerBox(height: 120, radius: AppRadius.lg),
        ],
      ),
    );
  }
}

/// Stand-in page content until a real WebView is embedded.
class _SimulatedPage extends StatelessWidget {
  const _SimulatedPage({required this.url, required this.detected, required this.onCast});
  final String url;
  final List<DetectedMedia> detected;
  final ValueChanged<DetectedMedia> onCast;

  @override
  Widget build(BuildContext context) {
    final host = hostOf(url);
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.md, AppSpace.page, 120),
      children: [
        Row(
          children: [
            IconBubble(icon: siteIcon(host), color: siteColor(host), size: 36),
            const SizedBox(width: AppSpace.sm),
            Expanded(child: Text(host, style: context.text.titleSmall)),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        if (detected.isNotEmpty)
          for (final m in detected) ...[
            TapScale(
              onTap: () => onCast(m),
              semanticLabel: context.l10n.cast(m.title),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: MediaArt(
                  seed: m.seed,
                  radius: AppRadius.lg,
                  icon: Iconsax.play_circle_copy,
                  iconSize: 52,
                  child: PositionedDirectional(
                    top: 10,
                    start: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        '${m.format} · ${m.quality}',
                        style: context.text.labelSmall?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(m.title, style: context.text.titleMedium),
            Text('${formatDuration(m.duration)} · ${m.format}', style: context.text.bodySmall),
            const SizedBox(height: AppSpace.xl),
          ]
        else ...[
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.md),
              child: SoftCard(
                child: Row(
                  children: [
                    SizedBox.square(
                      dimension: 56,
                      child: MediaArt(seed: host.hashCode + i, radius: AppRadius.sm),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.resultOn(i + 1, host), style: context.text.titleSmall),
                          Text(context.l10n.aSimulatedPageResult, style: context.text.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _DetectedSheet extends StatelessWidget {
  const _DetectedSheet({required this.items});
  final List<DetectedMedia> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.videosOnThisPage, style: context.text.headlineMedium),
          const SizedBox(height: 4),
          Text(context.l10n.pickOneToSend, style: context.text.bodyMedium),
          const SizedBox(height: AppSpace.xl),
          for (final m in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.md),
              child: SoftCard(
                padding: const EdgeInsets.all(AppSpace.sm),
                child: Row(
                  children: [
                    SizedBox(
                      width: 96,
                      height: 60,
                      child: MediaArt(seed: m.seed, icon: Iconsax.play_copy, iconSize: 20, radius: AppRadius.sm),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.titleSmall),
                          Text(
                            '${m.format} · ${m.quality} · ${formatDuration(m.duration)}',
                            style: context.text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    GradientButton(
                      label: context.l10n.castAction,
                      compact: true,
                      onPressed: () => Navigator.of(context).pop(m),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
