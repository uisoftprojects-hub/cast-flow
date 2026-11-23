import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../features/monetization/domain/ad_suppression.dart';

/// Keeps the app (and the media server the TV streams from) running while a
/// cast plays with the screen off: a "mediaPlayback" foreground service on
/// Android (CastSessionService.kt). No-ops elsewhere.
abstract final class CastSessionChannel {
  static const _channel = MethodChannel('castflow/cast_session');

  static bool get _android =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// A button or the seek bar of the notification / lock screen was used:
  /// `play`, `pause`, `next`, `previous`, `stop` or `seek` (with the position).
  static void Function(String name, Duration position)? onCommand;

  static bool _handlerSet = false;

  static void _ensureHandler() {
    if (_handlerSet || !_android) return;
    _handlerSet = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'command') {
        final args = call.arguments as Map<Object?, Object?>;
        onCommand?.call(
          args['name'] as String,
          Duration(milliseconds: (args['positionMs'] as num?)?.toInt() ?? 0),
        );
      }
      return null;
    });
  }

  /// Shows what is playing in the notification (title, buttons, seek bar).
  /// Only needed when something changes: Android moves the bar by itself
  /// from the position and the time it was sent.
  static Future<void> update({
    required String title,
    String? subtitle,
    required bool playing,
    required Duration position,
    required Duration duration,
    required bool hasPrevious,
    required bool hasNext,
    required bool preparing,
  }) async {
    if (!_android || !_running) return;
    await _channel.invokeMethod<bool>('update', {
      'title': title,
      'subtitle': subtitle,
      'playing': playing,
      'positionMs': position.inMilliseconds,
      'durationMs': duration.inMilliseconds,
      'hasPrevious': hasPrevious,
      'hasNext': hasNext,
      'preparing': preparing,
    }).catchError((_) => false);
  }

  static bool _askedForNotifications = false;
  static bool _running = false;

  /// Starts (or retitles) the service. Asks once per app run for the
  /// Android 13+ notification permission its notification needs; the cast
  /// never waits for that answer and works either way.
  static Future<void> start(String? title) async {
    if (!_android) return;
    _ensureHandler();
    if (!_askedForNotifications) {
      _askedForNotifications = true;
      // Not awaited: the prompt must never delay the cast.
      _askNotifications();
    }
    _running =
        await _channel
            .invokeMethod<bool>('start', {'title': title})
            .catchError((_) => false) ??
        false;
  }

  static Future<void> stop() async {
    if (!_android || !_running) return;
    _running = false;
    await _channel.invokeMethod<bool>('stop').catchError((_) => false);
  }

  static Future<void> _askNotifications() async {
    try {
      final status = await ph.Permission.notification.status;
      // Denied once already, or blocked: don't nag.
      if (status.isGranted || status.isPermanentlyDenied || status.isRestricted)
        return;
      await AdSuppression.around(() => ph.Permission.notification.request());
    } catch (_) {}
  }
}
