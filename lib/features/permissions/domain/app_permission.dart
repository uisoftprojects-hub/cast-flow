/// Result of checking or requesting the permissions needed to discover TVs.
enum DiscoveryPermissionStatus { granted, denied, permanentlyDenied, locationServiceDisabled, notDetermined }

abstract interface class DiscoveryPermissionService {
  /// Checks whether required discovery permissions and services are already satisfied.
  Future<DiscoveryPermissionStatus> checkStatus();

  /// Whether location permission specifically is required by the OS version / technology.
  Future<bool> isLocationRequired();

  /// Requests the appropriate runtime permission(s) from the user.
  Future<DiscoveryPermissionStatus> requestPermission();

  /// Checks if location services (GPS/master switch) are enabled when required.
  Future<bool> isLocationServiceEnabled();

  /// Opens application settings.
  Future<bool> openAppSettings();

  /// Opens system location settings.
  Future<bool> openLocationSettings();
}
