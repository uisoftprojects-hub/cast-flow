import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/monetization/domain/ad_suppression.dart';

/// Native helpers implemented in MainActivity.kt (Android only; no-ops
/// elsewhere).
abstract final class NetworkChannel {
  static const _channel = MethodChannel('castflow/network');
  static const _events = EventChannel('castflow/network_events');

  static bool get _android =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Android drops incoming multicast (SSDP/mDNS replies) without this lock.
  static Future<void> acquireMulticastLock() async {
    if (_android)
      await _channel
          .invokeMethod<bool>('acquireMulticastLock')
          .catchError((_) => false);
  }

  static Future<void> releaseMulticastLock() async {
    if (_android)
      await _channel
          .invokeMethod<bool>('releaseMulticastLock')
          .catchError((_) => false);
  }

  /// Wi-Fi and own-hotspot state. Off Android: treated as Wi-Fi if the device
  /// has any private LAN address (previews, desktop, tests).
  static Future<Map<String, Object?>> networkStatus() async {
    if (!_android) return const {'wifi': true, 'hotspot': false};
    final raw = await _channel
        .invokeMethod<Map<Object?, Object?>>('networkStatus')
        .catchError((_) => null);
    return {
      for (final e in (raw ?? const {}).entries) e.key.toString(): e.value,
    };
  }

  /// Pushed by Android on every Wi-Fi / hotspot / VPN change (a
  /// ConnectivityManager.NetworkCallback plus the hotspot state broadcast).
  /// Empty off Android.
  static Stream<Map<String, Object?>> networkEvents() {
    if (!_android) return const Stream.empty();
    return _events.receiveBroadcastStream().map(
      (raw) => {
        for (final e in (raw as Map<Object?, Object?>? ?? const {}).entries) e.key.toString(): e.value,
      },
    );
  }

  /// Runs a native "open this settings screen" call with App Open
  /// suppression armed, dropping the mark again if nothing opened.
  static Future<bool> _openOutside(String method) async {
    if (!_android) return false;
    AdSuppression.suppressNextAppOpen();
    final ok = await _channel.invokeMethod<bool>(method).catchError((_) => false) ?? false;
    if (!ok) AdSuppression.clear();
    return ok;
  }

  static Future<bool> openWifiSettings() => _openOutside('openWifiSettings');

  /// Android 10+: the Wi-Fi panel over the app (Settings.Panel); older
  /// versions: the Wi-Fi settings screen.
  static Future<bool> openWifiPanel() => _openOutside('openWifiPanel');

  /// Opens the system location settings screen.
  static Future<bool> openLocationSettings() => _openOutside('openLocationSettings');

  /// System hotspot / tethering screen (falls back to wireless settings).
  static Future<bool> openHotspotSettings() => _openOutside('openHotspotSettings');

  /// Whether the screen is being mirrored right now (Smart View / Cast adds
  /// a presentation display), and the TV's name.
  static Future<({bool active, String? name})> mirroringStatus() async {
    if (!_android) return (active: false, name: null);
    final raw = await _channel
        .invokeMethod<Map<Object?, Object?>>('mirroringStatus')
        .catchError((_) => null);
    return (active: raw?['active'] == true, name: raw?['name'] as String?);
  }

  /// Opens the system Cast / Smart View screen. Returns false if none exists.
  static Future<bool> openCastSettings() => _openOutside('openCastSettings');
}
