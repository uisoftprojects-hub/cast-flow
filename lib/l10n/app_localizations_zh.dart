// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get networkRequiredTitle => '未连接到 Wi-Fi';

  @override
  String get networkRequiredMessage => '手机和电视必须在同一个 Wi-Fi 网络中才能投屏。';

  @override
  String get openWifiSettings => '打开 Wi-Fi 设置';

  @override
  String get useMobileHotspot => '使用移动热点';

  @override
  String get hotspotInstruction => '请将电视连接到手机的移动热点。';

  @override
  String get hotspotStep1 => '打开移动热点';

  @override
  String get hotspotStep2 => '让电视连接到该热点';

  @override
  String get hotspotStep3 => '返回应用';

  @override
  String get openHotspotSettings => '打开热点设置';

  @override
  String get hotspotAutoCheck => '您返回后，我们会自动再次检查。';

  @override
  String get hotspotDetected => '热点已开启。正在查找您的电视…';

  @override
  String get searchingDevices => '正在搜索附近的设备...';

  @override
  String get waitingForTvOnHotspot => '正在等待电视加入您的热点…';

  @override
  String get usingHotspot => '正在使用您的移动热点';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 台设备',
      one: '找到 1 台设备',
    );
    return '$_temp0';
  }

  @override
  String get retry => '重试';

  @override
  String get scanAgain => '重新扫描';

  @override
  String get isolationTitle => '电视无响应';

  @override
  String get isolationHint =>
      '有设备加入了您的热点但没有响应。热点可能阻止了设备之间的通信（客户端隔离）。请在热点设置中关闭该功能，或使用 Wi-Fi 网络。';

  @override
  String get connecting => '正在连接…';

  @override
  String get connected => '已连接';

  @override
  String get connectionFailed => '无法连接';

  @override
  String get connectFailedHint => '请确保手机和电视在同一网络中，然后重试。';

  @override
  String get hotspotConnectHint => '您的热点可能阻止了设备之间的通信。请检查客户端隔离设置。';

  @override
  String get networkLostTitle => '网络连接已断开';

  @override
  String get networkLostMessage => '请重新连接 Wi-Fi 或热点，然后重新连接电视。';

  @override
  String get reconnect => '重新连接';

  @override
  String reconnectTo(String name) {
    return '重新连接到 $name';
  }

  @override
  String get tapToReconnect => '点按以重新连接';

  @override
  String get pairingRequired => '需要配对';

  @override
  String get pairingEnterCode => '请输入电视上显示的代码。';

  @override
  String get pairingApproveOnTv => '请看电视并点按“允许”继续。';

  @override
  String get connect => '连接';

  @override
  String get cancel => '取消';

  @override
  String get pairingIncorrectCode => '代码不正确。请重试。';

  @override
  String get pairingTimedOut => '配对超时';

  @override
  String get tryAgain => '重试';

  @override
  String get pairingDeclined => '电视拒绝了连接';

  @override
  String pairingTooManyAttempts(int seconds) {
    return '错误代码过多。请等待 $seconds 秒，然后请求新代码。';
  }

  @override
  String get pairingCooldownOver => '您现在可以请求新代码。';

  @override
  String get pairingRequestNewCode => '请求新代码';

  @override
  String get pairingNetworkLost => '配对期间网络中断。请重新连接 Wi-Fi 后重试。';

  @override
  String get pairingFailed => '无法与电视配对。';

  @override
  String pairingCodeField(int length) {
    return '配对码，共 $length 位';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return '第 $index 格，共 $total 格';
  }

  @override
  String get pairingEmptyBox => '空';

  @override
  String get pairingPaired => '已配对';

  @override
  String get forgetDevice => '忘记设备';

  @override
  String forgetDeviceMessage(String name) {
    return '下次需要重新配对 $name。';
  }

  @override
  String get forget => '忘记';

  @override
  String get castVideo => '投放视频';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 个视频。投放视频',
      one: '找到 1 个视频。投放视频',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => '此页面上暂未找到视频。';

  @override
  String get videoFound => '发现视频';

  @override
  String get videoFoundMessage => '在电视上播放。';

  @override
  String get castAction => '投放';

  @override
  String get dismiss => '关闭';

  @override
  String videosFound(int count) {
    return '发现的视频（$count）';
  }

  @override
  String get castToTv => '投放到电视';

  @override
  String get protectedVideo => '受保护，无法投放';

  @override
  String get videoThumbnail => '视频缩略图';

  @override
  String castingTo(String device) {
    return '正在投放到 $device';
  }

  @override
  String get stopCasting => '停止投放';

  @override
  String get play => '播放';

  @override
  String get pause => '暂停';

  @override
  String get volume => '音量';

  @override
  String get seekPosition => '播放位置';

  @override
  String get showControls => '显示控件';

  @override
  String get hideControls => '隐藏控件';

  @override
  String get formatUnsupportedTitle => '不支持的格式';

  @override
  String formatUnsupported(String device, String format) {
    return '$device 无法播放 $format 视频。请尝试此页面上的其他视频，或使用屏幕镜像。';
  }

  @override
  String get videoExpired => '此视频链接已过期。请刷新页面后重试。';

  @override
  String get refreshingVideo => '正在获取新的视频链接…';

  @override
  String get browserBack => '返回';

  @override
  String get browserForward => '前进';

  @override
  String get browserStartPage => '起始页';

  @override
  String get browserReload => '刷新';

  @override
  String get ok => '确定';

  @override
  String get home => '首页';

  @override
  String get devices => '设备';

  @override
  String get history => '历史记录';

  @override
  String get settings => '设置';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get couldntOpenTheLink => '无法打开链接。';

  @override
  String get castflowLogo => 'CastFlow 标志';

  @override
  String get somethingWentWrong => '出了点问题';

  @override
  String get weCouldntLoadThis => '暂时无法加载。请重试。';

  @override
  String get apps => '应用';

  @override
  String open(Object name) {
    return '打开 $name';
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
  String get up => '上';

  @override
  String get down => '下';

  @override
  String get left => '左';

  @override
  String get right => '右';

  @override
  String get menu => '菜单';

  @override
  String get input => '输入';

  @override
  String get playPause => '播放 / 暂停';

  @override
  String get previous => '上一个';

  @override
  String get next => '下一个';

  @override
  String get rewind => '快退';

  @override
  String get volumeUp => '调大音量';

  @override
  String get volumeDown => '调小音量';

  @override
  String get mute => '静音';

  @override
  String connectedTo(Object name) {
    return '已连接到 $name';
  }

  @override
  String get chooseADevice => '选择设备';

  @override
  String get connectionGuide => '连接指南';

  @override
  String get lookingForTvsOn => '正在您的 Wi-Fi 中查找电视';

  @override
  String foundSoFar(Object found) {
    return '目前已找到 $found 台';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '找到 $found 台设备';
  }

  @override
  String get disconnect => '断开连接';

  @override
  String signalOf4(Object level) {
    return '信号 $level/4';
  }

  @override
  String get connecting2 => '正在连接';

  @override
  String get theTvRemoteNeeds => '电视遥控器需要已连接的电视。请在下方选择一台。';

  @override
  String get connectToATv => '请连接电视以继续。';

  @override
  String get findingTvs => '正在查找电视…';

  @override
  String get makeSureYourTv => '请确保电视已开机';

  @override
  String get notConnected => '未连接';

  @override
  String get tapToFindYour => '点按以查找电视';

  @override
  String get connectionFailed2 => '连接失败';

  @override
  String tapToManageDevices(Object label) {
    return '$label。点按以管理设备';
  }

  @override
  String get joinTheSameWi => '加入同一 Wi-Fi';

  @override
  String get connectYourPhoneAnd => '将手机和电视连接到同一个 Wi-Fi 网络。';

  @override
  String get turnOnCastingOn => '在电视上开启投屏';

  @override
  String get enableScreenMirroringMiracast =>
      '在电视设置中启用屏幕镜像、Miracast 或 Google Cast。';

  @override
  String get scanForDevices => '扫描设备';

  @override
  String get openDevicesInCastflow => '在 CastFlow 中打开“设备”，等待几秒，电视就会出现。';

  @override
  String get tapConnect => '点按“连接”';

  @override
  String get acceptThePromptOn => '如果电视上出现提示，请接受。就这么简单！';

  @override
  String get howToConnect => '如何连接';

  @override
  String get fourQuickStepsTo => '四个简单步骤，投到大屏幕。';

  @override
  String get gotIt => '知道了';

  @override
  String step(Object number, Object title, Object body) {
    return '第 $number 步。$title。$body';
  }

  @override
  String get homeWiFi => '家庭 Wi-Fi';

  @override
  String get router => '路由器';

  @override
  String get settingsConnection => '设置 › 连接';

  @override
  String get inputHdmi1 => '输入：HDMI 1';

  @override
  String get screenMirroring => '屏幕镜像';

  @override
  String get networkHomeWiFi => '网络：家庭 Wi-Fi';

  @override
  String get livingRoomTv => '客厅电视';

  @override
  String get allowCastflowToConnect => '允许 CastFlow 连接吗？';

  @override
  String get deny => '拒绝';

  @override
  String get allow => '允许';

  @override
  String get yourTv => '您的电视';

  @override
  String get findYourTv => '查找您的电视';

  @override
  String connectTo(Object name) {
    return '连接到 $name';
  }

  @override
  String connected2(Object label) {
    return '已连接 · $label';
  }

  @override
  String get openTvRemote => '打开电视遥控器';

  @override
  String get sameWiFiNetwork => '同一 Wi-Fi 网络';

  @override
  String get yourPhoneAndTv => '手机和电视必须连接到同一个 Wi-Fi。';

  @override
  String get tvIsOnAnd => '电视已开机并准备就绪';

  @override
  String get turnOnScreenMirroring => '在电视上打开屏幕镜像、Cast 或 Miracast。';

  @override
  String get noVpnOrGuest => '不使用 VPN 或访客网络';

  @override
  String get vpnsAndGuestIsolated => 'VPN 和访客/隔离的 Wi-Fi 会让设备彼此不可见。';

  @override
  String get localNetworkAccess => '本地网络访问';

  @override
  String get allowCastflowToFind => '在系统询问时，允许 CastFlow 查找您网络中的设备。';

  @override
  String get noTvFound => '未找到电视';

  @override
  String get checkThatYourPhone => '请检查手机和电视是否连接到同一个 Wi-Fi，然后重新扫描。';

  @override
  String get noWiFiRouter => '没有 Wi-Fi 路由器？使用您的热点';

  @override
  String searchingForTvsFound(Object length) {
    return '正在查找电视。已找到 $length 台。';
  }

  @override
  String tvsFound(Object length) {
    return '找到 $length 台电视';
  }

  @override
  String get connectToYourTv => '连接到您的电视';

  @override
  String get connectYourPhoneAndTv => '将手机和电视连接到同一个 Wi-Fi 网络。';

  @override
  String get turnOnTheTv => '打开电视并进入其屏幕镜像 / Cast 输入。';

  @override
  String get tapTheConnectionBar => '点按首页上的连接栏来查找电视。';

  @override
  String get tapConnectAndAccept => '点按“连接”，如果电视上出现提示请接受。';

  @override
  String get mirrorYourScreen => '镜像您的屏幕';

  @override
  String get connectToYourTvFirst => '请先连接电视。';

  @override
  String get openScreenMirroringFrom => '从首页打开屏幕镜像。';

  @override
  String get pickAQualityAnd => '选择画质并点按“开始”。';

  @override
  String get allowScreenCaptureWhen => '当 Android 询问时，允许屏幕录制。';

  @override
  String get castPhotosVideosMusic => '投放照片、视频和音乐';

  @override
  String get openPhotosVideosOr => '在首页打开照片、视频或音乐。';

  @override
  String get pickWhatYouWant => '选择要展示的内容。';

  @override
  String get itPlaysOnThe => '内容会在电视上播放；可通过手机或通知控制。';

  @override
  String get useTheTvRemote => '使用电视遥控器';

  @override
  String get openTvRemoteOn => '在首页打开电视遥控器。';

  @override
  String get useTheDPad => '使用方向键或在触控板上滑动来移动，点按 OK 选择。';

  @override
  String get buttonsATvDoesnt => '电视不支持的按钮会显示为灰色。';

  @override
  String get castFromTheWeb => '从网页和应用投放';

  @override
  String get tapTheBrowserBar => '点按首页上的浏览器栏或某个应用。';

  @override
  String get playAVideoOn => '在网站上播放视频。';

  @override
  String get tapCastThisVideo => '点按“投放此视频”即可发送到电视。';

  @override
  String get screenMirroringHelp => '屏幕镜像帮助';

  @override
  String get connectYourPhoneTo => '将手机连接到 Wi-Fi。';

  @override
  String get onTheTvOpen => '在电视上打开设置 → 网络，并加入同一个 Wi-Fi。';

  @override
  String get guestOrOfficeNetworks => '访客或办公网络常会阻止镜像；请使用家庭 Wi-Fi 或手机热点。';

  @override
  String get turnOffVpn => '关闭 VPN';

  @override
  String get aVpnHidesYour => 'VPN 会让手机看不到您的电视。';

  @override
  String get pauseOrDisconnectYour => '开始前请暂停或断开 VPN 应用。';

  @override
  String get youCanTurnIt => '完成后可以再次开启。';

  @override
  String get turnOnMirroringOn => '在电视上开启镜像';

  @override
  String get samsungLgAndMost => '三星、LG 和大多数 Android 电视会自动接受镜像。';

  @override
  String get otherTvsOpenInput => '其他电视：打开“输入 / 信号源”，选择屏幕镜像或 Miracast。';

  @override
  String get keepTheTvOn => '手机连接期间，请让电视停留在该界面。';

  @override
  String get tapStartAndPick => '点按“开始”并选择您的电视';

  @override
  String get tapStartOnThe => '在屏幕镜像界面点按“开始”。';

  @override
  String get androidOpensSmartView =>
      'Android 会打开 Smart View / Cast。在列表中点按您的电视。';

  @override
  String get ifTheTvAsks => '如果电视询问，请选择“允许”或输入屏幕上显示的 PIN。';

  @override
  String get youreMirroring => '您正在镜像';

  @override
  String get everythingOnYourPhone => '手机上的所有内容现在都显示在电视上。';

  @override
  String get turnThePhoneSideways => '将手机横过来可全屏观看视频和玩游戏。';

  @override
  String get toStopTapStop => '要停止，请点按“停止”或使用投放通知。';

  @override
  String get vpn => 'VPN';

  @override
  String get off => '关';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => '卧室电视';

  @override
  String get officeDisplay => '办公室显示器';

  @override
  String get clearHistory => '清除历史记录？';

  @override
  String get thisRemovesEverythingYouve => '这将从此列表中移除您投放过的所有内容。';

  @override
  String get clear => '清除';

  @override
  String get clearHistory2 => '清除历史记录';

  @override
  String get noHistoryYet => '暂无历史记录';

  @override
  String get everythingYouCastWill => '您投放的所有内容都会列在这里，方便再次找到。';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get earlier => '更早';

  @override
  String get swipeAnItemTo => '滑动项目即可移除';

  @override
  String get delete => '删除';

  @override
  String removed(Object title) {
    return '已移除“$title”';
  }

  @override
  String get undo => '撤销';

  @override
  String get photos => '照片';

  @override
  String get albums => '相册';

  @override
  String get videos => '视频';

  @override
  String get gallery => '图库';

  @override
  String get music => '音乐';

  @override
  String get songs => '歌曲';

  @override
  String get media => '媒体';

  @override
  String get browseTheWeb => '浏览网页';

  @override
  String get goPro => '升级 Pro';

  @override
  String cast(Object title) {
    return '投放 $title';
  }

  @override
  String get screenMirroringStartMirroring => '屏幕镜像。开始镜像';

  @override
  String readyToMirrorTo(Object device) {
    return '已准备好镜像到 $device';
  }

  @override
  String get showYourPhoneOn => '将手机屏幕实时显示在电视上。';

  @override
  String get startMirroring => '开始镜像';

  @override
  String get tvRemote => '电视遥控器';

  @override
  String get controlYourTv => '控制您的电视';

  @override
  String get youtubeMore => 'YouTube 等';

  @override
  String get openTheBrowser => '打开浏览器';

  @override
  String get searchOrTypeA => '搜索或输入网址';

  @override
  String get howToConnectOpen => '如何连接。打开图示指南';

  @override
  String get visualGuideForEvery => '每项功能的图示指南';

  @override
  String get language => '语言';

  @override
  String get done => '完成';

  @override
  String get enterAValidHttp => '请输入有效的 http(s) 或 rtsp 链接，例如 .m3u8 或 .mp4 网址。';

  @override
  String get linkStream => '链接流';

  @override
  String get iptvLinkCast => 'IPTV / 链接投放';

  @override
  String get castALink => '投放链接';

  @override
  String get pasteADirectVideo => '粘贴直接视频、M3U8 或 IPTV 流网址。';

  @override
  String get paste => '粘贴';

  @override
  String get castLink => '投放链接';

  @override
  String get allowAccessToYour => '请允许访问您的媒体以进行投放。您可以在设置中更改。';

  @override
  String get video => '视频';

  @override
  String get castMusic => '投放音乐';

  @override
  String get noMusicFound => '未找到音乐';

  @override
  String get addSongsToYour => '将歌曲添加到手机，它们会显示在这里。';

  @override
  String get shuffle => '随机播放';

  @override
  String get playAll => '全部播放';

  @override
  String photo(Object formatShortDate) {
    return '照片 · $formatShortDate';
  }

  @override
  String get photo2 => '照片';

  @override
  String get castPhotos => '投放照片';

  @override
  String get select => '选择';

  @override
  String get noPhotosHere => '这里没有照片';

  @override
  String get photosYouTakeOr => '您拍摄或保存的照片会显示在此相册中。';

  @override
  String photos2(Object name, Object count) {
    return '$name，$count 张照片';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return '$formatShortDate 的照片';
  }

  @override
  String get allPhotos => '所有照片';

  @override
  String get slideshow => '幻灯片';

  @override
  String get interval => '间隔';

  @override
  String get transition => '转场';

  @override
  String get fade => '淡入淡出';

  @override
  String get slide => '滑动';

  @override
  String get zoom => '缩放';

  @override
  String get startSlideshow => '开始幻灯片';

  @override
  String get castVideos => '投放视频';

  @override
  String get noVideosYet => '暂无视频';

  @override
  String get videosYouRecordOr => '您录制或下载的视频会显示在这里，随时可以投放。';

  @override
  String video2(Object resolution) {
    return '视频 · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title，$formatDuration。投放';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => '屏幕镜像会话';

  @override
  String get mirroringDidntStartTap => '镜像未开始。请再次点按“开始”，并在列表中选择您的电视。';

  @override
  String get openSmartViewOr => '要镜像，请从手机的快捷设置中打开 Smart View 或 Cast。';

  @override
  String get quality => '画质';

  @override
  String get adjustsToYourWi => '会根据您的 Wi-Fi 调整，以获得最流畅的画面。';

  @override
  String upToLowerIt(Object label) {
    return '最高 $label。画面卡顿时请调低。';
  }

  @override
  String get stillNeedHelp => '需要帮助？';

  @override
  String get startingScreenMirroring => '正在启动屏幕镜像…';

  @override
  String mirroringTo(Object value) {
    return '正在镜像到 $value';
  }

  @override
  String get stopping => '正在停止…';

  @override
  String get readyToMirror => '已准备好镜像';

  @override
  String get beforeYouStart => '开始之前';

  @override
  String get phoneAndTvAre => '手机和电视在同一个 Wi-Fi 上';

  @override
  String get noVpnIsConnected => '手机上未连接 VPN';

  @override
  String get tvIsOnWith => '电视已开机并启用屏幕镜像';

  @override
  String get phoneIsCloseTo => '手机靠近电视';

  @override
  String get stopMirroring => '停止镜像';

  @override
  String get startMirroring2 => '开始镜像';

  @override
  String get stop => '停止';

  @override
  String get start => '开始';

  @override
  String get duration => '时长';

  @override
  String get adIsLoading => '广告加载中';

  @override
  String get ad => '广告';

  @override
  String get mirrorYourScreenTo => '将屏幕镜像到任何电视';

  @override
  String get showYourPhoneOnThe => '轻点一下即可在大屏幕上显示手机，无需线缆，不再麻烦。';

  @override
  String get shareMemoriesWithThe => '与全屋人分享回忆，并用手机掌控一切。';

  @override
  String get castFromWebApps => '从网页和应用投放';

  @override
  String get sendVideosFromYoutube => '将 YouTube、Facebook 和任何网站的视频直接发送到电视。';

  @override
  String pageOf(Object value, Object length) {
    return '第 $value 页，共 $length 页';
  }

  @override
  String get getStarted => '开始使用';

  @override
  String get localNetwork => '本地网络';

  @override
  String get findTvsAndStreaming => '在您的 Wi-Fi 中查找电视和流媒体设备。';

  @override
  String get notifications => '通知';

  @override
  String get showCastingControlsWhile => '在使用其他应用时显示投放控件。';

  @override
  String get photosVideosMusic => '照片、视频和音乐';

  @override
  String get pickWhatYouWantTo => '从图库和媒体库中选择要投放的内容。';

  @override
  String get screenCapture => '屏幕录制';

  @override
  String get mirrorYourScreenYoull => '镜像您的屏幕。每次会话都需要您确认。';

  @override
  String get webVideo => '网页视频';

  @override
  String get link => '链接';

  @override
  String get screenMirroring2 => '屏幕镜像';

  @override
  String nowCastingOpenRemote(Object title) {
    return '正在投放 $title。打开遥控器';
  }

  @override
  String castingTo2(Object value) {
    return '正在投放到 $value';
  }

  @override
  String get nowCasting => '正在投放';

  @override
  String get nothingIsCasting => '没有正在投放的内容';

  @override
  String get pickAPhotoVideo => '选择照片、视频、歌曲或网页视频发送到电视。';

  @override
  String get backToHome => '返回首页';

  @override
  String slide2(Object formatDuration) {
    return '幻灯片 $formatDuration';
  }

  @override
  String get back10Seconds => '后退 10 秒';

  @override
  String get forward10Seconds => '快进 10 秒';

  @override
  String get tvVolume => '电视音量';

  @override
  String tvVolumePercent(Object round) {
    return '电视音量百分之 $round';
  }

  @override
  String get upNext => '接下来';

  @override
  String get addPhotos => '添加照片';

  @override
  String get addVideos => '添加视频';

  @override
  String get nothingElseInThe => '队列中没有更多内容。';

  @override
  String play2(Object title) {
    return '播放 $title';
  }

  @override
  String get unknownDevice => '未知设备';

  @override
  String get perWeek => '每周';

  @override
  String get perYear => '每年';

  @override
  String get payOnce => '一次性付费';

  @override
  String get wirelessScreenMirroring => '无线屏幕镜像';

  @override
  String get castVideosPhotosMusic => '投放视频、照片和音乐';

  @override
  String get fullTvRemoteControl => '完整的电视遥控功能';

  @override
  String get worksWithAllMajor => '适用于所有主流电视';

  @override
  String get smoothLagFreeStreaming => '流畅无卡顿的播放';

  @override
  String get noAds => '无广告';

  @override
  String get welcomeToCastflowPro => '欢迎使用 CastFlow Pro！';

  @override
  String get purchaseCancelled => '购买已取消。';

  @override
  String get purchasePendingProUnlocks => '购买待处理。商店确认后 Pro 将立即解锁。';

  @override
  String get purchaseFailedPleaseTry => '购买失败。请重试。';

  @override
  String get theStoreIsntAvailable => '商店暂时不可用。';

  @override
  String get close => '关闭';

  @override
  String get goProWithCastflow => '用 CASTFLOW 升级 PRO';

  @override
  String get unlockEveryFeature => '解锁所有功能';

  @override
  String get renewsAutomaticallyUntilCancelled => '在取消前自动续订。';

  @override
  String get oneTimePurchaseNo => '一次性购买。无需订阅。';

  @override
  String get continueAction => '继续';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsAndConditions => '条款和条件';

  @override
  String get cancelAnytime => '随时取消';

  @override
  String get loadingPrice => '正在加载价格…';

  @override
  String get pricesUnavailableTapTo => '价格不可用 · 点按重试';

  @override
  String get noPlansAvailableRight => '目前没有可用的套餐。';

  @override
  String get weekly => '每周';

  @override
  String get yearly => '每年';

  @override
  String get lifetime => '终身';

  @override
  String get bestValue => '超值之选';

  @override
  String get disconnectFromTv => '断开与电视的连接？';

  @override
  String get thisStopsWhatIs => '这将停止当前正在播放或镜像的内容。';

  @override
  String get useTouchpad => '使用触控板';

  @override
  String get useDPad => '使用方向键';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label 接收器不接受遥控命令。';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return '$label 上的某些按钮不可用。';
  }

  @override
  String get idle => '空闲';

  @override
  String get playing => '播放中';

  @override
  String get paused => '已暂停';

  @override
  String get noTvConnected => '未连接电视';

  @override
  String get mute2 => '静音';

  @override
  String vol(Object volume) {
    return '音量 $volume';
  }

  @override
  String get noTvConnectedTap => '未连接电视。点按以选择设备';

  @override
  String get tapToChooseA => '点按以选择设备';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label2 不支持 $label';
  }

  @override
  String get touchpadSwipeToMove => '触控板。滑动以移动，点按以选择。';

  @override
  String get swipeToMoveTap => '滑动以移动 · 点按以选择';

  @override
  String get navigationIsntSupportedBy => '此电视不支持导航';

  @override
  String get vol2 => '音量';

  @override
  String get auto => '自动';

  @override
  String get automatic => '自动';

  @override
  String get googleCastFirst => '优先 Google Cast';

  @override
  String get dlnaUpnpFirst => '优先 DLNA / UPnP';

  @override
  String get miracastFirst => '优先 Miracast';

  @override
  String get tvOnly => '仅电视';

  @override
  String get phoneAndTv => '手机和电视';

  @override
  String get phoneOnly => '仅手机';

  @override
  String get touchpad => '触控板';

  @override
  String get doMyPhoneAnd => '手机和电视需要在同一个 Wi-Fi 上吗？';

  @override
  String get yesDiscoveryAndCasting =>
      '是的。发现和投放都在您的本地网络内进行，所以两者必须在同一个 Wi-Fi 上（相似的频段名称可能是不同的网络）。';

  @override
  String get myRouterHasAp => '我的路由器启用了“AP / 客户端隔离”';

  @override
  String get isolationBlocksDevicesFrom => '隔离会阻止设备互相看到。请在路由器设置中关闭它，或使用非访客网络。';

  @override
  String get findingYourTv => '查找您的电视';

  @override
  String get myTvDoesntAppear => '我的电视没有出现在列表中';

  @override
  String get turnOnCastingScreen =>
      '在电视上开启投放 / 屏幕镜像，将其从待机中唤醒，然后点按“重新扫描”。如果询问，请允许本地网络权限。';

  @override
  String get onlySomeDevicesShow => '只显示部分设备';

  @override
  String get olderTvsMayNeed => '较旧的电视可能需要更新固件。Miracast 电视仅在其“屏幕镜像”输入打开时才会出现。';

  @override
  String get connectionFailsOrTimes => '连接失败或超时';

  @override
  String get restartTheTvApp => '重启电视应用或电视，靠近路由器，并接受电视屏幕上显示的任何提示。';

  @override
  String get itKeepsReconnectingTo => '总是重新连接到旧电视';

  @override
  String get turnOffAutoConnect => '在设置 → 投放中关闭“自动连接到上一台电视”。';

  @override
  String get mirroringIsLaggy => '镜像卡顿';

  @override
  String get chooseALowerQuality =>
      '选择较低的画质（720p 或 480p），关闭占用资源多的应用，并使用 5 GHz Wi-Fi 网络。';

  @override
  String get thePictureIsRotated => '画面旋转或被裁剪';

  @override
  String get toggleAutoRotateOn => '在屏幕镜像界面切换自动旋转。';

  @override
  String get sound => '声音';

  @override
  String get thereIsNoSound => '电视没有声音';

  @override
  String get makeSureAudioIs => '确保屏幕镜像中已开启音频，并检查设置 → 投放 → 音频输出。部分接收器不支持手机音频。';

  @override
  String get tvRemote2 => '电视遥控器';

  @override
  String get someRemoteButtonsAre => '部分遥控按钮显示为灰色';

  @override
  String get eachReceiverSupportsDifferent =>
      '每种接收器支持的命令不同。Chromecast 和 DLNA 仅支持播放和音量；Miracast 没有遥控通道。';

  @override
  String get canCastflowTurnMy => 'CastFlow 可以打开我的电视或切换输入吗？';

  @override
  String get onlyOnTvsThat => '仅限通过网络提供这些命令的电视。不支持的按钮会被禁用，而不是假装可用。';

  @override
  String get helpFaq => '帮助与常见问题';

  @override
  String get stepByStepConnection => '分步连接指南';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release（SDK $sdkInt）';
  }

  @override
  String get noEmailAppFound => '未找到电子邮件应用。';

  @override
  String get enjoyingCastflow => '喜欢 CastFlow 吗？';

  @override
  String get sorryToHearThat => '很抱歉听到这个';

  @override
  String get thanksHowCanWe => '谢谢！我们如何改进？';

  @override
  String get wereGladYouLike => '很高兴您喜欢！';

  @override
  String get youMadeOurDay => '您让我们很开心！';

  @override
  String get tapToExit => '点按退出';

  @override
  String get selectARating => '选择评分';

  @override
  String get sendFeedback => '发送反馈';

  @override
  String get rateUs => '给我们评分';

  @override
  String get rateYourExperienceBefore => '离开前，请为您的体验评分。';

  @override
  String get tapAStarTo => '点按星星为 CastFlow 评分。';

  @override
  String get general => '通用';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => '默认画质';

  @override
  String get autoConnectToLast => '自动连接到上一台电视';

  @override
  String get hapticFeedback => '触感反馈';

  @override
  String get clearCastingHistory => '清除投放历史记录';

  @override
  String get clearCastingHistory2 => '清除投放历史记录？';

  @override
  String get onlyCastflowsListIs => '仅清除 CastFlow 的列表。手机上的媒体不会被删除。';

  @override
  String get appearance => '外观';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get system => '跟随系统';

  @override
  String get aboutSupport => '关于与支持';

  @override
  String get rateApp => '给应用评分';

  @override
  String get feedback => '反馈';

  @override
  String get termsConditions => '条款和条件';

  @override
  String get version => '版本';

  @override
  String get castflowProIsActive => 'CastFlow Pro 已启用';

  @override
  String get upgradeToPremium => '升级到 Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport => '感谢您的支持。尽享无广告投放。';

  @override
  String get noAds1080pMirroring => '无广告、1080p 镜像和无限投放';

  @override
  String get upgrade => '升级';

  @override
  String get mirrorCastBeautifullySimple => '镜像与投放，简单又美观';

  @override
  String get thisActionMayContain => '此操作可能包含广告';

  @override
  String get webCast => '网页投放';

  @override
  String get castThisVideo => '投放此视频';

  @override
  String get searchOrTypeAWeb => '搜索或输入网址';

  @override
  String get removeBookmark => '移除书签';

  @override
  String get bookmark => '书签';

  @override
  String get quickAccess => '快速访问';

  @override
  String open2(Object title) {
    return '打开 $title';
  }

  @override
  String get bookmarks => '书签';

  @override
  String get noBookmarks => '没有书签';

  @override
  String get tapTheBookmarkIcon => '点按地址栏中的书签图标即可保存页面。';

  @override
  String get noHistory => '没有历史记录';

  @override
  String get pagesYouVisitShow => '您访问过的页面会显示在这里。';

  @override
  String get remove => '移除';

  @override
  String resultOn(Object value, Object host) {
    return '$host 上的结果 $value';
  }

  @override
  String get aSimulatedPageResult => '模拟的页面结果';

  @override
  String get videosOnThisPage => '此页面上的视频';

  @override
  String get pickOneToSend => '选择一个发送到电视。';

  @override
  String get onboardHotspotTitle => '没有 Wi-Fi？使用热点';

  @override
  String get onboardHotspotBody => '打开手机热点并将电视连接到热点，投屏与 Wi-Fi 下一样。';

  @override
  String get stillCantFindTitle => '还是找不到电视？';

  @override
  String get stillCantFindBody => '将电视连接到手机热点：';

  @override
  String get hotspotStep4 => '点击重试，然后从列表中选择电视';

  @override
  String get castOverHotspot => '没有 Wi-Fi？通过手机热点投屏：';

  @override
  String get queue => '播放队列';

  @override
  String get addMusic => '添加音乐';

  @override
  String get connectWithWifi => '连接 Wi-Fi';

  @override
  String get continueWithHotspot => '使用热点继续';

  @override
  String get noWifiAlertMessage =>
      '您正在使用移动数据。请将手机和电视连接到同一 Wi-Fi，或打开手机热点并让电视连接该热点。';
}
