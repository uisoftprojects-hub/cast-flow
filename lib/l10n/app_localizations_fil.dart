// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get networkRequiredTitle => 'Hindi nakakonekta sa Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Dapat nasa iisang Wi-Fi network ang iyong telepono at TV para makapag-cast.';

  @override
  String get openWifiSettings => 'Buksan ang Mga Setting ng Wi-Fi';

  @override
  String get useMobileHotspot => 'Gamitin ang Mobile Hotspot';

  @override
  String get hotspotInstruction =>
      'Ikonekta ang iyong LCD/TV sa iyong mobile hotspot.';

  @override
  String get hotspotStep1 => 'I-on ang mobile hotspot';

  @override
  String get hotspotStep2 => 'Ikonekta ang iyong TV dito';

  @override
  String get hotspotStep3 => 'Bumalik sa app';

  @override
  String get openHotspotSettings => 'Buksan ang Mga Setting ng Hotspot';

  @override
  String get hotspotAutoCheck =>
      'Awtomatiko naming susuriin muli kapag bumalik ka.';

  @override
  String get hotspotDetected => 'Naka-on ang hotspot. Hinahanap ang iyong TV…';

  @override
  String get searchingDevices => 'Naghahanap ng mga kalapit na device...';

  @override
  String get waitingForTvOnHotspot =>
      'Hinihintay na sumali ang iyong TV sa iyong hotspot…';

  @override
  String get usingHotspot => 'Ginagamit ang iyong mobile hotspot';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count device ang nakita',
      one: '1 device ang nakita',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Subukan muli';

  @override
  String get scanAgain => 'I-scan muli';

  @override
  String get isolationTitle => 'Hindi tumutugon ang TV';

  @override
  String get isolationHint =>
      'May device na sumali sa iyong hotspot pero hindi tumutugon. Maaaring hinaharang ng iyong hotspot ang trapiko sa pagitan ng mga device (client isolation). I-off ito sa mga setting ng hotspot, o gumamit ng Wi-Fi network.';

  @override
  String get connecting => 'Kumokonekta…';

  @override
  String get connected => 'Nakakonekta';

  @override
  String get connectionFailed => 'Hindi makakonekta';

  @override
  String get connectFailedHint =>
      'Tiyaking nasa iisang network ang iyong telepono at TV, pagkatapos ay subukan muli.';

  @override
  String get hotspotConnectHint =>
      'Maaaring hinaharang ng iyong hotspot ang trapiko sa pagitan ng mga device. Suriin ang setting nito para sa client isolation.';

  @override
  String get networkLostTitle => 'Nawala ang koneksyon sa network';

  @override
  String get networkLostMessage =>
      'Kumonekta muli sa Wi-Fi o sa iyong hotspot, pagkatapos ay kumonekta muli sa iyong TV.';

  @override
  String get reconnect => 'Kumonekta muli';

  @override
  String reconnectTo(String name) {
    return 'Kumonekta muli sa $name';
  }

  @override
  String get tapToReconnect => 'I-tap para kumonekta muli';

  @override
  String get pairingRequired => 'Kailangan ng pagpapares';

  @override
  String get pairingEnterCode => 'Ilagay ang code na ipinapakita sa iyong TV.';

  @override
  String get pairingApproveOnTv =>
      'Tingnan ang iyong TV at i-tap ang Payagan para magpatuloy.';

  @override
  String get connect => 'Kumonekta';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get pairingIncorrectCode => 'Maling code. Subukan muli.';

  @override
  String get pairingTimedOut => 'Nag-time out ang pagpapares';

  @override
  String get tryAgain => 'Subukan muli';

  @override
  String get pairingDeclined => 'Tinanggihan ng TV ang koneksyon';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Masyadong maraming maling code. Maghintay ng $seconds s, pagkatapos ay humiling ng bagong code.';
  }

  @override
  String get pairingCooldownOver => 'Maaari ka nang humiling ng bagong code.';

  @override
  String get pairingRequestNewCode => 'Humiling ng bagong code';

  @override
  String get pairingNetworkLost =>
      'Nawala ang network habang nagpapares. Kumonekta muli sa Wi-Fi at subukan muli.';

  @override
  String get pairingFailed => 'Hindi makapares sa TV.';

  @override
  String pairingCodeField(int length) {
    return 'Code ng pagpapares, $length na character';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Kahon ng code $index sa $total';
  }

  @override
  String get pairingEmptyBox => 'walang laman';

  @override
  String get pairingPaired => 'Napares';

  @override
  String get forgetDevice => 'Kalimutan ang device';

  @override
  String forgetDeviceMessage(String name) {
    return 'Kakailanganing ipares muli ang $name sa susunod.';
  }

  @override
  String get forget => 'Kalimutan';

  @override
  String get castVideo => 'I-cast ang video';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video ang nakita. I-cast ang video',
      one: '1 video ang nakita. I-cast ang video',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Wala pang nakitang video sa page na ito.';

  @override
  String get videoFound => 'May nakitang video';

  @override
  String get videoFoundMessage => 'I-play ito sa iyong TV.';

  @override
  String get castAction => 'I-cast';

  @override
  String get dismiss => 'Isara';

  @override
  String videosFound(int count) {
    return 'Mga video na nakita ($count)';
  }

  @override
  String get castToTv => 'I-cast sa TV';

  @override
  String get protectedVideo => 'Protektado, hindi maaaring i-cast';

  @override
  String get videoThumbnail => 'Thumbnail ng video';

  @override
  String castingTo(String device) {
    return 'Nagka-cast sa $device';
  }

  @override
  String get stopCasting => 'Ihinto ang pag-cast';

  @override
  String get play => 'I-play';

  @override
  String get pause => 'I-pause';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Posisyon ng playback';

  @override
  String get showControls => 'Ipakita ang mga kontrol';

  @override
  String get hideControls => 'Itago ang mga kontrol';

  @override
  String get formatUnsupportedTitle => 'Hindi sinusuportahan ang format';

  @override
  String formatUnsupported(String device, String format) {
    return 'Hindi mapapatugtog ng $device ang mga video na $format. Subukan ang ibang video sa page na ito, o gamitin ang screen mirroring.';
  }

  @override
  String get videoExpired =>
      'Nag-expire na ang link ng video na ito. I-reload ang page at subukan muli.';

  @override
  String get refreshingVideo => 'Kumukuha ng bagong link ng video…';

  @override
  String get browserBack => 'Bumalik';

  @override
  String get browserForward => 'Pasulong';

  @override
  String get browserStartPage => 'Panimulang page';

  @override
  String get browserReload => 'I-reload';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Home';

  @override
  String get devices => 'Mga Device';

  @override
  String get history => 'History';

  @override
  String get settings => 'Mga Setting';

  @override
  String get goodMorning => 'Magandang umaga';

  @override
  String get goodAfternoon => 'Magandang hapon';

  @override
  String get goodEvening => 'Magandang gabi';

  @override
  String get couldntOpenTheLink => 'Hindi mabuksan ang link.';

  @override
  String get castflowLogo => 'Logo ng I-cast sa TV';

  @override
  String get somethingWentWrong => 'May nangyaring mali';

  @override
  String get weCouldntLoadThis =>
      'Hindi namin ito nai-load ngayon. Pakisubukan muli.';

  @override
  String get apps => 'Mga App';

  @override
  String open(Object name) {
    return 'Buksan ang $name';
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
  String get up => 'Pataas';

  @override
  String get down => 'Pababa';

  @override
  String get left => 'Kaliwa';

  @override
  String get right => 'Kanan';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Input';

  @override
  String get playPause => 'I-play / I-pause';

  @override
  String get previous => 'Nakaraan';

  @override
  String get next => 'Susunod';

  @override
  String get rewind => 'I-rewind';

  @override
  String get volumeUp => 'Lakasan ang volume';

  @override
  String get volumeDown => 'Hinaan ang volume';

  @override
  String get mute => 'I-mute';

  @override
  String connectedTo(Object name) {
    return 'Nakakonekta sa $name';
  }

  @override
  String get chooseADevice => 'Pumili ng device';

  @override
  String get connectionGuide => 'Gabay sa koneksyon';

  @override
  String get lookingForTvsOn => 'Naghahanap ng mga TV sa iyong Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return '$found ang nakita sa ngayon';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found device$value ang nakita';
  }

  @override
  String get disconnect => 'Idiskonekta';

  @override
  String signalOf4(Object level) {
    return 'Signal $level sa 4';
  }

  @override
  String get connecting2 => 'Kumokonekta';

  @override
  String get theTvRemoteNeeds =>
      'Kailangan ng nakakonektang TV ng remote ng TV. Pumili ng isa sa ibaba.';

  @override
  String get connectToATv => 'Kumonekta sa TV para magpatuloy.';

  @override
  String get findingTvs => 'Naghahanap ng mga TV…';

  @override
  String get makeSureYourTv => 'Tiyaking naka-on ang iyong TV';

  @override
  String get notConnected => 'Hindi nakakonekta';

  @override
  String get tapToFindYour => 'I-tap para hanapin ang iyong TV';

  @override
  String get connectionFailed2 => 'Nabigo ang koneksyon';

  @override
  String tapToManageDevices(Object label) {
    return '$label. I-tap para pamahalaan ang mga device';
  }

  @override
  String get joinTheSameWi => 'Sumali sa parehong Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Ikonekta ang iyong telepono at TV sa iisang Wi-Fi network.';

  @override
  String get turnOnCastingOn => 'I-on ang pag-cast sa iyong TV';

  @override
  String get enableScreenMirroringMiracast =>
      'I-enable ang Screen Mirroring, Miracast o Google Cast sa mga setting ng TV.';

  @override
  String get scanForDevices => 'Maghanap ng mga device';

  @override
  String get openDevicesInCastflow =>
      'Buksan ang Mga Device sa I-cast sa TV at maghintay ng ilang segundo hanggang lumabas ang iyong TV.';

  @override
  String get tapConnect => 'I-tap ang Kumonekta';

  @override
  String get acceptThePromptOn =>
      'Tanggapin ang prompt sa iyong TV kung may lumabas. Iyon na!';

  @override
  String get howToConnect => 'Paano kumonekta';

  @override
  String get fourQuickStepsTo =>
      'Apat na mabilis na hakbang papunta sa malaking screen.';

  @override
  String get gotIt => 'Sige';

  @override
  String step(Object number, Object title, Object body) {
    return 'Hakbang $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi sa bahay';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Mga Setting › Koneksyon';

  @override
  String get inputHdmi1 => 'Input: HDMI 1';

  @override
  String get screenMirroring => 'Screen Mirroring';

  @override
  String get networkHomeWiFi => 'Network: Wi-Fi sa bahay';

  @override
  String get livingRoomTv => 'TV sa Sala';

  @override
  String get allowCastflowToConnect => 'Payagan ang I-cast sa TV na kumonekta?';

  @override
  String get deny => 'Tanggihan';

  @override
  String get allow => 'Payagan';

  @override
  String get yourTv => 'Ang iyong TV';

  @override
  String get findYourTv => 'Hanapin ang iyong TV';

  @override
  String connectTo(Object name) {
    return 'Kumonekta sa $name';
  }

  @override
  String connected2(Object label) {
    return 'Nakakonekta · $label';
  }

  @override
  String get openTvRemote => 'Buksan ang remote ng TV';

  @override
  String get sameWiFiNetwork => 'Parehong Wi-Fi network';

  @override
  String get yourPhoneAndTv =>
      'Dapat nakakonekta sa iisang Wi-Fi ang iyong telepono at TV.';

  @override
  String get tvIsOnAnd => 'Naka-on ang TV at handa na';

  @override
  String get turnOnScreenMirroring =>
      'I-on ang Screen Mirroring, Cast o Miracast sa TV.';

  @override
  String get noVpnOrGuest => 'Walang VPN o guest network';

  @override
  String get vpnsAndGuestIsolated =>
      'Itinatago ng mga VPN at guest / isolated na Wi-Fi ang mga device sa isa’t isa.';

  @override
  String get localNetworkAccess => 'Access sa lokal na network';

  @override
  String get allowCastflowToFind =>
      'Payagan ang I-cast sa TV na maghanap ng mga device sa iyong network kapag hiniling.';

  @override
  String get noTvFound => 'Walang nakitang TV';

  @override
  String get checkThatYourPhone =>
      'Tiyaking nakakonekta ang iyong telepono at TV sa iisang Wi-Fi, pagkatapos ay mag-scan muli.';

  @override
  String get noWiFiRouter => 'Walang Wi-Fi router? Gamitin ang iyong hotspot';

  @override
  String searchingForTvsFound(Object length) {
    return 'Naghahanap ng mga TV. $length ang nakita.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TV ang nakita';
  }

  @override
  String get connectToYourTv => 'Kumonekta sa iyong TV';

  @override
  String get connectYourPhoneAndTv =>
      'Ikonekta ang iyong telepono at TV sa iisang Wi-Fi network.';

  @override
  String get turnOnTheTv =>
      'I-on ang TV at buksan ang Screen Mirroring / Cast input nito.';

  @override
  String get tapTheConnectionBar =>
      'I-tap ang connection bar sa Home para hanapin ang iyong TV.';

  @override
  String get tapConnectAndAccept =>
      'I-tap ang Kumonekta at tanggapin ang prompt sa TV kung may lumabas.';

  @override
  String get mirrorYourScreen => 'I-mirror ang iyong screen';

  @override
  String get connectToYourTvFirst => 'Kumonekta muna sa iyong TV.';

  @override
  String get openScreenMirroringFrom =>
      'Buksan ang Screen Mirroring mula sa Home.';

  @override
  String get pickAQualityAnd => 'Pumili ng kalidad at i-tap ang Simulan.';

  @override
  String get allowScreenCaptureWhen =>
      'Payagan ang screen capture kapag nagtanong ang Android.';

  @override
  String get castPhotosVideosMusic =>
      'Mag-cast ng mga larawan, video at musika';

  @override
  String get openPhotosVideosOr =>
      'Buksan ang Mga Larawan, Video o Musika sa Home.';

  @override
  String get pickWhatYouWant => 'Piliin kung ano ang gusto mong ipakita.';

  @override
  String get itPlaysOnThe =>
      'Pinapatugtog ito sa TV; kontrolin ito mula sa iyong telepono o sa notification.';

  @override
  String get useTheTvRemote => 'Gamitin ang remote ng TV';

  @override
  String get openTvRemoteOn => 'Buksan ang Remote ng TV sa Home.';

  @override
  String get useTheDPad =>
      'Gamitin ang D-pad o mag-swipe sa touchpad para gumalaw, i-tap ang OK para pumili.';

  @override
  String get buttonsATvDoesnt =>
      'Ang mga button na hindi sinusuportahan ng TV ay naka-gray.';

  @override
  String get castFromTheWeb => 'Mag-cast mula sa web at mga app';

  @override
  String get tapTheBrowserBar => 'I-tap ang browser bar o isang app sa Home.';

  @override
  String get playAVideoOn => 'Mag-play ng video sa site.';

  @override
  String get tapCastThisVideo =>
      'I-tap ang “I-cast ang video na ito” para ipadala ito sa iyong TV.';

  @override
  String get screenMirroringHelp => 'Tulong sa screen mirroring';

  @override
  String get connectYourPhoneTo => 'Ikonekta ang iyong telepono sa Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Sa TV, buksan ang Mga Setting → Network at sumali sa parehong Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Madalas hinaharang ng guest o office network ang mirroring; gamitin ang Wi-Fi sa bahay o ang hotspot ng iyong telepono.';

  @override
  String get turnOffVpn => 'I-off ang VPN';

  @override
  String get aVpnHidesYour =>
      'Itinatago ng VPN ang iyong TV sa iyong telepono.';

  @override
  String get pauseOrDisconnectYour =>
      'I-pause o idiskonekta ang iyong VPN app bago ka magsimula.';

  @override
  String get youCanTurnIt => 'Maaari mo itong i-on muli kapag tapos ka na.';

  @override
  String get turnOnMirroringOn => 'I-on ang mirroring sa TV';

  @override
  String get samsungLgAndMost =>
      'Awtomatikong tinatanggap ng Samsung, LG at karamihan ng Android TV ang mirroring.';

  @override
  String get otherTvsOpenInput =>
      'Ibang TV: buksan ang Input / Source at piliin ang Screen Mirroring o Miracast.';

  @override
  String get keepTheTvOn =>
      'Panatilihin ang TV sa screen na iyon habang kumokonekta ang iyong telepono.';

  @override
  String get tapStartAndPick => 'I-tap ang Simulan at piliin ang iyong TV';

  @override
  String get tapStartOnThe =>
      'I-tap ang Simulan sa screen ng Screen Mirroring.';

  @override
  String get androidOpensSmartView =>
      'Bubuksan ng Android ang Smart View / Cast. I-tap ang iyong TV sa listahan.';

  @override
  String get ifTheTvAsks =>
      'Kung magtanong ang TV, piliin ang Payagan o ilagay ang PIN na ipinapakita sa screen.';

  @override
  String get youreMirroring => 'Nagmi-mirror ka';

  @override
  String get everythingOnYourPhone =>
      'Lahat ng nasa iyong telepono ay makikita na ngayon sa TV.';

  @override
  String get turnThePhoneSideways =>
      'Ihiga ang telepono para sa full-screen na mga video at laro.';

  @override
  String get toStopTapStop =>
      'Para huminto, i-tap ang Ihinto o gamitin ang cast notification.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Off';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'TV sa Kuwarto';

  @override
  String get officeDisplay => 'Display sa opisina';

  @override
  String get clearHistory => 'I-clear ang history?';

  @override
  String get thisRemovesEverythingYouve =>
      'Aalisin nito sa listahang ito ang lahat ng na-cast mo.';

  @override
  String get clear => 'I-clear';

  @override
  String get clearHistory2 => 'I-clear ang history';

  @override
  String get noHistoryYet => 'Wala pang history';

  @override
  String get everythingYouCastWill =>
      'Ililista rito ang lahat ng ica-cast mo para madali mo itong mahanap muli.';

  @override
  String get today => 'Ngayon';

  @override
  String get yesterday => 'Kahapon';

  @override
  String get earlier => 'Mas maaga';

  @override
  String get swipeAnItemTo => 'I-swipe ang isang item para alisin ito';

  @override
  String get delete => 'Burahin';

  @override
  String removed(Object title) {
    return 'Inalis ang “$title”';
  }

  @override
  String get undo => 'I-undo';

  @override
  String get photos => 'Mga Larawan';

  @override
  String get albums => 'Mga Album';

  @override
  String get videos => 'Mga Video';

  @override
  String get gallery => 'Gallery';

  @override
  String get music => 'Musika';

  @override
  String get songs => 'Mga Kanta';

  @override
  String get media => 'Media';

  @override
  String get browseTheWeb => 'Mag-browse sa web';

  @override
  String get goPro => 'Mag-Pro';

  @override
  String cast(Object title) {
    return 'I-cast ang $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Screen Mirroring. Simulan ang mirroring';

  @override
  String readyToMirrorTo(Object device) {
    return 'Handa nang mag-mirror sa $device';
  }

  @override
  String get showYourPhoneOn =>
      'Ipakita ang iyong telepono sa TV nang real time.';

  @override
  String get startMirroring => 'Simulan ang Mirroring';

  @override
  String get tvRemote => 'Remote ng TV';

  @override
  String get controlYourTv => 'Kontrolin ang iyong TV';

  @override
  String get youtubeMore => 'YouTube at iba pa';

  @override
  String get openTheBrowser => 'Buksan ang browser';

  @override
  String get searchOrTypeA => 'Maghanap o mag-type ng website';

  @override
  String get howToConnectOpen => 'Paano kumonekta. Buksan ang visual na gabay';

  @override
  String get visualGuideForEvery => 'Visual na gabay para sa bawat feature';

  @override
  String get language => 'Wika';

  @override
  String get done => 'Tapos na';

  @override
  String get enterAValidHttp =>
      'Maglagay ng wastong http(s) o rtsp na link, hal. isang .m3u8 o .mp4 na URL.';

  @override
  String get linkStream => 'Link stream';

  @override
  String get iptvLinkCast => 'IPTV / Link Cast';

  @override
  String get castALink => 'Mag-cast ng link';

  @override
  String get pasteADirectVideo =>
      'I-paste ang direktang video, M3U8 o IPTV stream URL.';

  @override
  String get paste => 'I-paste';

  @override
  String get castLink => 'I-cast ang link';

  @override
  String get allowAccessToYour =>
      'Payagan ang access sa iyong media para ma-cast ito. Maaari mo itong baguhin sa Mga Setting.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'I-cast ang Musika';

  @override
  String get noMusicFound => 'Walang nakitang musika';

  @override
  String get addSongsToYour =>
      'Magdagdag ng mga kanta sa iyong telepono at lalabas ang mga ito rito.';

  @override
  String get shuffle => 'I-shuffle';

  @override
  String get playAll => 'I-play lahat';

  @override
  String photo(Object formatShortDate) {
    return 'Larawan · $formatShortDate';
  }

  @override
  String get photo2 => 'Larawan';

  @override
  String get castPhotos => 'I-cast ang Mga Larawan';

  @override
  String get select => 'Pumili';

  @override
  String get noPhotosHere => 'Walang mga larawan dito';

  @override
  String get photosYouTakeOr =>
      'Lalabas sa album na ito ang mga larawang kukunan o ise-save mo.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count larawan';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Larawan mula $formatShortDate';
  }

  @override
  String get allPhotos => 'Lahat ng larawan';

  @override
  String get slideshow => 'Slideshow';

  @override
  String get interval => 'Agwat';

  @override
  String get transition => 'Transition';

  @override
  String get fade => 'Fade';

  @override
  String get slide => 'Slide';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Simulan ang slideshow';

  @override
  String get castVideos => 'I-cast ang Mga Video';

  @override
  String get noVideosYet => 'Wala pang mga video';

  @override
  String get videosYouRecordOr =>
      'Lalabas dito ang mga video na ire-record o ida-download mo, handa nang i-cast.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. I-cast';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Session ng screen mirroring';

  @override
  String get mirroringDidntStartTap =>
      'Hindi nagsimula ang mirroring. I-tap muli ang Simulan at piliin ang iyong TV sa listahan.';

  @override
  String get openSmartViewOr =>
      'Buksan ang Smart View o Cast mula sa mabilisang setting ng iyong telepono para mag-mirror.';

  @override
  String get quality => 'Kalidad';

  @override
  String get adjustsToYourWi =>
      'Nag-aadjust sa iyong Wi-Fi para sa pinakamakinis na larawan.';

  @override
  String upToLowerIt(Object label) {
    return 'Hanggang $label. Ibaba ito kung pumipiyok ang larawan.';
  }

  @override
  String get stillNeedHelp => 'Kailangan pa ng tulong?';

  @override
  String get startingScreenMirroring => 'Sinisimulan ang screen mirroring…';

  @override
  String mirroringTo(Object value) {
    return 'Nagmi-mirror sa $value';
  }

  @override
  String get stopping => 'Humihinto…';

  @override
  String get readyToMirror => 'Handa nang mag-mirror';

  @override
  String get beforeYouStart => 'Bago ka magsimula';

  @override
  String get phoneAndTvAre => 'Nasa iisang Wi-Fi ang telepono at TV';

  @override
  String get noVpnIsConnected => 'Walang VPN na nakakonekta sa iyong telepono';

  @override
  String get tvIsOnWith => 'Naka-on ang TV at naka-enable ang Screen Mirroring';

  @override
  String get phoneIsCloseTo => 'Malapit ang telepono sa TV';

  @override
  String get stopMirroring => 'Ihinto ang mirroring';

  @override
  String get startMirroring2 => 'Simulan ang mirroring';

  @override
  String get stop => 'Ihinto';

  @override
  String get start => 'Simulan';

  @override
  String get duration => 'Tagal';

  @override
  String get adIsLoading => 'Naglo-load ang ad';

  @override
  String get ad => 'Ad';

  @override
  String get mirrorYourScreenTo =>
      'I-mirror ang iyong screen sa kahit anong TV';

  @override
  String get showYourPhoneOnThe =>
      'Ipakita ang iyong telepono sa malaking screen sa isang tap — walang kable, walang abala.';

  @override
  String get shareMemoriesWithThe =>
      'Ibahagi ang mga alaala sa buong kuwarto at manatiling may kontrol mula sa iyong telepono.';

  @override
  String get castFromWebApps => 'Mag-cast mula sa web at mga app';

  @override
  String get sendVideosFromYoutube =>
      'Magpadala ng mga video mula sa YouTube, Facebook at anumang website diretso sa iyong TV.';

  @override
  String pageOf(Object value, Object length) {
    return 'Page $value sa $length';
  }

  @override
  String get getStarted => 'Magsimula';

  @override
  String get localNetwork => 'Lokal na Network';

  @override
  String get findTvsAndStreaming =>
      'Maghanap ng mga TV at streaming device sa iyong Wi-Fi.';

  @override
  String get notifications => 'Mga Notification';

  @override
  String get showCastingControlsWhile =>
      'Ipakita ang mga kontrol sa pag-cast habang gumagamit ka ng ibang app.';

  @override
  String get photosVideosMusic => 'Mga Larawan, Video at Musika';

  @override
  String get pickWhatYouWantTo =>
      'Piliin kung ano ang gusto mong i-cast mula sa iyong gallery at library.';

  @override
  String get screenCapture => 'Screen Capture';

  @override
  String get mirrorYourScreenYoull =>
      'I-mirror ang iyong screen. Kukumpirmahin mo ang bawat session.';

  @override
  String get webVideo => 'Web video';

  @override
  String get link => 'Link';

  @override
  String get screenMirroring2 => 'Screen mirroring';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Kasalukuyang nagka-cast ng $title. Buksan ang remote';
  }

  @override
  String castingTo2(Object value) {
    return 'Nagka-cast sa $value';
  }

  @override
  String get nowCasting => 'Kasalukuyang nagka-cast';

  @override
  String get nothingIsCasting => 'Walang nagka-cast';

  @override
  String get pickAPhotoVideo =>
      'Pumili ng larawan, video, kanta o web video para ipadala ito sa iyong TV.';

  @override
  String get backToHome => 'Bumalik sa home';

  @override
  String slide2(Object formatDuration) {
    return 'Slide $formatDuration';
  }

  @override
  String get back10Seconds => 'Bumalik ng 10 segundo';

  @override
  String get forward10Seconds => 'Pasulong ng 10 segundo';

  @override
  String get tvVolume => 'Volume ng TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Volume ng TV $round porsiyento';
  }

  @override
  String get upNext => 'Susunod';

  @override
  String get addPhotos => 'Magdagdag ng mga larawan';

  @override
  String get addVideos => 'Magdagdag ng mga video';

  @override
  String get nothingElseInThe => 'Wala nang iba sa pila.';

  @override
  String play2(Object title) {
    return 'I-play ang $title';
  }

  @override
  String get unknownDevice => 'Hindi kilalang device';

  @override
  String get perWeek => 'bawat linggo';

  @override
  String get perYear => 'bawat taon';

  @override
  String get payOnce => 'isang beses na bayad';

  @override
  String get wirelessScreenMirroring => 'Wireless na screen mirroring';

  @override
  String get castVideosPhotosMusic =>
      'Mag-cast ng mga video, larawan at musika';

  @override
  String get fullTvRemoteControl => 'Buong remote control ng TV';

  @override
  String get worksWithAllMajor => 'Gumagana sa lahat ng pangunahing TV';

  @override
  String get smoothLagFreeStreaming => 'Makinis at walang lag na streaming';

  @override
  String get noAds => 'Walang ad';

  @override
  String get welcomeToCastflowPro =>
      'Maligayang pagdating sa I-cast sa TV Pro!';

  @override
  String get purchaseCancelled => 'Kinansela ang pagbili.';

  @override
  String get purchasePendingProUnlocks =>
      'Nakabinbin ang pagbili. Mag-a-unlock ang Pro sa sandaling kumpirmahin ito ng store.';

  @override
  String get purchaseFailedPleaseTry => 'Nabigo ang pagbili. Pakisubukan muli.';

  @override
  String get theStoreIsntAvailable => 'Hindi available ang store ngayon.';

  @override
  String get close => 'Isara';

  @override
  String get goProWithCastflow => 'MAG-PRO GAMIT ANG I-CAST SA TV';

  @override
  String get unlockEveryFeature => 'I-unlock ang bawat feature';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Awtomatikong nagre-renew hanggang makansela.';

  @override
  String get oneTimePurchaseNo =>
      'Isang beses na pagbili. Walang subscription.';

  @override
  String get continueAction => 'Magpatuloy';

  @override
  String get privacyPolicy => 'Patakaran sa Privacy';

  @override
  String get termsAndConditions => 'Mga Tuntunin at Kundisyon';

  @override
  String get cancelAnytime => 'Kanselahin anumang oras';

  @override
  String get loadingPrice => 'Naglo-load ng presyo…';

  @override
  String get pricesUnavailableTapTo =>
      'Hindi available ang mga presyo · I-tap para subukan muli';

  @override
  String get noPlansAvailableRight => 'Walang available na plano ngayon.';

  @override
  String get weekly => 'Lingguhan';

  @override
  String get yearly => 'Taunan';

  @override
  String get lifetime => 'Panghabambuhay';

  @override
  String get bestValue => 'Pinakamagandang halaga';

  @override
  String get disconnectFromTv => 'Idiskonekta sa TV?';

  @override
  String get thisStopsWhatIs =>
      'Ihihinto nito ang kasalukuyang pinapatugtog o minimirror.';

  @override
  String get useTouchpad => 'Gamitin ang touchpad';

  @override
  String get useDPad => 'Gamitin ang D-pad';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Hindi tumatanggap ng mga remote command ang mga receiver na $label.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'May ilang button na hindi available sa $label.';
  }

  @override
  String get idle => 'IDLE';

  @override
  String get playing => 'NAGPLAPLAY';

  @override
  String get paused => 'NAKA-PAUSE';

  @override
  String get noTvConnected => 'Walang nakakonektang TV';

  @override
  String get mute2 => 'MUTE';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Walang nakakonektang TV. I-tap para pumili ng device';

  @override
  String get tapToChooseA => 'I-tap para pumili ng device';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return 'Hindi sinusuportahan ng $label2 ang $label';
  }

  @override
  String get touchpadSwipeToMove =>
      'Touchpad. Mag-swipe para gumalaw, mag-tap para pumili.';

  @override
  String get swipeToMoveTap => 'Mag-swipe para gumalaw · Mag-tap para pumili';

  @override
  String get navigationIsntSupportedBy =>
      'Hindi sinusuportahan ng TV na ito ang nabigasyon';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Awtomatiko';

  @override
  String get googleCastFirst => 'Google Cast muna';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP muna';

  @override
  String get miracastFirst => 'Miracast muna';

  @override
  String get tvOnly => 'TV lang';

  @override
  String get phoneAndTv => 'Telepono at TV';

  @override
  String get phoneOnly => 'Telepono lang';

  @override
  String get touchpad => 'Touchpad';

  @override
  String get doMyPhoneAnd =>
      'Kailangan ba ng parehong Wi-Fi ng aking telepono at TV?';

  @override
  String get yesDiscoveryAndCasting =>
      'Oo. Nananatili sa iyong lokal na network ang paghahanap at pag-cast, kaya dapat nasa iisang Wi-Fi ang dalawa (maaari pa ring magkaibang network ang magkaparehong pangalan ng band).';

  @override
  String get myRouterHasAp => 'May “AP / client isolation” ang aking router';

  @override
  String get isolationBlocksDevicesFrom =>
      'Pinipigilan ng isolation ang mga device na makita ang isa’t isa. I-off ito sa mga setting ng router, o gumamit ng hindi guest na network.';

  @override
  String get findingYourTv => 'Hinahanap ang iyong TV';

  @override
  String get myTvDoesntAppear => 'Hindi lumalabas ang aking TV sa listahan';

  @override
  String get turnOnCastingScreen =>
      'I-on ang pag-cast / screen mirroring sa TV, gisingin ito mula sa standby, pagkatapos ay i-tap ang I-scan muli. Payagan ang permiso ng Lokal na Network kung hihilingin.';

  @override
  String get onlySomeDevicesShow => 'Ilang device lang ang lumalabas';

  @override
  String get olderTvsMayNeed =>
      'Maaaring kailanganin ng mas lumang TV ng firmware update. Lumalabas lang ang mga Miracast TV habang bukas ang kanilang “Screen Mirroring” input.';

  @override
  String get connectionFailsOrTimes =>
      'Nabibigo o nagti-time out ang koneksyon';

  @override
  String get restartTheTvApp =>
      'I-restart ang TV app o ang TV, lumapit sa router, at tanggapin ang anumang prompt na lumalabas sa screen ng TV.';

  @override
  String get itKeepsReconnectingTo => 'Patuloy itong kumokonekta sa lumang TV';

  @override
  String get turnOffAutoConnect =>
      'I-off ang “Auto-connect sa huling TV” sa Mga Setting → Pag-cast.';

  @override
  String get mirroringIsLaggy => 'Nag-lag ang mirroring';

  @override
  String get chooseALowerQuality =>
      'Pumili ng mas mababang kalidad (720p o 480p), isara ang mabibigat na app at gumamit ng 5 GHz na Wi-Fi network.';

  @override
  String get thePictureIsRotated => 'Naka-rotate o naka-crop ang larawan';

  @override
  String get toggleAutoRotateOn =>
      'I-toggle ang Auto-rotate sa screen ng Screen Mirroring.';

  @override
  String get sound => 'Tunog';

  @override
  String get thereIsNoSound => 'Walang tunog sa TV';

  @override
  String get makeSureAudioIs =>
      'Tiyaking naka-on ang Audio sa Screen Mirroring at suriin ang Mga Setting → Pag-cast → Audio output. May ilang receiver na hindi sumusuporta sa audio ng telepono.';

  @override
  String get tvRemote2 => 'Remote ng TV';

  @override
  String get someRemoteButtonsAre => 'May ilang button ng remote na naka-gray';

  @override
  String get eachReceiverSupportsDifferent =>
      'Iba-iba ang sinusuportahang command ng bawat receiver. Playback at volume lang ang sinusuportahan ng Chromecast at DLNA; walang remote channel ang Miracast.';

  @override
  String get canCastflowTurnMy =>
      'Kaya bang i-on ng I-cast sa TV ang aking TV o palitan ang mga input?';

  @override
  String get onlyOnTvsThat =>
      'Sa mga TV lang na naglalantad ng mga command na iyon sa network. Dini-disable ang mga hindi sinusuportahang button sa halip na magkunwaring gumagana.';

  @override
  String get helpFaq => 'Tulong at FAQ';

  @override
  String get stepByStepConnection => 'Hakbang-hakbang na gabay sa koneksyon';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Walang nakitang email app.';

  @override
  String get enjoyingCastflow => 'Nasisiyahan ka ba sa I-cast sa TV?';

  @override
  String get sorryToHearThat => 'Pasensya na sa narinig';

  @override
  String get thanksHowCanWe => 'Salamat! Paano namin mapapabuti?';

  @override
  String get wereGladYouLike => 'Natutuwa kaming nagustuhan mo!';

  @override
  String get youMadeOurDay => 'Napasaya mo ang araw namin!';

  @override
  String get tapToExit => 'I-tap para lumabas';

  @override
  String get selectARating => 'Pumili ng rating';

  @override
  String get sendFeedback => 'Magpadala ng feedback';

  @override
  String get rateUs => 'I-rate kami';

  @override
  String get rateYourExperienceBefore =>
      'I-rate ang iyong karanasan bago ka umalis.';

  @override
  String get tapAStarTo => 'Mag-tap ng bituin para i-rate ang I-cast sa TV.';

  @override
  String get general => 'Pangkalahatan';

  @override
  String get english => 'Ingles';

  @override
  String get defaultQuality => 'Default na kalidad';

  @override
  String get autoConnectToLast => 'Auto-connect sa huling TV';

  @override
  String get appearance => 'Hitsura';

  @override
  String get light => 'Maliwanag';

  @override
  String get dark => 'Madilim';

  @override
  String get system => 'Sistema';

  @override
  String get aboutSupport => 'Tungkol at suporta';

  @override
  String get rateApp => 'I-rate ang app';

  @override
  String get feedback => 'Feedback';

  @override
  String get termsConditions => 'Mga Tuntunin at Kundisyon';

  @override
  String get version => 'Bersyon';

  @override
  String get castflowProIsActive => 'Aktibo ang I-cast sa TV Pro';

  @override
  String get upgradeToPremium => 'Mag-upgrade sa Premium';

  @override
  String get castflowPremium => 'I-cast sa TV Premium';

  @override
  String get thanksForYourSupport =>
      'Salamat sa iyong suporta. Mag-enjoy sa pag-cast na walang ad.';

  @override
  String get noAds1080pMirroring =>
      'Walang ad, 1080p mirroring at walang limitasyong pag-cast';

  @override
  String get upgrade => 'Mag-upgrade';

  @override
  String get mirrorCastBeautifullySimple =>
      'Mag-mirror at mag-cast, napakasimple';

  @override
  String get thisActionMayContain => 'Maaaring may ad ang aksyong ito';

  @override
  String get webCast => 'Web Cast';

  @override
  String get castThisVideo => 'I-cast ang video na ito';

  @override
  String get searchOrTypeAWeb => 'Maghanap o mag-type ng web address';

  @override
  String get removeBookmark => 'Alisin ang bookmark';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get quickAccess => 'Mabilisang access';

  @override
  String open2(Object title) {
    return 'Buksan ang $title';
  }

  @override
  String get bookmarks => 'Mga Bookmark';

  @override
  String get noBookmarks => 'Walang mga bookmark';

  @override
  String get tapTheBookmarkIcon =>
      'I-tap ang icon ng bookmark sa address bar para i-save ang isang page.';

  @override
  String get noHistory => 'Walang history';

  @override
  String get pagesYouVisitShow => 'Lalabas dito ang mga page na binibisita mo.';

  @override
  String get remove => 'Alisin';

  @override
  String resultOn(Object value, Object host) {
    return 'Resulta $value sa $host';
  }

  @override
  String get aSimulatedPageResult => 'Isang simulate na resulta ng page';

  @override
  String get videosOnThisPage => 'Mga video sa page na ito';

  @override
  String get pickOneToSend => 'Pumili ng isa para ipadala sa iyong TV.';

  @override
  String get onboardHotspotTitle => 'Walang Wi-Fi? Gamitin ang iyong hotspot';

  @override
  String get onboardHotspotBody =>
      'I-on ang hotspot ng iyong telepono at ikonekta ang iyong TV dito. Gumagana ang pag-cast tulad ng sa Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Hindi pa rin makita ang iyong TV?';

  @override
  String get stillCantFindBody =>
      'Sa halip, ikonekta ang iyong TV sa hotspot ng iyong telepono:';

  @override
  String get hotspotStep4 =>
      'I-tap ang Subukan muli at piliin ang iyong TV sa listahan';

  @override
  String get castOverHotspot =>
      'Walang Wi-Fi? Mag-cast gamit ang hotspot ng iyong telepono:';

  @override
  String get queue => 'Pila';

  @override
  String get addMusic => 'Magdagdag ng musika';

  @override
  String get connectWithWifi => 'Kumonekta gamit ang Wi-Fi';

  @override
  String get continueWithHotspot => 'Magpatuloy gamit ang hotspot';

  @override
  String get noWifiAlertMessage =>
      'Gumagamit ka ng mobile data. Ikonekta ang iyong telepono at TV sa iisang Wi-Fi, o i-on ang hotspot ng iyong telepono at sumali rito mula sa TV.';

  @override
  String get checkingNetwork => 'Sinusuri ang network...';

  @override
  String get discoveryStopped => 'Huminto ang paghahanap';

  @override
  String get discoveryStoppedHint =>
      'Huminto ang paghahanap. I-tap ang hanapin para makahanap ng mga kalapit na device.';

  @override
  String get search => 'Hanapin';

  @override
  String get permissionNeededToDiscover =>
      'Kailangan ang permiso sa lokasyon para makahanap ng mga device sa Wi-Fi.';

  @override
  String get locationServicesDisabled =>
      'Naka-disable ang Mga Serbisyo ng Lokasyon';

  @override
  String get openLocationSettings => 'Buksan ang Mga Setting ng Lokasyon';

  @override
  String get openAppSettings => 'Buksan ang Mga Setting ng App';

  @override
  String get subscriptionExpired => 'Nag-expire na ang iyong subscription.';

  @override
  String get noPurchasesFound => 'Walang nakitang nakaraang pagbili.';

  @override
  String get restore => 'Ibalik';

  @override
  String get permissionNeeded => 'Kailangan ng Permiso';

  @override
  String get permissionBlockedInSettings =>
      'Naka-block ang Permiso sa Mga Setting';

  @override
  String get grantPermission => 'Ibigay ang Permiso';

  @override
  String get checkAgain => 'Suriin Muli';

  @override
  String get appName => 'I-cast sa TV';

  @override
  String get allowPermission => 'Payagan ang Pahintulot';

  @override
  String get openSettings => 'Buksan ang Settings';

  @override
  String get noNetworkMessage =>
      'I-on ang Wi-Fi (kaparehong network ng TV mo), o i-share ang hotspot ng phone at ikonekta rito ang TV.';

  @override
  String get turnOnWifi => 'I-on ang Wi-Fi';

  @override
  String get waitingForNetwork =>
      'Hahanapin namin ang TV mo kapag nakakonekta ka na.';

  @override
  String get howHotspotWorks =>
      'Paano gumagana ang pag-cast gamit ang hotspot?';

  @override
  String get preparingForTv => 'Inihahanda para sa TV mo…';

  @override
  String convertingForTv(int percent) {
    return 'Kino-convert para sa TV mo… $percent%';
  }

  @override
  String get lookingForTvsOnHotspot => 'Hinahanap ang mga TV sa hotspot mo';
}
