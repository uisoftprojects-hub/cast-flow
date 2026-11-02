import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in `main()` with the loaded instance.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPrefsProvider must be overridden'),
);

/// Lets reviewers force the fake services into their empty or error branches
/// so every screen's states can be checked without real hardware.
enum PreviewMode {
  live('Live data'),
  empty('Empty states'),
  error('Error states');

  const PreviewMode(this.label);
  final String label;
}

class PreviewModeNotifier extends Notifier<PreviewMode> {
  @override
  PreviewMode build() => PreviewMode.live;

  void set(PreviewMode mode) => state = mode;
}

final previewModeProvider = NotifierProvider<PreviewModeNotifier, PreviewMode>(PreviewModeNotifier.new);

/// Shared helper for the fake data sources: waits a little, then applies the
/// current [PreviewMode].
Future<List<T>> simulateFetch<T>(
  PreviewMode mode,
  List<T> Function() data, {
  Duration delay = const Duration(milliseconds: 900),
}) async {
  await Future<void>.delayed(delay);
  switch (mode) {
    case PreviewMode.live:
      return data();
    case PreviewMode.empty:
      return <T>[];
    case PreviewMode.error:
      throw const FakeServiceException('Simulated failure (preview mode)');
  }
}

class FakeServiceException implements Exception {
  const FakeServiceException(this.message);
  final String message;

  @override
  String toString() => message;
}
