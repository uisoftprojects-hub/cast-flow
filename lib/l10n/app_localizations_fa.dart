// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get networkRequiredTitle => 'به Wi-Fi متصل نیستید';

  @override
  String get networkRequiredMessage =>
      'برای پخش، گوشی و تلویزیون باید در یک شبکه Wi-Fi باشند.';

  @override
  String get openWifiSettings => 'باز کردن تنظیمات Wi-Fi';

  @override
  String get useMobileHotspot => 'استفاده از هات‌اسپات موبایل';

  @override
  String get hotspotInstruction =>
      'تلویزیون را به هات‌اسپات موبایل گوشی وصل کنید.';

  @override
  String get hotspotStep1 => 'هات‌اسپات موبایل را روشن کنید';

  @override
  String get hotspotStep2 => 'تلویزیون را به آن وصل کنید';

  @override
  String get hotspotStep3 => 'به برنامه برگردید';

  @override
  String get openHotspotSettings => 'باز کردن تنظیمات هات‌اسپات';

  @override
  String get hotspotAutoCheck => 'وقتی برگردید، خودکار دوباره بررسی می‌کنیم.';

  @override
  String get hotspotDetected =>
      'هات‌اسپات روشن است. در حال جستجوی تلویزیون شما…';

  @override
  String get searchingDevices => 'در حال جستجوی دستگاه‌های اطراف...';

  @override
  String get waitingForTvOnHotspot =>
      'در انتظار پیوستن تلویزیون به هات‌اسپات شما…';

  @override
  String get usingHotspot => 'در حال استفاده از هات‌اسپات موبایل شما';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دستگاه پیدا شد',
      one: '۱ دستگاه پیدا شد',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'تلاش دوباره';

  @override
  String get scanAgain => 'اسکن دوباره';

  @override
  String get isolationTitle => 'تلویزیون پاسخ نمی‌دهد';

  @override
  String get isolationHint =>
      'دستگاهی به هات‌اسپات شما پیوسته اما پاسخ نمی‌دهد. ممکن است هات‌اسپات ترافیک بین دستگاه‌ها را مسدود کند (جداسازی کلاینت). آن را در تنظیمات هات‌اسپات خاموش کنید یا از شبکه Wi-Fi استفاده کنید.';

  @override
  String get connecting => 'در حال اتصال…';

  @override
  String get connected => 'متصل';

  @override
  String get connectionFailed => 'اتصال ممکن نشد';

  @override
  String get connectFailedHint =>
      'مطمئن شوید گوشی و تلویزیون در یک شبکه هستند، سپس دوباره تلاش کنید.';

  @override
  String get hotspotConnectHint =>
      'ممکن است هات‌اسپات شما ترافیک بین دستگاه‌ها را مسدود کند. تنظیم جداسازی کلاینت را بررسی کنید.';

  @override
  String get networkLostTitle => 'اتصال شبکه قطع شد';

  @override
  String get networkLostMessage =>
      'دوباره به Wi-Fi یا هات‌اسپات وصل شوید، سپس دوباره به تلویزیون متصل شوید.';

  @override
  String get reconnect => 'اتصال مجدد';

  @override
  String reconnectTo(String name) {
    return 'اتصال مجدد به $name';
  }

  @override
  String get tapToReconnect => 'برای اتصال مجدد ضربه بزنید';

  @override
  String get pairingRequired => 'جفت‌سازی لازم است';

  @override
  String get pairingEnterCode =>
      'کدی را که روی تلویزیون نمایش داده شده وارد کنید.';

  @override
  String get pairingApproveOnTv =>
      'به تلویزیون نگاه کنید و برای ادامه روی اجازه ضربه بزنید.';

  @override
  String get connect => 'اتصال';

  @override
  String get cancel => 'لغو';

  @override
  String get pairingIncorrectCode => 'کد نادرست است. دوباره تلاش کنید.';

  @override
  String get pairingTimedOut => 'زمان جفت‌سازی تمام شد';

  @override
  String get tryAgain => 'تلاش دوباره';

  @override
  String get pairingDeclined => 'تلویزیون اتصال را رد کرد';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'کدهای اشتباه زیادی وارد شد. $seconds ثانیه صبر کنید، سپس کد جدید بخواهید.';
  }

  @override
  String get pairingCooldownOver => 'اکنون می‌توانید کد جدید درخواست کنید.';

  @override
  String get pairingRequestNewCode => 'درخواست کد جدید';

  @override
  String get pairingNetworkLost =>
      'هنگام جفت‌سازی شبکه قطع شد. دوباره به Wi-Fi وصل شوید و تلاش کنید.';

  @override
  String get pairingFailed => 'جفت‌سازی با تلویزیون ممکن نشد.';

  @override
  String pairingCodeField(int length) {
    return 'کد جفت‌سازی، $length نویسه';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'کادر کد $index از $total';
  }

  @override
  String get pairingEmptyBox => 'خالی';

  @override
  String get pairingPaired => 'جفت شد';

  @override
  String get forgetDevice => 'فراموش کردن دستگاه';

  @override
  String forgetDeviceMessage(String name) {
    return 'دفعه بعد باید $name دوباره جفت شود.';
  }

  @override
  String get forget => 'فراموش کن';

  @override
  String get castVideo => 'پخش ویدیو';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ویدیو پیدا شد. پخش ویدیو',
      one: '۱ ویدیو پیدا شد. پخش ویدیو',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'هنوز ویدیویی در این صفحه پیدا نشده است.';

  @override
  String get videoFound => 'ویدیو پیدا شد';

  @override
  String get videoFoundMessage => 'آن را روی تلویزیون پخش کنید.';

  @override
  String get castAction => 'پخش';

  @override
  String get dismiss => 'بستن';

  @override
  String videosFound(int count) {
    return 'ویدیوهای پیدا شده ($count)';
  }

  @override
  String get castToTv => 'پخش روی تلویزیون';

  @override
  String get protectedVideo => 'محافظت‌شده، قابل پخش نیست';

  @override
  String get videoThumbnail => 'تصویر بندانگشتی ویدیو';

  @override
  String castingTo(String device) {
    return 'در حال پخش روی $device';
  }

  @override
  String get stopCasting => 'توقف پخش';

  @override
  String get play => 'پخش';

  @override
  String get pause => 'مکث';

  @override
  String get volume => 'صدا';

  @override
  String get seekPosition => 'موقعیت پخش';

  @override
  String get showControls => 'نمایش کنترل‌ها';

  @override
  String get hideControls => 'پنهان کردن کنترل‌ها';

  @override
  String get formatUnsupportedTitle => 'قالب پشتیبانی نمی‌شود';

  @override
  String formatUnsupported(String device, String format) {
    return '$device نمی‌تواند ویدیوهای $format را پخش کند. ویدیوی دیگری در این صفحه امتحان کنید یا از آینه‌سازی صفحه استفاده کنید.';
  }

  @override
  String get videoExpired =>
      'پیوند این ویدیو منقضی شد. صفحه را دوباره بارگذاری کنید و تلاش کنید.';

  @override
  String get refreshingVideo => 'در حال دریافت پیوند ویدیوی جدید…';

  @override
  String get browserBack => 'برگشت';

  @override
  String get browserForward => 'جلو';

  @override
  String get browserStartPage => 'صفحه شروع';

  @override
  String get browserReload => 'بارگذاری مجدد';

  @override
  String get ok => 'تأیید';

  @override
  String get home => 'خانه';

  @override
  String get devices => 'دستگاه‌ها';

  @override
  String get history => 'تاریخچه';

  @override
  String get settings => 'تنظیمات';

  @override
  String get goodMorning => 'صبح بخیر';

  @override
  String get goodAfternoon => 'عصر بخیر';

  @override
  String get goodEvening => 'شب بخیر';

  @override
  String get couldntOpenTheLink => 'پیوند باز نشد.';

  @override
  String get castflowLogo => 'لوگوی CastFlow';

  @override
  String get somethingWentWrong => 'مشکلی پیش آمد';

  @override
  String get weCouldntLoadThis =>
      'اکنون بارگذاری ممکن نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get apps => 'برنامه‌ها';

  @override
  String open(Object name) {
    return 'باز کردن $name';
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
  String get up => 'بالا';

  @override
  String get down => 'پایین';

  @override
  String get left => 'چپ';

  @override
  String get right => 'راست';

  @override
  String get menu => 'منو';

  @override
  String get input => 'ورودی';

  @override
  String get playPause => 'پخش / مکث';

  @override
  String get previous => 'قبلی';

  @override
  String get next => 'بعدی';

  @override
  String get rewind => 'عقب‌بردن';

  @override
  String get volumeUp => 'افزایش صدا';

  @override
  String get volumeDown => 'کاهش صدا';

  @override
  String get mute => 'بی‌صدا';

  @override
  String connectedTo(Object name) {
    return 'متصل به $name';
  }

  @override
  String get chooseADevice => 'یک دستگاه انتخاب کنید';

  @override
  String get connectionGuide => 'راهنمای اتصال';

  @override
  String get lookingForTvsOn => 'در حال جستجوی تلویزیون در Wi-Fi شما';

  @override
  String foundSoFar(Object found) {
    return 'تاکنون $found مورد پیدا شد';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found دستگاه پیدا شد';
  }

  @override
  String get disconnect => 'قطع اتصال';

  @override
  String signalOf4(Object level) {
    return 'سیگنال $level از ۴';
  }

  @override
  String get connecting2 => 'در حال اتصال';

  @override
  String get theTvRemoteNeeds =>
      'ریموت تلویزیون به یک تلویزیون متصل نیاز دارد. یکی را از پایین انتخاب کنید.';

  @override
  String get connectToATv => 'برای ادامه به یک تلویزیون وصل شوید.';

  @override
  String get findingTvs => 'در حال جستجوی تلویزیون…';

  @override
  String get makeSureYourTv => 'مطمئن شوید تلویزیون روشن است';

  @override
  String get notConnected => 'متصل نیست';

  @override
  String get tapToFindYour => 'برای یافتن تلویزیون ضربه بزنید';

  @override
  String get connectionFailed2 => 'اتصال ناموفق بود';

  @override
  String tapToManageDevices(Object label) {
    return '$label. برای مدیریت دستگاه‌ها ضربه بزنید';
  }

  @override
  String get joinTheSameWi => 'به همان Wi-Fi بپیوندید';

  @override
  String get connectYourPhoneAnd =>
      'گوشی و تلویزیون را به یک شبکه Wi-Fi وصل کنید.';

  @override
  String get turnOnCastingOn => 'پخش را روی تلویزیون روشن کنید';

  @override
  String get enableScreenMirroringMiracast =>
      'آینه‌سازی صفحه، Miracast یا Google Cast را در تنظیمات تلویزیون فعال کنید.';

  @override
  String get scanForDevices => 'اسکن دستگاه‌ها';

  @override
  String get openDevicesInCastflow =>
      'در CastFlow بخش دستگاه‌ها را باز کنید و چند ثانیه صبر کنید تا تلویزیون ظاهر شود.';

  @override
  String get tapConnect => 'روی اتصال ضربه بزنید';

  @override
  String get acceptThePromptOn =>
      'اگر روی تلویزیون پیامی آمد، آن را بپذیرید. همین!';

  @override
  String get howToConnect => 'نحوه اتصال';

  @override
  String get fourQuickStepsTo => 'چهار مرحله سریع برای رفتن به صفحه بزرگ.';

  @override
  String get gotIt => 'متوجه شدم';

  @override
  String step(Object number, Object title, Object body) {
    return 'مرحله $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi خانه';

  @override
  String get router => 'روتر';

  @override
  String get settingsConnection => 'تنظیمات › اتصال';

  @override
  String get inputHdmi1 => 'ورودی: HDMI 1';

  @override
  String get screenMirroring => 'آینه‌سازی صفحه';

  @override
  String get networkHomeWiFi => 'شبکه: Wi-Fi خانه';

  @override
  String get livingRoomTv => 'تلویزیون اتاق نشیمن';

  @override
  String get allowCastflowToConnect => 'به CastFlow اجازه اتصال داده شود؟';

  @override
  String get deny => 'رد کردن';

  @override
  String get allow => 'اجازه';

  @override
  String get yourTv => 'تلویزیون شما';

  @override
  String get findYourTv => 'تلویزیون خود را پیدا کنید';

  @override
  String connectTo(Object name) {
    return 'اتصال به $name';
  }

  @override
  String connected2(Object label) {
    return 'متصل · $label';
  }

  @override
  String get openTvRemote => 'باز کردن ریموت تلویزیون';

  @override
  String get sameWiFiNetwork => 'همان شبکه Wi-Fi';

  @override
  String get yourPhoneAndTv => 'گوشی و تلویزیون باید به یک Wi-Fi وصل باشند.';

  @override
  String get tvIsOnAnd => 'تلویزیون روشن و آماده است';

  @override
  String get turnOnScreenMirroring =>
      'آینه‌سازی صفحه، Cast یا Miracast را روی تلویزیون روشن کنید.';

  @override
  String get noVpnOrGuest => 'بدون VPN یا شبکه مهمان';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN و Wi-Fi مهمان یا ایزوله باعث می‌شوند دستگاه‌ها همدیگر را نبینند.';

  @override
  String get localNetworkAccess => 'دسترسی به شبکه محلی';

  @override
  String get allowCastflowToFind =>
      'هنگام درخواست، اجازه دهید CastFlow دستگاه‌های شبکه شما را پیدا کند.';

  @override
  String get noTvFound => 'تلویزیونی پیدا نشد';

  @override
  String get checkThatYourPhone =>
      'بررسی کنید گوشی و تلویزیون در یک Wi-Fi هستند، سپس دوباره اسکن کنید.';

  @override
  String get noWiFiRouter => 'روتر Wi-Fi ندارید؟ از هات‌اسپات استفاده کنید';

  @override
  String searchingForTvsFound(Object length) {
    return 'در حال جستجوی تلویزیون. $length مورد پیدا شد.';
  }

  @override
  String tvsFound(Object length) {
    return '$length تلویزیون پیدا شد';
  }

  @override
  String get connectToYourTv => 'به تلویزیون خود وصل شوید';

  @override
  String get connectYourPhoneAndTv =>
      'گوشی و تلویزیون را به یک شبکه Wi-Fi وصل کنید.';

  @override
  String get turnOnTheTv =>
      'تلویزیون را روشن کنید و ورودی آینه‌سازی صفحه / Cast را باز کنید.';

  @override
  String get tapTheConnectionBar =>
      'برای یافتن تلویزیون، روی نوار اتصال در خانه ضربه بزنید.';

  @override
  String get tapConnectAndAccept =>
      'روی اتصال ضربه بزنید و اگر روی تلویزیون پیامی آمد، آن را بپذیرید.';

  @override
  String get mirrorYourScreen => 'صفحه خود را آینه کنید';

  @override
  String get connectToYourTvFirst => 'ابتدا به تلویزیون وصل شوید.';

  @override
  String get openScreenMirroringFrom => 'از خانه، آینه‌سازی صفحه را باز کنید.';

  @override
  String get pickAQualityAnd => 'کیفیتی انتخاب کنید و روی شروع ضربه بزنید.';

  @override
  String get allowScreenCaptureWhen =>
      'وقتی Android پرسید، ضبط صفحه را مجاز کنید.';

  @override
  String get castPhotosVideosMusic => 'پخش عکس، ویدیو و موسیقی';

  @override
  String get openPhotosVideosOr =>
      'در خانه، عکس‌ها، ویدیوها یا موسیقی را باز کنید.';

  @override
  String get pickWhatYouWant => 'آنچه می‌خواهید نمایش دهید را انتخاب کنید.';

  @override
  String get itPlaysOnThe =>
      'روی تلویزیون پخش می‌شود؛ از گوشی یا اعلان کنترل کنید.';

  @override
  String get useTheTvRemote => 'از ریموت تلویزیون استفاده کنید';

  @override
  String get openTvRemoteOn => 'در خانه، ریموت تلویزیون را باز کنید.';

  @override
  String get useTheDPad =>
      'برای حرکت از کلیدهای جهت‌دار یا کشیدن روی تاچ‌پد استفاده کنید و برای انتخاب روی OK ضربه بزنید.';

  @override
  String get buttonsATvDoesnt =>
      'دکمه‌هایی که تلویزیون پشتیبانی نمی‌کند خاکستری هستند.';

  @override
  String get castFromTheWeb => 'پخش از وب و برنامه‌ها';

  @override
  String get tapTheBrowserBar =>
      'در خانه، روی نوار مرورگر یا یک برنامه ضربه بزنید.';

  @override
  String get playAVideoOn => 'در سایت یک ویدیو پخش کنید.';

  @override
  String get tapCastThisVideo =>
      'برای ارسال به تلویزیون روی «پخش این ویدیو» ضربه بزنید.';

  @override
  String get screenMirroringHelp => 'راهنمای آینه‌سازی صفحه';

  @override
  String get connectYourPhoneTo => 'گوشی را به Wi-Fi وصل کنید.';

  @override
  String get onTheTvOpen =>
      'روی تلویزیون، تنظیمات → شبکه را باز کنید و به همان Wi-Fi بپیوندید.';

  @override
  String get guestOrOfficeNetworks =>
      'شبکه‌های مهمان یا اداری اغلب آینه‌سازی را مسدود می‌کنند؛ از Wi-Fi خانه یا هات‌اسپات گوشی استفاده کنید.';

  @override
  String get turnOffVpn => 'VPN را خاموش کنید';

  @override
  String get aVpnHidesYour => 'VPN تلویزیون را از گوشی شما پنهان می‌کند.';

  @override
  String get pauseOrDisconnectYour =>
      'قبل از شروع، برنامه VPN را مکث یا قطع کنید.';

  @override
  String get youCanTurnIt => 'پس از پایان می‌توانید دوباره آن را روشن کنید.';

  @override
  String get turnOnMirroringOn => 'آینه‌سازی را روی تلویزیون روشن کنید';

  @override
  String get samsungLgAndMost =>
      'تلویزیون‌های سامسونگ، ال‌جی و بیشتر تلویزیون‌های Android آینه‌سازی را خودکار می‌پذیرند.';

  @override
  String get otherTvsOpenInput =>
      'تلویزیون‌های دیگر: ورودی / منبع را باز کنید و آینه‌سازی صفحه یا Miracast را انتخاب کنید.';

  @override
  String get keepTheTvOn =>
      'تا زمانی که گوشی وصل می‌شود، تلویزیون را روی همان صفحه نگه دارید.';

  @override
  String get tapStartAndPick =>
      'روی شروع ضربه بزنید و تلویزیون خود را انتخاب کنید';

  @override
  String get tapStartOnThe => 'در صفحه آینه‌سازی صفحه روی شروع ضربه بزنید.';

  @override
  String get androidOpensSmartView =>
      'Android، Smart View / Cast را باز می‌کند. در فهرست روی تلویزیون خود ضربه بزنید.';

  @override
  String get ifTheTvAsks =>
      'اگر تلویزیون پرسید، اجازه را انتخاب کنید یا PIN نمایش‌داده‌شده را وارد کنید.';

  @override
  String get youreMirroring => 'در حال آینه‌سازی هستید';

  @override
  String get everythingOnYourPhone =>
      'همه چیز گوشی شما اکنون روی تلویزیون نمایش داده می‌شود.';

  @override
  String get turnThePhoneSideways =>
      'برای ویدیوها و بازی‌های تمام‌صفحه، گوشی را بچرخانید.';

  @override
  String get toStopTapStop =>
      'برای توقف، روی توقف ضربه بزنید یا از اعلان پخش استفاده کنید.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'خاموش';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'تلویزیون اتاق خواب';

  @override
  String get officeDisplay => 'نمایشگر دفتر';

  @override
  String get clearHistory => 'تاریخچه پاک شود؟';

  @override
  String get thisRemovesEverythingYouve =>
      'این کار هر چیزی را که پخش کرده‌اید از این فهرست حذف می‌کند.';

  @override
  String get clear => 'پاک کردن';

  @override
  String get clearHistory2 => 'پاک کردن تاریخچه';

  @override
  String get noHistoryYet => 'هنوز تاریخچه‌ای نیست';

  @override
  String get everythingYouCastWill =>
      'هر چیزی که پخش کنید اینجا فهرست می‌شود تا دوباره آن را پیدا کنید.';

  @override
  String get today => 'امروز';

  @override
  String get yesterday => 'دیروز';

  @override
  String get earlier => 'قبل‌تر';

  @override
  String get swipeAnItemTo => 'برای حذف، یک مورد را بکشید';

  @override
  String get delete => 'حذف';

  @override
  String removed(Object title) {
    return '«$title» حذف شد';
  }

  @override
  String get undo => 'واگرد';

  @override
  String get photos => 'عکس‌ها';

  @override
  String get albums => 'آلبوم‌ها';

  @override
  String get videos => 'ویدیوها';

  @override
  String get gallery => 'گالری';

  @override
  String get music => 'موسیقی';

  @override
  String get songs => 'آهنگ‌ها';

  @override
  String get media => 'رسانه';

  @override
  String get browseTheWeb => 'مرور وب';

  @override
  String get goPro => 'دریافت Pro';

  @override
  String cast(Object title) {
    return 'پخش $title';
  }

  @override
  String get screenMirroringStartMirroring => 'آینه‌سازی صفحه. شروع آینه‌سازی';

  @override
  String readyToMirrorTo(Object device) {
    return 'آماده آینه‌سازی روی $device';
  }

  @override
  String get showYourPhoneOn =>
      'گوشی خود را به‌صورت زنده روی تلویزیون نمایش دهید.';

  @override
  String get startMirroring => 'شروع آینه‌سازی';

  @override
  String get tvRemote => 'ریموت تلویزیون';

  @override
  String get controlYourTv => 'تلویزیون خود را کنترل کنید';

  @override
  String get youtubeMore => 'YouTube و بیشتر';

  @override
  String get openTheBrowser => 'باز کردن مرورگر';

  @override
  String get searchOrTypeA => 'جستجو یا نوشتن نشانی وب‌سایت';

  @override
  String get howToConnectOpen => 'نحوه اتصال. باز کردن راهنمای تصویری';

  @override
  String get visualGuideForEvery => 'راهنمای تصویری برای هر قابلیت';

  @override
  String get language => 'زبان';

  @override
  String get done => 'انجام شد';

  @override
  String get enterAValidHttp =>
      'یک پیوند معتبر http(s) یا rtsp وارد کنید، مثلاً نشانی .m3u8 یا .mp4.';

  @override
  String get linkStream => 'پخش از پیوند';

  @override
  String get iptvLinkCast => 'IPTV / پخش پیوند';

  @override
  String get castALink => 'پخش یک پیوند';

  @override
  String get pasteADirectVideo =>
      'نشانی ویدیوی مستقیم، M3U8 یا جریان IPTV را جای‌گذاری کنید.';

  @override
  String get paste => 'جای‌گذاری';

  @override
  String get castLink => 'پخش پیوند';

  @override
  String get allowAccessToYour =>
      'برای پخش رسانه‌ها اجازه دسترسی بدهید. می‌توانید در تنظیمات تغییرش دهید.';

  @override
  String get video => 'ویدیو';

  @override
  String get castMusic => 'پخش موسیقی';

  @override
  String get noMusicFound => 'موسیقی‌ای پیدا نشد';

  @override
  String get addSongsToYour =>
      'آهنگ‌ها را به گوشی اضافه کنید تا اینجا نمایش داده شوند.';

  @override
  String get shuffle => 'تصادفی';

  @override
  String get playAll => 'پخش همه';

  @override
  String photo(Object formatShortDate) {
    return 'عکس · $formatShortDate';
  }

  @override
  String get photo2 => 'عکس';

  @override
  String get castPhotos => 'پخش عکس‌ها';

  @override
  String get select => 'انتخاب';

  @override
  String get noPhotosHere => 'اینجا عکسی نیست';

  @override
  String get photosYouTakeOr =>
      'عکس‌هایی که می‌گیرید یا ذخیره می‌کنید در این آلبوم نمایش داده می‌شوند.';

  @override
  String photos2(Object name, Object count) {
    return '$name، $count عکس';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'عکس مربوط به $formatShortDate';
  }

  @override
  String get allPhotos => 'همه عکس‌ها';

  @override
  String get slideshow => 'نمایش اسلاید';

  @override
  String get interval => 'فاصله';

  @override
  String get transition => 'گذار';

  @override
  String get fade => 'محو شدن';

  @override
  String get slide => 'لغزش';

  @override
  String get zoom => 'بزرگ‌نمایی';

  @override
  String get startSlideshow => 'شروع نمایش اسلاید';

  @override
  String get castVideos => 'پخش ویدیوها';

  @override
  String get noVideosYet => 'هنوز ویدیویی نیست';

  @override
  String get videosYouRecordOr =>
      'ویدیوهایی که ضبط یا دانلود می‌کنید اینجا آماده پخش نمایش داده می‌شوند.';

  @override
  String video2(Object resolution) {
    return 'ویدیو · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title، $formatDuration. پخش';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'نشست آینه‌سازی صفحه';

  @override
  String get mirroringDidntStartTap =>
      'آینه‌سازی شروع نشد. دوباره روی شروع ضربه بزنید و تلویزیون خود را از فهرست انتخاب کنید.';

  @override
  String get openSmartViewOr =>
      'برای آینه‌سازی، Smart View یا Cast را از تنظیمات سریع گوشی باز کنید.';

  @override
  String get quality => 'کیفیت';

  @override
  String get adjustsToYourWi =>
      'برای روان‌ترین تصویر با Wi-Fi شما سازگار می‌شود.';

  @override
  String upToLowerIt(Object label) {
    return 'تا $label. اگر تصویر می‌پرد، آن را کم کنید.';
  }

  @override
  String get stillNeedHelp => 'کمک بیشتری لازم دارید؟';

  @override
  String get startingScreenMirroring => 'در حال شروع آینه‌سازی صفحه…';

  @override
  String mirroringTo(Object value) {
    return 'در حال آینه‌سازی روی $value';
  }

  @override
  String get stopping => 'در حال توقف…';

  @override
  String get readyToMirror => 'آماده آینه‌سازی';

  @override
  String get beforeYouStart => 'قبل از شروع';

  @override
  String get phoneAndTvAre => 'گوشی و تلویزیون در یک Wi-Fi هستند';

  @override
  String get noVpnIsConnected => 'هیچ VPN‌ای روی گوشی شما متصل نیست';

  @override
  String get tvIsOnWith => 'تلویزیون روشن است و آینه‌سازی صفحه فعال است';

  @override
  String get phoneIsCloseTo => 'گوشی نزدیک تلویزیون است';

  @override
  String get stopMirroring => 'توقف آینه‌سازی';

  @override
  String get startMirroring2 => 'شروع آینه‌سازی';

  @override
  String get stop => 'توقف';

  @override
  String get start => 'شروع';

  @override
  String get duration => 'مدت';

  @override
  String get adIsLoading => 'در حال بارگذاری تبلیغ';

  @override
  String get ad => 'تبلیغ';

  @override
  String get mirrorYourScreenTo => 'صفحه خود را روی هر تلویزیونی آینه کنید';

  @override
  String get showYourPhoneOnThe =>
      'با یک ضربه گوشی را روی صفحه بزرگ نشان دهید؛ بدون کابل و دردسر.';

  @override
  String get shareMemoriesWithThe =>
      'خاطرات را با همه اتاق به اشتراک بگذارید و کنترل را در گوشی نگه دارید.';

  @override
  String get castFromWebApps => 'پخش از وب و برنامه‌ها';

  @override
  String get sendVideosFromYoutube =>
      'ویدیوهای YouTube، Facebook و هر وب‌سایتی را مستقیم به تلویزیون بفرستید.';

  @override
  String pageOf(Object value, Object length) {
    return 'صفحه $value از $length';
  }

  @override
  String get getStarted => 'شروع کنید';

  @override
  String get localNetwork => 'شبکه محلی';

  @override
  String get findTvsAndStreaming =>
      'تلویزیون‌ها و دستگاه‌های استریم را در Wi-Fi خود پیدا کنید.';

  @override
  String get notifications => 'اعلان‌ها';

  @override
  String get showCastingControlsWhile =>
      'هنگام استفاده از برنامه‌های دیگر، کنترل‌های پخش را نشان بده.';

  @override
  String get photosVideosMusic => 'عکس، ویدیو و موسیقی';

  @override
  String get pickWhatYouWantTo =>
      'آنچه می‌خواهید از گالری و کتابخانه پخش کنید را انتخاب کنید.';

  @override
  String get screenCapture => 'ضبط صفحه';

  @override
  String get mirrorYourScreenYoull =>
      'صفحه خود را آینه کنید. هر نشست را تأیید خواهید کرد.';

  @override
  String get webVideo => 'ویدیوی وب';

  @override
  String get link => 'پیوند';

  @override
  String get screenMirroring2 => 'آینه‌سازی صفحه';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'در حال پخش $title. باز کردن ریموت';
  }

  @override
  String castingTo2(Object value) {
    return 'در حال پخش روی $value';
  }

  @override
  String get nowCasting => 'اکنون در حال پخش';

  @override
  String get nothingIsCasting => 'چیزی پخش نمی‌شود';

  @override
  String get pickAPhotoVideo =>
      'یک عکس، ویدیو، آهنگ یا ویدیوی وب انتخاب کنید تا به تلویزیون بفرستید.';

  @override
  String get backToHome => 'بازگشت به خانه';

  @override
  String slide2(Object formatDuration) {
    return 'اسلاید $formatDuration';
  }

  @override
  String get back10Seconds => '۱۰ ثانیه عقب';

  @override
  String get forward10Seconds => '۱۰ ثانیه جلو';

  @override
  String get tvVolume => 'صدای تلویزیون';

  @override
  String tvVolumePercent(Object round) {
    return 'صدای تلویزیون $round درصد';
  }

  @override
  String get upNext => 'بعدی';

  @override
  String get addPhotos => 'افزودن عکس';

  @override
  String get addVideos => 'افزودن ویدیو';

  @override
  String get nothingElseInThe => 'چیز دیگری در صف نیست.';

  @override
  String play2(Object title) {
    return 'پخش $title';
  }

  @override
  String get unknownDevice => 'دستگاه ناشناس';

  @override
  String get perWeek => 'در هفته';

  @override
  String get perYear => 'در سال';

  @override
  String get payOnce => 'پرداخت یک‌باره';

  @override
  String get wirelessScreenMirroring => 'آینه‌سازی بی‌سیم صفحه';

  @override
  String get castVideosPhotosMusic => 'پخش ویدیو، عکس و موسیقی';

  @override
  String get fullTvRemoteControl => 'کنترل کامل ریموت تلویزیون';

  @override
  String get worksWithAllMajor => 'با همه تلویزیون‌های اصلی کار می‌کند';

  @override
  String get smoothLagFreeStreaming => 'استریم روان و بدون لگ';

  @override
  String get noAds => 'بدون تبلیغ';

  @override
  String get welcomeToCastflowPro => 'به CastFlow Pro خوش آمدید!';

  @override
  String get purchaseCancelled => 'خرید لغو شد.';

  @override
  String get purchasePendingProUnlocks =>
      'خرید در انتظار است. به‌محض تأیید فروشگاه، Pro فعال می‌شود.';

  @override
  String get purchaseFailedPleaseTry =>
      'خرید ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get theStoreIsntAvailable => 'فروشگاه اکنون در دسترس نیست.';

  @override
  String get close => 'بستن';

  @override
  String get goProWithCastflow => 'با CASTFLOW به PRO بروید';

  @override
  String get unlockEveryFeature => 'همه قابلیت‌ها را باز کنید';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'تا زمان لغو، خودکار تمدید می‌شود.';

  @override
  String get oneTimePurchaseNo => 'خرید یک‌باره. بدون اشتراک.';

  @override
  String get continueAction => 'ادامه';

  @override
  String get privacyPolicy => 'سیاست حریم خصوصی';

  @override
  String get termsAndConditions => 'شرایط و ضوابط';

  @override
  String get cancelAnytime => 'هر زمان لغو کنید';

  @override
  String get loadingPrice => 'در حال بارگذاری قیمت…';

  @override
  String get pricesUnavailableTapTo =>
      'قیمت‌ها در دسترس نیست · برای تلاش دوباره ضربه بزنید';

  @override
  String get noPlansAvailableRight => 'اکنون طرحی در دسترس نیست.';

  @override
  String get weekly => 'هفتگی';

  @override
  String get yearly => 'سالانه';

  @override
  String get lifetime => 'مادام‌العمر';

  @override
  String get bestValue => 'بهترین ارزش';

  @override
  String get disconnectFromTv => 'قطع اتصال از تلویزیون؟';

  @override
  String get thisStopsWhatIs =>
      'این کار آنچه را اکنون پخش یا آینه می‌شود متوقف می‌کند.';

  @override
  String get useTouchpad => 'استفاده از تاچ‌پد';

  @override
  String get useDPad => 'استفاده از کلیدهای جهت‌دار';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'گیرنده‌های $label دستورهای ریموت را نمی‌پذیرند.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'برخی دکمه‌ها در $label در دسترس نیستند.';
  }

  @override
  String get idle => 'بیکار';

  @override
  String get playing => 'در حال پخش';

  @override
  String get paused => 'مکث‌شده';

  @override
  String get noTvConnected => 'تلویزیونی متصل نیست';

  @override
  String get mute2 => 'بی‌صدا';

  @override
  String vol(Object volume) {
    return 'صدا $volume';
  }

  @override
  String get noTvConnectedTap =>
      'تلویزیونی متصل نیست. برای انتخاب دستگاه ضربه بزنید';

  @override
  String get tapToChooseA => 'برای انتخاب دستگاه ضربه بزنید';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label توسط $label2 پشتیبانی نمی‌شود';
  }

  @override
  String get touchpadSwipeToMove =>
      'تاچ‌پد. برای حرکت بکشید، برای انتخاب ضربه بزنید.';

  @override
  String get swipeToMoveTap => 'برای حرکت بکشید · برای انتخاب ضربه بزنید';

  @override
  String get navigationIsntSupportedBy =>
      'این تلویزیون از پیمایش پشتیبانی نمی‌کند';

  @override
  String get vol2 => 'صدا';

  @override
  String get auto => 'خودکار';

  @override
  String get automatic => 'خودکار';

  @override
  String get googleCastFirst => 'ابتدا Google Cast';

  @override
  String get dlnaUpnpFirst => 'ابتدا DLNA / UPnP';

  @override
  String get miracastFirst => 'ابتدا Miracast';

  @override
  String get tvOnly => 'فقط تلویزیون';

  @override
  String get phoneAndTv => 'گوشی و تلویزیون';

  @override
  String get phoneOnly => 'فقط گوشی';

  @override
  String get touchpad => 'تاچ‌پد';

  @override
  String get doMyPhoneAnd => 'آیا گوشی و تلویزیون من باید در یک Wi-Fi باشند؟';

  @override
  String get yesDiscoveryAndCasting =>
      'بله. جستجو و پخش در شبکه محلی شما انجام می‌شود، پس هر دو باید در یک Wi-Fi باشند (نام‌های باند مشابه ممکن است شبکه‌های متفاوتی باشند).';

  @override
  String get myRouterHasAp => 'روتر من «جداسازی AP / کلاینت» دارد';

  @override
  String get isolationBlocksDevicesFrom =>
      'جداسازی مانع دیدن دستگاه‌ها از همدیگر می‌شود. آن را در تنظیمات روتر خاموش کنید یا از شبکه‌ای غیر از مهمان استفاده کنید.';

  @override
  String get findingYourTv => 'پیدا کردن تلویزیون';

  @override
  String get myTvDoesntAppear => 'تلویزیون من در فهرست نمی‌آید';

  @override
  String get turnOnCastingScreen =>
      'پخش / آینه‌سازی صفحه را روی تلویزیون روشن کنید، آن را از حالت آماده‌باش بیدار کنید و روی اسکن دوباره ضربه بزنید. در صورت درخواست، مجوز شبکه محلی را بدهید.';

  @override
  String get onlySomeDevicesShow => 'فقط برخی دستگاه‌ها نمایش داده می‌شوند';

  @override
  String get olderTvsMayNeed =>
      'تلویزیون‌های قدیمی‌تر ممکن است به به‌روزرسانی سیستم‌افزار نیاز داشته باشند. تلویزیون‌های Miracast فقط وقتی دیده می‌شوند که ورودی «آینه‌سازی صفحه» باز باشد.';

  @override
  String get connectionFailsOrTimes => 'اتصال ناموفق است یا زمانش تمام می‌شود';

  @override
  String get restartTheTvApp =>
      'برنامه تلویزیون یا تلویزیون را راه‌اندازی مجدد کنید، به روتر نزدیک شوید و هر پیامی را که روی صفحه تلویزیون آمد بپذیرید.';

  @override
  String get itKeepsReconnectingTo => 'مدام به تلویزیون قدیمی وصل می‌شود';

  @override
  String get turnOffAutoConnect =>
      '«اتصال خودکار به آخرین تلویزیون» را در تنظیمات → پخش خاموش کنید.';

  @override
  String get mirroringIsLaggy => 'آینه‌سازی لگ دارد';

  @override
  String get chooseALowerQuality =>
      'کیفیت پایین‌تری (720p یا 480p) انتخاب کنید، برنامه‌های سنگین را ببندید و از شبکه Wi-Fi 5 گیگاهرتز استفاده کنید.';

  @override
  String get thePictureIsRotated => 'تصویر چرخیده یا بریده است';

  @override
  String get toggleAutoRotateOn =>
      'در صفحه آینه‌سازی صفحه، چرخش خودکار را روشن یا خاموش کنید.';

  @override
  String get sound => 'صدا';

  @override
  String get thereIsNoSound => 'روی تلویزیون صدا نیست';

  @override
  String get makeSureAudioIs =>
      'مطمئن شوید صدا در آینه‌سازی صفحه روشن است و تنظیمات → پخش → خروجی صدا را بررسی کنید. برخی گیرنده‌ها از صدای گوشی پشتیبانی نمی‌کنند.';

  @override
  String get tvRemote2 => 'ریموت تلویزیون';

  @override
  String get someRemoteButtonsAre => 'برخی دکمه‌های ریموت خاکستری هستند';

  @override
  String get eachReceiverSupportsDifferent =>
      'هر گیرنده دستورهای متفاوتی را پشتیبانی می‌کند. Chromecast و DLNA فقط پخش و صدا را پشتیبانی می‌کنند؛ Miracast کانال ریموت ندارد.';

  @override
  String get canCastflowTurnMy =>
      'آیا CastFlow می‌تواند تلویزیون را روشن کند یا ورودی را عوض کند؟';

  @override
  String get onlyOnTvsThat =>
      'فقط روی تلویزیون‌هایی که این دستورها را از طریق شبکه ارائه می‌دهند. دکمه‌های پشتیبانی‌نشده به‌جای تظاهر به کار کردن غیرفعال می‌شوند.';

  @override
  String get helpFaq => 'راهنما و پرسش‌های متداول';

  @override
  String get stepByStepConnection => 'راهنمای گام‌به‌گام اتصال';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'برنامه ایمیلی پیدا نشد.';

  @override
  String get enjoyingCastflow => 'از CastFlow راضی هستید؟';

  @override
  String get sorryToHearThat => 'متأسفیم که این را می‌شنویم';

  @override
  String get thanksHowCanWe => 'ممنون! چگونه می‌توانیم بهتر شویم؟';

  @override
  String get wereGladYouLike => 'خوشحالیم که خوشتان آمد!';

  @override
  String get youMadeOurDay => 'روزمان را ساختید!';

  @override
  String get tapToExit => 'برای خروج ضربه بزنید';

  @override
  String get selectARating => 'یک امتیاز انتخاب کنید';

  @override
  String get sendFeedback => 'ارسال بازخورد';

  @override
  String get rateUs => 'به ما امتیاز دهید';

  @override
  String get rateYourExperienceBefore =>
      'قبل از رفتن، تجربه‌تان را امتیاز دهید.';

  @override
  String get tapAStarTo =>
      'برای امتیاز دادن به CastFlow روی یک ستاره ضربه بزنید.';

  @override
  String get general => 'عمومی';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'کیفیت پیش‌فرض';

  @override
  String get autoConnectToLast => 'اتصال خودکار به آخرین تلویزیون';

  @override
  String get hapticFeedback => 'بازخورد لمسی';

  @override
  String get clearCastingHistory => 'پاک کردن تاریخچه پخش';

  @override
  String get clearCastingHistory2 => 'تاریخچه پخش پاک شود؟';

  @override
  String get onlyCastflowsListIs =>
      'فقط فهرست CastFlow پاک می‌شود. رسانه‌های گوشی شما هرگز حذف نمی‌شوند.';

  @override
  String get appearance => 'ظاهر';

  @override
  String get light => 'روشن';

  @override
  String get dark => 'تاریک';

  @override
  String get system => 'سیستم';

  @override
  String get aboutSupport => 'درباره و پشتیبانی';

  @override
  String get rateApp => 'امتیاز به برنامه';

  @override
  String get feedback => 'بازخورد';

  @override
  String get termsConditions => 'شرایط و ضوابط';

  @override
  String get version => 'نسخه';

  @override
  String get castflowProIsActive => 'CastFlow Pro فعال است';

  @override
  String get upgradeToPremium => 'ارتقا به Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'از حمایت شما سپاسگزاریم. از پخش بدون تبلیغ لذت ببرید.';

  @override
  String get noAds1080pMirroring => 'بدون تبلیغ، آینه‌سازی 1080p و پخش نامحدود';

  @override
  String get upgrade => 'ارتقا';

  @override
  String get mirrorCastBeautifullySimple => 'آینه و پخش کنید، ساده و زیبا';

  @override
  String get thisActionMayContain => 'این کار ممکن است شامل تبلیغ باشد';

  @override
  String get webCast => 'پخش وب';

  @override
  String get castThisVideo => 'پخش این ویدیو';

  @override
  String get searchOrTypeAWeb => 'جستجو یا نوشتن نشانی وب';

  @override
  String get removeBookmark => 'حذف نشانک';

  @override
  String get bookmark => 'نشانک';

  @override
  String get quickAccess => 'دسترسی سریع';

  @override
  String open2(Object title) {
    return 'باز کردن $title';
  }

  @override
  String get bookmarks => 'نشانک‌ها';

  @override
  String get noBookmarks => 'نشانکی نیست';

  @override
  String get tapTheBookmarkIcon =>
      'برای ذخیره یک صفحه، روی نماد نشانک در نوار نشانی ضربه بزنید.';

  @override
  String get noHistory => 'تاریخچه‌ای نیست';

  @override
  String get pagesYouVisitShow =>
      'صفحه‌هایی که بازدید می‌کنید اینجا نمایش داده می‌شوند.';

  @override
  String get remove => 'حذف';

  @override
  String resultOn(Object value, Object host) {
    return 'نتیجه $value در $host';
  }

  @override
  String get aSimulatedPageResult => 'یک نتیجه صفحه شبیه‌سازی‌شده';

  @override
  String get videosOnThisPage => 'ویدیوهای این صفحه';

  @override
  String get pickOneToSend => 'یکی را انتخاب کنید تا به تلویزیون بفرستید.';

  @override
  String get onboardHotspotTitle => 'وای‌فای ندارید؟ از هات‌اسپات استفاده کنید';

  @override
  String get onboardHotspotBody =>
      'هات‌اسپات گوشی را روشن کنید و تلویزیون را به آن وصل کنید. پخش درست مثل وای‌فای کار می‌کند.';

  @override
  String get stillCantFindTitle => 'هنوز تلویزیون را پیدا نکردید؟';

  @override
  String get stillCantFindBody => 'تلویزیون را به هات‌اسپات گوشی وصل کنید:';

  @override
  String get hotspotStep4 =>
      'روی تلاش دوباره بزنید و تلویزیون را از فهرست انتخاب کنید';

  @override
  String get castOverHotspot =>
      'وای‌فای ندارید؟ از طریق هات‌اسپات گوشی پخش کنید:';

  @override
  String get queue => 'صف پخش';

  @override
  String get addMusic => 'افزودن موسیقی';

  @override
  String get connectWithWifi => 'اتصال به Wi-Fi';

  @override
  String get continueWithHotspot => 'ادامه با هات‌اسپات';

  @override
  String get noWifiAlertMessage =>
      'شما از اینترنت همراه استفاده می‌کنید. گوشی و تلویزیون را به یک Wi-Fi وصل کنید، یا هات‌اسپات گوشی را روشن کنید و تلویزیون را به آن وصل کنید.';
}
