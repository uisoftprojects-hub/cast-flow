// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class AppLocalizationsAf extends AppLocalizations {
  AppLocalizationsAf([String locale = 'af']) : super(locale);

  @override
  String get networkRequiredTitle => 'Nie aan Wi-Fi gekoppel nie';

  @override
  String get networkRequiredMessage =>
      'Jou foon en TV moet op dieselfde Wi-Fi-netwerk wees om te saai.';

  @override
  String get openWifiSettings => 'Maak Wi-Fi-instellings oop';

  @override
  String get useMobileHotspot => 'Gebruik mobiele warmkol';

  @override
  String get hotspotInstruction => 'Koppel jou LCD/TV aan jou mobiele warmkol.';

  @override
  String get hotspotStep1 => 'Skakel mobiele warmkol aan';

  @override
  String get hotspotStep2 => 'Koppel jou TV daaraan';

  @override
  String get hotspotStep3 => 'Kom terug na die toep';

  @override
  String get openHotspotSettings => 'Maak warmkol-instellings oop';

  @override
  String get hotspotAutoCheck =>
      'Ons sal outomaties weer nagaan wanneer jy terugkom.';

  @override
  String get hotspotDetected => 'Warmkol is aan. Soek tans na jou TV…';

  @override
  String get searchingDevices => 'Soek tans na toestelle in die omgewing...';

  @override
  String get waitingForTvOnHotspot =>
      'Wag tans vir jou TV om by jou warmkol aan te sluit…';

  @override
  String get usingHotspot => 'Gebruik jou mobiele warmkol';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count toestelle gevind',
      one: '1 toestel gevind',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Probeer weer';

  @override
  String get scanAgain => 'Soek weer';

  @override
  String get isolationTitle => 'TV reageer nie';

  @override
  String get isolationHint =>
      '’n Toestel het by jou warmkol aangesluit maar reageer nie. Jou warmkol blokkeer dalk verkeer tussen toestelle (kliëntisolasie). Skakel dit af in warmkol-instellings, of gebruik ’n Wi-Fi-netwerk.';

  @override
  String get connecting => 'Koppel tans…';

  @override
  String get connected => 'Gekoppel';

  @override
  String get connectionFailed => 'Kon nie koppel nie';

  @override
  String get connectFailedHint =>
      'Maak seker jou foon en TV is op dieselfde netwerk en probeer dan weer.';

  @override
  String get hotspotConnectHint =>
      'Jou warmkol blokkeer dalk verkeer tussen toestelle. Kontroleer sy kliëntisolasie-instelling.';

  @override
  String get networkLostTitle => 'Netwerkverbinding verloor';

  @override
  String get networkLostMessage =>
      'Koppel weer aan Wi-Fi of jou warmkol en koppel dan weer aan jou TV.';

  @override
  String get reconnect => 'Koppel weer';

  @override
  String reconnectTo(String name) {
    return 'Koppel weer aan $name';
  }

  @override
  String get tapToReconnect => 'Tik om weer te koppel';

  @override
  String get pairingRequired => 'Paring vereis';

  @override
  String get pairingEnterCode => 'Voer die kode in wat op jou TV gewys word.';

  @override
  String get pairingApproveOnTv =>
      'Kyk na jou TV en tik Laat toe om voort te gaan.';

  @override
  String get connect => 'Koppel';

  @override
  String get cancel => 'Kanselleer';

  @override
  String get pairingIncorrectCode => 'Verkeerde kode. Probeer weer.';

  @override
  String get pairingTimedOut => 'Paring het uitgetel';

  @override
  String get tryAgain => 'Probeer weer';

  @override
  String get pairingDeclined => 'Die TV het die verbinding geweier';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Te veel verkeerde kodes. Wag $seconds s en vra dan ’n nuwe kode aan.';
  }

  @override
  String get pairingCooldownOver => 'Jy kan nou ’n nuwe kode aanvra.';

  @override
  String get pairingRequestNewCode => 'Vra nuwe kode aan';

  @override
  String get pairingNetworkLost =>
      'Die netwerk is tydens paring verloor. Koppel weer aan Wi-Fi en probeer weer.';

  @override
  String get pairingFailed => 'Kon nie met die TV paar nie.';

  @override
  String pairingCodeField(int length) {
    return 'Parings-kode, $length karakters';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Kodekassie $index van $total';
  }

  @override
  String get pairingEmptyBox => 'leeg';

  @override
  String get pairingPaired => 'Gepaar';

  @override
  String get forgetDevice => 'Vergeet toestel';

  @override
  String forgetDeviceMessage(String name) {
    return '$name sal volgende keer weer gepaar moet word.';
  }

  @override
  String get forget => 'Vergeet';

  @override
  String get castVideo => 'Saai video uit';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video’s gevind. Saai video uit',
      one: '1 video gevind. Saai video uit',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Nog geen video op hierdie bladsy gevind nie.';

  @override
  String get videoFound => 'Video gevind';

  @override
  String get videoFoundMessage => 'Speel dit op jou TV.';

  @override
  String get castAction => 'Saai uit';

  @override
  String get dismiss => 'Maak toe';

  @override
  String videosFound(int count) {
    return 'Video’s gevind ($count)';
  }

  @override
  String get castToTv => 'Saai uit na TV';

  @override
  String get protectedVideo => 'Beskerm, kan nie uitgesaai word nie';

  @override
  String get videoThumbnail => 'Videominiatuur';

  @override
  String castingTo(String device) {
    return 'Saai tans uit na $device';
  }

  @override
  String get stopCasting => 'Stop uitsaai';

  @override
  String get play => 'Speel';

  @override
  String get pause => 'Laat wag';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Speelposisie';

  @override
  String get showControls => 'Wys kontroles';

  @override
  String get hideControls => 'Versteek kontroles';

  @override
  String get formatUnsupportedTitle => 'Formaat word nie ondersteun nie';

  @override
  String formatUnsupported(String device, String format) {
    return '$device kan nie $format-video’s speel nie. Probeer ’n ander video op hierdie bladsy, of gebruik skermspieëling.';
  }

  @override
  String get videoExpired =>
      'Hierdie videoskakel het verval. Herlaai die bladsy en probeer weer.';

  @override
  String get refreshingVideo => 'Kry tans ’n nuwe videoskakel…';

  @override
  String get browserBack => 'Terug';

  @override
  String get browserForward => 'Vorentoe';

  @override
  String get browserStartPage => 'Beginbladsy';

  @override
  String get browserReload => 'Herlaai';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Tuis';

  @override
  String get devices => 'Toestelle';

  @override
  String get history => 'Geskiedenis';

  @override
  String get settings => 'Instellings';

  @override
  String get goodMorning => 'Goeie more';

  @override
  String get goodAfternoon => 'Goeie middag';

  @override
  String get goodEvening => 'Goeie aand';

  @override
  String get couldntOpenTheLink => 'Kon nie die skakel oopmaak nie.';

  @override
  String get castflowLogo => 'Saai uit na TV-logo';

  @override
  String get somethingWentWrong => 'Iets het skeefgeloop';

  @override
  String get weCouldntLoadThis =>
      'Ons kon dit nou nie laai nie. Probeer asseblief weer.';

  @override
  String get apps => 'Toepassings';

  @override
  String open(Object name) {
    return 'Maak $name oop';
  }

  @override
  String get smartTv => 'Slim-TV';

  @override
  String get chromecast => 'Chromecast';

  @override
  String get fireTv => 'Fire TV';

  @override
  String get roku => 'Roku';

  @override
  String get dlnaRenderer => 'DLNA-weergawer';

  @override
  String get miracast => 'Miracast';

  @override
  String get up => 'Op';

  @override
  String get down => 'Af';

  @override
  String get left => 'Links';

  @override
  String get right => 'Regs';

  @override
  String get menu => 'Kieslys';

  @override
  String get input => 'Invoer';

  @override
  String get playPause => 'Speel / Laat wag';

  @override
  String get previous => 'Vorige';

  @override
  String get next => 'Volgende';

  @override
  String get rewind => 'Terugspoel';

  @override
  String get volumeUp => 'Volume harder';

  @override
  String get volumeDown => 'Volume sagter';

  @override
  String get mute => 'Demp';

  @override
  String connectedTo(Object name) {
    return 'Gekoppel aan $name';
  }

  @override
  String get chooseADevice => 'Kies ’n toestel';

  @override
  String get connectionGuide => 'Koppelgids';

  @override
  String get lookingForTvsOn => 'Soek tans na TV’s op jou Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return '$found tot dusver gevind';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found toestel$value gevind';
  }

  @override
  String get disconnect => 'Ontkoppel';

  @override
  String signalOf4(Object level) {
    return 'Sein $level van 4';
  }

  @override
  String get connecting2 => 'Koppel tans';

  @override
  String get theTvRemoteNeeds =>
      'Die TV-afstandbeheer het ’n gekoppelde TV nodig. Kies een hieronder.';

  @override
  String get connectToATv => 'Koppel aan ’n TV om voort te gaan.';

  @override
  String get findingTvs => 'Soek tans na TV’s…';

  @override
  String get makeSureYourTv => 'Maak seker jou TV is aan';

  @override
  String get notConnected => 'Nie gekoppel nie';

  @override
  String get tapToFindYour => 'Tik om jou TV te vind';

  @override
  String get connectionFailed2 => 'Koppeling het misluk';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Tik om toestelle te bestuur';
  }

  @override
  String get joinTheSameWi => 'Sluit by dieselfde Wi-Fi aan';

  @override
  String get connectYourPhoneAnd =>
      'Koppel jou foon en jou TV aan dieselfde Wi-Fi-netwerk.';

  @override
  String get turnOnCastingOn => 'Skakel uitsaai op jou TV aan';

  @override
  String get enableScreenMirroringMiracast =>
      'Aktiveer Skermspieëling, Miracast of Google Cast in die TV-instellings.';

  @override
  String get scanForDevices => 'Soek na toestelle';

  @override
  String get openDevicesInCastflow =>
      'Maak Toestelle in Saai uit na TV oop en wag ’n paar sekondes totdat jou TV verskyn.';

  @override
  String get tapConnect => 'Tik Koppel';

  @override
  String get acceptThePromptOn =>
      'Aanvaar die aanwysing op jou TV as een verskyn. Dis dit!';

  @override
  String get howToConnect => 'Hoe om te koppel';

  @override
  String get fourQuickStepsTo => 'Vier vinnige stappe na die groot skerm.';

  @override
  String get gotIt => 'Verstaan';

  @override
  String step(Object number, Object title, Object body) {
    return 'Stap $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Tuis-Wi-Fi';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Instellings › Koppeling';

  @override
  String get inputHdmi1 => 'Invoer: HDMI 1';

  @override
  String get screenMirroring => 'Skermspieëling';

  @override
  String get networkHomeWiFi => 'Netwerk: Tuis-Wi-Fi';

  @override
  String get livingRoomTv => 'Sitkamer-TV';

  @override
  String get allowCastflowToConnect => 'Laat Saai uit na TV toe om te koppel?';

  @override
  String get deny => 'Weier';

  @override
  String get allow => 'Laat toe';

  @override
  String get yourTv => 'Jou TV';

  @override
  String get findYourTv => 'Vind jou TV';

  @override
  String connectTo(Object name) {
    return 'Koppel aan $name';
  }

  @override
  String connected2(Object label) {
    return 'Gekoppel · $label';
  }

  @override
  String get openTvRemote => 'Maak TV-afstandbeheer oop';

  @override
  String get sameWiFiNetwork => 'Dieselfde Wi-Fi-netwerk';

  @override
  String get yourPhoneAndTv =>
      'Jou foon en TV moet aan dieselfde Wi-Fi gekoppel wees.';

  @override
  String get tvIsOnAnd => 'TV is aan en gereed';

  @override
  String get turnOnScreenMirroring =>
      'Skakel Skermspieëling, Cast of Miracast op die TV aan.';

  @override
  String get noVpnOrGuest => 'Geen VPN of gasnetwerk nie';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN’s en gas- / geïsoleerde Wi-Fi versteek toestelle van mekaar.';

  @override
  String get localNetworkAccess => 'Plaaslike netwerktoegang';

  @override
  String get allowCastflowToFind =>
      'Laat Saai uit na TV toe om toestelle op jou netwerk te vind wanneer gevra word.';

  @override
  String get noTvFound => 'Geen TV gevind nie';

  @override
  String get checkThatYourPhone =>
      'Kontroleer dat jou foon en TV aan dieselfde Wi-Fi gekoppel is en soek dan weer.';

  @override
  String get noWiFiRouter => 'Geen Wi-Fi-router nie? Gebruik jou warmkol';

  @override
  String searchingForTvsFound(Object length) {
    return 'Soek tans na TV’s. $length gevind.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TV’s gevind';
  }

  @override
  String get connectToYourTv => 'Koppel aan jou TV';

  @override
  String get connectYourPhoneAndTv =>
      'Koppel jou foon en TV aan dieselfde Wi-Fi-netwerk.';

  @override
  String get turnOnTheTv =>
      'Skakel die TV aan en maak sy Skermspieëling- / Cast-invoer oop.';

  @override
  String get tapTheConnectionBar =>
      'Tik die koppelbalk op Tuis om jou TV te vind.';

  @override
  String get tapConnectAndAccept =>
      'Tik Koppel en aanvaar die aanwysing op die TV as een verskyn.';

  @override
  String get mirrorYourScreen => 'Spieël jou skerm';

  @override
  String get connectToYourTvFirst => 'Koppel eers aan jou TV.';

  @override
  String get openScreenMirroringFrom => 'Maak Skermspieëling vanaf Tuis oop.';

  @override
  String get pickAQualityAnd => 'Kies ’n gehalte en tik Begin.';

  @override
  String get allowScreenCaptureWhen =>
      'Laat skermopname toe wanneer Android vra.';

  @override
  String get castPhotosVideosMusic => 'Saai foto’s, video’s en musiek uit';

  @override
  String get openPhotosVideosOr =>
      'Maak Foto’s, Video’s of Musiek op Tuis oop.';

  @override
  String get pickWhatYouWant => 'Kies wat jy wil wys.';

  @override
  String get itPlaysOnThe =>
      'Dit speel op die TV; beheer dit vanaf jou foon of die kennisgewing.';

  @override
  String get useTheTvRemote => 'Gebruik die TV-afstandbeheer';

  @override
  String get openTvRemoteOn => 'Maak TV-afstandbeheer op Tuis oop.';

  @override
  String get useTheDPad =>
      'Gebruik die D-pad of swiep op die raakmat om te beweeg, tik OK om te kies.';

  @override
  String get buttonsATvDoesnt =>
      'Knoppies wat ’n TV nie ondersteun nie, is grys.';

  @override
  String get castFromTheWeb => 'Saai uit vanaf die web en toepassings';

  @override
  String get tapTheBrowserBar =>
      'Tik die blaaierbalk of ’n toepassing op Tuis.';

  @override
  String get playAVideoOn => 'Speel ’n video op die webwerf.';

  @override
  String get tapCastThisVideo =>
      'Tik “Saai hierdie video uit” om dit na jou TV te stuur.';

  @override
  String get screenMirroringHelp => 'Skermspieëling-hulp';

  @override
  String get connectYourPhoneTo => 'Koppel jou foon aan Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Maak op die TV Instellings → Netwerk oop en sluit by dieselfde Wi-Fi aan.';

  @override
  String get guestOrOfficeNetworks =>
      'Gas- of kantoornetwerke blokkeer dikwels spieëling; gebruik jou tuis-Wi-Fi of jou foon se warmkol.';

  @override
  String get turnOffVpn => 'Skakel VPN af';

  @override
  String get aVpnHidesYour => '’n VPN versteek jou TV van jou foon.';

  @override
  String get pauseOrDisconnectYour =>
      'Laat wag of ontkoppel jou VPN-toepassing voordat jy begin.';

  @override
  String get youCanTurnIt => 'Jy kan dit weer aanskakel wanneer jy klaar is.';

  @override
  String get turnOnMirroringOn => 'Skakel spieëling op die TV aan';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG en die meeste Android-TV’s aanvaar spieëling outomaties.';

  @override
  String get otherTvsOpenInput =>
      'Ander TV’s: maak Invoer / Bron oop en kies Skermspieëling of Miracast.';

  @override
  String get keepTheTvOn =>
      'Hou die TV op daardie skerm terwyl jou foon koppel.';

  @override
  String get tapStartAndPick => 'Tik Begin en kies jou TV';

  @override
  String get tapStartOnThe => 'Tik Begin op die Skermspieëling-skerm.';

  @override
  String get androidOpensSmartView =>
      'Android maak Smart View / Cast oop. Tik jou TV in die lys.';

  @override
  String get ifTheTvAsks =>
      'As die TV vra, kies Laat toe of voer die PIN in wat op die skerm gewys word.';

  @override
  String get youreMirroring => 'Jy spieël';

  @override
  String get everythingOnYourPhone =>
      'Alles op jou foon word nou op die TV gewys.';

  @override
  String get turnThePhoneSideways =>
      'Draai die foon sywaarts vir volskermvideo’s en speletjies.';

  @override
  String get toStopTapStop =>
      'Om te stop, tik Stop of gebruik die uitsaaikennisgewing.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Af';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'Slaapkamer-TV';

  @override
  String get officeDisplay => 'Kantoorvertoning';

  @override
  String get clearHistory => 'Vee geskiedenis uit?';

  @override
  String get thisRemovesEverythingYouve =>
      'Dit verwyder alles wat jy uitgesaai het uit hierdie lys.';

  @override
  String get clear => 'Vee uit';

  @override
  String get clearHistory2 => 'Vee geskiedenis uit';

  @override
  String get noHistoryYet => 'Nog geen geskiedenis nie';

  @override
  String get everythingYouCastWill =>
      'Alles wat jy uitsaai, sal hier gelys word sodat jy dit weer kan vind.';

  @override
  String get today => 'Vandag';

  @override
  String get yesterday => 'Gister';

  @override
  String get earlier => 'Vroeër';

  @override
  String get swipeAnItemTo => 'Swiep ’n item om dit te verwyder';

  @override
  String get delete => 'Skrap';

  @override
  String removed(Object title) {
    return '“$title” verwyder';
  }

  @override
  String get undo => 'Ontdoen';

  @override
  String get photos => 'Foto’s';

  @override
  String get albums => 'Albums';

  @override
  String get videos => 'Video’s';

  @override
  String get gallery => 'Galery';

  @override
  String get music => 'Musiek';

  @override
  String get songs => 'Liedjies';

  @override
  String get media => 'Media';

  @override
  String get browseTheWeb => 'Blaai deur die web';

  @override
  String get goPro => 'Kry Pro';

  @override
  String cast(Object title) {
    return 'Saai $title uit';
  }

  @override
  String get screenMirroringStartMirroring => 'Skermspieëling. Begin spieël';

  @override
  String readyToMirrorTo(Object device) {
    return 'Gereed om na $device te spieël';
  }

  @override
  String get showYourPhoneOn => 'Wys jou foon intyds op die TV.';

  @override
  String get startMirroring => 'Begin spieël';

  @override
  String get tvRemote => 'TV-afstandbeheer';

  @override
  String get controlYourTv => 'Beheer jou TV';

  @override
  String get youtubeMore => 'YouTube en meer';

  @override
  String get openTheBrowser => 'Maak die blaaier oop';

  @override
  String get searchOrTypeA => 'Soek of tik ’n webwerf';

  @override
  String get howToConnectOpen => 'Hoe om te koppel. Maak die visuele gids oop';

  @override
  String get visualGuideForEvery => 'Visuele gids vir elke kenmerk';

  @override
  String get language => 'Taal';

  @override
  String get done => 'Klaar';

  @override
  String get enterAValidHttp =>
      'Voer ’n geldige http(s)- of rtsp-skakel in, bv. ’n .m3u8- of .mp4-URL.';

  @override
  String get linkStream => 'Skakelstroom';

  @override
  String get iptvLinkCast => 'IPTV / Skakel-uitsaai';

  @override
  String get castALink => 'Saai ’n skakel uit';

  @override
  String get pasteADirectVideo =>
      'Plak ’n direkte video-, M3U8- of IPTV-stroom-URL.';

  @override
  String get paste => 'Plak';

  @override
  String get castLink => 'Saai skakel uit';

  @override
  String get allowAccessToYour =>
      'Laat toegang tot jou media toe om dit uit te saai. Jy kan dit in Instellings verander.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Saai musiek uit';

  @override
  String get noMusicFound => 'Geen musiek gevind nie';

  @override
  String get addSongsToYour =>
      'Voeg liedjies by jou foon en dit sal hier verskyn.';

  @override
  String get shuffle => 'Skommel';

  @override
  String get playAll => 'Speel almal';

  @override
  String photo(Object formatShortDate) {
    return 'Foto · $formatShortDate';
  }

  @override
  String get photo2 => 'Foto';

  @override
  String get castPhotos => 'Saai foto’s uit';

  @override
  String get select => 'Kies';

  @override
  String get noPhotosHere => 'Geen foto’s hier nie';

  @override
  String get photosYouTakeOr =>
      'Foto’s wat jy neem of stoor, sal in hierdie album verskyn.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count foto’s';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Foto van $formatShortDate';
  }

  @override
  String get allPhotos => 'Alle foto’s';

  @override
  String get slideshow => 'Skyfievertoning';

  @override
  String get interval => 'Interval';

  @override
  String get transition => 'Oorgang';

  @override
  String get fade => 'Vervaag';

  @override
  String get slide => 'Gly';

  @override
  String get zoom => 'Zoem';

  @override
  String get startSlideshow => 'Begin skyfievertoning';

  @override
  String get castVideos => 'Saai video’s uit';

  @override
  String get noVideosYet => 'Nog geen video’s nie';

  @override
  String get videosYouRecordOr =>
      'Video’s wat jy opneem of aflaai, sal hier verskyn, gereed om uit te saai.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Saai uit';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Skermspieëlingsessie';

  @override
  String get mirroringDidntStartTap =>
      'Spieëling het nie begin nie. Tik weer Begin en kies jou TV in die lys.';

  @override
  String get openSmartViewOr =>
      'Maak Smart View of Cast oop vanaf jou foon se vinnige instellings om te spieël.';

  @override
  String get quality => 'Gehalte';

  @override
  String get adjustsToYourWi => 'Pas by jou Wi-Fi aan vir die gladste beeld.';

  @override
  String upToLowerIt(Object label) {
    return 'Tot $label. Verlaag dit as die beeld stamp.';
  }

  @override
  String get stillNeedHelp => 'Het jy nog hulp nodig?';

  @override
  String get startingScreenMirroring => 'Begin tans skermspieëling…';

  @override
  String mirroringTo(Object value) {
    return 'Spieël tans na $value';
  }

  @override
  String get stopping => 'Stop tans…';

  @override
  String get readyToMirror => 'Gereed om te spieël';

  @override
  String get beforeYouStart => 'Voordat jy begin';

  @override
  String get phoneAndTvAre => 'Foon en TV is op dieselfde Wi-Fi';

  @override
  String get noVpnIsConnected => 'Geen VPN is op jou foon gekoppel nie';

  @override
  String get tvIsOnWith => 'TV is aan met Skermspieëling geaktiveer';

  @override
  String get phoneIsCloseTo => 'Foon is naby die TV';

  @override
  String get stopMirroring => 'Stop spieëling';

  @override
  String get startMirroring2 => 'Begin spieël';

  @override
  String get stop => 'Stop';

  @override
  String get start => 'Begin';

  @override
  String get duration => 'Duur';

  @override
  String get adIsLoading => 'Advertensie word gelaai';

  @override
  String get ad => 'Advertensie';

  @override
  String get mirrorYourScreenTo => 'Spieël jou skerm na enige TV';

  @override
  String get showYourPhoneOnThe =>
      'Wys jou foon met een tik op die groot skerm — geen kabels, geen moeite nie.';

  @override
  String get shareMemoriesWithThe =>
      'Deel herinneringe met die hele kamer en hou beheer vanaf jou foon.';

  @override
  String get castFromWebApps => 'Saai uit vanaf web en toepassings';

  @override
  String get sendVideosFromYoutube =>
      'Stuur video’s van YouTube, Facebook en enige webwerf direk na jou TV.';

  @override
  String pageOf(Object value, Object length) {
    return 'Bladsy $value van $length';
  }

  @override
  String get getStarted => 'Aan die gang kom';

  @override
  String get localNetwork => 'Plaaslike netwerk';

  @override
  String get findTvsAndStreaming =>
      'Vind TV’s en stroomtoestelle op jou Wi-Fi.';

  @override
  String get notifications => 'Kennisgewings';

  @override
  String get showCastingControlsWhile =>
      'Wys uitsaaibeheer terwyl jy ander toepassings gebruik.';

  @override
  String get photosVideosMusic => 'Foto’s, video’s en musiek';

  @override
  String get pickWhatYouWantTo =>
      'Kies wat jy wil uitsaai uit jou galery en biblioteek.';

  @override
  String get screenCapture => 'Skermopname';

  @override
  String get mirrorYourScreenYoull =>
      'Spieël jou skerm. Jy bevestig elke sessie.';

  @override
  String get webVideo => 'Webvideo';

  @override
  String get link => 'Skakel';

  @override
  String get screenMirroring2 => 'Skermspieëling';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Saai tans $title uit. Maak afstandbeheer oop';
  }

  @override
  String castingTo2(Object value) {
    return 'Saai tans uit na $value';
  }

  @override
  String get nowCasting => 'Saai tans uit';

  @override
  String get nothingIsCasting => 'Niks word uitgesaai nie';

  @override
  String get pickAPhotoVideo =>
      'Kies ’n foto, video, liedjie of webvideo om dit na jou TV te stuur.';

  @override
  String get backToHome => 'Terug na tuis';

  @override
  String slide2(Object formatDuration) {
    return 'Skyfie $formatDuration';
  }

  @override
  String get back10Seconds => '10 sekondes terug';

  @override
  String get forward10Seconds => '10 sekondes vorentoe';

  @override
  String get tvVolume => 'TV-volume';

  @override
  String tvVolumePercent(Object round) {
    return 'TV-volume $round persent';
  }

  @override
  String get upNext => 'Volgende';

  @override
  String get addPhotos => 'Voeg foto’s by';

  @override
  String get addVideos => 'Voeg video’s by';

  @override
  String get nothingElseInThe => 'Niks anders in die tou nie.';

  @override
  String play2(Object title) {
    return 'Speel $title';
  }

  @override
  String get unknownDevice => 'Onbekende toestel';

  @override
  String get perWeek => 'per week';

  @override
  String get perYear => 'per jaar';

  @override
  String get payOnce => 'betaal een keer';

  @override
  String get wirelessScreenMirroring => 'Draadlose skermspieëling';

  @override
  String get castVideosPhotosMusic => 'Saai video’s, foto’s en musiek uit';

  @override
  String get fullTvRemoteControl => 'Volledige TV-afstandbeheer';

  @override
  String get worksWithAllMajor => 'Werk met alle groot TV’s';

  @override
  String get smoothLagFreeStreaming => 'Gladde, vertragingsvrye stroming';

  @override
  String get noAds => 'Geen advertensies nie';

  @override
  String get welcomeToCastflowPro => 'Welkom by Saai uit na TV Pro!';

  @override
  String get purchaseCancelled => 'Aankoop gekanselleer.';

  @override
  String get purchasePendingProUnlocks =>
      'Aankoop hangend. Pro ontsluit sodra die winkel dit bevestig.';

  @override
  String get purchaseFailedPleaseTry =>
      'Aankoop het misluk. Probeer asseblief weer.';

  @override
  String get theStoreIsntAvailable => 'Die winkel is nou nie beskikbaar nie.';

  @override
  String get close => 'Maak toe';

  @override
  String get goProWithCastflow => 'KRY PRO MET SAAI UIT NA TV';

  @override
  String get unlockEveryFeature => 'Ontsluit elke kenmerk';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Hernu outomaties totdat dit gekanselleer word.';

  @override
  String get oneTimePurchaseNo => 'Eenmalige aankoop. Geen intekening nie.';

  @override
  String get continueAction => 'Gaan voort';

  @override
  String get privacyPolicy => 'Privaatheidsbeleid';

  @override
  String get termsAndConditions => 'Bepalings en voorwaardes';

  @override
  String get cancelAnytime => 'Kanselleer enige tyd';

  @override
  String get loadingPrice => 'Laai tans prys…';

  @override
  String get pricesUnavailableTapTo =>
      'Pryse nie beskikbaar nie · Tik om weer te probeer';

  @override
  String get noPlansAvailableRight => 'Geen planne nou beskikbaar nie.';

  @override
  String get weekly => 'Weekliks';

  @override
  String get yearly => 'Jaarliks';

  @override
  String get lifetime => 'Lewenslank';

  @override
  String get bestValue => 'Beste waarde';

  @override
  String get disconnectFromTv => 'Ontkoppel van TV?';

  @override
  String get thisStopsWhatIs => 'Dit stop wat tans speel of gespieël word.';

  @override
  String get useTouchpad => 'Gebruik raakmat';

  @override
  String get useDPad => 'Gebruik D-pad';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label-ontvangers aanvaar nie afstandbeheeropdragte nie.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Sommige knoppies is nie beskikbaar op $label nie.';
  }

  @override
  String get idle => 'ONAKTIEF';

  @override
  String get playing => 'SPEEL';

  @override
  String get paused => 'GELAAT WAG';

  @override
  String get noTvConnected => 'Geen TV gekoppel nie';

  @override
  String get mute2 => 'DEMP';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Geen TV gekoppel nie. Tik om ’n toestel te kies';

  @override
  String get tapToChooseA => 'Tik om ’n toestel te kies';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label word nie deur $label2 ondersteun nie';
  }

  @override
  String get touchpadSwipeToMove =>
      'Raakmat. Swiep om te beweeg, tik om te kies.';

  @override
  String get swipeToMoveTap => 'Swiep om te beweeg · Tik om te kies';

  @override
  String get navigationIsntSupportedBy =>
      'Navigasie word nie deur hierdie TV ondersteun nie';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Outo';

  @override
  String get automatic => 'Outomaties';

  @override
  String get googleCastFirst => 'Google Cast eerste';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP eerste';

  @override
  String get miracastFirst => 'Miracast eerste';

  @override
  String get tvOnly => 'Net TV';

  @override
  String get phoneAndTv => 'Foon en TV';

  @override
  String get phoneOnly => 'Net foon';

  @override
  String get touchpad => 'Raakmat';

  @override
  String get doMyPhoneAnd => 'Moet my foon en TV dieselfde Wi-Fi hê?';

  @override
  String get yesDiscoveryAndCasting =>
      'Ja. Ontdekking en uitsaai bly op jou plaaslike netwerk, dus moet albei op dieselfde Wi-Fi wees (dieselfde bandname kan steeds verskillende netwerke wees).';

  @override
  String get myRouterHasAp => 'My router het “AP- / kliëntisolasie”';

  @override
  String get isolationBlocksDevicesFrom =>
      'Isolasie keer dat toestelle mekaar sien. Skakel dit af in die router-instellings, of gebruik ’n nie-gasnetwerk.';

  @override
  String get findingYourTv => 'Soek jou TV';

  @override
  String get myTvDoesntAppear => 'My TV verskyn nie in die lys nie';

  @override
  String get turnOnCastingScreen =>
      'Skakel uitsaai / skermspieëling op die TV aan, wek dit uit gereedstaan en tik dan Soek weer. Laat die Plaaslike netwerk-toestemming toe as gevra word.';

  @override
  String get onlySomeDevicesShow => 'Net sommige toestelle verskyn';

  @override
  String get olderTvsMayNeed =>
      'Ouer TV’s het dalk ’n firmware-opdatering nodig. Miracast-TV’s verskyn net terwyl hul “Skermspieëling”-invoer oop is.';

  @override
  String get connectionFailsOrTimes => 'Koppeling misluk of verstryk';

  @override
  String get restartTheTvApp =>
      'Herbegin die TV-toepassing of die TV, beweeg nader aan die router en aanvaar enige aanwysing op die TV-skerm.';

  @override
  String get itKeepsReconnectingTo => 'Dit koppel aanhou weer aan ’n ou TV';

  @override
  String get turnOffAutoConnect =>
      'Skakel “Koppel outomaties aan laaste TV” af in Instellings → Uitsaai.';

  @override
  String get mirroringIsLaggy => 'Spieëling is traag';

  @override
  String get chooseALowerQuality =>
      'Kies ’n laer gehalte (720p of 480p), maak swaar toepassings toe en gebruik ’n 5 GHz-Wi-Fi-netwerk.';

  @override
  String get thePictureIsRotated => 'Die beeld is gedraai of afgesny';

  @override
  String get toggleAutoRotateOn =>
      'Skakel Outo-draai aan op die Skermspieëling-skerm.';

  @override
  String get sound => 'Klank';

  @override
  String get thereIsNoSound => 'Daar is geen klank op die TV nie';

  @override
  String get makeSureAudioIs =>
      'Maak seker Klank is aan in Skermspieëling en kontroleer Instellings → Uitsaai → Klankuitvoer. Sommige ontvangers ondersteun nie foonklank nie.';

  @override
  String get tvRemote2 => 'TV-afstandbeheer';

  @override
  String get someRemoteButtonsAre => 'Sommige afstandbeheerknoppies is grys';

  @override
  String get eachReceiverSupportsDifferent =>
      'Elke ontvanger ondersteun verskillende opdragte. Chromecast en DLNA ondersteun net weergawe en volume; Miracast het geen afstandbeheerkanaal nie.';

  @override
  String get canCastflowTurnMy =>
      'Kan Saai uit na TV my TV aanskakel of invoere verander?';

  @override
  String get onlyOnTvsThat =>
      'Net op TV’s wat daardie opdragte oor die netwerk beskikbaar stel. Nie-ondersteunde knoppies word gedeaktiveer in plaas daarvan om voor te gee dat dit werk.';

  @override
  String get helpFaq => 'Hulp en gereelde vrae';

  @override
  String get stepByStepConnection => 'Stap-vir-stap-koppelgids';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Geen e-poptoepassing gevind nie.';

  @override
  String get enjoyingCastflow => 'Geniet jy Saai uit na TV?';

  @override
  String get sorryToHearThat => 'Jammer om dit te hoor';

  @override
  String get thanksHowCanWe => 'Dankie! Hoe kan ons verbeter?';

  @override
  String get wereGladYouLike => 'Ons is bly jy hou daarvan!';

  @override
  String get youMadeOurDay => 'Jy het ons dag gemaak!';

  @override
  String get tapToExit => 'Tik om te verlaat';

  @override
  String get selectARating => 'Kies ’n gradering';

  @override
  String get sendFeedback => 'Stuur terugvoer';

  @override
  String get rateUs => 'Gradeer ons';

  @override
  String get rateYourExperienceBefore =>
      'Gradeer jou ervaring voordat jy gaan.';

  @override
  String get tapAStarTo => 'Tik ’n ster om Saai uit na TV te gradeer.';

  @override
  String get general => 'Algemeen';

  @override
  String get english => 'Engels';

  @override
  String get defaultQuality => 'Verstekgehalte';

  @override
  String get autoConnectToLast => 'Koppel outomaties aan laaste TV';

  @override
  String get appearance => 'Voorkoms';

  @override
  String get light => 'Lig';

  @override
  String get dark => 'Donker';

  @override
  String get system => 'Stelsel';

  @override
  String get aboutSupport => 'Oor en ondersteuning';

  @override
  String get rateApp => 'Gradeer toepassing';

  @override
  String get feedback => 'Terugvoer';

  @override
  String get termsConditions => 'Bepalings en voorwaardes';

  @override
  String get version => 'Weergawe';

  @override
  String get castflowProIsActive => 'Saai uit na TV Pro is aktief';

  @override
  String get upgradeToPremium => 'Gradeer op na Premium';

  @override
  String get castflowPremium => 'Saai uit na TV Premium';

  @override
  String get thanksForYourSupport =>
      'Dankie vir jou ondersteuning. Geniet advertensievrye uitsaai.';

  @override
  String get noAds1080pMirroring =>
      'Geen advertensies, 1080p-spieëling en onbeperkte uitsaai';

  @override
  String get upgrade => 'Gradeer op';

  @override
  String get mirrorCastBeautifullySimple =>
      'Spieël en saai uit, pragtig eenvoudig';

  @override
  String get thisActionMayContain => 'Hierdie handeling kan advertensies bevat';

  @override
  String get webCast => 'Web-uitsaai';

  @override
  String get castThisVideo => 'Saai hierdie video uit';

  @override
  String get searchOrTypeAWeb => 'Soek of tik ’n webadres';

  @override
  String get removeBookmark => 'Verwyder boekmerk';

  @override
  String get bookmark => 'Boekmerk';

  @override
  String get quickAccess => 'Vinnige toegang';

  @override
  String open2(Object title) {
    return 'Maak $title oop';
  }

  @override
  String get bookmarks => 'Boekmerke';

  @override
  String get noBookmarks => 'Geen boekmerke nie';

  @override
  String get tapTheBookmarkIcon =>
      'Tik die boekmerk-ikoon in die adresbalk om ’n bladsy te stoor.';

  @override
  String get noHistory => 'Geen geskiedenis nie';

  @override
  String get pagesYouVisitShow => 'Bladsye wat jy besoek, verskyn hier.';

  @override
  String get remove => 'Verwyder';

  @override
  String resultOn(Object value, Object host) {
    return 'Resultaat $value op $host';
  }

  @override
  String get aSimulatedPageResult => '’n Gesimuleerde bladsyresultaat';

  @override
  String get videosOnThisPage => 'Video’s op hierdie bladsy';

  @override
  String get pickOneToSend => 'Kies een om na jou TV te stuur.';

  @override
  String get onboardHotspotTitle => 'Geen Wi-Fi nie? Gebruik jou warmkol';

  @override
  String get onboardHotspotBody =>
      'Skakel jou foon se warmkol aan en koppel jou TV daaraan. Uitsaai werk net soos op Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Kan jy steeds nie jou TV vind nie?';

  @override
  String get stillCantFindBody =>
      'Koppel jou TV eerder aan jou foon se warmkol:';

  @override
  String get hotspotStep4 => 'Tik Probeer weer en kies jou TV uit die lys';

  @override
  String get castOverHotspot =>
      'Geen Wi-Fi nie? Saai uit oor jou foon se warmkol:';

  @override
  String get queue => 'Tou';

  @override
  String get addMusic => 'Voeg musiek by';

  @override
  String get connectWithWifi => 'Koppel met Wi-Fi';

  @override
  String get continueWithHotspot => 'Gaan voort met warmkol';

  @override
  String get noWifiAlertMessage =>
      'Jy is op mobiele data. Koppel jou foon en TV aan dieselfde Wi-Fi, of skakel jou foon se warmkol aan en sluit daarby aan vanaf die TV.';

  @override
  String get checkingNetwork => 'Kontroleer tans netwerk...';

  @override
  String get discoveryStopped => 'Ontdekking gestop';

  @override
  String get discoveryStoppedHint =>
      'Ontdekking gestop. Tik soek om toestelle in die omgewing te vind.';

  @override
  String get search => 'Soek';

  @override
  String get permissionNeededToDiscover =>
      'Liggingtoestemming is nodig om toestelle op Wi-Fi te ontdek.';

  @override
  String get locationServicesDisabled => 'Liggingdienste gedeaktiveer';

  @override
  String get openLocationSettings => 'Maak liggingsinstellings oop';

  @override
  String get openAppSettings => 'Maak toepassinginstellings oop';

  @override
  String get subscriptionExpired => 'Jou intekening het verval.';

  @override
  String get noPurchasesFound => 'Geen vorige aankope gevind nie.';

  @override
  String get restore => 'Herstel';

  @override
  String get permissionNeeded => 'Toestemming nodig';

  @override
  String get permissionBlockedInSettings =>
      'Toestemming in instellings geblokkeer';

  @override
  String get grantPermission => 'Verleen toestemming';

  @override
  String get checkAgain => 'Kontroleer weer';

  @override
  String get appName => 'Saai uit na TV';

  @override
  String get allowPermission => 'Gee toestemming';

  @override
  String get openSettings => 'Maak Instellings oop';

  @override
  String get noNetworkMessage =>
      'Skakel Wi-Fi aan (dieselfde netwerk as jou TV), of deel jou foon se hotspot en koppel die TV daaraan.';

  @override
  String get turnOnWifi => 'Skakel Wi-Fi aan';

  @override
  String get waitingForNetwork =>
      'Ons begin na jou TV soek sodra jy gekoppel is.';

  @override
  String get howHotspotWorks => 'Hoe werk uitsending oor \'n hotspot?';

  @override
  String get preparingForTv => 'Berei voor vir jou TV…';

  @override
  String convertingForTv(int percent) {
    return 'Skakel om vir jou TV… $percent%';
  }

  @override
  String get lookingForTvsOnHotspot => 'Soek TV\'s op jou hotspot';
}
