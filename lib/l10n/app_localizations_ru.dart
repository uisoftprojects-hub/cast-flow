// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get networkRequiredTitle => 'Not connected to Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Your phone and TV must be on the same Wi-Fi network to cast.';

  @override
  String get openWifiSettings => 'Open Wi-Fi Settings';

  @override
  String get useMobileHotspot => 'Use Mobile Hotspot';

  @override
  String get hotspotInstruction =>
      'Connect your LCD/TV to your mobile hotspot.';

  @override
  String get hotspotStep1 => 'Turn on mobile hotspot';

  @override
  String get hotspotStep2 => 'Connect your TV to it';

  @override
  String get hotspotStep3 => 'Come back to the app';

  @override
  String get openHotspotSettings => 'Open Hotspot Settings';

  @override
  String get hotspotAutoCheck =>
      'We\'ll check again automatically when you come back.';

  @override
  String get hotspotDetected => 'Hotspot is on. Looking for your TV…';

  @override
  String get searchingDevices => 'Searching for nearby devices...';

  @override
  String get waitingForTvOnHotspot =>
      'Waiting for your TV to join your hotspot…';

  @override
  String get usingHotspot => 'Using your mobile hotspot';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices found',
      one: '1 device found',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Retry';

  @override
  String get scanAgain => 'Scan again';

  @override
  String get isolationTitle => 'TV not responding';

  @override
  String get isolationHint =>
      'A device joined your hotspot but isn\'t responding. Your hotspot may be blocking device-to-device traffic (client isolation). Turn that off in hotspot settings, or use a Wi-Fi network.';

  @override
  String get connecting => 'Connecting…';

  @override
  String get connected => 'Connected';

  @override
  String get connectionFailed => 'Couldn\'t connect';

  @override
  String get connectFailedHint =>
      'Make sure your phone and TV are on the same network, then try again.';

  @override
  String get hotspotConnectHint =>
      'Your hotspot may be blocking device-to-device traffic. Check its client isolation setting.';

  @override
  String get networkLostTitle => 'Network connection lost';

  @override
  String get networkLostMessage =>
      'Reconnect to Wi-Fi or your hotspot, then reconnect to your TV.';

  @override
  String get reconnect => 'Reconnect';

  @override
  String reconnectTo(String name) {
    return 'Reconnect to $name';
  }

  @override
  String get tapToReconnect => 'Tap to reconnect';

  @override
  String get pairingRequired => 'Pairing required';

  @override
  String get pairingEnterCode => 'Enter the code shown on your TV.';

  @override
  String get pairingApproveOnTv => 'Look at your TV and tap Allow to continue.';

  @override
  String get connect => 'Connect';

  @override
  String get cancel => 'Cancel';

  @override
  String get pairingIncorrectCode => 'Incorrect code. Try again.';

  @override
  String get pairingTimedOut => 'Pairing timed out';

  @override
  String get tryAgain => 'Try again';

  @override
  String get pairingDeclined => 'The TV declined the connection';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Too many wrong codes. Wait $seconds s, then request a new code.';
  }

  @override
  String get pairingCooldownOver => 'You can request a new code now.';

  @override
  String get pairingRequestNewCode => 'Request new code';

  @override
  String get pairingNetworkLost =>
      'The network was lost during pairing. Reconnect to Wi-Fi and try again.';

  @override
  String get pairingFailed => 'Couldn\'t pair with the TV.';

  @override
  String pairingCodeField(int length) {
    return 'Pairing code, $length characters';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Code box $index of $total';
  }

  @override
  String get pairingEmptyBox => 'empty';

  @override
  String get pairingPaired => 'Paired';

  @override
  String get forgetDevice => 'Forget device';

  @override
  String forgetDeviceMessage(String name) {
    return '$name will need to be paired again next time.';
  }

  @override
  String get forget => 'Forget';

  @override
  String get castVideo => 'Cast video';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos found. Cast video',
      one: '1 video found. Cast video',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'No video found on this page yet.';

  @override
  String get videoFound => 'Video found';

  @override
  String get videoFoundMessage => 'Play it on your TV.';

  @override
  String get castAction => 'Cast';

  @override
  String get dismiss => 'Dismiss';

  @override
  String videosFound(int count) {
    return 'Videos found ($count)';
  }

  @override
  String get castToTv => 'Cast to TV';

  @override
  String get protectedVideo => 'Protected, can\'t be cast';

  @override
  String get videoThumbnail => 'Video thumbnail';

  @override
  String castingTo(String device) {
    return 'Casting to $device';
  }

  @override
  String get stopCasting => 'Stop casting';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Playback position';

  @override
  String get showControls => 'Show controls';

  @override
  String get hideControls => 'Hide controls';

  @override
  String get formatUnsupportedTitle => 'Format not supported';

  @override
  String formatUnsupported(String device, String format) {
    return '$device can\'t play $format videos. Try another video on this page, or use screen mirroring.';
  }

  @override
  String get videoExpired =>
      'This video link expired. Reload the page and try again.';

  @override
  String get refreshingVideo => 'Getting a fresh video link…';

  @override
  String get browserBack => 'Back';

  @override
  String get browserForward => 'Forward';

  @override
  String get browserStartPage => 'Start page';

  @override
  String get browserReload => 'Reload';

  @override
  String get ok => 'OK';
}
