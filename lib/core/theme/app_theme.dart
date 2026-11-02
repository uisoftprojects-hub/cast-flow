import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_tokens.dart';

/// Typography scale: H1 28 semibold, H2 22 semibold, Title 17 medium,
/// Body 15 regular, Caption 12 regular, all at line height 1.4.
TextTheme _textTheme(Color primary, Color secondary) {
  TextStyle s(double size, FontWeight w, Color c) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: w, height: 1.4, color: c, letterSpacing: 0);

  return TextTheme(
    displaySmall: s(34, FontWeight.w700, primary),
    headlineLarge: s(28, FontWeight.w800, primary),
    headlineMedium: s(22, FontWeight.w700, primary),
    headlineSmall: s(20, FontWeight.w700, primary),
    titleLarge: s(17, FontWeight.w700, primary),
    titleMedium: s(17, FontWeight.w500, primary),
    titleSmall: s(15, FontWeight.w700, primary),
    bodyLarge: s(15, FontWeight.w400, primary),
    bodyMedium: s(15, FontWeight.w400, secondary),
    bodySmall: s(12, FontWeight.w400, secondary),
    labelLarge: s(15, FontWeight.w600, primary),
    labelMedium: s(13, FontWeight.w700, primary),
    labelSmall: s(12, FontWeight.w500, secondary),
  );
}

ThemeData _build(Brightness brightness, AppPalette p) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.primary,
    onPrimary: Colors.white,
    primaryContainer: p.primaryTint,
    onPrimaryContainer: p.primary,
    secondary: p.secondary,
    onSecondary: AppColors.textPrimary,
    secondaryContainer: p.secondary.withValues(alpha: 0.25),
    onSecondaryContainer: p.textPrimary,
    tertiary: p.accent,
    onTertiary: AppColors.textPrimary,
    error: p.error,
    onError: Colors.white,
    surface: p.surface,
    onSurface: p.textPrimary,
    onSurfaceVariant: p.textSecondary,
    surfaceContainerLowest: p.background,
    surfaceContainerLow: p.background,
    surfaceContainer: p.surface,
    surfaceContainerHigh: p.surfaceHigh,
    surfaceContainerHighest: p.surfaceHigh,
    outline: p.divider,
    outlineVariant: p.divider,
    shadow: p.shadow,
  );
  final text = _textTheme(p.textPrimary, p.textSecondary);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.background,
    textTheme: text,
    extensions: [p],
    splashFactory: InkSparkle.splashFactory,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: p.textPrimary,
      titleTextStyle: text.headlineSmall,
    ),
    dividerTheme: DividerThemeData(color: p.divider, thickness: 1, space: 1),
    iconTheme: IconThemeData(color: p.textPrimary, size: 22),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: p.divider,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? p.surfaceHigh : AppColors.textPrimary,
      contentTextStyle: text.bodyLarge?.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.surface,
      hintStyle: text.bodyMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        borderSide: BorderSide(color: p.primary.withValues(alpha: 0.5), width: 1.5),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: p.primary,
      inactiveTrackColor: p.primaryTint,
      thumbColor: p.primary,
      overlayColor: p.primary.withValues(alpha: 0.12),
      trackHeight: 5,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? Colors.white : p.textSecondary,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? p.primary : p.primaryTint,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: p.textSecondary,
      labelStyle: text.labelMedium,
      unselectedLabelStyle: text.labelMedium,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

abstract final class AppTheme {
  static final light = _build(Brightness.light, AppPalette.light);
  static final dark = _build(Brightness.dark, AppPalette.dark);
}

extension ThemeX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

extension MotionX on BuildContext {
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  /// Use as a flutter_animate `onPlay` to loop decorative motion, unless the
  /// OS asks for reduced motion (then it plays once and stops).
  void loopMotion(AnimationController c, {bool reverse = false}) {
    if (reduceMotion) return;
    reverse ? c.repeat(reverse: true) : c.repeat();
  }
}
