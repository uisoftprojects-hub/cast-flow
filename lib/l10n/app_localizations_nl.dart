// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get networkRequiredTitle => 'Niet verbonden met wifi';

  @override
  String get networkRequiredMessage =>
      'Je telefoon en tv moeten op hetzelfde wifi-netwerk zitten om te casten.';

  @override
  String get openWifiSettings => 'Wifi-instellingen openen';

  @override
  String get useMobileHotspot => 'Mobiele hotspot gebruiken';

  @override
  String get hotspotInstruction => 'Verbind je lcd/tv met je mobiele hotspot.';

  @override
  String get hotspotStep1 => 'Zet de mobiele hotspot aan';

  @override
  String get hotspotStep2 => 'Verbind je tv ermee';

  @override
  String get hotspotStep3 => 'Ga terug naar de app';

  @override
  String get openHotspotSettings => 'Hotspot-instellingen openen';

  @override
  String get hotspotAutoCheck =>
      'We controleren automatisch opnieuw als je terugkomt.';

  @override
  String get hotspotDetected => 'Hotspot staat aan. Je tv zoeken…';

  @override
  String get searchingDevices => 'Zoeken naar apparaten in de buurt...';

  @override
  String get waitingForTvOnHotspot =>
      'Wachten tot je tv met je hotspot verbindt…';

  @override
  String get usingHotspot => 'Je mobiele hotspot wordt gebruikt';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apparaten gevonden',
      one: '1 apparaat gevonden',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Opnieuw';

  @override
  String get scanAgain => 'Opnieuw scannen';

  @override
  String get isolationTitle => 'Tv reageert niet';

  @override
  String get isolationHint =>
      'Een apparaat is met je hotspot verbonden maar reageert niet. Je hotspot blokkeert mogelijk verkeer tussen apparaten (clientisolatie). Zet dit uit in de hotspot-instellingen of gebruik een wifi-netwerk.';

  @override
  String get connecting => 'Verbinden…';

  @override
  String get connected => 'Verbonden';

  @override
  String get connectionFailed => 'Verbinden mislukt';

  @override
  String get connectFailedHint =>
      'Controleer of je telefoon en tv op hetzelfde netwerk zitten en probeer het opnieuw.';

  @override
  String get hotspotConnectHint =>
      'Je hotspot blokkeert mogelijk verkeer tussen apparaten. Controleer de instelling voor clientisolatie.';

  @override
  String get networkLostTitle => 'Netwerkverbinding verbroken';

  @override
  String get networkLostMessage =>
      'Maak opnieuw verbinding met wifi of je hotspot en verbind daarna opnieuw met je tv.';

  @override
  String get reconnect => 'Opnieuw verbinden';

  @override
  String reconnectTo(String name) {
    return 'Opnieuw verbinden met $name';
  }

  @override
  String get tapToReconnect => 'Tik om opnieuw te verbinden';

  @override
  String get pairingRequired => 'Koppeling vereist';

  @override
  String get pairingEnterCode => 'Voer de code in die op je tv wordt getoond.';

  @override
  String get pairingApproveOnTv =>
      'Kijk op je tv en tik op Toestaan om door te gaan.';

  @override
  String get connect => 'Verbinden';

  @override
  String get cancel => 'Annuleren';

  @override
  String get pairingIncorrectCode => 'Onjuiste code. Probeer het opnieuw.';

  @override
  String get pairingTimedOut => 'Koppelen is verlopen';

  @override
  String get tryAgain => 'Opnieuw proberen';

  @override
  String get pairingDeclined => 'De tv heeft de verbinding geweigerd';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Te veel foute codes. Wacht $seconds s en vraag dan een nieuwe code aan.';
  }

  @override
  String get pairingCooldownOver => 'Je kunt nu een nieuwe code aanvragen.';

  @override
  String get pairingRequestNewCode => 'Nieuwe code aanvragen';

  @override
  String get pairingNetworkLost =>
      'Het netwerk is tijdens het koppelen verbroken. Maak opnieuw verbinding met wifi en probeer het opnieuw.';

  @override
  String get pairingFailed => 'Koppelen met de tv is niet gelukt.';

  @override
  String pairingCodeField(int length) {
    return 'Koppelcode, $length tekens';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Codevak $index van $total';
  }

  @override
  String get pairingEmptyBox => 'leeg';

  @override
  String get pairingPaired => 'Gekoppeld';

  @override
  String get forgetDevice => 'Apparaat vergeten';

  @override
  String forgetDeviceMessage(String name) {
    return '$name moet de volgende keer opnieuw worden gekoppeld.';
  }

  @override
  String get forget => 'Vergeten';

  @override
  String get castVideo => 'Video casten';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video\'s gevonden. Video casten',
      one: '1 video gevonden. Video casten',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Nog geen video gevonden op deze pagina.';

  @override
  String get videoFound => 'Video gevonden';

  @override
  String get videoFoundMessage => 'Speel hem af op je tv.';

  @override
  String get castAction => 'Casten';

  @override
  String get dismiss => 'Sluiten';

  @override
  String videosFound(int count) {
    return 'Video\'s gevonden ($count)';
  }

  @override
  String get castToTv => 'Casten naar tv';

  @override
  String get protectedVideo => 'Beveiligd, kan niet worden gecast';

  @override
  String get videoThumbnail => 'Videominiatuur';

  @override
  String castingTo(String device) {
    return 'Casten naar $device';
  }

  @override
  String get stopCasting => 'Casten stoppen';

  @override
  String get play => 'Afspelen';

  @override
  String get pause => 'Pauzeren';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Afspeelpositie';

  @override
  String get showControls => 'Bediening tonen';

  @override
  String get hideControls => 'Bediening verbergen';

  @override
  String get formatUnsupportedTitle => 'Indeling wordt niet ondersteund';

  @override
  String formatUnsupported(String device, String format) {
    return '$device kan geen $format-video\'s afspelen. Probeer een andere video op deze pagina of gebruik schermspiegeling.';
  }

  @override
  String get videoExpired =>
      'Deze videolink is verlopen. Laad de pagina opnieuw en probeer het nog eens.';

  @override
  String get refreshingVideo => 'Nieuwe videolink ophalen…';

  @override
  String get browserBack => 'Terug';

  @override
  String get browserForward => 'Vooruit';

  @override
  String get browserStartPage => 'Startpagina';

  @override
  String get browserReload => 'Opnieuw laden';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Start';

  @override
  String get devices => 'Apparaten';

  @override
  String get history => 'Geschiedenis';

  @override
  String get settings => 'Instellingen';

  @override
  String get goodMorning => 'Goedemorgen';

  @override
  String get goodAfternoon => 'Goedemiddag';

  @override
  String get goodEvening => 'Goedenavond';

  @override
  String get couldntOpenTheLink => 'Kan de link niet openen.';

  @override
  String get castflowLogo => 'Casten naar tv-logo';

  @override
  String get somethingWentWrong => 'Er is iets misgegaan';

  @override
  String get weCouldntLoadThis =>
      'We konden dit nu niet laden. Probeer het opnieuw.';

  @override
  String get apps => 'Apps';

  @override
  String open(Object name) {
    return '$name openen';
  }

  @override
  String get smartTv => 'Smart-tv';

  @override
  String get chromecast => 'Chromecast';

  @override
  String get fireTv => 'Fire TV';

  @override
  String get roku => 'Roku';

  @override
  String get dlnaRenderer => 'DLNA-renderer';

  @override
  String get miracast => 'Miracast';

  @override
  String get up => 'Omhoog';

  @override
  String get down => 'Omlaag';

  @override
  String get left => 'Links';

  @override
  String get right => 'Rechts';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Ingang';

  @override
  String get playPause => 'Afspelen / Pauzeren';

  @override
  String get previous => 'Vorige';

  @override
  String get next => 'Volgende';

  @override
  String get rewind => 'Terugspoelen';

  @override
  String get volumeUp => 'Volume omhoog';

  @override
  String get volumeDown => 'Volume omlaag';

  @override
  String get mute => 'Dempen';

  @override
  String connectedTo(Object name) {
    return 'Verbonden met $name';
  }

  @override
  String get chooseADevice => 'Kies een apparaat';

  @override
  String get connectionGuide => 'Verbindingsgids';

  @override
  String get lookingForTvsOn => 'Tv\'s zoeken op je wifi';

  @override
  String foundSoFar(Object found) {
    return 'Tot nu toe $found gevonden';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found apparaat$value gevonden';
  }

  @override
  String get disconnect => 'Verbinding verbreken';

  @override
  String signalOf4(Object level) {
    return 'Signaal $level van 4';
  }

  @override
  String get connecting2 => 'Verbinden';

  @override
  String get theTvRemoteNeeds =>
      'De tv-afstandsbediening heeft een verbonden tv nodig. Kies er hieronder een.';

  @override
  String get connectToATv => 'Verbind met een tv om door te gaan.';

  @override
  String get findingTvs => 'Tv\'s zoeken…';

  @override
  String get makeSureYourTv => 'Zorg dat je tv aanstaat';

  @override
  String get notConnected => 'Niet verbonden';

  @override
  String get tapToFindYour => 'Tik om je tv te zoeken';

  @override
  String get connectionFailed2 => 'Verbinding mislukt';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Tik om apparaten te beheren';
  }

  @override
  String get joinTheSameWi => 'Zelfde wifi gebruiken';

  @override
  String get connectYourPhoneAnd =>
      'Verbind je telefoon en je tv met hetzelfde wifi-netwerk.';

  @override
  String get turnOnCastingOn => 'Zet casten aan op je tv';

  @override
  String get enableScreenMirroringMiracast =>
      'Schakel Schermspiegeling, Miracast of Google Cast in bij de tv-instellingen.';

  @override
  String get scanForDevices => 'Zoeken naar apparaten';

  @override
  String get openDevicesInCastflow =>
      'Open Apparaten in Casten naar tv en wacht een paar seconden tot je tv verschijnt.';

  @override
  String get tapConnect => 'Tik op Verbinden';

  @override
  String get acceptThePromptOn =>
      'Accepteer de melding op je tv als die verschijnt. Dat is alles!';

  @override
  String get howToConnect => 'Zo verbind je';

  @override
  String get fourQuickStepsTo => 'Vier snelle stappen naar het grote scherm.';

  @override
  String get gotIt => 'Begrepen';

  @override
  String step(Object number, Object title, Object body) {
    return 'Stap $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wifi thuis';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Instellingen › Verbinding';

  @override
  String get inputHdmi1 => 'Ingang: HDMI 1';

  @override
  String get screenMirroring => 'Schermspiegeling';

  @override
  String get networkHomeWiFi => 'Netwerk: wifi thuis';

  @override
  String get livingRoomTv => 'Woonkamer-tv';

  @override
  String get allowCastflowToConnect =>
      'Casten naar tv toestaan om te verbinden?';

  @override
  String get deny => 'Weigeren';

  @override
  String get allow => 'Toestaan';

  @override
  String get yourTv => 'Je tv';

  @override
  String get findYourTv => 'Zoek je tv';

  @override
  String connectTo(Object name) {
    return 'Verbinden met $name';
  }

  @override
  String connected2(Object label) {
    return 'Verbonden · $label';
  }

  @override
  String get openTvRemote => 'Tv-afstandsbediening openen';

  @override
  String get sameWiFiNetwork => 'Zelfde wifi-netwerk';

  @override
  String get yourPhoneAndTv =>
      'Je telefoon en tv moeten met hetzelfde wifi zijn verbonden.';

  @override
  String get tvIsOnAnd => 'Tv staat aan en is klaar';

  @override
  String get turnOnScreenMirroring =>
      'Zet Schermspiegeling, Cast of Miracast aan op de tv.';

  @override
  String get noVpnOrGuest => 'Geen vpn of gastnetwerk';

  @override
  String get vpnsAndGuestIsolated =>
      'Vpn\'s en gast- of geïsoleerde wifi verbergen apparaten voor elkaar.';

  @override
  String get localNetworkAccess => 'Toegang tot lokaal netwerk';

  @override
  String get allowCastflowToFind =>
      'Sta Casten naar tv toe apparaten op je netwerk te vinden wanneer daarom wordt gevraagd.';

  @override
  String get noTvFound => 'Geen tv gevonden';

  @override
  String get checkThatYourPhone =>
      'Controleer of je telefoon en tv met hetzelfde wifi zijn verbonden en scan dan opnieuw.';

  @override
  String get noWiFiRouter => 'Geen wifi-router? Gebruik je hotspot';

  @override
  String searchingForTvsFound(Object length) {
    return 'Tv\'s zoeken. $length gevonden.';
  }

  @override
  String tvsFound(Object length) {
    return '$length tv\'s gevonden';
  }

  @override
  String get connectToYourTv => 'Verbind met je tv';

  @override
  String get connectYourPhoneAndTv =>
      'Verbind je telefoon en tv met hetzelfde wifi-netwerk.';

  @override
  String get turnOnTheTv =>
      'Zet de tv aan en open de ingang Schermspiegeling / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Tik op de verbindingsbalk op Start om je tv te zoeken.';

  @override
  String get tapConnectAndAccept =>
      'Tik op Verbinden en accepteer de melding op de tv als die verschijnt.';

  @override
  String get mirrorYourScreen => 'Spiegel je scherm';

  @override
  String get connectToYourTvFirst => 'Verbind eerst met je tv.';

  @override
  String get openScreenMirroringFrom => 'Open Schermspiegeling vanaf Start.';

  @override
  String get pickAQualityAnd => 'Kies een kwaliteit en tik op Starten.';

  @override
  String get allowScreenCaptureWhen =>
      'Sta schermopname toe wanneer Android erom vraagt.';

  @override
  String get castPhotosVideosMusic => 'Cast foto\'s, video\'s en muziek';

  @override
  String get openPhotosVideosOr => 'Open Foto\'s, Video\'s of Muziek op Start.';

  @override
  String get pickWhatYouWant => 'Kies wat je wilt tonen.';

  @override
  String get itPlaysOnThe =>
      'Het wordt op de tv afgespeeld; bedien het vanaf je telefoon of via de melding.';

  @override
  String get useTheTvRemote => 'Gebruik de tv-afstandsbediening';

  @override
  String get openTvRemoteOn => 'Open Tv-afstandsbediening op Start.';

  @override
  String get useTheDPad =>
      'Gebruik het d-pad of veeg op het touchpad om te bewegen en tik op OK om te selecteren.';

  @override
  String get buttonsATvDoesnt =>
      'Knoppen die een tv niet ondersteunt, zijn grijs.';

  @override
  String get castFromTheWeb => 'Cast vanaf het web en apps';

  @override
  String get tapTheBrowserBar => 'Tik op de browserbalk of een app op Start.';

  @override
  String get playAVideoOn => 'Speel een video af op de site.';

  @override
  String get tapCastThisVideo =>
      'Tik op ‘Deze video casten’ om hem naar je tv te sturen.';

  @override
  String get screenMirroringHelp => 'Hulp bij schermspiegeling';

  @override
  String get connectYourPhoneTo => 'Verbind je telefoon met wifi.';

  @override
  String get onTheTvOpen =>
      'Open op de tv Instellingen → Netwerk en maak verbinding met hetzelfde wifi.';

  @override
  String get guestOrOfficeNetworks =>
      'Gast- of kantoornetwerken blokkeren spiegelen vaak; gebruik je wifi thuis of de hotspot van je telefoon.';

  @override
  String get turnOffVpn => 'Zet vpn uit';

  @override
  String get aVpnHidesYour => 'Een vpn verbergt je tv voor je telefoon.';

  @override
  String get pauseOrDisconnectYour =>
      'Pauzeer of verbreek je vpn-app voordat je begint.';

  @override
  String get youCanTurnIt => 'Je kunt hem weer aanzetten als je klaar bent.';

  @override
  String get turnOnMirroringOn => 'Zet spiegelen aan op de tv';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG en de meeste Android-tv\'s accepteren spiegelen automatisch.';

  @override
  String get otherTvsOpenInput =>
      'Andere tv\'s: open Ingang / Bron en kies Schermspiegeling of Miracast.';

  @override
  String get keepTheTvOn =>
      'Houd de tv op dat scherm terwijl je telefoon verbindt.';

  @override
  String get tapStartAndPick => 'Tik op Starten en kies je tv';

  @override
  String get tapStartOnThe => 'Tik op Starten op het scherm Schermspiegeling.';

  @override
  String get androidOpensSmartView =>
      'Android opent Smart View / Cast. Tik op je tv in de lijst.';

  @override
  String get ifTheTvAsks =>
      'Als de tv erom vraagt, kies Toestaan of voer de pincode op het scherm in.';

  @override
  String get youreMirroring => 'Je spiegelt';

  @override
  String get everythingOnYourPhone =>
      'Alles op je telefoon is nu op de tv te zien.';

  @override
  String get turnThePhoneSideways =>
      'Draai de telefoon voor video\'s en games op volledig scherm.';

  @override
  String get toStopTapStop =>
      'Tik op Stoppen of gebruik de cast-melding om te stoppen.';

  @override
  String get vpn => 'Vpn';

  @override
  String get off => 'Uit';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'Slaapkamer-tv';

  @override
  String get officeDisplay => 'Kantoorscherm';

  @override
  String get clearHistory => 'Geschiedenis wissen?';

  @override
  String get thisRemovesEverythingYouve =>
      'Hiermee verwijder je alles wat je hebt gecast uit deze lijst.';

  @override
  String get clear => 'Wissen';

  @override
  String get clearHistory2 => 'Geschiedenis wissen';

  @override
  String get noHistoryYet => 'Nog geen geschiedenis';

  @override
  String get everythingYouCastWill =>
      'Alles wat je cast, staat hier zodat je het weer kunt vinden.';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String get earlier => 'Eerder';

  @override
  String get swipeAnItemTo => 'Veeg een item om het te verwijderen';

  @override
  String get delete => 'Verwijderen';

  @override
  String removed(Object title) {
    return '‘$title’ verwijderd';
  }

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get photos => 'Foto\'s';

  @override
  String get albums => 'Albums';

  @override
  String get videos => 'Video\'s';

  @override
  String get gallery => 'Galerij';

  @override
  String get music => 'Muziek';

  @override
  String get songs => 'Nummers';

  @override
  String get media => 'Media';

  @override
  String get browseTheWeb => 'Browse het web';

  @override
  String get goPro => 'Pro nemen';

  @override
  String cast(Object title) {
    return '$title casten';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Schermspiegeling. Spiegelen starten';

  @override
  String readyToMirrorTo(Object device) {
    return 'Klaar om te spiegelen naar $device';
  }

  @override
  String get showYourPhoneOn => 'Toon je telefoon in realtime op de tv.';

  @override
  String get startMirroring => 'Spiegelen starten';

  @override
  String get tvRemote => 'Tv-afstandsbediening';

  @override
  String get controlYourTv => 'Bedien je tv';

  @override
  String get youtubeMore => 'YouTube en meer';

  @override
  String get openTheBrowser => 'Open de browser';

  @override
  String get searchOrTypeA => 'Zoek of typ een website';

  @override
  String get howToConnectOpen => 'Zo verbind je. Open de visuele gids';

  @override
  String get visualGuideForEvery => 'Visuele gids voor elke functie';

  @override
  String get language => 'Taal';

  @override
  String get done => 'Klaar';

  @override
  String get enterAValidHttp =>
      'Voer een geldige http(s)- of rtsp-link in, bijv. een .m3u8- of .mp4-URL.';

  @override
  String get linkStream => 'Linkstream';

  @override
  String get iptvLinkCast => 'IPTV / Link casten';

  @override
  String get castALink => 'Een link casten';

  @override
  String get pasteADirectVideo =>
      'Plak een directe video-, M3U8- of IPTV-stream-URL.';

  @override
  String get paste => 'Plakken';

  @override
  String get castLink => 'Link casten';

  @override
  String get allowAccessToYour =>
      'Geef toegang tot je media om te casten. Je kunt dit wijzigen in Instellingen.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Muziek casten';

  @override
  String get noMusicFound => 'Geen muziek gevonden';

  @override
  String get addSongsToYour =>
      'Voeg nummers toe aan je telefoon en ze verschijnen hier.';

  @override
  String get shuffle => 'Willekeurig';

  @override
  String get playAll => 'Alles afspelen';

  @override
  String photo(Object formatShortDate) {
    return 'Foto · $formatShortDate';
  }

  @override
  String get photo2 => 'Foto';

  @override
  String get castPhotos => 'Foto\'s casten';

  @override
  String get select => 'Selecteren';

  @override
  String get noPhotosHere => 'Geen foto\'s hier';

  @override
  String get photosYouTakeOr =>
      'Foto\'s die je maakt of bewaart, verschijnen in dit album.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count foto\'s';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Foto van $formatShortDate';
  }

  @override
  String get allPhotos => 'Alle foto\'s';

  @override
  String get slideshow => 'Diavoorstelling';

  @override
  String get interval => 'Interval';

  @override
  String get transition => 'Overgang';

  @override
  String get fade => 'Vervagen';

  @override
  String get slide => 'Schuiven';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Diavoorstelling starten';

  @override
  String get castVideos => 'Video\'s casten';

  @override
  String get noVideosYet => 'Nog geen video\'s';

  @override
  String get videosYouRecordOr =>
      'Video\'s die je opneemt of downloadt, verschijnen hier, klaar om te casten.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Casten';
  }

  @override
  String get tv => 'Tv';

  @override
  String get screenMirroringSession => 'Schermspiegelingssessie';

  @override
  String get mirroringDidntStartTap =>
      'Spiegelen is niet gestart. Tik opnieuw op Starten en kies je tv in de lijst.';

  @override
  String get openSmartViewOr =>
      'Open Smart View of Cast via de snelle instellingen van je telefoon om te spiegelen.';

  @override
  String get quality => 'Kwaliteit';

  @override
  String get adjustsToYourWi =>
      'Past zich aan je wifi aan voor het soepelste beeld.';

  @override
  String upToLowerIt(Object label) {
    return 'Tot $label. Verlaag dit als het beeld hapert.';
  }

  @override
  String get stillNeedHelp => 'Nog hulp nodig?';

  @override
  String get startingScreenMirroring => 'Schermspiegeling starten…';

  @override
  String mirroringTo(Object value) {
    return 'Spiegelen naar $value';
  }

  @override
  String get stopping => 'Stoppen…';

  @override
  String get readyToMirror => 'Klaar om te spiegelen';

  @override
  String get beforeYouStart => 'Voordat je begint';

  @override
  String get phoneAndTvAre => 'Telefoon en tv zitten op hetzelfde wifi';

  @override
  String get noVpnIsConnected => 'Er is geen vpn verbonden op je telefoon';

  @override
  String get tvIsOnWith => 'Tv staat aan met Schermspiegeling ingeschakeld';

  @override
  String get phoneIsCloseTo => 'Telefoon is dicht bij de tv';

  @override
  String get stopMirroring => 'Spiegelen stoppen';

  @override
  String get startMirroring2 => 'Spiegelen starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get start => 'Starten';

  @override
  String get duration => 'Duur';

  @override
  String get adIsLoading => 'Advertentie wordt geladen';

  @override
  String get ad => 'Advertentie';

  @override
  String get mirrorYourScreenTo => 'Spiegel je scherm naar elke tv';

  @override
  String get showYourPhoneOnThe =>
      'Toon je telefoon met één tik op het grote scherm — geen kabels, geen gedoe.';

  @override
  String get shareMemoriesWithThe =>
      'Deel herinneringen met de hele kamer en houd de controle op je telefoon.';

  @override
  String get castFromWebApps => 'Cast vanaf web en apps';

  @override
  String get sendVideosFromYoutube =>
      'Stuur video\'s van YouTube, Facebook en elke website rechtstreeks naar je tv.';

  @override
  String pageOf(Object value, Object length) {
    return 'Pagina $value van $length';
  }

  @override
  String get getStarted => 'Aan de slag';

  @override
  String get localNetwork => 'Lokaal netwerk';

  @override
  String get findTvsAndStreaming =>
      'Vind tv\'s en streamingapparaten op je wifi.';

  @override
  String get notifications => 'Meldingen';

  @override
  String get showCastingControlsWhile =>
      'Toon cast-bediening terwijl je andere apps gebruikt.';

  @override
  String get photosVideosMusic => 'Foto\'s, video\'s en muziek';

  @override
  String get pickWhatYouWantTo =>
      'Kies wat je wilt casten uit je galerij en bibliotheek.';

  @override
  String get screenCapture => 'Schermopname';

  @override
  String get mirrorYourScreenYoull =>
      'Spiegel je scherm. Je bevestigt elke sessie.';

  @override
  String get webVideo => 'Webvideo';

  @override
  String get link => 'Link';

  @override
  String get screenMirroring2 => 'Schermspiegeling';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Nu aan het casten: $title. Afstandsbediening openen';
  }

  @override
  String castingTo2(Object value) {
    return 'Casten naar $value';
  }

  @override
  String get nowCasting => 'Nu aan het casten';

  @override
  String get nothingIsCasting => 'Er wordt niets gecast';

  @override
  String get pickAPhotoVideo =>
      'Kies een foto, video, nummer of webvideo om naar je tv te sturen.';

  @override
  String get backToHome => 'Terug naar start';

  @override
  String slide2(Object formatDuration) {
    return 'Dia $formatDuration';
  }

  @override
  String get back10Seconds => '10 seconden terug';

  @override
  String get forward10Seconds => '10 seconden vooruit';

  @override
  String get tvVolume => 'Tv-volume';

  @override
  String tvVolumePercent(Object round) {
    return 'Tv-volume $round procent';
  }

  @override
  String get upNext => 'Hierna';

  @override
  String get addPhotos => 'Foto\'s toevoegen';

  @override
  String get addVideos => 'Video\'s toevoegen';

  @override
  String get nothingElseInThe => 'Verder niets in de wachtrij.';

  @override
  String play2(Object title) {
    return '$title afspelen';
  }

  @override
  String get unknownDevice => 'Onbekend apparaat';

  @override
  String get perWeek => 'per week';

  @override
  String get perYear => 'per jaar';

  @override
  String get payOnce => 'eenmalig betalen';

  @override
  String get wirelessScreenMirroring => 'Draadloze schermspiegeling';

  @override
  String get castVideosPhotosMusic => 'Cast video\'s, foto\'s en muziek';

  @override
  String get fullTvRemoteControl => 'Volledige tv-afstandsbediening';

  @override
  String get worksWithAllMajor => 'Werkt met alle grote tv\'s';

  @override
  String get smoothLagFreeStreaming => 'Soepel streamen zonder vertraging';

  @override
  String get noAds => 'Geen advertenties';

  @override
  String get welcomeToCastflowPro => 'Welkom bij Casten naar tv Pro!';

  @override
  String get purchaseCancelled => 'Aankoop geannuleerd.';

  @override
  String get purchasePendingProUnlocks =>
      'Aankoop in behandeling. Pro wordt ontgrendeld zodra de store dit bevestigt.';

  @override
  String get purchaseFailedPleaseTry => 'Aankoop mislukt. Probeer het opnieuw.';

  @override
  String get theStoreIsntAvailable => 'De store is momenteel niet beschikbaar.';

  @override
  String get close => 'Sluiten';

  @override
  String get goProWithCastflow => 'NEEM PRO MET CASTEN NAAR TV';

  @override
  String get unlockEveryFeature => 'Ontgrendel alle functies';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Wordt automatisch verlengd tot opzegging.';

  @override
  String get oneTimePurchaseNo => 'Eenmalige aankoop. Geen abonnement.';

  @override
  String get continueAction => 'Doorgaan';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get termsAndConditions => 'Algemene voorwaarden';

  @override
  String get cancelAnytime => 'Altijd opzegbaar';

  @override
  String get loadingPrice => 'Prijs laden…';

  @override
  String get pricesUnavailableTapTo =>
      'Prijzen niet beschikbaar · Tik om opnieuw te proberen';

  @override
  String get noPlansAvailableRight =>
      'Momenteel geen abonnementen beschikbaar.';

  @override
  String get weekly => 'Wekelijks';

  @override
  String get yearly => 'Jaarlijks';

  @override
  String get lifetime => 'Levenslang';

  @override
  String get bestValue => 'Beste waarde';

  @override
  String get disconnectFromTv => 'Verbinding met tv verbreken?';

  @override
  String get thisStopsWhatIs =>
      'Hiermee stop je wat nu wordt afgespeeld of gespiegeld.';

  @override
  String get useTouchpad => 'Touchpad gebruiken';

  @override
  String get useDPad => 'D-pad gebruiken';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label-ontvangers accepteren geen afstandsbedieningscommando\'s.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Sommige knoppen zijn niet beschikbaar op $label.';
  }

  @override
  String get idle => 'INACTIEF';

  @override
  String get playing => 'AFSPELEN';

  @override
  String get paused => 'GEPAUZEERD';

  @override
  String get noTvConnected => 'Geen tv verbonden';

  @override
  String get mute2 => 'DEMPEN';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Geen tv verbonden. Tik om een apparaat te kiezen';

  @override
  String get tapToChooseA => 'Tik om een apparaat te kiezen';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label wordt niet ondersteund door $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Touchpad. Veeg om te bewegen, tik om te selecteren.';

  @override
  String get swipeToMoveTap => 'Veeg om te bewegen · Tik om te selecteren';

  @override
  String get navigationIsntSupportedBy =>
      'Navigatie wordt niet ondersteund door deze tv';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automatisch';

  @override
  String get googleCastFirst => 'Eerst Google Cast';

  @override
  String get dlnaUpnpFirst => 'Eerst DLNA / UPnP';

  @override
  String get miracastFirst => 'Eerst Miracast';

  @override
  String get tvOnly => 'Alleen tv';

  @override
  String get phoneAndTv => 'Telefoon en tv';

  @override
  String get phoneOnly => 'Alleen telefoon';

  @override
  String get touchpad => 'Touchpad';

  @override
  String get doMyPhoneAnd =>
      'Moeten mijn telefoon en tv hetzelfde wifi gebruiken?';

  @override
  String get yesDiscoveryAndCasting =>
      'Ja. Zoeken en casten gebeuren op je lokale netwerk, dus beide moeten op hetzelfde wifi zitten (dezelfde bandnamen kunnen nog steeds verschillende netwerken zijn).';

  @override
  String get myRouterHasAp => 'Mijn router heeft ‘AP- / clientisolatie’';

  @override
  String get isolationBlocksDevicesFrom =>
      'Isolatie voorkomt dat apparaten elkaar zien. Zet het uit in de routerinstellingen of gebruik een netwerk dat geen gastnetwerk is.';

  @override
  String get findingYourTv => 'Je tv zoeken';

  @override
  String get myTvDoesntAppear => 'Mijn tv staat niet in de lijst';

  @override
  String get turnOnCastingScreen =>
      'Zet casten / schermspiegeling aan op de tv, haal hem uit stand-by en tik op Opnieuw scannen. Geef toestemming voor Lokaal netwerk als daarom wordt gevraagd.';

  @override
  String get onlySomeDevicesShow => 'Slechts enkele apparaten verschijnen';

  @override
  String get olderTvsMayNeed =>
      'Oudere tv\'s hebben mogelijk een firmware-update nodig. Miracast-tv\'s verschijnen alleen zolang hun ingang ‘Schermspiegeling’ open is.';

  @override
  String get connectionFailsOrTimes => 'Verbinding mislukt of verloopt';

  @override
  String get restartTheTvApp =>
      'Herstart de tv-app of de tv, ga dichter bij de router staan en accepteer elke melding op het tv-scherm.';

  @override
  String get itKeepsReconnectingTo => 'Hij blijft verbinden met een oude tv';

  @override
  String get turnOffAutoConnect =>
      'Zet ‘Automatisch verbinden met laatste tv’ uit bij Instellingen → Casten.';

  @override
  String get mirroringIsLaggy => 'Spiegelen loopt vertraagd';

  @override
  String get chooseALowerQuality =>
      'Kies een lagere kwaliteit (720p of 480p), sluit zware apps en gebruik een 5 GHz-wifinetwerk.';

  @override
  String get thePictureIsRotated => 'Het beeld is gedraaid of bijgesneden';

  @override
  String get toggleAutoRotateOn =>
      'Schakel Automatisch roteren in op het scherm Schermspiegeling.';

  @override
  String get sound => 'Geluid';

  @override
  String get thereIsNoSound => 'Er is geen geluid op de tv';

  @override
  String get makeSureAudioIs =>
      'Zorg dat Audio aanstaat bij Schermspiegeling en controleer Instellingen → Casten → Audio-uitvoer. Sommige ontvangers ondersteunen geen telefoonaudio.';

  @override
  String get tvRemote2 => 'Tv-afstandsbediening';

  @override
  String get someRemoteButtonsAre =>
      'Sommige knoppen van de afstandsbediening zijn grijs';

  @override
  String get eachReceiverSupportsDifferent =>
      'Elke ontvanger ondersteunt andere commando\'s. Chromecast en DLNA ondersteunen alleen afspelen en volume; Miracast heeft geen afstandsbedieningskanaal.';

  @override
  String get canCastflowTurnMy =>
      'Kan Casten naar tv mijn tv aanzetten of de ingang wijzigen?';

  @override
  String get onlyOnTvsThat =>
      'Alleen op tv\'s die die commando\'s via het netwerk beschikbaar stellen. Niet-ondersteunde knoppen zijn uitgeschakeld in plaats van te doen alsof ze werken.';

  @override
  String get helpFaq => 'Help en veelgestelde vragen';

  @override
  String get stepByStepConnection => 'Stapsgewijze verbindingsgids';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Geen e-mail-app gevonden.';

  @override
  String get enjoyingCastflow => 'Bevalt Casten naar tv?';

  @override
  String get sorryToHearThat => 'Jammer om te horen';

  @override
  String get thanksHowCanWe => 'Bedankt! Hoe kunnen we verbeteren?';

  @override
  String get wereGladYouLike => 'Fijn dat je het leuk vindt!';

  @override
  String get youMadeOurDay => 'Je hebt onze dag gemaakt!';

  @override
  String get tapToExit => 'Tik om af te sluiten';

  @override
  String get selectARating => 'Kies een beoordeling';

  @override
  String get sendFeedback => 'Feedback sturen';

  @override
  String get rateUs => 'Beoordeel ons';

  @override
  String get rateYourExperienceBefore =>
      'Beoordeel je ervaring voordat je gaat.';

  @override
  String get tapAStarTo => 'Tik op een ster om Casten naar tv te beoordelen.';

  @override
  String get general => 'Algemeen';

  @override
  String get english => 'Engels';

  @override
  String get defaultQuality => 'Standaardkwaliteit';

  @override
  String get autoConnectToLast => 'Automatisch verbinden met laatste tv';

  @override
  String get appearance => 'Weergave';

  @override
  String get light => 'Licht';

  @override
  String get dark => 'Donker';

  @override
  String get system => 'Systeem';

  @override
  String get aboutSupport => 'Over en ondersteuning';

  @override
  String get rateApp => 'App beoordelen';

  @override
  String get feedback => 'Feedback';

  @override
  String get termsConditions => 'Algemene voorwaarden';

  @override
  String get version => 'Versie';

  @override
  String get castflowProIsActive => 'Casten naar tv Pro is actief';

  @override
  String get upgradeToPremium => 'Upgraden naar Premium';

  @override
  String get castflowPremium => 'Casten naar tv Premium';

  @override
  String get thanksForYourSupport =>
      'Bedankt voor je steun. Geniet van casten zonder advertenties.';

  @override
  String get noAds1080pMirroring =>
      'Geen advertenties, 1080p-spiegeling en onbeperkt casten';

  @override
  String get upgrade => 'Upgraden';

  @override
  String get mirrorCastBeautifullySimple =>
      'Spiegelen en casten, prachtig eenvoudig';

  @override
  String get thisActionMayContain => 'Deze actie kan advertenties bevatten';

  @override
  String get webCast => 'Webcast';

  @override
  String get castThisVideo => 'Deze video casten';

  @override
  String get searchOrTypeAWeb => 'Zoek of typ een webadres';

  @override
  String get removeBookmark => 'Bladwijzer verwijderen';

  @override
  String get bookmark => 'Bladwijzer';

  @override
  String get quickAccess => 'Snelle toegang';

  @override
  String open2(Object title) {
    return '$title openen';
  }

  @override
  String get bookmarks => 'Bladwijzers';

  @override
  String get noBookmarks => 'Geen bladwijzers';

  @override
  String get tapTheBookmarkIcon =>
      'Tik op het bladwijzerpictogram in de adresbalk om een pagina op te slaan.';

  @override
  String get noHistory => 'Geen geschiedenis';

  @override
  String get pagesYouVisitShow => 'Pagina\'s die je bezoekt, verschijnen hier.';

  @override
  String get remove => 'Verwijderen';

  @override
  String resultOn(Object value, Object host) {
    return 'Resultaat $value op $host';
  }

  @override
  String get aSimulatedPageResult => 'Een gesimuleerd paginaresultaat';

  @override
  String get videosOnThisPage => 'Video\'s op deze pagina';

  @override
  String get pickOneToSend => 'Kies er een om naar je tv te sturen.';

  @override
  String get onboardHotspotTitle => 'Geen wifi? Gebruik je hotspot';

  @override
  String get onboardHotspotBody =>
      'Zet de hotspot van je telefoon aan en verbind je tv ermee. Casten werkt net als via wifi.';

  @override
  String get stillCantFindTitle => 'Je tv nog steeds niet gevonden?';

  @override
  String get stillCantFindBody =>
      'Verbind je tv in plaats daarvan met de hotspot van je telefoon:';

  @override
  String get hotspotStep4 => 'Tik op Opnieuw en kies je tv in de lijst';

  @override
  String get castOverHotspot =>
      'Geen wifi? Cast via de hotspot van je telefoon:';

  @override
  String get queue => 'Wachtrij';

  @override
  String get addMusic => 'Muziek toevoegen';

  @override
  String get connectWithWifi => 'Verbinden via wifi';

  @override
  String get continueWithHotspot => 'Doorgaan met hotspot';

  @override
  String get noWifiAlertMessage =>
      'Je gebruikt mobiele data. Verbind je telefoon en tv met hetzelfde wifi of zet de hotspot van je telefoon aan en verbind de tv ermee.';

  @override
  String get checkingNetwork => 'Netwerk controleren...';

  @override
  String get discoveryStopped => 'Zoeken gestopt';

  @override
  String get discoveryStoppedHint =>
      'Zoeken gestopt. Tik op zoeken om apparaten in de buurt te vinden.';

  @override
  String get search => 'Zoeken';

  @override
  String get permissionNeededToDiscover =>
      'Locatietoestemming is vereist om apparaten op wifi te vinden.';

  @override
  String get locationServicesDisabled => 'Locatievoorzieningen uitgeschakeld';

  @override
  String get openLocationSettings => 'Locatie-instellingen openen';

  @override
  String get openAppSettings => 'App-instellingen openen';

  @override
  String get subscriptionExpired => 'Je abonnement is verlopen.';

  @override
  String get noPurchasesFound => 'Geen eerdere aankopen gevonden.';

  @override
  String get restore => 'Herstellen';

  @override
  String get permissionNeeded => 'Toestemming nodig';

  @override
  String get permissionBlockedInSettings =>
      'Toestemming geblokkeerd in instellingen';

  @override
  String get grantPermission => 'Toestemming geven';

  @override
  String get checkAgain => 'Opnieuw controleren';

  @override
  String get appName => 'Casten naar tv';

  @override
  String get allowPermission => 'Toestemming geven';

  @override
  String get openSettings => 'Instellingen openen';

  @override
  String get noNetworkMessage =>
      'Zet wifi aan (hetzelfde netwerk als je tv) of deel de hotspot van je telefoon en verbind de tv ermee.';

  @override
  String get turnOnWifi => 'Wifi aanzetten';

  @override
  String get waitingForNetwork => 'We zoeken je tv zodra je verbonden bent.';

  @override
  String get howHotspotWorks => 'Hoe werkt casten via hotspot?';

  @override
  String get preparingForTv => 'Voorbereiden voor je tv…';

  @override
  String convertingForTv(int percent) {
    return 'Omzetten voor je tv… $percent%';
  }

  @override
  String get lookingForTvsOnHotspot => 'Zoeken naar tv\'s op je hotspot';

  @override
  String get noInternetConnection =>
      'Geen internetverbinding. Controleer je verbinding en probeer het opnieuw.';

  @override
  String get convertingToTvFormat => 'Omzetten naar het formaat van je tv';

  @override
  String get playMode => 'Afspeelmodus';

  @override
  String get playModeOnce => 'Eén keer afspelen';

  @override
  String get playModeAutoplay => 'Automatisch afspelen';

  @override
  String get playModeRepeatAll => 'Alles herhalen';

  @override
  String get playModeRepeatOne => 'Eén herhalen';

  @override
  String convertingExplain(Object from, Object to) {
    return 'Je tv kan $from niet rechtstreeks afspelen, daarom wordt het omgezet naar $to.';
  }

  @override
  String get convertingKeepOpen =>
      'Laat de app open. Het start vanzelf op je tv zodra het klaar is.';

  @override
  String get checkingTvFormats => 'Controleren wat je tv kan afspelen…';

  @override
  String convertingTimeLeft(Object time) {
    return 'Nog ongeveer $time';
  }
}
