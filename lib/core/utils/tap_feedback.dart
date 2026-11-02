import 'package:flutter/services.dart';

/// Subtle haptic on taps. Mirrors Settings → Remote → Haptic feedback
/// (synced in app.dart) so plain widgets don't need a provider.
abstract final class TapFeedback {
  static bool hapticsEnabled = true;

  static void tap() {
    if (hapticsEnabled) HapticFeedback.selectionClick();
  }
}
