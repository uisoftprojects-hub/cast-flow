import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/navigation.dart';
import '../features/apps/presentation/apps_screen.dart';
import '../features/devices/presentation/connect_screen.dart';
import '../features/guide/presentation/guide_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/language/presentation/language_screen.dart';
import '../features/linkcast/presentation/link_cast_screen.dart';
import '../features/media/presentation/music_screen.dart';
import '../features/media/presentation/photos_screen.dart';
import '../features/media/presentation/videos_screen.dart';
import '../features/mirroring/presentation/mirroring_screen.dart';
import '../features/monetization/presentation/ad_diagnostics_screen.dart';
import '../features/monetization/presentation/ad_manager.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/player/presentation/now_playing_screen.dart';
import '../features/premium/presentation/paywall_screen.dart';
import '../features/remote/presentation/remote_screen.dart';
import '../features/settings/presentation/faq_screen.dart';
import '../features/settings/presentation/settings_controller.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/webcast/presentation/web_cast_screen.dart';
import 'shell.dart';

/// Soft fade + slight upward slide for pushed screens. The page is named
/// after its route so the ad observer can tell screens apart.
CustomTransitionPage<T> _soft<T>(GoRouterState state, String name, Widget child, {bool fromBottom = false}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    name: name,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: Offset(0, fromBottom ? 0.12 : 0.04), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}

GoRoute _page(String path, Widget Function(GoRouterState s) build, {bool fromBottom = false}) => GoRoute(
      path: path,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _soft(state, path, build(state), fromBottom: fromBottom),
    );

/// Startup-journey routes; everything else requires a completed first run.
const _flowRoutes = {'/splash', '/paywall', '/language', '/onboarding'};

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    observers: [ref.read(adRouteObserverProvider)],
    // Single route guard: deep links can't skip the first-run journey.
    redirect: (context, state) {
      final done = ref.read(settingsProvider).firstLaunchCompleted;
      if (!done && !_flowRoutes.contains(state.uri.path)) return '/splash';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      _page('/paywall', (s) => PaywallScreen(slot: s.uri.queryParameters['slot']), fromBottom: true),
      _page('/language', (_) => const LanguageScreen()),
      _page('/onboarding', (_) => const OnboardingScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/devices', builder: (_, _) => const ConnectScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/history', builder: (_, _) => const HistoryScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen())]),
        ],
      ),
      _page(
        '/connect',
        (s) => ConnectScreen(standalone: true, reason: s.uri.queryParameters['reason']),
        fromBottom: true,
      ),
      _page('/mirror', (_) => const MirroringScreen()),
      _page('/remote', (_) => const RemoteScreen()),
      _page('/photos', (_) => const PhotosScreen()),
      _page('/videos', (_) => const VideosScreen()),
      _page('/music', (_) => const MusicScreen()),
      _page('/player', (_) => const NowPlayingScreen(), fromBottom: true),
      _page('/web', (s) => WebCastScreen(initialUrl: s.uri.queryParameters['url'])),
      _page('/apps/facebook', (_) => const WebCastScreen(initialUrl: 'https://m.facebook.com/watch')),
      _page('/link', (_) => const LinkCastScreen()),
      _page('/apps', (_) => const AppsScreen()),
      _page('/premium', (_) => const PaywallScreen(), fromBottom: true),
      _page('/settings/language', (_) => const LanguageScreen(fromSettings: true)),
      _page('/faq', (_) => const FaqScreen()),
      _page('/guide', (_) => const GuideScreen()),
      _page('/ad-diagnostics', (_) => const AdDiagnosticsScreen()),
    ],
  );
});
