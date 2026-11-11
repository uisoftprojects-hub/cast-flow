import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/device_discovery_permission_service.dart';
import '../domain/app_permission.dart';

final discoveryPermissionServiceProvider = Provider<DiscoveryPermissionService>(
  (ref) => DeviceDiscoveryPermissionService(),
);

class FakeDiscoveryPermissionService implements DiscoveryPermissionService {
  FakeDiscoveryPermissionService({
    DiscoveryPermissionStatus initialStatus = DiscoveryPermissionStatus.granted,
    this.requiresLocation = false,
    this.locationServiceEnabled = true,
  }) : _status = initialStatus;

  DiscoveryPermissionStatus _status;
  final bool requiresLocation;
  bool locationServiceEnabled;
  int requestCallCount = 0;
  int checkCallCount = 0;
  bool openedSettings = false;
  bool openedLocationSettings = false;

  void setStatus(DiscoveryPermissionStatus s) {
    _status = s;
  }

  @override
  Future<DiscoveryPermissionStatus> checkStatus() async {
    checkCallCount++;
    if (_status == DiscoveryPermissionStatus.granted && requiresLocation && !locationServiceEnabled) {
      return DiscoveryPermissionStatus.locationServiceDisabled;
    }
    return _status;
  }

  @override
  Future<bool> isLocationRequired() async => requiresLocation;

  @override
  Future<bool> isLocationServiceEnabled() async => locationServiceEnabled;

  @override
  Future<DiscoveryPermissionStatus> requestPermission() async {
    requestCallCount++;
    if (_status == DiscoveryPermissionStatus.granted && requiresLocation && !locationServiceEnabled) {
      return DiscoveryPermissionStatus.locationServiceDisabled;
    }
    return _status;
  }

  @override
  Future<bool> openAppSettings() async {
    openedSettings = true;
    return true;
  }

  @override
  Future<bool> openLocationSettings() async {
    openedLocationSettings = true;
    return true;
  }
}
