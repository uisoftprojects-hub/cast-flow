import 'dart:async';

/// Runs async jobs one at a time, in the order they were asked for.
///
/// Used for system permission prompts: Android allows a single request at a
/// time, so a second one started while the first dialog is still open fails
/// instead of waiting. Queued behind each other, the second job starts after
/// the first has finished and can see its result (e.g. "already granted").
class SerialRunner {
  Future<void> _tail = Future<void>.value();

  Future<T> run<T>(Future<T> Function() job) {
    final done = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        done.complete(await job());
      } catch (e, s) {
        done.completeError(e, s);
      }
    });
    return done.future;
  }
}
