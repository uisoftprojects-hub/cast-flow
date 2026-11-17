import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ad_models.dart';

/// Log levels for AdMob and ad lifecycle logging in Logcat.
enum AdLogLevel { verbose, debug, info, warn, error }

/// Comprehensive enum of all states and lifecycle events for all ad formats
/// (Native, Interstitial, Splash, Click-Count, App Open, UMP Consent, SDK Init).
enum AdState {
  // --- Consent & SDK Initialization ---
  consentCheckStart,
  consentUpdated,
  consentFormRequired,
  consentFormLoaded,
  consentFormDismissed,
  consentError,
  consentCanRequestStatus,
  sdkInitStart,
  sdkInitSuccess,
  sdkInitFailed,

  // --- Request & Preload ---
  requestStart,
  requestSkipped,
  requestLoading,
  preloadStart,
  preloadSuccess,
  preloadConsumed,
  preloadFailed,

  // --- Load Outcome ---
  loaded,
  loadFailed,
  noFill,

  // --- Presentation & Interaction ---
  showRequested,
  showing,
  opened,
  impression,
  clicked,
  dismissed,
  showFailed,

  // --- Lifecycle, Timing & Session Rules ---
  backgrounded,
  resumed,
  freshnessCheck,
  expiredDiscarded,
  overlayShowing,
  overlayDismissed,
  overlayTimeout,
  delayedShowCached,
  clickCounterIncremented,
  sessionCompleted,
  cooldownActive,
  coordinatorLockAcquired,
  coordinatorLockRejected,
  coordinatorLockReleased,
  premiumPurge,
  disposed,
}

/// Centralized logger that broadcasts ad states across:
/// 1. Android Logcat via native [MethodChannel] ('castflow/ad_logger' with tag 'AdMob').
/// 2. Flutter console & Android logcat (under 'flutter' tag) via [debugPrint].
/// 3. Dart VM developer timeline via [developer.log].
class AdLogger {
  static const String defaultTag = 'AdMob';
  static const MethodChannel _channel = MethodChannel('castflow/ad_logger');

  /// Logs an ad state transition.
  static void log({
    required AdState state,
    AdPlacement? placement,
    String? adType,
    String? unitId,
    String? message,
    Object? error,
    StackTrace? stackTrace,
    AdLogLevel level = AdLogLevel.debug,
    String tag = defaultTag,
  }) {
    final stateName = state.name.toUpperCase();
    final parts = <String>['[STATE: $stateName]'];

    // Always show where the ad lives; non-ad-unit events (consent, SDK init) are 'global'.
    parts.add(
      placement != null
          ? '[Placement: ${placement.name} | ${placement.label}]'
          : '[Placement: global]',
    );
    if (adType != null) {
      parts.add('[Type: $adType]');
    }
    if (unitId != null && unitId.isNotEmpty) {
      parts.add('[UnitId: $unitId]');
    }
    if (message != null && message.isNotEmpty) {
      parts.add(message);
    }
    if (error != null) {
      parts.add('Error: $error');
    }

    final formatted = '[$tag] ${parts.join(' ')}';

    // 1. Send to native Android Logcat via MethodChannel
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      try {
        _channel
            .invokeMethod<void>('log', {
              'tag': tag,
              'level': level.name.toUpperCase(),
              'message': formatted,
            })
            .catchError((_) {
              // Swallow any channel errors (e.g. during headless widget tests)
            });
      } catch (_) {
        // Channel unavailable or in testing environment
      }
    }

    // 2. Output to Flutter console / Logcat 'flutter' tag
    debugPrint(formatted);

    // 3. Emit to Dart VM timeline
    developer.log(
      formatted,
      name: tag,
      level: _levelToNumber(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Convenience helper methods
  static void d(
    AdState state, {
    AdPlacement? placement,
    String? adType,
    String? unitId,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) => log(
    state: state,
    placement: placement,
    adType: adType,
    unitId: unitId,
    message: message,
    error: error,
    stackTrace: stackTrace,
    level: AdLogLevel.debug,
  );

  static void i(
    AdState state, {
    AdPlacement? placement,
    String? adType,
    String? unitId,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) => log(
    state: state,
    placement: placement,
    adType: adType,
    unitId: unitId,
    message: message,
    error: error,
    stackTrace: stackTrace,
    level: AdLogLevel.info,
  );

  static void w(
    AdState state, {
    AdPlacement? placement,
    String? adType,
    String? unitId,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) => log(
    state: state,
    placement: placement,
    adType: adType,
    unitId: unitId,
    message: message,
    error: error,
    stackTrace: stackTrace,
    level: AdLogLevel.warn,
  );

  static void e(
    AdState state, {
    AdPlacement? placement,
    String? adType,
    String? unitId,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) => log(
    state: state,
    placement: placement,
    adType: adType,
    unitId: unitId,
    message: message,
    error: error,
    stackTrace: stackTrace,
    level: AdLogLevel.error,
  );

  static int _levelToNumber(AdLogLevel level) {
    switch (level) {
      case AdLogLevel.verbose:
        return 300;
      case AdLogLevel.debug:
        return 500;
      case AdLogLevel.info:
        return 800;
      case AdLogLevel.warn:
        return 900;
      case AdLogLevel.error:
        return 1000;
    }
  }
}
