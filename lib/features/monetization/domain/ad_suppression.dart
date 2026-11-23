/// Marks "the app is about to leave on purpose" (system permission prompt,
/// system settings, the system Cast picker, an external link, feedback,
/// rating...). A background -> foreground trip that follows is then NOT
/// eligible for an App Open ad: the user is coming back from something they
/// started, not re-opening the app.
///
/// Two mechanisms:
/// - A one-shot mark ([suppressNextAppOpen]) for a single trip out and back.
///   It lives until the app backgrounds (consumed by [take]) or until the
///   caller's request finishes without backgrounding ([clear], e.g. the
///   permission was already granted so no prompt appeared).
/// - Named holds ([hold] / [release]) for multi-step flows such as
///   "prompt -> denied -> Open Settings -> back -> prompt again". While any
///   hold is active every trip is suppressed. Holds expire on their own after
///   [holdLimit] so a flow that is never closed can't block App Open ads for
///   the rest of the session.
abstract final class AdSuppression {
  static bool _marked = false;
  static final Map<String, DateTime> _holds = {};

  /// Longest time a single hold suppresses App Open ads.
  static const holdLimit = Duration(minutes: 3);

  /// Overridable clock for tests.
  static DateTime Function() now = DateTime.now;

  /// Call right before launching something outside the app.
  static void suppressNextAppOpen() => _marked = true;

  /// Drops a mark that was armed but never consumed (no prompt was shown).
  static void clear() => _marked = false;

  /// Starts (or refreshes) a named suppression window, e.g. 'permission'.
  static void hold(String tag) => _holds[tag] = now();

  /// Ends a named suppression window. Unknown tags are ignored.
  static void release(String tag) => _holds.remove(tag);

  /// Whether a flow that leaves the app on purpose is in progress.
  static bool get isHeld {
    final t = now();
    _holds.removeWhere((_, since) => t.difference(since) > holdLimit);
    return _holds.isNotEmpty;
  }

  /// Consumed by the App Open manager when the app goes to the background.
  static bool take() {
    final was = _marked || isHeld;
    _marked = false;
    return was;
  }

  /// Runs an awaited permission request with suppression armed, and clears the
  /// mark afterwards so a prompt that never appeared can't affect a later pause.
  static Future<T> around<T>(Future<T> Function() action) async {
    suppressNextAppOpen();
    try {
      return await action();
    } finally {
      clear();
    }
  }

  /// Test helper: forgets every mark and hold.
  static void reset() {
    _marked = false;
    _holds.clear();
  }
}
