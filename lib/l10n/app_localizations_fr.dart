// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get networkRequiredTitle => 'Non connecté au Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Votre téléphone et la TV doivent être sur le même réseau Wi-Fi pour diffuser.';

  @override
  String get openWifiSettings => 'Ouvrir les réglages Wi-Fi';

  @override
  String get useMobileHotspot => 'Utiliser le partage de connexion';

  @override
  String get hotspotInstruction =>
      'Connectez votre TV au partage de connexion de votre téléphone.';

  @override
  String get hotspotStep1 => 'Activez le partage de connexion';

  @override
  String get hotspotStep2 => 'Connectez-y votre TV';

  @override
  String get hotspotStep3 => 'Revenez dans l’application';

  @override
  String get openHotspotSettings =>
      'Ouvrir les réglages du partage de connexion';

  @override
  String get hotspotAutoCheck =>
      'Nous vérifierons de nouveau automatiquement à votre retour.';

  @override
  String get hotspotDetected =>
      'Le partage de connexion est activé. Recherche de votre TV…';

  @override
  String get searchingDevices => 'Recherche d’appareils à proximité...';

  @override
  String get waitingForTvOnHotspot =>
      'En attente que votre TV rejoigne votre partage de connexion…';

  @override
  String get usingHotspot => 'Utilisation de votre partage de connexion';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appareils trouvés',
      one: '1 appareil trouvé',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get scanAgain => 'Relancer la recherche';

  @override
  String get isolationTitle => 'La TV ne répond pas';

  @override
  String get isolationHint =>
      'Un appareil a rejoint votre partage de connexion mais ne répond pas. Celui-ci bloque peut-être le trafic entre appareils (isolation des clients). Désactivez-la dans les réglages du partage de connexion ou utilisez un réseau Wi-Fi.';

  @override
  String get connecting => 'Connexion…';

  @override
  String get connected => 'Connecté';

  @override
  String get connectionFailed => 'Connexion impossible';

  @override
  String get connectFailedHint =>
      'Vérifiez que le téléphone et la TV sont sur le même réseau, puis réessayez.';

  @override
  String get hotspotConnectHint =>
      'Votre partage de connexion bloque peut-être le trafic entre appareils. Vérifiez le réglage d’isolation des clients.';

  @override
  String get networkLostTitle => 'Connexion réseau perdue';

  @override
  String get networkLostMessage =>
      'Reconnectez-vous au Wi-Fi ou au partage de connexion, puis reconnectez votre TV.';

  @override
  String get reconnect => 'Reconnecter';

  @override
  String reconnectTo(String name) {
    return 'Se reconnecter à $name';
  }

  @override
  String get tapToReconnect => 'Touchez pour vous reconnecter';

  @override
  String get pairingRequired => 'Association requise';

  @override
  String get pairingEnterCode => 'Saisissez le code affiché sur votre TV.';

  @override
  String get pairingApproveOnTv =>
      'Regardez votre TV et touchez Autoriser pour continuer.';

  @override
  String get connect => 'Connecter';

  @override
  String get cancel => 'Annuler';

  @override
  String get pairingIncorrectCode => 'Code incorrect. Réessayez.';

  @override
  String get pairingTimedOut => 'Délai d’association dépassé';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get pairingDeclined => 'La TV a refusé la connexion';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Trop de codes erronés. Attendez $seconds s, puis demandez un nouveau code.';
  }

  @override
  String get pairingCooldownOver => 'Vous pouvez demander un nouveau code.';

  @override
  String get pairingRequestNewCode => 'Demander un nouveau code';

  @override
  String get pairingNetworkLost =>
      'Le réseau a été perdu pendant l’association. Reconnectez-vous au Wi-Fi et réessayez.';

  @override
  String get pairingFailed => 'Association avec la TV impossible.';

  @override
  String pairingCodeField(int length) {
    return 'Code d’association, $length caractères';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Case $index sur $total';
  }

  @override
  String get pairingEmptyBox => 'vide';

  @override
  String get pairingPaired => 'Associé';

  @override
  String get forgetDevice => 'Oublier l’appareil';

  @override
  String forgetDeviceMessage(String name) {
    return '$name devra être de nouveau associé la prochaine fois.';
  }

  @override
  String get forget => 'Oublier';

  @override
  String get castVideo => 'Diffuser la vidéo';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vidéos trouvées. Diffuser la vidéo',
      one: '1 vidéo trouvée. Diffuser la vidéo',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet =>
      'Aucune vidéo trouvée sur cette page pour l’instant.';

  @override
  String get videoFound => 'Vidéo trouvée';

  @override
  String get videoFoundMessage => 'Lancez-la sur votre TV.';

  @override
  String get castAction => 'Diffuser';

  @override
  String get dismiss => 'Ignorer';

  @override
  String videosFound(int count) {
    return 'Vidéos trouvées ($count)';
  }

  @override
  String get castToTv => 'Diffuser sur la TV';

  @override
  String get protectedVideo => 'Protégée, diffusion impossible';

  @override
  String get videoThumbnail => 'Miniature de la vidéo';

  @override
  String castingTo(String device) {
    return 'Diffusion sur $device';
  }

  @override
  String get stopCasting => 'Arrêter la diffusion';

  @override
  String get play => 'Lecture';

  @override
  String get pause => 'Pause';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Position de lecture';

  @override
  String get showControls => 'Afficher les commandes';

  @override
  String get hideControls => 'Masquer les commandes';

  @override
  String get formatUnsupportedTitle => 'Format non pris en charge';

  @override
  String formatUnsupported(String device, String format) {
    return '$device ne peut pas lire les vidéos $format. Essayez une autre vidéo de cette page ou utilisez la recopie d’écran.';
  }

  @override
  String get videoExpired =>
      'Le lien de cette vidéo a expiré. Rechargez la page et réessayez.';

  @override
  String get refreshingVideo => 'Récupération d’un nouveau lien vidéo…';

  @override
  String get browserBack => 'Retour';

  @override
  String get browserForward => 'Suivant';

  @override
  String get browserStartPage => 'Page d’accueil';

  @override
  String get browserReload => 'Actualiser';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Accueil';

  @override
  String get devices => 'Appareils';

  @override
  String get history => 'Historique';

  @override
  String get settings => 'Réglages';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get couldntOpenTheLink => 'Impossible d’ouvrir le lien.';

  @override
  String get castflowLogo => 'Logo CastFlow';

  @override
  String get somethingWentWrong => 'Un problème est survenu';

  @override
  String get weCouldntLoadThis =>
      'Impossible de charger ceci pour le moment. Réessayez.';

  @override
  String get apps => 'Apps';

  @override
  String open(Object name) {
    return 'Ouvrir $name';
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
  String get up => 'Haut';

  @override
  String get down => 'Bas';

  @override
  String get left => 'Gauche';

  @override
  String get right => 'Droite';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Entrée';

  @override
  String get playPause => 'Lecture / Pause';

  @override
  String get previous => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get rewind => 'Retour rapide';

  @override
  String get volumeUp => 'Volume +';

  @override
  String get volumeDown => 'Volume −';

  @override
  String get mute => 'Muet';

  @override
  String connectedTo(Object name) {
    return 'Connecté à $name';
  }

  @override
  String get chooseADevice => 'Choisir un appareil';

  @override
  String get connectionGuide => 'Guide de connexion';

  @override
  String get lookingForTvsOn => 'Recherche de TV sur votre Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return '$found trouvés pour l’instant';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found appareils trouvés';
  }

  @override
  String get disconnect => 'Déconnecter';

  @override
  String signalOf4(Object level) {
    return 'Signal $level sur 4';
  }

  @override
  String get connecting2 => 'Connexion';

  @override
  String get theTvRemoteNeeds =>
      'La télécommande a besoin d’une TV connectée. Choisissez-en une ci-dessous.';

  @override
  String get connectToATv => 'Connectez-vous à une TV pour continuer.';

  @override
  String get findingTvs => 'Recherche de TV…';

  @override
  String get makeSureYourTv => 'Vérifiez que votre TV est allumée';

  @override
  String get notConnected => 'Non connecté';

  @override
  String get tapToFindYour => 'Touchez pour trouver votre TV';

  @override
  String get connectionFailed2 => 'Échec de la connexion';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Touchez pour gérer les appareils';
  }

  @override
  String get joinTheSameWi => 'Rejoignez le même Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Connectez votre téléphone et votre TV au même réseau Wi-Fi.';

  @override
  String get turnOnCastingOn => 'Activez la diffusion sur votre TV';

  @override
  String get enableScreenMirroringMiracast =>
      'Activez la recopie d’écran, Miracast ou Google Cast dans les réglages de la TV.';

  @override
  String get scanForDevices => 'Rechercher des appareils';

  @override
  String get openDevicesInCastflow =>
      'Ouvrez Appareils dans CastFlow et patientez quelques secondes pour que votre TV apparaisse.';

  @override
  String get tapConnect => 'Touchez Connecter';

  @override
  String get acceptThePromptOn =>
      'Acceptez la demande sur votre TV si elle apparaît. C’est tout !';

  @override
  String get howToConnect => 'Comment se connecter';

  @override
  String get fourQuickStepsTo =>
      'Quatre étapes rapides pour passer sur grand écran.';

  @override
  String get gotIt => 'Compris';

  @override
  String step(Object number, Object title, Object body) {
    return 'Étape $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi maison';

  @override
  String get router => 'Routeur';

  @override
  String get settingsConnection => 'Réglages › Connexion';

  @override
  String get inputHdmi1 => 'Entrée : HDMI 1';

  @override
  String get screenMirroring => 'Recopie d’écran';

  @override
  String get networkHomeWiFi => 'Réseau : Wi-Fi maison';

  @override
  String get livingRoomTv => 'TV du salon';

  @override
  String get allowCastflowToConnect => 'Autoriser CastFlow à se connecter ?';

  @override
  String get deny => 'Refuser';

  @override
  String get allow => 'Autoriser';

  @override
  String get yourTv => 'Votre TV';

  @override
  String get findYourTv => 'Trouvez votre TV';

  @override
  String connectTo(Object name) {
    return 'Se connecter à $name';
  }

  @override
  String connected2(Object label) {
    return 'Connecté · $label';
  }

  @override
  String get openTvRemote => 'Ouvrir la télécommande';

  @override
  String get sameWiFiNetwork => 'Même réseau Wi-Fi';

  @override
  String get yourPhoneAndTv =>
      'Votre téléphone et la TV doivent être connectés au même Wi-Fi.';

  @override
  String get tvIsOnAnd => 'La TV est allumée et prête';

  @override
  String get turnOnScreenMirroring =>
      'Activez la recopie d’écran, Cast ou Miracast sur la TV.';

  @override
  String get noVpnOrGuest => 'Pas de VPN ni de réseau invité';

  @override
  String get vpnsAndGuestIsolated =>
      'Les VPN et le Wi-Fi invité ou isolé empêchent les appareils de se voir.';

  @override
  String get localNetworkAccess => 'Accès au réseau local';

  @override
  String get allowCastflowToFind =>
      'Autorisez CastFlow à trouver des appareils sur votre réseau quand il le demande.';

  @override
  String get noTvFound => 'Aucune TV trouvée';

  @override
  String get checkThatYourPhone =>
      'Vérifiez que le téléphone et la TV sont sur le même Wi-Fi, puis relancez la recherche.';

  @override
  String get noWiFiRouter =>
      'Pas de routeur Wi-Fi ? Utilisez votre partage de connexion';

  @override
  String searchingForTvsFound(Object length) {
    return 'Recherche de TV. $length trouvée(s).';
  }

  @override
  String tvsFound(Object length) {
    return '$length TV trouvées';
  }

  @override
  String get connectToYourTv => 'Connectez-vous à votre TV';

  @override
  String get connectYourPhoneAndTv =>
      'Connectez votre téléphone et votre TV au même réseau Wi-Fi.';

  @override
  String get turnOnTheTv =>
      'Allumez la TV et ouvrez son entrée Recopie d’écran / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Touchez la barre de connexion sur l’accueil pour trouver votre TV.';

  @override
  String get tapConnectAndAccept =>
      'Touchez Connecter et acceptez la demande sur la TV si elle apparaît.';

  @override
  String get mirrorYourScreen => 'Recopiez votre écran';

  @override
  String get connectToYourTvFirst => 'Connectez-vous d’abord à votre TV.';

  @override
  String get openScreenMirroringFrom =>
      'Ouvrez Recopie d’écran depuis l’accueil.';

  @override
  String get pickAQualityAnd => 'Choisissez une qualité et touchez Démarrer.';

  @override
  String get allowScreenCaptureWhen =>
      'Autorisez la capture d’écran quand Android le demande.';

  @override
  String get castPhotosVideosMusic => 'Diffusez photos, vidéos et musique';

  @override
  String get openPhotosVideosOr =>
      'Ouvrez Photos, Vidéos ou Musique sur l’accueil.';

  @override
  String get pickWhatYouWant => 'Choisissez ce que vous voulez montrer.';

  @override
  String get itPlaysOnThe =>
      'Cela se lit sur la TV ; contrôlez depuis votre téléphone ou la notification.';

  @override
  String get useTheTvRemote => 'Utilisez la télécommande';

  @override
  String get openTvRemoteOn => 'Ouvrez Télécommande sur l’accueil.';

  @override
  String get useTheDPad =>
      'Utilisez la croix directionnelle ou glissez sur le pavé tactile pour vous déplacer, touchez OK pour choisir.';

  @override
  String get buttonsATvDoesnt =>
      'Les boutons non pris en charge par la TV sont grisés.';

  @override
  String get castFromTheWeb => 'Diffusez depuis le web et les apps';

  @override
  String get tapTheBrowserBar =>
      'Touchez la barre du navigateur ou une app sur l’accueil.';

  @override
  String get playAVideoOn => 'Lancez une vidéo sur le site.';

  @override
  String get tapCastThisVideo =>
      'Touchez « Diffuser cette vidéo » pour l’envoyer sur votre TV.';

  @override
  String get screenMirroringHelp => 'Aide sur la recopie d’écran';

  @override
  String get connectYourPhoneTo => 'Connectez votre téléphone au Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Sur la TV, ouvrez Réglages → Réseau et rejoignez le même Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Les réseaux invités ou de bureau bloquent souvent la recopie ; utilisez votre Wi-Fi maison ou le partage de connexion.';

  @override
  String get turnOffVpn => 'Désactivez le VPN';

  @override
  String get aVpnHidesYour => 'Un VPN cache votre TV à votre téléphone.';

  @override
  String get pauseOrDisconnectYour =>
      'Mettez en pause ou déconnectez votre app VPN avant de commencer.';

  @override
  String get youCanTurnIt => 'Vous pourrez la réactiver ensuite.';

  @override
  String get turnOnMirroringOn => 'Activez la recopie sur la TV';

  @override
  String get samsungLgAndMost =>
      'Les TV Samsung, LG et la plupart des TV Android acceptent la recopie automatiquement.';

  @override
  String get otherTvsOpenInput =>
      'Autres TV : ouvrez Entrée / Source et choisissez Recopie d’écran ou Miracast.';

  @override
  String get keepTheTvOn =>
      'Laissez la TV sur cet écran pendant la connexion du téléphone.';

  @override
  String get tapStartAndPick => 'Touchez Démarrer et choisissez votre TV';

  @override
  String get tapStartOnThe => 'Touchez Démarrer sur l’écran Recopie d’écran.';

  @override
  String get androidOpensSmartView =>
      'Android ouvre Smart View / Cast. Touchez votre TV dans la liste.';

  @override
  String get ifTheTvAsks =>
      'Si la TV le demande, choisissez Autoriser ou saisissez le code PIN affiché.';

  @override
  String get youreMirroring => 'Vous recopiez votre écran';

  @override
  String get everythingOnYourPhone =>
      'Tout ce qui est sur votre téléphone s’affiche maintenant sur la TV.';

  @override
  String get turnThePhoneSideways =>
      'Tournez le téléphone pour les vidéos et jeux en plein écran.';

  @override
  String get toStopTapStop =>
      'Pour arrêter, touchez Arrêter ou utilisez la notification de diffusion.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Désactivé';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'TV de la chambre';

  @override
  String get officeDisplay => 'Écran du bureau';

  @override
  String get clearHistory => 'Effacer l’historique ?';

  @override
  String get thisRemovesEverythingYouve =>
      'Cela supprime de cette liste tout ce que vous avez diffusé.';

  @override
  String get clear => 'Effacer';

  @override
  String get clearHistory2 => 'Effacer l’historique';

  @override
  String get noHistoryYet => 'Pas encore d’historique';

  @override
  String get everythingYouCastWill =>
      'Tout ce que vous diffusez sera listé ici pour le retrouver facilement.';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get earlier => 'Plus ancien';

  @override
  String get swipeAnItemTo => 'Faites glisser un élément pour le supprimer';

  @override
  String get delete => 'Supprimer';

  @override
  String removed(Object title) {
    return '« $title » supprimé';
  }

  @override
  String get undo => 'Annuler';

  @override
  String get photos => 'Photos';

  @override
  String get albums => 'Albums';

  @override
  String get videos => 'Vidéos';

  @override
  String get gallery => 'Galerie';

  @override
  String get music => 'Musique';

  @override
  String get songs => 'Titres';

  @override
  String get media => 'Médias';

  @override
  String get browseTheWeb => 'Naviguer sur le web';

  @override
  String get goPro => 'Passer à Pro';

  @override
  String cast(Object title) {
    return 'Diffuser $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Recopie d’écran. Démarrer la recopie';

  @override
  String readyToMirrorTo(Object device) {
    return 'Prêt à recopier sur $device';
  }

  @override
  String get showYourPhoneOn =>
      'Affichez votre téléphone sur la TV en temps réel.';

  @override
  String get startMirroring => 'Démarrer la recopie';

  @override
  String get tvRemote => 'Télécommande';

  @override
  String get controlYourTv => 'Contrôlez votre TV';

  @override
  String get youtubeMore => 'YouTube et plus';

  @override
  String get openTheBrowser => 'Ouvrir le navigateur';

  @override
  String get searchOrTypeA => 'Rechercher ou saisir un site web';

  @override
  String get howToConnectOpen => 'Comment se connecter. Ouvrir le guide visuel';

  @override
  String get visualGuideForEvery => 'Guide visuel pour chaque fonction';

  @override
  String get language => 'Langue';

  @override
  String get done => 'Terminé';

  @override
  String get enterAValidHttp =>
      'Saisissez un lien http(s) ou rtsp valide, p. ex. une URL .m3u8 ou .mp4.';

  @override
  String get linkStream => 'Diffusion par lien';

  @override
  String get iptvLinkCast => 'IPTV / Diffusion de lien';

  @override
  String get castALink => 'Diffuser un lien';

  @override
  String get pasteADirectVideo =>
      'Collez l’URL d’une vidéo directe, M3U8 ou d’un flux IPTV.';

  @override
  String get paste => 'Coller';

  @override
  String get castLink => 'Diffuser le lien';

  @override
  String get allowAccessToYour =>
      'Autorisez l’accès à vos médias pour les diffuser. Vous pouvez le modifier dans Réglages.';

  @override
  String get video => 'Vidéo';

  @override
  String get castMusic => 'Diffuser de la musique';

  @override
  String get noMusicFound => 'Aucune musique trouvée';

  @override
  String get addSongsToYour =>
      'Ajoutez des titres à votre téléphone et ils apparaîtront ici.';

  @override
  String get shuffle => 'Aléatoire';

  @override
  String get playAll => 'Tout lire';

  @override
  String photo(Object formatShortDate) {
    return 'Photo · $formatShortDate';
  }

  @override
  String get photo2 => 'Photo';

  @override
  String get castPhotos => 'Diffuser des photos';

  @override
  String get select => 'Sélectionner';

  @override
  String get noPhotosHere => 'Aucune photo ici';

  @override
  String get photosYouTakeOr =>
      'Les photos que vous prenez ou enregistrez apparaîtront dans cet album.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count photos';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Photo du $formatShortDate';
  }

  @override
  String get allPhotos => 'Toutes les photos';

  @override
  String get slideshow => 'Diaporama';

  @override
  String get interval => 'Intervalle';

  @override
  String get transition => 'Transition';

  @override
  String get fade => 'Fondu';

  @override
  String get slide => 'Glissement';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Lancer le diaporama';

  @override
  String get castVideos => 'Diffuser des vidéos';

  @override
  String get noVideosYet => 'Pas encore de vidéos';

  @override
  String get videosYouRecordOr =>
      'Les vidéos que vous filmez ou téléchargez apparaîtront ici, prêtes à être diffusées.';

  @override
  String video2(Object resolution) {
    return 'Vidéo · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Diffuser';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Session de recopie d’écran';

  @override
  String get mirroringDidntStartTap =>
      'La recopie n’a pas démarré. Touchez Démarrer à nouveau et choisissez votre TV dans la liste.';

  @override
  String get openSmartViewOr =>
      'Ouvrez Smart View ou Cast depuis les réglages rapides du téléphone pour recopier.';

  @override
  String get quality => 'Qualité';

  @override
  String get adjustsToYourWi =>
      'S’adapte à votre Wi-Fi pour une image plus fluide.';

  @override
  String upToLowerIt(Object label) {
    return 'Jusqu’à $label. Réduisez si l’image saccade.';
  }

  @override
  String get stillNeedHelp => 'Besoin d’aide ?';

  @override
  String get startingScreenMirroring => 'Démarrage de la recopie d’écran…';

  @override
  String mirroringTo(Object value) {
    return 'Recopie sur $value';
  }

  @override
  String get stopping => 'Arrêt…';

  @override
  String get readyToMirror => 'Prêt à recopier';

  @override
  String get beforeYouStart => 'Avant de commencer';

  @override
  String get phoneAndTvAre => 'Le téléphone et la TV sont sur le même Wi-Fi';

  @override
  String get noVpnIsConnected => 'Aucun VPN n’est connecté sur votre téléphone';

  @override
  String get tvIsOnWith => 'La TV est allumée avec la recopie d’écran activée';

  @override
  String get phoneIsCloseTo => 'Le téléphone est près de la TV';

  @override
  String get stopMirroring => 'Arrêter la recopie';

  @override
  String get startMirroring2 => 'Démarrer la recopie';

  @override
  String get stop => 'Arrêter';

  @override
  String get start => 'Démarrer';

  @override
  String get duration => 'Durée';

  @override
  String get adIsLoading => 'Chargement de la publicité';

  @override
  String get ad => 'Pub';

  @override
  String get mirrorYourScreenTo =>
      'Recopiez votre écran sur n’importe quelle TV';

  @override
  String get showYourPhoneOnThe =>
      'Affichez votre téléphone sur grand écran en un geste : sans câble, sans complication.';

  @override
  String get shareMemoriesWithThe =>
      'Partagez vos souvenirs avec toute la pièce et gardez le contrôle depuis votre téléphone.';

  @override
  String get castFromWebApps => 'Diffusez depuis le web et les apps';

  @override
  String get sendVideosFromYoutube =>
      'Envoyez des vidéos de YouTube, Facebook et de n’importe quel site directement sur votre TV.';

  @override
  String pageOf(Object value, Object length) {
    return 'Page $value sur $length';
  }

  @override
  String get getStarted => 'Commencer';

  @override
  String get localNetwork => 'Réseau local';

  @override
  String get findTvsAndStreaming =>
      'Trouvez des TV et appareils de streaming sur votre Wi-Fi.';

  @override
  String get notifications => 'Notifications';

  @override
  String get showCastingControlsWhile =>
      'Affichez les commandes de diffusion pendant que vous utilisez d’autres apps.';

  @override
  String get photosVideosMusic => 'Photos, vidéos et musique';

  @override
  String get pickWhatYouWantTo =>
      'Choisissez ce que vous voulez diffuser depuis votre galerie et votre bibliothèque.';

  @override
  String get screenCapture => 'Capture d’écran';

  @override
  String get mirrorYourScreenYoull =>
      'Recopiez votre écran. Vous confirmerez chaque session.';

  @override
  String get webVideo => 'Vidéo web';

  @override
  String get link => 'Lien';

  @override
  String get screenMirroring2 => 'Recopie d’écran';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Diffusion de $title. Ouvrir la télécommande';
  }

  @override
  String castingTo2(Object value) {
    return 'Diffusion sur $value';
  }

  @override
  String get nowCasting => 'En cours de diffusion';

  @override
  String get nothingIsCasting => 'Rien n’est diffusé';

  @override
  String get pickAPhotoVideo =>
      'Choisissez une photo, une vidéo, un titre ou une vidéo web à envoyer sur votre TV.';

  @override
  String get backToHome => 'Retour à l’accueil';

  @override
  String slide2(Object formatDuration) {
    return 'Diapositive $formatDuration';
  }

  @override
  String get back10Seconds => 'Reculer de 10 secondes';

  @override
  String get forward10Seconds => 'Avancer de 10 secondes';

  @override
  String get tvVolume => 'Volume de la TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Volume de la TV $round pour cent';
  }

  @override
  String get upNext => 'À suivre';

  @override
  String get addPhotos => 'Ajouter des photos';

  @override
  String get addVideos => 'Ajouter des vidéos';

  @override
  String get nothingElseInThe => 'Rien d’autre dans la file.';

  @override
  String play2(Object title) {
    return 'Lire $title';
  }

  @override
  String get unknownDevice => 'Appareil inconnu';

  @override
  String get perWeek => 'par semaine';

  @override
  String get perYear => 'par an';

  @override
  String get payOnce => 'paiement unique';

  @override
  String get wirelessScreenMirroring => 'Recopie d’écran sans fil';

  @override
  String get castVideosPhotosMusic => 'Diffusez vidéos, photos et musique';

  @override
  String get fullTvRemoteControl => 'Télécommande complète de la TV';

  @override
  String get worksWithAllMajor => 'Compatible avec les principales TV';

  @override
  String get smoothLagFreeStreaming => 'Streaming fluide, sans latence';

  @override
  String get noAds => 'Sans publicité';

  @override
  String get welcomeToCastflowPro => 'Bienvenue dans CastFlow Pro !';

  @override
  String get purchaseCancelled => 'Achat annulé.';

  @override
  String get purchasePendingProUnlocks =>
      'Achat en attente. Pro s’activera dès que la boutique le confirmera.';

  @override
  String get purchaseFailedPleaseTry => 'L’achat a échoué. Réessayez.';

  @override
  String get theStoreIsntAvailable =>
      'La boutique n’est pas disponible pour le moment.';

  @override
  String get close => 'Fermer';

  @override
  String get goProWithCastflow => 'PASSEZ À PRO AVEC CASTFLOW';

  @override
  String get unlockEveryFeature => 'Débloquez toutes les fonctions';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Se renouvelle automatiquement jusqu’à l’annulation.';

  @override
  String get oneTimePurchaseNo => 'Achat unique. Sans abonnement.';

  @override
  String get continueAction => 'Continuer';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get cancelAnytime => 'Annulez à tout moment';

  @override
  String get loadingPrice => 'Chargement du prix…';

  @override
  String get pricesUnavailableTapTo =>
      'Prix indisponibles · Touchez pour réessayer';

  @override
  String get noPlansAvailableRight => 'Aucune offre disponible pour le moment.';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get yearly => 'Annuel';

  @override
  String get lifetime => 'À vie';

  @override
  String get bestValue => 'Meilleure offre';

  @override
  String get disconnectFromTv => 'Se déconnecter de la TV ?';

  @override
  String get thisStopsWhatIs =>
      'Cela arrête ce qui est en cours de lecture ou de recopie.';

  @override
  String get useTouchpad => 'Utiliser le pavé tactile';

  @override
  String get useDPad => 'Utiliser la croix directionnelle';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Les récepteurs $label n’acceptent pas les commandes à distance.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Certains boutons sont indisponibles sur $label.';
  }

  @override
  String get idle => 'INACTIF';

  @override
  String get playing => 'LECTURE';

  @override
  String get paused => 'EN PAUSE';

  @override
  String get noTvConnected => 'Aucune TV connectée';

  @override
  String get mute2 => 'MUET';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Aucune TV connectée. Touchez pour choisir un appareil';

  @override
  String get tapToChooseA => 'Touchez pour choisir un appareil';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label n’est pas pris en charge par $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Pavé tactile. Glissez pour déplacer, touchez pour sélectionner.';

  @override
  String get swipeToMoveTap =>
      'Glissez pour déplacer · Touchez pour sélectionner';

  @override
  String get navigationIsntSupportedBy =>
      'La navigation n’est pas prise en charge par cette TV';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automatique';

  @override
  String get googleCastFirst => 'Google Cast d’abord';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP d’abord';

  @override
  String get miracastFirst => 'Miracast d’abord';

  @override
  String get tvOnly => 'TV uniquement';

  @override
  String get phoneAndTv => 'Téléphone et TV';

  @override
  String get phoneOnly => 'Téléphone uniquement';

  @override
  String get touchpad => 'Pavé tactile';

  @override
  String get doMyPhoneAnd =>
      'Mon téléphone et ma TV doivent-ils être sur le même Wi-Fi ?';

  @override
  String get yesDiscoveryAndCasting =>
      'Oui. La détection et la diffusion restent sur votre réseau local, donc les deux doivent être sur le même Wi-Fi (des noms de bande similaires peuvent être des réseaux différents).';

  @override
  String get myRouterHasAp => 'Mon routeur a l’« isolation AP / clients »';

  @override
  String get isolationBlocksDevicesFrom =>
      'L’isolation empêche les appareils de se voir. Désactivez-la dans les réglages du routeur ou utilisez un réseau non invité.';

  @override
  String get findingYourTv => 'Trouver votre TV';

  @override
  String get myTvDoesntAppear => 'Ma TV n’apparaît pas dans la liste';

  @override
  String get turnOnCastingScreen =>
      'Activez la diffusion / recopie sur la TV, sortez-la de veille, puis touchez Relancer la recherche. Autorisez l’accès au réseau local si demandé.';

  @override
  String get onlySomeDevicesShow => 'Seuls certains appareils apparaissent';

  @override
  String get olderTvsMayNeed =>
      'Les TV plus anciennes peuvent nécessiter une mise à jour du firmware. Les TV Miracast n’apparaissent que lorsque leur entrée « Recopie d’écran » est ouverte.';

  @override
  String get connectionFailsOrTimes => 'La connexion échoue ou expire';

  @override
  String get restartTheTvApp =>
      'Redémarrez l’app de la TV ou la TV, rapprochez-vous du routeur et acceptez toute demande affichée sur l’écran de la TV.';

  @override
  String get itKeepsReconnectingTo =>
      'Il se reconnecte sans cesse à une ancienne TV';

  @override
  String get turnOffAutoConnect =>
      'Désactivez « Connexion automatique à la dernière TV » dans Réglages → Diffusion.';

  @override
  String get mirroringIsLaggy => 'La recopie est saccadée';

  @override
  String get chooseALowerQuality =>
      'Choisissez une qualité inférieure (720p ou 480p), fermez les apps gourmandes et utilisez un réseau Wi-Fi 5 GHz.';

  @override
  String get thePictureIsRotated => 'L’image est pivotée ou rognée';

  @override
  String get toggleAutoRotateOn =>
      'Activez ou désactivez la rotation auto sur l’écran Recopie d’écran.';

  @override
  String get sound => 'Son';

  @override
  String get thereIsNoSound => 'Il n’y a pas de son sur la TV';

  @override
  String get makeSureAudioIs =>
      'Vérifiez que l’audio est activé dans Recopie d’écran et consultez Réglages → Diffusion → Sortie audio. Certains récepteurs ne prennent pas en charge l’audio du téléphone.';

  @override
  String get tvRemote2 => 'Télécommande';

  @override
  String get someRemoteButtonsAre =>
      'Certains boutons de la télécommande sont grisés';

  @override
  String get eachReceiverSupportsDifferent =>
      'Chaque récepteur prend en charge des commandes différentes. Chromecast et DLNA ne gèrent que la lecture et le volume ; Miracast n’a pas de canal de télécommande.';

  @override
  String get canCastflowTurnMy =>
      'CastFlow peut-il allumer ma TV ou changer d’entrée ?';

  @override
  String get onlyOnTvsThat =>
      'Seulement sur les TV qui exposent ces commandes sur le réseau. Les boutons non pris en charge sont désactivés au lieu de faire semblant de fonctionner.';

  @override
  String get helpFaq => 'Aide et FAQ';

  @override
  String get stepByStepConnection => 'Guide de connexion pas à pas';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Aucune application de messagerie trouvée.';

  @override
  String get enjoyingCastflow => 'Vous aimez CastFlow ?';

  @override
  String get sorryToHearThat => 'Désolé de l’apprendre';

  @override
  String get thanksHowCanWe => 'Merci ! Comment pouvons-nous nous améliorer ?';

  @override
  String get wereGladYouLike => 'Nous sommes ravis que vous aimiez !';

  @override
  String get youMadeOurDay => 'Vous avez illuminé notre journée !';

  @override
  String get tapToExit => 'Touchez pour quitter';

  @override
  String get selectARating => 'Sélectionnez une note';

  @override
  String get sendFeedback => 'Envoyer un avis';

  @override
  String get rateUs => 'Notez-nous';

  @override
  String get rateYourExperienceBefore =>
      'Notez votre expérience avant de partir.';

  @override
  String get tapAStarTo => 'Touchez une étoile pour noter CastFlow.';

  @override
  String get general => 'Général';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Qualité par défaut';

  @override
  String get autoConnectToLast => 'Connexion automatique à la dernière TV';

  @override
  String get hapticFeedback => 'Retour haptique';

  @override
  String get clearCastingHistory => 'Effacer l’historique de diffusion';

  @override
  String get clearCastingHistory2 => 'Effacer l’historique de diffusion ?';

  @override
  String get onlyCastflowsListIs =>
      'Seule la liste de CastFlow est effacée. Les médias de votre téléphone ne sont jamais supprimés.';

  @override
  String get appearance => 'Apparence';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Système';

  @override
  String get aboutSupport => 'À propos et assistance';

  @override
  String get rateApp => 'Noter l’app';

  @override
  String get feedback => 'Avis';

  @override
  String get termsConditions => 'Conditions générales';

  @override
  String get version => 'Version';

  @override
  String get castflowProIsActive => 'CastFlow Pro est actif';

  @override
  String get upgradeToPremium => 'Passer à Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Merci pour votre soutien. Profitez de la diffusion sans publicité.';

  @override
  String get noAds1080pMirroring =>
      'Sans pub, recopie 1080p et diffusion illimitée';

  @override
  String get upgrade => 'Mettre à niveau';

  @override
  String get mirrorCastBeautifullySimple =>
      'Recopiez et diffusez, tout simplement';

  @override
  String get thisActionMayContain =>
      'Cette action peut contenir des publicités';

  @override
  String get webCast => 'Diffusion web';

  @override
  String get castThisVideo => 'Diffuser cette vidéo';

  @override
  String get searchOrTypeAWeb => 'Rechercher ou saisir une adresse web';

  @override
  String get removeBookmark => 'Supprimer le favori';

  @override
  String get bookmark => 'Favori';

  @override
  String get quickAccess => 'Accès rapide';

  @override
  String open2(Object title) {
    return 'Ouvrir $title';
  }

  @override
  String get bookmarks => 'Favoris';

  @override
  String get noBookmarks => 'Aucun favori';

  @override
  String get tapTheBookmarkIcon =>
      'Touchez l’icône de favori dans la barre d’adresse pour enregistrer une page.';

  @override
  String get noHistory => 'Aucun historique';

  @override
  String get pagesYouVisitShow =>
      'Les pages que vous visitez apparaissent ici.';

  @override
  String get remove => 'Supprimer';

  @override
  String resultOn(Object value, Object host) {
    return 'Résultat $value sur $host';
  }

  @override
  String get aSimulatedPageResult => 'Un résultat de page simulé';

  @override
  String get videosOnThisPage => 'Vidéos sur cette page';

  @override
  String get pickOneToSend => 'Choisissez-en une à envoyer sur votre TV.';

  @override
  String get onboardHotspotTitle =>
      'Pas de Wi-Fi ? Utilisez votre point d’accès';

  @override
  String get onboardHotspotBody =>
      'Activez le point d’accès de votre téléphone et connectez-y votre TV. La diffusion fonctionne comme en Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Toujours pas de TV ?';

  @override
  String get stillCantFindBody =>
      'Connectez votre TV au point d’accès de votre téléphone :';

  @override
  String get hotspotStep4 =>
      'Touchez Réessayer et choisissez votre TV dans la liste';

  @override
  String get castOverHotspot =>
      'Pas de Wi-Fi ? Diffusez via le point d’accès du téléphone :';

  @override
  String get queue => 'File d’attente';

  @override
  String get addMusic => 'Ajouter de la musique';

  @override
  String get connectWithWifi => 'Se connecter au Wi-Fi';

  @override
  String get continueWithHotspot => 'Continuer avec le partage de connexion';

  @override
  String get noWifiAlertMessage =>
      'Vous utilisez les données mobiles. Connectez le téléphone et la TV au même Wi-Fi, ou activez le partage de connexion du téléphone et connectez-y la TV.';
}
