// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get networkRequiredTitle => 'Brak połączenia z Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Aby przesyłać, telefon i telewizor muszą być w tej samej sieci Wi-Fi.';

  @override
  String get openWifiSettings => 'Otwórz ustawienia Wi-Fi';

  @override
  String get useMobileHotspot => 'Użyj hotspotu mobilnego';

  @override
  String get hotspotInstruction =>
      'Połącz telewizor z hotspotem mobilnym telefonu.';

  @override
  String get hotspotStep1 => 'Włącz hotspot mobilny';

  @override
  String get hotspotStep2 => 'Połącz z nim telewizor';

  @override
  String get hotspotStep3 => 'Wróć do aplikacji';

  @override
  String get openHotspotSettings => 'Otwórz ustawienia hotspotu';

  @override
  String get hotspotAutoCheck =>
      'Gdy wrócisz, sprawdzimy ponownie automatycznie.';

  @override
  String get hotspotDetected => 'Hotspot jest włączony. Szukam telewizora…';

  @override
  String get searchingDevices => 'Szukanie urządzeń w pobliżu...';

  @override
  String get waitingForTvOnHotspot =>
      'Czekam, aż telewizor dołączy do hotspotu…';

  @override
  String get usingHotspot => 'Używasz hotspotu mobilnego';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znaleziono $count urządzenia',
      many: 'Znaleziono $count urządzeń',
      few: 'Znaleziono $count urządzenia',
      one: 'Znaleziono 1 urządzenie',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Ponów';

  @override
  String get scanAgain => 'Skanuj ponownie';

  @override
  String get isolationTitle => 'Telewizor nie odpowiada';

  @override
  String get isolationHint =>
      'Urządzenie dołączyło do hotspotu, ale nie odpowiada. Hotspot może blokować ruch między urządzeniami (izolacja klientów). Wyłącz to w ustawieniach hotspotu lub użyj sieci Wi-Fi.';

  @override
  String get connecting => 'Łączenie…';

  @override
  String get connected => 'Połączono';

  @override
  String get connectionFailed => 'Nie udało się połączyć';

  @override
  String get connectFailedHint =>
      'Upewnij się, że telefon i telewizor są w tej samej sieci, i spróbuj ponownie.';

  @override
  String get hotspotConnectHint =>
      'Hotspot może blokować ruch między urządzeniami. Sprawdź ustawienie izolacji klientów.';

  @override
  String get networkLostTitle => 'Utracono połączenie z siecią';

  @override
  String get networkLostMessage =>
      'Połącz się ponownie z Wi-Fi lub hotspotem, a następnie z telewizorem.';

  @override
  String get reconnect => 'Połącz ponownie';

  @override
  String reconnectTo(String name) {
    return 'Połącz ponownie z $name';
  }

  @override
  String get tapToReconnect => 'Dotknij, aby połączyć ponownie';

  @override
  String get pairingRequired => 'Wymagane parowanie';

  @override
  String get pairingEnterCode => 'Wpisz kod wyświetlony na telewizorze.';

  @override
  String get pairingApproveOnTv =>
      'Spójrz na telewizor i dotknij Zezwól, aby kontynuować.';

  @override
  String get connect => 'Połącz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get pairingIncorrectCode => 'Nieprawidłowy kod. Spróbuj ponownie.';

  @override
  String get pairingTimedOut => 'Upłynął czas parowania';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get pairingDeclined => 'Telewizor odrzucił połączenie';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Zbyt wiele błędnych kodów. Poczekaj $seconds s, a potem poproś o nowy kod.';
  }

  @override
  String get pairingCooldownOver => 'Możesz teraz poprosić o nowy kod.';

  @override
  String get pairingRequestNewCode => 'Poproś o nowy kod';

  @override
  String get pairingNetworkLost =>
      'Podczas parowania utracono sieć. Połącz się ponownie z Wi-Fi i spróbuj jeszcze raz.';

  @override
  String get pairingFailed => 'Nie udało się sparować z telewizorem.';

  @override
  String pairingCodeField(int length) {
    return 'Kod parowania, liczba znaków: $length';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Pole $index z $total';
  }

  @override
  String get pairingEmptyBox => 'puste';

  @override
  String get pairingPaired => 'Sparowano';

  @override
  String get forgetDevice => 'Zapomnij urządzenie';

  @override
  String forgetDeviceMessage(String name) {
    return 'Przy następnym razie $name trzeba będzie sparować ponownie.';
  }

  @override
  String get forget => 'Zapomnij';

  @override
  String get castVideo => 'Prześlij film';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znaleziono $count filmu. Prześlij film',
      many: 'Znaleziono $count filmów. Prześlij film',
      few: 'Znaleziono $count filmy. Prześlij film',
      one: 'Znaleziono 1 film. Prześlij film',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Na tej stronie nie znaleziono jeszcze filmu.';

  @override
  String get videoFound => 'Znaleziono film';

  @override
  String get videoFoundMessage => 'Odtwórz go na telewizorze.';

  @override
  String get castAction => 'Prześlij';

  @override
  String get dismiss => 'Zamknij';

  @override
  String videosFound(int count) {
    return 'Znalezione filmy ($count)';
  }

  @override
  String get castToTv => 'Prześlij na telewizor';

  @override
  String get protectedVideo => 'Chroniony, nie można przesłać';

  @override
  String get videoThumbnail => 'Miniatura filmu';

  @override
  String castingTo(String device) {
    return 'Przesyłanie na $device';
  }

  @override
  String get stopCasting => 'Zatrzymaj przesyłanie';

  @override
  String get play => 'Odtwórz';

  @override
  String get pause => 'Wstrzymaj';

  @override
  String get volume => 'Głośność';

  @override
  String get seekPosition => 'Pozycja odtwarzania';

  @override
  String get showControls => 'Pokaż elementy sterujące';

  @override
  String get hideControls => 'Ukryj elementy sterujące';

  @override
  String get formatUnsupportedTitle => 'Nieobsługiwany format';

  @override
  String formatUnsupported(String device, String format) {
    return '$device nie odtworzy filmów $format. Wypróbuj inny film na tej stronie lub użyj dublowania ekranu.';
  }

  @override
  String get videoExpired =>
      'Link do filmu wygasł. Odśwież stronę i spróbuj ponownie.';

  @override
  String get refreshingVideo => 'Pobieranie nowego linku do filmu…';

  @override
  String get browserBack => 'Wstecz';

  @override
  String get browserForward => 'Dalej';

  @override
  String get browserStartPage => 'Strona startowa';

  @override
  String get browserReload => 'Odśwież';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Start';

  @override
  String get devices => 'Urządzenia';

  @override
  String get history => 'Historia';

  @override
  String get settings => 'Ustawienia';

  @override
  String get goodMorning => 'Dzień dobry';

  @override
  String get goodAfternoon => 'Dzień dobry';

  @override
  String get goodEvening => 'Dobry wieczór';

  @override
  String get couldntOpenTheLink => 'Nie udało się otworzyć linku.';

  @override
  String get castflowLogo => 'Logo CastFlow';

  @override
  String get somethingWentWrong => 'Coś poszło nie tak';

  @override
  String get weCouldntLoadThis =>
      'Nie udało się teraz tego wczytać. Spróbuj ponownie.';

  @override
  String get apps => 'Aplikacje';

  @override
  String open(Object name) {
    return 'Otwórz $name';
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
  String get up => 'Góra';

  @override
  String get down => 'Dół';

  @override
  String get left => 'Lewo';

  @override
  String get right => 'Prawo';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Wejście';

  @override
  String get playPause => 'Odtwarzaj / Wstrzymaj';

  @override
  String get previous => 'Poprzedni';

  @override
  String get next => 'Następny';

  @override
  String get rewind => 'Przewiń wstecz';

  @override
  String get volumeUp => 'Głośniej';

  @override
  String get volumeDown => 'Ciszej';

  @override
  String get mute => 'Wycisz';

  @override
  String connectedTo(Object name) {
    return 'Połączono z $name';
  }

  @override
  String get chooseADevice => 'Wybierz urządzenie';

  @override
  String get connectionGuide => 'Przewodnik po łączeniu';

  @override
  String get lookingForTvsOn => 'Szukanie telewizorów w Twojej sieci Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return 'Dotąd znaleziono: $found';
  }

  @override
  String deviceFound(Object found, Object value) {
    return 'Znaleziono urządzeń: $found';
  }

  @override
  String get disconnect => 'Rozłącz';

  @override
  String signalOf4(Object level) {
    return 'Sygnał $level z 4';
  }

  @override
  String get connecting2 => 'Łączenie';

  @override
  String get theTvRemoteNeeds =>
      'Pilot wymaga połączonego telewizora. Wybierz jeden poniżej.';

  @override
  String get connectToATv => 'Połącz się z telewizorem, aby kontynuować.';

  @override
  String get findingTvs => 'Szukanie telewizorów…';

  @override
  String get makeSureYourTv => 'Upewnij się, że telewizor jest włączony';

  @override
  String get notConnected => 'Niepołączony';

  @override
  String get tapToFindYour => 'Dotknij, aby znaleźć telewizor';

  @override
  String get connectionFailed2 => 'Połączenie nie powiodło się';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Dotknij, aby zarządzać urządzeniami';
  }

  @override
  String get joinTheSameWi => 'Dołącz do tej samej sieci Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Połącz telefon i telewizor z tą samą siecią Wi-Fi.';

  @override
  String get turnOnCastingOn => 'Włącz przesyłanie na telewizorze';

  @override
  String get enableScreenMirroringMiracast =>
      'Włącz dublowanie ekranu, Miracast lub Google Cast w ustawieniach telewizora.';

  @override
  String get scanForDevices => 'Skanuj urządzenia';

  @override
  String get openDevicesInCastflow =>
      'Otwórz Urządzenia w CastFlow i poczekaj kilka sekund, aż pojawi się telewizor.';

  @override
  String get tapConnect => 'Dotknij Połącz';

  @override
  String get acceptThePromptOn =>
      'Zaakceptuj komunikat na telewizorze, jeśli się pojawi. To wszystko!';

  @override
  String get howToConnect => 'Jak się połączyć';

  @override
  String get fourQuickStepsTo =>
      'Cztery szybkie kroki, by przenieść obraz na duży ekran.';

  @override
  String get gotIt => 'Rozumiem';

  @override
  String step(Object number, Object title, Object body) {
    return 'Krok $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Domowe Wi-Fi';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Ustawienia › Połączenie';

  @override
  String get inputHdmi1 => 'Wejście: HDMI 1';

  @override
  String get screenMirroring => 'Dublowanie ekranu';

  @override
  String get networkHomeWiFi => 'Sieć: domowe Wi-Fi';

  @override
  String get livingRoomTv => 'Telewizor w salonie';

  @override
  String get allowCastflowToConnect => 'Zezwolić CastFlow na połączenie?';

  @override
  String get deny => 'Odmów';

  @override
  String get allow => 'Zezwól';

  @override
  String get yourTv => 'Twój telewizor';

  @override
  String get findYourTv => 'Znajdź telewizor';

  @override
  String connectTo(Object name) {
    return 'Połącz z $name';
  }

  @override
  String connected2(Object label) {
    return 'Połączono · $label';
  }

  @override
  String get openTvRemote => 'Otwórz pilota TV';

  @override
  String get sameWiFiNetwork => 'Ta sama sieć Wi-Fi';

  @override
  String get yourPhoneAndTv =>
      'Telefon i telewizor muszą być połączone z tą samą siecią Wi-Fi.';

  @override
  String get tvIsOnAnd => 'Telewizor jest włączony i gotowy';

  @override
  String get turnOnScreenMirroring =>
      'Włącz dublowanie ekranu, Cast lub Miracast na telewizorze.';

  @override
  String get noVpnOrGuest => 'Bez VPN i sieci gościnnej';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN i gościnne albo izolowane Wi-Fi ukrywają urządzenia przed sobą.';

  @override
  String get localNetworkAccess => 'Dostęp do sieci lokalnej';

  @override
  String get allowCastflowToFind =>
      'Gdy aplikacja poprosi, zezwól CastFlow na wyszukiwanie urządzeń w Twojej sieci.';

  @override
  String get noTvFound => 'Nie znaleziono telewizora';

  @override
  String get checkThatYourPhone =>
      'Sprawdź, czy telefon i telewizor są w tej samej sieci Wi-Fi, i skanuj ponownie.';

  @override
  String get noWiFiRouter => 'Brak routera Wi-Fi? Użyj hotspotu';

  @override
  String searchingForTvsFound(Object length) {
    return 'Szukanie telewizorów. Znaleziono: $length.';
  }

  @override
  String tvsFound(Object length) {
    return 'Znaleziono telewizorów: $length';
  }

  @override
  String get connectToYourTv => 'Połącz się z telewizorem';

  @override
  String get connectYourPhoneAndTv =>
      'Połącz telefon i telewizor z tą samą siecią Wi-Fi.';

  @override
  String get turnOnTheTv =>
      'Włącz telewizor i otwórz wejście Dublowanie ekranu / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Dotknij paska połączenia na ekranie głównym, aby znaleźć telewizor.';

  @override
  String get tapConnectAndAccept =>
      'Dotknij Połącz i zaakceptuj komunikat na telewizorze, jeśli się pojawi.';

  @override
  String get mirrorYourScreen => 'Dubluj ekran';

  @override
  String get connectToYourTvFirst => 'Najpierw połącz się z telewizorem.';

  @override
  String get openScreenMirroringFrom =>
      'Otwórz Dublowanie ekranu na ekranie głównym.';

  @override
  String get pickAQualityAnd => 'Wybierz jakość i dotknij Start.';

  @override
  String get allowScreenCaptureWhen =>
      'Zezwól na przechwytywanie ekranu, gdy zapyta Android.';

  @override
  String get castPhotosVideosMusic => 'Przesyłaj zdjęcia, filmy i muzykę';

  @override
  String get openPhotosVideosOr =>
      'Otwórz Zdjęcia, Filmy lub Muzykę na ekranie głównym.';

  @override
  String get pickWhatYouWant => 'Wybierz, co chcesz pokazać.';

  @override
  String get itPlaysOnThe =>
      'Odtwarza się na telewizorze; steruj z telefonu lub powiadomienia.';

  @override
  String get useTheTvRemote => 'Używaj pilota TV';

  @override
  String get openTvRemoteOn => 'Otwórz Pilot TV na ekranie głównym.';

  @override
  String get useTheDPad =>
      'Używaj klawiszy kierunkowych lub przesuwaj palcem po touchpadzie, a OK wybiera.';

  @override
  String get buttonsATvDoesnt =>
      'Przyciski, których telewizor nie obsługuje, są wyszarzone.';

  @override
  String get castFromTheWeb => 'Przesyłaj z internetu i aplikacji';

  @override
  String get tapTheBrowserBar =>
      'Dotknij paska przeglądarki lub aplikacji na ekranie głównym.';

  @override
  String get playAVideoOn => 'Odtwórz film na stronie.';

  @override
  String get tapCastThisVideo =>
      'Dotknij „Prześlij ten film”, aby wysłać go na telewizor.';

  @override
  String get screenMirroringHelp => 'Pomoc dotycząca dublowania ekranu';

  @override
  String get connectYourPhoneTo => 'Połącz telefon z Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Na telewizorze otwórz Ustawienia → Sieć i dołącz do tej samej sieci Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Sieci gościnne lub firmowe często blokują dublowanie; użyj domowego Wi-Fi lub hotspotu telefonu.';

  @override
  String get turnOffVpn => 'Wyłącz VPN';

  @override
  String get aVpnHidesYour => 'VPN ukrywa telewizor przed telefonem.';

  @override
  String get pauseOrDisconnectYour =>
      'Wstrzymaj lub rozłącz aplikację VPN przed rozpoczęciem.';

  @override
  String get youCanTurnIt => 'Po zakończeniu możesz ją włączyć ponownie.';

  @override
  String get turnOnMirroringOn => 'Włącz dublowanie na telewizorze';

  @override
  String get samsungLgAndMost =>
      'Telewizory Samsung, LG i większość Android TV przyjmują dublowanie automatycznie.';

  @override
  String get otherTvsOpenInput =>
      'Inne telewizory: otwórz Wejście / Źródło i wybierz Dublowanie ekranu lub Miracast.';

  @override
  String get keepTheTvOn =>
      'Zostaw telewizor na tym ekranie, gdy telefon się łączy.';

  @override
  String get tapStartAndPick => 'Dotknij Start i wybierz telewizor';

  @override
  String get tapStartOnThe => 'Dotknij Start na ekranie Dublowanie ekranu.';

  @override
  String get androidOpensSmartView =>
      'Android otworzy Smart View / Cast. Dotknij telewizora na liście.';

  @override
  String get ifTheTvAsks =>
      'Jeśli telewizor zapyta, wybierz Zezwól lub wpisz PIN widoczny na ekranie.';

  @override
  String get youreMirroring => 'Dublujesz ekran';

  @override
  String get everythingOnYourPhone =>
      'Wszystko z telefonu widać teraz na telewizorze.';

  @override
  String get turnThePhoneSideways =>
      'Obróć telefon, aby oglądać filmy i grać na pełnym ekranie.';

  @override
  String get toStopTapStop =>
      'Aby zatrzymać, dotknij Zatrzymaj lub użyj powiadomienia o przesyłaniu.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Wył.';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'Telewizor w sypialni';

  @override
  String get officeDisplay => 'Wyświetlacz w biurze';

  @override
  String get clearHistory => 'Wyczyścić historię?';

  @override
  String get thisRemovesEverythingYouve =>
      'To usunie z tej listy wszystko, co przesyłałeś.';

  @override
  String get clear => 'Wyczyść';

  @override
  String get clearHistory2 => 'Wyczyść historię';

  @override
  String get noHistoryYet => 'Brak historii';

  @override
  String get everythingYouCastWill =>
      'Wszystko, co prześlesz, pojawi się tutaj, aby łatwo to znaleźć.';

  @override
  String get today => 'Dzisiaj';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String get earlier => 'Wcześniej';

  @override
  String get swipeAnItemTo => 'Przesuń element, aby go usunąć';

  @override
  String get delete => 'Usuń';

  @override
  String removed(Object title) {
    return 'Usunięto „$title”';
  }

  @override
  String get undo => 'Cofnij';

  @override
  String get photos => 'Zdjęcia';

  @override
  String get albums => 'Albumy';

  @override
  String get videos => 'Filmy';

  @override
  String get gallery => 'Galeria';

  @override
  String get music => 'Muzyka';

  @override
  String get songs => 'Utwory';

  @override
  String get media => 'Multimedia';

  @override
  String get browseTheWeb => 'Przeglądaj internet';

  @override
  String get goPro => 'Przejdź na Pro';

  @override
  String cast(Object title) {
    return 'Prześlij $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Dublowanie ekranu. Rozpocznij dublowanie';

  @override
  String readyToMirrorTo(Object device) {
    return 'Gotowe do dublowania na $device';
  }

  @override
  String get showYourPhoneOn =>
      'Pokaż telefon na telewizorze w czasie rzeczywistym.';

  @override
  String get startMirroring => 'Rozpocznij dublowanie';

  @override
  String get tvRemote => 'Pilot TV';

  @override
  String get controlYourTv => 'Steruj telewizorem';

  @override
  String get youtubeMore => 'YouTube i więcej';

  @override
  String get openTheBrowser => 'Otwórz przeglądarkę';

  @override
  String get searchOrTypeA => 'Wyszukaj lub wpisz adres strony';

  @override
  String get howToConnectOpen =>
      'Jak się połączyć. Otwórz przewodnik graficzny';

  @override
  String get visualGuideForEvery => 'Przewodnik graficzny do każdej funkcji';

  @override
  String get language => 'Język';

  @override
  String get done => 'Gotowe';

  @override
  String get enterAValidHttp =>
      'Wpisz prawidłowy link http(s) lub rtsp, np. adres URL .m3u8 lub .mp4.';

  @override
  String get linkStream => 'Strumień z linku';

  @override
  String get iptvLinkCast => 'IPTV / Przesyłanie linku';

  @override
  String get castALink => 'Prześlij link';

  @override
  String get pasteADirectVideo =>
      'Wklej adres URL bezpośredniego filmu, M3U8 lub strumienia IPTV.';

  @override
  String get paste => 'Wklej';

  @override
  String get castLink => 'Prześlij link';

  @override
  String get allowAccessToYour =>
      'Zezwól na dostęp do multimediów, aby je przesyłać. Możesz to zmienić w Ustawieniach.';

  @override
  String get video => 'Film';

  @override
  String get castMusic => 'Prześlij muzykę';

  @override
  String get noMusicFound => 'Nie znaleziono muzyki';

  @override
  String get addSongsToYour => 'Dodaj utwory do telefonu, a pojawią się tutaj.';

  @override
  String get shuffle => 'Losowo';

  @override
  String get playAll => 'Odtwórz wszystko';

  @override
  String photo(Object formatShortDate) {
    return 'Zdjęcie · $formatShortDate';
  }

  @override
  String get photo2 => 'Zdjęcie';

  @override
  String get castPhotos => 'Prześlij zdjęcia';

  @override
  String get select => 'Wybierz';

  @override
  String get noPhotosHere => 'Brak zdjęć';

  @override
  String get photosYouTakeOr =>
      'Zdjęcia, które zrobisz lub zapiszesz, pojawią się w tym albumie.';

  @override
  String photos2(Object name, Object count) {
    return '$name, zdjęć: $count';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Zdjęcie z $formatShortDate';
  }

  @override
  String get allPhotos => 'Wszystkie zdjęcia';

  @override
  String get slideshow => 'Pokaz slajdów';

  @override
  String get interval => 'Odstęp';

  @override
  String get transition => 'Przejście';

  @override
  String get fade => 'Zanikanie';

  @override
  String get slide => 'Przesunięcie';

  @override
  String get zoom => 'Powiększenie';

  @override
  String get startSlideshow => 'Rozpocznij pokaz slajdów';

  @override
  String get castVideos => 'Prześlij filmy';

  @override
  String get noVideosYet => 'Brak filmów';

  @override
  String get videosYouRecordOr =>
      'Filmy, które nagrasz lub pobierzesz, pojawią się tutaj, gotowe do przesłania.';

  @override
  String video2(Object resolution) {
    return 'Film · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Prześlij';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Sesja dublowania ekranu';

  @override
  String get mirroringDidntStartTap =>
      'Dublowanie nie ruszyło. Dotknij Start jeszcze raz i wybierz telewizor z listy.';

  @override
  String get openSmartViewOr =>
      'Aby dublować, otwórz Smart View lub Cast w szybkich ustawieniach telefonu.';

  @override
  String get quality => 'Jakość';

  @override
  String get adjustsToYourWi =>
      'Dopasowuje się do Twojego Wi-Fi, aby obraz był jak najpłynniejszy.';

  @override
  String upToLowerIt(Object label) {
    return 'Do $label. Obniż, jeśli obraz się zacina.';
  }

  @override
  String get stillNeedHelp => 'Potrzebujesz pomocy?';

  @override
  String get startingScreenMirroring => 'Rozpoczynanie dublowania ekranu…';

  @override
  String mirroringTo(Object value) {
    return 'Dublowanie na $value';
  }

  @override
  String get stopping => 'Zatrzymywanie…';

  @override
  String get readyToMirror => 'Gotowe do dublowania';

  @override
  String get beforeYouStart => 'Zanim zaczniesz';

  @override
  String get phoneAndTvAre => 'Telefon i telewizor są w tej samej sieci Wi-Fi';

  @override
  String get noVpnIsConnected => 'Na telefonie nie jest połączony żaden VPN';

  @override
  String get tvIsOnWith => 'Telewizor jest włączony z dublowaniem ekranu';

  @override
  String get phoneIsCloseTo => 'Telefon jest blisko telewizora';

  @override
  String get stopMirroring => 'Zatrzymaj dublowanie';

  @override
  String get startMirroring2 => 'Rozpocznij dublowanie';

  @override
  String get stop => 'Stop';

  @override
  String get start => 'Start';

  @override
  String get duration => 'Czas trwania';

  @override
  String get adIsLoading => 'Wczytywanie reklamy';

  @override
  String get ad => 'Reklama';

  @override
  String get mirrorYourScreenTo => 'Dubluj ekran na dowolnym telewizorze';

  @override
  String get showYourPhoneOnThe =>
      'Pokaż telefon na dużym ekranie jednym dotknięciem — bez kabli i zamieszania.';

  @override
  String get shareMemoriesWithThe =>
      'Dziel się wspomnieniami z całym pokojem i steruj z telefonu.';

  @override
  String get castFromWebApps => 'Przesyłaj z internetu i aplikacji';

  @override
  String get sendVideosFromYoutube =>
      'Wysyłaj filmy z YouTube, Facebooka i dowolnej strony prosto na telewizor.';

  @override
  String pageOf(Object value, Object length) {
    return 'Strona $value z $length';
  }

  @override
  String get getStarted => 'Zaczynamy';

  @override
  String get localNetwork => 'Sieć lokalna';

  @override
  String get findTvsAndStreaming =>
      'Znajdź telewizory i urządzenia do streamingu w swojej sieci Wi-Fi.';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get showCastingControlsWhile =>
      'Pokazuj elementy sterujące przesyłaniem podczas korzystania z innych aplikacji.';

  @override
  String get photosVideosMusic => 'Zdjęcia, filmy i muzyka';

  @override
  String get pickWhatYouWantTo =>
      'Wybierz, co przesłać z galerii i biblioteki.';

  @override
  String get screenCapture => 'Przechwytywanie ekranu';

  @override
  String get mirrorYourScreenYoull => 'Dubluj ekran. Każdą sesję potwierdzisz.';

  @override
  String get webVideo => 'Film z internetu';

  @override
  String get link => 'Link';

  @override
  String get screenMirroring2 => 'Dublowanie ekranu';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Przesyłanie: $title. Otwórz pilota';
  }

  @override
  String castingTo2(Object value) {
    return 'Przesyłanie na $value';
  }

  @override
  String get nowCasting => 'Teraz przesyłane';

  @override
  String get nothingIsCasting => 'Nic nie jest przesyłane';

  @override
  String get pickAPhotoVideo =>
      'Wybierz zdjęcie, film, utwór lub film z internetu, aby wysłać go na telewizor.';

  @override
  String get backToHome => 'Wróć do ekranu głównego';

  @override
  String slide2(Object formatDuration) {
    return 'Slajd $formatDuration';
  }

  @override
  String get back10Seconds => 'Cofnij o 10 sekund';

  @override
  String get forward10Seconds => 'Do przodu o 10 sekund';

  @override
  String get tvVolume => 'Głośność TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Głośność TV: $round procent';
  }

  @override
  String get upNext => 'Dalej';

  @override
  String get addPhotos => 'Dodaj zdjęcia';

  @override
  String get addVideos => 'Dodaj filmy';

  @override
  String get nothingElseInThe => 'W kolejce nie ma nic więcej.';

  @override
  String play2(Object title) {
    return 'Odtwórz $title';
  }

  @override
  String get unknownDevice => 'Nieznane urządzenie';

  @override
  String get perWeek => 'tygodniowo';

  @override
  String get perYear => 'rocznie';

  @override
  String get payOnce => 'jednorazowa płatność';

  @override
  String get wirelessScreenMirroring => 'Bezprzewodowe dublowanie ekranu';

  @override
  String get castVideosPhotosMusic => 'Przesyłaj filmy, zdjęcia i muzykę';

  @override
  String get fullTvRemoteControl => 'Pełne sterowanie telewizorem';

  @override
  String get worksWithAllMajor =>
      'Działa z wszystkimi popularnymi telewizorami';

  @override
  String get smoothLagFreeStreaming => 'Płynne przesyłanie bez opóźnień';

  @override
  String get noAds => 'Bez reklam';

  @override
  String get welcomeToCastflowPro => 'Witaj w CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Zakup anulowany.';

  @override
  String get purchasePendingProUnlocks =>
      'Zakup oczekuje. Pro odblokuje się, gdy sklep go potwierdzi.';

  @override
  String get purchaseFailedPleaseTry =>
      'Zakup nie powiódł się. Spróbuj ponownie.';

  @override
  String get theStoreIsntAvailable => 'Sklep jest teraz niedostępny.';

  @override
  String get close => 'Zamknij';

  @override
  String get goProWithCastflow => 'PRZEJDŹ NA PRO Z CASTFLOW';

  @override
  String get unlockEveryFeature => 'Odblokuj wszystkie funkcje';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Odnawia się automatycznie do momentu anulowania.';

  @override
  String get oneTimePurchaseNo => 'Zakup jednorazowy. Bez subskrypcji.';

  @override
  String get continueAction => 'Kontynuuj';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get termsAndConditions => 'Warunki korzystania';

  @override
  String get cancelAnytime => 'Anuluj w dowolnym momencie';

  @override
  String get loadingPrice => 'Wczytywanie ceny…';

  @override
  String get pricesUnavailableTapTo =>
      'Ceny niedostępne · Dotknij, aby ponowić';

  @override
  String get noPlansAvailableRight => 'Obecnie brak dostępnych planów.';

  @override
  String get weekly => 'Tygodniowy';

  @override
  String get yearly => 'Roczny';

  @override
  String get lifetime => 'Dożywotni';

  @override
  String get bestValue => 'Najlepsza oferta';

  @override
  String get disconnectFromTv => 'Rozłączyć z telewizorem?';

  @override
  String get thisStopsWhatIs =>
      'To zatrzyma to, co jest teraz odtwarzane lub dublowane.';

  @override
  String get useTouchpad => 'Użyj touchpada';

  @override
  String get useDPad => 'Użyj klawiszy kierunkowych';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Odbiorniki $label nie przyjmują poleceń pilota.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Niektóre przyciski są niedostępne na $label.';
  }

  @override
  String get idle => 'BEZCZYNNY';

  @override
  String get playing => 'ODTWARZANIE';

  @override
  String get paused => 'WSTRZYMANO';

  @override
  String get noTvConnected => 'Brak połączonego telewizora';

  @override
  String get mute2 => 'WYCISZONO';

  @override
  String vol(Object volume) {
    return 'GŁOŚN. $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Brak połączonego telewizora. Dotknij, aby wybrać urządzenie';

  @override
  String get tapToChooseA => 'Dotknij, aby wybrać urządzenie';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label nie jest obsługiwane przez $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Touchpad. Przesuń, aby się poruszać, dotknij, aby wybrać.';

  @override
  String get swipeToMoveTap =>
      'Przesuń, aby się poruszać · Dotknij, aby wybrać';

  @override
  String get navigationIsntSupportedBy =>
      'Ten telewizor nie obsługuje nawigacji';

  @override
  String get vol2 => 'GŁOŚN.';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automatycznie';

  @override
  String get googleCastFirst => 'Najpierw Google Cast';

  @override
  String get dlnaUpnpFirst => 'Najpierw DLNA / UPnP';

  @override
  String get miracastFirst => 'Najpierw Miracast';

  @override
  String get tvOnly => 'Tylko TV';

  @override
  String get phoneAndTv => 'Telefon i TV';

  @override
  String get phoneOnly => 'Tylko telefon';

  @override
  String get touchpad => 'Touchpad';

  @override
  String get doMyPhoneAnd =>
      'Czy telefon i telewizor muszą być w tej samej sieci Wi-Fi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Tak. Wykrywanie i przesyłanie odbywają się w Twojej sieci lokalnej, więc oba urządzenia muszą być w tej samej sieci Wi-Fi (podobne nazwy pasm mogą oznaczać różne sieci).';

  @override
  String get myRouterHasAp => 'Mój router ma „izolację AP / klientów”';

  @override
  String get isolationBlocksDevicesFrom =>
      'Izolacja uniemożliwia urządzeniom widzenie się nawzajem. Wyłącz ją w ustawieniach routera lub użyj sieci innej niż gościnna.';

  @override
  String get findingYourTv => 'Znajdowanie telewizora';

  @override
  String get myTvDoesntAppear => 'Mój telewizor nie pojawia się na liście';

  @override
  String get turnOnCastingScreen =>
      'Włącz przesyłanie / dublowanie na telewizorze, wybudź go z uśpienia i dotknij Skanuj ponownie. Zezwól na dostęp do sieci lokalnej, jeśli aplikacja o to poprosi.';

  @override
  String get onlySomeDevicesShow => 'Widać tylko niektóre urządzenia';

  @override
  String get olderTvsMayNeed =>
      'Starsze telewizory mogą wymagać aktualizacji oprogramowania. Telewizory Miracast pojawiają się tylko przy otwartym wejściu „Dublowanie ekranu”.';

  @override
  String get connectionFailsOrTimes =>
      'Połączenie nie powodzi się lub przekracza limit czasu';

  @override
  String get restartTheTvApp =>
      'Uruchom ponownie aplikację telewizora lub telewizor, podejdź bliżej routera i zaakceptuj każdy komunikat na ekranie telewizora.';

  @override
  String get itKeepsReconnectingTo => 'Ciągle łączy się ze starym telewizorem';

  @override
  String get turnOffAutoConnect =>
      'Wyłącz „Łącz automatycznie z ostatnim telewizorem” w Ustawienia → Przesyłanie.';

  @override
  String get mirroringIsLaggy => 'Dublowanie się zacina';

  @override
  String get chooseALowerQuality =>
      'Wybierz niższą jakość (720p lub 480p), zamknij ciężkie aplikacje i użyj sieci Wi-Fi 5 GHz.';

  @override
  String get thePictureIsRotated => 'Obraz jest obrócony lub przycięty';

  @override
  String get toggleAutoRotateOn =>
      'Włącz lub wyłącz Autoobracanie na ekranie Dublowanie ekranu.';

  @override
  String get sound => 'Dźwięk';

  @override
  String get thereIsNoSound => 'Telewizor nie ma dźwięku';

  @override
  String get makeSureAudioIs =>
      'Upewnij się, że dźwięk jest włączony w Dublowaniu ekranu, i sprawdź Ustawienia → Przesyłanie → Wyjście audio. Niektóre odbiorniki nie obsługują dźwięku z telefonu.';

  @override
  String get tvRemote2 => 'Pilot TV';

  @override
  String get someRemoteButtonsAre => 'Niektóre przyciski pilota są wyszarzone';

  @override
  String get eachReceiverSupportsDifferent =>
      'Każdy odbiornik obsługuje inne polecenia. Chromecast i DLNA obsługują tylko odtwarzanie i głośność; Miracast nie ma kanału pilota.';

  @override
  String get canCastflowTurnMy =>
      'Czy CastFlow może włączyć telewizor lub zmienić wejście?';

  @override
  String get onlyOnTvsThat =>
      'Tylko na telewizorach, które udostępniają te polecenia w sieci. Nieobsługiwane przyciski są wyłączone, zamiast udawać, że działają.';

  @override
  String get helpFaq => 'Pomoc i FAQ';

  @override
  String get stepByStepConnection => 'Przewodnik po łączeniu krok po kroku';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Nie znaleziono aplikacji poczty.';

  @override
  String get enjoyingCastflow => 'Podoba Ci się CastFlow?';

  @override
  String get sorryToHearThat => 'Przykro nam';

  @override
  String get thanksHowCanWe => 'Dzięki! Jak możemy być lepsi?';

  @override
  String get wereGladYouLike => 'Cieszymy się, że Ci się podoba!';

  @override
  String get youMadeOurDay => 'Umilasz nam dzień!';

  @override
  String get tapToExit => 'Dotknij, aby wyjść';

  @override
  String get selectARating => 'Wybierz ocenę';

  @override
  String get sendFeedback => 'Wyślij opinię';

  @override
  String get rateUs => 'Oceń nas';

  @override
  String get rateYourExperienceBefore =>
      'Oceń swoje wrażenia, zanim wyjdziesz.';

  @override
  String get tapAStarTo => 'Dotknij gwiazdki, aby ocenić CastFlow.';

  @override
  String get general => 'Ogólne';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Domyślna jakość';

  @override
  String get autoConnectToLast => 'Łącz automatycznie z ostatnim telewizorem';

  @override
  String get hapticFeedback => 'Wibracje dotykowe';

  @override
  String get clearCastingHistory => 'Wyczyść historię przesyłania';

  @override
  String get clearCastingHistory2 => 'Wyczyścić historię przesyłania?';

  @override
  String get onlyCastflowsListIs =>
      'Czyszczona jest tylko lista CastFlow. Multimedia w telefonie nigdy nie są usuwane.';

  @override
  String get appearance => 'Wygląd';

  @override
  String get light => 'Jasny';

  @override
  String get dark => 'Ciemny';

  @override
  String get system => 'Systemowy';

  @override
  String get aboutSupport => 'O aplikacji i pomoc';

  @override
  String get rateApp => 'Oceń aplikację';

  @override
  String get feedback => 'Opinia';

  @override
  String get termsConditions => 'Warunki korzystania';

  @override
  String get version => 'Wersja';

  @override
  String get castflowProIsActive => 'CastFlow Pro jest aktywny';

  @override
  String get upgradeToPremium => 'Przejdź na Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Dziękujemy za wsparcie. Ciesz się przesyłaniem bez reklam.';

  @override
  String get noAds1080pMirroring =>
      'Bez reklam, dublowanie 1080p i nielimitowane przesyłanie';

  @override
  String get upgrade => 'Ulepsz';

  @override
  String get mirrorCastBeautifullySimple =>
      'Dubluj i przesyłaj — pięknie i prosto';

  @override
  String get thisActionMayContain => 'Ta czynność może zawierać reklamy';

  @override
  String get webCast => 'Przesyłanie z internetu';

  @override
  String get castThisVideo => 'Prześlij ten film';

  @override
  String get searchOrTypeAWeb => 'Wyszukaj lub wpisz adres internetowy';

  @override
  String get removeBookmark => 'Usuń zakładkę';

  @override
  String get bookmark => 'Zakładka';

  @override
  String get quickAccess => 'Szybki dostęp';

  @override
  String open2(Object title) {
    return 'Otwórz $title';
  }

  @override
  String get bookmarks => 'Zakładki';

  @override
  String get noBookmarks => 'Brak zakładek';

  @override
  String get tapTheBookmarkIcon =>
      'Dotknij ikony zakładki na pasku adresu, aby zapisać stronę.';

  @override
  String get noHistory => 'Brak historii';

  @override
  String get pagesYouVisitShow => 'Odwiedzone strony pojawią się tutaj.';

  @override
  String get remove => 'Usuń';

  @override
  String resultOn(Object value, Object host) {
    return 'Wynik $value na $host';
  }

  @override
  String get aSimulatedPageResult => 'Symulowany wynik strony';

  @override
  String get videosOnThisPage => 'Filmy na tej stronie';

  @override
  String get pickOneToSend => 'Wybierz jeden, aby wysłać go na telewizor.';

  @override
  String get onboardHotspotTitle => 'Brak Wi-Fi? Użyj hotspotu';

  @override
  String get onboardHotspotBody =>
      'Włącz hotspot w telefonie i połącz z nim telewizor. Przesyłanie działa tak samo jak przez Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Nadal nie widzisz telewizora?';

  @override
  String get stillCantFindBody => 'Połącz telewizor z hotspotem telefonu:';

  @override
  String get hotspotStep4 => 'Stuknij Ponów i wybierz telewizor z listy';

  @override
  String get castOverHotspot => 'Brak Wi-Fi? Przesyłaj przez hotspot telefonu:';

  @override
  String get queue => 'Kolejka';

  @override
  String get addMusic => 'Dodaj muzykę';

  @override
  String get connectWithWifi => 'Połącz z Wi-Fi';

  @override
  String get continueWithHotspot => 'Kontynuuj z hotspotem';

  @override
  String get noWifiAlertMessage =>
      'Korzystasz z danych komórkowych. Połącz telefon i telewizor z tą samą siecią Wi-Fi albo włącz hotspot w telefonie i połącz z nim telewizor.';
}
