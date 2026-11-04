// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get networkRequiredTitle => 'وائی فائی سے منسلک نہیں';

  @override
  String get networkRequiredMessage =>
      'کاسٹ کرنے کے لیے آپ کا فون اور ٹی وی ایک ہی وائی فائی نیٹ ورک پر ہونے چاہییں۔';

  @override
  String get openWifiSettings => 'وائی فائی سیٹنگز کھولیں';

  @override
  String get useMobileHotspot => 'موبائل ہاٹ اسپاٹ استعمال کریں';

  @override
  String get hotspotInstruction =>
      'اپنے ٹی وی کو فون کے موبائل ہاٹ اسپاٹ سے جوڑیں۔';

  @override
  String get hotspotStep1 => 'موبائل ہاٹ اسپاٹ آن کریں';

  @override
  String get hotspotStep2 => 'اپنا ٹی وی اس سے جوڑیں';

  @override
  String get hotspotStep3 => 'ایپ میں واپس آئیں';

  @override
  String get openHotspotSettings => 'ہاٹ اسپاٹ سیٹنگز کھولیں';

  @override
  String get hotspotAutoCheck =>
      'آپ کے واپس آنے پر ہم خود بخود دوبارہ جانچ کریں گے۔';

  @override
  String get hotspotDetected =>
      'ہاٹ اسپاٹ آن ہے۔ آپ کا ٹی وی تلاش کیا جا رہا ہے…';

  @override
  String get searchingDevices => 'قریبی آلات تلاش کیے جا رہے ہیں...';

  @override
  String get waitingForTvOnHotspot =>
      'آپ کے ٹی وی کے ہاٹ اسپاٹ سے جڑنے کا انتظار ہے…';

  @override
  String get usingHotspot => 'آپ کا موبائل ہاٹ اسپاٹ استعمال ہو رہا ہے';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آلات ملے',
      one: '1 آلہ ملا',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get scanAgain => 'دوبارہ اسکین کریں';

  @override
  String get isolationTitle => 'ٹی وی جواب نہیں دے رہا';

  @override
  String get isolationHint =>
      'ایک آلہ آپ کے ہاٹ اسپاٹ سے جڑ گیا ہے مگر جواب نہیں دے رہا۔ ہو سکتا ہے آپ کا ہاٹ اسپاٹ آلات کے درمیان ٹریفک روک رہا ہو (کلائنٹ آئسولیشن)۔ اسے ہاٹ اسپاٹ سیٹنگز میں بند کریں یا وائی فائی نیٹ ورک استعمال کریں۔';

  @override
  String get connecting => 'منسلک ہو رہا ہے…';

  @override
  String get connected => 'منسلک';

  @override
  String get connectionFailed => 'منسلک نہیں ہو سکا';

  @override
  String get connectFailedHint =>
      'یقینی بنائیں کہ فون اور ٹی وی ایک ہی نیٹ ورک پر ہیں، پھر دوبارہ کوشش کریں۔';

  @override
  String get hotspotConnectHint =>
      'ہو سکتا ہے آپ کا ہاٹ اسپاٹ آلات کے درمیان ٹریفک روک رہا ہو۔ کلائنٹ آئسولیشن کی سیٹنگ چیک کریں۔';

  @override
  String get networkLostTitle => 'نیٹ ورک کنکشن منقطع ہو گیا';

  @override
  String get networkLostMessage =>
      'وائی فائی یا ہاٹ اسپاٹ سے دوبارہ جڑیں، پھر اپنے ٹی وی سے دوبارہ جڑیں۔';

  @override
  String get reconnect => 'دوبارہ منسلک کریں';

  @override
  String reconnectTo(String name) {
    return '$name سے دوبارہ منسلک کریں';
  }

  @override
  String get tapToReconnect => 'دوبارہ منسلک ہونے کے لیے ٹیپ کریں';

  @override
  String get pairingRequired => 'پیئرنگ درکار ہے';

  @override
  String get pairingEnterCode => 'اپنے ٹی وی پر دکھایا گیا کوڈ درج کریں۔';

  @override
  String get pairingApproveOnTv =>
      'اپنے ٹی وی کو دیکھیں اور جاری رکھنے کے لیے اجازت دیں پر ٹیپ کریں۔';

  @override
  String get connect => 'منسلک کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get pairingIncorrectCode => 'کوڈ غلط ہے۔ دوبارہ کوشش کریں۔';

  @override
  String get pairingTimedOut => 'پیئرنگ کا وقت ختم ہو گیا';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get pairingDeclined => 'ٹی وی نے کنکشن مسترد کر دیا';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'بہت زیادہ غلط کوڈ۔ $seconds سیکنڈ انتظار کریں، پھر نیا کوڈ مانگیں۔';
  }

  @override
  String get pairingCooldownOver => 'اب آپ نیا کوڈ مانگ سکتے ہیں۔';

  @override
  String get pairingRequestNewCode => 'نیا کوڈ مانگیں';

  @override
  String get pairingNetworkLost =>
      'پیئرنگ کے دوران نیٹ ورک منقطع ہو گیا۔ وائی فائی سے دوبارہ جڑ کر کوشش کریں۔';

  @override
  String get pairingFailed => 'ٹی وی کے ساتھ پیئر نہیں ہو سکا۔';

  @override
  String pairingCodeField(int length) {
    return 'پیئرنگ کوڈ، $length حروف';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'کوڈ باکس $index/$total';
  }

  @override
  String get pairingEmptyBox => 'خالی';

  @override
  String get pairingPaired => 'پیئر ہو گیا';

  @override
  String get forgetDevice => 'آلہ بھول جائیں';

  @override
  String forgetDeviceMessage(String name) {
    return 'اگلی بار $name کو دوبارہ پیئر کرنا ہوگا۔';
  }

  @override
  String get forget => 'بھول جائیں';

  @override
  String get castVideo => 'ویڈیو کاسٹ کریں';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ویڈیوز ملیں۔ ویڈیو کاسٹ کریں',
      one: '1 ویڈیو ملی۔ ویڈیو کاسٹ کریں',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'اس صفحے پر ابھی کوئی ویڈیو نہیں ملی۔';

  @override
  String get videoFound => 'ویڈیو مل گئی';

  @override
  String get videoFoundMessage => 'اسے اپنے ٹی وی پر چلائیں۔';

  @override
  String get castAction => 'کاسٹ';

  @override
  String get dismiss => 'بند کریں';

  @override
  String videosFound(int count) {
    return 'ملنے والی ویڈیوز ($count)';
  }

  @override
  String get castToTv => 'ٹی وی پر کاسٹ کریں';

  @override
  String get protectedVideo => 'محفوظ ہے، کاسٹ نہیں ہو سکتی';

  @override
  String get videoThumbnail => 'ویڈیو کی تھمب نیل';

  @override
  String castingTo(String device) {
    return '$device پر کاسٹ ہو رہا ہے';
  }

  @override
  String get stopCasting => 'کاسٹنگ روکیں';

  @override
  String get play => 'چلائیں';

  @override
  String get pause => 'وقفہ';

  @override
  String get volume => 'آواز';

  @override
  String get seekPosition => 'پلے بیک کی پوزیشن';

  @override
  String get showControls => 'کنٹرولز دکھائیں';

  @override
  String get hideControls => 'کنٹرولز چھپائیں';

  @override
  String get formatUnsupportedTitle => 'فارمیٹ سپورٹڈ نہیں';

  @override
  String formatUnsupported(String device, String format) {
    return '$device $format ویڈیوز نہیں چلا سکتا۔ اس صفحے کی کوئی اور ویڈیو آزمائیں یا اسکرین مررنگ استعمال کریں۔';
  }

  @override
  String get videoExpired =>
      'اس ویڈیو لنک کی میعاد ختم ہو گئی۔ صفحہ ری لوڈ کر کے دوبارہ کوشش کریں۔';

  @override
  String get refreshingVideo => 'نیا ویڈیو لنک حاصل کیا جا رہا ہے…';

  @override
  String get browserBack => 'پیچھے';

  @override
  String get browserForward => 'آگے';

  @override
  String get browserStartPage => 'اسٹارٹ پیج';

  @override
  String get browserReload => 'ری لوڈ';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get home => 'ہوم';

  @override
  String get devices => 'آلات';

  @override
  String get history => 'ہسٹری';

  @override
  String get settings => 'سیٹنگز';

  @override
  String get goodMorning => 'صبح بخیر';

  @override
  String get goodAfternoon => 'سہ پہر بخیر';

  @override
  String get goodEvening => 'شام بخیر';

  @override
  String get couldntOpenTheLink => 'لنک نہیں کھل سکا۔';

  @override
  String get castflowLogo => 'CastFlow لوگو';

  @override
  String get somethingWentWrong => 'کچھ غلط ہو گیا';

  @override
  String get weCouldntLoadThis =>
      'یہ ابھی لوڈ نہیں ہو سکا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get apps => 'ایپس';

  @override
  String open(Object name) {
    return '$name کھولیں';
  }

  @override
  String get smartTv => 'Smart TV';

  @override
  String get chromecast => 'Chromecast';

  @override
  String get fireTv => 'Fire TV';

  @override
  String get roku => 'Roku';

  @override
  String get dlnaRenderer => 'DLNA renderer';

  @override
  String get miracast => 'Miracast';

  @override
  String get up => 'اوپر';

  @override
  String get down => 'نیچے';

  @override
  String get left => 'بائیں';

  @override
  String get right => 'دائیں';

  @override
  String get menu => 'مینو';

  @override
  String get input => 'ان پٹ';

  @override
  String get playPause => 'چلائیں / وقفہ';

  @override
  String get previous => 'پچھلا';

  @override
  String get next => 'اگلا';

  @override
  String get rewind => 'ریوائنڈ';

  @override
  String get volumeUp => 'آواز بڑھائیں';

  @override
  String get volumeDown => 'آواز کم کریں';

  @override
  String get mute => 'خاموش';

  @override
  String connectedTo(Object name) {
    return '$name سے منسلک';
  }

  @override
  String get chooseADevice => 'آلہ منتخب کریں';

  @override
  String get connectionGuide => 'کنکشن گائیڈ';

  @override
  String get lookingForTvsOn => 'آپ کے وائی فائی پر ٹی وی تلاش کیے جا رہے ہیں';

  @override
  String foundSoFar(Object found) {
    return 'اب تک $found ملے';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found آلات ملے';
  }

  @override
  String get disconnect => 'منقطع کریں';

  @override
  String signalOf4(Object level) {
    return 'سگنل 4 میں سے $level';
  }

  @override
  String get connecting2 => 'منسلک ہو رہا ہے';

  @override
  String get theTvRemoteNeeds =>
      'ٹی وی ریموٹ کو منسلک ٹی وی چاہیے۔ نیچے سے ایک منتخب کریں۔';

  @override
  String get connectToATv => 'جاری رکھنے کے لیے کسی ٹی وی سے منسلک ہوں۔';

  @override
  String get findingTvs => 'ٹی وی تلاش کیے جا رہے ہیں…';

  @override
  String get makeSureYourTv => 'یقینی بنائیں کہ آپ کا ٹی وی آن ہے';

  @override
  String get notConnected => 'منسلک نہیں';

  @override
  String get tapToFindYour => 'اپنا ٹی وی تلاش کرنے کے لیے ٹیپ کریں';

  @override
  String get connectionFailed2 => 'کنکشن ناکام';

  @override
  String tapToManageDevices(Object label) {
    return '$label۔ آلات کا نظم کرنے کے لیے ٹیپ کریں';
  }

  @override
  String get joinTheSameWi => 'ایک ہی وائی فائی سے جڑیں';

  @override
  String get connectYourPhoneAnd =>
      'اپنے فون اور ٹی وی کو ایک ہی وائی فائی نیٹ ورک سے جوڑیں۔';

  @override
  String get turnOnCastingOn => 'اپنے ٹی وی پر کاسٹنگ آن کریں';

  @override
  String get enableScreenMirroringMiracast =>
      'ٹی وی سیٹنگز میں اسکرین مررنگ، میراکاسٹ یا گوگل کاسٹ فعال کریں۔';

  @override
  String get scanForDevices => 'آلات اسکین کریں';

  @override
  String get openDevicesInCastflow =>
      'CastFlow میں آلات کھولیں اور ٹی وی ظاہر ہونے تک چند سیکنڈ انتظار کریں۔';

  @override
  String get tapConnect => 'منسلک کریں پر ٹیپ کریں';

  @override
  String get acceptThePromptOn =>
      'اگر ٹی وی پر کوئی پیغام آئے تو قبول کریں۔ بس اتنا ہی!';

  @override
  String get howToConnect => 'کیسے منسلک ہوں';

  @override
  String get fourQuickStepsTo => 'بڑی اسکرین تک پہنچنے کے چار آسان مراحل۔';

  @override
  String get gotIt => 'سمجھ گیا';

  @override
  String step(Object number, Object title, Object body) {
    return 'مرحلہ $number۔ $title۔ $body';
  }

  @override
  String get homeWiFi => 'گھر کا وائی فائی';

  @override
  String get router => 'راؤٹر';

  @override
  String get settingsConnection => 'سیٹنگز › کنکشن';

  @override
  String get inputHdmi1 => 'ان پٹ: HDMI 1';

  @override
  String get screenMirroring => 'اسکرین مررنگ';

  @override
  String get networkHomeWiFi => 'نیٹ ورک: گھر کا وائی فائی';

  @override
  String get livingRoomTv => 'لونگ روم کا ٹی وی';

  @override
  String get allowCastflowToConnect => 'CastFlow کو منسلک ہونے کی اجازت دیں؟';

  @override
  String get deny => 'مسترد کریں';

  @override
  String get allow => 'اجازت دیں';

  @override
  String get yourTv => 'آپ کا ٹی وی';

  @override
  String get findYourTv => 'اپنا ٹی وی تلاش کریں';

  @override
  String connectTo(Object name) {
    return '$name سے منسلک ہوں';
  }

  @override
  String connected2(Object label) {
    return 'منسلک · $label';
  }

  @override
  String get openTvRemote => 'ٹی وی ریموٹ کھولیں';

  @override
  String get sameWiFiNetwork => 'ایک ہی وائی فائی نیٹ ورک';

  @override
  String get yourPhoneAndTv =>
      'آپ کا فون اور ٹی وی ایک ہی وائی فائی سے منسلک ہونے چاہییں۔';

  @override
  String get tvIsOnAnd => 'ٹی وی آن اور تیار ہے';

  @override
  String get turnOnScreenMirroring =>
      'ٹی وی پر اسکرین مررنگ، کاسٹ یا میراکاسٹ آن کریں۔';

  @override
  String get noVpnOrGuest => 'کوئی VPN یا گیسٹ نیٹ ورک نہیں';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN اور گیسٹ / الگ تھلگ وائی فائی آلات کو ایک دوسرے سے چھپا دیتے ہیں۔';

  @override
  String get localNetworkAccess => 'مقامی نیٹ ورک تک رسائی';

  @override
  String get allowCastflowToFind =>
      'پوچھے جانے پر CastFlow کو اپنے نیٹ ورک پر آلات تلاش کرنے دیں۔';

  @override
  String get noTvFound => 'کوئی ٹی وی نہیں ملا';

  @override
  String get checkThatYourPhone =>
      'دیکھیں کہ فون اور ٹی وی ایک ہی وائی فائی پر ہیں، پھر دوبارہ اسکین کریں۔';

  @override
  String get noWiFiRouter =>
      'وائی فائی راؤٹر نہیں ہے؟ اپنا ہاٹ اسپاٹ استعمال کریں';

  @override
  String searchingForTvsFound(Object length) {
    return 'ٹی وی تلاش کیے جا رہے ہیں۔ $length ملے۔';
  }

  @override
  String tvsFound(Object length) {
    return '$length ٹی وی ملے';
  }

  @override
  String get connectToYourTv => 'اپنے ٹی وی سے منسلک ہوں';

  @override
  String get connectYourPhoneAndTv =>
      'اپنے فون اور ٹی وی کو ایک ہی وائی فائی نیٹ ورک سے جوڑیں۔';

  @override
  String get turnOnTheTv =>
      'ٹی وی آن کریں اور اس کا اسکرین مررنگ / کاسٹ ان پٹ کھولیں۔';

  @override
  String get tapTheConnectionBar =>
      'اپنا ٹی وی تلاش کرنے کے لیے ہوم پر کنکشن بار پر ٹیپ کریں۔';

  @override
  String get tapConnectAndAccept =>
      'منسلک کریں پر ٹیپ کریں اور ٹی وی پر پیغام آئے تو قبول کریں۔';

  @override
  String get mirrorYourScreen => 'اپنی اسکرین مرر کریں';

  @override
  String get connectToYourTvFirst => 'پہلے اپنے ٹی وی سے منسلک ہوں۔';

  @override
  String get openScreenMirroringFrom => 'ہوم سے اسکرین مررنگ کھولیں۔';

  @override
  String get pickAQualityAnd => 'معیار منتخب کریں اور اسٹارٹ پر ٹیپ کریں۔';

  @override
  String get allowScreenCaptureWhen =>
      'Android پوچھے تو اسکرین کیپچر کی اجازت دیں۔';

  @override
  String get castPhotosVideosMusic => 'تصاویر، ویڈیوز اور موسیقی کاسٹ کریں';

  @override
  String get openPhotosVideosOr => 'ہوم پر تصاویر، ویڈیوز یا موسیقی کھولیں۔';

  @override
  String get pickWhatYouWant => 'جو دکھانا ہے وہ منتخب کریں۔';

  @override
  String get itPlaysOnThe =>
      'یہ ٹی وی پر چلتا ہے؛ فون یا نوٹیفکیشن سے کنٹرول کریں۔';

  @override
  String get useTheTvRemote => 'ٹی وی ریموٹ استعمال کریں';

  @override
  String get openTvRemoteOn => 'ہوم پر ٹی وی ریموٹ کھولیں۔';

  @override
  String get useTheDPad =>
      'چلنے کے لیے ڈی پیڈ استعمال کریں یا ٹچ پیڈ پر سوائپ کریں، منتخب کرنے کے لیے OK پر ٹیپ کریں۔';

  @override
  String get buttonsATvDoesnt =>
      'جو بٹن ٹی وی سپورٹ نہیں کرتا وہ دھندلے نظر آتے ہیں۔';

  @override
  String get castFromTheWeb => 'ویب اور ایپس سے کاسٹ کریں';

  @override
  String get tapTheBrowserBar => 'ہوم پر براؤزر بار یا کسی ایپ پر ٹیپ کریں۔';

  @override
  String get playAVideoOn => 'سائٹ پر کوئی ویڈیو چلائیں۔';

  @override
  String get tapCastThisVideo =>
      'ٹی وی پر بھیجنے کے لیے “یہ ویڈیو کاسٹ کریں” پر ٹیپ کریں۔';

  @override
  String get screenMirroringHelp => 'اسکرین مررنگ کی مدد';

  @override
  String get connectYourPhoneTo => 'اپنے فون کو وائی فائی سے جوڑیں۔';

  @override
  String get onTheTvOpen =>
      'ٹی وی پر سیٹنگز → نیٹ ورک کھولیں اور اسی وائی فائی سے جڑیں۔';

  @override
  String get guestOrOfficeNetworks =>
      'گیسٹ یا دفتر کے نیٹ ورک اکثر مررنگ روک دیتے ہیں؛ گھر کا وائی فائی یا فون کا ہاٹ اسپاٹ استعمال کریں۔';

  @override
  String get turnOffVpn => 'VPN بند کریں';

  @override
  String get aVpnHidesYour => 'VPN آپ کے ٹی وی کو آپ کے فون سے چھپا دیتا ہے۔';

  @override
  String get pauseOrDisconnectYour =>
      'شروع کرنے سے پہلے اپنی VPN ایپ روکیں یا منقطع کریں۔';

  @override
  String get youCanTurnIt => 'کام ختم ہونے پر آپ اسے دوبارہ آن کر سکتے ہیں۔';

  @override
  String get turnOnMirroringOn => 'ٹی وی پر مررنگ آن کریں';

  @override
  String get samsungLgAndMost =>
      'Samsung، LG اور زیادہ تر Android ٹی وی مررنگ خود بخود قبول کر لیتے ہیں۔';

  @override
  String get otherTvsOpenInput =>
      'دوسرے ٹی وی: ان پٹ / سورس کھولیں اور اسکرین مررنگ یا میراکاسٹ منتخب کریں۔';

  @override
  String get keepTheTvOn =>
      'فون کے منسلک ہونے تک ٹی وی کو اسی اسکرین پر رکھیں۔';

  @override
  String get tapStartAndPick => 'اسٹارٹ پر ٹیپ کریں اور اپنا ٹی وی منتخب کریں';

  @override
  String get tapStartOnThe => 'اسکرین مررنگ اسکرین پر اسٹارٹ پر ٹیپ کریں۔';

  @override
  String get androidOpensSmartView =>
      'Android اسمارٹ ویو / کاسٹ کھولے گا۔ فہرست میں اپنے ٹی وی پر ٹیپ کریں۔';

  @override
  String get ifTheTvAsks =>
      'اگر ٹی وی پوچھے تو اجازت دیں منتخب کریں یا اسکرین پر دکھایا گیا PIN درج کریں۔';

  @override
  String get youreMirroring => 'آپ مرر کر رہے ہیں';

  @override
  String get everythingOnYourPhone =>
      'آپ کے فون کی ہر چیز اب ٹی وی پر نظر آ رہی ہے۔';

  @override
  String get turnThePhoneSideways =>
      'فل اسکرین ویڈیوز اور گیمز کے لیے فون کو آڑا گھمائیں۔';

  @override
  String get toStopTapStop =>
      'روکنے کے لیے اسٹاپ پر ٹیپ کریں یا کاسٹ نوٹیفکیشن استعمال کریں۔';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'بند';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'بیڈ روم کا ٹی وی';

  @override
  String get officeDisplay => 'دفتر کا ڈسپلے';

  @override
  String get clearHistory => 'ہسٹری صاف کریں؟';

  @override
  String get thisRemovesEverythingYouve =>
      'اس سے آپ کی کاسٹ کی ہوئی ہر چیز اس فہرست سے ہٹ جائے گی۔';

  @override
  String get clear => 'صاف کریں';

  @override
  String get clearHistory2 => 'ہسٹری صاف کریں';

  @override
  String get noHistoryYet => 'ابھی کوئی ہسٹری نہیں';

  @override
  String get everythingYouCastWill =>
      'آپ جو کچھ کاسٹ کریں گے وہ یہاں درج ہوگا تاکہ آپ اسے دوبارہ ڈھونڈ سکیں۔';

  @override
  String get today => 'آج';

  @override
  String get yesterday => 'کل';

  @override
  String get earlier => 'پہلے';

  @override
  String get swipeAnItemTo => 'ہٹانے کے لیے کسی آئٹم کو سوائپ کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String removed(Object title) {
    return '“$title” ہٹا دیا گیا';
  }

  @override
  String get undo => 'واپس کریں';

  @override
  String get photos => 'تصاویر';

  @override
  String get albums => 'البمز';

  @override
  String get videos => 'ویڈیوز';

  @override
  String get gallery => 'گیلری';

  @override
  String get music => 'موسیقی';

  @override
  String get songs => 'گانے';

  @override
  String get media => 'میڈیا';

  @override
  String get browseTheWeb => 'ویب براؤز کریں';

  @override
  String get goPro => 'پرو بنیں';

  @override
  String cast(Object title) {
    return '$title کاسٹ کریں';
  }

  @override
  String get screenMirroringStartMirroring => 'اسکرین مررنگ۔ مررنگ شروع کریں';

  @override
  String readyToMirrorTo(Object device) {
    return '$device پر مرر کرنے کے لیے تیار';
  }

  @override
  String get showYourPhoneOn => 'اپنے فون کو ٹی وی پر حقیقی وقت میں دکھائیں۔';

  @override
  String get startMirroring => 'مررنگ شروع کریں';

  @override
  String get tvRemote => 'ٹی وی ریموٹ';

  @override
  String get controlYourTv => 'اپنے ٹی وی کو کنٹرول کریں';

  @override
  String get youtubeMore => 'YouTube اور مزید';

  @override
  String get openTheBrowser => 'براؤزر کھولیں';

  @override
  String get searchOrTypeA => 'تلاش کریں یا ویب سائٹ لکھیں';

  @override
  String get howToConnectOpen => 'کیسے منسلک ہوں۔ بصری گائیڈ کھولیں';

  @override
  String get visualGuideForEvery => 'ہر فیچر کی بصری گائیڈ';

  @override
  String get language => 'زبان';

  @override
  String get done => 'مکمل';

  @override
  String get enterAValidHttp =>
      'درست http(s) یا rtsp لنک درج کریں، مثلاً .m3u8 یا .mp4 URL۔';

  @override
  String get linkStream => 'لنک اسٹریم';

  @override
  String get iptvLinkCast => 'IPTV / لنک کاسٹ';

  @override
  String get castALink => 'لنک کاسٹ کریں';

  @override
  String get pasteADirectVideo =>
      'براہ راست ویڈیو، M3U8 یا IPTV اسٹریم URL پیسٹ کریں۔';

  @override
  String get paste => 'پیسٹ کریں';

  @override
  String get castLink => 'لنک کاسٹ کریں';

  @override
  String get allowAccessToYour =>
      'میڈیا کاسٹ کرنے کے لیے رسائی کی اجازت دیں۔ آپ اسے سیٹنگز میں بدل سکتے ہیں۔';

  @override
  String get video => 'ویڈیو';

  @override
  String get castMusic => 'موسیقی کاسٹ کریں';

  @override
  String get noMusicFound => 'کوئی موسیقی نہیں ملی';

  @override
  String get addSongsToYour =>
      'اپنے فون میں گانے شامل کریں، وہ یہاں نظر آئیں گے۔';

  @override
  String get shuffle => 'شفل';

  @override
  String get playAll => 'سب چلائیں';

  @override
  String photo(Object formatShortDate) {
    return 'تصویر · $formatShortDate';
  }

  @override
  String get photo2 => 'تصویر';

  @override
  String get castPhotos => 'تصاویر کاسٹ کریں';

  @override
  String get select => 'منتخب کریں';

  @override
  String get noPhotosHere => 'یہاں کوئی تصویر نہیں';

  @override
  String get photosYouTakeOr =>
      'آپ کی لی ہوئی یا محفوظ کی ہوئی تصاویر اس البم میں نظر آئیں گی۔';

  @override
  String photos2(Object name, Object count) {
    return '$name، $count تصاویر';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return '$formatShortDate کی تصویر';
  }

  @override
  String get allPhotos => 'تمام تصاویر';

  @override
  String get slideshow => 'سلائیڈ شو';

  @override
  String get interval => 'وقفہ';

  @override
  String get transition => 'ٹرانزیشن';

  @override
  String get fade => 'فیڈ';

  @override
  String get slide => 'سلائیڈ';

  @override
  String get zoom => 'زوم';

  @override
  String get startSlideshow => 'سلائیڈ شو شروع کریں';

  @override
  String get castVideos => 'ویڈیوز کاسٹ کریں';

  @override
  String get noVideosYet => 'ابھی کوئی ویڈیو نہیں';

  @override
  String get videosYouRecordOr =>
      'آپ کی ریکارڈ یا ڈاؤن لوڈ کی ہوئی ویڈیوز یہاں کاسٹ کے لیے تیار نظر آئیں گی۔';

  @override
  String video2(Object resolution) {
    return 'ویڈیو · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title، $formatDuration۔ کاسٹ کریں';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'اسکرین مررنگ سیشن';

  @override
  String get mirroringDidntStartTap =>
      'مررنگ شروع نہیں ہوئی۔ اسٹارٹ پر دوبارہ ٹیپ کریں اور فہرست میں اپنا ٹی وی منتخب کریں۔';

  @override
  String get openSmartViewOr =>
      'مرر کرنے کے لیے فون کی کوئیک سیٹنگز سے اسمارٹ ویو یا کاسٹ کھولیں۔';

  @override
  String get quality => 'معیار';

  @override
  String get adjustsToYourWi =>
      'سب سے ہموار تصویر کے لیے آپ کے وائی فائی کے مطابق ڈھل جاتا ہے۔';

  @override
  String upToLowerIt(Object label) {
    return '$label تک۔ تصویر رکے تو کم کریں۔';
  }

  @override
  String get stillNeedHelp => 'مزید مدد چاہیے؟';

  @override
  String get startingScreenMirroring => 'اسکرین مررنگ شروع ہو رہی ہے…';

  @override
  String mirroringTo(Object value) {
    return '$value پر مرر ہو رہا ہے';
  }

  @override
  String get stopping => 'روکا جا رہا ہے…';

  @override
  String get readyToMirror => 'مرر کرنے کے لیے تیار';

  @override
  String get beforeYouStart => 'شروع کرنے سے پہلے';

  @override
  String get phoneAndTvAre => 'فون اور ٹی وی ایک ہی وائی فائی پر ہیں';

  @override
  String get noVpnIsConnected => 'آپ کے فون پر کوئی VPN منسلک نہیں';

  @override
  String get tvIsOnWith => 'ٹی وی آن ہے اور اسکرین مررنگ فعال ہے';

  @override
  String get phoneIsCloseTo => 'فون ٹی وی کے قریب ہے';

  @override
  String get stopMirroring => 'مررنگ روکیں';

  @override
  String get startMirroring2 => 'مررنگ شروع کریں';

  @override
  String get stop => 'روکیں';

  @override
  String get start => 'شروع';

  @override
  String get duration => 'دورانیہ';

  @override
  String get adIsLoading => 'اشتہار لوڈ ہو رہا ہے';

  @override
  String get ad => 'اشتہار';

  @override
  String get mirrorYourScreenTo => 'اپنی اسکرین کسی بھی ٹی وی پر مرر کریں';

  @override
  String get showYourPhoneOnThe =>
      'ایک ٹیپ میں اپنا فون بڑی اسکرین پر دکھائیں — نہ تار، نہ جھنجھٹ۔';

  @override
  String get shareMemoriesWithThe =>
      'یادیں پورے کمرے کے ساتھ بانٹیں اور کنٹرول اپنے فون سے رکھیں۔';

  @override
  String get castFromWebApps => 'ویب اور ایپس سے کاسٹ کریں';

  @override
  String get sendVideosFromYoutube =>
      'YouTube، Facebook اور کسی بھی ویب سائٹ کی ویڈیوز سیدھا اپنے ٹی وی پر بھیجیں۔';

  @override
  String pageOf(Object value, Object length) {
    return 'صفحہ $value/$length';
  }

  @override
  String get getStarted => 'شروع کریں';

  @override
  String get localNetwork => 'مقامی نیٹ ورک';

  @override
  String get findTvsAndStreaming =>
      'اپنے وائی فائی پر ٹی وی اور اسٹریمنگ آلات تلاش کریں۔';

  @override
  String get notifications => 'اطلاعات';

  @override
  String get showCastingControlsWhile =>
      'دوسری ایپس استعمال کرتے وقت کاسٹنگ کنٹرولز دکھائیں۔';

  @override
  String get photosVideosMusic => 'تصاویر، ویڈیوز اور موسیقی';

  @override
  String get pickWhatYouWantTo =>
      'اپنی گیلری اور لائبریری سے جو کاسٹ کرنا ہے وہ منتخب کریں۔';

  @override
  String get screenCapture => 'اسکرین کیپچر';

  @override
  String get mirrorYourScreenYoull =>
      'اپنی اسکرین مرر کریں۔ ہر سیشن کی آپ تصدیق کریں گے۔';

  @override
  String get webVideo => 'ویب ویڈیو';

  @override
  String get link => 'لنک';

  @override
  String get screenMirroring2 => 'اسکرین مررنگ';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'ابھی $title کاسٹ ہو رہا ہے۔ ریموٹ کھولیں';
  }

  @override
  String castingTo2(Object value) {
    return '$value پر کاسٹ ہو رہا ہے';
  }

  @override
  String get nowCasting => 'ابھی کاسٹ ہو رہا ہے';

  @override
  String get nothingIsCasting => 'کچھ بھی کاسٹ نہیں ہو رہا';

  @override
  String get pickAPhotoVideo =>
      'ٹی وی پر بھیجنے کے لیے کوئی تصویر، ویڈیو، گانا یا ویب ویڈیو منتخب کریں۔';

  @override
  String get backToHome => 'ہوم پر واپس';

  @override
  String slide2(Object formatDuration) {
    return 'سلائیڈ $formatDuration';
  }

  @override
  String get back10Seconds => '10 سیکنڈ پیچھے';

  @override
  String get forward10Seconds => '10 سیکنڈ آگے';

  @override
  String get tvVolume => 'ٹی وی کی آواز';

  @override
  String tvVolumePercent(Object round) {
    return 'ٹی وی کی آواز $round فیصد';
  }

  @override
  String get upNext => 'اگلا';

  @override
  String get addPhotos => 'تصاویر شامل کریں';

  @override
  String get addVideos => 'ویڈیوز شامل کریں';

  @override
  String get nothingElseInThe => 'قطار میں اور کچھ نہیں ہے۔';

  @override
  String play2(Object title) {
    return '$title چلائیں';
  }

  @override
  String get unknownDevice => 'نامعلوم آلہ';

  @override
  String get perWeek => 'فی ہفتہ';

  @override
  String get perYear => 'فی سال';

  @override
  String get payOnce => 'ایک بار ادائیگی';

  @override
  String get wirelessScreenMirroring => 'وائرلیس اسکرین مررنگ';

  @override
  String get castVideosPhotosMusic => 'ویڈیوز، تصاویر اور موسیقی کاسٹ کریں';

  @override
  String get fullTvRemoteControl => 'مکمل ٹی وی ریموٹ کنٹرول';

  @override
  String get worksWithAllMajor => 'تمام بڑے ٹی وی کے ساتھ کام کرتا ہے';

  @override
  String get smoothLagFreeStreaming => 'ہموار، بغیر رکاوٹ اسٹریمنگ';

  @override
  String get noAds => 'کوئی اشتہار نہیں';

  @override
  String get welcomeToCastflowPro => 'CastFlow Pro میں خوش آمدید!';

  @override
  String get purchaseCancelled => 'خریداری منسوخ ہو گئی۔';

  @override
  String get purchasePendingProUnlocks =>
      'خریداری زیر التوا ہے۔ اسٹور کی تصدیق ہوتے ہی Pro کھل جائے گا۔';

  @override
  String get purchaseFailedPleaseTry =>
      'خریداری ناکام ہو گئی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get theStoreIsntAvailable => 'اسٹور ابھی دستیاب نہیں ہے۔';

  @override
  String get close => 'بند کریں';

  @override
  String get goProWithCastflow => 'CASTFLOW کے ساتھ پرو بنیں';

  @override
  String get unlockEveryFeature => 'ہر فیچر کھولیں';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'منسوخ کیے جانے تک خود بخود تجدید ہوتی ہے۔';

  @override
  String get oneTimePurchaseNo => 'ایک بار کی خریداری۔ کوئی سبسکرپشن نہیں۔';

  @override
  String get continueAction => 'جاری رکھیں';

  @override
  String get privacyPolicy => 'رازداری کی پالیسی';

  @override
  String get termsAndConditions => 'شرائط و ضوابط';

  @override
  String get cancelAnytime => 'کسی بھی وقت منسوخ کریں';

  @override
  String get loadingPrice => 'قیمت لوڈ ہو رہی ہے…';

  @override
  String get pricesUnavailableTapTo =>
      'قیمتیں دستیاب نہیں · دوبارہ کوشش کے لیے ٹیپ کریں';

  @override
  String get noPlansAvailableRight => 'ابھی کوئی پلان دستیاب نہیں۔';

  @override
  String get weekly => 'ہفتہ وار';

  @override
  String get yearly => 'سالانہ';

  @override
  String get lifetime => 'تاحیات';

  @override
  String get bestValue => 'بہترین قدر';

  @override
  String get disconnectFromTv => 'ٹی وی سے منقطع کریں؟';

  @override
  String get thisStopsWhatIs =>
      'اس سے جو کچھ چل رہا ہے یا مرر ہو رہا ہے وہ رک جائے گا۔';

  @override
  String get useTouchpad => 'ٹچ پیڈ استعمال کریں';

  @override
  String get useDPad => 'ڈی پیڈ استعمال کریں';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label ریسیورز ریموٹ کمانڈز قبول نہیں کرتے۔';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return '$label پر کچھ بٹن دستیاب نہیں ہیں۔';
  }

  @override
  String get idle => 'غیر فعال';

  @override
  String get playing => 'چل رہا ہے';

  @override
  String get paused => 'وقفے پر';

  @override
  String get noTvConnected => 'کوئی ٹی وی منسلک نہیں';

  @override
  String get mute2 => 'خاموش';

  @override
  String vol(Object volume) {
    return 'آواز $volume';
  }

  @override
  String get noTvConnectedTap =>
      'کوئی ٹی وی منسلک نہیں۔ آلہ منتخب کرنے کے لیے ٹیپ کریں';

  @override
  String get tapToChooseA => 'آلہ منتخب کرنے کے لیے ٹیپ کریں';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label کو $label2 سپورٹ نہیں کرتا';
  }

  @override
  String get touchpadSwipeToMove =>
      'ٹچ پیڈ۔ حرکت کے لیے سوائپ کریں، منتخب کرنے کے لیے ٹیپ کریں۔';

  @override
  String get swipeToMoveTap => 'حرکت کے لیے سوائپ · منتخب کرنے کے لیے ٹیپ';

  @override
  String get navigationIsntSupportedBy => 'یہ ٹی وی نیویگیشن سپورٹ نہیں کرتا';

  @override
  String get vol2 => 'آواز';

  @override
  String get auto => 'خودکار';

  @override
  String get automatic => 'خودکار';

  @override
  String get googleCastFirst => 'پہلے گوگل کاسٹ';

  @override
  String get dlnaUpnpFirst => 'پہلے DLNA / UPnP';

  @override
  String get miracastFirst => 'پہلے میراکاسٹ';

  @override
  String get tvOnly => 'صرف ٹی وی';

  @override
  String get phoneAndTv => 'فون اور ٹی وی';

  @override
  String get phoneOnly => 'صرف فون';

  @override
  String get touchpad => 'ٹچ پیڈ';

  @override
  String get doMyPhoneAnd =>
      'کیا میرے فون اور ٹی وی کو ایک ہی وائی فائی چاہیے؟';

  @override
  String get yesDiscoveryAndCasting =>
      'جی ہاں۔ تلاش اور کاسٹنگ آپ کے مقامی نیٹ ورک پر رہتی ہے، اس لیے دونوں ایک ہی وائی فائی پر ہونے چاہییں (ملتے جلتے بینڈ نام الگ نیٹ ورک ہو سکتے ہیں)۔';

  @override
  String get myRouterHasAp => 'میرے راؤٹر میں “AP / کلائنٹ آئسولیشن” ہے';

  @override
  String get isolationBlocksDevicesFrom =>
      'آئسولیشن آلات کو ایک دوسرے کو دیکھنے سے روکتا ہے۔ اسے راؤٹر سیٹنگز میں بند کریں یا گیسٹ کے علاوہ نیٹ ورک استعمال کریں۔';

  @override
  String get findingYourTv => 'اپنا ٹی وی تلاش کرنا';

  @override
  String get myTvDoesntAppear => 'میرا ٹی وی فہرست میں نظر نہیں آ رہا';

  @override
  String get turnOnCastingScreen =>
      'ٹی وی پر کاسٹنگ / اسکرین مررنگ آن کریں، اسے اسٹینڈ بائی سے جگائیں، پھر دوبارہ اسکین پر ٹیپ کریں۔ پوچھے جانے پر مقامی نیٹ ورک کی اجازت دیں۔';

  @override
  String get onlySomeDevicesShow => 'صرف کچھ آلات نظر آتے ہیں';

  @override
  String get olderTvsMayNeed =>
      'پرانے ٹی وی کو فرم ویئر اپ ڈیٹ کی ضرورت ہو سکتی ہے۔ میراکاسٹ ٹی وی صرف اسی وقت نظر آتے ہیں جب ان کا “اسکرین مررنگ” ان پٹ کھلا ہو۔';

  @override
  String get connectionFailsOrTimes =>
      'کنکشن ناکام ہوتا ہے یا ٹائم آؤٹ ہو جاتا ہے';

  @override
  String get restartTheTvApp =>
      'ٹی وی ایپ یا ٹی وی ری اسٹارٹ کریں، راؤٹر کے قریب جائیں اور ٹی وی اسکرین پر آنے والا کوئی بھی پیغام قبول کریں۔';

  @override
  String get itKeepsReconnectingTo =>
      'یہ بار بار پرانے ٹی وی سے منسلک ہو جاتا ہے';

  @override
  String get turnOffAutoConnect =>
      'سیٹنگز → کاسٹنگ میں “آخری ٹی وی سے خودکار کنکشن” بند کریں۔';

  @override
  String get mirroringIsLaggy => 'مررنگ میں رکاوٹ آتی ہے';

  @override
  String get chooseALowerQuality =>
      'کم معیار (720p یا 480p) منتخب کریں، بھاری ایپس بند کریں اور 5 GHz وائی فائی نیٹ ورک استعمال کریں۔';

  @override
  String get thePictureIsRotated => 'تصویر گھومی ہوئی یا کٹی ہوئی ہے';

  @override
  String get toggleAutoRotateOn =>
      'اسکرین مررنگ اسکرین پر آٹو روٹیٹ آن/آف کریں۔';

  @override
  String get sound => 'آواز';

  @override
  String get thereIsNoSound => 'ٹی وی پر آواز نہیں آ رہی';

  @override
  String get makeSureAudioIs =>
      'یقینی بنائیں کہ اسکرین مررنگ میں آڈیو آن ہے اور سیٹنگز → کاسٹنگ → آڈیو آؤٹ پٹ چیک کریں۔ کچھ ریسیورز فون کی آڈیو سپورٹ نہیں کرتے۔';

  @override
  String get tvRemote2 => 'ٹی وی ریموٹ';

  @override
  String get someRemoteButtonsAre => 'کچھ ریموٹ بٹن دھندلے ہیں';

  @override
  String get eachReceiverSupportsDifferent =>
      'ہر ریسیور مختلف کمانڈز سپورٹ کرتا ہے۔ Chromecast اور DLNA صرف پلے بیک اور آواز سپورٹ کرتے ہیں؛ میراکاسٹ میں ریموٹ چینل نہیں ہوتا۔';

  @override
  String get canCastflowTurnMy =>
      'کیا CastFlow میرا ٹی وی آن کر سکتا ہے یا ان پٹ بدل سکتا ہے؟';

  @override
  String get onlyOnTvsThat =>
      'صرف ان ٹی وی پر جو یہ کمانڈز نیٹ ورک پر فراہم کرتے ہیں۔ غیر سپورٹڈ بٹن کام کرنے کا دکھاوا کرنے کے بجائے غیر فعال رہتے ہیں۔';

  @override
  String get helpFaq => 'مدد اور اکثر پوچھے گئے سوالات';

  @override
  String get stepByStepConnection => 'مرحلہ وار کنکشن گائیڈ';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'کوئی ای میل ایپ نہیں ملی۔';

  @override
  String get enjoyingCastflow => 'کیا آپ کو CastFlow پسند آ رہا ہے؟';

  @override
  String get sorryToHearThat => 'یہ سن کر افسوس ہوا';

  @override
  String get thanksHowCanWe => 'شکریہ! ہم کیسے بہتر ہو سکتے ہیں؟';

  @override
  String get wereGladYouLike => 'ہمیں خوشی ہے کہ آپ کو پسند آیا!';

  @override
  String get youMadeOurDay => 'آپ نے ہمارا دن بنا دیا!';

  @override
  String get tapToExit => 'باہر نکلنے کے لیے ٹیپ کریں';

  @override
  String get selectARating => 'ریٹنگ منتخب کریں';

  @override
  String get sendFeedback => 'فیڈ بیک بھیجیں';

  @override
  String get rateUs => 'ہمیں ریٹ کریں';

  @override
  String get rateYourExperienceBefore => 'جانے سے پہلے اپنے تجربے کو ریٹ کریں۔';

  @override
  String get tapAStarTo => 'CastFlow کو ریٹ کرنے کے لیے ستارے پر ٹیپ کریں۔';

  @override
  String get general => 'عمومی';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'ڈیفالٹ معیار';

  @override
  String get autoConnectToLast => 'آخری ٹی وی سے خودکار کنکشن';

  @override
  String get hapticFeedback => 'ہیپٹک فیڈ بیک';

  @override
  String get clearCastingHistory => 'کاسٹنگ ہسٹری صاف کریں';

  @override
  String get clearCastingHistory2 => 'کاسٹنگ ہسٹری صاف کریں؟';

  @override
  String get onlyCastflowsListIs =>
      'صرف CastFlow کی فہرست صاف ہوتی ہے۔ آپ کے فون کا میڈیا کبھی حذف نہیں ہوتا۔';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get light => 'ہلکا';

  @override
  String get dark => 'گہرا';

  @override
  String get system => 'سسٹم';

  @override
  String get aboutSupport => 'تعارف اور معاونت';

  @override
  String get rateApp => 'ایپ کو ریٹ کریں';

  @override
  String get feedback => 'فیڈ بیک';

  @override
  String get termsConditions => 'شرائط و ضوابط';

  @override
  String get version => 'ورژن';

  @override
  String get castflowProIsActive => 'CastFlow Pro فعال ہے';

  @override
  String get upgradeToPremium => 'پریمیم میں اپ گریڈ کریں';

  @override
  String get castflowPremium => 'CastFlow پریمیم';

  @override
  String get thanksForYourSupport =>
      'آپ کی حمایت کا شکریہ۔ بغیر اشتہار کاسٹنگ کا لطف اٹھائیں۔';

  @override
  String get noAds1080pMirroring =>
      'کوئی اشتہار نہیں، 1080p مررنگ اور لامحدود کاسٹنگ';

  @override
  String get upgrade => 'اپ گریڈ';

  @override
  String get mirrorCastBeautifullySimple => 'مرر اور کاسٹ، خوبصورتی سے آسان';

  @override
  String get thisActionMayContain => 'اس عمل میں اشتہارات ہو سکتے ہیں';

  @override
  String get webCast => 'ویب کاسٹ';

  @override
  String get castThisVideo => 'یہ ویڈیو کاسٹ کریں';

  @override
  String get searchOrTypeAWeb => 'تلاش کریں یا ویب ایڈریس لکھیں';

  @override
  String get removeBookmark => 'بک مارک ہٹائیں';

  @override
  String get bookmark => 'بک مارک';

  @override
  String get quickAccess => 'فوری رسائی';

  @override
  String open2(Object title) {
    return '$title کھولیں';
  }

  @override
  String get bookmarks => 'بک مارکس';

  @override
  String get noBookmarks => 'کوئی بک مارک نہیں';

  @override
  String get tapTheBookmarkIcon =>
      'صفحہ محفوظ کرنے کے لیے ایڈریس بار میں بک مارک آئیکن پر ٹیپ کریں۔';

  @override
  String get noHistory => 'کوئی ہسٹری نہیں';

  @override
  String get pagesYouVisitShow => 'آپ کے دیکھے ہوئے صفحات یہاں نظر آئیں گے۔';

  @override
  String get remove => 'ہٹائیں';

  @override
  String resultOn(Object value, Object host) {
    return '$host پر نتیجہ $value';
  }

  @override
  String get aSimulatedPageResult => 'ایک فرضی صفحے کا نتیجہ';

  @override
  String get videosOnThisPage => 'اس صفحے کی ویڈیوز';

  @override
  String get pickOneToSend => 'ٹی وی پر بھیجنے کے لیے ایک منتخب کریں۔';

  @override
  String get onboardHotspotTitle => 'وائی فائی نہیں؟ ہاٹ اسپاٹ استعمال کریں';

  @override
  String get onboardHotspotBody =>
      'اپنے فون کا ہاٹ اسپاٹ آن کریں اور ٹی وی کو اس سے جوڑیں۔ کاسٹنگ وائی فائی کی طرح ہی کام کرتی ہے۔';

  @override
  String get stillCantFindTitle => 'ابھی بھی ٹی وی نہیں ملا؟';

  @override
  String get stillCantFindBody => 'اپنے ٹی وی کو فون کے ہاٹ اسپاٹ سے جوڑیں:';

  @override
  String get hotspotStep4 =>
      'دوبارہ کوشش کریں پر ٹیپ کریں اور فہرست سے اپنا ٹی وی چنیں';

  @override
  String get castOverHotspot =>
      'وائی فائی نہیں؟ فون کے ہاٹ اسپاٹ سے کاسٹ کریں:';

  @override
  String get queue => 'قطار';

  @override
  String get addMusic => 'موسیقی شامل کریں';

  @override
  String get connectWithWifi => 'وائی فائی سے کنیکٹ کریں';

  @override
  String get continueWithHotspot => 'ہاٹ اسپاٹ کے ساتھ جاری رکھیں';

  @override
  String get noWifiAlertMessage =>
      'آپ موبائل ڈیٹا استعمال کر رہے ہیں۔ فون اور ٹی وی کو ایک ہی وائی فائی سے جوڑیں، یا فون کا ہاٹ اسپاٹ آن کر کے ٹی وی سے اس سے جڑیں۔';
}
