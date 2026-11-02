/// Published links and store identifiers. Replace the placeholders with the
/// real documents before release; every legal link in the app reads these.
abstract final class AppLinks {
  static const privacyPolicy = 'https://example.com/castflow/privacy';
  static const terms = 'https://example.com/castflow/terms';
  static const supportEmail = 'support@example.com';

  static const androidPackage = 'com.castflow.castflow';
  static const iosAppId = '0000000000';

  static const playStore = 'https://play.google.com/store/apps/details?id=$androidPackage';
  static const appStore = 'https://apps.apple.com/app/id$iosAppId';
}
