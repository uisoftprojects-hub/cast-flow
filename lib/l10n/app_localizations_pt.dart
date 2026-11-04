// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get networkRequiredTitle => 'Sem conexão Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Seu celular e a TV precisam estar na mesma rede Wi-Fi para transmitir.';

  @override
  String get openWifiSettings => 'Abrir configurações de Wi-Fi';

  @override
  String get useMobileHotspot => 'Usar ponto de acesso móvel';

  @override
  String get hotspotInstruction => 'Conecte sua TV ao ponto de acesso móvel.';

  @override
  String get hotspotStep1 => 'Ative o ponto de acesso móvel';

  @override
  String get hotspotStep2 => 'Conecte sua TV a ele';

  @override
  String get hotspotStep3 => 'Volte ao app';

  @override
  String get openHotspotSettings => 'Abrir configurações do ponto de acesso';

  @override
  String get hotspotAutoCheck =>
      'Verificaremos de novo automaticamente quando você voltar.';

  @override
  String get hotspotDetected => 'Ponto de acesso ativo. Procurando sua TV…';

  @override
  String get searchingDevices => 'Procurando dispositivos próximos...';

  @override
  String get waitingForTvOnHotspot =>
      'Aguardando sua TV entrar no ponto de acesso…';

  @override
  String get usingHotspot => 'Usando seu ponto de acesso móvel';

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
  String get retry => 'Tentar novamente';

  @override
  String get scanAgain => 'Procurar de novo';

  @override
  String get isolationTitle => 'A TV não responde';

  @override
  String get isolationHint =>
      'Um dispositivo entrou no seu ponto de acesso, mas não responde. O ponto de acesso pode estar bloqueando o tráfego entre dispositivos (isolamento de clientes). Desative isso nas configurações do ponto de acesso ou use uma rede Wi-Fi.';

  @override
  String get connecting => 'Conectando…';

  @override
  String get connected => 'Conectado';

  @override
  String get connectionFailed => 'Não foi possível conectar';

  @override
  String get connectFailedHint =>
      'Verifique se o celular e a TV estão na mesma rede e tente de novo.';

  @override
  String get hotspotConnectHint =>
      'Seu ponto de acesso pode estar bloqueando o tráfego entre dispositivos. Verifique o isolamento de clientes.';

  @override
  String get networkLostTitle => 'Conexão de rede perdida';

  @override
  String get networkLostMessage =>
      'Reconecte ao Wi-Fi ou ao ponto de acesso e depois reconecte à TV.';

  @override
  String get reconnect => 'Reconectar';

  @override
  String reconnectTo(String name) {
    return 'Reconectar a $name';
  }

  @override
  String get tapToReconnect => 'Toque para reconectar';

  @override
  String get pairingRequired => 'Pareamento necessário';

  @override
  String get pairingEnterCode => 'Digite o código exibido na sua TV.';

  @override
  String get pairingApproveOnTv =>
      'Olhe para a TV e toque em Permitir para continuar.';

  @override
  String get connect => 'Conectar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get pairingIncorrectCode => 'Código incorreto. Tente de novo.';

  @override
  String get pairingTimedOut => 'Tempo de pareamento esgotado';

  @override
  String get tryAgain => 'Tentar de novo';

  @override
  String get pairingDeclined => 'A TV recusou a conexão';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Muitos códigos errados. Aguarde $seconds s e peça um novo código.';
  }

  @override
  String get pairingCooldownOver => 'Agora você pode pedir um novo código.';

  @override
  String get pairingRequestNewCode => 'Pedir novo código';

  @override
  String get pairingNetworkLost =>
      'A rede caiu durante o pareamento. Reconecte ao Wi-Fi e tente de novo.';

  @override
  String get pairingFailed => 'Não foi possível parear com a TV.';

  @override
  String pairingCodeField(int length) {
    return 'Código de pareamento, $length caracteres';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Caixa $index de $total';
  }

  @override
  String get pairingEmptyBox => 'vazio';

  @override
  String get pairingPaired => 'Pareado';

  @override
  String get forgetDevice => 'Esquecer dispositivo';

  @override
  String forgetDeviceMessage(String name) {
    return '$name precisará ser pareado de novo da próxima vez.';
  }

  @override
  String get forget => 'Esquecer';

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
  String get noVideoYet => 'Nenhum vídeo encontrado nesta página ainda.';

  @override
  String get videoFound => 'Vídeo encontrado';

  @override
  String get videoFoundMessage => 'Reproduza na sua TV.';

  @override
  String get castAction => 'Transmitir';

  @override
  String get dismiss => 'Dispensar';

  @override
  String videosFound(int count) {
    return 'Vídeos encontrados ($count)';
  }

  @override
  String get castToTv => 'Transmitir para a TV';

  @override
  String get protectedVideo => 'Protegido, não pode ser transmitido';

  @override
  String get videoThumbnail => 'Miniatura do vídeo';

  @override
  String castingTo(String device) {
    return 'Transmitindo para $device';
  }

  @override
  String get stopCasting => 'Parar transmissão';

  @override
  String get play => 'Reproduzir';

  @override
  String get pause => 'Pausar';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Posição da reprodução';

  @override
  String get showControls => 'Mostrar controles';

  @override
  String get hideControls => 'Ocultar controles';

  @override
  String get formatUnsupportedTitle => 'Formato não compatível';

  @override
  String formatUnsupported(String device, String format) {
    return '$device não reproduz vídeos $format. Tente outro vídeo desta página ou use o espelhamento de tela.';
  }

  @override
  String get videoExpired =>
      'O link do vídeo expirou. Recarregue a página e tente de novo.';

  @override
  String get refreshingVideo => 'Obtendo um novo link de vídeo…';

  @override
  String get browserBack => 'Voltar';

  @override
  String get browserForward => 'Avançar';

  @override
  String get browserStartPage => 'Página inicial';

  @override
  String get browserReload => 'Recarregar';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Início';

  @override
  String get devices => 'Dispositivos';

  @override
  String get history => 'Histórico';

  @override
  String get settings => 'Configurações';

  @override
  String get goodMorning => 'Bom dia';

  @override
  String get goodAfternoon => 'Boa tarde';

  @override
  String get goodEvening => 'Boa noite';

  @override
  String get couldntOpenTheLink => 'Não foi possível abrir o link.';

  @override
  String get castflowLogo => 'Logotipo do CastFlow';

  @override
  String get somethingWentWrong => 'Algo deu errado';

  @override
  String get weCouldntLoadThis =>
      'Não foi possível carregar isso agora. Tente de novo.';

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
  String get up => 'Para cima';

  @override
  String get down => 'Para baixo';

  @override
  String get left => 'Esquerda';

  @override
  String get right => 'Direita';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Entrada';

  @override
  String get playPause => 'Reproduzir / Pausar';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Próximo';

  @override
  String get rewind => 'Retroceder';

  @override
  String get volumeUp => 'Aumentar volume';

  @override
  String get volumeDown => 'Diminuir volume';

  @override
  String get mute => 'Mudo';

  @override
  String connectedTo(Object name) {
    return 'Conectado a $name';
  }

  @override
  String get chooseADevice => 'Escolha um dispositivo';

  @override
  String get connectionGuide => 'Guia de conexão';

  @override
  String get lookingForTvsOn => 'Procurando TVs no seu Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return '$found encontrados até agora';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found dispositivos encontrados';
  }

  @override
  String get disconnect => 'Desconectar';

  @override
  String signalOf4(Object level) {
    return 'Sinal $level de 4';
  }

  @override
  String get connecting2 => 'Conectando';

  @override
  String get theTvRemoteNeeds =>
      'O controle remoto precisa de uma TV conectada. Escolha uma abaixo.';

  @override
  String get connectToATv => 'Conecte-se a uma TV para continuar.';

  @override
  String get findingTvs => 'Procurando TVs…';

  @override
  String get makeSureYourTv => 'Verifique se a TV está ligada';

  @override
  String get notConnected => 'Não conectado';

  @override
  String get tapToFindYour => 'Toque para encontrar sua TV';

  @override
  String get connectionFailed2 => 'Falha na conexão';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Toque para gerenciar dispositivos';
  }

  @override
  String get joinTheSameWi => 'Entre no mesmo Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Conecte o celular e a TV à mesma rede Wi-Fi.';

  @override
  String get turnOnCastingOn => 'Ative a transmissão na TV';

  @override
  String get enableScreenMirroringMiracast =>
      'Ative Espelhamento de tela, Miracast ou Google Cast nas configurações da TV.';

  @override
  String get scanForDevices => 'Procurar dispositivos';

  @override
  String get openDevicesInCastflow =>
      'Abra Dispositivos no CastFlow e aguarde alguns segundos para a TV aparecer.';

  @override
  String get tapConnect => 'Toque em Conectar';

  @override
  String get acceptThePromptOn => 'Aceite o aviso na TV, se aparecer. Pronto!';

  @override
  String get howToConnect => 'Como conectar';

  @override
  String get fourQuickStepsTo =>
      'Quatro passos rápidos para ir para a tela grande.';

  @override
  String get gotIt => 'Entendi';

  @override
  String step(Object number, Object title, Object body) {
    return 'Passo $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi de casa';

  @override
  String get router => 'Roteador';

  @override
  String get settingsConnection => 'Configurações › Conexão';

  @override
  String get inputHdmi1 => 'Entrada: HDMI 1';

  @override
  String get screenMirroring => 'Espelhamento de tela';

  @override
  String get networkHomeWiFi => 'Rede: Wi-Fi de casa';

  @override
  String get livingRoomTv => 'TV da sala';

  @override
  String get allowCastflowToConnect => 'Permitir que o CastFlow se conecte?';

  @override
  String get deny => 'Negar';

  @override
  String get allow => 'Permitir';

  @override
  String get yourTv => 'Sua TV';

  @override
  String get findYourTv => 'Encontre sua TV';

  @override
  String connectTo(Object name) {
    return 'Conectar a $name';
  }

  @override
  String connected2(Object label) {
    return 'Conectado · $label';
  }

  @override
  String get openTvRemote => 'Abrir controle da TV';

  @override
  String get sameWiFiNetwork => 'Mesma rede Wi-Fi';

  @override
  String get yourPhoneAndTv =>
      'Seu celular e a TV precisam estar conectados ao mesmo Wi-Fi.';

  @override
  String get tvIsOnAnd => 'A TV está ligada e pronta';

  @override
  String get turnOnScreenMirroring =>
      'Ative Espelhamento de tela, Cast ou Miracast na TV.';

  @override
  String get noVpnOrGuest => 'Sem VPN nem rede de convidados';

  @override
  String get vpnsAndGuestIsolated =>
      'VPNs e Wi-Fi de convidados ou isolado impedem que os dispositivos se vejam.';

  @override
  String get localNetworkAccess => 'Acesso à rede local';

  @override
  String get allowCastflowToFind =>
      'Permita que o CastFlow encontre dispositivos na sua rede quando solicitado.';

  @override
  String get noTvFound => 'Nenhuma TV encontrada';

  @override
  String get checkThatYourPhone =>
      'Verifique se o celular e a TV estão no mesmo Wi-Fi e procure de novo.';

  @override
  String get noWiFiRouter => 'Sem roteador Wi-Fi? Use seu ponto de acesso';

  @override
  String searchingForTvsFound(Object length) {
    return 'Procurando TVs. $length encontradas.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TVs encontradas';
  }

  @override
  String get connectToYourTv => 'Conecte-se à sua TV';

  @override
  String get connectYourPhoneAndTv =>
      'Conecte o celular e a TV à mesma rede Wi-Fi.';

  @override
  String get turnOnTheTv =>
      'Ligue a TV e abra a entrada de Espelhamento de tela / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Toque na barra de conexão no Início para encontrar sua TV.';

  @override
  String get tapConnectAndAccept =>
      'Toque em Conectar e aceite o aviso na TV, se aparecer.';

  @override
  String get mirrorYourScreen => 'Espelhe sua tela';

  @override
  String get connectToYourTvFirst => 'Conecte-se primeiro à sua TV.';

  @override
  String get openScreenMirroringFrom => 'Abra Espelhamento de tela no Início.';

  @override
  String get pickAQualityAnd => 'Escolha uma qualidade e toque em Iniciar.';

  @override
  String get allowScreenCaptureWhen =>
      'Permita a captura de tela quando o Android pedir.';

  @override
  String get castPhotosVideosMusic => 'Transmita fotos, vídeos e músicas';

  @override
  String get openPhotosVideosOr => 'Abra Fotos, Vídeos ou Música no Início.';

  @override
  String get pickWhatYouWant => 'Escolha o que quer mostrar.';

  @override
  String get itPlaysOnThe =>
      'Toca na TV; controle pelo celular ou pela notificação.';

  @override
  String get useTheTvRemote => 'Use o controle remoto da TV';

  @override
  String get openTvRemoteOn => 'Abra Controle da TV no Início.';

  @override
  String get useTheDPad =>
      'Use o direcional ou deslize no touchpad para mover e toque em OK para selecionar.';

  @override
  String get buttonsATvDoesnt => 'Botões que a TV não suporta ficam cinza.';

  @override
  String get castFromTheWeb => 'Transmita da web e de apps';

  @override
  String get tapTheBrowserBar =>
      'Toque na barra do navegador ou em um app no Início.';

  @override
  String get playAVideoOn => 'Reproduza um vídeo no site.';

  @override
  String get tapCastThisVideo =>
      'Toque em “Transmitir este vídeo” para enviar à TV.';

  @override
  String get screenMirroringHelp => 'Ajuda com espelhamento de tela';

  @override
  String get connectYourPhoneTo => 'Conecte o celular ao Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Na TV, abra Configurações → Rede e entre no mesmo Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Redes de convidados ou de escritório costumam bloquear o espelhamento; use o Wi-Fi de casa ou o ponto de acesso do celular.';

  @override
  String get turnOffVpn => 'Desative a VPN';

  @override
  String get aVpnHidesYour => 'Uma VPN esconde sua TV do celular.';

  @override
  String get pauseOrDisconnectYour =>
      'Pause ou desconecte o app de VPN antes de começar.';

  @override
  String get youCanTurnIt => 'Você pode reativá-la quando terminar.';

  @override
  String get turnOnMirroringOn => 'Ative o espelhamento na TV';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG e a maioria das TVs Android aceitam o espelhamento automaticamente.';

  @override
  String get otherTvsOpenInput =>
      'Outras TVs: abra Entrada / Fonte e escolha Espelhamento de tela ou Miracast.';

  @override
  String get keepTheTvOn =>
      'Mantenha a TV nessa tela enquanto o celular conecta.';

  @override
  String get tapStartAndPick => 'Toque em Iniciar e escolha sua TV';

  @override
  String get tapStartOnThe =>
      'Toque em Iniciar na tela de Espelhamento de tela.';

  @override
  String get androidOpensSmartView =>
      'O Android abre o Smart View / Cast. Toque na sua TV na lista.';

  @override
  String get ifTheTvAsks =>
      'Se a TV pedir, escolha Permitir ou digite o PIN mostrado na tela.';

  @override
  String get youreMirroring => 'Você está espelhando';

  @override
  String get everythingOnYourPhone =>
      'Tudo no seu celular agora aparece na TV.';

  @override
  String get turnThePhoneSideways =>
      'Gire o celular para vídeos e jogos em tela cheia.';

  @override
  String get toStopTapStop =>
      'Para parar, toque em Parar ou use a notificação de transmissão.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Desligado';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'TV do quarto';

  @override
  String get officeDisplay => 'Tela do escritório';

  @override
  String get clearHistory => 'Limpar histórico?';

  @override
  String get thisRemovesEverythingYouve =>
      'Isso remove da lista tudo o que você transmitiu.';

  @override
  String get clear => 'Limpar';

  @override
  String get clearHistory2 => 'Limpar histórico';

  @override
  String get noHistoryYet => 'Nenhum histórico ainda';

  @override
  String get everythingYouCastWill =>
      'Tudo o que você transmitir aparecerá aqui para encontrar de novo.';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get earlier => 'Antes';

  @override
  String get swipeAnItemTo => 'Deslize um item para remover';

  @override
  String get delete => 'Excluir';

  @override
  String removed(Object title) {
    return '“$title” removido';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String get photos => 'Fotos';

  @override
  String get albums => 'Álbuns';

  @override
  String get videos => 'Vídeos';

  @override
  String get gallery => 'Galeria';

  @override
  String get music => 'Música';

  @override
  String get songs => 'Músicas';

  @override
  String get media => 'Mídia';

  @override
  String get browseTheWeb => 'Navegar na web';

  @override
  String get goPro => 'Seja Pro';

  @override
  String cast(Object title) {
    return 'Transmitir $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Espelhamento de tela. Iniciar espelhamento';

  @override
  String readyToMirrorTo(Object device) {
    return 'Pronto para espelhar em $device';
  }

  @override
  String get showYourPhoneOn => 'Mostre seu celular na TV em tempo real.';

  @override
  String get startMirroring => 'Iniciar espelhamento';

  @override
  String get tvRemote => 'Controle da TV';

  @override
  String get controlYourTv => 'Controle sua TV';

  @override
  String get youtubeMore => 'YouTube e mais';

  @override
  String get openTheBrowser => 'Abrir o navegador';

  @override
  String get searchOrTypeA => 'Pesquise ou digite um site';

  @override
  String get howToConnectOpen => 'Como conectar. Abrir o guia visual';

  @override
  String get visualGuideForEvery => 'Guia visual de cada recurso';

  @override
  String get language => 'Idioma';

  @override
  String get done => 'Concluído';

  @override
  String get enterAValidHttp =>
      'Digite um link http(s) ou rtsp válido, por exemplo uma URL .m3u8 ou .mp4.';

  @override
  String get linkStream => 'Transmissão por link';

  @override
  String get iptvLinkCast => 'IPTV / Transmitir link';

  @override
  String get castALink => 'Transmitir um link';

  @override
  String get pasteADirectVideo =>
      'Cole a URL de um vídeo direto, M3U8 ou transmissão IPTV.';

  @override
  String get paste => 'Colar';

  @override
  String get castLink => 'Transmitir link';

  @override
  String get allowAccessToYour =>
      'Permita o acesso à sua mídia para transmiti-la. Você pode mudar isso em Configurações.';

  @override
  String get video => 'Vídeo';

  @override
  String get castMusic => 'Transmitir música';

  @override
  String get noMusicFound => 'Nenhuma música encontrada';

  @override
  String get addSongsToYour =>
      'Adicione músicas ao celular e elas aparecerão aqui.';

  @override
  String get shuffle => 'Aleatório';

  @override
  String get playAll => 'Reproduzir tudo';

  @override
  String photo(Object formatShortDate) {
    return 'Foto · $formatShortDate';
  }

  @override
  String get photo2 => 'Foto';

  @override
  String get castPhotos => 'Transmitir fotos';

  @override
  String get select => 'Selecionar';

  @override
  String get noPhotosHere => 'Nenhuma foto aqui';

  @override
  String get photosYouTakeOr =>
      'As fotos que você tirar ou salvar aparecerão neste álbum.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count fotos';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Foto de $formatShortDate';
  }

  @override
  String get allPhotos => 'Todas as fotos';

  @override
  String get slideshow => 'Apresentação';

  @override
  String get interval => 'Intervalo';

  @override
  String get transition => 'Transição';

  @override
  String get fade => 'Esmaecer';

  @override
  String get slide => 'Deslizar';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Iniciar apresentação';

  @override
  String get castVideos => 'Transmitir vídeos';

  @override
  String get noVideosYet => 'Nenhum vídeo ainda';

  @override
  String get videosYouRecordOr =>
      'Vídeos que você gravar ou baixar aparecerão aqui, prontos para transmitir.';

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
  String get screenMirroringSession => 'Sessão de espelhamento de tela';

  @override
  String get mirroringDidntStartTap =>
      'O espelhamento não iniciou. Toque em Iniciar de novo e escolha sua TV na lista.';

  @override
  String get openSmartViewOr =>
      'Abra o Smart View ou Cast nas configurações rápidas do celular para espelhar.';

  @override
  String get quality => 'Qualidade';

  @override
  String get adjustsToYourWi =>
      'Se ajusta ao seu Wi-Fi para uma imagem mais fluida.';

  @override
  String upToLowerIt(Object label) {
    return 'Até $label. Reduza se a imagem travar.';
  }

  @override
  String get stillNeedHelp => 'Precisa de ajuda?';

  @override
  String get startingScreenMirroring => 'Iniciando espelhamento de tela…';

  @override
  String mirroringTo(Object value) {
    return 'Espelhando em $value';
  }

  @override
  String get stopping => 'Parando…';

  @override
  String get readyToMirror => 'Pronto para espelhar';

  @override
  String get beforeYouStart => 'Antes de começar';

  @override
  String get phoneAndTvAre => 'Celular e TV estão no mesmo Wi-Fi';

  @override
  String get noVpnIsConnected => 'Nenhuma VPN está conectada no celular';

  @override
  String get tvIsOnWith => 'A TV está ligada com Espelhamento de tela ativado';

  @override
  String get phoneIsCloseTo => 'O celular está perto da TV';

  @override
  String get stopMirroring => 'Parar espelhamento';

  @override
  String get startMirroring2 => 'Iniciar espelhamento';

  @override
  String get stop => 'Parar';

  @override
  String get start => 'Iniciar';

  @override
  String get duration => 'Duração';

  @override
  String get adIsLoading => 'Carregando anúncio';

  @override
  String get ad => 'Anúncio';

  @override
  String get mirrorYourScreenTo => 'Espelhe sua tela em qualquer TV';

  @override
  String get showYourPhoneOnThe =>
      'Mostre seu celular na tela grande com um toque, sem cabos nem complicação.';

  @override
  String get shareMemoriesWithThe =>
      'Compartilhe memórias com a sala toda e mantenha o controle pelo celular.';

  @override
  String get castFromWebApps => 'Transmita da web e de apps';

  @override
  String get sendVideosFromYoutube =>
      'Envie vídeos do YouTube, Facebook e de qualquer site direto para a TV.';

  @override
  String pageOf(Object value, Object length) {
    return 'Página $value de $length';
  }

  @override
  String get getStarted => 'Começar';

  @override
  String get localNetwork => 'Rede local';

  @override
  String get findTvsAndStreaming =>
      'Encontre TVs e dispositivos de streaming no seu Wi-Fi.';

  @override
  String get notifications => 'Notificações';

  @override
  String get showCastingControlsWhile =>
      'Mostre controles de transmissão enquanto usa outros apps.';

  @override
  String get photosVideosMusic => 'Fotos, vídeos e músicas';

  @override
  String get pickWhatYouWantTo =>
      'Escolha o que transmitir da sua galeria e biblioteca.';

  @override
  String get screenCapture => 'Captura de tela';

  @override
  String get mirrorYourScreenYoull =>
      'Espelhe sua tela. Você confirmará cada sessão.';

  @override
  String get webVideo => 'Vídeo da web';

  @override
  String get link => 'Link';

  @override
  String get screenMirroring2 => 'Espelhamento de tela';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Transmitindo $title. Abrir controle';
  }

  @override
  String castingTo2(Object value) {
    return 'Transmitindo para $value';
  }

  @override
  String get nowCasting => 'Transmitindo agora';

  @override
  String get nothingIsCasting => 'Nada está sendo transmitido';

  @override
  String get pickAPhotoVideo =>
      'Escolha uma foto, vídeo, música ou vídeo da web para enviar à TV.';

  @override
  String get backToHome => 'Voltar ao início';

  @override
  String slide2(Object formatDuration) {
    return 'Slide $formatDuration';
  }

  @override
  String get back10Seconds => 'Voltar 10 segundos';

  @override
  String get forward10Seconds => 'Avançar 10 segundos';

  @override
  String get tvVolume => 'Volume da TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Volume da TV $round por cento';
  }

  @override
  String get upNext => 'A seguir';

  @override
  String get addPhotos => 'Adicionar fotos';

  @override
  String get addVideos => 'Adicionar vídeos';

  @override
  String get nothingElseInThe => 'Não há mais nada na fila.';

  @override
  String play2(Object title) {
    return 'Reproduzir $title';
  }

  @override
  String get unknownDevice => 'Dispositivo desconhecido';

  @override
  String get perWeek => 'por semana';

  @override
  String get perYear => 'por ano';

  @override
  String get payOnce => 'pagamento único';

  @override
  String get wirelessScreenMirroring => 'Espelhamento de tela sem fio';

  @override
  String get castVideosPhotosMusic => 'Transmita vídeos, fotos e músicas';

  @override
  String get fullTvRemoteControl => 'Controle remoto completo da TV';

  @override
  String get worksWithAllMajor => 'Funciona com as principais TVs';

  @override
  String get smoothLagFreeStreaming => 'Streaming fluido, sem travamentos';

  @override
  String get noAds => 'Sem anúncios';

  @override
  String get welcomeToCastflowPro => 'Bem-vindo ao CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Compra cancelada.';

  @override
  String get purchasePendingProUnlocks =>
      'Compra pendente. O Pro será liberado assim que a loja confirmar.';

  @override
  String get purchaseFailedPleaseTry => 'A compra falhou. Tente de novo.';

  @override
  String get theStoreIsntAvailable => 'A loja não está disponível agora.';

  @override
  String get close => 'Fechar';

  @override
  String get goProWithCastflow => 'SEJA PRO COM CASTFLOW';

  @override
  String get unlockEveryFeature => 'Desbloqueie todos os recursos';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Renova automaticamente até ser cancelada.';

  @override
  String get oneTimePurchaseNo => 'Compra única. Sem assinatura.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get termsAndConditions => 'Termos e Condições';

  @override
  String get cancelAnytime => 'Cancele quando quiser';

  @override
  String get loadingPrice => 'Carregando preço…';

  @override
  String get pricesUnavailableTapTo =>
      'Preços indisponíveis · Toque para tentar de novo';

  @override
  String get noPlansAvailableRight => 'Nenhum plano disponível agora.';

  @override
  String get weekly => 'Semanal';

  @override
  String get yearly => 'Anual';

  @override
  String get lifetime => 'Vitalício';

  @override
  String get bestValue => 'Melhor custo-benefício';

  @override
  String get disconnectFromTv => 'Desconectar da TV?';

  @override
  String get thisStopsWhatIs =>
      'Isso interrompe o que está tocando ou sendo espelhado.';

  @override
  String get useTouchpad => 'Usar touchpad';

  @override
  String get useDPad => 'Usar direcional';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Receptores $label não aceitam comandos remotos.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Alguns botões não estão disponíveis em $label.';
  }

  @override
  String get idle => 'OCIOSO';

  @override
  String get playing => 'REPRODUZINDO';

  @override
  String get paused => 'PAUSADO';

  @override
  String get noTvConnected => 'Nenhuma TV conectada';

  @override
  String get mute2 => 'MUDO';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Nenhuma TV conectada. Toque para escolher um dispositivo';

  @override
  String get tapToChooseA => 'Toque para escolher um dispositivo';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label não é compatível com $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Touchpad. Deslize para mover, toque para selecionar.';

  @override
  String get swipeToMoveTap => 'Deslize para mover · Toque para selecionar';

  @override
  String get navigationIsntSupportedBy => 'Esta TV não suporta navegação';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automático';

  @override
  String get googleCastFirst => 'Google Cast primeiro';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP primeiro';

  @override
  String get miracastFirst => 'Miracast primeiro';

  @override
  String get tvOnly => 'Só TV';

  @override
  String get phoneAndTv => 'Celular e TV';

  @override
  String get phoneOnly => 'Só celular';

  @override
  String get touchpad => 'Touchpad';

  @override
  String get doMyPhoneAnd => 'Meu celular e a TV precisam do mesmo Wi-Fi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Sim. A descoberta e a transmissão ficam na sua rede local, então ambos devem estar no mesmo Wi-Fi (nomes de banda parecidos podem ser redes diferentes).';

  @override
  String get myRouterHasAp => 'Meu roteador tem “isolamento de AP / clientes”';

  @override
  String get isolationBlocksDevicesFrom =>
      'O isolamento impede que os dispositivos se vejam. Desative nas configurações do roteador ou use uma rede que não seja de convidados.';

  @override
  String get findingYourTv => 'Encontrando sua TV';

  @override
  String get myTvDoesntAppear => 'Minha TV não aparece na lista';

  @override
  String get turnOnCastingScreen =>
      'Ative a transmissão / espelhamento na TV, tire-a do modo de espera e toque em Procurar de novo. Permita a rede local se solicitado.';

  @override
  String get onlySomeDevicesShow => 'Só alguns dispositivos aparecem';

  @override
  String get olderTvsMayNeed =>
      'TVs mais antigas podem precisar de atualização de firmware. TVs Miracast só aparecem enquanto a entrada “Espelhamento de tela” está aberta.';

  @override
  String get connectionFailsOrTimes => 'A conexão falha ou expira';

  @override
  String get restartTheTvApp =>
      'Reinicie o app da TV ou a TV, chegue mais perto do roteador e aceite qualquer aviso na tela da TV.';

  @override
  String get itKeepsReconnectingTo =>
      'Ele continua reconectando a uma TV antiga';

  @override
  String get turnOffAutoConnect =>
      'Desative “Conectar automaticamente à última TV” em Configurações → Transmissão.';

  @override
  String get mirroringIsLaggy => 'O espelhamento está com atraso';

  @override
  String get chooseALowerQuality =>
      'Escolha uma qualidade menor (720p ou 480p), feche apps pesados e use uma rede Wi-Fi de 5 GHz.';

  @override
  String get thePictureIsRotated => 'A imagem está girada ou cortada';

  @override
  String get toggleAutoRotateOn =>
      'Ative ou desative Girar automaticamente na tela de Espelhamento de tela.';

  @override
  String get sound => 'Som';

  @override
  String get thereIsNoSound => 'Não há som na TV';

  @override
  String get makeSureAudioIs =>
      'Verifique se o áudio está ativado no Espelhamento de tela e confira Configurações → Transmissão → Saída de áudio. Alguns receptores não suportam o áudio do celular.';

  @override
  String get tvRemote2 => 'Controle da TV';

  @override
  String get someRemoteButtonsAre => 'Alguns botões do controle estão em cinza';

  @override
  String get eachReceiverSupportsDifferent =>
      'Cada receptor suporta comandos diferentes. Chromecast e DLNA só suportam reprodução e volume; o Miracast não tem canal de controle.';

  @override
  String get canCastflowTurnMy =>
      'O CastFlow pode ligar minha TV ou trocar de entrada?';

  @override
  String get onlyOnTvsThat =>
      'Só em TVs que expõem esses comandos pela rede. Botões não compatíveis ficam desativados em vez de fingir que funcionam.';

  @override
  String get helpFaq => 'Ajuda e perguntas frequentes';

  @override
  String get stepByStepConnection => 'Guia de conexão passo a passo';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Nenhum app de e-mail encontrado.';

  @override
  String get enjoyingCastflow => 'Curtindo o CastFlow?';

  @override
  String get sorryToHearThat => 'Sentimos muito por isso';

  @override
  String get thanksHowCanWe => 'Obrigado! Como podemos melhorar?';

  @override
  String get wereGladYouLike => 'Que bom que você gostou!';

  @override
  String get youMadeOurDay => 'Você alegrou o nosso dia!';

  @override
  String get tapToExit => 'Toque para sair';

  @override
  String get selectARating => 'Selecione uma avaliação';

  @override
  String get sendFeedback => 'Enviar feedback';

  @override
  String get rateUs => 'Avalie-nos';

  @override
  String get rateYourExperienceBefore =>
      'Avalie sua experiência antes de sair.';

  @override
  String get tapAStarTo => 'Toque em uma estrela para avaliar o CastFlow.';

  @override
  String get general => 'Geral';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Qualidade padrão';

  @override
  String get autoConnectToLast => 'Conectar automaticamente à última TV';

  @override
  String get hapticFeedback => 'Resposta tátil';

  @override
  String get clearCastingHistory => 'Limpar histórico de transmissão';

  @override
  String get clearCastingHistory2 => 'Limpar histórico de transmissão?';

  @override
  String get onlyCastflowsListIs =>
      'Só a lista do CastFlow é apagada. A mídia do celular nunca é excluída.';

  @override
  String get appearance => 'Aparência';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get system => 'Sistema';

  @override
  String get aboutSupport => 'Sobre e suporte';

  @override
  String get rateApp => 'Avaliar o app';

  @override
  String get feedback => 'Feedback';

  @override
  String get termsConditions => 'Termos e Condições';

  @override
  String get version => 'Versão';

  @override
  String get castflowProIsActive => 'CastFlow Pro está ativo';

  @override
  String get upgradeToPremium => 'Faça upgrade para Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Obrigado pelo apoio. Aproveite transmissões sem anúncios.';

  @override
  String get noAds1080pMirroring =>
      'Sem anúncios, espelhamento 1080p e transmissão ilimitada';

  @override
  String get upgrade => 'Fazer upgrade';

  @override
  String get mirrorCastBeautifullySimple =>
      'Espelhe e transmita, de forma simples';

  @override
  String get thisActionMayContain => 'Esta ação pode conter anúncios';

  @override
  String get webCast => 'Transmissão web';

  @override
  String get castThisVideo => 'Transmitir este vídeo';

  @override
  String get searchOrTypeAWeb => 'Pesquise ou digite um endereço da web';

  @override
  String get removeBookmark => 'Remover favorito';

  @override
  String get bookmark => 'Favorito';

  @override
  String get quickAccess => 'Acesso rápido';

  @override
  String open2(Object title) {
    return 'Abrir $title';
  }

  @override
  String get bookmarks => 'Favoritos';

  @override
  String get noBookmarks => 'Sem favoritos';

  @override
  String get tapTheBookmarkIcon =>
      'Toque no ícone de favorito na barra de endereço para salvar uma página.';

  @override
  String get noHistory => 'Sem histórico';

  @override
  String get pagesYouVisitShow =>
      'As páginas que você visitar aparecerão aqui.';

  @override
  String get remove => 'Remover';

  @override
  String resultOn(Object value, Object host) {
    return 'Resultado $value em $host';
  }

  @override
  String get aSimulatedPageResult => 'Um resultado de página simulado';

  @override
  String get videosOnThisPage => 'Vídeos nesta página';

  @override
  String get pickOneToSend => 'Escolha um para enviar à TV.';

  @override
  String get onboardHotspotTitle => 'Sem Wi-Fi? Use seu hotspot';

  @override
  String get onboardHotspotBody =>
      'Ative o hotspot do celular e conecte sua TV a ele. A transmissão funciona como no Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Ainda não encontrou sua TV?';

  @override
  String get stillCantFindBody => 'Conecte sua TV ao hotspot do celular:';

  @override
  String get hotspotStep4 =>
      'Toque em Tentar novamente e escolha sua TV na lista';

  @override
  String get castOverHotspot => 'Sem Wi-Fi? Transmita pelo hotspot do celular:';

  @override
  String get queue => 'Fila';

  @override
  String get addMusic => 'Adicionar músicas';

  @override
  String get connectWithWifi => 'Conectar ao Wi-Fi';

  @override
  String get continueWithHotspot => 'Continuar com hotspot';

  @override
  String get noWifiAlertMessage =>
      'Você está usando dados móveis. Conecte o celular e a TV ao mesmo Wi-Fi ou ative o hotspot do celular e conecte a TV a ele.';
}
