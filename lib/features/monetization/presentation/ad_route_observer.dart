import 'package:flutter/widgets.dart';

/// Watches the root navigator for two things AdManager needs: eligible
/// "clicks" (opening a content screen) and whether a full-screen ad may be
/// shown over the current top route.
class AdRouteObserver extends NavigatorObserver {
  /// Opening one of these counts as an eligible click for the interstitial.
  /// High-intent screens (connect, mirror, remote, player) are excluded.
  static const eligibleClickRoutes = {
    '/photos',
    '/videos',
    '/music',
    '/web',
    '/apps',
    '/apps/youtube',
    '/apps/google',
    '/apps/facebook',
    '/link',
    '/faq',
  };

  /// Never present a full-screen ad over these.
  static const blockedRoutes = {
    '/splash',
    '/paywall',
    '/premium',
    '/language',
    '/settings/language',
    '/onboarding',
    '/connect',
    '/mirror',
    '/ad-loading',
  };

  final List<Route<dynamic>> _stack = [];
  void Function(String route)? onEligiblePush;

  /// Test hook to bypass route tracking.
  @visibleForTesting
  bool? debugTopIsSafe;

  bool get topIsSafe {
    if (debugTopIsSafe != null) return debugTopIsSafe!;
    if (_stack.isEmpty) return false;
    final top = _stack.last;
    // Dialogs, bottom sheets and system-style popups (permission prompts).
    if (top is PopupRoute) return false;
    final name = top.settings.name;
    return name == null || !blockedRoutes.contains(name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
    final name = route.settings.name;
    if (name != null && eligibleClickRoutes.contains(name)) onEligiblePush?.call(name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _stack.remove(route);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) => _stack.remove(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final i = oldRoute == null ? -1 : _stack.indexOf(oldRoute);
    if (i >= 0 && newRoute != null) {
      _stack[i] = newRoute;
    } else if (newRoute != null) {
      _stack.add(newRoute);
    }
  }
}
