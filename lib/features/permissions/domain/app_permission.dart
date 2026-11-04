import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

enum AppPermission {
  localNetwork('Local Network', 'Find TVs and streaming devices on your Wi-Fi.', Iconsax.wifi_copy),
  notifications('Notifications', 'Show casting controls while you use other apps.', Iconsax.notification_copy),
  media('Photos, Videos & Music', 'Pick what you want to cast from your gallery and library.', Iconsax.gallery_copy),
  screenCapture('Screen Capture', 'Mirror your screen. You’ll confirm each session.', Iconsax.screenmirroring_copy);

  const AppPermission(this.title, this.description, this.icon);
  final String title;
  final String description;
  final IconData icon;
}

enum PermissionStatus { notRequested, requesting, granted, denied }

/// Wraps permission_handler (and the MediaProjection prompt) in production.
abstract interface class PermissionService {
  Future<PermissionStatus> request(AppPermission permission);
}
