// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get networkRequiredTitle => 'Wi-Fi에 연결되지 않음';

  @override
  String get networkRequiredMessage =>
      '캐스트하려면 휴대폰과 TV가 같은 Wi-Fi 네트워크에 있어야 합니다.';

  @override
  String get openWifiSettings => 'Wi-Fi 설정 열기';

  @override
  String get useMobileHotspot => '모바일 핫스팟 사용';

  @override
  String get hotspotInstruction => 'TV를 휴대폰의 모바일 핫스팟에 연결하세요.';

  @override
  String get hotspotStep1 => '모바일 핫스팟 켜기';

  @override
  String get hotspotStep2 => 'TV를 핫스팟에 연결하기';

  @override
  String get hotspotStep3 => '앱으로 돌아오기';

  @override
  String get openHotspotSettings => '핫스팟 설정 열기';

  @override
  String get hotspotAutoCheck => '돌아오시면 자동으로 다시 확인합니다.';

  @override
  String get hotspotDetected => '핫스팟이 켜져 있습니다. TV를 찾는 중…';

  @override
  String get searchingDevices => '주변 기기를 검색하는 중...';

  @override
  String get waitingForTvOnHotspot => 'TV가 핫스팟에 연결되기를 기다리는 중…';

  @override
  String get usingHotspot => '모바일 핫스팟 사용 중';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '기기 $count대를 찾았습니다',
      one: '기기 1대를 찾았습니다',
    );
    return '$_temp0';
  }

  @override
  String get retry => '다시 시도';

  @override
  String get scanAgain => '다시 검색';

  @override
  String get isolationTitle => 'TV가 응답하지 않음';

  @override
  String get isolationHint =>
      '기기가 핫스팟에 연결되었지만 응답하지 않습니다. 핫스팟이 기기 간 통신을 차단하고 있을 수 있습니다(클라이언트 격리). 핫스팟 설정에서 끄거나 Wi-Fi 네트워크를 사용하세요.';

  @override
  String get connecting => '연결 중…';

  @override
  String get connected => '연결됨';

  @override
  String get connectionFailed => '연결할 수 없음';

  @override
  String get connectFailedHint => '휴대폰과 TV가 같은 네트워크에 있는지 확인한 후 다시 시도하세요.';

  @override
  String get hotspotConnectHint =>
      '핫스팟이 기기 간 통신을 차단하고 있을 수 있습니다. 클라이언트 격리 설정을 확인하세요.';

  @override
  String get networkLostTitle => '네트워크 연결이 끊어짐';

  @override
  String get networkLostMessage => 'Wi-Fi 또는 핫스팟에 다시 연결한 후 TV에 다시 연결하세요.';

  @override
  String get reconnect => '다시 연결';

  @override
  String reconnectTo(String name) {
    return '$name에 다시 연결';
  }

  @override
  String get tapToReconnect => '탭하여 다시 연결';

  @override
  String get pairingRequired => '페어링 필요';

  @override
  String get pairingEnterCode => 'TV에 표시된 코드를 입력하세요.';

  @override
  String get pairingApproveOnTv => 'TV를 보고 계속하려면 허용을 탭하세요.';

  @override
  String get connect => '연결';

  @override
  String get cancel => '취소';

  @override
  String get pairingIncorrectCode => '코드가 올바르지 않습니다. 다시 시도하세요.';

  @override
  String get pairingTimedOut => '페어링 시간 초과';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get pairingDeclined => 'TV가 연결을 거부했습니다';

  @override
  String pairingTooManyAttempts(int seconds) {
    return '잘못된 코드가 너무 많습니다. $seconds초 기다린 후 새 코드를 요청하세요.';
  }

  @override
  String get pairingCooldownOver => '이제 새 코드를 요청할 수 있습니다.';

  @override
  String get pairingRequestNewCode => '새 코드 요청';

  @override
  String get pairingNetworkLost =>
      '페어링 중 네트워크가 끊어졌습니다. Wi-Fi에 다시 연결한 후 다시 시도하세요.';

  @override
  String get pairingFailed => 'TV와 페어링할 수 없습니다.';

  @override
  String pairingCodeField(int length) {
    return '페어링 코드, $length자리';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return '코드 칸 $index/$total';
  }

  @override
  String get pairingEmptyBox => '비어 있음';

  @override
  String get pairingPaired => '페어링됨';

  @override
  String get forgetDevice => '기기 삭제';

  @override
  String forgetDeviceMessage(String name) {
    return '다음에는 $name을(를) 다시 페어링해야 합니다.';
  }

  @override
  String get forget => '삭제';

  @override
  String get castVideo => '동영상 캐스트';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '동영상 $count개를 찾았습니다. 동영상 캐스트',
      one: '동영상 1개를 찾았습니다. 동영상 캐스트',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => '이 페이지에서 아직 동영상을 찾지 못했습니다.';

  @override
  String get videoFound => '동영상을 찾았습니다';

  @override
  String get videoFoundMessage => 'TV에서 재생하세요.';

  @override
  String get castAction => '캐스트';

  @override
  String get dismiss => '닫기';

  @override
  String videosFound(int count) {
    return '찾은 동영상 ($count)';
  }

  @override
  String get castToTv => 'TV로 캐스트';

  @override
  String get protectedVideo => '보호됨, 캐스트할 수 없음';

  @override
  String get videoThumbnail => '동영상 썸네일';

  @override
  String castingTo(String device) {
    return '$device(으)로 캐스트 중';
  }

  @override
  String get stopCasting => '캐스트 중지';

  @override
  String get play => '재생';

  @override
  String get pause => '일시정지';

  @override
  String get volume => '볼륨';

  @override
  String get seekPosition => '재생 위치';

  @override
  String get showControls => '컨트롤 표시';

  @override
  String get hideControls => '컨트롤 숨기기';

  @override
  String get formatUnsupportedTitle => '지원되지 않는 형식';

  @override
  String formatUnsupported(String device, String format) {
    return '$device에서 $format 동영상을 재생할 수 없습니다. 이 페이지의 다른 동영상을 시도하거나 화면 미러링을 사용하세요.';
  }

  @override
  String get videoExpired => '이 동영상 링크가 만료되었습니다. 페이지를 새로고침한 후 다시 시도하세요.';

  @override
  String get refreshingVideo => '새 동영상 링크를 가져오는 중…';

  @override
  String get browserBack => '뒤로';

  @override
  String get browserForward => '앞으로';

  @override
  String get browserStartPage => '시작 페이지';

  @override
  String get browserReload => '새로고침';

  @override
  String get ok => '확인';

  @override
  String get home => '홈';

  @override
  String get devices => '기기';

  @override
  String get history => '기록';

  @override
  String get settings => '설정';

  @override
  String get goodMorning => '좋은 아침입니다';

  @override
  String get goodAfternoon => '안녕하세요';

  @override
  String get goodEvening => '좋은 저녁입니다';

  @override
  String get couldntOpenTheLink => '링크를 열 수 없습니다.';

  @override
  String get castflowLogo => 'CastFlow 로고';

  @override
  String get somethingWentWrong => '문제가 발생했습니다';

  @override
  String get weCouldntLoadThis => '지금은 불러올 수 없습니다. 다시 시도해 주세요.';

  @override
  String get apps => '앱';

  @override
  String open(Object name) {
    return '$name 열기';
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
  String get up => '위';

  @override
  String get down => '아래';

  @override
  String get left => '왼쪽';

  @override
  String get right => '오른쪽';

  @override
  String get menu => '메뉴';

  @override
  String get input => '입력';

  @override
  String get playPause => '재생 / 일시정지';

  @override
  String get previous => '이전';

  @override
  String get next => '다음';

  @override
  String get rewind => '되감기';

  @override
  String get volumeUp => '볼륨 높이기';

  @override
  String get volumeDown => '볼륨 낮추기';

  @override
  String get mute => '음소거';

  @override
  String connectedTo(Object name) {
    return '$name에 연결됨';
  }

  @override
  String get chooseADevice => '기기 선택';

  @override
  String get connectionGuide => '연결 가이드';

  @override
  String get lookingForTvsOn => 'Wi-Fi에서 TV를 찾는 중';

  @override
  String foundSoFar(Object found) {
    return '지금까지 $found대 찾음';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '기기 $found대를 찾았습니다';
  }

  @override
  String get disconnect => '연결 해제';

  @override
  String signalOf4(Object level) {
    return '신호 $level/4';
  }

  @override
  String get connecting2 => '연결 중';

  @override
  String get theTvRemoteNeeds => 'TV 리모컨을 사용하려면 연결된 TV가 필요합니다. 아래에서 선택하세요.';

  @override
  String get connectToATv => '계속하려면 TV에 연결하세요.';

  @override
  String get findingTvs => 'TV를 찾는 중…';

  @override
  String get makeSureYourTv => 'TV가 켜져 있는지 확인하세요';

  @override
  String get notConnected => '연결되지 않음';

  @override
  String get tapToFindYour => '탭하여 TV 찾기';

  @override
  String get connectionFailed2 => '연결 실패';

  @override
  String tapToManageDevices(Object label) {
    return '$label. 탭하여 기기 관리';
  }

  @override
  String get joinTheSameWi => '같은 Wi-Fi에 연결';

  @override
  String get connectYourPhoneAnd => '휴대폰과 TV를 같은 Wi-Fi 네트워크에 연결하세요.';

  @override
  String get turnOnCastingOn => 'TV에서 캐스트 켜기';

  @override
  String get enableScreenMirroringMiracast =>
      'TV 설정에서 화면 미러링, Miracast 또는 Google Cast를 켜세요.';

  @override
  String get scanForDevices => '기기 검색';

  @override
  String get openDevicesInCastflow =>
      'CastFlow에서 기기를 열고 TV가 나타날 때까지 몇 초 기다리세요.';

  @override
  String get tapConnect => '연결 탭';

  @override
  String get acceptThePromptOn => 'TV에 메시지가 나타나면 수락하세요. 끝!';

  @override
  String get howToConnect => '연결 방법';

  @override
  String get fourQuickStepsTo => '큰 화면으로 연결하는 4가지 간단한 단계.';

  @override
  String get gotIt => '확인';

  @override
  String step(Object number, Object title, Object body) {
    return '$number단계. $title. $body';
  }

  @override
  String get homeWiFi => '집 Wi-Fi';

  @override
  String get router => '공유기';

  @override
  String get settingsConnection => '설정 › 연결';

  @override
  String get inputHdmi1 => '입력: HDMI 1';

  @override
  String get screenMirroring => '화면 미러링';

  @override
  String get networkHomeWiFi => '네트워크: 집 Wi-Fi';

  @override
  String get livingRoomTv => '거실 TV';

  @override
  String get allowCastflowToConnect => 'CastFlow의 연결을 허용할까요?';

  @override
  String get deny => '거부';

  @override
  String get allow => '허용';

  @override
  String get yourTv => '내 TV';

  @override
  String get findYourTv => 'TV 찾기';

  @override
  String connectTo(Object name) {
    return '$name에 연결';
  }

  @override
  String connected2(Object label) {
    return '연결됨 · $label';
  }

  @override
  String get openTvRemote => 'TV 리모컨 열기';

  @override
  String get sameWiFiNetwork => '같은 Wi-Fi 네트워크';

  @override
  String get yourPhoneAndTv => '휴대폰과 TV가 같은 Wi-Fi에 연결되어 있어야 합니다.';

  @override
  String get tvIsOnAnd => 'TV가 켜져 있고 준비됨';

  @override
  String get turnOnScreenMirroring => 'TV에서 화면 미러링, Cast 또는 Miracast를 켜세요.';

  @override
  String get noVpnOrGuest => 'VPN이나 게스트 네트워크 없음';

  @override
  String get vpnsAndGuestIsolated => 'VPN과 게스트/격리된 Wi-Fi는 기기끼리 서로 보이지 않게 합니다.';

  @override
  String get localNetworkAccess => '로컬 네트워크 액세스';

  @override
  String get allowCastflowToFind => '요청 시 CastFlow가 네트워크에서 기기를 찾도록 허용하세요.';

  @override
  String get noTvFound => 'TV를 찾을 수 없음';

  @override
  String get checkThatYourPhone =>
      '휴대폰과 TV가 같은 Wi-Fi에 연결되어 있는지 확인한 후 다시 검색하세요.';

  @override
  String get noWiFiRouter => 'Wi-Fi 공유기가 없나요? 핫스팟을 사용하세요';

  @override
  String searchingForTvsFound(Object length) {
    return 'TV를 찾는 중. $length대 찾음.';
  }

  @override
  String tvsFound(Object length) {
    return 'TV $length대를 찾았습니다';
  }

  @override
  String get connectToYourTv => 'TV에 연결';

  @override
  String get connectYourPhoneAndTv => '휴대폰과 TV를 같은 Wi-Fi 네트워크에 연결하세요.';

  @override
  String get turnOnTheTv => 'TV를 켜고 화면 미러링 / Cast 입력을 여세요.';

  @override
  String get tapTheConnectionBar => '홈의 연결 막대를 탭하여 TV를 찾으세요.';

  @override
  String get tapConnectAndAccept => '연결을 탭하고 TV에 메시지가 나타나면 수락하세요.';

  @override
  String get mirrorYourScreen => '화면 미러링';

  @override
  String get connectToYourTvFirst => '먼저 TV에 연결하세요.';

  @override
  String get openScreenMirroringFrom => '홈에서 화면 미러링을 여세요.';

  @override
  String get pickAQualityAnd => '화질을 선택하고 시작을 탭하세요.';

  @override
  String get allowScreenCaptureWhen => 'Android에서 요청하면 화면 캡처를 허용하세요.';

  @override
  String get castPhotosVideosMusic => '사진, 동영상, 음악 캐스트';

  @override
  String get openPhotosVideosOr => '홈에서 사진, 동영상 또는 음악을 여세요.';

  @override
  String get pickWhatYouWant => '보여 줄 항목을 선택하세요.';

  @override
  String get itPlaysOnThe => 'TV에서 재생됩니다. 휴대폰이나 알림에서 제어하세요.';

  @override
  String get useTheTvRemote => 'TV 리모컨 사용';

  @override
  String get openTvRemoteOn => '홈에서 TV 리모컨을 여세요.';

  @override
  String get useTheDPad => '방향 패드를 사용하거나 터치패드에서 스와이프하여 이동하고, OK를 탭하여 선택하세요.';

  @override
  String get buttonsATvDoesnt => 'TV가 지원하지 않는 버튼은 회색으로 표시됩니다.';

  @override
  String get castFromTheWeb => '웹과 앱에서 캐스트';

  @override
  String get tapTheBrowserBar => '홈에서 브라우저 막대나 앱을 탭하세요.';

  @override
  String get playAVideoOn => '사이트에서 동영상을 재생하세요.';

  @override
  String get tapCastThisVideo => '“이 동영상 캐스트”를 탭하여 TV로 보내세요.';

  @override
  String get screenMirroringHelp => '화면 미러링 도움말';

  @override
  String get connectYourPhoneTo => '휴대폰을 Wi-Fi에 연결하세요.';

  @override
  String get onTheTvOpen => 'TV에서 설정 → 네트워크를 열고 같은 Wi-Fi에 연결하세요.';

  @override
  String get guestOrOfficeNetworks =>
      '게스트나 사무실 네트워크는 미러링을 막는 경우가 많습니다. 집 Wi-Fi나 휴대폰 핫스팟을 사용하세요.';

  @override
  String get turnOffVpn => 'VPN 끄기';

  @override
  String get aVpnHidesYour => 'VPN은 휴대폰에서 TV가 보이지 않게 합니다.';

  @override
  String get pauseOrDisconnectYour => '시작하기 전에 VPN 앱을 일시정지하거나 연결을 끊으세요.';

  @override
  String get youCanTurnIt => '끝나면 다시 켤 수 있습니다.';

  @override
  String get turnOnMirroringOn => 'TV에서 미러링 켜기';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG 및 대부분의 Android TV는 미러링을 자동으로 수락합니다.';

  @override
  String get otherTvsOpenInput =>
      '다른 TV: 입력 / 소스를 열고 화면 미러링 또는 Miracast를 선택하세요.';

  @override
  String get keepTheTvOn => '휴대폰이 연결되는 동안 TV를 그 화면에 두세요.';

  @override
  String get tapStartAndPick => '시작을 탭하고 TV 선택';

  @override
  String get tapStartOnThe => '화면 미러링 화면에서 시작을 탭하세요.';

  @override
  String get androidOpensSmartView =>
      'Android에서 Smart View / Cast가 열립니다. 목록에서 TV를 탭하세요.';

  @override
  String get ifTheTvAsks => 'TV에서 묻으면 허용을 선택하거나 화면에 표시된 PIN을 입력하세요.';

  @override
  String get youreMirroring => '미러링 중입니다';

  @override
  String get everythingOnYourPhone => '휴대폰의 모든 화면이 이제 TV에 표시됩니다.';

  @override
  String get turnThePhoneSideways => '전체 화면 동영상과 게임은 휴대폰을 가로로 돌리세요.';

  @override
  String get toStopTapStop => '중지하려면 중지를 탭하거나 캐스트 알림을 사용하세요.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => '꺼짐';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => '침실 TV';

  @override
  String get officeDisplay => '사무실 디스플레이';

  @override
  String get clearHistory => '기록을 지울까요?';

  @override
  String get thisRemovesEverythingYouve => '캐스트한 모든 항목이 이 목록에서 삭제됩니다.';

  @override
  String get clear => '지우기';

  @override
  String get clearHistory2 => '기록 지우기';

  @override
  String get noHistoryYet => '아직 기록이 없습니다';

  @override
  String get everythingYouCastWill => '캐스트한 모든 항목이 여기에 표시되어 다시 쉽게 찾을 수 있습니다.';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get earlier => '이전';

  @override
  String get swipeAnItemTo => '항목을 스와이프하여 삭제';

  @override
  String get delete => '삭제';

  @override
  String removed(Object title) {
    return '“$title” 삭제됨';
  }

  @override
  String get undo => '실행 취소';

  @override
  String get photos => '사진';

  @override
  String get albums => '앨범';

  @override
  String get videos => '동영상';

  @override
  String get gallery => '갤러리';

  @override
  String get music => '음악';

  @override
  String get songs => '노래';

  @override
  String get media => '미디어';

  @override
  String get browseTheWeb => '웹 탐색';

  @override
  String get goPro => 'Pro 시작하기';

  @override
  String cast(Object title) {
    return '$title 캐스트';
  }

  @override
  String get screenMirroringStartMirroring => '화면 미러링. 미러링 시작';

  @override
  String readyToMirrorTo(Object device) {
    return '$device(으)로 미러링할 준비 완료';
  }

  @override
  String get showYourPhoneOn => '휴대폰 화면을 TV에 실시간으로 보여 주세요.';

  @override
  String get startMirroring => '미러링 시작';

  @override
  String get tvRemote => 'TV 리모컨';

  @override
  String get controlYourTv => 'TV 제어';

  @override
  String get youtubeMore => 'YouTube 등';

  @override
  String get openTheBrowser => '브라우저 열기';

  @override
  String get searchOrTypeA => '검색하거나 웹사이트 입력';

  @override
  String get howToConnectOpen => '연결 방법. 비주얼 가이드 열기';

  @override
  String get visualGuideForEvery => '모든 기능의 비주얼 가이드';

  @override
  String get language => '언어';

  @override
  String get done => '완료';

  @override
  String get enterAValidHttp =>
      '올바른 http(s) 또는 rtsp 링크를 입력하세요. 예: .m3u8 또는 .mp4 URL.';

  @override
  String get linkStream => '링크 스트림';

  @override
  String get iptvLinkCast => 'IPTV / 링크 캐스트';

  @override
  String get castALink => '링크 캐스트';

  @override
  String get pasteADirectVideo => '직접 동영상, M3U8 또는 IPTV 스트림 URL을 붙여넣으세요.';

  @override
  String get paste => '붙여넣기';

  @override
  String get castLink => '링크 캐스트';

  @override
  String get allowAccessToYour => '미디어를 캐스트하려면 접근을 허용하세요. 설정에서 변경할 수 있습니다.';

  @override
  String get video => '동영상';

  @override
  String get castMusic => '음악 캐스트';

  @override
  String get noMusicFound => '음악을 찾을 수 없음';

  @override
  String get addSongsToYour => '휴대폰에 노래를 추가하면 여기에 표시됩니다.';

  @override
  String get shuffle => '셔플';

  @override
  String get playAll => '모두 재생';

  @override
  String photo(Object formatShortDate) {
    return '사진 · $formatShortDate';
  }

  @override
  String get photo2 => '사진';

  @override
  String get castPhotos => '사진 캐스트';

  @override
  String get select => '선택';

  @override
  String get noPhotosHere => '여기에 사진이 없습니다';

  @override
  String get photosYouTakeOr => '촬영하거나 저장한 사진이 이 앨범에 표시됩니다.';

  @override
  String photos2(Object name, Object count) {
    return '$name, 사진 $count장';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return '$formatShortDate의 사진';
  }

  @override
  String get allPhotos => '모든 사진';

  @override
  String get slideshow => '슬라이드쇼';

  @override
  String get interval => '간격';

  @override
  String get transition => '전환';

  @override
  String get fade => '페이드';

  @override
  String get slide => '슬라이드';

  @override
  String get zoom => '줌';

  @override
  String get startSlideshow => '슬라이드쇼 시작';

  @override
  String get castVideos => '동영상 캐스트';

  @override
  String get noVideosYet => '아직 동영상이 없습니다';

  @override
  String get videosYouRecordOr => '촬영하거나 다운로드한 동영상이 여기에 표시되어 바로 캐스트할 수 있습니다.';

  @override
  String video2(Object resolution) {
    return '동영상 · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. 캐스트';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => '화면 미러링 세션';

  @override
  String get mirroringDidntStartTap =>
      '미러링이 시작되지 않았습니다. 시작을 다시 탭하고 목록에서 TV를 선택하세요.';

  @override
  String get openSmartViewOr => '미러링하려면 휴대폰 빠른 설정에서 Smart View 또는 Cast를 여세요.';

  @override
  String get quality => '화질';

  @override
  String get adjustsToYourWi => '가장 부드러운 화면을 위해 Wi-Fi에 맞게 조정됩니다.';

  @override
  String upToLowerIt(Object label) {
    return '최대 $label. 화면이 끊기면 낮추세요.';
  }

  @override
  String get stillNeedHelp => '도움이 필요하신가요?';

  @override
  String get startingScreenMirroring => '화면 미러링을 시작하는 중…';

  @override
  String mirroringTo(Object value) {
    return '$value(으)로 미러링 중';
  }

  @override
  String get stopping => '중지하는 중…';

  @override
  String get readyToMirror => '미러링 준비 완료';

  @override
  String get beforeYouStart => '시작하기 전에';

  @override
  String get phoneAndTvAre => '휴대폰과 TV가 같은 Wi-Fi에 있음';

  @override
  String get noVpnIsConnected => '휴대폰에 연결된 VPN이 없음';

  @override
  String get tvIsOnWith => 'TV가 켜져 있고 화면 미러링이 사용 설정됨';

  @override
  String get phoneIsCloseTo => '휴대폰이 TV 가까이에 있음';

  @override
  String get stopMirroring => '미러링 중지';

  @override
  String get startMirroring2 => '미러링 시작';

  @override
  String get stop => '중지';

  @override
  String get start => '시작';

  @override
  String get duration => '시간';

  @override
  String get adIsLoading => '광고 로드 중';

  @override
  String get ad => '광고';

  @override
  String get mirrorYourScreenTo => '어떤 TV에도 화면 미러링';

  @override
  String get showYourPhoneOnThe =>
      '탭 한 번으로 휴대폰을 큰 화면에 보여 주세요. 케이블도, 번거로움도 없습니다.';

  @override
  String get shareMemoriesWithThe => '추억을 모두와 함께 나누고 휴대폰으로 제어하세요.';

  @override
  String get castFromWebApps => '웹과 앱에서 캐스트';

  @override
  String get sendVideosFromYoutube =>
      'YouTube, Facebook 및 모든 웹사이트의 동영상을 TV로 바로 보내세요.';

  @override
  String pageOf(Object value, Object length) {
    return '$length페이지 중 $value페이지';
  }

  @override
  String get getStarted => '시작하기';

  @override
  String get localNetwork => '로컬 네트워크';

  @override
  String get findTvsAndStreaming => 'Wi-Fi에서 TV와 스트리밍 기기를 찾습니다.';

  @override
  String get notifications => '알림';

  @override
  String get showCastingControlsWhile => '다른 앱을 사용하는 동안 캐스트 컨트롤을 표시합니다.';

  @override
  String get photosVideosMusic => '사진, 동영상, 음악';

  @override
  String get pickWhatYouWantTo => '갤러리와 라이브러리에서 캐스트할 항목을 선택하세요.';

  @override
  String get screenCapture => '화면 캡처';

  @override
  String get mirrorYourScreenYoull => '화면을 미러링합니다. 세션마다 확인합니다.';

  @override
  String get webVideo => '웹 동영상';

  @override
  String get link => '링크';

  @override
  String get screenMirroring2 => '화면 미러링';

  @override
  String nowCastingOpenRemote(Object title) {
    return '$title 캐스트 중. 리모컨 열기';
  }

  @override
  String castingTo2(Object value) {
    return '$value(으)로 캐스트 중';
  }

  @override
  String get nowCasting => '지금 캐스트 중';

  @override
  String get nothingIsCasting => '캐스트 중인 항목 없음';

  @override
  String get pickAPhotoVideo => 'TV로 보낼 사진, 동영상, 노래 또는 웹 동영상을 선택하세요.';

  @override
  String get backToHome => '홈으로 돌아가기';

  @override
  String slide2(Object formatDuration) {
    return '슬라이드 $formatDuration';
  }

  @override
  String get back10Seconds => '10초 뒤로';

  @override
  String get forward10Seconds => '10초 앞으로';

  @override
  String get tvVolume => 'TV 볼륨';

  @override
  String tvVolumePercent(Object round) {
    return 'TV 볼륨 $round퍼센트';
  }

  @override
  String get upNext => '다음 항목';

  @override
  String get addPhotos => '사진 추가';

  @override
  String get addVideos => '동영상 추가';

  @override
  String get nothingElseInThe => '대기열에 더 이상 항목이 없습니다.';

  @override
  String play2(Object title) {
    return '$title 재생';
  }

  @override
  String get unknownDevice => '알 수 없는 기기';

  @override
  String get perWeek => '주당';

  @override
  String get perYear => '연간';

  @override
  String get payOnce => '한 번 결제';

  @override
  String get wirelessScreenMirroring => '무선 화면 미러링';

  @override
  String get castVideosPhotosMusic => '동영상, 사진, 음악 캐스트';

  @override
  String get fullTvRemoteControl => 'TV 리모컨 완전 제어';

  @override
  String get worksWithAllMajor => '모든 주요 TV와 호환';

  @override
  String get smoothLagFreeStreaming => '부드럽고 지연 없는 스트리밍';

  @override
  String get noAds => '광고 없음';

  @override
  String get welcomeToCastflowPro => 'CastFlow Pro에 오신 것을 환영합니다!';

  @override
  String get purchaseCancelled => '구매가 취소되었습니다.';

  @override
  String get purchasePendingProUnlocks =>
      '구매 보류 중입니다. 스토어가 확인하면 Pro가 바로 활성화됩니다.';

  @override
  String get purchaseFailedPleaseTry => '구매에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get theStoreIsntAvailable => '지금은 스토어를 사용할 수 없습니다.';

  @override
  String get close => '닫기';

  @override
  String get goProWithCastflow => 'CASTFLOW로 PRO 시작하기';

  @override
  String get unlockEveryFeature => '모든 기능 잠금 해제';

  @override
  String get renewsAutomaticallyUntilCancelled => '취소할 때까지 자동으로 갱신됩니다.';

  @override
  String get oneTimePurchaseNo => '한 번만 결제. 구독 없음.';

  @override
  String get continueAction => '계속';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get termsAndConditions => '이용약관';

  @override
  String get cancelAnytime => '언제든지 취소 가능';

  @override
  String get loadingPrice => '가격 불러오는 중…';

  @override
  String get pricesUnavailableTapTo => '가격을 불러올 수 없음 · 탭하여 다시 시도';

  @override
  String get noPlansAvailableRight => '지금은 이용 가능한 요금제가 없습니다.';

  @override
  String get weekly => '주간';

  @override
  String get yearly => '연간';

  @override
  String get lifetime => '평생';

  @override
  String get bestValue => '최고의 가치';

  @override
  String get disconnectFromTv => 'TV 연결을 해제할까요?';

  @override
  String get thisStopsWhatIs => '현재 재생 중이거나 미러링 중인 항목이 중지됩니다.';

  @override
  String get useTouchpad => '터치패드 사용';

  @override
  String get useDPad => '방향 패드 사용';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label 수신기는 리모컨 명령을 지원하지 않습니다.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return '$label에서는 일부 버튼을 사용할 수 없습니다.';
  }

  @override
  String get idle => '대기 중';

  @override
  String get playing => '재생 중';

  @override
  String get paused => '일시정지됨';

  @override
  String get noTvConnected => '연결된 TV 없음';

  @override
  String get mute2 => '음소거';

  @override
  String vol(Object volume) {
    return '볼륨 $volume';
  }

  @override
  String get noTvConnectedTap => '연결된 TV 없음. 탭하여 기기 선택';

  @override
  String get tapToChooseA => '탭하여 기기 선택';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label은(는) $label2에서 지원되지 않습니다';
  }

  @override
  String get touchpadSwipeToMove => '터치패드. 스와이프하여 이동하고 탭하여 선택하세요.';

  @override
  String get swipeToMoveTap => '스와이프하여 이동 · 탭하여 선택';

  @override
  String get navigationIsntSupportedBy => '이 TV는 탐색을 지원하지 않습니다';

  @override
  String get vol2 => '볼륨';

  @override
  String get auto => '자동';

  @override
  String get automatic => '자동';

  @override
  String get googleCastFirst => 'Google Cast 우선';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP 우선';

  @override
  String get miracastFirst => 'Miracast 우선';

  @override
  String get tvOnly => 'TV만';

  @override
  String get phoneAndTv => '휴대폰과 TV';

  @override
  String get phoneOnly => '휴대폰만';

  @override
  String get touchpad => '터치패드';

  @override
  String get doMyPhoneAnd => '휴대폰과 TV가 같은 Wi-Fi에 있어야 하나요?';

  @override
  String get yesDiscoveryAndCasting =>
      '네. 검색과 캐스트는 로컬 네트워크 안에서 이루어지므로 둘 다 같은 Wi-Fi에 있어야 합니다(비슷한 대역 이름도 다른 네트워크일 수 있습니다).';

  @override
  String get myRouterHasAp => '공유기에 “AP / 클라이언트 격리”가 있습니다';

  @override
  String get isolationBlocksDevicesFrom =>
      '격리는 기기끼리 서로 보이지 않게 합니다. 공유기 설정에서 끄거나 게스트가 아닌 네트워크를 사용하세요.';

  @override
  String get findingYourTv => 'TV 찾기';

  @override
  String get myTvDoesntAppear => 'TV가 목록에 나타나지 않습니다';

  @override
  String get turnOnCastingScreen =>
      'TV에서 캐스트 / 화면 미러링을 켜고 대기 모드에서 깨운 뒤 다시 검색을 탭하세요. 요청 시 로컬 네트워크 권한을 허용하세요.';

  @override
  String get onlySomeDevicesShow => '일부 기기만 표시됩니다';

  @override
  String get olderTvsMayNeed =>
      '오래된 TV는 펌웨어 업데이트가 필요할 수 있습니다. Miracast TV는 “화면 미러링” 입력이 열려 있을 때만 표시됩니다.';

  @override
  String get connectionFailsOrTimes => '연결이 실패하거나 시간이 초과됩니다';

  @override
  String get restartTheTvApp =>
      'TV 앱 또는 TV를 다시 시작하고 공유기에 가까이 가서 TV 화면에 나타나는 메시지를 수락하세요.';

  @override
  String get itKeepsReconnectingTo => '계속 예전 TV에 다시 연결됩니다';

  @override
  String get turnOffAutoConnect => '설정 → 캐스트에서 “마지막 TV에 자동 연결”을 끄세요.';

  @override
  String get mirroringIsLaggy => '미러링이 끊깁니다';

  @override
  String get chooseALowerQuality =>
      '더 낮은 화질(720p 또는 480p)을 선택하고, 무거운 앱을 닫고, 5GHz Wi-Fi 네트워크를 사용하세요.';

  @override
  String get thePictureIsRotated => '화면이 회전되었거나 잘렸습니다';

  @override
  String get toggleAutoRotateOn => '화면 미러링 화면에서 자동 회전을 켜거나 끄세요.';

  @override
  String get sound => '소리';

  @override
  String get thereIsNoSound => 'TV에서 소리가 나지 않습니다';

  @override
  String get makeSureAudioIs =>
      '화면 미러링에서 오디오가 켜져 있는지 확인하고 설정 → 캐스트 → 오디오 출력을 확인하세요. 일부 수신기는 휴대폰 오디오를 지원하지 않습니다.';

  @override
  String get tvRemote2 => 'TV 리모컨';

  @override
  String get someRemoteButtonsAre => '일부 리모컨 버튼이 회색입니다';

  @override
  String get eachReceiverSupportsDifferent =>
      '수신기마다 지원하는 명령이 다릅니다. Chromecast와 DLNA는 재생과 볼륨만 지원하며, Miracast에는 리모컨 채널이 없습니다.';

  @override
  String get canCastflowTurnMy => 'CastFlow로 TV를 켜거나 입력을 바꿀 수 있나요?';

  @override
  String get onlyOnTvsThat =>
      '네트워크로 해당 명령을 제공하는 TV에서만 가능합니다. 지원되지 않는 버튼은 작동하는 척하지 않고 비활성화됩니다.';

  @override
  String get helpFaq => '도움말 및 FAQ';

  @override
  String get stepByStepConnection => '단계별 연결 가이드';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => '이메일 앱을 찾을 수 없습니다.';

  @override
  String get enjoyingCastflow => 'CastFlow가 마음에 드시나요?';

  @override
  String get sorryToHearThat => '안타깝습니다';

  @override
  String get thanksHowCanWe => '감사합니다! 어떻게 개선할까요?';

  @override
  String get wereGladYouLike => '마음에 드셨다니 기쁩니다!';

  @override
  String get youMadeOurDay => '덕분에 기분 좋은 하루가 되었어요!';

  @override
  String get tapToExit => '탭하여 종료';

  @override
  String get selectARating => '평점 선택';

  @override
  String get sendFeedback => '피드백 보내기';

  @override
  String get rateUs => '평가하기';

  @override
  String get rateYourExperienceBefore => '나가기 전에 경험을 평가해 주세요.';

  @override
  String get tapAStarTo => '별을 탭하여 CastFlow를 평가하세요.';

  @override
  String get general => '일반';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => '기본 화질';

  @override
  String get autoConnectToLast => '마지막 TV에 자동 연결';

  @override
  String get hapticFeedback => '햅틱 피드백';

  @override
  String get clearCastingHistory => '캐스트 기록 지우기';

  @override
  String get clearCastingHistory2 => '캐스트 기록을 지울까요?';

  @override
  String get onlyCastflowsListIs => 'CastFlow의 목록만 지워집니다. 휴대폰의 미디어는 삭제되지 않습니다.';

  @override
  String get appearance => '화면 스타일';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String get system => '시스템';

  @override
  String get aboutSupport => '정보 및 지원';

  @override
  String get rateApp => '앱 평가';

  @override
  String get feedback => '피드백';

  @override
  String get termsConditions => '이용약관';

  @override
  String get version => '버전';

  @override
  String get castflowProIsActive => 'CastFlow Pro 사용 중';

  @override
  String get upgradeToPremium => '프리미엄으로 업그레이드';

  @override
  String get castflowPremium => 'CastFlow 프리미엄';

  @override
  String get thanksForYourSupport => '응원해 주셔서 감사합니다. 광고 없는 캐스트를 즐기세요.';

  @override
  String get noAds1080pMirroring => '광고 없음, 1080p 미러링 및 무제한 캐스트';

  @override
  String get upgrade => '업그레이드';

  @override
  String get mirrorCastBeautifullySimple => '미러링과 캐스트, 아름답도록 간단하게';

  @override
  String get thisActionMayContain => '이 작업에는 광고가 포함될 수 있습니다';

  @override
  String get webCast => '웹 캐스트';

  @override
  String get castThisVideo => '이 동영상 캐스트';

  @override
  String get searchOrTypeAWeb => '검색하거나 웹 주소 입력';

  @override
  String get removeBookmark => '북마크 삭제';

  @override
  String get bookmark => '북마크';

  @override
  String get quickAccess => '빠른 실행';

  @override
  String open2(Object title) {
    return '$title 열기';
  }

  @override
  String get bookmarks => '북마크';

  @override
  String get noBookmarks => '북마크 없음';

  @override
  String get tapTheBookmarkIcon => '주소 표시줄의 북마크 아이콘을 탭하여 페이지를 저장하세요.';

  @override
  String get noHistory => '기록 없음';

  @override
  String get pagesYouVisitShow => '방문한 페이지가 여기에 표시됩니다.';

  @override
  String get remove => '삭제';

  @override
  String resultOn(Object value, Object host) {
    return '$host의 결과 $value';
  }

  @override
  String get aSimulatedPageResult => '시뮬레이션된 페이지 결과';

  @override
  String get videosOnThisPage => '이 페이지의 동영상';

  @override
  String get pickOneToSend => 'TV로 보낼 항목을 하나 선택하세요.';

  @override
  String get onboardHotspotTitle => 'Wi-Fi가 없나요? 핫스팟을 사용하세요';

  @override
  String get onboardHotspotBody => '휴대폰 핫스팟을 켜고 TV를 연결하세요. Wi-Fi와 똑같이 전송됩니다.';

  @override
  String get stillCantFindTitle => '아직 TV를 찾지 못했나요?';

  @override
  String get stillCantFindBody => 'TV를 휴대폰 핫스팟에 연결하세요:';

  @override
  String get hotspotStep4 => '다시 시도를 누르고 목록에서 TV를 선택하세요';

  @override
  String get castOverHotspot => 'Wi-Fi가 없나요? 휴대폰 핫스팟으로 전송하세요:';

  @override
  String get queue => '대기열';

  @override
  String get addMusic => '음악 추가';

  @override
  String get connectWithWifi => 'Wi-Fi에 연결';

  @override
  String get continueWithHotspot => '핫스팟으로 계속';

  @override
  String get noWifiAlertMessage =>
      '모바일 데이터를 사용 중입니다. 휴대폰과 TV를 같은 Wi-Fi에 연결하거나 휴대폰 핫스팟을 켜고 TV에서 연결하세요.';
}
