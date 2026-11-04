// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get networkRequiredTitle => 'Wi-Fi\'ye bağlı değil';

  @override
  String get networkRequiredMessage =>
      'Yayın yapmak için telefonunuz ve TV aynı Wi-Fi ağında olmalıdır.';

  @override
  String get openWifiSettings => 'Wi-Fi ayarlarını aç';

  @override
  String get useMobileHotspot => 'Mobil hotspot kullan';

  @override
  String get hotspotInstruction =>
      'TV\'nizi telefonunuzun mobil hotspot\'una bağlayın.';

  @override
  String get hotspotStep1 => 'Mobil hotspot\'u açın';

  @override
  String get hotspotStep2 => 'TV\'nizi ona bağlayın';

  @override
  String get hotspotStep3 => 'Uygulamaya geri dönün';

  @override
  String get openHotspotSettings => 'Hotspot ayarlarını aç';

  @override
  String get hotspotAutoCheck =>
      'Geri döndüğünüzde otomatik olarak tekrar kontrol edeceğiz.';

  @override
  String get hotspotDetected => 'Hotspot açık. TV\'niz aranıyor…';

  @override
  String get searchingDevices => 'Yakındaki cihazlar aranıyor...';

  @override
  String get waitingForTvOnHotspot =>
      'TV\'nizin hotspot\'unuza katılması bekleniyor…';

  @override
  String get usingHotspot => 'Mobil hotspot\'unuz kullanılıyor';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cihaz bulundu',
      one: '1 cihaz bulundu',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Tekrar dene';

  @override
  String get scanAgain => 'Yeniden tara';

  @override
  String get isolationTitle => 'TV yanıt vermiyor';

  @override
  String get isolationHint =>
      'Bir cihaz hotspot\'unuza katıldı ancak yanıt vermiyor. Hotspot\'unuz cihazlar arası trafiği engelliyor olabilir (istemci yalıtımı). Bunu hotspot ayarlarında kapatın veya bir Wi-Fi ağı kullanın.';

  @override
  String get connecting => 'Bağlanıyor…';

  @override
  String get connected => 'Bağlandı';

  @override
  String get connectionFailed => 'Bağlanılamadı';

  @override
  String get connectFailedHint =>
      'Telefonunuz ve TV\'nin aynı ağda olduğundan emin olun, sonra tekrar deneyin.';

  @override
  String get hotspotConnectHint =>
      'Hotspot\'unuz cihazlar arası trafiği engelliyor olabilir. İstemci yalıtımı ayarını kontrol edin.';

  @override
  String get networkLostTitle => 'Ağ bağlantısı koptu';

  @override
  String get networkLostMessage =>
      'Wi-Fi\'ye veya hotspot\'a yeniden bağlanın, ardından TV\'nize yeniden bağlanın.';

  @override
  String get reconnect => 'Yeniden bağlan';

  @override
  String reconnectTo(String name) {
    return '$name cihazına yeniden bağlan';
  }

  @override
  String get tapToReconnect => 'Yeniden bağlanmak için dokunun';

  @override
  String get pairingRequired => 'Eşleştirme gerekli';

  @override
  String get pairingEnterCode => 'TV\'nizde görünen kodu girin.';

  @override
  String get pairingApproveOnTv =>
      'TV\'nize bakın ve devam etmek için İzin ver\'e dokunun.';

  @override
  String get connect => 'Bağlan';

  @override
  String get cancel => 'İptal';

  @override
  String get pairingIncorrectCode => 'Kod yanlış. Tekrar deneyin.';

  @override
  String get pairingTimedOut => 'Eşleştirme zaman aşımına uğradı';

  @override
  String get tryAgain => 'Tekrar dene';

  @override
  String get pairingDeclined => 'TV bağlantıyı reddetti';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Çok fazla yanlış kod. $seconds sn bekleyin, ardından yeni kod isteyin.';
  }

  @override
  String get pairingCooldownOver => 'Artık yeni kod isteyebilirsiniz.';

  @override
  String get pairingRequestNewCode => 'Yeni kod iste';

  @override
  String get pairingNetworkLost =>
      'Eşleştirme sırasında ağ kesildi. Wi-Fi\'ye yeniden bağlanın ve tekrar deneyin.';

  @override
  String get pairingFailed => 'TV ile eşleştirilemedi.';

  @override
  String pairingCodeField(int length) {
    return 'Eşleştirme kodu, $length karakter';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Kod kutusu $index/$total';
  }

  @override
  String get pairingEmptyBox => 'boş';

  @override
  String get pairingPaired => 'Eşleştirildi';

  @override
  String get forgetDevice => 'Cihazı unut';

  @override
  String forgetDeviceMessage(String name) {
    return '$name bir sonraki sefer yeniden eşleştirilmeli.';
  }

  @override
  String get forget => 'Unut';

  @override
  String get castVideo => 'Videoyu yayınla';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video bulundu. Videoyu yayınla',
      one: '1 video bulundu. Videoyu yayınla',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Bu sayfada henüz video bulunamadı.';

  @override
  String get videoFound => 'Video bulundu';

  @override
  String get videoFoundMessage => 'TV\'nizde oynatın.';

  @override
  String get castAction => 'Yayınla';

  @override
  String get dismiss => 'Kapat';

  @override
  String videosFound(int count) {
    return 'Bulunan videolar ($count)';
  }

  @override
  String get castToTv => 'TV\'ye yayınla';

  @override
  String get protectedVideo => 'Korumalı, yayınlanamaz';

  @override
  String get videoThumbnail => 'Video küçük resmi';

  @override
  String castingTo(String device) {
    return '$device cihazına yayınlanıyor';
  }

  @override
  String get stopCasting => 'Yayını durdur';

  @override
  String get play => 'Oynat';

  @override
  String get pause => 'Duraklat';

  @override
  String get volume => 'Ses';

  @override
  String get seekPosition => 'Oynatma konumu';

  @override
  String get showControls => 'Kontrolleri göster';

  @override
  String get hideControls => 'Kontrolleri gizle';

  @override
  String get formatUnsupportedTitle => 'Biçim desteklenmiyor';

  @override
  String formatUnsupported(String device, String format) {
    return '$device $format videolarını oynatamıyor. Bu sayfadaki başka bir videoyu deneyin veya ekran yansıtmayı kullanın.';
  }

  @override
  String get videoExpired =>
      'Bu video bağlantısının süresi doldu. Sayfayı yenileyip tekrar deneyin.';

  @override
  String get refreshingVideo => 'Yeni video bağlantısı alınıyor…';

  @override
  String get browserBack => 'Geri';

  @override
  String get browserForward => 'İleri';

  @override
  String get browserStartPage => 'Başlangıç sayfası';

  @override
  String get browserReload => 'Yenile';

  @override
  String get ok => 'Tamam';

  @override
  String get home => 'Ana sayfa';

  @override
  String get devices => 'Cihazlar';

  @override
  String get history => 'Geçmiş';

  @override
  String get settings => 'Ayarlar';

  @override
  String get goodMorning => 'Günaydın';

  @override
  String get goodAfternoon => 'İyi günler';

  @override
  String get goodEvening => 'İyi akşamlar';

  @override
  String get couldntOpenTheLink => 'Bağlantı açılamadı.';

  @override
  String get castflowLogo => 'CastFlow logosu';

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti';

  @override
  String get weCouldntLoadThis =>
      'Bu şu anda yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String get apps => 'Uygulamalar';

  @override
  String open(Object name) {
    return '$name aç';
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
  String get up => 'Yukarı';

  @override
  String get down => 'Aşağı';

  @override
  String get left => 'Sol';

  @override
  String get right => 'Sağ';

  @override
  String get menu => 'Menü';

  @override
  String get input => 'Giriş';

  @override
  String get playPause => 'Oynat / Duraklat';

  @override
  String get previous => 'Önceki';

  @override
  String get next => 'Sonraki';

  @override
  String get rewind => 'Geri sar';

  @override
  String get volumeUp => 'Sesi artır';

  @override
  String get volumeDown => 'Sesi azalt';

  @override
  String get mute => 'Sessiz';

  @override
  String connectedTo(Object name) {
    return '$name cihazına bağlı';
  }

  @override
  String get chooseADevice => 'Bir cihaz seçin';

  @override
  String get connectionGuide => 'Bağlantı rehberi';

  @override
  String get lookingForTvsOn => 'Wi-Fi ağınızdaki TV\'ler aranıyor';

  @override
  String foundSoFar(Object found) {
    return 'Şimdiye kadar $found bulundu';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found cihaz bulundu';
  }

  @override
  String get disconnect => 'Bağlantıyı kes';

  @override
  String signalOf4(Object level) {
    return 'Sinyal $level/4';
  }

  @override
  String get connecting2 => 'Bağlanıyor';

  @override
  String get theTvRemoteNeeds =>
      'TV kumandası bağlı bir TV gerektirir. Aşağıdan birini seçin.';

  @override
  String get connectToATv => 'Devam etmek için bir TV\'ye bağlanın.';

  @override
  String get findingTvs => 'TV\'ler aranıyor…';

  @override
  String get makeSureYourTv => 'TV\'nizin açık olduğundan emin olun';

  @override
  String get notConnected => 'Bağlı değil';

  @override
  String get tapToFindYour => 'TV\'nizi bulmak için dokunun';

  @override
  String get connectionFailed2 => 'Bağlantı başarısız';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Cihazları yönetmek için dokunun';
  }

  @override
  String get joinTheSameWi => 'Aynı Wi-Fi\'ye katılın';

  @override
  String get connectYourPhoneAnd =>
      'Telefonunuzu ve TV\'nizi aynı Wi-Fi ağına bağlayın.';

  @override
  String get turnOnCastingOn => 'TV\'nizde yayını açın';

  @override
  String get enableScreenMirroringMiracast =>
      'TV ayarlarında Ekran Yansıtma, Miracast veya Google Cast\'i etkinleştirin.';

  @override
  String get scanForDevices => 'Cihazları tara';

  @override
  String get openDevicesInCastflow =>
      'CastFlow\'da Cihazlar\'ı açın ve TV\'nizin görünmesi için birkaç saniye bekleyin.';

  @override
  String get tapConnect => 'Bağlan\'a dokunun';

  @override
  String get acceptThePromptOn =>
      'TV\'nizde bir istem çıkarsa kabul edin. Hepsi bu kadar!';

  @override
  String get howToConnect => 'Nasıl bağlanılır';

  @override
  String get fourQuickStepsTo => 'Büyük ekrana geçmek için dört hızlı adım.';

  @override
  String get gotIt => 'Anladım';

  @override
  String step(Object number, Object title, Object body) {
    return 'Adım $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Ev Wi-Fi\'si';

  @override
  String get router => 'Yönlendirici';

  @override
  String get settingsConnection => 'Ayarlar › Bağlantı';

  @override
  String get inputHdmi1 => 'Giriş: HDMI 1';

  @override
  String get screenMirroring => 'Ekran Yansıtma';

  @override
  String get networkHomeWiFi => 'Ağ: Ev Wi-Fi\'si';

  @override
  String get livingRoomTv => 'Oturma odası TV\'si';

  @override
  String get allowCastflowToConnect =>
      'CastFlow\'un bağlanmasına izin verilsin mi?';

  @override
  String get deny => 'Reddet';

  @override
  String get allow => 'İzin ver';

  @override
  String get yourTv => 'TV\'niz';

  @override
  String get findYourTv => 'TV\'nizi bulun';

  @override
  String connectTo(Object name) {
    return '$name cihazına bağlan';
  }

  @override
  String connected2(Object label) {
    return 'Bağlandı · $label';
  }

  @override
  String get openTvRemote => 'TV kumandasını aç';

  @override
  String get sameWiFiNetwork => 'Aynı Wi-Fi ağı';

  @override
  String get yourPhoneAndTv =>
      'Telefonunuz ve TV aynı Wi-Fi\'ye bağlı olmalıdır.';

  @override
  String get tvIsOnAnd => 'TV açık ve hazır';

  @override
  String get turnOnScreenMirroring =>
      'TV\'de Ekran Yansıtma, Cast veya Miracast\'i açın.';

  @override
  String get noVpnOrGuest => 'VPN veya misafir ağı yok';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN\'ler ve misafir / yalıtılmış Wi-Fi cihazları birbirinden gizler.';

  @override
  String get localNetworkAccess => 'Yerel ağ erişimi';

  @override
  String get allowCastflowToFind =>
      'İstendiğinde CastFlow\'un ağınızdaki cihazları bulmasına izin verin.';

  @override
  String get noTvFound => 'TV bulunamadı';

  @override
  String get checkThatYourPhone =>
      'Telefonunuz ve TV\'nin aynı Wi-Fi\'ye bağlı olduğunu kontrol edin, sonra tekrar tarayın.';

  @override
  String get noWiFiRouter =>
      'Wi-Fi yönlendiriciniz yok mu? Hotspot\'unuzu kullanın';

  @override
  String searchingForTvsFound(Object length) {
    return 'TV\'ler aranıyor. $length bulundu.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TV bulundu';
  }

  @override
  String get connectToYourTv => 'TV\'nize bağlanın';

  @override
  String get connectYourPhoneAndTv =>
      'Telefonunuzu ve TV\'nizi aynı Wi-Fi ağına bağlayın.';

  @override
  String get turnOnTheTv =>
      'TV\'yi açın ve Ekran Yansıtma / Cast girişini açın.';

  @override
  String get tapTheConnectionBar =>
      'TV\'nizi bulmak için Ana sayfadaki bağlantı çubuğuna dokunun.';

  @override
  String get tapConnectAndAccept =>
      'Bağlan\'a dokunun ve TV\'de bir istem çıkarsa kabul edin.';

  @override
  String get mirrorYourScreen => 'Ekranınızı yansıtın';

  @override
  String get connectToYourTvFirst => 'Önce TV\'nize bağlanın.';

  @override
  String get openScreenMirroringFrom => 'Ana sayfadan Ekran Yansıtma\'yı açın.';

  @override
  String get pickAQualityAnd => 'Bir kalite seçin ve Başlat\'a dokunun.';

  @override
  String get allowScreenCaptureWhen =>
      'Android sorduğunda ekran yakalamaya izin verin.';

  @override
  String get castPhotosVideosMusic => 'Fotoğraf, video ve müzik yayınlayın';

  @override
  String get openPhotosVideosOr =>
      'Ana sayfada Fotoğraflar, Videolar veya Müzik\'i açın.';

  @override
  String get pickWhatYouWant => 'Göstermek istediğinizi seçin.';

  @override
  String get itPlaysOnThe =>
      'TV\'de oynar; telefonunuzdan veya bildirimden kontrol edin.';

  @override
  String get useTheTvRemote => 'TV kumandasını kullanın';

  @override
  String get openTvRemoteOn => 'Ana sayfada TV Kumandası\'nı açın.';

  @override
  String get useTheDPad =>
      'Hareket için yön tuşlarını kullanın veya dokunmatik yüzeyde kaydırın, seçmek için OK\'a dokunun.';

  @override
  String get buttonsATvDoesnt => 'TV\'nin desteklemediği düğmeler gri görünür.';

  @override
  String get castFromTheWeb => 'Web ve uygulamalardan yayınlayın';

  @override
  String get tapTheBrowserBar =>
      'Ana sayfada tarayıcı çubuğuna veya bir uygulamaya dokunun.';

  @override
  String get playAVideoOn => 'Sitede bir video oynatın.';

  @override
  String get tapCastThisVideo =>
      'TV\'nize göndermek için “Bu videoyu yayınla”ya dokunun.';

  @override
  String get screenMirroringHelp => 'Ekran yansıtma yardımı';

  @override
  String get connectYourPhoneTo => 'Telefonunuzu Wi-Fi\'ye bağlayın.';

  @override
  String get onTheTvOpen =>
      'TV\'de Ayarlar → Ağ\'ı açın ve aynı Wi-Fi\'ye katılın.';

  @override
  String get guestOrOfficeNetworks =>
      'Misafir veya ofis ağları çoğunlukla yansıtmayı engeller; ev Wi-Fi\'nizi veya telefonunuzun hotspot\'unu kullanın.';

  @override
  String get turnOffVpn => 'VPN\'i kapatın';

  @override
  String get aVpnHidesYour => 'VPN, TV\'nizi telefonunuzdan gizler.';

  @override
  String get pauseOrDisconnectYour =>
      'Başlamadan önce VPN uygulamanızı duraklatın veya bağlantısını kesin.';

  @override
  String get youCanTurnIt => 'İşiniz bitince tekrar açabilirsiniz.';

  @override
  String get turnOnMirroringOn => 'TV\'de yansıtmayı açın';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG ve çoğu Android TV yansıtmayı otomatik kabul eder.';

  @override
  String get otherTvsOpenInput =>
      'Diğer TV\'ler: Giriş / Kaynak\'ı açıp Ekran Yansıtma veya Miracast\'i seçin.';

  @override
  String get keepTheTvOn => 'Telefonunuz bağlanırken TV\'yi o ekranda tutun.';

  @override
  String get tapStartAndPick => 'Başlat\'a dokunup TV\'nizi seçin';

  @override
  String get tapStartOnThe => 'Ekran Yansıtma ekranında Başlat\'a dokunun.';

  @override
  String get androidOpensSmartView =>
      'Android Smart View / Cast\'i açar. Listeden TV\'nize dokunun.';

  @override
  String get ifTheTvAsks =>
      'TV sorarsa İzin ver\'i seçin veya ekrandaki PIN\'i girin.';

  @override
  String get youreMirroring => 'Yansıtıyorsunuz';

  @override
  String get everythingOnYourPhone =>
      'Telefonunuzdaki her şey artık TV\'de görünüyor.';

  @override
  String get turnThePhoneSideways =>
      'Tam ekran videolar ve oyunlar için telefonu yan çevirin.';

  @override
  String get toStopTapStop =>
      'Durdurmak için Durdur\'a dokunun veya yayın bildirimini kullanın.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Kapalı';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'Yatak odası TV\'si';

  @override
  String get officeDisplay => 'Ofis ekranı';

  @override
  String get clearHistory => 'Geçmiş temizlensin mi?';

  @override
  String get thisRemovesEverythingYouve =>
      'Bu işlem yayınladığınız her şeyi bu listeden kaldırır.';

  @override
  String get clear => 'Temizle';

  @override
  String get clearHistory2 => 'Geçmişi temizle';

  @override
  String get noHistoryYet => 'Henüz geçmiş yok';

  @override
  String get everythingYouCastWill =>
      'Yayınladığınız her şey yeniden bulabilmeniz için burada listelenir.';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get earlier => 'Daha önce';

  @override
  String get swipeAnItemTo => 'Kaldırmak için bir öğeyi kaydırın';

  @override
  String get delete => 'Sil';

  @override
  String removed(Object title) {
    return '“$title” kaldırıldı';
  }

  @override
  String get undo => 'Geri al';

  @override
  String get photos => 'Fotoğraflar';

  @override
  String get albums => 'Albümler';

  @override
  String get videos => 'Videolar';

  @override
  String get gallery => 'Galeri';

  @override
  String get music => 'Müzik';

  @override
  String get songs => 'Şarkılar';

  @override
  String get media => 'Medya';

  @override
  String get browseTheWeb => 'Web\'de gez';

  @override
  String get goPro => 'Pro\'ya geç';

  @override
  String cast(Object title) {
    return '$title yayınla';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Ekran Yansıtma. Yansıtmayı başlat';

  @override
  String readyToMirrorTo(Object device) {
    return '$device cihazına yansıtmaya hazır';
  }

  @override
  String get showYourPhoneOn => 'Telefonunuzu TV\'de gerçek zamanlı gösterin.';

  @override
  String get startMirroring => 'Yansıtmayı başlat';

  @override
  String get tvRemote => 'TV Kumandası';

  @override
  String get controlYourTv => 'TV\'nizi kontrol edin';

  @override
  String get youtubeMore => 'YouTube ve daha fazlası';

  @override
  String get openTheBrowser => 'Tarayıcıyı aç';

  @override
  String get searchOrTypeA => 'Ara veya bir web sitesi yaz';

  @override
  String get howToConnectOpen => 'Nasıl bağlanılır. Görsel rehberi aç';

  @override
  String get visualGuideForEvery => 'Her özellik için görsel rehber';

  @override
  String get language => 'Dil';

  @override
  String get done => 'Bitti';

  @override
  String get enterAValidHttp =>
      'Geçerli bir http(s) veya rtsp bağlantısı girin, ör. .m3u8 veya .mp4 URL\'si.';

  @override
  String get linkStream => 'Bağlantı akışı';

  @override
  String get iptvLinkCast => 'IPTV / Bağlantı yayını';

  @override
  String get castALink => 'Bağlantı yayınla';

  @override
  String get pasteADirectVideo =>
      'Doğrudan video, M3U8 veya IPTV akış URL\'si yapıştırın.';

  @override
  String get paste => 'Yapıştır';

  @override
  String get castLink => 'Bağlantıyı yayınla';

  @override
  String get allowAccessToYour =>
      'Medyanızı yayınlamak için erişime izin verin. Bunu Ayarlar\'dan değiştirebilirsiniz.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Müzik yayınla';

  @override
  String get noMusicFound => 'Müzik bulunamadı';

  @override
  String get addSongsToYour => 'Telefonunuza şarkı ekleyin, burada görünür.';

  @override
  String get shuffle => 'Karıştır';

  @override
  String get playAll => 'Tümünü oynat';

  @override
  String photo(Object formatShortDate) {
    return 'Fotoğraf · $formatShortDate';
  }

  @override
  String get photo2 => 'Fotoğraf';

  @override
  String get castPhotos => 'Fotoğraf yayınla';

  @override
  String get select => 'Seç';

  @override
  String get noPhotosHere => 'Burada fotoğraf yok';

  @override
  String get photosYouTakeOr =>
      'Çektiğiniz veya kaydettiğiniz fotoğraflar bu albümde görünür.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count fotoğraf';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return '$formatShortDate tarihli fotoğraf';
  }

  @override
  String get allPhotos => 'Tüm fotoğraflar';

  @override
  String get slideshow => 'Slayt gösterisi';

  @override
  String get interval => 'Aralık';

  @override
  String get transition => 'Geçiş';

  @override
  String get fade => 'Solma';

  @override
  String get slide => 'Kaydırma';

  @override
  String get zoom => 'Yakınlaştırma';

  @override
  String get startSlideshow => 'Slayt gösterisini başlat';

  @override
  String get castVideos => 'Video yayınla';

  @override
  String get noVideosYet => 'Henüz video yok';

  @override
  String get videosYouRecordOr =>
      'Kaydettiğiniz veya indirdiğiniz videolar yayına hazır olarak burada görünür.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Yayınla';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Ekran yansıtma oturumu';

  @override
  String get mirroringDidntStartTap =>
      'Yansıtma başlamadı. Başlat\'a tekrar dokunun ve listeden TV\'nizi seçin.';

  @override
  String get openSmartViewOr =>
      'Yansıtmak için telefonunuzun hızlı ayarlarından Smart View veya Cast\'i açın.';

  @override
  String get quality => 'Kalite';

  @override
  String get adjustsToYourWi =>
      'En akıcı görüntü için Wi-Fi\'nize uyum sağlar.';

  @override
  String upToLowerIt(Object label) {
    return 'En fazla $label. Görüntü takılırsa düşürün.';
  }

  @override
  String get stillNeedHelp => 'Yardım mı lazım?';

  @override
  String get startingScreenMirroring => 'Ekran yansıtma başlatılıyor…';

  @override
  String mirroringTo(Object value) {
    return '$value cihazına yansıtılıyor';
  }

  @override
  String get stopping => 'Durduruluyor…';

  @override
  String get readyToMirror => 'Yansıtmaya hazır';

  @override
  String get beforeYouStart => 'Başlamadan önce';

  @override
  String get phoneAndTvAre => 'Telefon ve TV aynı Wi-Fi\'de';

  @override
  String get noVpnIsConnected => 'Telefonunuzda bağlı VPN yok';

  @override
  String get tvIsOnWith => 'TV açık ve Ekran Yansıtma etkin';

  @override
  String get phoneIsCloseTo => 'Telefon TV\'ye yakın';

  @override
  String get stopMirroring => 'Yansıtmayı durdur';

  @override
  String get startMirroring2 => 'Yansıtmayı başlat';

  @override
  String get stop => 'Durdur';

  @override
  String get start => 'Başlat';

  @override
  String get duration => 'Süre';

  @override
  String get adIsLoading => 'Reklam yükleniyor';

  @override
  String get ad => 'Reklam';

  @override
  String get mirrorYourScreenTo => 'Ekranınızı herhangi bir TV\'ye yansıtın';

  @override
  String get showYourPhoneOnThe =>
      'Tek dokunuşla telefonunuzu büyük ekranda gösterin — kablo yok, dert yok.';

  @override
  String get shareMemoriesWithThe =>
      'Anıları tüm odayla paylaşın ve kontrolü telefonunuzdan sürdürün.';

  @override
  String get castFromWebApps => 'Web ve uygulamalardan yayınlayın';

  @override
  String get sendVideosFromYoutube =>
      'YouTube, Facebook ve her web sitesindeki videoları doğrudan TV\'nize gönderin.';

  @override
  String pageOf(Object value, Object length) {
    return 'Sayfa $value/$length';
  }

  @override
  String get getStarted => 'Başlayın';

  @override
  String get localNetwork => 'Yerel ağ';

  @override
  String get findTvsAndStreaming =>
      'Wi-Fi ağınızdaki TV\'leri ve akış cihazlarını bulun.';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get showCastingControlsWhile =>
      'Diğer uygulamaları kullanırken yayın kontrollerini gösterin.';

  @override
  String get photosVideosMusic => 'Fotoğraf, video ve müzik';

  @override
  String get pickWhatYouWantTo =>
      'Galerinizden ve kitaplığınızdan yayınlamak istediğinizi seçin.';

  @override
  String get screenCapture => 'Ekran yakalama';

  @override
  String get mirrorYourScreenYoull =>
      'Ekranınızı yansıtın. Her oturumu onaylarsınız.';

  @override
  String get webVideo => 'Web videosu';

  @override
  String get link => 'Bağlantı';

  @override
  String get screenMirroring2 => 'Ekran yansıtma';

  @override
  String nowCastingOpenRemote(Object title) {
    return '$title yayınlanıyor. Kumandayı aç';
  }

  @override
  String castingTo2(Object value) {
    return '$value cihazına yayınlanıyor';
  }

  @override
  String get nowCasting => 'Şu an yayında';

  @override
  String get nothingIsCasting => 'Hiçbir şey yayınlanmıyor';

  @override
  String get pickAPhotoVideo =>
      'TV\'nize göndermek için bir fotoğraf, video, şarkı veya web videosu seçin.';

  @override
  String get backToHome => 'Ana sayfaya dön';

  @override
  String slide2(Object formatDuration) {
    return 'Slayt $formatDuration';
  }

  @override
  String get back10Seconds => '10 saniye geri';

  @override
  String get forward10Seconds => '10 saniye ileri';

  @override
  String get tvVolume => 'TV sesi';

  @override
  String tvVolumePercent(Object round) {
    return 'TV sesi yüzde $round';
  }

  @override
  String get upNext => 'Sıradaki';

  @override
  String get addPhotos => 'Fotoğraf ekle';

  @override
  String get addVideos => 'Video ekle';

  @override
  String get nothingElseInThe => 'Kuyrukta başka bir şey yok.';

  @override
  String play2(Object title) {
    return '$title oynat';
  }

  @override
  String get unknownDevice => 'Bilinmeyen cihaz';

  @override
  String get perWeek => 'haftalık';

  @override
  String get perYear => 'yıllık';

  @override
  String get payOnce => 'tek seferlik ödeme';

  @override
  String get wirelessScreenMirroring => 'Kablosuz ekran yansıtma';

  @override
  String get castVideosPhotosMusic => 'Video, fotoğraf ve müzik yayınlayın';

  @override
  String get fullTvRemoteControl => 'Tam TV kumanda kontrolü';

  @override
  String get worksWithAllMajor => 'Tüm büyük TV\'lerle çalışır';

  @override
  String get smoothLagFreeStreaming => 'Akıcı, takılmasız yayın';

  @override
  String get noAds => 'Reklam yok';

  @override
  String get welcomeToCastflowPro => 'CastFlow Pro\'ya hoş geldiniz!';

  @override
  String get purchaseCancelled => 'Satın alma iptal edildi.';

  @override
  String get purchasePendingProUnlocks =>
      'Satın alma beklemede. Mağaza onaylar onaylamaz Pro açılır.';

  @override
  String get purchaseFailedPleaseTry =>
      'Satın alma başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get theStoreIsntAvailable => 'Mağaza şu anda kullanılamıyor.';

  @override
  String get close => 'Kapat';

  @override
  String get goProWithCastflow => 'CASTFLOW İLE PRO OLUN';

  @override
  String get unlockEveryFeature => 'Tüm özelliklerin kilidini açın';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'İptal edilene kadar otomatik yenilenir.';

  @override
  String get oneTimePurchaseNo => 'Tek seferlik satın alma. Abonelik yok.';

  @override
  String get continueAction => 'Devam';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsAndConditions => 'Şartlar ve Koşullar';

  @override
  String get cancelAnytime => 'İstediğiniz zaman iptal edin';

  @override
  String get loadingPrice => 'Fiyat yükleniyor…';

  @override
  String get pricesUnavailableTapTo =>
      'Fiyatlar kullanılamıyor · Tekrar denemek için dokunun';

  @override
  String get noPlansAvailableRight => 'Şu anda kullanılabilir plan yok.';

  @override
  String get weekly => 'Haftalık';

  @override
  String get yearly => 'Yıllık';

  @override
  String get lifetime => 'Ömür boyu';

  @override
  String get bestValue => 'En iyi değer';

  @override
  String get disconnectFromTv => 'TV ile bağlantı kesilsin mi?';

  @override
  String get thisStopsWhatIs =>
      'Bu, şu anda oynatılan veya yansıtılan her şeyi durdurur.';

  @override
  String get useTouchpad => 'Dokunmatik yüzeyi kullan';

  @override
  String get useDPad => 'Yön tuşlarını kullan';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label alıcıları uzaktan kumanda komutlarını kabul etmez.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Bazı düğmeler $label üzerinde kullanılamıyor.';
  }

  @override
  String get idle => 'BOŞTA';

  @override
  String get playing => 'OYNATILIYOR';

  @override
  String get paused => 'DURAKLATILDI';

  @override
  String get noTvConnected => 'Bağlı TV yok';

  @override
  String get mute2 => 'SESSİZ';

  @override
  String vol(Object volume) {
    return 'SES $volume';
  }

  @override
  String get noTvConnectedTap => 'Bağlı TV yok. Cihaz seçmek için dokunun';

  @override
  String get tapToChooseA => 'Cihaz seçmek için dokunun';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label, $label2 tarafından desteklenmiyor';
  }

  @override
  String get touchpadSwipeToMove =>
      'Dokunmatik yüzey. Hareket için kaydırın, seçmek için dokunun.';

  @override
  String get swipeToMoveTap => 'Hareket için kaydırın · Seçmek için dokunun';

  @override
  String get navigationIsntSupportedBy =>
      'Gezinme bu TV tarafından desteklenmiyor';

  @override
  String get vol2 => 'SES';

  @override
  String get auto => 'Otomatik';

  @override
  String get automatic => 'Otomatik';

  @override
  String get googleCastFirst => 'Önce Google Cast';

  @override
  String get dlnaUpnpFirst => 'Önce DLNA / UPnP';

  @override
  String get miracastFirst => 'Önce Miracast';

  @override
  String get tvOnly => 'Yalnızca TV';

  @override
  String get phoneAndTv => 'Telefon ve TV';

  @override
  String get phoneOnly => 'Yalnızca telefon';

  @override
  String get touchpad => 'Dokunmatik yüzey';

  @override
  String get doMyPhoneAnd =>
      'Telefonum ve TV\'nin aynı Wi-Fi\'de olması gerekir mi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Evet. Keşif ve yayın yerel ağınızda kalır, bu yüzden ikisi de aynı Wi-Fi\'de olmalıdır (benzer bant adları farklı ağlar olabilir).';

  @override
  String get myRouterHasAp => 'Yönlendiricimde “AP / istemci yalıtımı” var';

  @override
  String get isolationBlocksDevicesFrom =>
      'Yalıtım cihazların birbirini görmesini engeller. Yönlendirici ayarlarında kapatın veya misafir olmayan bir ağ kullanın.';

  @override
  String get findingYourTv => 'TV\'nizi bulma';

  @override
  String get myTvDoesntAppear => 'TV\'m listede görünmüyor';

  @override
  String get turnOnCastingScreen =>
      'TV\'de yayını / ekran yansıtmayı açın, bekleme modundan uyandırın, sonra Yeniden tara\'ya dokunun. İstenirse Yerel Ağ iznini verin.';

  @override
  String get onlySomeDevicesShow => 'Yalnızca bazı cihazlar görünüyor';

  @override
  String get olderTvsMayNeed =>
      'Eski TV\'ler bellenim güncellemesi gerektirebilir. Miracast TV\'ler yalnızca “Ekran Yansıtma” girişi açıkken görünür.';

  @override
  String get connectionFailsOrTimes =>
      'Bağlantı başarısız oluyor veya zaman aşımına uğruyor';

  @override
  String get restartTheTvApp =>
      'TV uygulamasını veya TV\'yi yeniden başlatın, yönlendiriciye yaklaşın ve TV ekranındaki istemleri kabul edin.';

  @override
  String get itKeepsReconnectingTo =>
      'Sürekli eski bir TV\'ye yeniden bağlanıyor';

  @override
  String get turnOffAutoConnect =>
      'Ayarlar → Yayın\'da “Son TV\'ye otomatik bağlan”ı kapatın.';

  @override
  String get mirroringIsLaggy => 'Yansıtma takılıyor';

  @override
  String get chooseALowerQuality =>
      'Daha düşük kalite (720p veya 480p) seçin, ağır uygulamaları kapatın ve 5 GHz Wi-Fi ağı kullanın.';

  @override
  String get thePictureIsRotated => 'Görüntü döndürülmüş veya kırpılmış';

  @override
  String get toggleAutoRotateOn =>
      'Ekran Yansıtma ekranında Otomatik döndürme\'yi açıp kapatın.';

  @override
  String get sound => 'Ses';

  @override
  String get thereIsNoSound => 'TV\'de ses yok';

  @override
  String get makeSureAudioIs =>
      'Ekran Yansıtma\'da Ses\'in açık olduğundan emin olun ve Ayarlar → Yayın → Ses çıkışı\'nı kontrol edin. Bazı alıcılar telefon sesini desteklemez.';

  @override
  String get tvRemote2 => 'TV kumandası';

  @override
  String get someRemoteButtonsAre => 'Bazı kumanda düğmeleri gri';

  @override
  String get eachReceiverSupportsDifferent =>
      'Her alıcı farklı komutları destekler. Chromecast ve DLNA yalnızca oynatma ve sesi destekler; Miracast\'in kumanda kanalı yoktur.';

  @override
  String get canCastflowTurnMy =>
      'CastFlow TV\'mi açabilir veya girişi değiştirebilir mi?';

  @override
  String get onlyOnTvsThat =>
      'Yalnızca bu komutları ağ üzerinden sunan TV\'lerde. Desteklenmeyen düğmeler çalışıyormuş gibi davranmak yerine devre dışı bırakılır.';

  @override
  String get helpFaq => 'Yardım ve SSS';

  @override
  String get stepByStepConnection => 'Adım adım bağlantı rehberi';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'E-posta uygulaması bulunamadı.';

  @override
  String get enjoyingCastflow => 'CastFlow\'u beğendiniz mi?';

  @override
  String get sorryToHearThat => 'Bunu duyduğumuza üzüldük';

  @override
  String get thanksHowCanWe => 'Teşekkürler! Nasıl daha iyi olabiliriz?';

  @override
  String get wereGladYouLike => 'Beğendiğinize sevindik!';

  @override
  String get youMadeOurDay => 'Günümüzü güzelleştirdiniz!';

  @override
  String get tapToExit => 'Çıkmak için dokunun';

  @override
  String get selectARating => 'Bir puan seçin';

  @override
  String get sendFeedback => 'Geri bildirim gönder';

  @override
  String get rateUs => 'Bizi değerlendirin';

  @override
  String get rateYourExperienceBefore =>
      'Ayrılmadan önce deneyiminizi değerlendirin.';

  @override
  String get tapAStarTo =>
      'CastFlow\'u değerlendirmek için bir yıldıza dokunun.';

  @override
  String get general => 'Genel';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Varsayılan kalite';

  @override
  String get autoConnectToLast => 'Son TV\'ye otomatik bağlan';

  @override
  String get hapticFeedback => 'Dokunsal geri bildirim';

  @override
  String get clearCastingHistory => 'Yayın geçmişini temizle';

  @override
  String get clearCastingHistory2 => 'Yayın geçmişi temizlensin mi?';

  @override
  String get onlyCastflowsListIs =>
      'Yalnızca CastFlow\'un listesi temizlenir. Telefonunuzdaki medya asla silinmez.';

  @override
  String get appearance => 'Görünüm';

  @override
  String get light => 'Açık';

  @override
  String get dark => 'Koyu';

  @override
  String get system => 'Sistem';

  @override
  String get aboutSupport => 'Hakkında ve destek';

  @override
  String get rateApp => 'Uygulamayı değerlendir';

  @override
  String get feedback => 'Geri bildirim';

  @override
  String get termsConditions => 'Şartlar ve Koşullar';

  @override
  String get version => 'Sürüm';

  @override
  String get castflowProIsActive => 'CastFlow Pro etkin';

  @override
  String get upgradeToPremium => 'Premium\'a yükselt';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Desteğiniz için teşekkürler. Reklamsız yayının keyfini çıkarın.';

  @override
  String get noAds1080pMirroring =>
      'Reklamsız, 1080p yansıtma ve sınırsız yayın';

  @override
  String get upgrade => 'Yükselt';

  @override
  String get mirrorCastBeautifullySimple =>
      'Yansıtın ve yayınlayın, güzelce basit';

  @override
  String get thisActionMayContain => 'Bu işlem reklam içerebilir';

  @override
  String get webCast => 'Web yayını';

  @override
  String get castThisVideo => 'Bu videoyu yayınla';

  @override
  String get searchOrTypeAWeb => 'Ara veya web adresi yaz';

  @override
  String get removeBookmark => 'Yer işaretini kaldır';

  @override
  String get bookmark => 'Yer işareti';

  @override
  String get quickAccess => 'Hızlı erişim';

  @override
  String open2(Object title) {
    return '$title aç';
  }

  @override
  String get bookmarks => 'Yer işaretleri';

  @override
  String get noBookmarks => 'Yer işareti yok';

  @override
  String get tapTheBookmarkIcon =>
      'Bir sayfayı kaydetmek için adres çubuğundaki yer işareti simgesine dokunun.';

  @override
  String get noHistory => 'Geçmiş yok';

  @override
  String get pagesYouVisitShow => 'Gezdiğiniz sayfalar burada görünür.';

  @override
  String get remove => 'Kaldır';

  @override
  String resultOn(Object value, Object host) {
    return '$host üzerinde sonuç $value';
  }

  @override
  String get aSimulatedPageResult => 'Simüle edilmiş bir sayfa sonucu';

  @override
  String get videosOnThisPage => 'Bu sayfadaki videolar';

  @override
  String get pickOneToSend => 'TV\'nize göndermek için birini seçin.';

  @override
  String get onboardHotspotTitle => 'Wi-Fi yok mu? Hotspot kullanın';

  @override
  String get onboardHotspotBody =>
      'Telefonunuzun hotspot’unu açın ve TV’nizi bağlayın. Yayın Wi-Fi’deki gibi çalışır.';

  @override
  String get stillCantFindTitle => 'TV’nizi hâlâ bulamıyor musunuz?';

  @override
  String get stillCantFindBody => 'TV’nizi telefonunuzun hotspot’una bağlayın:';

  @override
  String get hotspotStep4 => 'Tekrar dene’ye dokunup listeden TV’nizi seçin';

  @override
  String get castOverHotspot =>
      'Wi-Fi yok mu? Telefonun hotspot’u üzerinden yayınlayın:';

  @override
  String get queue => 'Sıra';

  @override
  String get addMusic => 'Müzik ekle';

  @override
  String get connectWithWifi => 'Wi-Fi ile bağlan';

  @override
  String get continueWithHotspot => 'Hotspot ile devam et';

  @override
  String get noWifiAlertMessage =>
      'Mobil veri kullanıyorsunuz. Telefonu ve TV\'yi aynı Wi-Fi ağına bağlayın ya da telefonun hotspot\'unu açıp TV\'yi ona bağlayın.';
}
