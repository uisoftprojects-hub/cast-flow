import 'ad_suppression.dart';

/// Keeps system prompts (permission dialogs, file pickers) from opening on top of
/// a full-screen ad. A tap can both count toward the click interstitial and lead to
/// a permission prompt (opening Music asks for audio access); the prompt then waits
/// until the ad has been dismissed instead of appearing over it.
abstract final class AdGate {
  static Future<bool> Function()? _waitUntilClear;

  /// Registered by the ad coordinator: completes once no full-screen ad is showing, with
  /// true if it had to wait for one.
  static void register(Future<bool> Function() waitUntilClear) => _waitUntilClear = waitUntilClear;

  static void unregister(Future<bool> Function() waitUntilClear) {
    if (identical(_waitUntilClear, waitUntilClear)) _waitUntilClear = null;
  }

  /// The tap that opened a prompt may also be starting an interstitial in the same
  /// moment (its click is counted right after the tap is handled). This gives that
  /// ad time to start, so it is seen below.
  static Duration settle = const Duration(milliseconds: 80);

  /// Let the ad finish closing before the prompt takes the screen.
  static Duration afterClose = const Duration(milliseconds: 300);

  /// Runs [prompt] (a system permission request or picker) once no full-screen ad
  /// is on screen, with App Open suppressed around it like any prompt.
  static Future<T> afterAds<T>(Future<T> Function() prompt) async {
    await Future<void>.delayed(settle);
    final wait = _waitUntilClear;
    if (wait != null) {
      // An ad can follow another one: look again until the screen is clear.
      for (var i = 0; i < 3; i++) {
        if (!await wait()) break;
        await Future<void>.delayed(afterClose);
      }
    }
    return AdSuppression.around(prompt);
  }
}
