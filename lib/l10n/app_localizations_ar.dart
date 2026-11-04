// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get networkRequiredTitle => 'غير متصل بشبكة Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'يجب أن يكون هاتفك والتلفاز على شبكة Wi-Fi نفسها للبث.';

  @override
  String get openWifiSettings => 'فتح إعدادات Wi-Fi';

  @override
  String get useMobileHotspot => 'استخدام نقطة اتصال الجوال';

  @override
  String get hotspotInstruction => 'وصّل التلفاز بنقطة اتصال هاتفك.';

  @override
  String get hotspotStep1 => 'شغّل نقطة اتصال الجوال';

  @override
  String get hotspotStep2 => 'وصّل التلفاز بها';

  @override
  String get hotspotStep3 => 'ارجع إلى التطبيق';

  @override
  String get openHotspotSettings => 'فتح إعدادات نقطة الاتصال';

  @override
  String get hotspotAutoCheck => 'سنتحقق مرة أخرى تلقائيًا عند عودتك.';

  @override
  String get hotspotDetected => 'نقطة الاتصال تعمل. جارٍ البحث عن التلفاز…';

  @override
  String get searchingDevices => 'جارٍ البحث عن الأجهزة القريبة...';

  @override
  String get waitingForTvOnHotspot =>
      'بانتظار انضمام التلفاز إلى نقطة الاتصال…';

  @override
  String get usingHotspot => 'يتم استخدام نقطة اتصال الجوال';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count أجهزة',
      one: 'تم العثور على جهاز واحد',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get scanAgain => 'إعادة البحث';

  @override
  String get isolationTitle => 'التلفاز لا يستجيب';

  @override
  String get isolationHint =>
      'انضم جهاز إلى نقطة الاتصال لكنه لا يستجيب. قد تحجب نقطة الاتصال الاتصال بين الأجهزة (عزل العملاء). أوقف ذلك في إعدادات نقطة الاتصال أو استخدم شبكة Wi-Fi.';

  @override
  String get connecting => 'جارٍ الاتصال…';

  @override
  String get connected => 'متصل';

  @override
  String get connectionFailed => 'تعذّر الاتصال';

  @override
  String get connectFailedHint =>
      'تأكد من أن الهاتف والتلفاز على الشبكة نفسها ثم حاول مجددًا.';

  @override
  String get hotspotConnectHint =>
      'قد تحجب نقطة الاتصال الاتصال بين الأجهزة. تحقق من إعداد عزل العملاء.';

  @override
  String get networkLostTitle => 'انقطع اتصال الشبكة';

  @override
  String get networkLostMessage =>
      'أعد الاتصال بشبكة Wi-Fi أو نقطة الاتصال ثم أعد الاتصال بالتلفاز.';

  @override
  String get reconnect => 'إعادة الاتصال';

  @override
  String reconnectTo(String name) {
    return 'إعادة الاتصال بـ $name';
  }

  @override
  String get tapToReconnect => 'اضغط لإعادة الاتصال';

  @override
  String get pairingRequired => 'الاقتران مطلوب';

  @override
  String get pairingEnterCode => 'أدخل الرمز الظاهر على التلفاز.';

  @override
  String get pairingApproveOnTv => 'انظر إلى التلفاز واضغط على سماح للمتابعة.';

  @override
  String get connect => 'اتصال';

  @override
  String get cancel => 'إلغاء';

  @override
  String get pairingIncorrectCode => 'الرمز غير صحيح. حاول مجددًا.';

  @override
  String get pairingTimedOut => 'انتهت مهلة الاقتران';

  @override
  String get tryAgain => 'حاول مجددًا';

  @override
  String get pairingDeclined => 'رفض التلفاز الاتصال';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'رموز خاطئة كثيرة. انتظر $seconds ث ثم اطلب رمزًا جديدًا.';
  }

  @override
  String get pairingCooldownOver => 'يمكنك الآن طلب رمز جديد.';

  @override
  String get pairingRequestNewCode => 'طلب رمز جديد';

  @override
  String get pairingNetworkLost =>
      'فُقدت الشبكة أثناء الاقتران. أعد الاتصال بشبكة Wi-Fi وحاول مجددًا.';

  @override
  String get pairingFailed => 'تعذّر الاقتران بالتلفاز.';

  @override
  String pairingCodeField(int length) {
    return 'رمز الاقتران، $length خانات';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'الخانة $index من $total';
  }

  @override
  String get pairingEmptyBox => 'فارغ';

  @override
  String get pairingPaired => 'تم الاقتران';

  @override
  String get forgetDevice => 'نسيان الجهاز';

  @override
  String forgetDeviceMessage(String name) {
    return 'سيحتاج $name إلى الاقتران مرة أخرى في المرة القادمة.';
  }

  @override
  String get forget => 'نسيان';

  @override
  String get castVideo => 'بث الفيديو';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count فيديوهات. بث الفيديو',
      one: 'تم العثور على فيديو واحد. بث الفيديو',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'لم يتم العثور على فيديو في هذه الصفحة بعد.';

  @override
  String get videoFound => 'تم العثور على فيديو';

  @override
  String get videoFoundMessage => 'شغّله على التلفاز.';

  @override
  String get castAction => 'بث';

  @override
  String get dismiss => 'إغلاق';

  @override
  String videosFound(int count) {
    return 'الفيديوهات الموجودة ($count)';
  }

  @override
  String get castToTv => 'بث إلى التلفاز';

  @override
  String get protectedVideo => 'محمي، لا يمكن بثه';

  @override
  String get videoThumbnail => 'صورة الفيديو المصغرة';

  @override
  String castingTo(String device) {
    return 'البث إلى $device';
  }

  @override
  String get stopCasting => 'إيقاف البث';

  @override
  String get play => 'تشغيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get volume => 'مستوى الصوت';

  @override
  String get seekPosition => 'موضع التشغيل';

  @override
  String get showControls => 'إظهار عناصر التحكم';

  @override
  String get hideControls => 'إخفاء عناصر التحكم';

  @override
  String get formatUnsupportedTitle => 'التنسيق غير مدعوم';

  @override
  String formatUnsupported(String device, String format) {
    return 'لا يمكن لـ $device تشغيل فيديوهات $format. جرّب فيديو آخر في هذه الصفحة أو استخدم عرض الشاشة.';
  }

  @override
  String get videoExpired =>
      'انتهت صلاحية رابط الفيديو. أعد تحميل الصفحة وحاول مجددًا.';

  @override
  String get refreshingVideo => 'جارٍ الحصول على رابط فيديو جديد…';

  @override
  String get browserBack => 'رجوع';

  @override
  String get browserForward => 'للأمام';

  @override
  String get browserStartPage => 'الصفحة الرئيسية';

  @override
  String get browserReload => 'إعادة تحميل';

  @override
  String get ok => 'حسنًا';

  @override
  String get home => 'الرئيسية';

  @override
  String get devices => 'الأجهزة';

  @override
  String get history => 'السجل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get couldntOpenTheLink => 'تعذّر فتح الرابط.';

  @override
  String get castflowLogo => 'شعار CastFlow';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get weCouldntLoadThis => 'تعذّر تحميل هذا الآن. حاول مجددًا.';

  @override
  String get apps => 'التطبيقات';

  @override
  String open(Object name) {
    return 'فتح $name';
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
  String get up => 'أعلى';

  @override
  String get down => 'أسفل';

  @override
  String get left => 'يسار';

  @override
  String get right => 'يمين';

  @override
  String get menu => 'القائمة';

  @override
  String get input => 'الإدخال';

  @override
  String get playPause => 'تشغيل / إيقاف مؤقت';

  @override
  String get previous => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String get rewind => 'رجوع سريع';

  @override
  String get volumeUp => 'رفع الصوت';

  @override
  String get volumeDown => 'خفض الصوت';

  @override
  String get mute => 'كتم';

  @override
  String connectedTo(Object name) {
    return 'متصل بـ $name';
  }

  @override
  String get chooseADevice => 'اختر جهازًا';

  @override
  String get connectionGuide => 'دليل الاتصال';

  @override
  String get lookingForTvsOn => 'جارٍ البحث عن تلفازات على شبكة Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return 'تم العثور على $found حتى الآن';
  }

  @override
  String deviceFound(Object found, Object value) {
    return 'تم العثور على $found أجهزة';
  }

  @override
  String get disconnect => 'قطع الاتصال';

  @override
  String signalOf4(Object level) {
    return 'الإشارة $level من 4';
  }

  @override
  String get connecting2 => 'جارٍ الاتصال';

  @override
  String get theTvRemoteNeeds =>
      'يحتاج جهاز التحكم إلى تلفاز متصل. اختر واحدًا أدناه.';

  @override
  String get connectToATv => 'اتصل بتلفاز للمتابعة.';

  @override
  String get findingTvs => 'جارٍ البحث عن التلفازات…';

  @override
  String get makeSureYourTv => 'تأكد من تشغيل التلفاز';

  @override
  String get notConnected => 'غير متصل';

  @override
  String get tapToFindYour => 'اضغط للبحث عن تلفازك';

  @override
  String get connectionFailed2 => 'فشل الاتصال';

  @override
  String tapToManageDevices(Object label) {
    return '$label. اضغط لإدارة الأجهزة';
  }

  @override
  String get joinTheSameWi => 'اتصل بشبكة Wi-Fi نفسها';

  @override
  String get connectYourPhoneAnd => 'وصّل هاتفك والتلفاز بشبكة Wi-Fi نفسها.';

  @override
  String get turnOnCastingOn => 'شغّل البث على التلفاز';

  @override
  String get enableScreenMirroringMiracast =>
      'فعّل عرض الشاشة أو Miracast أو Google Cast من إعدادات التلفاز.';

  @override
  String get scanForDevices => 'البحث عن الأجهزة';

  @override
  String get openDevicesInCastflow =>
      'افتح الأجهزة في CastFlow وانتظر بضع ثوانٍ حتى يظهر التلفاز.';

  @override
  String get tapConnect => 'اضغط على اتصال';

  @override
  String get acceptThePromptOn => 'اقبل الطلب على التلفاز إن ظهر. هذا كل شيء!';

  @override
  String get howToConnect => 'كيفية الاتصال';

  @override
  String get fourQuickStepsTo =>
      'أربع خطوات سريعة للانتقال إلى الشاشة الكبيرة.';

  @override
  String get gotIt => 'فهمت';

  @override
  String step(Object number, Object title, Object body) {
    return 'الخطوة $number. $title. $body';
  }

  @override
  String get homeWiFi => 'شبكة Wi-Fi المنزلية';

  @override
  String get router => 'الراوتر';

  @override
  String get settingsConnection => 'الإعدادات › الاتصال';

  @override
  String get inputHdmi1 => 'الإدخال: HDMI 1';

  @override
  String get screenMirroring => 'عرض الشاشة';

  @override
  String get networkHomeWiFi => 'الشبكة: Wi-Fi المنزلية';

  @override
  String get livingRoomTv => 'تلفاز غرفة المعيشة';

  @override
  String get allowCastflowToConnect => 'السماح لـ CastFlow بالاتصال؟';

  @override
  String get deny => 'رفض';

  @override
  String get allow => 'سماح';

  @override
  String get yourTv => 'تلفازك';

  @override
  String get findYourTv => 'ابحث عن تلفازك';

  @override
  String connectTo(Object name) {
    return 'الاتصال بـ $name';
  }

  @override
  String connected2(Object label) {
    return 'متصل · $label';
  }

  @override
  String get openTvRemote => 'فتح ريموت التلفاز';

  @override
  String get sameWiFiNetwork => 'شبكة Wi-Fi نفسها';

  @override
  String get yourPhoneAndTv =>
      'يجب أن يكون هاتفك والتلفاز متصلين بشبكة Wi-Fi نفسها.';

  @override
  String get tvIsOnAnd => 'التلفاز يعمل وجاهز';

  @override
  String get turnOnScreenMirroring =>
      'فعّل عرض الشاشة أو Cast أو Miracast على التلفاز.';

  @override
  String get noVpnOrGuest => 'لا VPN ولا شبكة ضيوف';

  @override
  String get vpnsAndGuestIsolated =>
      'شبكات VPN وشبكات Wi-Fi للضيوف أو المعزولة تخفي الأجهزة عن بعضها.';

  @override
  String get localNetworkAccess => 'الوصول إلى الشبكة المحلية';

  @override
  String get allowCastflowToFind =>
      'اسمح لـ CastFlow بالعثور على الأجهزة في شبكتك عند الطلب.';

  @override
  String get noTvFound => 'لم يتم العثور على تلفاز';

  @override
  String get checkThatYourPhone =>
      'تأكد أن هاتفك والتلفاز على شبكة Wi-Fi نفسها ثم أعد البحث.';

  @override
  String get noWiFiRouter => 'لا يوجد راوتر Wi-Fi؟ استخدم نقطة الاتصال';

  @override
  String searchingForTvsFound(Object length) {
    return 'جارٍ البحث عن تلفازات. تم العثور على $length.';
  }

  @override
  String tvsFound(Object length) {
    return 'تم العثور على $length تلفازات';
  }

  @override
  String get connectToYourTv => 'اتصل بتلفازك';

  @override
  String get connectYourPhoneAndTv => 'وصّل هاتفك والتلفاز بشبكة Wi-Fi نفسها.';

  @override
  String get turnOnTheTv => 'شغّل التلفاز وافتح مدخل عرض الشاشة / Cast.';

  @override
  String get tapTheConnectionBar =>
      'اضغط على شريط الاتصال في الرئيسية للبحث عن تلفازك.';

  @override
  String get tapConnectAndAccept =>
      'اضغط على اتصال واقبل الطلب على التلفاز إن ظهر.';

  @override
  String get mirrorYourScreen => 'اعرض شاشتك';

  @override
  String get connectToYourTvFirst => 'اتصل بتلفازك أولًا.';

  @override
  String get openScreenMirroringFrom => 'افتح عرض الشاشة من الرئيسية.';

  @override
  String get pickAQualityAnd => 'اختر الجودة واضغط على ابدأ.';

  @override
  String get allowScreenCaptureWhen =>
      'اسمح بتسجيل الشاشة عندما يطلب Android ذلك.';

  @override
  String get castPhotosVideosMusic => 'بث الصور والفيديوهات والموسيقى';

  @override
  String get openPhotosVideosOr =>
      'افتح الصور أو الفيديوهات أو الموسيقى في الرئيسية.';

  @override
  String get pickWhatYouWant => 'اختر ما تريد عرضه.';

  @override
  String get itPlaysOnThe =>
      'يُشغَّل على التلفاز؛ تحكّم به من الهاتف أو من الإشعار.';

  @override
  String get useTheTvRemote => 'استخدم ريموت التلفاز';

  @override
  String get openTvRemoteOn => 'افتح ريموت التلفاز في الرئيسية.';

  @override
  String get useTheDPad =>
      'استخدم أزرار الاتجاهات أو اسحب على لوحة اللمس للتنقل، واضغط OK للاختيار.';

  @override
  String get buttonsATvDoesnt => 'الأزرار التي لا يدعمها التلفاز تظهر باهتة.';

  @override
  String get castFromTheWeb => 'البث من الويب والتطبيقات';

  @override
  String get tapTheBrowserBar =>
      'اضغط على شريط المتصفح أو على تطبيق في الرئيسية.';

  @override
  String get playAVideoOn => 'شغّل فيديو في الموقع.';

  @override
  String get tapCastThisVideo =>
      'اضغط على «بث هذا الفيديو» لإرساله إلى التلفاز.';

  @override
  String get screenMirroringHelp => 'مساعدة عرض الشاشة';

  @override
  String get connectYourPhoneTo => 'وصّل هاتفك بشبكة Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'على التلفاز، افتح الإعدادات ← الشبكة واتصل بشبكة Wi-Fi نفسها.';

  @override
  String get guestOrOfficeNetworks =>
      'شبكات الضيوف أو المكاتب غالبًا تمنع العرض؛ استخدم Wi-Fi المنزل أو نقطة اتصال هاتفك.';

  @override
  String get turnOffVpn => 'أوقف VPN';

  @override
  String get aVpnHidesYour => 'يخفي VPN تلفازك عن هاتفك.';

  @override
  String get pauseOrDisconnectYour =>
      'أوقف تطبيق VPN مؤقتًا أو افصله قبل البدء.';

  @override
  String get youCanTurnIt => 'يمكنك تشغيله مجددًا عند الانتهاء.';

  @override
  String get turnOnMirroringOn => 'فعّل العرض على التلفاز';

  @override
  String get samsungLgAndMost =>
      'تقبل تلفازات Samsung وLG ومعظم تلفازات Android العرض تلقائيًا.';

  @override
  String get otherTvsOpenInput =>
      'تلفازات أخرى: افتح الإدخال / المصدر واختر عرض الشاشة أو Miracast.';

  @override
  String get keepTheTvOn => 'أبقِ التلفاز على تلك الشاشة أثناء اتصال هاتفك.';

  @override
  String get tapStartAndPick => 'اضغط على ابدأ واختر تلفازك';

  @override
  String get tapStartOnThe => 'اضغط على ابدأ في شاشة عرض الشاشة.';

  @override
  String get androidOpensSmartView =>
      'يفتح Android خيار Smart View / Cast. اضغط على تلفازك في القائمة.';

  @override
  String get ifTheTvAsks =>
      'إذا طلب التلفاز ذلك، اختر سماح أو أدخل رمز PIN الظاهر على الشاشة.';

  @override
  String get youreMirroring => 'أنت تعرض الشاشة';

  @override
  String get everythingOnYourPhone => 'كل ما في هاتفك يظهر الآن على التلفاز.';

  @override
  String get turnThePhoneSideways =>
      'أدر الهاتف أفقيًا لعرض الفيديوهات والألعاب بملء الشاشة.';

  @override
  String get toStopTapStop => 'للإيقاف، اضغط على إيقاف أو استخدم إشعار البث.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'متوقف';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'تلفاز غرفة النوم';

  @override
  String get officeDisplay => 'شاشة المكتب';

  @override
  String get clearHistory => 'مسح السجل؟';

  @override
  String get thisRemovesEverythingYouve =>
      'سيؤدي هذا إلى إزالة كل ما بثثته من هذه القائمة.';

  @override
  String get clear => 'مسح';

  @override
  String get clearHistory2 => 'مسح السجل';

  @override
  String get noHistoryYet => 'لا يوجد سجل بعد';

  @override
  String get everythingYouCastWill => 'كل ما تبثه سيظهر هنا لتجده مجددًا.';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get earlier => 'سابقًا';

  @override
  String get swipeAnItemTo => 'اسحب عنصرًا لإزالته';

  @override
  String get delete => 'حذف';

  @override
  String removed(Object title) {
    return 'تمت إزالة «$title»';
  }

  @override
  String get undo => 'تراجع';

  @override
  String get photos => 'الصور';

  @override
  String get albums => 'الألبومات';

  @override
  String get videos => 'الفيديوهات';

  @override
  String get gallery => 'المعرض';

  @override
  String get music => 'الموسيقى';

  @override
  String get songs => 'الأغاني';

  @override
  String get media => 'الوسائط';

  @override
  String get browseTheWeb => 'تصفح الويب';

  @override
  String get goPro => 'اشترك في Pro';

  @override
  String cast(Object title) {
    return 'بث $title';
  }

  @override
  String get screenMirroringStartMirroring => 'عرض الشاشة. ابدأ العرض';

  @override
  String readyToMirrorTo(Object device) {
    return 'جاهز للعرض على $device';
  }

  @override
  String get showYourPhoneOn => 'اعرض هاتفك على التلفاز مباشرة.';

  @override
  String get startMirroring => 'ابدأ عرض الشاشة';

  @override
  String get tvRemote => 'ريموت التلفاز';

  @override
  String get controlYourTv => 'تحكّم في تلفازك';

  @override
  String get youtubeMore => 'YouTube والمزيد';

  @override
  String get openTheBrowser => 'افتح المتصفح';

  @override
  String get searchOrTypeA => 'ابحث أو اكتب موقعًا';

  @override
  String get howToConnectOpen => 'كيفية الاتصال. افتح الدليل المصوّر';

  @override
  String get visualGuideForEvery => 'دليل مصوّر لكل ميزة';

  @override
  String get language => 'اللغة';

  @override
  String get done => 'تم';

  @override
  String get enterAValidHttp =>
      'أدخل رابط http(s) أو rtsp صالحًا، مثل رابط .m3u8 أو .mp4.';

  @override
  String get linkStream => 'بث عبر رابط';

  @override
  String get iptvLinkCast => 'IPTV / بث رابط';

  @override
  String get castALink => 'بث رابط';

  @override
  String get pasteADirectVideo => 'الصق رابط فيديو مباشر أو M3U8 أو بث IPTV.';

  @override
  String get paste => 'لصق';

  @override
  String get castLink => 'بث الرابط';

  @override
  String get allowAccessToYour =>
      'اسمح بالوصول إلى وسائطك لبثها. يمكنك تغيير ذلك في الإعدادات.';

  @override
  String get video => 'فيديو';

  @override
  String get castMusic => 'بث الموسيقى';

  @override
  String get noMusicFound => 'لم يتم العثور على موسيقى';

  @override
  String get addSongsToYour => 'أضف أغاني إلى هاتفك وستظهر هنا.';

  @override
  String get shuffle => 'عشوائي';

  @override
  String get playAll => 'تشغيل الكل';

  @override
  String photo(Object formatShortDate) {
    return 'صورة · $formatShortDate';
  }

  @override
  String get photo2 => 'صورة';

  @override
  String get castPhotos => 'بث الصور';

  @override
  String get select => 'تحديد';

  @override
  String get noPhotosHere => 'لا توجد صور هنا';

  @override
  String get photosYouTakeOr =>
      'الصور التي تلتقطها أو تحفظها ستظهر في هذا الألبوم.';

  @override
  String photos2(Object name, Object count) {
    return '$name، $count صور';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'صورة من $formatShortDate';
  }

  @override
  String get allPhotos => 'كل الصور';

  @override
  String get slideshow => 'عرض شرائح';

  @override
  String get interval => 'الفاصل';

  @override
  String get transition => 'الانتقال';

  @override
  String get fade => 'تلاشٍ';

  @override
  String get slide => 'انزلاق';

  @override
  String get zoom => 'تكبير';

  @override
  String get startSlideshow => 'ابدأ عرض الشرائح';

  @override
  String get castVideos => 'بث الفيديوهات';

  @override
  String get noVideosYet => 'لا توجد فيديوهات بعد';

  @override
  String get videosYouRecordOr =>
      'الفيديوهات التي تسجلها أو تنزّلها ستظهر هنا جاهزة للبث.';

  @override
  String video2(Object resolution) {
    return 'فيديو · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title، $formatDuration. بث';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'جلسة عرض الشاشة';

  @override
  String get mirroringDidntStartTap =>
      'لم يبدأ العرض. اضغط على ابدأ مجددًا واختر تلفازك من القائمة.';

  @override
  String get openSmartViewOr =>
      'افتح Smart View أو Cast من الإعدادات السريعة في هاتفك للعرض.';

  @override
  String get quality => 'الجودة';

  @override
  String get adjustsToYourWi =>
      'تتكيّف مع شبكة Wi-Fi لديك للحصول على أسلس صورة.';

  @override
  String upToLowerIt(Object label) {
    return 'حتى $label. خفّضها إذا تقطّعت الصورة.';
  }

  @override
  String get stillNeedHelp => 'تحتاج مساعدة؟';

  @override
  String get startingScreenMirroring => 'جارٍ بدء عرض الشاشة…';

  @override
  String mirroringTo(Object value) {
    return 'العرض على $value';
  }

  @override
  String get stopping => 'جارٍ الإيقاف…';

  @override
  String get readyToMirror => 'جاهز للعرض';

  @override
  String get beforeYouStart => 'قبل أن تبدأ';

  @override
  String get phoneAndTvAre => 'الهاتف والتلفاز على شبكة Wi-Fi نفسها';

  @override
  String get noVpnIsConnected => 'لا يوجد VPN متصل على هاتفك';

  @override
  String get tvIsOnWith => 'التلفاز يعمل وعرض الشاشة مفعّل';

  @override
  String get phoneIsCloseTo => 'الهاتف قريب من التلفاز';

  @override
  String get stopMirroring => 'إيقاف العرض';

  @override
  String get startMirroring2 => 'بدء العرض';

  @override
  String get stop => 'إيقاف';

  @override
  String get start => 'ابدأ';

  @override
  String get duration => 'المدة';

  @override
  String get adIsLoading => 'جارٍ تحميل الإعلان';

  @override
  String get ad => 'إعلان';

  @override
  String get mirrorYourScreenTo => 'اعرض شاشتك على أي تلفاز';

  @override
  String get showYourPhoneOnThe =>
      'اعرض هاتفك على الشاشة الكبيرة بضغطة واحدة، بلا كابلات ولا تعقيد.';

  @override
  String get shareMemoriesWithThe => 'شارك الذكريات مع الجميع وتحكّم من هاتفك.';

  @override
  String get castFromWebApps => 'البث من الويب والتطبيقات';

  @override
  String get sendVideosFromYoutube =>
      'أرسل فيديوهات YouTube وFacebook وأي موقع مباشرة إلى التلفاز.';

  @override
  String pageOf(Object value, Object length) {
    return 'الصفحة $value من $length';
  }

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get localNetwork => 'الشبكة المحلية';

  @override
  String get findTvsAndStreaming =>
      'ابحث عن تلفازات وأجهزة البث على شبكة Wi-Fi.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get showCastingControlsWhile =>
      'أظهر عناصر التحكم في البث أثناء استخدام تطبيقات أخرى.';

  @override
  String get photosVideosMusic => 'الصور والفيديوهات والموسيقى';

  @override
  String get pickWhatYouWantTo => 'اختر ما تريد بثه من المعرض والمكتبة.';

  @override
  String get screenCapture => 'تسجيل الشاشة';

  @override
  String get mirrorYourScreenYoull => 'اعرض شاشتك. ستؤكد كل جلسة.';

  @override
  String get webVideo => 'فيديو من الويب';

  @override
  String get link => 'رابط';

  @override
  String get screenMirroring2 => 'عرض الشاشة';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'جارٍ بث $title. افتح الريموت';
  }

  @override
  String castingTo2(Object value) {
    return 'البث إلى $value';
  }

  @override
  String get nowCasting => 'قيد البث الآن';

  @override
  String get nothingIsCasting => 'لا شيء يُبث';

  @override
  String get pickAPhotoVideo =>
      'اختر صورة أو فيديو أو أغنية أو فيديو ويب لإرساله إلى التلفاز.';

  @override
  String get backToHome => 'العودة إلى الرئيسية';

  @override
  String slide2(Object formatDuration) {
    return 'شريحة $formatDuration';
  }

  @override
  String get back10Seconds => 'رجوع 10 ثوانٍ';

  @override
  String get forward10Seconds => 'تقدم 10 ثوانٍ';

  @override
  String get tvVolume => 'صوت التلفاز';

  @override
  String tvVolumePercent(Object round) {
    return 'صوت التلفاز $round بالمئة';
  }

  @override
  String get upNext => 'التالي';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get addVideos => 'إضافة فيديوهات';

  @override
  String get nothingElseInThe => 'لا يوجد شيء آخر في قائمة الانتظار.';

  @override
  String play2(Object title) {
    return 'تشغيل $title';
  }

  @override
  String get unknownDevice => 'جهاز غير معروف';

  @override
  String get perWeek => 'أسبوعيًا';

  @override
  String get perYear => 'سنويًا';

  @override
  String get payOnce => 'دفعة واحدة';

  @override
  String get wirelessScreenMirroring => 'عرض الشاشة لاسلكيًا';

  @override
  String get castVideosPhotosMusic => 'بث الفيديوهات والصور والموسيقى';

  @override
  String get fullTvRemoteControl => 'تحكم كامل في التلفاز';

  @override
  String get worksWithAllMajor => 'يعمل مع كل التلفازات الرئيسية';

  @override
  String get smoothLagFreeStreaming => 'بث سلس بدون تقطيع';

  @override
  String get noAds => 'بدون إعلانات';

  @override
  String get welcomeToCastflowPro => 'مرحبًا بك في CastFlow Pro!';

  @override
  String get purchaseCancelled => 'تم إلغاء الشراء.';

  @override
  String get purchasePendingProUnlocks =>
      'الشراء معلّق. سيُفعَّل Pro فور تأكيد المتجر.';

  @override
  String get purchaseFailedPleaseTry => 'فشل الشراء. حاول مجددًا.';

  @override
  String get theStoreIsntAvailable => 'المتجر غير متاح حاليًا.';

  @override
  String get close => 'إغلاق';

  @override
  String get goProWithCastflow => 'اشترك في PRO مع CASTFLOW';

  @override
  String get unlockEveryFeature => 'افتح كل الميزات';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'يتجدد تلقائيًا حتى يتم الإلغاء.';

  @override
  String get oneTimePurchaseNo => 'شراء لمرة واحدة. بدون اشتراك.';

  @override
  String get continueAction => 'متابعة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get cancelAnytime => 'ألغِ في أي وقت';

  @override
  String get loadingPrice => 'جارٍ تحميل السعر…';

  @override
  String get pricesUnavailableTapTo =>
      'الأسعار غير متاحة · اضغط لإعادة المحاولة';

  @override
  String get noPlansAvailableRight => 'لا توجد خطط متاحة حاليًا.';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get yearly => 'سنوي';

  @override
  String get lifetime => 'مدى الحياة';

  @override
  String get bestValue => 'أفضل قيمة';

  @override
  String get disconnectFromTv => 'قطع الاتصال بالتلفاز؟';

  @override
  String get thisStopsWhatIs =>
      'سيؤدي هذا إلى إيقاف ما يُشغَّل أو يُعرض حاليًا.';

  @override
  String get useTouchpad => 'استخدام لوحة اللمس';

  @override
  String get useDPad => 'استخدام أزرار الاتجاهات';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'أجهزة الاستقبال $label لا تقبل أوامر التحكم عن بُعد.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'بعض الأزرار غير متاحة على $label.';
  }

  @override
  String get idle => 'خامل';

  @override
  String get playing => 'قيد التشغيل';

  @override
  String get paused => 'متوقف مؤقتًا';

  @override
  String get noTvConnected => 'لا يوجد تلفاز متصل';

  @override
  String get mute2 => 'كتم';

  @override
  String vol(Object volume) {
    return 'الصوت $volume';
  }

  @override
  String get noTvConnectedTap => 'لا يوجد تلفاز متصل. اضغط لاختيار جهاز';

  @override
  String get tapToChooseA => 'اضغط لاختيار جهاز';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label غير مدعوم من $label2';
  }

  @override
  String get touchpadSwipeToMove => 'لوحة اللمس. اسحب للتحرك واضغط للاختيار.';

  @override
  String get swipeToMoveTap => 'اسحب للتحرك · اضغط للاختيار';

  @override
  String get navigationIsntSupportedBy => 'هذا التلفاز لا يدعم التنقل';

  @override
  String get vol2 => 'الصوت';

  @override
  String get auto => 'تلقائي';

  @override
  String get automatic => 'تلقائي';

  @override
  String get googleCastFirst => 'Google Cast أولًا';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP أولًا';

  @override
  String get miracastFirst => 'Miracast أولًا';

  @override
  String get tvOnly => 'التلفاز فقط';

  @override
  String get phoneAndTv => 'الهاتف والتلفاز';

  @override
  String get phoneOnly => 'الهاتف فقط';

  @override
  String get touchpad => 'لوحة اللمس';

  @override
  String get doMyPhoneAnd => 'هل يحتاج هاتفي والتلفاز إلى شبكة Wi-Fi نفسها؟';

  @override
  String get yesDiscoveryAndCasting =>
      'نعم. البحث والبث يبقيان على شبكتك المحلية، لذا يجب أن يكون كلاهما على شبكة Wi-Fi نفسها (أسماء النطاقات المتشابهة قد تكون شبكات مختلفة).';

  @override
  String get myRouterHasAp => 'الراوتر لدي يحتوي على «عزل AP / العملاء»';

  @override
  String get isolationBlocksDevicesFrom =>
      'العزل يمنع الأجهزة من رؤية بعضها. أوقفه في إعدادات الراوتر أو استخدم شبكة غير خاصة بالضيوف.';

  @override
  String get findingYourTv => 'العثور على تلفازك';

  @override
  String get myTvDoesntAppear => 'تلفازي لا يظهر في القائمة';

  @override
  String get turnOnCastingScreen =>
      'فعّل البث / عرض الشاشة على التلفاز، أيقظه من وضع الاستعداد ثم اضغط على إعادة البحث. اسمح بإذن الشبكة المحلية إن طُلب.';

  @override
  String get onlySomeDevicesShow => 'تظهر بعض الأجهزة فقط';

  @override
  String get olderTvsMayNeed =>
      'قد تحتاج التلفازات الأقدم إلى تحديث للبرنامج الثابت. تلفازات Miracast تظهر فقط أثناء فتح مدخل «عرض الشاشة».';

  @override
  String get connectionFailsOrTimes => 'يفشل الاتصال أو تنتهي مهلته';

  @override
  String get restartTheTvApp =>
      'أعد تشغيل تطبيق التلفاز أو التلفاز، اقترب من الراوتر واقبل أي طلب يظهر على شاشة التلفاز.';

  @override
  String get itKeepsReconnectingTo => 'يستمر في إعادة الاتصال بتلفاز قديم';

  @override
  String get turnOffAutoConnect =>
      'أوقف «الاتصال التلقائي بآخر تلفاز» في الإعدادات ← البث.';

  @override
  String get mirroringIsLaggy => 'العرض متقطع';

  @override
  String get chooseALowerQuality =>
      'اختر جودة أقل (720p أو 480p)، وأغلق التطبيقات الثقيلة، واستخدم شبكة Wi-Fi بتردد 5 غيغاهرتز.';

  @override
  String get thePictureIsRotated => 'الصورة مقلوبة أو مقصوصة';

  @override
  String get toggleAutoRotateOn => 'بدّل التدوير التلقائي في شاشة عرض الشاشة.';

  @override
  String get sound => 'الصوت';

  @override
  String get thereIsNoSound => 'لا يوجد صوت على التلفاز';

  @override
  String get makeSureAudioIs =>
      'تأكد من تفعيل الصوت في عرض الشاشة وتحقق من الإعدادات ← البث ← مخرج الصوت. بعض أجهزة الاستقبال لا تدعم صوت الهاتف.';

  @override
  String get tvRemote2 => 'ريموت التلفاز';

  @override
  String get someRemoteButtonsAre => 'بعض أزرار الريموت باهتة';

  @override
  String get eachReceiverSupportsDifferent =>
      'كل جهاز استقبال يدعم أوامر مختلفة. Chromecast وDLNA يدعمان التشغيل والصوت فقط؛ ولا توجد قناة ريموت في Miracast.';

  @override
  String get canCastflowTurnMy =>
      'هل يمكن لـ CastFlow تشغيل تلفازي أو تغيير المدخل؟';

  @override
  String get onlyOnTvsThat =>
      'فقط على التلفازات التي تتيح هذه الأوامر عبر الشبكة. الأزرار غير المدعومة تُعطَّل بدل أن تتظاهر بالعمل.';

  @override
  String get helpFaq => 'المساعدة والأسئلة الشائعة';

  @override
  String get stepByStepConnection => 'دليل الاتصال خطوة بخطوة';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'لم يتم العثور على تطبيق بريد.';

  @override
  String get enjoyingCastflow => 'هل يعجبك CastFlow؟';

  @override
  String get sorryToHearThat => 'يؤسفنا سماع ذلك';

  @override
  String get thanksHowCanWe => 'شكرًا! كيف يمكننا التحسين؟';

  @override
  String get wereGladYouLike => 'يسعدنا أنه أعجبك!';

  @override
  String get youMadeOurDay => 'لقد أسعدت يومنا!';

  @override
  String get tapToExit => 'اضغط للخروج';

  @override
  String get selectARating => 'اختر تقييمًا';

  @override
  String get sendFeedback => 'إرسال ملاحظات';

  @override
  String get rateUs => 'قيّمنا';

  @override
  String get rateYourExperienceBefore => 'قيّم تجربتك قبل أن تغادر.';

  @override
  String get tapAStarTo => 'اضغط على نجمة لتقييم CastFlow.';

  @override
  String get general => 'عام';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'الجودة الافتراضية';

  @override
  String get autoConnectToLast => 'الاتصال التلقائي بآخر تلفاز';

  @override
  String get hapticFeedback => 'الاستجابة اللمسية';

  @override
  String get clearCastingHistory => 'مسح سجل البث';

  @override
  String get clearCastingHistory2 => 'مسح سجل البث؟';

  @override
  String get onlyCastflowsListIs =>
      'يُمسح سجل CastFlow فقط. لا تُحذف الوسائط من هاتفك أبدًا.';

  @override
  String get appearance => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get aboutSupport => 'حول التطبيق والدعم';

  @override
  String get rateApp => 'قيّم التطبيق';

  @override
  String get feedback => 'ملاحظات';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get version => 'الإصدار';

  @override
  String get castflowProIsActive => 'CastFlow Pro مفعّل';

  @override
  String get upgradeToPremium => 'الترقية إلى Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport => 'شكرًا لدعمك. استمتع بالبث بدون إعلانات.';

  @override
  String get noAds1080pMirroring => 'بدون إعلانات، عرض 1080p وبث غير محدود';

  @override
  String get upgrade => 'ترقية';

  @override
  String get mirrorCastBeautifullySimple => 'اعرض وابث بكل بساطة';

  @override
  String get thisActionMayContain => 'قد يحتوي هذا الإجراء على إعلانات';

  @override
  String get webCast => 'بث الويب';

  @override
  String get castThisVideo => 'بث هذا الفيديو';

  @override
  String get searchOrTypeAWeb => 'ابحث أو اكتب عنوان ويب';

  @override
  String get removeBookmark => 'إزالة الإشارة المرجعية';

  @override
  String get bookmark => 'إشارة مرجعية';

  @override
  String get quickAccess => 'وصول سريع';

  @override
  String open2(Object title) {
    return 'فتح $title';
  }

  @override
  String get bookmarks => 'الإشارات المرجعية';

  @override
  String get noBookmarks => 'لا توجد إشارات مرجعية';

  @override
  String get tapTheBookmarkIcon =>
      'اضغط على أيقونة الإشارة المرجعية في شريط العنوان لحفظ صفحة.';

  @override
  String get noHistory => 'لا يوجد سجل';

  @override
  String get pagesYouVisitShow => 'الصفحات التي تزورها تظهر هنا.';

  @override
  String get remove => 'إزالة';

  @override
  String resultOn(Object value, Object host) {
    return 'النتيجة $value على $host';
  }

  @override
  String get aSimulatedPageResult => 'نتيجة صفحة تجريبية';

  @override
  String get videosOnThisPage => 'فيديوهات في هذه الصفحة';

  @override
  String get pickOneToSend => 'اختر واحدًا لإرساله إلى التلفاز.';

  @override
  String get onboardHotspotTitle => 'لا يوجد Wi-Fi؟ استخدم نقطة الاتصال';

  @override
  String get onboardHotspotBody =>
      'شغّل نقطة اتصال هاتفك وأوصل التلفزيون بها. يعمل البث تمامًا كما في Wi-Fi.';

  @override
  String get stillCantFindTitle => 'لم تجد تلفزيونك بعد؟';

  @override
  String get stillCantFindBody => 'أوصل التلفزيون بنقطة اتصال هاتفك:';

  @override
  String get hotspotStep4 => 'اضغط إعادة المحاولة واختر تلفزيونك من القائمة';

  @override
  String get castOverHotspot => 'لا يوجد Wi-Fi؟ ابثّ عبر نقطة اتصال هاتفك:';

  @override
  String get queue => 'قائمة الانتظار';

  @override
  String get addMusic => 'إضافة موسيقى';

  @override
  String get connectWithWifi => 'الاتصال بشبكة Wi-Fi';

  @override
  String get continueWithHotspot => 'المتابعة عبر نقطة الاتصال';

  @override
  String get noWifiAlertMessage =>
      'أنت تستخدم بيانات الجوال. وصّل الهاتف والتلفاز بشبكة Wi-Fi نفسها، أو شغّل نقطة اتصال الهاتف واتصل بها من التلفاز.';
}
