import 'package:flutter/material.dart';

/// Raw palette for the CastFlow soft theme.
abstract final class AppColors {
  static const primary = Color(0xFF4F46E5);
  static const primaryDark = Color(0xFF818CF8);
  static const primaryLight = Color(0xFFEEF0FF);
  static const secondary = Color(0xFF12B886);
  static const accent = Color(0xFFFF7A59);

  static const background = Color(0xFFF4F5F9);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF111327);
  static const textSecondary = Color(0xFF646985);

  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFE5484D);

  static const darkBackground = Color(0xFF0E0F1A);
  static const darkSurface = Color(0xFF181A2A);
  static const darkSurfaceHigh = Color(0xFF23263A);
  static const darkPrimaryLight = Color(0xFF272A55);
  static const darkTextPrimary = Color(0xFFEDEFFA);
  static const darkTextSecondary = Color(0xFF9DA3BC);

  static const gradientStart = Color(0xFF6366F1);
  static const gradientEnd = Color(0xFF4338CA);

  static const mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), secondary],
  );

  static const peachGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F7A), accent],
  );
}

/// Theme-aware semantic colors, exposed as a [ThemeExtension] so widgets can
/// read them with `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.primary,
    required this.primaryTint,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.error,
    required this.shadow,
    required this.divider,
    required this.glass,
  });

  final Color background;
  final Color surface;
  final Color surfaceHigh;
  final Color primary;
  final Color primaryTint;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color error;
  final Color shadow;
  final Color divider;
  final Color glass;

  static const light = AppPalette(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceHigh: Color(0xFFEEF0F6),
    primary: AppColors.primary,
    primaryTint: AppColors.primaryLight,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    shadow: Color(0x0F111327),
    divider: Color(0xFFE6E8F0),
    glass: Color(0xE6FFFFFF),
  );

  static const dark = AppPalette(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceHigh: AppColors.darkSurfaceHigh,
    primary: AppColors.primaryDark,
    primaryTint: AppColors.darkPrimaryLight,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    shadow: Color(0x40000000),
    divider: Color(0xFF2A2D42),
    glass: Color(0xE6181A2A),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceHigh,
    Color? primary,
    Color? primaryTint,
    Color? secondary,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? error,
    Color? shadow,
    Color? divider,
    Color? glass,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      primary: primary ?? this.primary,
      primaryTint: primaryTint ?? this.primaryTint,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      shadow: shadow ?? this.shadow,
      divider: divider ?? this.divider,
      glass: glass ?? this.glass,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceHigh: l(surfaceHigh, other.surfaceHigh),
      primary: l(primary, other.primary),
      primaryTint: l(primaryTint, other.primaryTint),
      secondary: l(secondary, other.secondary),
      accent: l(accent, other.accent),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      error: l(error, other.error),
      shadow: l(shadow, other.shadow),
      divider: l(divider, other.divider),
      glass: l(glass, other.glass),
    );
  }
}
