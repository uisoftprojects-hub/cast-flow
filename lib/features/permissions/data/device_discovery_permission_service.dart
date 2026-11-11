import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../../core/platform/network_channel.dart';
import '../../monetization/domain/ad_suppression.dart';
import '../domain/app_permission.dart';

/// Real implementation of [DiscoveryPermissionService] handling Android version differences:
/// - Android 13+ (API 33+): uses NEARBY_WIFI_DEVICES (location not required).
/// - Android <= 12 (API <= 32): requires ACCESS_FINE_LOCATION and Location Services enabled.
/// - iOS: Local network permission handled by OS on multicast/socket use.
class DeviceDiscoveryPermissionService implements DiscoveryPermissionService {
  DeviceDiscoveryPermissionService({DeviceInfoPlugin? deviceInfo, this._overrideSdkInt})
    : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _deviceInfo;
  final int? _overrideSdkInt;
  int? _cachedSdkInt;

  bool get _isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<int> _sdkInt() async {
    if (_overrideSdkInt != null) return _overrideSdkInt;
    if (_cachedSdkInt != null) return _cachedSdkInt!;
    if (!_isAndroid) return 33;
    try {
      final info = await _deviceInfo.androidInfo;
      _cachedSdkInt = info.version.sdkInt;
      return _cachedSdkInt!;
    } catch (_) {
      return 33;
    }
  }

  @override
  Future<bool> isLocationRequired() async {
    if (!_isAndroid) return false;
    final sdk = await _sdkInt();
    return sdk <= 32;
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    if (!_isAndroid) return true;
    try {
      return await ph.Permission.location.serviceStatus.isEnabled;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<DiscoveryPermissionStatus> checkStatus() async {
    if (!_isAndroid) return DiscoveryPermissionStatus.granted;
    final sdk = await _sdkInt();
    if (sdk <= 32) {
      final status = await ph.Permission.locationWhenInUse.status;
      if (status.isGranted) {
        final serviceEnabled = await isLocationServiceEnabled();
        if (!serviceEnabled) {
          return DiscoveryPermissionStatus.locationServiceDisabled;
        }
        return DiscoveryPermissionStatus.granted;
      }
      if (status.isPermanentlyDenied || status.isRestricted) {
        return DiscoveryPermissionStatus.permanentlyDenied;
      }
      return DiscoveryPermissionStatus.denied;
    } else {
      final status = await ph.Permission.nearbyWifiDevices.status;
      if (status.isGranted) {
        return DiscoveryPermissionStatus.granted;
      }
      if (status.isPermanentlyDenied || status.isRestricted) {
        return DiscoveryPermissionStatus.permanentlyDenied;
      }
      return DiscoveryPermissionStatus.denied;
    }
  }

  @override
  Future<DiscoveryPermissionStatus> requestPermission() async {
    if (!_isAndroid) return DiscoveryPermissionStatus.granted;
    final sdk = await _sdkInt();
    if (sdk <= 32) {
      final status = await AdSuppression.around(() => ph.Permission.locationWhenInUse.request());
      if (status.isGranted) {
        final serviceEnabled = await isLocationServiceEnabled();
        if (!serviceEnabled) {
          return DiscoveryPermissionStatus.locationServiceDisabled;
        }
        return DiscoveryPermissionStatus.granted;
      }
      if (status.isPermanentlyDenied || status.isRestricted) {
        return DiscoveryPermissionStatus.permanentlyDenied;
      }
      return DiscoveryPermissionStatus.denied;
    } else {
      final status = await AdSuppression.around(() => ph.Permission.nearbyWifiDevices.request());
      if (status.isGranted) {
        return DiscoveryPermissionStatus.granted;
      }
      if (status.isPermanentlyDenied || status.isRestricted) {
        return DiscoveryPermissionStatus.permanentlyDenied;
      }
      return DiscoveryPermissionStatus.denied;
    }
  }

  @override
  Future<bool> openAppSettings() async {
    try {
      AdSuppression.suppressNextAppOpen();
      return await ph.openAppSettings();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> openLocationSettings() async {
    if (_isAndroid) {
      final ok = await NetworkChannel.openLocationSettings();
      if (ok) return true;
    }
    return openAppSettings();
  }
}
