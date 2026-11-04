// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get networkRequiredTitle => 'Sin conexión Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Tu teléfono y la TV deben estar en la misma red Wi-Fi para transmitir.';

  @override
  String get openWifiSettings => 'Abrir ajustes de Wi-Fi';

  @override
  String get useMobileHotspot => 'Usar punto de acceso móvil';

  @override
  String get hotspotInstruction => 'Conecta tu TV al punto de acceso móvil.';

  @override
  String get hotspotStep1 => 'Activa el punto de acceso móvil';

  @override
  String get hotspotStep2 => 'Conecta tu TV a él';

  @override
  String get hotspotStep3 => 'Vuelve a la app';

  @override
  String get openHotspotSettings => 'Abrir ajustes del punto de acceso';

  @override
  String get hotspotAutoCheck =>
      'Comprobaremos de nuevo automáticamente cuando vuelvas.';

  @override
  String get hotspotDetected =>
      'El punto de acceso está activo. Buscando tu TV…';

  @override
  String get searchingDevices => 'Buscando dispositivos cercanos...';

  @override
  String get waitingForTvOnHotspot =>
      'Esperando a que tu TV se una a tu punto de acceso…';

  @override
  String get usingHotspot => 'Usando tu punto de acceso móvil';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dispositivos encontrados',
      one: '1 dispositivo encontrado',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get scanAgain => 'Buscar de nuevo';

  @override
  String get isolationTitle => 'La TV no responde';

  @override
  String get isolationHint =>
      'Un dispositivo se unió a tu punto de acceso pero no responde. Puede que bloquee el tráfico entre dispositivos (aislamiento de clientes). Desactívalo en los ajustes del punto de acceso o usa una red Wi-Fi.';

  @override
  String get connecting => 'Conectando…';

  @override
  String get connected => 'Conectado';

  @override
  String get connectionFailed => 'No se pudo conectar';

  @override
  String get connectFailedHint =>
      'Asegúrate de que el teléfono y la TV estén en la misma red e inténtalo de nuevo.';

  @override
  String get hotspotConnectHint =>
      'Tu punto de acceso puede estar bloqueando el tráfico entre dispositivos. Revisa el aislamiento de clientes.';

  @override
  String get networkLostTitle => 'Conexión de red perdida';

  @override
  String get networkLostMessage =>
      'Vuelve a conectarte al Wi-Fi o al punto de acceso y luego reconecta tu TV.';

  @override
  String get reconnect => 'Reconectar';

  @override
  String reconnectTo(String name) {
    return 'Reconectar con $name';
  }

  @override
  String get tapToReconnect => 'Toca para reconectar';

  @override
  String get pairingRequired => 'Se requiere emparejamiento';

  @override
  String get pairingEnterCode => 'Introduce el código que aparece en tu TV.';

  @override
  String get pairingApproveOnTv => 'Mira tu TV y toca Permitir para continuar.';

  @override
  String get connect => 'Conectar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get pairingIncorrectCode => 'Código incorrecto. Inténtalo de nuevo.';

  @override
  String get pairingTimedOut => 'Tiempo de emparejamiento agotado';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get pairingDeclined => 'La TV rechazó la conexión';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Demasiados códigos incorrectos. Espera $seconds s y solicita un código nuevo.';
  }

  @override
  String get pairingCooldownOver => 'Ya puedes solicitar un código nuevo.';

  @override
  String get pairingRequestNewCode => 'Solicitar código nuevo';

  @override
  String get pairingNetworkLost =>
      'Se perdió la red durante el emparejamiento. Vuelve a conectarte al Wi-Fi e inténtalo de nuevo.';

  @override
  String get pairingFailed => 'No se pudo emparejar con la TV.';

  @override
  String pairingCodeField(int length) {
    return 'Código de emparejamiento, $length caracteres';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Casilla $index de $total';
  }

  @override
  String get pairingEmptyBox => 'vacío';

  @override
  String get pairingPaired => 'Emparejado';

  @override
  String get forgetDevice => 'Olvidar dispositivo';

  @override
  String forgetDeviceMessage(String name) {
    return '$name deberá emparejarse de nuevo la próxima vez.';
  }

  @override
  String get forget => 'Olvidar';

  @override
  String get castVideo => 'Transmitir vídeo';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vídeos encontrados. Transmitir vídeo',
      one: '1 vídeo encontrado. Transmitir vídeo',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Aún no hay vídeo en esta página.';

  @override
  String get videoFound => 'Vídeo encontrado';

  @override
  String get videoFoundMessage => 'Reprodúcelo en tu TV.';

  @override
  String get castAction => 'Transmitir';

  @override
  String get dismiss => 'Descartar';

  @override
  String videosFound(int count) {
    return 'Vídeos encontrados ($count)';
  }

  @override
  String get castToTv => 'Transmitir a la TV';

  @override
  String get protectedVideo => 'Protegido, no se puede transmitir';

  @override
  String get videoThumbnail => 'Miniatura del vídeo';

  @override
  String castingTo(String device) {
    return 'Transmitiendo a $device';
  }

  @override
  String get stopCasting => 'Detener transmisión';

  @override
  String get play => 'Reproducir';

  @override
  String get pause => 'Pausa';

  @override
  String get volume => 'Volumen';

  @override
  String get seekPosition => 'Posición de reproducción';

  @override
  String get showControls => 'Mostrar controles';

  @override
  String get hideControls => 'Ocultar controles';

  @override
  String get formatUnsupportedTitle => 'Formato no compatible';

  @override
  String formatUnsupported(String device, String format) {
    return '$device no puede reproducir vídeos $format. Prueba con otro vídeo de esta página o usa la duplicación de pantalla.';
  }

  @override
  String get videoExpired =>
      'El enlace del vídeo caducó. Recarga la página e inténtalo de nuevo.';

  @override
  String get refreshingVideo => 'Obteniendo un enlace de vídeo nuevo…';

  @override
  String get browserBack => 'Atrás';

  @override
  String get browserForward => 'Adelante';

  @override
  String get browserStartPage => 'Página de inicio';

  @override
  String get browserReload => 'Recargar';

  @override
  String get ok => 'Aceptar';

  @override
  String get home => 'Inicio';

  @override
  String get devices => 'Dispositivos';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Ajustes';

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String get couldntOpenTheLink => 'No se pudo abrir el enlace.';

  @override
  String get castflowLogo => 'Logotipo de CastFlow';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get weCouldntLoadThis =>
      'No pudimos cargar esto ahora. Inténtalo de nuevo.';

  @override
  String get apps => 'Apps';

  @override
  String open(Object name) {
    return 'Abrir $name';
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
  String get up => 'Arriba';

  @override
  String get down => 'Abajo';

  @override
  String get left => 'Izquierda';

  @override
  String get right => 'Derecha';

  @override
  String get menu => 'Menú';

  @override
  String get input => 'Entrada';

  @override
  String get playPause => 'Reproducir / Pausa';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get rewind => 'Retroceder';

  @override
  String get volumeUp => 'Subir volumen';

  @override
  String get volumeDown => 'Bajar volumen';

  @override
  String get mute => 'Silenciar';

  @override
  String connectedTo(Object name) {
    return 'Conectado a $name';
  }

  @override
  String get chooseADevice => 'Elige un dispositivo';

  @override
  String get connectionGuide => 'Guía de conexión';

  @override
  String get lookingForTvsOn => 'Buscando TVs en tu Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return '$found encontrados hasta ahora';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found dispositivos encontrados';
  }

  @override
  String get disconnect => 'Desconectar';

  @override
  String signalOf4(Object level) {
    return 'Señal $level de 4';
  }

  @override
  String get connecting2 => 'Conectando';

  @override
  String get theTvRemoteNeeds =>
      'El mando de la TV necesita una TV conectada. Elige una abajo.';

  @override
  String get connectToATv => 'Conéctate a una TV para continuar.';

  @override
  String get findingTvs => 'Buscando TVs…';

  @override
  String get makeSureYourTv => 'Asegúrate de que tu TV esté encendida';

  @override
  String get notConnected => 'Sin conexión';

  @override
  String get tapToFindYour => 'Toca para buscar tu TV';

  @override
  String get connectionFailed2 => 'Error de conexión';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Toca para gestionar dispositivos';
  }

  @override
  String get joinTheSameWi => 'Conéctate al mismo Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Conecta el teléfono y la TV a la misma red Wi-Fi.';

  @override
  String get turnOnCastingOn => 'Activa la transmisión en tu TV';

  @override
  String get enableScreenMirroringMiracast =>
      'Activa Duplicar pantalla, Miracast o Google Cast en los ajustes de la TV.';

  @override
  String get scanForDevices => 'Buscar dispositivos';

  @override
  String get openDevicesInCastflow =>
      'Abre Dispositivos en CastFlow y espera unos segundos a que aparezca tu TV.';

  @override
  String get tapConnect => 'Toca Conectar';

  @override
  String get acceptThePromptOn =>
      'Acepta el aviso en tu TV si aparece. ¡Listo!';

  @override
  String get howToConnect => 'Cómo conectar';

  @override
  String get fourQuickStepsTo =>
      'Cuatro pasos rápidos para ver todo en la pantalla grande.';

  @override
  String get gotIt => 'Entendido';

  @override
  String step(Object number, Object title, Object body) {
    return 'Paso $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi de casa';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Ajustes › Conexión';

  @override
  String get inputHdmi1 => 'Entrada: HDMI 1';

  @override
  String get screenMirroring => 'Duplicar pantalla';

  @override
  String get networkHomeWiFi => 'Red: Wi-Fi de casa';

  @override
  String get livingRoomTv => 'TV del salón';

  @override
  String get allowCastflowToConnect => '¿Permitir que CastFlow se conecte?';

  @override
  String get deny => 'Rechazar';

  @override
  String get allow => 'Permitir';

  @override
  String get yourTv => 'Tu TV';

  @override
  String get findYourTv => 'Encuentra tu TV';

  @override
  String connectTo(Object name) {
    return 'Conectar con $name';
  }

  @override
  String connected2(Object label) {
    return 'Conectado · $label';
  }

  @override
  String get openTvRemote => 'Abrir mando de TV';

  @override
  String get sameWiFiNetwork => 'Misma red Wi-Fi';

  @override
  String get yourPhoneAndTv =>
      'Tu teléfono y la TV deben estar conectados al mismo Wi-Fi.';

  @override
  String get tvIsOnAnd => 'La TV está encendida y lista';

  @override
  String get turnOnScreenMirroring =>
      'Activa Duplicar pantalla, Cast o Miracast en la TV.';

  @override
  String get noVpnOrGuest => 'Sin VPN ni red de invitados';

  @override
  String get vpnsAndGuestIsolated =>
      'Las VPN y el Wi-Fi de invitados o aislado impiden que los dispositivos se vean.';

  @override
  String get localNetworkAccess => 'Acceso a la red local';

  @override
  String get allowCastflowToFind =>
      'Permite que CastFlow busque dispositivos en tu red cuando lo pida.';

  @override
  String get noTvFound => 'No se encontró ninguna TV';

  @override
  String get checkThatYourPhone =>
      'Comprueba que el teléfono y la TV estén en el mismo Wi-Fi y vuelve a buscar.';

  @override
  String get noWiFiRouter => '¿Sin router Wi-Fi? Usa tu punto de acceso';

  @override
  String searchingForTvsFound(Object length) {
    return 'Buscando TVs. $length encontradas.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TVs encontradas';
  }

  @override
  String get connectToYourTv => 'Conéctate a tu TV';

  @override
  String get connectYourPhoneAndTv =>
      'Conecta el teléfono y la TV a la misma red Wi-Fi.';

  @override
  String get turnOnTheTv =>
      'Enciende la TV y abre su entrada de Duplicar pantalla / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Toca la barra de conexión en Inicio para buscar tu TV.';

  @override
  String get tapConnectAndAccept =>
      'Toca Conectar y acepta el aviso en la TV si aparece.';

  @override
  String get mirrorYourScreen => 'Duplica tu pantalla';

  @override
  String get connectToYourTvFirst => 'Primero conéctate a tu TV.';

  @override
  String get openScreenMirroringFrom => 'Abre Duplicar pantalla desde Inicio.';

  @override
  String get pickAQualityAnd => 'Elige una calidad y toca Iniciar.';

  @override
  String get allowScreenCaptureWhen =>
      'Permite la captura de pantalla cuando Android lo pida.';

  @override
  String get castPhotosVideosMusic => 'Transmite fotos, vídeos y música';

  @override
  String get openPhotosVideosOr => 'Abre Fotos, Vídeos o Música en Inicio.';

  @override
  String get pickWhatYouWant => 'Elige lo que quieres mostrar.';

  @override
  String get itPlaysOnThe =>
      'Se reproduce en la TV; contrólalo desde el teléfono o la notificación.';

  @override
  String get useTheTvRemote => 'Usa el mando de la TV';

  @override
  String get openTvRemoteOn => 'Abre Mando de TV en Inicio.';

  @override
  String get useTheDPad =>
      'Usa la cruceta o desliza en el panel táctil para moverte y toca OK para elegir.';

  @override
  String get buttonsATvDoesnt =>
      'Los botones que la TV no admite aparecen en gris.';

  @override
  String get castFromTheWeb => 'Transmite desde la web y apps';

  @override
  String get tapTheBrowserBar =>
      'Toca la barra del navegador o una app en Inicio.';

  @override
  String get playAVideoOn => 'Reproduce un vídeo en el sitio.';

  @override
  String get tapCastThisVideo =>
      'Toca «Transmitir este vídeo» para enviarlo a tu TV.';

  @override
  String get screenMirroringHelp => 'Ayuda de duplicación de pantalla';

  @override
  String get connectYourPhoneTo => 'Conecta tu teléfono al Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'En la TV, abre Ajustes → Red y únete al mismo Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Las redes de invitados u oficina suelen bloquear la duplicación; usa tu Wi-Fi de casa o el punto de acceso del teléfono.';

  @override
  String get turnOffVpn => 'Desactiva la VPN';

  @override
  String get aVpnHidesYour => 'Una VPN oculta tu TV de tu teléfono.';

  @override
  String get pauseOrDisconnectYour =>
      'Pausa o desconecta tu app de VPN antes de empezar.';

  @override
  String get youCanTurnIt => 'Puedes volver a activarla al terminar.';

  @override
  String get turnOnMirroringOn => 'Activa la duplicación en la TV';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG y la mayoría de TVs Android aceptan la duplicación automáticamente.';

  @override
  String get otherTvsOpenInput =>
      'Otras TVs: abre Entrada / Fuente y elige Duplicar pantalla o Miracast.';

  @override
  String get keepTheTvOn =>
      'Mantén la TV en esa pantalla mientras el teléfono se conecta.';

  @override
  String get tapStartAndPick => 'Toca Iniciar y elige tu TV';

  @override
  String get tapStartOnThe =>
      'Toca Iniciar en la pantalla de Duplicar pantalla.';

  @override
  String get androidOpensSmartView =>
      'Android abre Smart View / Cast. Toca tu TV en la lista.';

  @override
  String get ifTheTvAsks =>
      'Si la TV lo pide, elige Permitir o introduce el PIN que aparece en pantalla.';

  @override
  String get youreMirroring => 'Estás duplicando';

  @override
  String get everythingOnYourPhone =>
      'Todo lo que hay en tu teléfono se ve ahora en la TV.';

  @override
  String get turnThePhoneSideways =>
      'Gira el teléfono para vídeos y juegos a pantalla completa.';

  @override
  String get toStopTapStop =>
      'Para detener, toca Detener o usa la notificación de transmisión.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Desactivada';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'TV del dormitorio';

  @override
  String get officeDisplay => 'Pantalla de oficina';

  @override
  String get clearHistory => '¿Borrar historial?';

  @override
  String get thisRemovesEverythingYouve =>
      'Esto elimina de la lista todo lo que has transmitido.';

  @override
  String get clear => 'Borrar';

  @override
  String get clearHistory2 => 'Borrar historial';

  @override
  String get noHistoryYet => 'Aún no hay historial';

  @override
  String get everythingYouCastWill =>
      'Todo lo que transmitas aparecerá aquí para que lo encuentres de nuevo.';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get earlier => 'Antes';

  @override
  String get swipeAnItemTo => 'Desliza un elemento para quitarlo';

  @override
  String get delete => 'Eliminar';

  @override
  String removed(Object title) {
    return 'Se quitó «$title»';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get photos => 'Fotos';

  @override
  String get albums => 'Álbumes';

  @override
  String get videos => 'Vídeos';

  @override
  String get gallery => 'Galería';

  @override
  String get music => 'Música';

  @override
  String get songs => 'Canciones';

  @override
  String get media => 'Multimedia';

  @override
  String get browseTheWeb => 'Navegar por la web';

  @override
  String get goPro => 'Hazte Pro';

  @override
  String cast(Object title) {
    return 'Transmitir $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Duplicar pantalla. Iniciar duplicación';

  @override
  String readyToMirrorTo(Object device) {
    return 'Listo para duplicar en $device';
  }

  @override
  String get showYourPhoneOn => 'Muestra tu teléfono en la TV en tiempo real.';

  @override
  String get startMirroring => 'Iniciar duplicación';

  @override
  String get tvRemote => 'Mando de TV';

  @override
  String get controlYourTv => 'Controla tu TV';

  @override
  String get youtubeMore => 'YouTube y más';

  @override
  String get openTheBrowser => 'Abrir el navegador';

  @override
  String get searchOrTypeA => 'Busca o escribe un sitio web';

  @override
  String get howToConnectOpen => 'Cómo conectar. Abrir la guía visual';

  @override
  String get visualGuideForEvery => 'Guía visual de cada función';

  @override
  String get language => 'Idioma';

  @override
  String get done => 'Hecho';

  @override
  String get enterAValidHttp =>
      'Introduce un enlace http(s) o rtsp válido, p. ej. una URL .m3u8 o .mp4.';

  @override
  String get linkStream => 'Transmisión por enlace';

  @override
  String get iptvLinkCast => 'IPTV / Transmitir enlace';

  @override
  String get castALink => 'Transmitir un enlace';

  @override
  String get pasteADirectVideo =>
      'Pega la URL de un vídeo directo, M3U8 o transmisión IPTV.';

  @override
  String get paste => 'Pegar';

  @override
  String get castLink => 'Transmitir enlace';

  @override
  String get allowAccessToYour =>
      'Permite el acceso a tus archivos multimedia para transmitirlos. Puedes cambiarlo en Ajustes.';

  @override
  String get video => 'Vídeo';

  @override
  String get castMusic => 'Transmitir música';

  @override
  String get noMusicFound => 'No se encontró música';

  @override
  String get addSongsToYour =>
      'Añade canciones a tu teléfono y aparecerán aquí.';

  @override
  String get shuffle => 'Aleatorio';

  @override
  String get playAll => 'Reproducir todo';

  @override
  String photo(Object formatShortDate) {
    return 'Foto · $formatShortDate';
  }

  @override
  String get photo2 => 'Foto';

  @override
  String get castPhotos => 'Transmitir fotos';

  @override
  String get select => 'Seleccionar';

  @override
  String get noPhotosHere => 'No hay fotos aquí';

  @override
  String get photosYouTakeOr =>
      'Las fotos que hagas o guardes aparecerán en este álbum.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count fotos';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Foto del $formatShortDate';
  }

  @override
  String get allPhotos => 'Todas las fotos';

  @override
  String get slideshow => 'Presentación';

  @override
  String get interval => 'Intervalo';

  @override
  String get transition => 'Transición';

  @override
  String get fade => 'Fundido';

  @override
  String get slide => 'Deslizar';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Iniciar presentación';

  @override
  String get castVideos => 'Transmitir vídeos';

  @override
  String get noVideosYet => 'Aún no hay vídeos';

  @override
  String get videosYouRecordOr =>
      'Los vídeos que grabes o descargues aparecerán aquí, listos para transmitir.';

  @override
  String video2(Object resolution) {
    return 'Vídeo · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Transmitir';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Sesión de duplicación de pantalla';

  @override
  String get mirroringDidntStartTap =>
      'La duplicación no se inició. Toca Iniciar de nuevo y elige tu TV en la lista.';

  @override
  String get openSmartViewOr =>
      'Abre Smart View o Cast desde los ajustes rápidos del teléfono para duplicar.';

  @override
  String get quality => 'Calidad';

  @override
  String get adjustsToYourWi =>
      'Se adapta a tu Wi-Fi para una imagen más fluida.';

  @override
  String upToLowerIt(Object label) {
    return 'Hasta $label. Bájala si la imagen se entrecorta.';
  }

  @override
  String get stillNeedHelp => '¿Necesitas ayuda?';

  @override
  String get startingScreenMirroring => 'Iniciando duplicación de pantalla…';

  @override
  String mirroringTo(Object value) {
    return 'Duplicando en $value';
  }

  @override
  String get stopping => 'Deteniendo…';

  @override
  String get readyToMirror => 'Listo para duplicar';

  @override
  String get beforeYouStart => 'Antes de empezar';

  @override
  String get phoneAndTvAre => 'El teléfono y la TV están en el mismo Wi-Fi';

  @override
  String get noVpnIsConnected => 'No hay ninguna VPN conectada en tu teléfono';

  @override
  String get tvIsOnWith =>
      'La TV está encendida con Duplicar pantalla activado';

  @override
  String get phoneIsCloseTo => 'El teléfono está cerca de la TV';

  @override
  String get stopMirroring => 'Detener duplicación';

  @override
  String get startMirroring2 => 'Iniciar duplicación';

  @override
  String get stop => 'Detener';

  @override
  String get start => 'Iniciar';

  @override
  String get duration => 'Duración';

  @override
  String get adIsLoading => 'Cargando anuncio';

  @override
  String get ad => 'Anuncio';

  @override
  String get mirrorYourScreenTo => 'Duplica tu pantalla en cualquier TV';

  @override
  String get showYourPhoneOnThe =>
      'Muestra tu teléfono en la pantalla grande con un toque: sin cables ni complicaciones.';

  @override
  String get shareMemoriesWithThe =>
      'Comparte recuerdos con toda la sala y mantén el control desde tu teléfono.';

  @override
  String get castFromWebApps => 'Transmite desde la web y apps';

  @override
  String get sendVideosFromYoutube =>
      'Envía vídeos de YouTube, Facebook y cualquier sitio web directo a tu TV.';

  @override
  String pageOf(Object value, Object length) {
    return 'Página $value de $length';
  }

  @override
  String get getStarted => 'Empezar';

  @override
  String get localNetwork => 'Red local';

  @override
  String get findTvsAndStreaming =>
      'Encuentra TVs y dispositivos de streaming en tu Wi-Fi.';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get showCastingControlsWhile =>
      'Muestra los controles de transmisión mientras usas otras apps.';

  @override
  String get photosVideosMusic => 'Fotos, vídeos y música';

  @override
  String get pickWhatYouWantTo =>
      'Elige lo que quieres transmitir de tu galería y biblioteca.';

  @override
  String get screenCapture => 'Captura de pantalla';

  @override
  String get mirrorYourScreenYoull =>
      'Duplica tu pantalla. Confirmarás cada sesión.';

  @override
  String get webVideo => 'Vídeo web';

  @override
  String get link => 'Enlace';

  @override
  String get screenMirroring2 => 'Duplicación de pantalla';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Transmitiendo $title. Abrir mando';
  }

  @override
  String castingTo2(Object value) {
    return 'Transmitiendo a $value';
  }

  @override
  String get nowCasting => 'Transmitiendo ahora';

  @override
  String get nothingIsCasting => 'No se está transmitiendo nada';

  @override
  String get pickAPhotoVideo =>
      'Elige una foto, vídeo, canción o vídeo web para enviarlo a tu TV.';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String slide2(Object formatDuration) {
    return 'Diapositiva $formatDuration';
  }

  @override
  String get back10Seconds => 'Retroceder 10 segundos';

  @override
  String get forward10Seconds => 'Avanzar 10 segundos';

  @override
  String get tvVolume => 'Volumen de la TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Volumen de la TV $round por ciento';
  }

  @override
  String get upNext => 'A continuación';

  @override
  String get addPhotos => 'Añadir fotos';

  @override
  String get addVideos => 'Añadir vídeos';

  @override
  String get nothingElseInThe => 'No hay nada más en la cola.';

  @override
  String play2(Object title) {
    return 'Reproducir $title';
  }

  @override
  String get unknownDevice => 'Dispositivo desconocido';

  @override
  String get perWeek => 'por semana';

  @override
  String get perYear => 'por año';

  @override
  String get payOnce => 'pago único';

  @override
  String get wirelessScreenMirroring => 'Duplicación de pantalla inalámbrica';

  @override
  String get castVideosPhotosMusic => 'Transmite vídeos, fotos y música';

  @override
  String get fullTvRemoteControl => 'Control remoto completo de la TV';

  @override
  String get worksWithAllMajor => 'Funciona con las principales TVs';

  @override
  String get smoothLagFreeStreaming => 'Streaming fluido y sin retrasos';

  @override
  String get noAds => 'Sin anuncios';

  @override
  String get welcomeToCastflowPro => '¡Bienvenido a CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Compra cancelada.';

  @override
  String get purchasePendingProUnlocks =>
      'Compra pendiente. Pro se activará en cuanto la tienda la confirme.';

  @override
  String get purchaseFailedPleaseTry => 'La compra falló. Inténtalo de nuevo.';

  @override
  String get theStoreIsntAvailable =>
      'La tienda no está disponible ahora mismo.';

  @override
  String get close => 'Cerrar';

  @override
  String get goProWithCastflow => 'HAZTE PRO CON CASTFLOW';

  @override
  String get unlockEveryFeature => 'Desbloquea todas las funciones';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Se renueva automáticamente hasta que lo canceles.';

  @override
  String get oneTimePurchaseNo => 'Pago único. Sin suscripción.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get cancelAnytime => 'Cancela cuando quieras';

  @override
  String get loadingPrice => 'Cargando precio…';

  @override
  String get pricesUnavailableTapTo =>
      'Precios no disponibles · Toca para reintentar';

  @override
  String get noPlansAvailableRight => 'No hay planes disponibles ahora mismo.';

  @override
  String get weekly => 'Semanal';

  @override
  String get yearly => 'Anual';

  @override
  String get lifetime => 'De por vida';

  @override
  String get bestValue => 'Mejor valor';

  @override
  String get disconnectFromTv => '¿Desconectar de la TV?';

  @override
  String get thisStopsWhatIs =>
      'Esto detiene lo que se está reproduciendo o duplicando.';

  @override
  String get useTouchpad => 'Usar panel táctil';

  @override
  String get useDPad => 'Usar cruceta';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Los receptores $label no aceptan comandos remotos.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Algunos botones no están disponibles en $label.';
  }

  @override
  String get idle => 'INACTIVO';

  @override
  String get playing => 'REPRODUCIENDO';

  @override
  String get paused => 'EN PAUSA';

  @override
  String get noTvConnected => 'Sin TV conectada';

  @override
  String get mute2 => 'SILENCIO';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Sin TV conectada. Toca para elegir un dispositivo';

  @override
  String get tapToChooseA => 'Toca para elegir un dispositivo';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label no es compatible con $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Panel táctil. Desliza para mover, toca para seleccionar.';

  @override
  String get swipeToMoveTap => 'Desliza para mover · Toca para seleccionar';

  @override
  String get navigationIsntSupportedBy => 'Esta TV no admite la navegación';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automático';

  @override
  String get googleCastFirst => 'Google Cast primero';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP primero';

  @override
  String get miracastFirst => 'Miracast primero';

  @override
  String get tvOnly => 'Solo TV';

  @override
  String get phoneAndTv => 'Teléfono y TV';

  @override
  String get phoneOnly => 'Solo teléfono';

  @override
  String get touchpad => 'Panel táctil';

  @override
  String get doMyPhoneAnd => '¿Mi teléfono y la TV necesitan el mismo Wi-Fi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Sí. La búsqueda y la transmisión se quedan en tu red local, así que ambos deben estar en el mismo Wi-Fi (nombres de banda parecidos pueden ser redes distintas).';

  @override
  String get myRouterHasAp => 'Mi router tiene «aislamiento AP / de clientes»';

  @override
  String get isolationBlocksDevicesFrom =>
      'El aislamiento impide que los dispositivos se vean entre sí. Desactívalo en los ajustes del router o usa una red que no sea de invitados.';

  @override
  String get findingYourTv => 'Encontrar tu TV';

  @override
  String get myTvDoesntAppear => 'Mi TV no aparece en la lista';

  @override
  String get turnOnCastingScreen =>
      'Activa la transmisión / duplicación en la TV, sácala del modo de espera y toca Buscar de nuevo. Permite el permiso de red local si se pide.';

  @override
  String get onlySomeDevicesShow => 'Solo aparecen algunos dispositivos';

  @override
  String get olderTvsMayNeed =>
      'Las TVs antiguas pueden necesitar una actualización de firmware. Las TVs Miracast solo aparecen mientras su entrada «Duplicar pantalla» está abierta.';

  @override
  String get connectionFailsOrTimes => 'La conexión falla o se agota el tiempo';

  @override
  String get restartTheTvApp =>
      'Reinicia la app de la TV o la TV, acércate al router y acepta cualquier aviso que aparezca en la pantalla de la TV.';

  @override
  String get itKeepsReconnectingTo => 'Sigue reconectándose a una TV antigua';

  @override
  String get turnOffAutoConnect =>
      'Desactiva «Conectar automáticamente a la última TV» en Ajustes → Transmisión.';

  @override
  String get mirroringIsLaggy => 'La duplicación va con retraso';

  @override
  String get chooseALowerQuality =>
      'Elige una calidad menor (720p o 480p), cierra apps pesadas y usa una red Wi-Fi de 5 GHz.';

  @override
  String get thePictureIsRotated => 'La imagen está girada o recortada';

  @override
  String get toggleAutoRotateOn =>
      'Activa o desactiva Rotación automática en la pantalla de Duplicar pantalla.';

  @override
  String get sound => 'Sonido';

  @override
  String get thereIsNoSound => 'No hay sonido en la TV';

  @override
  String get makeSureAudioIs =>
      'Comprueba que el audio esté activado en Duplicar pantalla y revisa Ajustes → Transmisión → Salida de audio. Algunos receptores no admiten el audio del teléfono.';

  @override
  String get tvRemote2 => 'Mando de TV';

  @override
  String get someRemoteButtonsAre =>
      'Algunos botones del mando aparecen en gris';

  @override
  String get eachReceiverSupportsDifferent =>
      'Cada receptor admite comandos distintos. Chromecast y DLNA solo admiten reproducción y volumen; Miracast no tiene canal de mando.';

  @override
  String get canCastflowTurnMy =>
      '¿Puede CastFlow encender mi TV o cambiar de entrada?';

  @override
  String get onlyOnTvsThat =>
      'Solo en TVs que ofrecen esos comandos por la red. Los botones no compatibles se desactivan en lugar de fingir que funcionan.';

  @override
  String get helpFaq => 'Ayuda y preguntas frecuentes';

  @override
  String get stepByStepConnection => 'Guía de conexión paso a paso';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'No se encontró ninguna app de correo.';

  @override
  String get enjoyingCastflow => '¿Te gusta CastFlow?';

  @override
  String get sorryToHearThat => 'Lamentamos oír eso';

  @override
  String get thanksHowCanWe => '¡Gracias! ¿Cómo podemos mejorar?';

  @override
  String get wereGladYouLike => '¡Nos alegra que te guste!';

  @override
  String get youMadeOurDay => '¡Nos has alegrado el día!';

  @override
  String get tapToExit => 'Toca para salir';

  @override
  String get selectARating => 'Selecciona una valoración';

  @override
  String get sendFeedback => 'Enviar comentarios';

  @override
  String get rateUs => 'Valóranos';

  @override
  String get rateYourExperienceBefore => 'Valora tu experiencia antes de irte.';

  @override
  String get tapAStarTo => 'Toca una estrella para valorar CastFlow.';

  @override
  String get general => 'General';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Calidad predeterminada';

  @override
  String get autoConnectToLast => 'Conectar automáticamente a la última TV';

  @override
  String get hapticFeedback => 'Respuesta háptica';

  @override
  String get clearCastingHistory => 'Borrar historial de transmisión';

  @override
  String get clearCastingHistory2 => '¿Borrar historial de transmisión?';

  @override
  String get onlyCastflowsListIs =>
      'Solo se borra la lista de CastFlow. Nunca se elimina contenido de tu teléfono.';

  @override
  String get appearance => 'Apariencia';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get aboutSupport => 'Acerca de y soporte';

  @override
  String get rateApp => 'Valorar la app';

  @override
  String get feedback => 'Comentarios';

  @override
  String get termsConditions => 'Términos y condiciones';

  @override
  String get version => 'Versión';

  @override
  String get castflowProIsActive => 'CastFlow Pro está activo';

  @override
  String get upgradeToPremium => 'Pásate a Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Gracias por tu apoyo. Disfruta de transmisión sin anuncios.';

  @override
  String get noAds1080pMirroring =>
      'Sin anuncios, duplicación 1080p y transmisión ilimitada';

  @override
  String get upgrade => 'Mejorar';

  @override
  String get mirrorCastBeautifullySimple =>
      'Duplica y transmite, de forma sencilla';

  @override
  String get thisActionMayContain => 'Esta acción puede contener anuncios';

  @override
  String get webCast => 'Transmisión web';

  @override
  String get castThisVideo => 'Transmitir este vídeo';

  @override
  String get searchOrTypeAWeb => 'Busca o escribe una dirección web';

  @override
  String get removeBookmark => 'Quitar marcador';

  @override
  String get bookmark => 'Marcador';

  @override
  String get quickAccess => 'Acceso rápido';

  @override
  String open2(Object title) {
    return 'Abrir $title';
  }

  @override
  String get bookmarks => 'Marcadores';

  @override
  String get noBookmarks => 'Sin marcadores';

  @override
  String get tapTheBookmarkIcon =>
      'Toca el icono de marcador en la barra de direcciones para guardar una página.';

  @override
  String get noHistory => 'Sin historial';

  @override
  String get pagesYouVisitShow => 'Las páginas que visites aparecerán aquí.';

  @override
  String get remove => 'Quitar';

  @override
  String resultOn(Object value, Object host) {
    return 'Resultado $value en $host';
  }

  @override
  String get aSimulatedPageResult => 'Un resultado de página simulado';

  @override
  String get videosOnThisPage => 'Vídeos en esta página';

  @override
  String get pickOneToSend => 'Elige uno para enviarlo a tu TV.';

  @override
  String get onboardHotspotTitle => '¿Sin Wi-Fi? Usa tu punto de acceso';

  @override
  String get onboardHotspotBody =>
      'Activa el punto de acceso de tu teléfono y conecta tu TV. La transmisión funciona igual que con Wi-Fi.';

  @override
  String get stillCantFindTitle => '¿Aún no encuentras tu TV?';

  @override
  String get stillCantFindBody =>
      'Conecta tu TV al punto de acceso de tu teléfono:';

  @override
  String get hotspotStep4 => 'Toca Reintentar y elige tu TV en la lista';

  @override
  String get castOverHotspot =>
      '¿Sin Wi-Fi? Transmite con el punto de acceso de tu teléfono:';

  @override
  String get queue => 'Cola';

  @override
  String get addMusic => 'Añadir música';

  @override
  String get connectWithWifi => 'Conectar con Wi-Fi';

  @override
  String get continueWithHotspot => 'Continuar con punto de acceso';

  @override
  String get noWifiAlertMessage =>
      'Estás usando datos móviles. Conecta el teléfono y la TV a la misma Wi-Fi, o activa el punto de acceso del teléfono y conéctalo desde la TV.';
}
