import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppRadius {
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const pill = 999.0;
}

abstract final class AppSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;

  /// Horizontal page gutter.
  static const page = 20.0;
}

/// Bottom list padding that keeps content clear of the floating nav bar and
/// the mini player. The shell uses `extendBody`, so the Scaffold reports
/// their combined height as the bottom MediaQuery padding.
double navBottomPadding(BuildContext context) => MediaQuery.paddingOf(context).bottom + AppSpace.xl;

abstract final class AppShadows {
  /// Tight, low-blur card shadow (paired with a hairline border on cards).
  static List<BoxShadow> soft(AppPalette p) => [BoxShadow(color: p.shadow, blurRadius: 12, offset: const Offset(0, 4))];

  static List<BoxShadow> glow(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.28), blurRadius: 16, offset: const Offset(0, 6)),
  ];
}

abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 450);
}

/// Minimum tap target per accessibility rules.
const kMinTap = 48.0;
