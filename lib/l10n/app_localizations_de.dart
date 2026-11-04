// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get networkRequiredTitle => 'Nicht mit WLAN verbunden';

  @override
  String get networkRequiredMessage =>
      'Handy und Fernseher müssen im selben WLAN sein, um zu streamen.';

  @override
  String get openWifiSettings => 'WLAN-Einstellungen öffnen';

  @override
  String get useMobileHotspot => 'Mobilen Hotspot verwenden';

  @override
  String get hotspotInstruction =>
      'Verbinde deinen Fernseher mit dem Hotspot deines Handys.';

  @override
  String get hotspotStep1 => 'Mobilen Hotspot einschalten';

  @override
  String get hotspotStep2 => 'Verbinde deinen Fernseher damit';

  @override
  String get hotspotStep3 => 'Zurück zur App';

  @override
  String get openHotspotSettings => 'Hotspot-Einstellungen öffnen';

  @override
  String get hotspotAutoCheck =>
      'Wir prüfen automatisch erneut, wenn du zurückkommst.';

  @override
  String get hotspotDetected => 'Hotspot ist an. Suche nach deinem Fernseher…';

  @override
  String get searchingDevices => 'Suche nach Geräten in der Nähe...';

  @override
  String get waitingForTvOnHotspot =>
      'Warte darauf, dass dein Fernseher dem Hotspot beitritt…';

  @override
  String get usingHotspot => 'Dein mobiler Hotspot wird verwendet';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Geräte gefunden',
      one: '1 Gerät gefunden',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get scanAgain => 'Erneut suchen';

  @override
  String get isolationTitle => 'Fernseher antwortet nicht';

  @override
  String get isolationHint =>
      'Ein Gerät ist deinem Hotspot beigetreten, antwortet aber nicht. Dein Hotspot blockiert eventuell den Datenverkehr zwischen Geräten (Client-Isolation). Schalte das in den Hotspot-Einstellungen aus oder nutze ein WLAN.';

  @override
  String get connecting => 'Verbinde…';

  @override
  String get connected => 'Verbunden';

  @override
  String get connectionFailed => 'Verbindung nicht möglich';

  @override
  String get connectFailedHint =>
      'Prüfe, ob Handy und Fernseher im selben Netzwerk sind, und versuche es erneut.';

  @override
  String get hotspotConnectHint =>
      'Dein Hotspot blockiert eventuell den Datenverkehr zwischen Geräten. Prüfe die Client-Isolation.';

  @override
  String get networkLostTitle => 'Netzwerkverbindung verloren';

  @override
  String get networkLostMessage =>
      'Verbinde dich erneut mit WLAN oder Hotspot und dann wieder mit dem Fernseher.';

  @override
  String get reconnect => 'Neu verbinden';

  @override
  String reconnectTo(String name) {
    return 'Erneut mit $name verbinden';
  }

  @override
  String get tapToReconnect => 'Zum Neuverbinden tippen';

  @override
  String get pairingRequired => 'Kopplung erforderlich';

  @override
  String get pairingEnterCode =>
      'Gib den auf dem Fernseher angezeigten Code ein.';

  @override
  String get pairingApproveOnTv =>
      'Sieh auf den Fernseher und tippe auf Zulassen, um fortzufahren.';

  @override
  String get connect => 'Verbinden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get pairingIncorrectCode => 'Falscher Code. Versuche es erneut.';

  @override
  String get pairingTimedOut => 'Zeitüberschreitung bei der Kopplung';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get pairingDeclined => 'Der Fernseher hat die Verbindung abgelehnt';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Zu viele falsche Codes. Warte $seconds s und fordere dann einen neuen Code an.';
  }

  @override
  String get pairingCooldownOver =>
      'Du kannst jetzt einen neuen Code anfordern.';

  @override
  String get pairingRequestNewCode => 'Neuen Code anfordern';

  @override
  String get pairingNetworkLost =>
      'Das Netzwerk ging bei der Kopplung verloren. Verbinde dich erneut mit dem WLAN und versuche es noch mal.';

  @override
  String get pairingFailed => 'Kopplung mit dem Fernseher nicht möglich.';

  @override
  String pairingCodeField(int length) {
    return 'Kopplungscode, $length Zeichen';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Feld $index von $total';
  }

  @override
  String get pairingEmptyBox => 'leer';

  @override
  String get pairingPaired => 'Gekoppelt';

  @override
  String get forgetDevice => 'Gerät vergessen';

  @override
  String forgetDeviceMessage(String name) {
    return '$name muss beim nächsten Mal erneut gekoppelt werden.';
  }

  @override
  String get forget => 'Vergessen';

  @override
  String get castVideo => 'Video streamen';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Videos gefunden. Video streamen',
      one: '1 Video gefunden. Video streamen',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Auf dieser Seite wurde noch kein Video gefunden.';

  @override
  String get videoFound => 'Video gefunden';

  @override
  String get videoFoundMessage => 'Auf deinem Fernseher abspielen.';

  @override
  String get castAction => 'Streamen';

  @override
  String get dismiss => 'Schließen';

  @override
  String videosFound(int count) {
    return 'Gefundene Videos ($count)';
  }

  @override
  String get castToTv => 'Auf TV streamen';

  @override
  String get protectedVideo => 'Geschützt, kann nicht gestreamt werden';

  @override
  String get videoThumbnail => 'Video-Vorschaubild';

  @override
  String castingTo(String device) {
    return 'Streamt auf $device';
  }

  @override
  String get stopCasting => 'Streaming beenden';

  @override
  String get play => 'Wiedergabe';

  @override
  String get pause => 'Pause';

  @override
  String get volume => 'Lautstärke';

  @override
  String get seekPosition => 'Wiedergabeposition';

  @override
  String get showControls => 'Steuerelemente einblenden';

  @override
  String get hideControls => 'Steuerelemente ausblenden';

  @override
  String get formatUnsupportedTitle => 'Format nicht unterstützt';

  @override
  String formatUnsupported(String device, String format) {
    return '$device kann $format-Videos nicht abspielen. Probiere ein anderes Video auf dieser Seite oder nutze die Bildschirmspiegelung.';
  }

  @override
  String get videoExpired =>
      'Der Videolink ist abgelaufen. Lade die Seite neu und versuche es erneut.';

  @override
  String get refreshingVideo => 'Neuer Videolink wird geholt…';

  @override
  String get browserBack => 'Zurück';

  @override
  String get browserForward => 'Vor';

  @override
  String get browserStartPage => 'Startseite';

  @override
  String get browserReload => 'Neu laden';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Start';

  @override
  String get devices => 'Geräte';

  @override
  String get history => 'Verlauf';

  @override
  String get settings => 'Einstellungen';

  @override
  String get goodMorning => 'Guten Morgen';

  @override
  String get goodAfternoon => 'Guten Tag';

  @override
  String get goodEvening => 'Guten Abend';

  @override
  String get couldntOpenTheLink => 'Link konnte nicht geöffnet werden.';

  @override
  String get castflowLogo => 'CastFlow-Logo';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get weCouldntLoadThis =>
      'Das konnte gerade nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get apps => 'Apps';

  @override
  String open(Object name) {
    return '$name öffnen';
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
  String get up => 'Hoch';

  @override
  String get down => 'Runter';

  @override
  String get left => 'Links';

  @override
  String get right => 'Rechts';

  @override
  String get menu => 'Menü';

  @override
  String get input => 'Eingang';

  @override
  String get playPause => 'Wiedergabe / Pause';

  @override
  String get previous => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get rewind => 'Zurückspulen';

  @override
  String get volumeUp => 'Lauter';

  @override
  String get volumeDown => 'Leiser';

  @override
  String get mute => 'Stumm';

  @override
  String connectedTo(Object name) {
    return 'Verbunden mit $name';
  }

  @override
  String get chooseADevice => 'Gerät auswählen';

  @override
  String get connectionGuide => 'Verbindungsanleitung';

  @override
  String get lookingForTvsOn => 'Suche nach Fernsehern in deinem WLAN';

  @override
  String foundSoFar(Object found) {
    return 'Bisher $found gefunden';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found Geräte gefunden';
  }

  @override
  String get disconnect => 'Trennen';

  @override
  String signalOf4(Object level) {
    return 'Signal $level von 4';
  }

  @override
  String get connecting2 => 'Verbinde';

  @override
  String get theTvRemoteNeeds =>
      'Die Fernbedienung braucht einen verbundenen Fernseher. Wähle unten einen aus.';

  @override
  String get connectToATv =>
      'Verbinde dich mit einem Fernseher, um fortzufahren.';

  @override
  String get findingTvs => 'Suche Fernseher…';

  @override
  String get makeSureYourTv =>
      'Stelle sicher, dass dein Fernseher eingeschaltet ist';

  @override
  String get notConnected => 'Nicht verbunden';

  @override
  String get tapToFindYour => 'Tippen, um deinen Fernseher zu finden';

  @override
  String get connectionFailed2 => 'Verbindung fehlgeschlagen';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Tippen, um Geräte zu verwalten';
  }

  @override
  String get joinTheSameWi => 'Dasselbe WLAN nutzen';

  @override
  String get connectYourPhoneAnd =>
      'Verbinde Handy und Fernseher mit demselben WLAN.';

  @override
  String get turnOnCastingOn => 'Streaming am Fernseher aktivieren';

  @override
  String get enableScreenMirroringMiracast =>
      'Aktiviere Bildschirmspiegelung, Miracast oder Google Cast in den Fernseher-Einstellungen.';

  @override
  String get scanForDevices => 'Nach Geräten suchen';

  @override
  String get openDevicesInCastflow =>
      'Öffne Geräte in CastFlow und warte einige Sekunden, bis dein Fernseher erscheint.';

  @override
  String get tapConnect => 'Auf Verbinden tippen';

  @override
  String get acceptThePromptOn =>
      'Bestätige die Anfrage am Fernseher, falls sie erscheint. Das war’s!';

  @override
  String get howToConnect => 'So verbindest du dich';

  @override
  String get fourQuickStepsTo =>
      'Vier schnelle Schritte auf den großen Bildschirm.';

  @override
  String get gotIt => 'Verstanden';

  @override
  String step(Object number, Object title, Object body) {
    return 'Schritt $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Heim-WLAN';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Einstellungen › Verbindung';

  @override
  String get inputHdmi1 => 'Eingang: HDMI 1';

  @override
  String get screenMirroring => 'Bildschirmspiegelung';

  @override
  String get networkHomeWiFi => 'Netzwerk: Heim-WLAN';

  @override
  String get livingRoomTv => 'Wohnzimmer-TV';

  @override
  String get allowCastflowToConnect => 'CastFlow die Verbindung erlauben?';

  @override
  String get deny => 'Ablehnen';

  @override
  String get allow => 'Zulassen';

  @override
  String get yourTv => 'Dein Fernseher';

  @override
  String get findYourTv => 'Finde deinen Fernseher';

  @override
  String connectTo(Object name) {
    return 'Mit $name verbinden';
  }

  @override
  String connected2(Object label) {
    return 'Verbunden · $label';
  }

  @override
  String get openTvRemote => 'TV-Fernbedienung öffnen';

  @override
  String get sameWiFiNetwork => 'Dasselbe WLAN';

  @override
  String get yourPhoneAndTv =>
      'Handy und Fernseher müssen mit demselben WLAN verbunden sein.';

  @override
  String get tvIsOnAnd => 'Fernseher ist an und bereit';

  @override
  String get turnOnScreenMirroring =>
      'Aktiviere Bildschirmspiegelung, Cast oder Miracast am Fernseher.';

  @override
  String get noVpnOrGuest => 'Kein VPN oder Gastnetzwerk';

  @override
  String get vpnsAndGuestIsolated =>
      'VPNs und Gast- bzw. isolierte WLANs verbergen Geräte voreinander.';

  @override
  String get localNetworkAccess => 'Zugriff auf das lokale Netzwerk';

  @override
  String get allowCastflowToFind =>
      'Erlaube CastFlow auf Nachfrage, Geräte in deinem Netzwerk zu finden.';

  @override
  String get noTvFound => 'Kein Fernseher gefunden';

  @override
  String get checkThatYourPhone =>
      'Prüfe, ob Handy und Fernseher im selben WLAN sind, und suche erneut.';

  @override
  String get noWiFiRouter => 'Kein WLAN-Router? Nutze deinen Hotspot';

  @override
  String searchingForTvsFound(Object length) {
    return 'Suche nach Fernsehern. $length gefunden.';
  }

  @override
  String tvsFound(Object length) {
    return '$length Fernseher gefunden';
  }

  @override
  String get connectToYourTv => 'Mit deinem Fernseher verbinden';

  @override
  String get connectYourPhoneAndTv =>
      'Verbinde Handy und Fernseher mit demselben WLAN.';

  @override
  String get turnOnTheTv =>
      'Schalte den Fernseher ein und öffne den Eingang Bildschirmspiegelung / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Tippe auf die Verbindungsleiste im Start, um deinen Fernseher zu finden.';

  @override
  String get tapConnectAndAccept =>
      'Tippe auf Verbinden und bestätige die Anfrage am Fernseher, falls sie erscheint.';

  @override
  String get mirrorYourScreen => 'Bildschirm spiegeln';

  @override
  String get connectToYourTvFirst =>
      'Verbinde dich zuerst mit deinem Fernseher.';

  @override
  String get openScreenMirroringFrom => 'Öffne Bildschirmspiegelung im Start.';

  @override
  String get pickAQualityAnd => 'Wähle eine Qualität und tippe auf Start.';

  @override
  String get allowScreenCaptureWhen =>
      'Erlaube die Bildschirmaufnahme, wenn Android fragt.';

  @override
  String get castPhotosVideosMusic => 'Fotos, Videos und Musik streamen';

  @override
  String get openPhotosVideosOr => 'Öffne Fotos, Videos oder Musik im Start.';

  @override
  String get pickWhatYouWant => 'Wähle, was du zeigen möchtest.';

  @override
  String get itPlaysOnThe =>
      'Es läuft auf dem Fernseher; steuere es per Handy oder Benachrichtigung.';

  @override
  String get useTheTvRemote => 'TV-Fernbedienung nutzen';

  @override
  String get openTvRemoteOn => 'Öffne TV-Fernbedienung im Start.';

  @override
  String get useTheDPad =>
      'Nutze das Steuerkreuz oder wische auf dem Touchpad, tippe auf OK zum Auswählen.';

  @override
  String get buttonsATvDoesnt =>
      'Tasten, die der Fernseher nicht unterstützt, sind ausgegraut.';

  @override
  String get castFromTheWeb => 'Aus dem Web und Apps streamen';

  @override
  String get tapTheBrowserBar =>
      'Tippe auf die Browserleiste oder eine App im Start.';

  @override
  String get playAVideoOn => 'Spiele ein Video auf der Seite ab.';

  @override
  String get tapCastThisVideo =>
      'Tippe auf „Dieses Video streamen“, um es an den Fernseher zu senden.';

  @override
  String get screenMirroringHelp => 'Hilfe zur Bildschirmspiegelung';

  @override
  String get connectYourPhoneTo => 'Verbinde dein Handy mit dem WLAN.';

  @override
  String get onTheTvOpen =>
      'Öffne am Fernseher Einstellungen → Netzwerk und tritt demselben WLAN bei.';

  @override
  String get guestOrOfficeNetworks =>
      'Gast- oder Firmennetzwerke blockieren Spiegelung oft; nutze dein Heim-WLAN oder den Hotspot deines Handys.';

  @override
  String get turnOffVpn => 'VPN ausschalten';

  @override
  String get aVpnHidesYour =>
      'Ein VPN verbirgt deinen Fernseher vor deinem Handy.';

  @override
  String get pauseOrDisconnectYour =>
      'Pausiere oder trenne deine VPN-App, bevor du startest.';

  @override
  String get youCanTurnIt => 'Du kannst sie danach wieder einschalten.';

  @override
  String get turnOnMirroringOn => 'Spiegelung am Fernseher aktivieren';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG und die meisten Android-Fernseher akzeptieren die Spiegelung automatisch.';

  @override
  String get otherTvsOpenInput =>
      'Andere Fernseher: Öffne Eingang / Quelle und wähle Bildschirmspiegelung oder Miracast.';

  @override
  String get keepTheTvOn =>
      'Lass den Fernseher auf diesem Bildschirm, während dein Handy sich verbindet.';

  @override
  String get tapStartAndPick => 'Auf Start tippen und Fernseher wählen';

  @override
  String get tapStartOnThe =>
      'Tippe auf dem Bildschirm Bildschirmspiegelung auf Start.';

  @override
  String get androidOpensSmartView =>
      'Android öffnet Smart View / Cast. Tippe in der Liste auf deinen Fernseher.';

  @override
  String get ifTheTvAsks =>
      'Wenn der Fernseher fragt, wähle Zulassen oder gib die angezeigte PIN ein.';

  @override
  String get youreMirroring => 'Du spiegelst gerade';

  @override
  String get everythingOnYourPhone =>
      'Alles auf deinem Handy ist jetzt auf dem Fernseher zu sehen.';

  @override
  String get turnThePhoneSideways =>
      'Drehe das Handy für Vollbild-Videos und Spiele.';

  @override
  String get toStopTapStop =>
      'Zum Beenden tippe auf Stopp oder nutze die Streaming-Benachrichtigung.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Aus';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'Schlafzimmer-TV';

  @override
  String get officeDisplay => 'Büro-Display';

  @override
  String get clearHistory => 'Verlauf löschen?';

  @override
  String get thisRemovesEverythingYouve =>
      'Dadurch wird alles, was du gestreamt hast, aus dieser Liste entfernt.';

  @override
  String get clear => 'Löschen';

  @override
  String get clearHistory2 => 'Verlauf löschen';

  @override
  String get noHistoryYet => 'Noch kein Verlauf';

  @override
  String get everythingYouCastWill =>
      'Alles, was du streamst, erscheint hier, damit du es wiederfinden kannst.';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get earlier => 'Früher';

  @override
  String get swipeAnItemTo => 'Wische ein Element, um es zu entfernen';

  @override
  String get delete => 'Löschen';

  @override
  String removed(Object title) {
    return '„$title“ entfernt';
  }

  @override
  String get undo => 'Rückgängig';

  @override
  String get photos => 'Fotos';

  @override
  String get albums => 'Alben';

  @override
  String get videos => 'Videos';

  @override
  String get gallery => 'Galerie';

  @override
  String get music => 'Musik';

  @override
  String get songs => 'Songs';

  @override
  String get media => 'Medien';

  @override
  String get browseTheWeb => 'Im Web surfen';

  @override
  String get goPro => 'Pro holen';

  @override
  String cast(Object title) {
    return '$title streamen';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Bildschirmspiegelung. Spiegelung starten';

  @override
  String readyToMirrorTo(Object device) {
    return 'Bereit zum Spiegeln auf $device';
  }

  @override
  String get showYourPhoneOn =>
      'Zeige dein Handy in Echtzeit auf dem Fernseher.';

  @override
  String get startMirroring => 'Spiegelung starten';

  @override
  String get tvRemote => 'TV-Fernbedienung';

  @override
  String get controlYourTv => 'Steuere deinen Fernseher';

  @override
  String get youtubeMore => 'YouTube und mehr';

  @override
  String get openTheBrowser => 'Browser öffnen';

  @override
  String get searchOrTypeA => 'Suchen oder Website eingeben';

  @override
  String get howToConnectOpen =>
      'So verbindest du dich. Visuelle Anleitung öffnen';

  @override
  String get visualGuideForEvery => 'Visuelle Anleitung für jede Funktion';

  @override
  String get language => 'Sprache';

  @override
  String get done => 'Fertig';

  @override
  String get enterAValidHttp =>
      'Gib einen gültigen http(s)- oder rtsp-Link ein, z. B. eine .m3u8- oder .mp4-URL.';

  @override
  String get linkStream => 'Link-Stream';

  @override
  String get iptvLinkCast => 'IPTV / Link streamen';

  @override
  String get castALink => 'Link streamen';

  @override
  String get pasteADirectVideo =>
      'Füge eine direkte Video-, M3U8- oder IPTV-Stream-URL ein.';

  @override
  String get paste => 'Einfügen';

  @override
  String get castLink => 'Link streamen';

  @override
  String get allowAccessToYour =>
      'Erlaube den Zugriff auf deine Medien, um sie zu streamen. Du kannst das in den Einstellungen ändern.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Musik streamen';

  @override
  String get noMusicFound => 'Keine Musik gefunden';

  @override
  String get addSongsToYour =>
      'Füge Songs auf deinem Handy hinzu, dann erscheinen sie hier.';

  @override
  String get shuffle => 'Zufall';

  @override
  String get playAll => 'Alle abspielen';

  @override
  String photo(Object formatShortDate) {
    return 'Foto · $formatShortDate';
  }

  @override
  String get photo2 => 'Foto';

  @override
  String get castPhotos => 'Fotos streamen';

  @override
  String get select => 'Auswählen';

  @override
  String get noPhotosHere => 'Hier sind keine Fotos';

  @override
  String get photosYouTakeOr =>
      'Fotos, die du aufnimmst oder speicherst, erscheinen in diesem Album.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count Fotos';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Foto vom $formatShortDate';
  }

  @override
  String get allPhotos => 'Alle Fotos';

  @override
  String get slideshow => 'Diashow';

  @override
  String get interval => 'Intervall';

  @override
  String get transition => 'Übergang';

  @override
  String get fade => 'Überblenden';

  @override
  String get slide => 'Schieben';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Diashow starten';

  @override
  String get castVideos => 'Videos streamen';

  @override
  String get noVideosYet => 'Noch keine Videos';

  @override
  String get videosYouRecordOr =>
      'Videos, die du aufnimmst oder herunterlädst, erscheinen hier, bereit zum Streamen.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Streamen';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Bildschirmspiegelungs-Sitzung';

  @override
  String get mirroringDidntStartTap =>
      'Die Spiegelung wurde nicht gestartet. Tippe erneut auf Start und wähle deinen Fernseher in der Liste.';

  @override
  String get openSmartViewOr =>
      'Öffne Smart View oder Cast in den Schnelleinstellungen deines Handys, um zu spiegeln.';

  @override
  String get quality => 'Qualität';

  @override
  String get adjustsToYourWi =>
      'Passt sich deinem WLAN für ein möglichst flüssiges Bild an.';

  @override
  String upToLowerIt(Object label) {
    return 'Bis $label. Verringere sie, wenn das Bild ruckelt.';
  }

  @override
  String get stillNeedHelp => 'Brauchst du Hilfe?';

  @override
  String get startingScreenMirroring => 'Bildschirmspiegelung wird gestartet…';

  @override
  String mirroringTo(Object value) {
    return 'Spiegelt auf $value';
  }

  @override
  String get stopping => 'Wird beendet…';

  @override
  String get readyToMirror => 'Bereit zum Spiegeln';

  @override
  String get beforeYouStart => 'Bevor du startest';

  @override
  String get phoneAndTvAre => 'Handy und Fernseher sind im selben WLAN';

  @override
  String get noVpnIsConnected => 'Auf deinem Handy ist kein VPN verbunden';

  @override
  String get tvIsOnWith => 'Fernseher ist an, Bildschirmspiegelung aktiviert';

  @override
  String get phoneIsCloseTo => 'Das Handy ist nah am Fernseher';

  @override
  String get stopMirroring => 'Spiegelung beenden';

  @override
  String get startMirroring2 => 'Spiegelung starten';

  @override
  String get stop => 'Stopp';

  @override
  String get start => 'Start';

  @override
  String get duration => 'Dauer';

  @override
  String get adIsLoading => 'Anzeige wird geladen';

  @override
  String get ad => 'Anzeige';

  @override
  String get mirrorYourScreenTo =>
      'Spiegle deinen Bildschirm auf jeden Fernseher';

  @override
  String get showYourPhoneOnThe =>
      'Zeige dein Handy mit einem Tipp auf dem großen Bildschirm – ohne Kabel, ohne Aufwand.';

  @override
  String get shareMemoriesWithThe =>
      'Teile Erinnerungen mit dem ganzen Raum und behalte die Kontrolle über dein Handy.';

  @override
  String get castFromWebApps => 'Aus dem Web und Apps streamen';

  @override
  String get sendVideosFromYoutube =>
      'Sende Videos von YouTube, Facebook und jeder Website direkt an deinen Fernseher.';

  @override
  String pageOf(Object value, Object length) {
    return 'Seite $value von $length';
  }

  @override
  String get getStarted => 'Los geht’s';

  @override
  String get localNetwork => 'Lokales Netzwerk';

  @override
  String get findTvsAndStreaming =>
      'Finde Fernseher und Streaming-Geräte in deinem WLAN.';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get showCastingControlsWhile =>
      'Zeige Streaming-Steuerelemente, während du andere Apps nutzt.';

  @override
  String get photosVideosMusic => 'Fotos, Videos und Musik';

  @override
  String get pickWhatYouWantTo =>
      'Wähle aus Galerie und Bibliothek, was du streamen möchtest.';

  @override
  String get screenCapture => 'Bildschirmaufnahme';

  @override
  String get mirrorYourScreenYoull =>
      'Spiegle deinen Bildschirm. Du bestätigst jede Sitzung.';

  @override
  String get webVideo => 'Web-Video';

  @override
  String get link => 'Link';

  @override
  String get screenMirroring2 => 'Bildschirmspiegelung';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Streamt $title. Fernbedienung öffnen';
  }

  @override
  String castingTo2(Object value) {
    return 'Streamt auf $value';
  }

  @override
  String get nowCasting => 'Wird gerade gestreamt';

  @override
  String get nothingIsCasting => 'Es wird nichts gestreamt';

  @override
  String get pickAPhotoVideo =>
      'Wähle ein Foto, Video, Lied oder Web-Video, um es an deinen Fernseher zu senden.';

  @override
  String get backToHome => 'Zurück zum Start';

  @override
  String slide2(Object formatDuration) {
    return 'Folie $formatDuration';
  }

  @override
  String get back10Seconds => '10 Sekunden zurück';

  @override
  String get forward10Seconds => '10 Sekunden vor';

  @override
  String get tvVolume => 'TV-Lautstärke';

  @override
  String tvVolumePercent(Object round) {
    return 'TV-Lautstärke $round Prozent';
  }

  @override
  String get upNext => 'Als Nächstes';

  @override
  String get addPhotos => 'Fotos hinzufügen';

  @override
  String get addVideos => 'Videos hinzufügen';

  @override
  String get nothingElseInThe => 'Nichts weiter in der Warteschlange.';

  @override
  String play2(Object title) {
    return '$title abspielen';
  }

  @override
  String get unknownDevice => 'Unbekanntes Gerät';

  @override
  String get perWeek => 'pro Woche';

  @override
  String get perYear => 'pro Jahr';

  @override
  String get payOnce => 'einmalig zahlen';

  @override
  String get wirelessScreenMirroring => 'Kabellose Bildschirmspiegelung';

  @override
  String get castVideosPhotosMusic => 'Videos, Fotos und Musik streamen';

  @override
  String get fullTvRemoteControl => 'Vollständige TV-Fernbedienung';

  @override
  String get worksWithAllMajor => 'Funktioniert mit allen gängigen Fernsehern';

  @override
  String get smoothLagFreeStreaming => 'Flüssiges, ruckelfreies Streaming';

  @override
  String get noAds => 'Keine Werbung';

  @override
  String get welcomeToCastflowPro => 'Willkommen bei CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Kauf abgebrochen.';

  @override
  String get purchasePendingProUnlocks =>
      'Kauf ausstehend. Pro wird freigeschaltet, sobald der Store ihn bestätigt.';

  @override
  String get purchaseFailedPleaseTry =>
      'Kauf fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get theStoreIsntAvailable => 'Der Store ist gerade nicht verfügbar.';

  @override
  String get close => 'Schließen';

  @override
  String get goProWithCastflow => 'WERDE PRO MIT CASTFLOW';

  @override
  String get unlockEveryFeature => 'Alle Funktionen freischalten';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Verlängert sich automatisch bis zur Kündigung.';

  @override
  String get oneTimePurchaseNo => 'Einmalkauf. Kein Abo.';

  @override
  String get continueAction => 'Weiter';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get termsAndConditions => 'Nutzungsbedingungen';

  @override
  String get cancelAnytime => 'Jederzeit kündbar';

  @override
  String get loadingPrice => 'Preis wird geladen…';

  @override
  String get pricesUnavailableTapTo =>
      'Preise nicht verfügbar · Zum Wiederholen tippen';

  @override
  String get noPlansAvailableRight => 'Derzeit sind keine Tarife verfügbar.';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get yearly => 'Jährlich';

  @override
  String get lifetime => 'Lebenslang';

  @override
  String get bestValue => 'Bester Wert';

  @override
  String get disconnectFromTv => 'Vom Fernseher trennen?';

  @override
  String get thisStopsWhatIs =>
      'Dadurch wird beendet, was gerade abgespielt oder gespiegelt wird.';

  @override
  String get useTouchpad => 'Touchpad verwenden';

  @override
  String get useDPad => 'Steuerkreuz verwenden';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label-Empfänger akzeptieren keine Fernbedienungsbefehle.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Einige Tasten sind auf $label nicht verfügbar.';
  }

  @override
  String get idle => 'LEERLAUF';

  @override
  String get playing => 'WIEDERGABE';

  @override
  String get paused => 'PAUSIERT';

  @override
  String get noTvConnected => 'Kein Fernseher verbunden';

  @override
  String get mute2 => 'STUMM';

  @override
  String vol(Object volume) {
    return 'LAUT $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Kein Fernseher verbunden. Tippen, um ein Gerät zu wählen';

  @override
  String get tapToChooseA => 'Tippen, um ein Gerät zu wählen';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label wird von $label2 nicht unterstützt';
  }

  @override
  String get touchpadSwipeToMove =>
      'Touchpad. Wischen zum Bewegen, tippen zum Auswählen.';

  @override
  String get swipeToMoveTap => 'Wischen zum Bewegen · Tippen zum Auswählen';

  @override
  String get navigationIsntSupportedBy =>
      'Navigation wird von diesem Fernseher nicht unterstützt';

  @override
  String get vol2 => 'LAUT';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automatisch';

  @override
  String get googleCastFirst => 'Google Cast zuerst';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP zuerst';

  @override
  String get miracastFirst => 'Miracast zuerst';

  @override
  String get tvOnly => 'Nur TV';

  @override
  String get phoneAndTv => 'Handy und TV';

  @override
  String get phoneOnly => 'Nur Handy';

  @override
  String get touchpad => 'Touchpad';

  @override
  String get doMyPhoneAnd => 'Müssen Handy und Fernseher im selben WLAN sein?';

  @override
  String get yesDiscoveryAndCasting =>
      'Ja. Suche und Streaming bleiben in deinem lokalen Netzwerk, daher müssen beide im selben WLAN sein (ähnliche Bandnamen können unterschiedliche Netzwerke sein).';

  @override
  String get myRouterHasAp => 'Mein Router hat „AP-/Client-Isolation“';

  @override
  String get isolationBlocksDevicesFrom =>
      'Die Isolation verhindert, dass Geräte sich sehen. Schalte sie in den Router-Einstellungen aus oder nutze ein Nicht-Gastnetzwerk.';

  @override
  String get findingYourTv => 'Deinen Fernseher finden';

  @override
  String get myTvDoesntAppear => 'Mein Fernseher erscheint nicht in der Liste';

  @override
  String get turnOnCastingScreen =>
      'Aktiviere Streaming / Bildschirmspiegelung am Fernseher, wecke ihn aus dem Standby und tippe auf Erneut suchen. Erlaube die Berechtigung für das lokale Netzwerk, falls gefragt.';

  @override
  String get onlySomeDevicesShow => 'Nur einige Geräte werden angezeigt';

  @override
  String get olderTvsMayNeed =>
      'Ältere Fernseher brauchen eventuell ein Firmware-Update. Miracast-Fernseher erscheinen nur, solange ihr Eingang „Bildschirmspiegelung“ geöffnet ist.';

  @override
  String get connectionFailsOrTimes => 'Verbindung schlägt fehl oder läuft ab';

  @override
  String get restartTheTvApp =>
      'Starte die TV-App oder den Fernseher neu, geh näher an den Router und bestätige jede Anfrage auf dem Fernsehbildschirm.';

  @override
  String get itKeepsReconnectingTo =>
      'Er verbindet sich immer wieder mit einem alten Fernseher';

  @override
  String get turnOffAutoConnect =>
      'Schalte „Automatisch mit letztem TV verbinden“ unter Einstellungen → Streaming aus.';

  @override
  String get mirroringIsLaggy => 'Die Spiegelung ruckelt';

  @override
  String get chooseALowerQuality =>
      'Wähle eine niedrigere Qualität (720p oder 480p), schließe aufwendige Apps und nutze ein 5-GHz-WLAN.';

  @override
  String get thePictureIsRotated => 'Das Bild ist gedreht oder beschnitten';

  @override
  String get toggleAutoRotateOn =>
      'Schalte Automatisch drehen auf dem Bildschirm Bildschirmspiegelung um.';

  @override
  String get sound => 'Ton';

  @override
  String get thereIsNoSound => 'Am Fernseher ist kein Ton';

  @override
  String get makeSureAudioIs =>
      'Prüfe, ob Audio in der Bildschirmspiegelung aktiviert ist, und kontrolliere Einstellungen → Streaming → Audioausgabe. Manche Empfänger unterstützen keinen Handy-Ton.';

  @override
  String get tvRemote2 => 'TV-Fernbedienung';

  @override
  String get someRemoteButtonsAre =>
      'Einige Fernbedienungstasten sind ausgegraut';

  @override
  String get eachReceiverSupportsDifferent =>
      'Jeder Empfänger unterstützt andere Befehle. Chromecast und DLNA unterstützen nur Wiedergabe und Lautstärke; Miracast hat keinen Fernbedienungskanal.';

  @override
  String get canCastflowTurnMy =>
      'Kann CastFlow meinen Fernseher einschalten oder den Eingang wechseln?';

  @override
  String get onlyOnTvsThat =>
      'Nur bei Fernsehern, die diese Befehle über das Netzwerk anbieten. Nicht unterstützte Tasten sind deaktiviert, statt Funktion vorzutäuschen.';

  @override
  String get helpFaq => 'Hilfe und FAQ';

  @override
  String get stepByStepConnection => 'Schritt-für-Schritt-Verbindungsanleitung';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Keine E-Mail-App gefunden.';

  @override
  String get enjoyingCastflow => 'Gefällt dir CastFlow?';

  @override
  String get sorryToHearThat => 'Das tut uns leid';

  @override
  String get thanksHowCanWe => 'Danke! Wie können wir uns verbessern?';

  @override
  String get wereGladYouLike => 'Schön, dass es dir gefällt!';

  @override
  String get youMadeOurDay => 'Du hast uns den Tag versüßt!';

  @override
  String get tapToExit => 'Zum Beenden tippen';

  @override
  String get selectARating => 'Bewertung auswählen';

  @override
  String get sendFeedback => 'Feedback senden';

  @override
  String get rateUs => 'Bewerte uns';

  @override
  String get rateYourExperienceBefore =>
      'Bewerte deine Erfahrung, bevor du gehst.';

  @override
  String get tapAStarTo => 'Tippe auf einen Stern, um CastFlow zu bewerten.';

  @override
  String get general => 'Allgemein';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Standardqualität';

  @override
  String get autoConnectToLast => 'Automatisch mit letztem TV verbinden';

  @override
  String get hapticFeedback => 'Haptisches Feedback';

  @override
  String get clearCastingHistory => 'Streaming-Verlauf löschen';

  @override
  String get clearCastingHistory2 => 'Streaming-Verlauf löschen?';

  @override
  String get onlyCastflowsListIs =>
      'Nur die Liste von CastFlow wird gelöscht. Medien auf deinem Handy werden nie gelöscht.';

  @override
  String get appearance => 'Darstellung';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get aboutSupport => 'Über uns und Support';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get feedback => 'Feedback';

  @override
  String get termsConditions => 'Nutzungsbedingungen';

  @override
  String get version => 'Version';

  @override
  String get castflowProIsActive => 'CastFlow Pro ist aktiv';

  @override
  String get upgradeToPremium => 'Auf Premium upgraden';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Danke für deine Unterstützung. Genieße werbefreies Streaming.';

  @override
  String get noAds1080pMirroring =>
      'Keine Werbung, 1080p-Spiegelung und unbegrenztes Streaming';

  @override
  String get upgrade => 'Upgraden';

  @override
  String get mirrorCastBeautifullySimple =>
      'Spiegeln und streamen, ganz einfach';

  @override
  String get thisActionMayContain => 'Diese Aktion kann Werbung enthalten';

  @override
  String get webCast => 'Web-Streaming';

  @override
  String get castThisVideo => 'Dieses Video streamen';

  @override
  String get searchOrTypeAWeb => 'Suchen oder Webadresse eingeben';

  @override
  String get removeBookmark => 'Lesezeichen entfernen';

  @override
  String get bookmark => 'Lesezeichen';

  @override
  String get quickAccess => 'Schnellzugriff';

  @override
  String open2(Object title) {
    return '$title öffnen';
  }

  @override
  String get bookmarks => 'Lesezeichen';

  @override
  String get noBookmarks => 'Keine Lesezeichen';

  @override
  String get tapTheBookmarkIcon =>
      'Tippe in der Adressleiste auf das Lesezeichen-Symbol, um eine Seite zu speichern.';

  @override
  String get noHistory => 'Kein Verlauf';

  @override
  String get pagesYouVisitShow => 'Seiten, die du besuchst, erscheinen hier.';

  @override
  String get remove => 'Entfernen';

  @override
  String resultOn(Object value, Object host) {
    return 'Ergebnis $value auf $host';
  }

  @override
  String get aSimulatedPageResult => 'Ein simuliertes Seitenergebnis';

  @override
  String get videosOnThisPage => 'Videos auf dieser Seite';

  @override
  String get pickOneToSend =>
      'Wähle eines, um es an deinen Fernseher zu senden.';

  @override
  String get onboardHotspotTitle => 'Kein WLAN? Nutze deinen Hotspot';

  @override
  String get onboardHotspotBody =>
      'Schalte den Hotspot deines Handys ein und verbinde den Fernseher damit. Streamen funktioniert wie im WLAN.';

  @override
  String get stillCantFindTitle => 'Fernseher immer noch nicht gefunden?';

  @override
  String get stillCantFindBody =>
      'Verbinde den Fernseher mit dem Hotspot deines Handys:';

  @override
  String get hotspotStep4 =>
      'Tippe auf Erneut versuchen und wähle deinen Fernseher';

  @override
  String get castOverHotspot =>
      'Kein WLAN? Über den Hotspot deines Handys streamen:';

  @override
  String get queue => 'Warteschlange';

  @override
  String get addMusic => 'Musik hinzufügen';

  @override
  String get connectWithWifi => 'Mit WLAN verbinden';

  @override
  String get continueWithHotspot => 'Mit Hotspot fortfahren';

  @override
  String get noWifiAlertMessage =>
      'Du nutzt mobile Daten. Verbinde Handy und Fernseher mit demselben WLAN oder aktiviere den Hotspot deines Handys und verbinde den Fernseher damit.';
}
