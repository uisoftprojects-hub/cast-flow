/// Marks "the app is about to leave on purpose" (system permission prompt,
/// system settings, an external link, feedback, rating...). The next
/// background -> foreground transition that follows is then NOT eligible for
/// an App Open ad: the user is coming back from something they started, not
/// re-opening the app.
///
/// There is no timer. A mark lives until the app backgrounds (consumed by
/// [take]) or until the caller's request finishes without backgrounding
/// ([clear], e.g. permission already granted so no prompt appeared).
abstract final class AdSuppression {
  static bool _marked = false;

  /// Call right before launching something outside the app.
  static void suppressNextAppOpen() => _marked = true;

  /// Drops a mark that was armed but never consumed (no prompt was shown).
  static void clear() => _marked = false;

  /// Consumed by the App Open manager when the app goes to the background.
  static bool take() {
    final was = _marked;
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
}
