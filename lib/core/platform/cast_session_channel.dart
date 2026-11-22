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

  static bool _askedForNotifications = false;
  static bool _running = false;

  /// Starts (or retitles) the service. Asks once per app run for the
  /// Android 13+ notification permission its notification needs; the cast
  /// never waits for that answer and works either way.
  static Future<void> start(String? title) async {
    if (!_android) return;
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
