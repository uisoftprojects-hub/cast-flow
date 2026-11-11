/// Published links and store identifiers. Replace the placeholders with the
/// real documents before release; every legal link in the app reads these.
abstract final class AppLinks {
  static const privacyPolicy = 'https://sites.google.com/view/castto-tv-privacy-policy/home';
  static const terms = 'https://sites.google.com/view/termsand-conditions-/home';
  static const supportEmail = 'softrubi29@gmail.com';

  static const androidPackage = 'com.smarttvcast.screenmirror';
  static const iosAppId = '0000000000';

  static const playStore = 'https://play.google.com/store/apps/details?id=$androidPackage';
  static const appStore = 'https://apps.apple.com/app/id$iosAppId';
}
