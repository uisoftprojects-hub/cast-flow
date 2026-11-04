import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Native helpers implemented in MainActivity.kt (Android only; no-ops
/// elsewhere).
abstract final class NetworkChannel {
  static const _channel = MethodChannel('castflow/network');

  static bool get _android => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Android drops incoming multicast (SSDP/mDNS replies) without this lock.
  static Future<void> acquireMulticastLock() async {
    if (_android) await _channel.invokeMethod<bool>('acquireMulticastLock').catchError((_) => false);
  }

  static Future<void> releaseMulticastLock() async {
    if (_android) await _channel.invokeMethod<bool>('releaseMulticastLock').catchError((_) => false);
  }

  /// Wi-Fi and own-hotspot state. Off Android: treated as Wi-Fi if the device
  /// has any private LAN address (previews, desktop, tests).
  static Future<Map<String, Object?>> networkStatus() async {
    if (!_android) return const {'wifi': true, 'hotspot': false};
    final raw = await _channel.invokeMethod<Map<Object?, Object?>>('networkStatus').catchError((_) => null);
    return {for (final e in (raw ?? const {}).entries) e.key.toString(): e.value};
  }

  static Future<bool> openWifiSettings() async {
    if (!_android) return false;
    return await _channel.invokeMethod<bool>('openWifiSettings').catchError((_) => false) ?? false;
  }

  /// System tethering screen (falls back to wireless settings).
  static Future<bool> openHotspotSettings() async {
    if (!_android) return false;
    return await _channel.invokeMethod<bool>('openHotspotSettings').catchError((_) => false) ?? false;
  }

  /// Whether the screen is being mirrored right now (Smart View / Cast adds
  /// a presentation display), and the TV's name.
  static Future<({bool active, String? name})> mirroringStatus() async {
    if (!_android) return (active: false, name: null);
    final raw = await _channel.invokeMethod<Map<Object?, Object?>>('mirroringStatus').catchError((_) => null);
    return (active: raw?['active'] == true, name: raw?['name'] as String?);
  }

  /// Opens the system Cast / Smart View screen. Returns false if none exists.
  static Future<bool> openCastSettings() async {
    if (!_android) return false;
    return await _channel.invokeMethod<bool>('openCastSettings').catchError((_) => false) ?? false;
  }
}
