import 'package:flutter/services.dart';

/// Subtle haptic on taps, so plain widgets don't need a provider.
abstract final class TapFeedback {
  static void tap() => HapticFeedback.selectionClick();
}
