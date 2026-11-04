import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where events go. Firebase in production; a debug printer or an in-memory
/// recorder elsewhere.
abstract interface class AnalyticsSink {
  Future<void> logEvent(String name, Map<String, Object> params);
  Future<void> logScreen(String screenName);
  Future<void> setUserProperty(String name, String? value);
}

/// Prints events to the console in debug builds. Used until Firebase is
/// configured (no google-services.json yet) and in previews.
class DebugAnalyticsSink implements AnalyticsSink {
  const DebugAnalyticsSink();

  @override
  Future<void> logEvent(String name, Map<String, Object> params) async {
    if (kDebugMode) debugPrint('[analytics] $name $params');
  }

  @override
  Future<void> logScreen(String screenName) async {
    if (kDebugMode) debugPrint('[analytics] screen_view $screenName');
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    if (kDebugMode) debugPrint('[analytics] user_property $name=$value');
  }
}

/// Keeps every event in memory. For tests.
class MemoryAnalyticsSink implements AnalyticsSink {
  final events = <(String, Map<String, Object>)>[];
  final screens = <String>[];
  final userProperties = <String, String?>{};

  List<String> get names => [for (final e in events) e.$1];

  Map<String, Object>? last(String name) => events.lastWhere((e) => e.$1 == name, orElse: () => ('', {})).$2;

  @override
  Future<void> logEvent(String name, Map<String, Object> params) async => events.add((name, params));

  @override
  Future<void> logScreen(String screenName) async => screens.add(screenName);

  @override
  Future<void> setUserProperty(String name, String? value) async => userProperties[name] = value;
}

/// Overridden in main() with the Firebase sink once Firebase starts.
final analyticsSinkProvider = Provider<AnalyticsSink>((ref) => const DebugAnalyticsSink());

final analyticsProvider = Provider<Analytics>((ref) => Analytics(ref.watch(analyticsSinkProvider)));

/// Analytics from a widget context, for helpers that have no `ref`.
Analytics analyticsOf(BuildContext context) =>
    ProviderScope.containerOf(context, listen: false).read(analyticsProvider);

/// The single entry point for analytics. Cleans parameters to what Firebase
/// accepts (snake_case names up to 40 chars, string values up to 100 chars,
/// at most 25 params, no nulls, bools as 0/1) and never throws.
class Analytics {
  Analytics(this._sink);

  final AnalyticsSink _sink;

  static final _name = RegExp(r'^[a-z][a-z0-9_]{0,39}$');
  static const _reservedPrefixes = ['firebase_', 'google_', 'ga_'];

  /// Whether [name] is a valid event or parameter name.
  static bool isValidName(String name) => _name.hasMatch(name) && !_reservedPrefixes.any(name.startsWith);

  void log(String name, [Map<String, Object?> params = const {}]) {
    assert(isValidName(name), 'Bad analytics event name: $name');
    final clean = <String, Object>{};
    for (final MapEntry(:key, :value) in params.entries) {
      assert(isValidName(key), 'Bad analytics param name: $key on $name');
      if (value == null || clean.length >= 25) continue;
      clean[key] = switch (value) {
        final bool b => b ? 1 : 0,
        final int i => i,
        final double d => d,
        final Enum e => e.name,
        final Duration d => d.inMilliseconds,
        _ => _cut(value.toString()),
      };
    }
    _safe(() => _sink.logEvent(name, clean));
  }

  void screen(String screenName) => _safe(() => _sink.logScreen(_cut(screenName)));

  void userProperty(String name, String? value) =>
      _safe(() => _sink.setUserProperty(name, value == null ? null : _cut(value, 36)));

  static String _cut(String s, [int max = 100]) => s.length <= max ? s : s.substring(0, max);

  static void _safe(Future<void> Function() call) {
    try {
      unawaited(call().catchError((Object _) {}));
    } catch (_) {}
  }
}

/// Logs a screen_view whenever the router location changes (pushes, pops
/// and tab switches), skipping repeats of the same screen.
void trackScreens(Listenable router, String Function() currentPath, Analytics Function() analytics) {
  String? last;
  void report() {
    final name = screenNameFor(currentPath());
    if (name == null || name == last) return;
    last = name;
    analytics().screen(name);
  }

  router.addListener(report);
  report();
}

/// Maps a route path to its analytics screen name.
String? screenNameFor(String? path) {
  if (path == null || path.isEmpty) return null;
  final clean = path.split('?').first;
  const names = {
    '/splash': 'splash',
    '/language': 'language',
    '/settings/language': 'language_settings',
    '/onboarding': 'onboarding',
    '/home': 'home',
    '/devices': 'devices',
    '/connect': 'choose_device',
    '/history': 'history',
    '/settings': 'settings',
    '/mirror': 'screen_mirroring',
    '/remote': 'tv_remote',
    '/photos': 'photos',
    '/videos': 'videos',
    '/music': 'music',
    '/web': 'browser',
    '/apps': 'apps',
    '/apps/facebook': 'apps_facebook',
    '/link': 'link_cast',
    '/player': 'now_playing',
    '/premium': 'paywall',
    '/paywall': 'paywall',
    '/guide': 'guide',
    '/faq': 'faq',
    '/ad-diagnostics': 'ad_diagnostics',
  };
  if (names[clean] case final n?) return n;
  // Fallback: "/foo-bar/baz" → "foo_bar_baz".
  final n = clean.replaceAll(RegExp(r'^/+'), '').replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  return n.isEmpty ? null : n;
}
