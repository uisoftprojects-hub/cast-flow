// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get networkRequiredTitle => 'Wi-Fi ga ulanmagan';

  @override
  String get networkRequiredMessage =>
      'Translyatsiya qilish uchun telefon va televizor bir xil Wi-Fi tarmog‘ida bo‘lishi kerak.';

  @override
  String get openWifiSettings => 'Wi-Fi sozlamalarini ochish';

  @override
  String get useMobileHotspot => 'Mobil hotspotdan foydalanish';

  @override
  String get hotspotInstruction =>
      'LCD/televizoringizni mobil hotspotga ulang.';

  @override
  String get hotspotStep1 => 'Mobil hotspotni yoqing';

  @override
  String get hotspotStep2 => 'Televizoringizni unga ulang';

  @override
  String get hotspotStep3 => 'Ilovaga qayting';

  @override
  String get openHotspotSettings => 'Hotspot sozlamalarini ochish';

  @override
  String get hotspotAutoCheck =>
      'Qaytganingizda biz avtomatik qayta tekshiramiz.';

  @override
  String get hotspotDetected =>
      'Hotspot yoqilgan. Televizoringiz qidirilmoqda…';

  @override
  String get searchingDevices => 'Yaqin atrofdagi qurilmalar qidirilmoqda...';

  @override
  String get waitingForTvOnHotspot =>
      'Televizoringiz hotspotga qo‘shilishi kutilmoqda…';

  @override
  String get usingHotspot => 'Mobil hotspotingizdan foydalanilmoqda';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta qurilma topildi',
      one: '1 ta qurilma topildi',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Qayta urinish';

  @override
  String get scanAgain => 'Qayta skanerlash';

  @override
  String get isolationTitle => 'Televizor javob bermayapti';

  @override
  String get isolationHint =>
      'Qurilma hotspotingizga qo‘shildi, lekin javob bermayapti. Hotspotingiz qurilmalar o‘rtasidagi trafikni bloklayotgan bo‘lishi mumkin (mijozlarni ajratish). Buni hotspot sozlamalarida o‘chiring yoki Wi-Fi tarmog‘idan foydalaning.';

  @override
  String get connecting => 'Ulanmoqda…';

  @override
  String get connected => 'Ulangan';

  @override
  String get connectionFailed => 'Ulanib bo‘lmadi';

  @override
  String get connectFailedHint =>
      'Telefon va televizor bir xil tarmoqda ekanini tekshiring, so‘ng qayta urinib ko‘ring.';

  @override
  String get hotspotConnectHint =>
      'Hotspotingiz qurilmalar o‘rtasidagi trafikni bloklayotgan bo‘lishi mumkin. Mijozlarni ajratish sozlamasini tekshiring.';

  @override
  String get networkLostTitle => 'Tarmoq aloqasi uzildi';

  @override
  String get networkLostMessage =>
      'Wi-Fi yoki hotspotga qayta ulaning, so‘ng televizorga qayta ulaning.';

  @override
  String get reconnect => 'Qayta ulanish';

  @override
  String reconnectTo(String name) {
    return '$name ga qayta ulanish';
  }

  @override
  String get tapToReconnect => 'Qayta ulanish uchun bosing';

  @override
  String get pairingRequired => 'Juftlash talab qilinadi';

  @override
  String get pairingEnterCode => 'Televizorda ko‘rsatilgan kodni kiriting.';

  @override
  String get pairingApproveOnTv =>
      'Televizoringizga qarang va davom etish uchun “Ruxsat berish” tugmasini bosing.';

  @override
  String get connect => 'Ulanish';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get pairingIncorrectCode => 'Kod noto‘g‘ri. Qayta urinib ko‘ring.';

  @override
  String get pairingTimedOut => 'Juftlash vaqti tugadi';

  @override
  String get tryAgain => 'Qayta urinish';

  @override
  String get pairingDeclined => 'Televizor ulanishni rad etdi';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Noto‘g‘ri kodlar juda ko‘p. $seconds s kuting, so‘ng yangi kod so‘rang.';
  }

  @override
  String get pairingCooldownOver => 'Endi yangi kod so‘rashingiz mumkin.';

  @override
  String get pairingRequestNewCode => 'Yangi kod so‘rash';

  @override
  String get pairingNetworkLost =>
      'Juftlash vaqtida tarmoq uzildi. Wi-Fi ga qayta ulaning va qayta urinib ko‘ring.';

  @override
  String get pairingFailed => 'Televizor bilan juftlab bo‘lmadi.';

  @override
  String pairingCodeField(int length) {
    return 'Juftlash kodi, $length ta belgi';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return '$total ta kod katagidan $index-si';
  }

  @override
  String get pairingEmptyBox => 'bo‘sh';

  @override
  String get pairingPaired => 'Juftlangan';

  @override
  String get forgetDevice => 'Qurilmani unutish';

  @override
  String forgetDeviceMessage(String name) {
    return '$name keyingi safar yana juftlanishi kerak bo‘ladi.';
  }

  @override
  String get forget => 'Unutish';

  @override
  String get castVideo => 'Videoni translyatsiya qilish';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta video topildi. Videoni translyatsiya qilish',
      one: '1 ta video topildi. Videoni translyatsiya qilish',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Bu sahifada hali video topilmadi.';

  @override
  String get videoFound => 'Video topildi';

  @override
  String get videoFoundMessage => 'Uni televizorda ijro eting.';

  @override
  String get castAction => 'Translyatsiya';

  @override
  String get dismiss => 'Yopish';

  @override
  String videosFound(int count) {
    return 'Topilgan videolar ($count)';
  }

  @override
  String get castToTv => 'Televizorga translyatsiya';

  @override
  String get protectedVideo => 'Himoyalangan, translyatsiya qilib bo‘lmaydi';

  @override
  String get videoThumbnail => 'Video eskizi';

  @override
  String castingTo(String device) {
    return '$device ga translyatsiya qilinmoqda';
  }

  @override
  String get stopCasting => 'Translyatsiyani to‘xtatish';

  @override
  String get play => 'Ijro etish';

  @override
  String get pause => 'Pauza';

  @override
  String get volume => 'Ovoz balandligi';

  @override
  String get seekPosition => 'Ijro joyi';

  @override
  String get showControls => 'Boshqaruvni ko‘rsatish';

  @override
  String get hideControls => 'Boshqaruvni yashirish';

  @override
  String get formatUnsupportedTitle => 'Format qo‘llab-quvvatlanmaydi';

  @override
  String formatUnsupported(String device, String format) {
    return '$device $format videolarini ijro eta olmaydi. Shu sahifadagi boshqa videoni sinab ko‘ring yoki ekran akslantirishdan foydalaning.';
  }

  @override
  String get videoExpired =>
      'Bu video havolasi eskirgan. Sahifani qayta yuklab, yana urinib ko‘ring.';

  @override
  String get refreshingVideo => 'Yangi video havolasi olinmoqda…';

  @override
  String get browserBack => 'Orqaga';

  @override
  String get browserForward => 'Oldinga';

  @override
  String get browserStartPage => 'Boshlang‘ich sahifa';

  @override
  String get browserReload => 'Qayta yuklash';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Bosh sahifa';

  @override
  String get devices => 'Qurilmalar';

  @override
  String get history => 'Tarix';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get goodMorning => 'Xayrli tong';

  @override
  String get goodAfternoon => 'Xayrli kun';

  @override
  String get goodEvening => 'Xayrli kech';

  @override
  String get couldntOpenTheLink => 'Havolani ochib bo‘lmadi.';

  @override
  String get castflowLogo => 'Televizorga translyatsiya logotipi';

  @override
  String get somethingWentWrong => 'Nimadir xato ketdi';

  @override
  String get weCouldntLoadThis =>
      'Buni hozir yuklab bo‘lmadi. Qayta urinib ko‘ring.';

  @override
  String get apps => 'Ilovalar';

  @override
  String open(Object name) {
    return '$name ni ochish';
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
  String get up => 'Yuqoriga';

  @override
  String get down => 'Pastga';

  @override
  String get left => 'Chapga';

  @override
  String get right => 'O‘ngga';

  @override
  String get menu => 'Menyu';

  @override
  String get input => 'Kirish';

  @override
  String get playPause => 'Ijro / Pauza';

  @override
  String get previous => 'Oldingi';

  @override
  String get next => 'Keyingi';

  @override
  String get rewind => 'Orqaga o‘tkazish';

  @override
  String get volumeUp => 'Ovozni oshirish';

  @override
  String get volumeDown => 'Ovozni pasaytirish';

  @override
  String get mute => 'Ovozni o‘chirish';

  @override
  String connectedTo(Object name) {
    return '$name ga ulangan';
  }

  @override
  String get chooseADevice => 'Qurilmani tanlang';

  @override
  String get connectionGuide => 'Ulanish qo‘llanmasi';

  @override
  String get lookingForTvsOn =>
      'Wi-Fi tarmog‘ingizdagi televizorlar qidirilmoqda';

  @override
  String foundSoFar(Object found) {
    return 'Hozircha $found ta topildi';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found ta qurilma$value topildi';
  }

  @override
  String get disconnect => 'Uzish';

  @override
  String signalOf4(Object level) {
    return 'Signal: 4 dan $level';
  }

  @override
  String get connecting2 => 'Ulanmoqda';

  @override
  String get theTvRemoteNeeds =>
      'Televizor pulti uchun ulangan televizor kerak. Quyida birini tanlang.';

  @override
  String get connectToATv => 'Davom etish uchun televizorga ulaning.';

  @override
  String get findingTvs => 'Televizorlar qidirilmoqda…';

  @override
  String get makeSureYourTv =>
      'Televizoringiz yoqilganiga ishonch hosil qiling';

  @override
  String get notConnected => 'Ulanmagan';

  @override
  String get tapToFindYour => 'Televizoringizni topish uchun bosing';

  @override
  String get connectionFailed2 => 'Ulanish amalga oshmadi';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Qurilmalarni boshqarish uchun bosing';
  }

  @override
  String get joinTheSameWi => 'Bir xil Wi-Fi ga qo‘shiling';

  @override
  String get connectYourPhoneAnd =>
      'Telefon va televizoringizni bir xil Wi-Fi tarmog‘iga ulang.';

  @override
  String get turnOnCastingOn => 'Televizoringizda translyatsiyani yoqing';

  @override
  String get enableScreenMirroringMiracast =>
      'Televizor sozlamalarida Ekran akslantirish, Miracast yoki Google Cast ni yoqing.';

  @override
  String get scanForDevices => 'Qurilmalarni skanerlash';

  @override
  String get openDevicesInCastflow =>
      'Televizorga translyatsiya ilovasida Qurilmalarni oching va televizoringiz paydo bo‘lishini bir necha soniya kuting.';

  @override
  String get tapConnect => '“Ulanish” tugmasini bosing';

  @override
  String get acceptThePromptOn =>
      'Televizorda so‘rov chiqsa, uni qabul qiling. Hammasi shu!';

  @override
  String get howToConnect => 'Qanday ulanish kerak';

  @override
  String get fourQuickStepsTo => 'Katta ekranga to‘rtta tez qadam.';

  @override
  String get gotIt => 'Tushunarli';

  @override
  String step(Object number, Object title, Object body) {
    return '$number-qadam. $title. $body';
  }

  @override
  String get homeWiFi => 'Uy Wi-Fi tarmog‘i';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Sozlamalar › Ulanish';

  @override
  String get inputHdmi1 => 'Kirish: HDMI 1';

  @override
  String get screenMirroring => 'Ekran akslantirish';

  @override
  String get networkHomeWiFi => 'Tarmoq: uy Wi-Fi tarmog‘i';

  @override
  String get livingRoomTv => 'Mehmonxonadagi televizor';

  @override
  String get allowCastflowToConnect =>
      'Televizorga translyatsiyaga ulanishga ruxsat berasizmi?';

  @override
  String get deny => 'Rad etish';

  @override
  String get allow => 'Ruxsat berish';

  @override
  String get yourTv => 'Televizoringiz';

  @override
  String get findYourTv => 'Televizoringizni toping';

  @override
  String connectTo(Object name) {
    return '$name ga ulanish';
  }

  @override
  String connected2(Object label) {
    return 'Ulangan · $label';
  }

  @override
  String get openTvRemote => 'Televizor pultini ochish';

  @override
  String get sameWiFiNetwork => 'Bir xil Wi-Fi tarmog‘i';

  @override
  String get yourPhoneAndTv =>
      'Telefon va televizor bir xil Wi-Fi ga ulangan bo‘lishi kerak.';

  @override
  String get tvIsOnAnd => 'Televizor yoqilgan va tayyor';

  @override
  String get turnOnScreenMirroring =>
      'Televizorda Ekran akslantirish, Cast yoki Miracast ni yoqing.';

  @override
  String get noVpnOrGuest => 'VPN va mehmon tarmog‘i yo‘q';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN va mehmon / ajratilgan Wi-Fi qurilmalarni bir-biridan yashiradi.';

  @override
  String get localNetworkAccess => 'Mahalliy tarmoqqa kirish';

  @override
  String get allowCastflowToFind =>
      'So‘ralganda Televizorga translyatsiyaga tarmog‘ingizdagi qurilmalarni topishga ruxsat bering.';

  @override
  String get noTvFound => 'Televizor topilmadi';

  @override
  String get checkThatYourPhone =>
      'Telefon va televizor bir xil Wi-Fi ga ulanganini tekshiring, so‘ng yana skanerlang.';

  @override
  String get noWiFiRouter => 'Wi-Fi router yo‘qmi? Hotspotdan foydalaning';

  @override
  String searchingForTvsFound(Object length) {
    return 'Televizorlar qidirilmoqda. $length ta topildi.';
  }

  @override
  String tvsFound(Object length) {
    return '$length ta televizor topildi';
  }

  @override
  String get connectToYourTv => 'Televizoringizga ulaning';

  @override
  String get connectYourPhoneAndTv =>
      'Telefon va televizoringizni bir xil Wi-Fi tarmog‘iga ulang.';

  @override
  String get turnOnTheTv =>
      'Televizorni yoqing va uning Ekran akslantirish / Cast kirishini oching.';

  @override
  String get tapTheConnectionBar =>
      'Televizoringizni topish uchun Bosh sahifadagi ulanish panelini bosing.';

  @override
  String get tapConnectAndAccept =>
      '“Ulanish” tugmasini bosing va televizorda so‘rov chiqsa, uni qabul qiling.';

  @override
  String get mirrorYourScreen => 'Ekraningizni akslantiring';

  @override
  String get connectToYourTvFirst => 'Avval televizoringizga ulaning.';

  @override
  String get openScreenMirroringFrom =>
      'Bosh sahifadan Ekran akslantirishni oching.';

  @override
  String get pickAQualityAnd =>
      'Sifatni tanlang va “Boshlash” tugmasini bosing.';

  @override
  String get allowScreenCaptureWhen =>
      'Android so‘raganda ekranni yozib olishga ruxsat bering.';

  @override
  String get castPhotosVideosMusic =>
      'Rasm, video va musiqani translyatsiya qiling';

  @override
  String get openPhotosVideosOr =>
      'Bosh sahifada Rasmlar, Videolar yoki Musiqani oching.';

  @override
  String get pickWhatYouWant => 'Nimani ko‘rsatmoqchi ekaningizni tanlang.';

  @override
  String get itPlaysOnThe =>
      'U televizorda ijro etiladi; telefoningiz yoki bildirishnoma orqali boshqaring.';

  @override
  String get useTheTvRemote => 'Televizor pultidan foydalaning';

  @override
  String get openTvRemoteOn => 'Bosh sahifada Televizor pultini oching.';

  @override
  String get useTheDPad =>
      'Harakatlanish uchun D-pad dan foydalaning yoki sensorli panelda suring, tanlash uchun OK ni bosing.';

  @override
  String get buttonsATvDoesnt =>
      'Televizor qo‘llab-quvvatlamaydigan tugmalar kulrang bo‘ladi.';

  @override
  String get castFromTheWeb => 'Veb va ilovalardan translyatsiya qiling';

  @override
  String get tapTheBrowserBar =>
      'Bosh sahifada brauzer paneli yoki ilovani bosing.';

  @override
  String get playAVideoOn => 'Saytda videoni ijro eting.';

  @override
  String get tapCastThisVideo =>
      'Televizoringizga yuborish uchun “Bu videoni translyatsiya qilish” tugmasini bosing.';

  @override
  String get screenMirroringHelp => 'Ekran akslantirish bo‘yicha yordam';

  @override
  String get connectYourPhoneTo => 'Telefoningizni Wi-Fi ga ulang.';

  @override
  String get onTheTvOpen =>
      'Televizorda Sozlamalar → Tarmoq bo‘limini oching va bir xil Wi-Fi ga qo‘shiling.';

  @override
  String get guestOrOfficeNetworks =>
      'Mehmon yoki ofis tarmoqlari ko‘pincha akslantirishni bloklaydi; uy Wi-Fi tarmog‘i yoki telefon hotspotidan foydalaning.';

  @override
  String get turnOffVpn => 'VPN ni o‘chirish';

  @override
  String get aVpnHidesYour => 'VPN televizoringizni telefoningizdan yashiradi.';

  @override
  String get pauseOrDisconnectYour =>
      'Boshlashdan oldin VPN ilovangizni to‘xtating yoki uzing.';

  @override
  String get youCanTurnIt => 'Tugatgach, uni yana yoqishingiz mumkin.';

  @override
  String get turnOnMirroringOn => 'Televizorda akslantirishni yoqing';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG va aksariyat Android televizorlar akslantirishni avtomatik qabul qiladi.';

  @override
  String get otherTvsOpenInput =>
      'Boshqa televizorlar: Kirish / Manba bo‘limini oching va Ekran akslantirish yoki Miracast ni tanlang.';

  @override
  String get keepTheTvOn =>
      'Telefon ulanayotganda televizorni shu ekranda qoldiring.';

  @override
  String get tapStartAndPick =>
      '“Boshlash” tugmasini bosing va televizoringizni tanlang';

  @override
  String get tapStartOnThe =>
      'Ekran akslantirish ekranida “Boshlash” tugmasini bosing.';

  @override
  String get androidOpensSmartView =>
      'Android Smart View / Cast ni ochadi. Ro‘yxatdan televizoringizni bosing.';

  @override
  String get ifTheTvAsks =>
      'Televizor so‘rasa, “Ruxsat berish” ni tanlang yoki ekrandagi PIN kodni kiriting.';

  @override
  String get youreMirroring => 'Siz akslantiryapsiz';

  @override
  String get everythingOnYourPhone =>
      'Telefoningizdagi hamma narsa endi televizorda ko‘rinadi.';

  @override
  String get turnThePhoneSideways =>
      'To‘liq ekranli video va o‘yinlar uchun telefonni yonboshiga buring.';

  @override
  String get toStopTapStop =>
      'To‘xtatish uchun “To‘xtatish” tugmasini bosing yoki translyatsiya bildirishnomasidan foydalaning.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'O‘chiq';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'Yotoqxonadagi televizor';

  @override
  String get officeDisplay => 'Ofis displeyi';

  @override
  String get clearHistory => 'Tarix tozalansinmi?';

  @override
  String get thisRemovesEverythingYouve =>
      'Bu translyatsiya qilgan hamma narsangizni ushbu ro‘yxatdan olib tashlaydi.';

  @override
  String get clear => 'Tozalash';

  @override
  String get clearHistory2 => 'Tarixni tozalash';

  @override
  String get noHistoryYet => 'Hali tarix yo‘q';

  @override
  String get everythingYouCastWill =>
      'Translyatsiya qilgan hamma narsangiz shu yerda ro‘yxatga olinadi, shunda uni qayta topishingiz mumkin.';

  @override
  String get today => 'Bugun';

  @override
  String get yesterday => 'Kecha';

  @override
  String get earlier => 'Avvalroq';

  @override
  String get swipeAnItemTo => 'O‘chirish uchun elementni suring';

  @override
  String get delete => 'O‘chirish';

  @override
  String removed(Object title) {
    return '“$title” olib tashlandi';
  }

  @override
  String get undo => 'Bekor qilish';

  @override
  String get photos => 'Rasmlar';

  @override
  String get albums => 'Albomlar';

  @override
  String get videos => 'Videolar';

  @override
  String get gallery => 'Galereya';

  @override
  String get music => 'Musiqa';

  @override
  String get songs => 'Qo‘shiqlar';

  @override
  String get media => 'Media';

  @override
  String get browseTheWeb => 'Veb-sahifalarni ko‘rish';

  @override
  String get goPro => 'Pro ga o‘tish';

  @override
  String cast(Object title) {
    return '$title ni translyatsiya qilish';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Ekran akslantirish. Akslantirishni boshlash';

  @override
  String readyToMirrorTo(Object device) {
    return '$device ga akslantirishga tayyor';
  }

  @override
  String get showYourPhoneOn =>
      'Telefoningizni televizorda real vaqtda ko‘rsating.';

  @override
  String get startMirroring => 'Akslantirishni boshlash';

  @override
  String get tvRemote => 'Televizor pulti';

  @override
  String get controlYourTv => 'Televizoringizni boshqaring';

  @override
  String get youtubeMore => 'YouTube va boshqalar';

  @override
  String get openTheBrowser => 'Brauzerni ochish';

  @override
  String get searchOrTypeA => 'Veb-sayt qidiring yoki kiriting';

  @override
  String get howToConnectOpen =>
      'Qanday ulanish kerak. Vizual qo‘llanmani ochish';

  @override
  String get visualGuideForEvery => 'Har bir funksiya uchun vizual qo‘llanma';

  @override
  String get language => 'Til';

  @override
  String get done => 'Tayyor';

  @override
  String get enterAValidHttp =>
      'To‘g‘ri http(s) yoki rtsp havolasini kiriting, masalan, .m3u8 yoki .mp4 URL.';

  @override
  String get linkStream => 'Havola oqimi';

  @override
  String get iptvLinkCast => 'IPTV / Havola translyatsiyasi';

  @override
  String get castALink => 'Havolani translyatsiya qilish';

  @override
  String get pasteADirectVideo =>
      'To‘g‘ridan-to‘g‘ri video, M3U8 yoki IPTV oqimi URL manzilini joylashtiring.';

  @override
  String get paste => 'Joylashtirish';

  @override
  String get castLink => 'Havolani translyatsiya qilish';

  @override
  String get allowAccessToYour =>
      'Translyatsiya qilish uchun mediangizga kirishga ruxsat bering. Buni Sozlamalarda o‘zgartirishingiz mumkin.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Musiqani translyatsiya qilish';

  @override
  String get noMusicFound => 'Musiqa topilmadi';

  @override
  String get addSongsToYour =>
      'Telefoningizga qo‘shiqlar qo‘shing, ular shu yerda paydo bo‘ladi.';

  @override
  String get shuffle => 'Aralashtirish';

  @override
  String get playAll => 'Hammasini ijro etish';

  @override
  String photo(Object formatShortDate) {
    return 'Rasm · $formatShortDate';
  }

  @override
  String get photo2 => 'Rasm';

  @override
  String get castPhotos => 'Rasmlarni translyatsiya qilish';

  @override
  String get select => 'Tanlash';

  @override
  String get noPhotosHere => 'Bu yerda rasmlar yo‘q';

  @override
  String get photosYouTakeOr =>
      'Siz olgan yoki saqlagan rasmlar shu albomda paydo bo‘ladi.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count ta rasm';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return '$formatShortDate dagi rasm';
  }

  @override
  String get allPhotos => 'Barcha rasmlar';

  @override
  String get slideshow => 'Slayd-shou';

  @override
  String get interval => 'Interval';

  @override
  String get transition => 'O‘tish';

  @override
  String get fade => 'So‘nish';

  @override
  String get slide => 'Surilish';

  @override
  String get zoom => 'Kattalashtirish';

  @override
  String get startSlideshow => 'Slayd-shouni boshlash';

  @override
  String get castVideos => 'Videolarni translyatsiya qilish';

  @override
  String get noVideosYet => 'Hali videolar yo‘q';

  @override
  String get videosYouRecordOr =>
      'Siz yozgan yoki yuklab olgan videolar translyatsiyaga tayyor holda shu yerda paydo bo‘ladi.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Translyatsiya';
  }

  @override
  String get tv => 'Televizor';

  @override
  String get screenMirroringSession => 'Ekran akslantirish seansi';

  @override
  String get mirroringDidntStartTap =>
      'Akslantirish boshlanmadi. “Boshlash” tugmasini yana bosing va ro‘yxatdan televizoringizni tanlang.';

  @override
  String get openSmartViewOr =>
      'Akslantirish uchun telefoningizning tezkor sozlamalaridan Smart View yoki Cast ni oching.';

  @override
  String get quality => 'Sifat';

  @override
  String get adjustsToYourWi => 'Eng silliq tasvir uchun Wi-Fi ga moslashadi.';

  @override
  String upToLowerIt(Object label) {
    return '$label gacha. Tasvir uzilsa, pasaytiring.';
  }

  @override
  String get stillNeedHelp => 'Yordam kerakmi?';

  @override
  String get startingScreenMirroring => 'Ekran akslantirish boshlanmoqda…';

  @override
  String mirroringTo(Object value) {
    return '$value ga akslantirilmoqda';
  }

  @override
  String get stopping => 'To‘xtatilmoqda…';

  @override
  String get readyToMirror => 'Akslantirishga tayyor';

  @override
  String get beforeYouStart => 'Boshlashdan oldin';

  @override
  String get phoneAndTvAre => 'Telefon va televizor bir xil Wi-Fi da';

  @override
  String get noVpnIsConnected => 'Telefoningizda VPN ulanmagan';

  @override
  String get tvIsOnWith => 'Televizor yoqilgan va Ekran akslantirish yoqilgan';

  @override
  String get phoneIsCloseTo => 'Telefon televizorga yaqin';

  @override
  String get stopMirroring => 'Akslantirishni to‘xtatish';

  @override
  String get startMirroring2 => 'Akslantirishni boshlash';

  @override
  String get stop => 'To‘xtatish';

  @override
  String get start => 'Boshlash';

  @override
  String get duration => 'Davomiyligi';

  @override
  String get adIsLoading => 'Reklama yuklanmoqda';

  @override
  String get ad => 'Reklama';

  @override
  String get mirrorYourScreenTo =>
      'Ekraningizni istalgan televizorga akslantiring';

  @override
  String get showYourPhoneOnThe =>
      'Telefoningizni bir bosishda katta ekranda ko‘rsating — kabelsiz, tashvishsiz.';

  @override
  String get shareMemoriesWithThe =>
      'Xotiralarni butun xona bilan ulashing va telefoningizdan boshqaring.';

  @override
  String get castFromWebApps => 'Veb va ilovalardan translyatsiya qiling';

  @override
  String get sendVideosFromYoutube =>
      'YouTube, Facebook va istalgan saytdagi videolarni to‘g‘ridan-to‘g‘ri televizoringizga yuboring.';

  @override
  String pageOf(Object value, Object length) {
    return '$length sahifadan $value-sahifa';
  }

  @override
  String get getStarted => 'Boshlash';

  @override
  String get localNetwork => 'Mahalliy tarmoq';

  @override
  String get findTvsAndStreaming =>
      'Wi-Fi tarmog‘ingizdagi televizor va striming qurilmalarini toping.';

  @override
  String get notifications => 'Bildirishnomalar';

  @override
  String get showCastingControlsWhile =>
      'Boshqa ilovalardan foydalanayotganda translyatsiya boshqaruvini ko‘rsating.';

  @override
  String get photosVideosMusic => 'Rasm, video va musiqa';

  @override
  String get pickWhatYouWantTo =>
      'Galereya va kutubxonangizdan nimani translyatsiya qilishni tanlang.';

  @override
  String get screenCapture => 'Ekranni yozib olish';

  @override
  String get mirrorYourScreenYoull =>
      'Ekraningizni akslantiring. Har bir seansni tasdiqlaysiz.';

  @override
  String get webVideo => 'Veb-video';

  @override
  String get link => 'Havola';

  @override
  String get screenMirroring2 => 'Ekran akslantirish';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Hozir $title translyatsiya qilinmoqda. Pultni ochish';
  }

  @override
  String castingTo2(Object value) {
    return '$value ga translyatsiya qilinmoqda';
  }

  @override
  String get nowCasting => 'Hozir translyatsiya qilinmoqda';

  @override
  String get nothingIsCasting => 'Hech narsa translyatsiya qilinmayapti';

  @override
  String get pickAPhotoVideo =>
      'Televizoringizga yuborish uchun rasm, video, qo‘shiq yoki veb-videoni tanlang.';

  @override
  String get backToHome => 'Bosh sahifaga qaytish';

  @override
  String slide2(Object formatDuration) {
    return 'Slayd $formatDuration';
  }

  @override
  String get back10Seconds => '10 soniya orqaga';

  @override
  String get forward10Seconds => '10 soniya oldinga';

  @override
  String get tvVolume => 'Televizor ovozi';

  @override
  String tvVolumePercent(Object round) {
    return 'Televizor ovozi $round foiz';
  }

  @override
  String get upNext => 'Keyingisi';

  @override
  String get addPhotos => 'Rasmlar qo‘shish';

  @override
  String get addVideos => 'Videolar qo‘shish';

  @override
  String get nothingElseInThe => 'Navbatda boshqa hech narsa yo‘q.';

  @override
  String play2(Object title) {
    return '$title ni ijro etish';
  }

  @override
  String get unknownDevice => 'Noma’lum qurilma';

  @override
  String get perWeek => 'haftasiga';

  @override
  String get perYear => 'yiliga';

  @override
  String get payOnce => 'bir marta to‘lash';

  @override
  String get wirelessScreenMirroring => 'Simsiz ekran akslantirish';

  @override
  String get castVideosPhotosMusic =>
      'Video, rasm va musiqani translyatsiya qiling';

  @override
  String get fullTvRemoteControl => 'To‘liq televizor pulti';

  @override
  String get worksWithAllMajor => 'Barcha yirik televizorlar bilan ishlaydi';

  @override
  String get smoothLagFreeStreaming => 'Silliq, kechikishsiz striming';

  @override
  String get noAds => 'Reklamasiz';

  @override
  String get welcomeToCastflowPro =>
      'Televizorga translyatsiya Pro ga xush kelibsiz!';

  @override
  String get purchaseCancelled => 'Xarid bekor qilindi.';

  @override
  String get purchasePendingProUnlocks =>
      'Xarid kutilmoqda. Do‘kon tasdiqlashi bilan Pro ochiladi.';

  @override
  String get purchaseFailedPleaseTry =>
      'Xarid amalga oshmadi. Qayta urinib ko‘ring.';

  @override
  String get theStoreIsntAvailable => 'Do‘kon hozir mavjud emas.';

  @override
  String get close => 'Yopish';

  @override
  String get goProWithCastflow =>
      'TELEVIZORGA TRANSLYATSIYA BILAN PRO GA O‘TING';

  @override
  String get unlockEveryFeature => 'Barcha funksiyalarni oching';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Bekor qilinmaguncha avtomatik yangilanadi.';

  @override
  String get oneTimePurchaseNo => 'Bir martalik xarid. Obunasiz.';

  @override
  String get continueAction => 'Davom etish';

  @override
  String get privacyPolicy => 'Maxfiylik siyosati';

  @override
  String get termsAndConditions => 'Foydalanish shartlari';

  @override
  String get cancelAnytime => 'Istalgan vaqtda bekor qiling';

  @override
  String get loadingPrice => 'Narx yuklanmoqda…';

  @override
  String get pricesUnavailableTapTo =>
      'Narxlar mavjud emas · Qayta urinish uchun bosing';

  @override
  String get noPlansAvailableRight => 'Hozir tariflar mavjud emas.';

  @override
  String get weekly => 'Haftalik';

  @override
  String get yearly => 'Yillik';

  @override
  String get lifetime => 'Umrbod';

  @override
  String get bestValue => 'Eng yaxshi qiymat';

  @override
  String get disconnectFromTv => 'Televizordan uzilsinmi?';

  @override
  String get thisStopsWhatIs =>
      'Bu hozir ijro etilayotgan yoki akslantirilayotgan narsani to‘xtatadi.';

  @override
  String get useTouchpad => 'Sensorli paneldan foydalanish';

  @override
  String get useDPad => 'D-pad dan foydalanish';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label qabul qilgichlari pult buyruqlarini qabul qilmaydi.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Ba’zi tugmalar $label da mavjud emas.';
  }

  @override
  String get idle => 'KUTISH';

  @override
  String get playing => 'IJRO ETILMOQDA';

  @override
  String get paused => 'PAUZADA';

  @override
  String get noTvConnected => 'Televizor ulanmagan';

  @override
  String get mute2 => 'OVOZSIZ';

  @override
  String vol(Object volume) {
    return 'OVOZ $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Televizor ulanmagan. Qurilmani tanlash uchun bosing';

  @override
  String get tapToChooseA => 'Qurilmani tanlash uchun bosing';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label $label2 tomonidan qo‘llab-quvvatlanmaydi';
  }

  @override
  String get touchpadSwipeToMove =>
      'Sensorli panel. Harakatlanish uchun suring, tanlash uchun bosing.';

  @override
  String get swipeToMoveTap =>
      'Harakatlanish uchun suring · Tanlash uchun bosing';

  @override
  String get navigationIsntSupportedBy =>
      'Navigatsiya bu televizorda qo‘llab-quvvatlanmaydi';

  @override
  String get vol2 => 'OVOZ';

  @override
  String get auto => 'Avto';

  @override
  String get automatic => 'Avtomatik';

  @override
  String get googleCastFirst => 'Avval Google Cast';

  @override
  String get dlnaUpnpFirst => 'Avval DLNA / UPnP';

  @override
  String get miracastFirst => 'Avval Miracast';

  @override
  String get tvOnly => 'Faqat televizor';

  @override
  String get phoneAndTv => 'Telefon va televizor';

  @override
  String get phoneOnly => 'Faqat telefon';

  @override
  String get touchpad => 'Sensorli panel';

  @override
  String get doMyPhoneAnd =>
      'Telefon va televizorim bir xil Wi-Fi da bo‘lishi kerakmi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Ha. Qidirish va translyatsiya mahalliy tarmog‘ingizda amalga oshadi, shuning uchun ikkalasi ham bir xil Wi-Fi da bo‘lishi kerak (diapazon nomlari bir xil bo‘lsa ham, tarmoqlar boshqa bo‘lishi mumkin).';

  @override
  String get myRouterHasAp => 'Routerimda “AP / mijozlarni ajratish” bor';

  @override
  String get isolationBlocksDevicesFrom =>
      'Ajratish qurilmalarning bir-birini ko‘rishiga to‘sqinlik qiladi. Uni router sozlamalarida o‘chiring yoki mehmon bo‘lmagan tarmoqdan foydalaning.';

  @override
  String get findingYourTv => 'Televizoringiz qidirilmoqda';

  @override
  String get myTvDoesntAppear => 'Televizorim ro‘yxatda ko‘rinmayapti';

  @override
  String get turnOnCastingScreen =>
      'Televizorda translyatsiya / ekran akslantirishni yoqing, uni kutish rejimidan chiqaring, so‘ng “Qayta skanerlash” tugmasini bosing. So‘ralsa, Mahalliy tarmoq ruxsatini bering.';

  @override
  String get onlySomeDevicesShow => 'Faqat ba’zi qurilmalar ko‘rinadi';

  @override
  String get olderTvsMayNeed =>
      'Eski televizorlar uchun proshivka yangilanishi kerak bo‘lishi mumkin. Miracast televizorlar faqat “Ekran akslantirish” kirishi ochiq bo‘lganda ko‘rinadi.';

  @override
  String get connectionFailsOrTimes =>
      'Ulanish amalga oshmaydi yoki vaqt tugaydi';

  @override
  String get restartTheTvApp =>
      'Televizor ilovasini yoki televizorni qayta ishga tushiring, routerga yaqinlashing va televizor ekranidagi har qanday so‘rovni qabul qiling.';

  @override
  String get itKeepsReconnectingTo => 'U eski televizorga qayta ulanaveradi';

  @override
  String get turnOffAutoConnect =>
      'Sozlamalar → Translyatsiya bo‘limida “Oxirgi televizorga avto-ulanish” ni o‘chiring.';

  @override
  String get mirroringIsLaggy => 'Akslantirish sekin ishlayapti';

  @override
  String get chooseALowerQuality =>
      'Pastroq sifatni tanlang (720p yoki 480p), og‘ir ilovalarni yoping va 5 GHz Wi-Fi tarmog‘idan foydalaning.';

  @override
  String get thePictureIsRotated => 'Tasvir burilgan yoki qirqilgan';

  @override
  String get toggleAutoRotateOn =>
      'Ekran akslantirish ekranida Avto-burishni yoqing.';

  @override
  String get sound => 'Ovoz';

  @override
  String get thereIsNoSound => 'Televizorda ovoz yo‘q';

  @override
  String get makeSureAudioIs =>
      'Ekran akslantirishda Audio yoqilganini tekshiring va Sozlamalar → Translyatsiya → Audio chiqishni ko‘ring. Ba’zi qabul qilgichlar telefon audiosini qo‘llab-quvvatlamaydi.';

  @override
  String get tvRemote2 => 'Televizor pulti';

  @override
  String get someRemoteButtonsAre => 'Ba’zi pult tugmalari kulrang';

  @override
  String get eachReceiverSupportsDifferent =>
      'Har bir qabul qilgich turli buyruqlarni qo‘llab-quvvatlaydi. Chromecast va DLNA faqat ijro va ovozni qo‘llab-quvvatlaydi; Miracast da pult kanali yo‘q.';

  @override
  String get canCastflowTurnMy =>
      'Televizorga translyatsiya televizorimni yoqa oladimi yoki kirishni o‘zgartira oladimi?';

  @override
  String get onlyOnTvsThat =>
      'Faqat bu buyruqlarni tarmoq orqali taqdim etadigan televizorlarda. Qo‘llab-quvvatlanmaydigan tugmalar ishlayotgandek ko‘rsatilmasdan, o‘chirib qo‘yiladi.';

  @override
  String get helpFaq => 'Yordam va FAQ';

  @override
  String get stepByStepConnection => 'Bosqichma-bosqich ulanish qo‘llanmasi';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'E-pochta ilovasi topilmadi.';

  @override
  String get enjoyingCastflow => 'Televizorga translyatsiya yoqdimi?';

  @override
  String get sorryToHearThat => 'Eshitganimizdan afsusdamiz';

  @override
  String get thanksHowCanWe => 'Rahmat! Qanday yaxshilashimiz mumkin?';

  @override
  String get wereGladYouLike => 'Yoqqaniga xursandmiz!';

  @override
  String get youMadeOurDay => 'Kunimizni yaxshi qildingiz!';

  @override
  String get tapToExit => 'Chiqish uchun bosing';

  @override
  String get selectARating => 'Bahoni tanlang';

  @override
  String get sendFeedback => 'Fikr-mulohaza yuborish';

  @override
  String get rateUs => 'Bizni baholang';

  @override
  String get rateYourExperienceBefore =>
      'Ketishdan oldin tajribangizni baholang.';

  @override
  String get tapAStarTo =>
      'Televizorga translyatsiyani baholash uchun yulduzchani bosing.';

  @override
  String get general => 'Umumiy';

  @override
  String get english => 'Ingliz tili';

  @override
  String get defaultQuality => 'Standart sifat';

  @override
  String get autoConnectToLast => 'Oxirgi televizorga avto-ulanish';

  @override
  String get appearance => 'Ko‘rinish';

  @override
  String get light => 'Yorug‘';

  @override
  String get dark => 'Qorong‘i';

  @override
  String get system => 'Tizim';

  @override
  String get aboutSupport => 'Ilova haqida va yordam';

  @override
  String get rateApp => 'Ilovani baholash';

  @override
  String get feedback => 'Fikr-mulohaza';

  @override
  String get termsConditions => 'Foydalanish shartlari';

  @override
  String get version => 'Versiya';

  @override
  String get castflowProIsActive => 'Televizorga translyatsiya Pro faol';

  @override
  String get upgradeToPremium => 'Premium ga o‘tish';

  @override
  String get castflowPremium => 'Televizorga translyatsiya Premium';

  @override
  String get thanksForYourSupport =>
      'Qo‘llab-quvvatlaganingiz uchun rahmat. Reklamasiz translyatsiyadan zavqlaning.';

  @override
  String get noAds1080pMirroring =>
      'Reklamasiz, 1080p akslantirish va cheksiz translyatsiya';

  @override
  String get upgrade => 'Yangilash';

  @override
  String get mirrorCastBeautifullySimple =>
      'Akslantiring va translyatsiya qiling, juda oddiy';

  @override
  String get thisActionMayContain => 'Bu amalda reklama bo‘lishi mumkin';

  @override
  String get webCast => 'Veb translyatsiya';

  @override
  String get castThisVideo => 'Bu videoni translyatsiya qilish';

  @override
  String get searchOrTypeAWeb => 'Veb-manzil qidiring yoki kiriting';

  @override
  String get removeBookmark => 'Xatcho‘pni olib tashlash';

  @override
  String get bookmark => 'Xatcho‘p';

  @override
  String get quickAccess => 'Tezkor kirish';

  @override
  String open2(Object title) {
    return '$title ni ochish';
  }

  @override
  String get bookmarks => 'Xatcho‘plar';

  @override
  String get noBookmarks => 'Xatcho‘plar yo‘q';

  @override
  String get tapTheBookmarkIcon =>
      'Sahifani saqlash uchun manzil qatoridagi xatcho‘p belgisini bosing.';

  @override
  String get noHistory => 'Tarix yo‘q';

  @override
  String get pagesYouVisitShow => 'Siz kirgan sahifalar shu yerda ko‘rinadi.';

  @override
  String get remove => 'Olib tashlash';

  @override
  String resultOn(Object value, Object host) {
    return '$host dagi $value-natija';
  }

  @override
  String get aSimulatedPageResult => 'Simulyatsiya qilingan sahifa natijasi';

  @override
  String get videosOnThisPage => 'Bu sahifadagi videolar';

  @override
  String get pickOneToSend => 'Televizoringizga yuborish uchun birini tanlang.';

  @override
  String get onboardHotspotTitle => 'Wi-Fi yo‘qmi? Hotspotdan foydalaning';

  @override
  String get onboardHotspotBody =>
      'Telefoningiz hotspotini yoqing va televizoringizni unga ulang. Translyatsiya Wi-Fi dagidek ishlaydi.';

  @override
  String get stillCantFindTitle =>
      'Televizoringizni hali ham topa olmayapsizmi?';

  @override
  String get stillCantFindBody =>
      'Buning o‘rniga televizoringizni telefoningiz hotspotiga ulang:';

  @override
  String get hotspotStep4 =>
      '“Qayta urinish” tugmasini bosing va ro‘yxatdan televizoringizni tanlang';

  @override
  String get castOverHotspot =>
      'Wi-Fi yo‘qmi? Telefoningiz hotspoti orqali translyatsiya qiling:';

  @override
  String get queue => 'Navbat';

  @override
  String get addMusic => 'Musiqa qo‘shish';

  @override
  String get connectWithWifi => 'Wi-Fi orqali ulanish';

  @override
  String get continueWithHotspot => 'Hotspot bilan davom etish';

  @override
  String get noWifiAlertMessage =>
      'Siz mobil internetdasiz. Telefon va televizoringizni bir xil Wi-Fi ga ulang yoki telefoningiz hotspotini yoqing va televizordan unga qo‘shiling.';

  @override
  String get checkingNetwork => 'Tarmoq tekshirilmoqda...';

  @override
  String get discoveryStopped => 'Qidiruv to‘xtatildi';

  @override
  String get discoveryStoppedHint =>
      'Qidiruv to‘xtatildi. Yaqin atrofdagi qurilmalarni topish uchun qidirish tugmasini bosing.';

  @override
  String get search => 'Qidirish';

  @override
  String get permissionNeededToDiscover =>
      'Wi-Fi dagi qurilmalarni topish uchun joylashuv ruxsati kerak.';

  @override
  String get locationServicesDisabled => 'Joylashuv xizmatlari o‘chirilgan';

  @override
  String get openLocationSettings => 'Joylashuv sozlamalarini ochish';

  @override
  String get openAppSettings => 'Ilova sozlamalarini ochish';

  @override
  String get subscriptionExpired => 'Obunangiz muddati tugadi.';

  @override
  String get noPurchasesFound => 'Oldingi xaridlar topilmadi.';

  @override
  String get restore => 'Tiklash';

  @override
  String get permissionNeeded => 'Ruxsat kerak';

  @override
  String get permissionBlockedInSettings => 'Ruxsat sozlamalarda bloklangan';

  @override
  String get grantPermission => 'Ruxsat berish';

  @override
  String get checkAgain => 'Qayta tekshirish';

  @override
  String get appName => 'Televizorga translyatsiya';

  @override
  String get allowPermission => 'Ruxsat berish';

  @override
  String get openSettings => 'Sozlamalarni ochish';

  @override
  String get noNetworkMessage =>
      'Wi-Fi’ni yoqing (televizor bilan bir xil tarmoq) yoki telefon hotspotini yoqib, televizorni unga ulang.';

  @override
  String get turnOnWifi => 'Wi-Fi’ni yoqish';

  @override
  String get waitingForNetwork =>
      'Ulanishingiz bilan televizoringizni qidirishni boshlaymiz.';

  @override
  String get howHotspotWorks => 'Hotspot orqali translatsiya qanday ishlaydi?';

  @override
  String get preparingForTv => 'Televizoringiz uchun tayyorlanmoqda…';

  @override
  String convertingForTv(int percent) {
    return 'Televizoringiz uchun o‘zgartirilmoqda… $percent%';
  }

  @override
  String get lookingForTvsOnHotspot =>
      'Hotspotingizdagi televizorlar qidirilmoqda';

  @override
  String get noInternetConnection =>
      'Internet aloqasi yo‘q. Ulanishni tekshirib, qayta urinib ko‘ring.';

  @override
  String get convertingToTvFormat =>
      'Televizoringiz formatiga o‘zgartirilmoqda';

  @override
  String get playMode => 'Ijro rejimi';

  @override
  String get playModeOnce => 'Bir marta ijro etish';

  @override
  String get playModeAutoplay => 'Avto ijro';

  @override
  String get playModeRepeatAll => 'Hammasini takrorlash';

  @override
  String get playModeRepeatOne => 'Bittasini takrorlash';

  @override
  String convertingExplain(Object from, Object to) {
    return 'Televizoringiz $from ni to‘g‘ridan-to‘g‘ri ijro eta olmaydi, shuning uchun u $to ga o‘zgartirilmoqda.';
  }

  @override
  String get convertingKeepOpen =>
      'Ilovani ochiq qoldiring. Tayyor bo‘lgach televizorda o‘zi boshlanadi.';

  @override
  String get checkingTvFormats =>
      'Televizoringiz nimani ijro eta olishi tekshirilmoqda…';

  @override
  String convertingTimeLeft(Object time) {
    return 'Taxminan $time qoldi';
  }
}
