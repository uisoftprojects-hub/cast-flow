// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get networkRequiredTitle => 'Not connected to Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Your phone and TV must be on the same Wi-Fi network to cast.';

  @override
  String get openWifiSettings => 'Open Wi-Fi Settings';

  @override
  String get useMobileHotspot => 'Use Mobile Hotspot';

  @override
  String get hotspotInstruction =>
      'Connect your LCD/TV to your mobile hotspot.';

  @override
  String get hotspotStep1 => 'Turn on mobile hotspot';

  @override
  String get hotspotStep2 => 'Connect your TV to it';

  @override
  String get hotspotStep3 => 'Come back to the app';

  @override
  String get openHotspotSettings => 'Open Hotspot Settings';

  @override
  String get hotspotAutoCheck =>
      'We\'ll check again automatically when you come back.';

  @override
  String get hotspotDetected => 'Hotspot is on. Looking for your TV…';

  @override
  String get searchingDevices => 'Searching for nearby devices...';

  @override
  String get waitingForTvOnHotspot =>
      'Waiting for your TV to join your hotspot…';

  @override
  String get usingHotspot => 'Using your mobile hotspot';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices found',
      one: '1 device found',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Retry';

  @override
  String get scanAgain => 'Scan again';

  @override
  String get isolationTitle => 'TV not responding';

  @override
  String get isolationHint =>
      'A device joined your hotspot but isn\'t responding. Your hotspot may be blocking device-to-device traffic (client isolation). Turn that off in hotspot settings, or use a Wi-Fi network.';

  @override
  String get connecting => 'Connecting…';

  @override
  String get connected => 'Connected';

  @override
  String get connectionFailed => 'Couldn\'t connect';

  @override
  String get connectFailedHint =>
      'Make sure your phone and TV are on the same network, then try again.';

  @override
  String get hotspotConnectHint =>
      'Your hotspot may be blocking device-to-device traffic. Check its client isolation setting.';

  @override
  String get networkLostTitle => 'Network connection lost';

  @override
  String get networkLostMessage =>
      'Reconnect to Wi-Fi or your hotspot, then reconnect to your TV.';

  @override
  String get reconnect => 'Reconnect';

  @override
  String reconnectTo(String name) {
    return 'Reconnect to $name';
  }

  @override
  String get tapToReconnect => 'Tap to reconnect';

  @override
  String get pairingRequired => 'Pairing required';

  @override
  String get pairingEnterCode => 'Enter the code shown on your TV.';

  @override
  String get pairingApproveOnTv => 'Look at your TV and tap Allow to continue.';

  @override
  String get connect => 'Connect';

  @override
  String get cancel => 'Cancel';

  @override
  String get pairingIncorrectCode => 'Incorrect code. Try again.';

  @override
  String get pairingTimedOut => 'Pairing timed out';

  @override
  String get tryAgain => 'Try again';

  @override
  String get pairingDeclined => 'The TV declined the connection';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Too many wrong codes. Wait $seconds s, then request a new code.';
  }

  @override
  String get pairingCooldownOver => 'You can request a new code now.';

  @override
  String get pairingRequestNewCode => 'Request new code';

  @override
  String get pairingNetworkLost =>
      'The network was lost during pairing. Reconnect to Wi-Fi and try again.';

  @override
  String get pairingFailed => 'Couldn\'t pair with the TV.';

  @override
  String pairingCodeField(int length) {
    return 'Pairing code, $length characters';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Code box $index of $total';
  }

  @override
  String get pairingEmptyBox => 'empty';

  @override
  String get pairingPaired => 'Paired';

  @override
  String get forgetDevice => 'Forget device';

  @override
  String forgetDeviceMessage(String name) {
    return '$name will need to be paired again next time.';
  }

  @override
  String get forget => 'Forget';

  @override
  String get castVideo => 'Cast video';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos found. Cast video',
      one: '1 video found. Cast video',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'No video found on this page yet.';

  @override
  String get videoFound => 'Video found';

  @override
  String get videoFoundMessage => 'Play it on your TV.';

  @override
  String get castAction => 'Cast';

  @override
  String get dismiss => 'Dismiss';

  @override
  String videosFound(int count) {
    return 'Videos found ($count)';
  }

  @override
  String get castToTv => 'Cast to TV';

  @override
  String get protectedVideo => 'Protected, can\'t be cast';

  @override
  String get videoThumbnail => 'Video thumbnail';

  @override
  String castingTo(String device) {
    return 'Casting to $device';
  }

  @override
  String get stopCasting => 'Stop casting';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Playback position';

  @override
  String get showControls => 'Show controls';

  @override
  String get hideControls => 'Hide controls';

  @override
  String get formatUnsupportedTitle => 'Format not supported';

  @override
  String formatUnsupported(String device, String format) {
    return '$device can\'t play $format videos. Try another video on this page, or use screen mirroring.';
  }

  @override
  String get videoExpired =>
      'This video link expired. Reload the page and try again.';

  @override
  String get refreshingVideo => 'Getting a fresh video link…';

  @override
  String get browserBack => 'Back';

  @override
  String get browserForward => 'Forward';

  @override
  String get browserStartPage => 'Start page';

  @override
  String get browserReload => 'Reload';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Home';

  @override
  String get devices => 'Devices';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get couldntOpenTheLink => 'Couldn’t open the link.';

  @override
  String get castflowLogo => 'CastFlow logo';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get weCouldntLoadThis =>
      'We couldn’t load this right now. Please try again.';

  @override
  String get apps => 'Apps';

  @override
  String open(Object name) {
    return 'Open $name';
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
  String get up => 'Up';

  @override
  String get down => 'Down';

  @override
  String get left => 'Left';

  @override
  String get right => 'Right';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Input';

  @override
  String get playPause => 'Play / Pause';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get rewind => 'Rewind';

  @override
  String get volumeUp => 'Volume up';

  @override
  String get volumeDown => 'Volume down';

  @override
  String get mute => 'Mute';

  @override
  String connectedTo(Object name) {
    return 'Connected to $name';
  }

  @override
  String get chooseADevice => 'Choose a device';

  @override
  String get connectionGuide => 'Connection guide';

  @override
  String get lookingForTvsOn => 'Looking for TVs on your Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return '$found found so far';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found device$value found';
  }

  @override
  String get disconnect => 'Disconnect';

  @override
  String signalOf4(Object level) {
    return 'Signal $level of 4';
  }

  @override
  String get connecting2 => 'Connecting';

  @override
  String get theTvRemoteNeeds =>
      'The TV remote needs a connected TV. Pick one below.';

  @override
  String get connectToATv => 'Connect to a TV to continue.';

  @override
  String get findingTvs => 'Finding TVs…';

  @override
  String get makeSureYourTv => 'Make sure your TV is on';

  @override
  String get notConnected => 'Not connected';

  @override
  String get tapToFindYour => 'Tap to find your TV';

  @override
  String get connectionFailed2 => 'Connection failed';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Tap to manage devices';
  }

  @override
  String get joinTheSameWi => 'Join the same Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Connect your phone and your TV to the same Wi-Fi network.';

  @override
  String get turnOnCastingOn => 'Turn on casting on your TV';

  @override
  String get enableScreenMirroringMiracast =>
      'Enable Screen Mirroring, Miracast or Google Cast in the TV settings.';

  @override
  String get scanForDevices => 'Scan for devices';

  @override
  String get openDevicesInCastflow =>
      'Open Devices in CastFlow and wait a few seconds for your TV to appear.';

  @override
  String get tapConnect => 'Tap Connect';

  @override
  String get acceptThePromptOn =>
      'Accept the prompt on your TV if one appears. That’s it!';

  @override
  String get howToConnect => 'How to connect';

  @override
  String get fourQuickStepsTo => 'Four quick steps to get on the big screen.';

  @override
  String get gotIt => 'Got it';

  @override
  String step(Object number, Object title, Object body) {
    return 'Step $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Home Wi-Fi';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Settings › Connection';

  @override
  String get inputHdmi1 => 'Input: HDMI 1';

  @override
  String get screenMirroring => 'Screen Mirroring';

  @override
  String get networkHomeWiFi => 'Network: Home Wi-Fi';

  @override
  String get livingRoomTv => 'Living Room TV';

  @override
  String get allowCastflowToConnect => 'Allow CastFlow to connect?';

  @override
  String get deny => 'Deny';

  @override
  String get allow => 'Allow';

  @override
  String get yourTv => 'Your TV';

  @override
  String get findYourTv => 'Find your TV';

  @override
  String connectTo(Object name) {
    return 'Connect to $name';
  }

  @override
  String connected2(Object label) {
    return 'Connected · $label';
  }

  @override
  String get openTvRemote => 'Open TV remote';

  @override
  String get sameWiFiNetwork => 'Same Wi-Fi network';

  @override
  String get yourPhoneAndTv =>
      'Your phone and TV must be connected to the same Wi-Fi.';

  @override
  String get tvIsOnAnd => 'TV is on and ready';

  @override
  String get turnOnScreenMirroring =>
      'Turn on Screen Mirroring, Cast or Miracast on the TV.';

  @override
  String get noVpnOrGuest => 'No VPN or guest network';

  @override
  String get vpnsAndGuestIsolated =>
      'VPNs and guest / isolated Wi-Fi hide devices from each other.';

  @override
  String get localNetworkAccess => 'Local network access';

  @override
  String get allowCastflowToFind =>
      'Allow CastFlow to find devices on your network when asked.';

  @override
  String get noTvFound => 'No TV found';

  @override
  String get checkThatYourPhone =>
      'Check that your phone and TV are connected to the same Wi-Fi, then scan again.';

  @override
  String get noWiFiRouter => 'No Wi-Fi router? Use your hotspot';

  @override
  String searchingForTvsFound(Object length) {
    return 'Searching for TVs. $length found.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TVs found';
  }

  @override
  String get connectToYourTv => 'Connect to your TV';

  @override
  String get connectYourPhoneAndTv =>
      'Connect your phone and TV to the same Wi-Fi network.';

  @override
  String get turnOnTheTv =>
      'Turn on the TV and open its Screen Mirroring / Cast input.';

  @override
  String get tapTheConnectionBar =>
      'Tap the connection bar on Home to find your TV.';

  @override
  String get tapConnectAndAccept =>
      'Tap Connect and accept the prompt on the TV if one appears.';

  @override
  String get mirrorYourScreen => 'Mirror your screen';

  @override
  String get connectToYourTvFirst => 'Connect to your TV first.';

  @override
  String get openScreenMirroringFrom => 'Open Screen Mirroring from Home.';

  @override
  String get pickAQualityAnd => 'Pick a quality and tap Start.';

  @override
  String get allowScreenCaptureWhen =>
      'Allow screen capture when Android asks.';

  @override
  String get castPhotosVideosMusic => 'Cast photos, videos & music';

  @override
  String get openPhotosVideosOr => 'Open Photos, Videos or Music on Home.';

  @override
  String get pickWhatYouWant => 'Pick what you want to show.';

  @override
  String get itPlaysOnThe =>
      'It plays on the TV; control it from your phone or the notification.';

  @override
  String get useTheTvRemote => 'Use the TV remote';

  @override
  String get openTvRemoteOn => 'Open TV Remote on Home.';

  @override
  String get useTheDPad =>
      'Use the D-pad or swipe on the touchpad to move, tap OK to select.';

  @override
  String get buttonsATvDoesnt => 'Buttons a TV doesn’t support are greyed out.';

  @override
  String get castFromTheWeb => 'Cast from the web & apps';

  @override
  String get tapTheBrowserBar => 'Tap the browser bar or an app on Home.';

  @override
  String get playAVideoOn => 'Play a video on the site.';

  @override
  String get tapCastThisVideo => 'Tap “Cast this video” to send it to your TV.';

  @override
  String get screenMirroringHelp => 'Screen mirroring help';

  @override
  String get connectYourPhoneTo => 'Connect your phone to Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'On the TV, open Settings → Network and join the same Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Guest or office networks often block mirroring; use your home Wi-Fi or your phone’s hotspot.';

  @override
  String get turnOffVpn => 'Turn off VPN';

  @override
  String get aVpnHidesYour => 'A VPN hides your TV from your phone.';

  @override
  String get pauseOrDisconnectYour =>
      'Pause or disconnect your VPN app before you start.';

  @override
  String get youCanTurnIt => 'You can turn it back on when you’re done.';

  @override
  String get turnOnMirroringOn => 'Turn on mirroring on the TV';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG and most Android TVs accept mirroring automatically.';

  @override
  String get otherTvsOpenInput =>
      'Other TVs: open Input / Source and pick Screen Mirroring or Miracast.';

  @override
  String get keepTheTvOn =>
      'Keep the TV on that screen while your phone connects.';

  @override
  String get tapStartAndPick => 'Tap Start and pick your TV';

  @override
  String get tapStartOnThe => 'Tap Start on the Screen Mirroring screen.';

  @override
  String get androidOpensSmartView =>
      'Android opens Smart View / Cast. Tap your TV in the list.';

  @override
  String get ifTheTvAsks =>
      'If the TV asks, choose Allow or enter the PIN shown on screen.';

  @override
  String get youreMirroring => 'You’re mirroring';

  @override
  String get everythingOnYourPhone =>
      'Everything on your phone now shows on the TV.';

  @override
  String get turnThePhoneSideways =>
      'Turn the phone sideways for full-screen videos and games.';

  @override
  String get toStopTapStop => 'To stop, tap Stop or use the cast notification.';

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
  String get bedroomTv => 'Bedroom TV';

  @override
  String get officeDisplay => 'Office display';

  @override
  String get clearHistory => 'Clear history?';

  @override
  String get thisRemovesEverythingYouve =>
      'This removes everything you’ve cast from this list.';

  @override
  String get clear => 'Clear';

  @override
  String get clearHistory2 => 'Clear history';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get everythingYouCastWill =>
      'Everything you cast will be listed here so you can find it again.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get earlier => 'Earlier';

  @override
  String get swipeAnItemTo => 'Swipe an item to remove it';

  @override
  String get delete => 'Delete';

  @override
  String removed(Object title) {
    return 'Removed “$title”';
  }

  @override
  String get undo => 'Undo';

  @override
  String get photos => 'Photos';

  @override
  String get albums => 'Albums';

  @override
  String get videos => 'Videos';

  @override
  String get gallery => 'Gallery';

  @override
  String get music => 'Music';

  @override
  String get songs => 'Songs';

  @override
  String get media => 'Media';

  @override
  String get browseTheWeb => 'Browse the web';

  @override
  String get goPro => 'Go Pro';

  @override
  String cast(Object title) {
    return 'Cast $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Screen Mirroring. Start mirroring';

  @override
  String readyToMirrorTo(Object device) {
    return 'Ready to mirror to $device';
  }

  @override
  String get showYourPhoneOn => 'Show your phone on the TV in real time.';

  @override
  String get startMirroring => 'Start Mirroring';

  @override
  String get tvRemote => 'TV Remote';

  @override
  String get controlYourTv => 'Control your TV';

  @override
  String get youtubeMore => 'YouTube & more';

  @override
  String get openTheBrowser => 'Open the browser';

  @override
  String get searchOrTypeA => 'Search or type a website';

  @override
  String get howToConnectOpen => 'How to connect. Open the visual guide';

  @override
  String get visualGuideForEvery => 'Visual guide for every feature';

  @override
  String get language => 'Language';

  @override
  String get done => 'Done';

  @override
  String get enterAValidHttp =>
      'Enter a valid http(s) or rtsp link, e.g. an .m3u8 or .mp4 URL.';

  @override
  String get linkStream => 'Link stream';

  @override
  String get iptvLinkCast => 'IPTV / Link Cast';

  @override
  String get castALink => 'Cast a link';

  @override
  String get pasteADirectVideo =>
      'Paste a direct video, M3U8 or IPTV stream URL.';

  @override
  String get paste => 'Paste';

  @override
  String get castLink => 'Cast link';

  @override
  String get allowAccessToYour =>
      'Allow access to your media to cast it. You can change this in Settings.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Cast Music';

  @override
  String get noMusicFound => 'No music found';

  @override
  String get addSongsToYour =>
      'Add songs to your phone and they’ll show up here.';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get playAll => 'Play all';

  @override
  String photo(Object formatShortDate) {
    return 'Photo · $formatShortDate';
  }

  @override
  String get photo2 => 'Photo';

  @override
  String get castPhotos => 'Cast Photos';

  @override
  String get select => 'Select';

  @override
  String get noPhotosHere => 'No photos here';

  @override
  String get photosYouTakeOr =>
      'Photos you take or save will show up in this album.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count photos';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Photo from $formatShortDate';
  }

  @override
  String get allPhotos => 'All photos';

  @override
  String get slideshow => 'Slideshow';

  @override
  String get interval => 'Interval';

  @override
  String get transition => 'Transition';

  @override
  String get fade => 'Fade';

  @override
  String get slide => 'Slide';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Start slideshow';

  @override
  String get castVideos => 'Cast Videos';

  @override
  String get noVideosYet => 'No videos yet';

  @override
  String get videosYouRecordOr =>
      'Videos you record or download will appear here, ready to cast.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Cast';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Screen mirroring session';

  @override
  String get mirroringDidntStartTap =>
      'Mirroring didn’t start. Tap Start again and pick your TV in the list.';

  @override
  String get openSmartViewOr =>
      'Open Smart View or Cast from your phone’s quick settings to mirror.';

  @override
  String get quality => 'Quality';

  @override
  String get adjustsToYourWi =>
      'Adjusts to your Wi-Fi for the smoothest picture.';

  @override
  String upToLowerIt(Object label) {
    return 'Up to $label. Lower it if the picture stutters.';
  }

  @override
  String get stillNeedHelp => 'Still need help?';

  @override
  String get startingScreenMirroring => 'Starting screen mirroring…';

  @override
  String mirroringTo(Object value) {
    return 'Mirroring to $value';
  }

  @override
  String get stopping => 'Stopping…';

  @override
  String get readyToMirror => 'Ready to mirror';

  @override
  String get beforeYouStart => 'Before you start';

  @override
  String get phoneAndTvAre => 'Phone and TV are on the same Wi-Fi';

  @override
  String get noVpnIsConnected => 'No VPN is connected on your phone';

  @override
  String get tvIsOnWith => 'TV is on with Screen Mirroring enabled';

  @override
  String get phoneIsCloseTo => 'Phone is close to the TV';

  @override
  String get stopMirroring => 'Stop mirroring';

  @override
  String get startMirroring2 => 'Start mirroring';

  @override
  String get stop => 'Stop';

  @override
  String get start => 'Start';

  @override
  String get duration => 'Duration';

  @override
  String get adIsLoading => 'Ad is loading';

  @override
  String get ad => 'Ad';

  @override
  String get mirrorYourScreenTo => 'Mirror your screen to any TV';

  @override
  String get showYourPhoneOnThe =>
      'Show your phone on the big screen in one tap — no cables, no fuss.';

  @override
  String get shareMemoriesWithThe =>
      'Share memories with the whole room and keep control from your phone.';

  @override
  String get castFromWebApps => 'Cast from web & apps';

  @override
  String get sendVideosFromYoutube =>
      'Send videos from YouTube, Facebook and any website straight to your TV.';

  @override
  String pageOf(Object value, Object length) {
    return 'Page $value of $length';
  }

  @override
  String get getStarted => 'Get started';

  @override
  String get localNetwork => 'Local Network';

  @override
  String get findTvsAndStreaming =>
      'Find TVs and streaming devices on your Wi-Fi.';

  @override
  String get notifications => 'Notifications';

  @override
  String get showCastingControlsWhile =>
      'Show casting controls while you use other apps.';

  @override
  String get photosVideosMusic => 'Photos, Videos & Music';

  @override
  String get pickWhatYouWantTo =>
      'Pick what you want to cast from your gallery and library.';

  @override
  String get screenCapture => 'Screen Capture';

  @override
  String get mirrorYourScreenYoull =>
      'Mirror your screen. You’ll confirm each session.';

  @override
  String get webVideo => 'Web video';

  @override
  String get link => 'Link';

  @override
  String get screenMirroring2 => 'Screen mirroring';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Now casting $title. Open remote';
  }

  @override
  String castingTo2(Object value) {
    return 'Casting to $value';
  }

  @override
  String get nowCasting => 'Now casting';

  @override
  String get nothingIsCasting => 'Nothing is casting';

  @override
  String get pickAPhotoVideo =>
      'Pick a photo, video, song or web video to send it to your TV.';

  @override
  String get backToHome => 'Back to home';

  @override
  String slide2(Object formatDuration) {
    return 'Slide $formatDuration';
  }

  @override
  String get back10Seconds => 'Back 10 seconds';

  @override
  String get forward10Seconds => 'Forward 10 seconds';

  @override
  String get tvVolume => 'TV volume';

  @override
  String tvVolumePercent(Object round) {
    return 'TV volume $round percent';
  }

  @override
  String get upNext => 'Up next';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get addVideos => 'Add videos';

  @override
  String get nothingElseInThe => 'Nothing else in the queue.';

  @override
  String play2(Object title) {
    return 'Play $title';
  }

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String get perWeek => 'per week';

  @override
  String get perYear => 'per year';

  @override
  String get payOnce => 'pay once';

  @override
  String get wirelessScreenMirroring => 'Wireless screen mirroring';

  @override
  String get castVideosPhotosMusic => 'Cast videos, photos & music';

  @override
  String get fullTvRemoteControl => 'Full TV remote control';

  @override
  String get worksWithAllMajor => 'Works with all major TVs';

  @override
  String get smoothLagFreeStreaming => 'Smooth, lag-free streaming';

  @override
  String get noAds => 'No ads';

  @override
  String get welcomeToCastflowPro => 'Welcome to CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Purchase cancelled.';

  @override
  String get purchasePendingProUnlocks =>
      'Purchase pending. Pro unlocks as soon as the store confirms it.';

  @override
  String get purchaseFailedPleaseTry => 'Purchase failed. Please try again.';

  @override
  String get theStoreIsntAvailable => 'The store isn’t available right now.';

  @override
  String get close => 'Close';

  @override
  String get goProWithCastflow => 'GO PRO WITH CASTFLOW';

  @override
  String get unlockEveryFeature => 'Unlock every feature';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Renews automatically until cancelled.';

  @override
  String get oneTimePurchaseNo => 'One-time purchase. No subscription.';

  @override
  String get continueAction => 'Continue';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get cancelAnytime => 'Cancel anytime';

  @override
  String get loadingPrice => 'Loading price…';

  @override
  String get pricesUnavailableTapTo => 'Prices unavailable · Tap to retry';

  @override
  String get noPlansAvailableRight => 'No plans available right now.';

  @override
  String get weekly => 'Weekly';

  @override
  String get yearly => 'Yearly';

  @override
  String get lifetime => 'Lifetime';

  @override
  String get bestValue => 'Best value';

  @override
  String get disconnectFromTv => 'Disconnect from TV?';

  @override
  String get thisStopsWhatIs =>
      'This stops what is currently playing or being mirrored.';

  @override
  String get useTouchpad => 'Use touchpad';

  @override
  String get useDPad => 'Use D-pad';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label receivers don’t accept remote commands.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Some buttons are unavailable on $label.';
  }

  @override
  String get idle => 'IDLE';

  @override
  String get playing => 'PLAYING';

  @override
  String get paused => 'PAUSED';

  @override
  String get noTvConnected => 'No TV connected';

  @override
  String get mute2 => 'MUTE';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap => 'No TV connected. Tap to choose a device';

  @override
  String get tapToChooseA => 'Tap to choose a device';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label isn’t supported by $label2';
  }

  @override
  String get touchpadSwipeToMove => 'Touchpad. Swipe to move, tap to select.';

  @override
  String get swipeToMoveTap => 'Swipe to move · Tap to select';

  @override
  String get navigationIsntSupportedBy =>
      'Navigation isn’t supported by this TV';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automatic';

  @override
  String get googleCastFirst => 'Google Cast first';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP first';

  @override
  String get miracastFirst => 'Miracast first';

  @override
  String get tvOnly => 'TV only';

  @override
  String get phoneAndTv => 'Phone and TV';

  @override
  String get phoneOnly => 'Phone only';

  @override
  String get touchpad => 'Touchpad';

  @override
  String get doMyPhoneAnd => 'Do my phone and TV need the same Wi-Fi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Yes. Discovery and casting stay on your local network, so both must be on the same Wi-Fi (same band names can still be different networks).';

  @override
  String get myRouterHasAp => 'My router has “AP / client isolation”';

  @override
  String get isolationBlocksDevicesFrom =>
      'Isolation blocks devices from seeing each other. Turn it off in the router settings, or use a non-guest network.';

  @override
  String get findingYourTv => 'Finding your TV';

  @override
  String get myTvDoesntAppear => 'My TV doesn’t appear in the list';

  @override
  String get turnOnCastingScreen =>
      'Turn on casting / screen mirroring on the TV, wake it from standby, then tap Rescan. Allow the Local Network permission if asked.';

  @override
  String get onlySomeDevicesShow => 'Only some devices show up';

  @override
  String get olderTvsMayNeed =>
      'Older TVs may need a firmware update. Miracast TVs only appear while their “Screen Mirroring” input is open.';

  @override
  String get connectionFailsOrTimes => 'Connection fails or times out';

  @override
  String get restartTheTvApp =>
      'Restart the TV app or the TV, move closer to the router, and accept any prompt shown on the TV screen.';

  @override
  String get itKeepsReconnectingTo => 'It keeps reconnecting to an old TV';

  @override
  String get turnOffAutoConnect =>
      'Turn off “Auto-connect to last TV” in Settings → Casting.';

  @override
  String get mirroringIsLaggy => 'Mirroring is laggy';

  @override
  String get chooseALowerQuality =>
      'Choose a lower quality (720p or 480p), close heavy apps and use a 5 GHz Wi-Fi network.';

  @override
  String get thePictureIsRotated => 'The picture is rotated or cropped';

  @override
  String get toggleAutoRotateOn =>
      'Toggle Auto-rotate on the Screen Mirroring screen.';

  @override
  String get sound => 'Sound';

  @override
  String get thereIsNoSound => 'There is no sound on the TV';

  @override
  String get makeSureAudioIs =>
      'Make sure Audio is on in Screen Mirroring and check Settings → Casting → Audio output. Some receivers don’t support phone audio.';

  @override
  String get tvRemote2 => 'TV remote';

  @override
  String get someRemoteButtonsAre => 'Some remote buttons are greyed out';

  @override
  String get eachReceiverSupportsDifferent =>
      'Each receiver supports different commands. Chromecast and DLNA only support playback and volume; Miracast has no remote channel.';

  @override
  String get canCastflowTurnMy =>
      'Can CastFlow turn my TV on or change inputs?';

  @override
  String get onlyOnTvsThat =>
      'Only on TVs that expose those commands over the network. Unsupported buttons are disabled instead of pretending to work.';

  @override
  String get helpFaq => 'Help & FAQ';

  @override
  String get stepByStepConnection => 'Step-by-step connection guide';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'No email app found.';

  @override
  String get enjoyingCastflow => 'Enjoying CastFlow?';

  @override
  String get sorryToHearThat => 'Sorry to hear that';

  @override
  String get thanksHowCanWe => 'Thanks! How can we improve?';

  @override
  String get wereGladYouLike => 'We’re glad you like it!';

  @override
  String get youMadeOurDay => 'You made our day!';

  @override
  String get tapToExit => 'Tap to exit';

  @override
  String get selectARating => 'Select a rating';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get rateUs => 'Rate us';

  @override
  String get rateYourExperienceBefore => 'Rate your experience before you go.';

  @override
  String get tapAStarTo => 'Tap a star to rate CastFlow.';

  @override
  String get general => 'General';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Default quality';

  @override
  String get autoConnectToLast => 'Auto-connect to last TV';

  @override
  String get hapticFeedback => 'Haptic feedback';

  @override
  String get clearCastingHistory => 'Clear casting history';

  @override
  String get clearCastingHistory2 => 'Clear casting history?';

  @override
  String get onlyCastflowsListIs =>
      'Only CastFlow’s list is cleared. Media on your phone is never deleted.';

  @override
  String get appearance => 'Appearance';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get aboutSupport => 'About & support';

  @override
  String get rateApp => 'Rate app';

  @override
  String get feedback => 'Feedback';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get version => 'Version';

  @override
  String get castflowProIsActive => 'CastFlow Pro is active';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Thanks for your support. Enjoy ad-free casting.';

  @override
  String get noAds1080pMirroring =>
      'No ads, 1080p mirroring & unlimited casting';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get mirrorCastBeautifullySimple => 'Mirror & cast, beautifully simple';

  @override
  String get thisActionMayContain => 'This action may contain ads';

  @override
  String get webCast => 'Web Cast';

  @override
  String get castThisVideo => 'Cast this video';

  @override
  String get searchOrTypeAWeb => 'Search or type a web address';

  @override
  String get removeBookmark => 'Remove bookmark';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get quickAccess => 'Quick access';

  @override
  String open2(Object title) {
    return 'Open $title';
  }

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get noBookmarks => 'No bookmarks';

  @override
  String get tapTheBookmarkIcon =>
      'Tap the bookmark icon in the address bar to save a page.';

  @override
  String get noHistory => 'No history';

  @override
  String get pagesYouVisitShow => 'Pages you visit show up here.';

  @override
  String get remove => 'Remove';

  @override
  String resultOn(Object value, Object host) {
    return 'Result $value on $host';
  }

  @override
  String get aSimulatedPageResult => 'A simulated page result';

  @override
  String get videosOnThisPage => 'Videos on this page';

  @override
  String get pickOneToSend => 'Pick one to send to your TV.';

  @override
  String get onboardHotspotTitle => 'No Wi-Fi? Use your hotspot';

  @override
  String get onboardHotspotBody =>
      'Turn on your phone’s hotspot and connect your TV to it. Casting works just like on Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Still can’t find your TV?';

  @override
  String get stillCantFindBody =>
      'Connect your TV to your phone’s hotspot instead:';

  @override
  String get hotspotStep4 => 'Tap Retry and pick your TV from the list';

  @override
  String get castOverHotspot => 'No Wi-Fi? Cast over your phone’s hotspot:';

  @override
  String get queue => 'Queue';

  @override
  String get addMusic => 'Add music';

  @override
  String get connectWithWifi => 'Connect with Wi-Fi';

  @override
  String get continueWithHotspot => 'Continue with hotspot';

  @override
  String get noWifiAlertMessage =>
      'You’re on mobile data. Connect your phone and TV to the same Wi-Fi, or turn on your phone’s hotspot and join it from the TV.';
}
