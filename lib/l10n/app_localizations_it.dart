// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get networkRequiredTitle => 'Non connesso al Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Telefono e TV devono essere sulla stessa rete Wi-Fi per trasmettere.';

  @override
  String get openWifiSettings => 'Apri impostazioni Wi-Fi';

  @override
  String get useMobileHotspot => 'Usa hotspot mobile';

  @override
  String get hotspotInstruction =>
      'Collega la TV all\'hotspot mobile del telefono.';

  @override
  String get hotspotStep1 => 'Attiva l\'hotspot mobile';

  @override
  String get hotspotStep2 => 'Collega la TV all\'hotspot';

  @override
  String get hotspotStep3 => 'Torna all\'app';

  @override
  String get openHotspotSettings => 'Apri impostazioni hotspot';

  @override
  String get hotspotAutoCheck =>
      'Controlleremo di nuovo automaticamente quando torni.';

  @override
  String get hotspotDetected => 'L\'hotspot è attivo. Cerco la tua TV…';

  @override
  String get searchingDevices => 'Ricerca dei dispositivi vicini...';

  @override
  String get waitingForTvOnHotspot =>
      'In attesa che la TV si unisca all\'hotspot…';

  @override
  String get usingHotspot => 'Uso dell\'hotspot mobile';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dispositivi trovati',
      one: '1 dispositivo trovato',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Riprova';

  @override
  String get scanAgain => 'Cerca di nuovo';

  @override
  String get isolationTitle => 'La TV non risponde';

  @override
  String get isolationHint =>
      'Un dispositivo si è unito al tuo hotspot ma non risponde. L\'hotspot potrebbe bloccare il traffico tra dispositivi (isolamento client). Disattivalo nelle impostazioni dell\'hotspot o usa una rete Wi-Fi.';

  @override
  String get connecting => 'Connessione…';

  @override
  String get connected => 'Connesso';

  @override
  String get connectionFailed => 'Impossibile connettersi';

  @override
  String get connectFailedHint =>
      'Assicurati che telefono e TV siano sulla stessa rete, poi riprova.';

  @override
  String get hotspotConnectHint =>
      'Il tuo hotspot potrebbe bloccare il traffico tra dispositivi. Controlla l\'impostazione di isolamento client.';

  @override
  String get networkLostTitle => 'Connessione di rete persa';

  @override
  String get networkLostMessage =>
      'Riconnettiti al Wi-Fi o all\'hotspot, poi ricollega la TV.';

  @override
  String get reconnect => 'Riconnetti';

  @override
  String reconnectTo(String name) {
    return 'Riconnetti a $name';
  }

  @override
  String get tapToReconnect => 'Tocca per riconnettere';

  @override
  String get pairingRequired => 'Associazione richiesta';

  @override
  String get pairingEnterCode => 'Inserisci il codice mostrato sulla TV.';

  @override
  String get pairingApproveOnTv =>
      'Guarda la TV e tocca Consenti per continuare.';

  @override
  String get connect => 'Connetti';

  @override
  String get cancel => 'Annulla';

  @override
  String get pairingIncorrectCode => 'Codice errato. Riprova.';

  @override
  String get pairingTimedOut => 'Associazione scaduta';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get pairingDeclined => 'La TV ha rifiutato la connessione';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Troppi codici errati. Attendi $seconds s, poi richiedi un nuovo codice.';
  }

  @override
  String get pairingCooldownOver => 'Ora puoi richiedere un nuovo codice.';

  @override
  String get pairingRequestNewCode => 'Richiedi nuovo codice';

  @override
  String get pairingNetworkLost =>
      'La rete è andata persa durante l\'associazione. Riconnettiti al Wi-Fi e riprova.';

  @override
  String get pairingFailed => 'Impossibile associare la TV.';

  @override
  String pairingCodeField(int length) {
    return 'Codice di associazione, $length caratteri';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Casella $index di $total';
  }

  @override
  String get pairingEmptyBox => 'vuota';

  @override
  String get pairingPaired => 'Associato';

  @override
  String get forgetDevice => 'Dimentica dispositivo';

  @override
  String forgetDeviceMessage(String name) {
    return '$name dovrà essere associato di nuovo la prossima volta.';
  }

  @override
  String get forget => 'Dimentica';

  @override
  String get castVideo => 'Trasmetti video';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video trovati. Trasmetti video',
      one: '1 video trovato. Trasmetti video',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Nessun video trovato in questa pagina per ora.';

  @override
  String get videoFound => 'Video trovato';

  @override
  String get videoFoundMessage => 'Riproducilo sulla TV.';

  @override
  String get castAction => 'Trasmetti';

  @override
  String get dismiss => 'Chiudi';

  @override
  String videosFound(int count) {
    return 'Video trovati ($count)';
  }

  @override
  String get castToTv => 'Trasmetti alla TV';

  @override
  String get protectedVideo => 'Protetto, impossibile trasmettere';

  @override
  String get videoThumbnail => 'Miniatura del video';

  @override
  String castingTo(String device) {
    return 'Trasmissione su $device';
  }

  @override
  String get stopCasting => 'Interrompi trasmissione';

  @override
  String get play => 'Riproduci';

  @override
  String get pause => 'Pausa';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Posizione di riproduzione';

  @override
  String get showControls => 'Mostra controlli';

  @override
  String get hideControls => 'Nascondi controlli';

  @override
  String get formatUnsupportedTitle => 'Formato non supportato';

  @override
  String formatUnsupported(String device, String format) {
    return '$device non può riprodurre video $format. Prova un altro video di questa pagina o usa la duplicazione dello schermo.';
  }

  @override
  String get videoExpired =>
      'Il link del video è scaduto. Ricarica la pagina e riprova.';

  @override
  String get refreshingVideo => 'Recupero di un nuovo link video…';

  @override
  String get browserBack => 'Indietro';

  @override
  String get browserForward => 'Avanti';

  @override
  String get browserStartPage => 'Pagina iniziale';

  @override
  String get browserReload => 'Ricarica';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Home';

  @override
  String get devices => 'Dispositivi';

  @override
  String get history => 'Cronologia';

  @override
  String get settings => 'Impostazioni';

  @override
  String get goodMorning => 'Buongiorno';

  @override
  String get goodAfternoon => 'Buon pomeriggio';

  @override
  String get goodEvening => 'Buonasera';

  @override
  String get couldntOpenTheLink => 'Impossibile aprire il link.';

  @override
  String get castflowLogo => 'Logo CastFlow';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get weCouldntLoadThis => 'Impossibile caricare ora. Riprova.';

  @override
  String get apps => 'App';

  @override
  String open(Object name) {
    return 'Apri $name';
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
  String get up => 'Su';

  @override
  String get down => 'Giù';

  @override
  String get left => 'Sinistra';

  @override
  String get right => 'Destra';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Ingresso';

  @override
  String get playPause => 'Riproduci / Pausa';

  @override
  String get previous => 'Precedente';

  @override
  String get next => 'Successivo';

  @override
  String get rewind => 'Riavvolgi';

  @override
  String get volumeUp => 'Alza volume';

  @override
  String get volumeDown => 'Abbassa volume';

  @override
  String get mute => 'Muto';

  @override
  String connectedTo(Object name) {
    return 'Connesso a $name';
  }

  @override
  String get chooseADevice => 'Scegli un dispositivo';

  @override
  String get connectionGuide => 'Guida alla connessione';

  @override
  String get lookingForTvsOn => 'Ricerca di TV sul tuo Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return '$found trovati finora';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found dispositivi trovati';
  }

  @override
  String get disconnect => 'Disconnetti';

  @override
  String signalOf4(Object level) {
    return 'Segnale $level su 4';
  }

  @override
  String get connecting2 => 'Connessione';

  @override
  String get theTvRemoteNeeds =>
      'Il telecomando richiede una TV connessa. Scegline una qui sotto.';

  @override
  String get connectToATv => 'Connettiti a una TV per continuare.';

  @override
  String get findingTvs => 'Ricerca di TV…';

  @override
  String get makeSureYourTv => 'Assicurati che la TV sia accesa';

  @override
  String get notConnected => 'Non connesso';

  @override
  String get tapToFindYour => 'Tocca per trovare la TV';

  @override
  String get connectionFailed2 => 'Connessione non riuscita';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Tocca per gestire i dispositivi';
  }

  @override
  String get joinTheSameWi => 'Unisciti allo stesso Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Collega telefono e TV alla stessa rete Wi-Fi.';

  @override
  String get turnOnCastingOn => 'Attiva la trasmissione sulla TV';

  @override
  String get enableScreenMirroringMiracast =>
      'Attiva Duplica schermo, Miracast o Google Cast nelle impostazioni della TV.';

  @override
  String get scanForDevices => 'Cerca dispositivi';

  @override
  String get openDevicesInCastflow =>
      'Apri Dispositivi in CastFlow e attendi qualche secondo che la TV compaia.';

  @override
  String get tapConnect => 'Tocca Connetti';

  @override
  String get acceptThePromptOn =>
      'Accetta la richiesta sulla TV se compare. Fatto!';

  @override
  String get howToConnect => 'Come connettersi';

  @override
  String get fourQuickStepsTo =>
      'Quattro passaggi rapidi per passare al grande schermo.';

  @override
  String get gotIt => 'Ho capito';

  @override
  String step(Object number, Object title, Object body) {
    return 'Passaggio $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi di casa';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Impostazioni › Connessione';

  @override
  String get inputHdmi1 => 'Ingresso: HDMI 1';

  @override
  String get screenMirroring => 'Duplica schermo';

  @override
  String get networkHomeWiFi => 'Rete: Wi-Fi di casa';

  @override
  String get livingRoomTv => 'TV del soggiorno';

  @override
  String get allowCastflowToConnect => 'Consentire a CastFlow di connettersi?';

  @override
  String get deny => 'Rifiuta';

  @override
  String get allow => 'Consenti';

  @override
  String get yourTv => 'La tua TV';

  @override
  String get findYourTv => 'Trova la tua TV';

  @override
  String connectTo(Object name) {
    return 'Connetti a $name';
  }

  @override
  String connected2(Object label) {
    return 'Connesso · $label';
  }

  @override
  String get openTvRemote => 'Apri telecomando TV';

  @override
  String get sameWiFiNetwork => 'Stessa rete Wi-Fi';

  @override
  String get yourPhoneAndTv =>
      'Telefono e TV devono essere connessi allo stesso Wi-Fi.';

  @override
  String get tvIsOnAnd => 'La TV è accesa e pronta';

  @override
  String get turnOnScreenMirroring =>
      'Attiva Duplica schermo, Cast o Miracast sulla TV.';

  @override
  String get noVpnOrGuest => 'Niente VPN o rete ospiti';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN e Wi-Fi ospiti o isolati nascondono i dispositivi tra loro.';

  @override
  String get localNetworkAccess => 'Accesso alla rete locale';

  @override
  String get allowCastflowToFind =>
      'Consenti a CastFlow di trovare dispositivi sulla tua rete quando richiesto.';

  @override
  String get noTvFound => 'Nessuna TV trovata';

  @override
  String get checkThatYourPhone =>
      'Verifica che telefono e TV siano sullo stesso Wi-Fi, poi cerca di nuovo.';

  @override
  String get noWiFiRouter => 'Niente router Wi-Fi? Usa l\'hotspot';

  @override
  String searchingForTvsFound(Object length) {
    return 'Ricerca di TV. $length trovate.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TV trovate';
  }

  @override
  String get connectToYourTv => 'Connettiti alla tua TV';

  @override
  String get connectYourPhoneAndTv =>
      'Collega telefono e TV alla stessa rete Wi-Fi.';

  @override
  String get turnOnTheTv =>
      'Accendi la TV e apri l\'ingresso Duplica schermo / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Tocca la barra di connessione nella Home per trovare la TV.';

  @override
  String get tapConnectAndAccept =>
      'Tocca Connetti e accetta la richiesta sulla TV se compare.';

  @override
  String get mirrorYourScreen => 'Duplica lo schermo';

  @override
  String get connectToYourTvFirst => 'Connettiti prima alla TV.';

  @override
  String get openScreenMirroringFrom => 'Apri Duplica schermo dalla Home.';

  @override
  String get pickAQualityAnd => 'Scegli una qualità e tocca Avvia.';

  @override
  String get allowScreenCaptureWhen =>
      'Consenti l\'acquisizione dello schermo quando Android lo chiede.';

  @override
  String get castPhotosVideosMusic => 'Trasmetti foto, video e musica';

  @override
  String get openPhotosVideosOr => 'Apri Foto, Video o Musica nella Home.';

  @override
  String get pickWhatYouWant => 'Scegli cosa vuoi mostrare.';

  @override
  String get itPlaysOnThe =>
      'Viene riprodotto sulla TV; controllalo dal telefono o dalla notifica.';

  @override
  String get useTheTvRemote => 'Usa il telecomando della TV';

  @override
  String get openTvRemoteOn => 'Apri Telecomando TV nella Home.';

  @override
  String get useTheDPad =>
      'Usa il D-pad o scorri sul touchpad per muoverti, tocca OK per selezionare.';

  @override
  String get buttonsATvDoesnt =>
      'I pulsanti che la TV non supporta sono disattivati.';

  @override
  String get castFromTheWeb => 'Trasmetti da web e app';

  @override
  String get tapTheBrowserBar =>
      'Tocca la barra del browser o un\'app nella Home.';

  @override
  String get playAVideoOn => 'Riproduci un video sul sito.';

  @override
  String get tapCastThisVideo =>
      'Tocca “Trasmetti questo video” per inviarlo alla TV.';

  @override
  String get screenMirroringHelp => 'Guida alla duplicazione dello schermo';

  @override
  String get connectYourPhoneTo => 'Connetti il telefono al Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Sulla TV apri Impostazioni → Rete e unisciti allo stesso Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Le reti ospiti o aziendali spesso bloccano la duplicazione; usa il Wi-Fi di casa o l\'hotspot del telefono.';

  @override
  String get turnOffVpn => 'Disattiva la VPN';

  @override
  String get aVpnHidesYour => 'Una VPN nasconde la TV al telefono.';

  @override
  String get pauseOrDisconnectYour =>
      'Metti in pausa o disconnetti l\'app VPN prima di iniziare.';

  @override
  String get youCanTurnIt => 'Potrai riattivarla alla fine.';

  @override
  String get turnOnMirroringOn => 'Attiva la duplicazione sulla TV';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG e la maggior parte delle TV Android accettano la duplicazione automaticamente.';

  @override
  String get otherTvsOpenInput =>
      'Altre TV: apri Ingresso / Sorgente e scegli Duplica schermo o Miracast.';

  @override
  String get keepTheTvOn =>
      'Lascia la TV su quella schermata mentre il telefono si connette.';

  @override
  String get tapStartAndPick => 'Tocca Avvia e scegli la TV';

  @override
  String get tapStartOnThe => 'Tocca Avvia nella schermata Duplica schermo.';

  @override
  String get androidOpensSmartView =>
      'Android apre Smart View / Cast. Tocca la TV nell\'elenco.';

  @override
  String get ifTheTvAsks =>
      'Se la TV lo chiede, scegli Consenti o inserisci il PIN mostrato a schermo.';

  @override
  String get youreMirroring => 'Stai duplicando lo schermo';

  @override
  String get everythingOnYourPhone =>
      'Tutto ciò che c\'è sul telefono ora appare sulla TV.';

  @override
  String get turnThePhoneSideways =>
      'Ruota il telefono per video e giochi a schermo intero.';

  @override
  String get toStopTapStop =>
      'Per interrompere, tocca Interrompi o usa la notifica di trasmissione.';

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
  String get bedroomTv => 'TV della camera';

  @override
  String get officeDisplay => 'Display dell\'ufficio';

  @override
  String get clearHistory => 'Cancellare la cronologia?';

  @override
  String get thisRemovesEverythingYouve =>
      'Questo rimuove da questo elenco tutto ciò che hai trasmesso.';

  @override
  String get clear => 'Cancella';

  @override
  String get clearHistory2 => 'Cancella cronologia';

  @override
  String get noHistoryYet => 'Ancora nessuna cronologia';

  @override
  String get everythingYouCastWill =>
      'Tutto ciò che trasmetti sarà elencato qui per ritrovarlo facilmente.';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get earlier => 'Prima';

  @override
  String get swipeAnItemTo => 'Scorri un elemento per rimuoverlo';

  @override
  String get delete => 'Elimina';

  @override
  String removed(Object title) {
    return '«$title» rimosso';
  }

  @override
  String get undo => 'Annulla';

  @override
  String get photos => 'Foto';

  @override
  String get albums => 'Album';

  @override
  String get videos => 'Video';

  @override
  String get gallery => 'Galleria';

  @override
  String get music => 'Musica';

  @override
  String get songs => 'Brani';

  @override
  String get media => 'Media';

  @override
  String get browseTheWeb => 'Naviga sul web';

  @override
  String get goPro => 'Passa a Pro';

  @override
  String cast(Object title) {
    return 'Trasmetti $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Duplica schermo. Avvia duplicazione';

  @override
  String readyToMirrorTo(Object device) {
    return 'Pronto a duplicare su $device';
  }

  @override
  String get showYourPhoneOn => 'Mostra il telefono sulla TV in tempo reale.';

  @override
  String get startMirroring => 'Avvia duplicazione';

  @override
  String get tvRemote => 'Telecomando TV';

  @override
  String get controlYourTv => 'Controlla la TV';

  @override
  String get youtubeMore => 'YouTube e altro';

  @override
  String get openTheBrowser => 'Apri il browser';

  @override
  String get searchOrTypeA => 'Cerca o digita un sito web';

  @override
  String get howToConnectOpen => 'Come connettersi. Apri la guida visiva';

  @override
  String get visualGuideForEvery => 'Guida visiva per ogni funzione';

  @override
  String get language => 'Lingua';

  @override
  String get done => 'Fine';

  @override
  String get enterAValidHttp =>
      'Inserisci un link http(s) o rtsp valido, ad es. un URL .m3u8 o .mp4.';

  @override
  String get linkStream => 'Stream da link';

  @override
  String get iptvLinkCast => 'IPTV / Trasmetti link';

  @override
  String get castALink => 'Trasmetti un link';

  @override
  String get pasteADirectVideo =>
      'Incolla l\'URL di un video diretto, M3U8 o stream IPTV.';

  @override
  String get paste => 'Incolla';

  @override
  String get castLink => 'Trasmetti link';

  @override
  String get allowAccessToYour =>
      'Consenti l\'accesso ai tuoi contenuti per trasmetterli. Puoi cambiarlo in Impostazioni.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Trasmetti musica';

  @override
  String get noMusicFound => 'Nessuna musica trovata';

  @override
  String get addSongsToYour => 'Aggiungi brani al telefono e compariranno qui.';

  @override
  String get shuffle => 'Casuale';

  @override
  String get playAll => 'Riproduci tutto';

  @override
  String photo(Object formatShortDate) {
    return 'Foto · $formatShortDate';
  }

  @override
  String get photo2 => 'Foto';

  @override
  String get castPhotos => 'Trasmetti foto';

  @override
  String get select => 'Seleziona';

  @override
  String get noPhotosHere => 'Nessuna foto qui';

  @override
  String get photosYouTakeOr =>
      'Le foto che scatti o salvi compariranno in questo album.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count foto';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Foto del $formatShortDate';
  }

  @override
  String get allPhotos => 'Tutte le foto';

  @override
  String get slideshow => 'Presentazione';

  @override
  String get interval => 'Intervallo';

  @override
  String get transition => 'Transizione';

  @override
  String get fade => 'Dissolvenza';

  @override
  String get slide => 'Scorrimento';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Avvia presentazione';

  @override
  String get castVideos => 'Trasmetti video';

  @override
  String get noVideosYet => 'Ancora nessun video';

  @override
  String get videosYouRecordOr =>
      'I video che registri o scarichi compariranno qui, pronti da trasmettere.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Trasmetti';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Sessione di duplicazione dello schermo';

  @override
  String get mirroringDidntStartTap =>
      'La duplicazione non è partita. Tocca di nuovo Avvia e scegli la TV nell\'elenco.';

  @override
  String get openSmartViewOr =>
      'Apri Smart View o Cast dalle impostazioni rapide del telefono per duplicare.';

  @override
  String get quality => 'Qualità';

  @override
  String get adjustsToYourWi =>
      'Si adatta al tuo Wi-Fi per un\'immagine più fluida.';

  @override
  String upToLowerIt(Object label) {
    return 'Fino a $label. Abbassala se l\'immagine scatta.';
  }

  @override
  String get stillNeedHelp => 'Serve aiuto?';

  @override
  String get startingScreenMirroring =>
      'Avvio della duplicazione dello schermo…';

  @override
  String mirroringTo(Object value) {
    return 'Duplicazione su $value';
  }

  @override
  String get stopping => 'Interruzione…';

  @override
  String get readyToMirror => 'Pronto a duplicare';

  @override
  String get beforeYouStart => 'Prima di iniziare';

  @override
  String get phoneAndTvAre => 'Telefono e TV sono sullo stesso Wi-Fi';

  @override
  String get noVpnIsConnected => 'Nessuna VPN è connessa sul telefono';

  @override
  String get tvIsOnWith => 'La TV è accesa con Duplica schermo attivo';

  @override
  String get phoneIsCloseTo => 'Il telefono è vicino alla TV';

  @override
  String get stopMirroring => 'Interrompi duplicazione';

  @override
  String get startMirroring2 => 'Avvia duplicazione';

  @override
  String get stop => 'Interrompi';

  @override
  String get start => 'Avvia';

  @override
  String get duration => 'Durata';

  @override
  String get adIsLoading => 'Caricamento dell\'annuncio';

  @override
  String get ad => 'Annuncio';

  @override
  String get mirrorYourScreenTo => 'Duplica lo schermo su qualsiasi TV';

  @override
  String get showYourPhoneOnThe =>
      'Mostra il telefono sul grande schermo con un tocco: niente cavi, niente complicazioni.';

  @override
  String get shareMemoriesWithThe =>
      'Condividi i ricordi con tutta la stanza e tieni il controllo dal telefono.';

  @override
  String get castFromWebApps => 'Trasmetti da web e app';

  @override
  String get sendVideosFromYoutube =>
      'Invia video da YouTube, Facebook e qualsiasi sito direttamente alla TV.';

  @override
  String pageOf(Object value, Object length) {
    return 'Pagina $value di $length';
  }

  @override
  String get getStarted => 'Inizia';

  @override
  String get localNetwork => 'Rete locale';

  @override
  String get findTvsAndStreaming =>
      'Trova TV e dispositivi di streaming sul tuo Wi-Fi.';

  @override
  String get notifications => 'Notifiche';

  @override
  String get showCastingControlsWhile =>
      'Mostra i controlli di trasmissione mentre usi altre app.';

  @override
  String get photosVideosMusic => 'Foto, video e musica';

  @override
  String get pickWhatYouWantTo =>
      'Scegli cosa trasmettere dalla galleria e dalla libreria.';

  @override
  String get screenCapture => 'Acquisizione schermo';

  @override
  String get mirrorYourScreenYoull =>
      'Duplica lo schermo. Confermerai ogni sessione.';

  @override
  String get webVideo => 'Video web';

  @override
  String get link => 'Link';

  @override
  String get screenMirroring2 => 'Duplicazione dello schermo';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Trasmissione di $title. Apri telecomando';
  }

  @override
  String castingTo2(Object value) {
    return 'Trasmissione su $value';
  }

  @override
  String get nowCasting => 'In trasmissione ora';

  @override
  String get nothingIsCasting => 'Nessuna trasmissione in corso';

  @override
  String get pickAPhotoVideo =>
      'Scegli una foto, un video, un brano o un video web da inviare alla TV.';

  @override
  String get backToHome => 'Torna alla home';

  @override
  String slide2(Object formatDuration) {
    return 'Diapositiva $formatDuration';
  }

  @override
  String get back10Seconds => 'Indietro di 10 secondi';

  @override
  String get forward10Seconds => 'Avanti di 10 secondi';

  @override
  String get tvVolume => 'Volume TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Volume TV $round per cento';
  }

  @override
  String get upNext => 'Prossimo';

  @override
  String get addPhotos => 'Aggiungi foto';

  @override
  String get addVideos => 'Aggiungi video';

  @override
  String get nothingElseInThe => 'Nient\'altro in coda.';

  @override
  String play2(Object title) {
    return 'Riproduci $title';
  }

  @override
  String get unknownDevice => 'Dispositivo sconosciuto';

  @override
  String get perWeek => 'a settimana';

  @override
  String get perYear => 'all\'anno';

  @override
  String get payOnce => 'pagamento unico';

  @override
  String get wirelessScreenMirroring => 'Duplicazione dello schermo wireless';

  @override
  String get castVideosPhotosMusic => 'Trasmetti video, foto e musica';

  @override
  String get fullTvRemoteControl => 'Controllo completo della TV';

  @override
  String get worksWithAllMajor => 'Funziona con tutte le principali TV';

  @override
  String get smoothLagFreeStreaming => 'Streaming fluido, senza lag';

  @override
  String get noAds => 'Senza pubblicità';

  @override
  String get welcomeToCastflowPro => 'Benvenuto in CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Acquisto annullato.';

  @override
  String get purchasePendingProUnlocks =>
      'Acquisto in sospeso. Pro si sblocca appena lo store lo conferma.';

  @override
  String get purchaseFailedPleaseTry => 'Acquisto non riuscito. Riprova.';

  @override
  String get theStoreIsntAvailable => 'Lo store non è disponibile al momento.';

  @override
  String get close => 'Chiudi';

  @override
  String get goProWithCastflow => 'PASSA A PRO CON CASTFLOW';

  @override
  String get unlockEveryFeature => 'Sblocca ogni funzione';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Si rinnova automaticamente fino alla cancellazione.';

  @override
  String get oneTimePurchaseNo => 'Acquisto una tantum. Nessun abbonamento.';

  @override
  String get continueAction => 'Continua';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get termsAndConditions => 'Termini e condizioni';

  @override
  String get cancelAnytime => 'Annulla quando vuoi';

  @override
  String get loadingPrice => 'Caricamento del prezzo…';

  @override
  String get pricesUnavailableTapTo =>
      'Prezzi non disponibili · Tocca per riprovare';

  @override
  String get noPlansAvailableRight => 'Nessun piano disponibile al momento.';

  @override
  String get weekly => 'Settimanale';

  @override
  String get yearly => 'Annuale';

  @override
  String get lifetime => 'A vita';

  @override
  String get bestValue => 'Il migliore';

  @override
  String get disconnectFromTv => 'Disconnettere dalla TV?';

  @override
  String get thisStopsWhatIs =>
      'Questo interrompe ciò che è in riproduzione o in duplicazione.';

  @override
  String get useTouchpad => 'Usa touchpad';

  @override
  String get useDPad => 'Usa D-pad';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'I ricevitori $label non accettano comandi remoti.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Alcuni pulsanti non sono disponibili su $label.';
  }

  @override
  String get idle => 'INATTIVO';

  @override
  String get playing => 'IN RIPRODUZIONE';

  @override
  String get paused => 'IN PAUSA';

  @override
  String get noTvConnected => 'Nessuna TV connessa';

  @override
  String get mute2 => 'MUTO';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Nessuna TV connessa. Tocca per scegliere un dispositivo';

  @override
  String get tapToChooseA => 'Tocca per scegliere un dispositivo';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label non è supportato da $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Touchpad. Scorri per muoverti, tocca per selezionare.';

  @override
  String get swipeToMoveTap => 'Scorri per muoverti · Tocca per selezionare';

  @override
  String get navigationIsntSupportedBy =>
      'La navigazione non è supportata da questa TV';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automatico';

  @override
  String get googleCastFirst => 'Prima Google Cast';

  @override
  String get dlnaUpnpFirst => 'Prima DLNA / UPnP';

  @override
  String get miracastFirst => 'Prima Miracast';

  @override
  String get tvOnly => 'Solo TV';

  @override
  String get phoneAndTv => 'Telefono e TV';

  @override
  String get phoneOnly => 'Solo telefono';

  @override
  String get touchpad => 'Touchpad';

  @override
  String get doMyPhoneAnd => 'Telefono e TV devono essere sullo stesso Wi-Fi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Sì. Rilevamento e trasmissione restano sulla rete locale, quindi entrambi devono essere sullo stesso Wi-Fi (nomi di banda simili possono essere reti diverse).';

  @override
  String get myRouterHasAp => 'Il mio router ha l\'«isolamento AP / client»';

  @override
  String get isolationBlocksDevicesFrom =>
      'L\'isolamento impedisce ai dispositivi di vedersi. Disattivalo nelle impostazioni del router o usa una rete non ospite.';

  @override
  String get findingYourTv => 'Trovare la TV';

  @override
  String get myTvDoesntAppear => 'La mia TV non compare nell\'elenco';

  @override
  String get turnOnCastingScreen =>
      'Attiva trasmissione / duplicazione sulla TV, riattivala dallo standby e tocca Cerca di nuovo. Consenti l\'autorizzazione alla rete locale se richiesta.';

  @override
  String get onlySomeDevicesShow => 'Compaiono solo alcuni dispositivi';

  @override
  String get olderTvsMayNeed =>
      'Le TV più vecchie potrebbero richiedere un aggiornamento del firmware. Le TV Miracast compaiono solo con l\'ingresso «Duplica schermo» aperto.';

  @override
  String get connectionFailsOrTimes => 'La connessione non riesce o scade';

  @override
  String get restartTheTvApp =>
      'Riavvia l\'app della TV o la TV, avvicinati al router e accetta qualsiasi richiesta mostrata sullo schermo della TV.';

  @override
  String get itKeepsReconnectingTo =>
      'Continua a riconnettersi a una vecchia TV';

  @override
  String get turnOffAutoConnect =>
      'Disattiva «Connetti automaticamente all\'ultima TV» in Impostazioni → Trasmissione.';

  @override
  String get mirroringIsLaggy => 'La duplicazione è a scatti';

  @override
  String get chooseALowerQuality =>
      'Scegli una qualità inferiore (720p o 480p), chiudi le app pesanti e usa una rete Wi-Fi a 5 GHz.';

  @override
  String get thePictureIsRotated => 'L\'immagine è ruotata o tagliata';

  @override
  String get toggleAutoRotateOn =>
      'Attiva o disattiva Rotazione automatica nella schermata Duplica schermo.';

  @override
  String get sound => 'Audio';

  @override
  String get thereIsNoSound => 'Non c\'è audio sulla TV';

  @override
  String get makeSureAudioIs =>
      'Verifica che l\'audio sia attivo in Duplica schermo e controlla Impostazioni → Trasmissione → Uscita audio. Alcuni ricevitori non supportano l\'audio del telefono.';

  @override
  String get tvRemote2 => 'Telecomando TV';

  @override
  String get someRemoteButtonsAre =>
      'Alcuni pulsanti del telecomando sono disattivati';

  @override
  String get eachReceiverSupportsDifferent =>
      'Ogni ricevitore supporta comandi diversi. Chromecast e DLNA supportano solo riproduzione e volume; Miracast non ha canale telecomando.';

  @override
  String get canCastflowTurnMy =>
      'CastFlow può accendere la TV o cambiare ingresso?';

  @override
  String get onlyOnTvsThat =>
      'Solo su TV che espongono quei comandi in rete. I pulsanti non supportati sono disattivati invece di fingere di funzionare.';

  @override
  String get helpFaq => 'Aiuto e FAQ';

  @override
  String get stepByStepConnection => 'Guida alla connessione passo per passo';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Nessuna app di posta trovata.';

  @override
  String get enjoyingCastflow => 'Ti piace CastFlow?';

  @override
  String get sorryToHearThat => 'Ci dispiace';

  @override
  String get thanksHowCanWe => 'Grazie! Come possiamo migliorare?';

  @override
  String get wereGladYouLike => 'Siamo felici che ti piaccia!';

  @override
  String get youMadeOurDay => 'Hai reso speciale la nostra giornata!';

  @override
  String get tapToExit => 'Tocca per uscire';

  @override
  String get selectARating => 'Seleziona una valutazione';

  @override
  String get sendFeedback => 'Invia feedback';

  @override
  String get rateUs => 'Valutaci';

  @override
  String get rateYourExperienceBefore =>
      'Valuta la tua esperienza prima di andare.';

  @override
  String get tapAStarTo => 'Tocca una stella per valutare CastFlow.';

  @override
  String get general => 'Generali';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Qualità predefinita';

  @override
  String get autoConnectToLast => 'Connetti automaticamente all\'ultima TV';

  @override
  String get hapticFeedback => 'Feedback aptico';

  @override
  String get clearCastingHistory => 'Cancella cronologia di trasmissione';

  @override
  String get clearCastingHistory2 =>
      'Cancellare la cronologia di trasmissione?';

  @override
  String get onlyCastflowsListIs =>
      'Viene cancellato solo l\'elenco di CastFlow. I contenuti sul telefono non vengono mai eliminati.';

  @override
  String get appearance => 'Aspetto';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get system => 'Sistema';

  @override
  String get aboutSupport => 'Info e assistenza';

  @override
  String get rateApp => 'Valuta l\'app';

  @override
  String get feedback => 'Feedback';

  @override
  String get termsConditions => 'Termini e condizioni';

  @override
  String get version => 'Versione';

  @override
  String get castflowProIsActive => 'CastFlow Pro è attivo';

  @override
  String get upgradeToPremium => 'Passa a Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Grazie per il supporto. Goditi la trasmissione senza pubblicità.';

  @override
  String get noAds1080pMirroring =>
      'Senza pubblicità, duplicazione 1080p e trasmissione illimitata';

  @override
  String get upgrade => 'Passa a Premium';

  @override
  String get mirrorCastBeautifullySimple =>
      'Duplica e trasmetti, in modo semplice';

  @override
  String get thisActionMayContain => 'Questa azione può contenere pubblicità';

  @override
  String get webCast => 'Trasmissione web';

  @override
  String get castThisVideo => 'Trasmetti questo video';

  @override
  String get searchOrTypeAWeb => 'Cerca o digita un indirizzo web';

  @override
  String get removeBookmark => 'Rimuovi segnalibro';

  @override
  String get bookmark => 'Segnalibro';

  @override
  String get quickAccess => 'Accesso rapido';

  @override
  String open2(Object title) {
    return 'Apri $title';
  }

  @override
  String get bookmarks => 'Segnalibri';

  @override
  String get noBookmarks => 'Nessun segnalibro';

  @override
  String get tapTheBookmarkIcon =>
      'Tocca l\'icona del segnalibro nella barra degli indirizzi per salvare una pagina.';

  @override
  String get noHistory => 'Nessuna cronologia';

  @override
  String get pagesYouVisitShow => 'Le pagine che visiti compaiono qui.';

  @override
  String get remove => 'Rimuovi';

  @override
  String resultOn(Object value, Object host) {
    return 'Risultato $value su $host';
  }

  @override
  String get aSimulatedPageResult => 'Un risultato di pagina simulato';

  @override
  String get videosOnThisPage => 'Video in questa pagina';

  @override
  String get pickOneToSend => 'Scegline uno da inviare alla TV.';

  @override
  String get onboardHotspotTitle => 'Niente Wi-Fi? Usa l’hotspot';

  @override
  String get onboardHotspotBody =>
      'Attiva l’hotspot del telefono e collega la TV. La trasmissione funziona come in Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Non trovi ancora la TV?';

  @override
  String get stillCantFindBody => 'Collega la TV all’hotspot del telefono:';

  @override
  String get hotspotStep4 => 'Tocca Riprova e scegli la TV dall’elenco';

  @override
  String get castOverHotspot =>
      'Niente Wi-Fi? Trasmetti con l’hotspot del telefono:';

  @override
  String get queue => 'Coda';

  @override
  String get addMusic => 'Aggiungi musica';

  @override
  String get connectWithWifi => 'Connetti al Wi-Fi';

  @override
  String get continueWithHotspot => 'Continua con hotspot';

  @override
  String get noWifiAlertMessage =>
      'Stai usando i dati mobili. Collega telefono e TV alla stessa rete Wi-Fi, oppure attiva l\'hotspot del telefono e collega la TV.';
}
