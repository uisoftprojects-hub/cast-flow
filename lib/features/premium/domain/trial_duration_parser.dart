import 'package:flutter/foundation.dart';

/// Parses ISO 8601 duration strings (e.g., P3D, P7D, P1W, P1M, P3M, P1Y)
/// into human-readable text with proper singular/plural grammar,
/// and builds dynamic CTA text according to Google Play trial eligibility.
@immutable
abstract final class TrialDurationParser {
  /// Regular expression to extract components of an ISO 8601 duration:
  /// Examples: P3D, P7D, P1W, P1M, P3M, P1Y, P1Y2M, etc.
  static final _isoRegex = RegExp(
    r'^P(?:(\d+)Y)?(?:(\d+)M)?(?:(\d+)W)?(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?)?$',
  );

  /// Converts an ISO 8601 duration string into human-readable duration text.
  ///
  /// Examples:
  /// - `P1D` -> `1 Day`
  /// - `P3D` -> `3 Days`
  /// - `P7D` -> `7 Days`
  /// - `P1W` -> `1 Week`
  /// - `P2W` -> `2 Weeks`
  /// - `P1M` -> `1 Month`
  /// - `P3M` -> `3 Months`
  /// - `P1Y` -> `1 Year`
  ///
  /// Returns `null` if the input is null, empty, or cannot be parsed.
  static String? parse(String? isoDuration) {
    if (isoDuration == null || isoDuration.trim().isEmpty) return null;
    final match = _isoRegex.firstMatch(isoDuration.trim().toUpperCase());
    if (match == null) return null;

    final years = int.tryParse(match.group(1) ?? '') ?? 0;
    final months = int.tryParse(match.group(2) ?? '') ?? 0;
    final weeks = int.tryParse(match.group(3) ?? '') ?? 0;
    final days = int.tryParse(match.group(4) ?? '') ?? 0;

    final parts = <String>[];

    if (years > 0) {
      parts.add(years == 1 ? '1 Year' : '$years Years');
    }
    if (months > 0) {
      parts.add(months == 1 ? '1 Month' : '$months Months');
    }
    if (weeks > 0) {
      parts.add(weeks == 1 ? '1 Week' : '$weeks Weeks');
    }
    if (days > 0) {
      parts.add(days == 1 ? '1 Day' : '$days Days');
    }

    if (parts.isEmpty) {
      // Check time parts if any (e.g., hours)
      final hours = int.tryParse(match.group(5) ?? '') ?? 0;
      if (hours > 0) {
        return hours == 1 ? '1 Hour' : '$hours Hours';
      }
      return null;
    }

    return parts.join(' ');
  }

  /// Builds the Call-To-Action (CTA) button text.
  ///
  /// If the user is eligible for a free trial and has a valid parsed duration,
  /// returns `[Duration] Free Trial` (e.g., `7 Days Free Trial`, `1 Week Free Trial`).
  ///
  /// If free trial is unavailable or ineligible, returns `Continue`.
  static String formatCta({
    required bool isEligible,
    String? trialDurationText,
    String continueLabel = 'Continue',
  }) {
    if (isEligible &&
        trialDurationText != null &&
        trialDurationText.isNotEmpty) {
      return '$trialDurationText Free Trial';
    }
    return continueLabel;
  }
}
