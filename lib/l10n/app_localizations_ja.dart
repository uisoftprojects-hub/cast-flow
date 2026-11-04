// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get networkRequiredTitle => 'Wi-Fiに接続されていません';

  @override
  String get networkRequiredMessage =>
      'キャストするには、スマートフォンとテレビが同じWi-Fiネットワークに接続されている必要があります。';

  @override
  String get openWifiSettings => 'Wi-Fi設定を開く';

  @override
  String get useMobileHotspot => 'モバイルホットスポットを使う';

  @override
  String get hotspotInstruction => 'テレビをスマートフォンのモバイルホットスポットに接続してください。';

  @override
  String get hotspotStep1 => 'モバイルホットスポットをオンにする';

  @override
  String get hotspotStep2 => 'テレビをそれに接続する';

  @override
  String get hotspotStep3 => 'アプリに戻る';

  @override
  String get openHotspotSettings => 'ホットスポット設定を開く';

  @override
  String get hotspotAutoCheck => '戻ると自動的に再確認します。';

  @override
  String get hotspotDetected => 'ホットスポットがオンです。テレビを探しています…';

  @override
  String get searchingDevices => '近くのデバイスを検索しています...';

  @override
  String get waitingForTvOnHotspot => 'テレビがホットスポットに参加するのを待っています…';

  @override
  String get usingHotspot => 'モバイルホットスポットを使用中';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count台のデバイスが見つかりました',
      one: '1台のデバイスが見つかりました',
    );
    return '$_temp0';
  }

  @override
  String get retry => '再試行';

  @override
  String get scanAgain => 'もう一度スキャン';

  @override
  String get isolationTitle => 'テレビが応答しません';

  @override
  String get isolationHint =>
      'デバイスがホットスポットに参加しましたが応答しません。ホットスポットがデバイス間の通信をブロックしている可能性があります（クライアント分離）。ホットスポット設定でオフにするか、Wi-Fiネットワークを使ってください。';

  @override
  String get connecting => '接続中…';

  @override
  String get connected => '接続済み';

  @override
  String get connectionFailed => '接続できませんでした';

  @override
  String get connectFailedHint => 'スマートフォンとテレビが同じネットワークにあることを確認して、もう一度お試しください。';

  @override
  String get hotspotConnectHint =>
      'ホットスポットがデバイス間の通信をブロックしている可能性があります。クライアント分離の設定を確認してください。';

  @override
  String get networkLostTitle => 'ネットワーク接続が切れました';

  @override
  String get networkLostMessage => 'Wi-Fiまたはホットスポットに再接続してから、テレビに再接続してください。';

  @override
  String get reconnect => '再接続';

  @override
  String reconnectTo(String name) {
    return '$nameに再接続';
  }

  @override
  String get tapToReconnect => 'タップして再接続';

  @override
  String get pairingRequired => 'ペアリングが必要です';

  @override
  String get pairingEnterCode => 'テレビに表示されているコードを入力してください。';

  @override
  String get pairingApproveOnTv => 'テレビを見て、続けるには［許可］をタップしてください。';

  @override
  String get connect => '接続';

  @override
  String get cancel => 'キャンセル';

  @override
  String get pairingIncorrectCode => 'コードが違います。もう一度お試しください。';

  @override
  String get pairingTimedOut => 'ペアリングがタイムアウトしました';

  @override
  String get tryAgain => 'もう一度試す';

  @override
  String get pairingDeclined => 'テレビが接続を拒否しました';

  @override
  String pairingTooManyAttempts(int seconds) {
    return '間違ったコードが多すぎます。$seconds秒待ってから新しいコードをリクエストしてください。';
  }

  @override
  String get pairingCooldownOver => '新しいコードをリクエストできます。';

  @override
  String get pairingRequestNewCode => '新しいコードをリクエスト';

  @override
  String get pairingNetworkLost =>
      'ペアリング中にネットワークが切れました。Wi-Fiに再接続してもう一度お試しください。';

  @override
  String get pairingFailed => 'テレビとペアリングできませんでした。';

  @override
  String pairingCodeField(int length) {
    return 'ペアリングコード、$length桁';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'コードボックス $index/$total';
  }

  @override
  String get pairingEmptyBox => '空';

  @override
  String get pairingPaired => 'ペアリング済み';

  @override
  String get forgetDevice => 'デバイスを削除';

  @override
  String forgetDeviceMessage(String name) {
    return '次回は$nameを再度ペアリングする必要があります。';
  }

  @override
  String get forget => '削除';

  @override
  String get castVideo => '動画をキャスト';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '動画が$count件見つかりました。動画をキャスト',
      one: '動画が1件見つかりました。動画をキャスト',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'このページにはまだ動画が見つかっていません。';

  @override
  String get videoFound => '動画が見つかりました';

  @override
  String get videoFoundMessage => 'テレビで再生します。';

  @override
  String get castAction => 'キャスト';

  @override
  String get dismiss => '閉じる';

  @override
  String videosFound(int count) {
    return '見つかった動画（$count）';
  }

  @override
  String get castToTv => 'テレビにキャスト';

  @override
  String get protectedVideo => '保護されているためキャストできません';

  @override
  String get videoThumbnail => '動画のサムネイル';

  @override
  String castingTo(String device) {
    return '$deviceにキャスト中';
  }

  @override
  String get stopCasting => 'キャストを停止';

  @override
  String get play => '再生';

  @override
  String get pause => '一時停止';

  @override
  String get volume => '音量';

  @override
  String get seekPosition => '再生位置';

  @override
  String get showControls => 'コントロールを表示';

  @override
  String get hideControls => 'コントロールを非表示';

  @override
  String get formatUnsupportedTitle => '非対応の形式です';

  @override
  String formatUnsupported(String device, String format) {
    return '$deviceは$format動画を再生できません。このページの別の動画を試すか、画面ミラーリングを使ってください。';
  }

  @override
  String get videoExpired => 'この動画のリンクの有効期限が切れました。ページを再読み込みしてもう一度お試しください。';

  @override
  String get refreshingVideo => '新しい動画リンクを取得しています…';

  @override
  String get browserBack => '戻る';

  @override
  String get browserForward => '進む';

  @override
  String get browserStartPage => 'スタートページ';

  @override
  String get browserReload => '再読み込み';

  @override
  String get ok => 'OK';

  @override
  String get home => 'ホーム';

  @override
  String get devices => 'デバイス';

  @override
  String get history => '履歴';

  @override
  String get settings => '設定';

  @override
  String get goodMorning => 'おはようございます';

  @override
  String get goodAfternoon => 'こんにちは';

  @override
  String get goodEvening => 'こんばんは';

  @override
  String get couldntOpenTheLink => 'リンクを開けませんでした。';

  @override
  String get castflowLogo => 'CastFlowのロゴ';

  @override
  String get somethingWentWrong => '問題が発生しました';

  @override
  String get weCouldntLoadThis => '現在読み込めません。もう一度お試しください。';

  @override
  String get apps => 'アプリ';

  @override
  String open(Object name) {
    return '$nameを開く';
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
  String get menu => 'メニュー';

  @override
  String get input => '入力';

  @override
  String get playPause => '再生 / 一時停止';

  @override
  String get previous => '前へ';

  @override
  String get next => '次へ';

  @override
  String get rewind => '巻き戻し';

  @override
  String get volumeUp => '音量を上げる';

  @override
  String get volumeDown => '音量を下げる';

  @override
  String get mute => 'ミュート';

  @override
  String connectedTo(Object name) {
    return '$nameに接続済み';
  }

  @override
  String get chooseADevice => 'デバイスを選択';

  @override
  String get connectionGuide => '接続ガイド';

  @override
  String get lookingForTvsOn => 'Wi-Fi上のテレビを検索しています';

  @override
  String foundSoFar(Object found) {
    return 'これまでに$found台見つかりました';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found台のデバイスが見つかりました';
  }

  @override
  String get disconnect => '切断';

  @override
  String signalOf4(Object level) {
    return '電波 $level/4';
  }

  @override
  String get connecting2 => '接続中';

  @override
  String get theTvRemoteNeeds => 'テレビのリモコンには接続済みのテレビが必要です。下から選んでください。';

  @override
  String get connectToATv => '続けるにはテレビに接続してください。';

  @override
  String get findingTvs => 'テレビを検索中…';

  @override
  String get makeSureYourTv => 'テレビの電源が入っていることを確認してください';

  @override
  String get notConnected => '未接続';

  @override
  String get tapToFindYour => 'タップしてテレビを探す';

  @override
  String get connectionFailed2 => '接続に失敗しました';

  @override
  String tapToManageDevices(Object label) {
    return '$label。タップしてデバイスを管理';
  }

  @override
  String get joinTheSameWi => '同じWi-Fiに接続';

  @override
  String get connectYourPhoneAnd => 'スマートフォンとテレビを同じWi-Fiネットワークに接続します。';

  @override
  String get turnOnCastingOn => 'テレビでキャストをオンにする';

  @override
  String get enableScreenMirroringMiracast =>
      'テレビの設定で画面ミラーリング、Miracast、またはGoogle Castを有効にします。';

  @override
  String get scanForDevices => 'デバイスをスキャン';

  @override
  String get openDevicesInCastflow => 'CastFlowで［デバイス］を開き、テレビが表示されるまで数秒待ちます。';

  @override
  String get tapConnect => '［接続］をタップ';

  @override
  String get acceptThePromptOn => 'テレビにメッセージが表示されたら承認してください。以上です！';

  @override
  String get howToConnect => '接続方法';

  @override
  String get fourQuickStepsTo => '大画面につなぐ4つの簡単なステップ。';

  @override
  String get gotIt => 'OK';

  @override
  String step(Object number, Object title, Object body) {
    return 'ステップ$number。$title。$body';
  }

  @override
  String get homeWiFi => '自宅のWi-Fi';

  @override
  String get router => 'ルーター';

  @override
  String get settingsConnection => '設定 › 接続';

  @override
  String get inputHdmi1 => '入力：HDMI 1';

  @override
  String get screenMirroring => '画面ミラーリング';

  @override
  String get networkHomeWiFi => 'ネットワーク：自宅のWi-Fi';

  @override
  String get livingRoomTv => 'リビングのテレビ';

  @override
  String get allowCastflowToConnect => 'CastFlowの接続を許可しますか？';

  @override
  String get deny => '拒否';

  @override
  String get allow => '許可';

  @override
  String get yourTv => 'あなたのテレビ';

  @override
  String get findYourTv => 'テレビを見つける';

  @override
  String connectTo(Object name) {
    return '$nameに接続';
  }

  @override
  String connected2(Object label) {
    return '接続済み · $label';
  }

  @override
  String get openTvRemote => 'テレビのリモコンを開く';

  @override
  String get sameWiFiNetwork => '同じWi-Fiネットワーク';

  @override
  String get yourPhoneAndTv => 'スマートフォンとテレビは同じWi-Fiに接続されている必要があります。';

  @override
  String get tvIsOnAnd => 'テレビの電源が入っていて準備完了';

  @override
  String get turnOnScreenMirroring =>
      'テレビで画面ミラーリング、Cast、またはMiracastをオンにしてください。';

  @override
  String get noVpnOrGuest => 'VPNやゲストネットワークを使わない';

  @override
  String get vpnsAndGuestIsolated => 'VPNやゲスト／分離されたWi-Fiではデバイス同士が見えなくなります。';

  @override
  String get localNetworkAccess => 'ローカルネットワークへのアクセス';

  @override
  String get allowCastflowToFind =>
      '求められたら、CastFlowがネットワーク上のデバイスを見つけることを許可してください。';

  @override
  String get noTvFound => 'テレビが見つかりません';

  @override
  String get checkThatYourPhone =>
      'スマートフォンとテレビが同じWi-Fiに接続されているか確認して、もう一度スキャンしてください。';

  @override
  String get noWiFiRouter => 'Wi-Fiルーターがない？ホットスポットを使いましょう';

  @override
  String searchingForTvsFound(Object length) {
    return 'テレビを検索中。$length台見つかりました。';
  }

  @override
  String tvsFound(Object length) {
    return '$length台のテレビが見つかりました';
  }

  @override
  String get connectToYourTv => 'テレビに接続';

  @override
  String get connectYourPhoneAndTv => 'スマートフォンとテレビを同じWi-Fiネットワークに接続します。';

  @override
  String get turnOnTheTv => 'テレビの電源を入れ、画面ミラーリング／Cast入力を開きます。';

  @override
  String get tapTheConnectionBar => 'ホームの接続バーをタップしてテレビを探します。';

  @override
  String get tapConnectAndAccept => '［接続］をタップし、テレビにメッセージが出たら承認します。';

  @override
  String get mirrorYourScreen => '画面をミラーリング';

  @override
  String get connectToYourTvFirst => 'まずテレビに接続してください。';

  @override
  String get openScreenMirroringFrom => 'ホームから画面ミラーリングを開きます。';

  @override
  String get pickAQualityAnd => '画質を選んで［開始］をタップします。';

  @override
  String get allowScreenCaptureWhen => 'Androidで求められたら画面キャプチャを許可します。';

  @override
  String get castPhotosVideosMusic => '写真・動画・音楽をキャスト';

  @override
  String get openPhotosVideosOr => 'ホームで［写真］［動画］［音楽］を開きます。';

  @override
  String get pickWhatYouWant => '表示したいものを選びます。';

  @override
  String get itPlaysOnThe => 'テレビで再生されます。スマートフォンや通知から操作できます。';

  @override
  String get useTheTvRemote => 'テレビのリモコンを使う';

  @override
  String get openTvRemoteOn => 'ホームで［テレビリモコン］を開きます。';

  @override
  String get useTheDPad => '十字キーまたはタッチパッドのスワイプで移動し、OKをタップして選択します。';

  @override
  String get buttonsATvDoesnt => 'テレビが対応していないボタンはグレーになります。';

  @override
  String get castFromTheWeb => 'ウェブやアプリからキャスト';

  @override
  String get tapTheBrowserBar => 'ホームでブラウザバーまたはアプリをタップします。';

  @override
  String get playAVideoOn => 'サイトで動画を再生します。';

  @override
  String get tapCastThisVideo => '［この動画をキャスト］をタップしてテレビに送ります。';

  @override
  String get screenMirroringHelp => '画面ミラーリングのヘルプ';

  @override
  String get connectYourPhoneTo => 'スマートフォンをWi-Fiに接続します。';

  @override
  String get onTheTvOpen => 'テレビで［設定］→［ネットワーク］を開き、同じWi-Fiに接続します。';

  @override
  String get guestOrOfficeNetworks =>
      'ゲストや社内ネットワークはミラーリングをブロックすることが多いので、自宅のWi-Fiかスマートフォンのホットスポットを使ってください。';

  @override
  String get turnOffVpn => 'VPNをオフにする';

  @override
  String get aVpnHidesYour => 'VPNを使うと、スマートフォンからテレビが見えなくなります。';

  @override
  String get pauseOrDisconnectYour => '開始する前にVPNアプリを一時停止または切断してください。';

  @override
  String get youCanTurnIt => '終わったらまたオンにできます。';

  @override
  String get turnOnMirroringOn => 'テレビでミラーリングをオンにする';

  @override
  String get samsungLgAndMost =>
      'Samsung、LG、ほとんどのAndroidテレビは自動的にミラーリングを受け付けます。';

  @override
  String get otherTvsOpenInput =>
      'その他のテレビ：［入力／ソース］を開き、画面ミラーリングまたはMiracastを選びます。';

  @override
  String get keepTheTvOn => 'スマートフォンが接続するまで、テレビをその画面のままにしておいてください。';

  @override
  String get tapStartAndPick => '［開始］をタップしてテレビを選ぶ';

  @override
  String get tapStartOnThe => '画面ミラーリング画面で［開始］をタップします。';

  @override
  String get androidOpensSmartView =>
      'AndroidがSmart View／Castを開きます。一覧からテレビをタップします。';

  @override
  String get ifTheTvAsks => 'テレビから確認されたら［許可］を選ぶか、画面に表示されたPINを入力します。';

  @override
  String get youreMirroring => 'ミラーリング中です';

  @override
  String get everythingOnYourPhone => 'スマートフォンの画面がすべてテレビに表示されています。';

  @override
  String get turnThePhoneSideways => '全画面の動画やゲームではスマートフォンを横向きにします。';

  @override
  String get toStopTapStop => '停止するには［停止］をタップするか、キャスト通知を使います。';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'オフ';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => '寝室のテレビ';

  @override
  String get officeDisplay => 'オフィスのディスプレイ';

  @override
  String get clearHistory => '履歴を消去しますか？';

  @override
  String get thisRemovesEverythingYouve => 'キャストしたものがこの一覧からすべて削除されます。';

  @override
  String get clear => '消去';

  @override
  String get clearHistory2 => '履歴を消去';

  @override
  String get noHistoryYet => 'まだ履歴がありません';

  @override
  String get everythingYouCastWill => 'キャストしたものはここに表示され、あとで簡単に見つけられます。';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get earlier => 'それ以前';

  @override
  String get swipeAnItemTo => '項目をスワイプして削除';

  @override
  String get delete => '削除';

  @override
  String removed(Object title) {
    return '「$title」を削除しました';
  }

  @override
  String get undo => '元に戻す';

  @override
  String get photos => '写真';

  @override
  String get albums => 'アルバム';

  @override
  String get videos => '動画';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get music => '音楽';

  @override
  String get songs => '曲';

  @override
  String get media => 'メディア';

  @override
  String get browseTheWeb => 'ウェブを見る';

  @override
  String get goPro => 'Proにアップグレード';

  @override
  String cast(Object title) {
    return '$titleをキャスト';
  }

  @override
  String get screenMirroringStartMirroring => '画面ミラーリング。ミラーリングを開始';

  @override
  String readyToMirrorTo(Object device) {
    return '$deviceにミラーリングする準備ができました';
  }

  @override
  String get showYourPhoneOn => 'スマートフォンの画面をテレビにリアルタイムで表示します。';

  @override
  String get startMirroring => 'ミラーリングを開始';

  @override
  String get tvRemote => 'テレビリモコン';

  @override
  String get controlYourTv => 'テレビを操作';

  @override
  String get youtubeMore => 'YouTubeなど';

  @override
  String get openTheBrowser => 'ブラウザを開く';

  @override
  String get searchOrTypeA => '検索またはウェブサイトを入力';

  @override
  String get howToConnectOpen => '接続方法。ビジュアルガイドを開く';

  @override
  String get visualGuideForEvery => 'すべての機能のビジュアルガイド';

  @override
  String get language => '言語';

  @override
  String get done => '完了';

  @override
  String get enterAValidHttp =>
      '有効なhttp(s)またはrtspリンクを入力してください（例：.m3u8や.mp4のURL）。';

  @override
  String get linkStream => 'リンクストリーム';

  @override
  String get iptvLinkCast => 'IPTV／リンクキャスト';

  @override
  String get castALink => 'リンクをキャスト';

  @override
  String get pasteADirectVideo => '直接の動画、M3U8、またはIPTVストリームのURLを貼り付けます。';

  @override
  String get paste => '貼り付け';

  @override
  String get castLink => 'リンクをキャスト';

  @override
  String get allowAccessToYour => 'メディアをキャストするにはアクセスを許可してください。設定で変更できます。';

  @override
  String get video => '動画';

  @override
  String get castMusic => '音楽をキャスト';

  @override
  String get noMusicFound => '音楽が見つかりません';

  @override
  String get addSongsToYour => 'スマートフォンに曲を追加すると、ここに表示されます。';

  @override
  String get shuffle => 'シャッフル';

  @override
  String get playAll => 'すべて再生';

  @override
  String photo(Object formatShortDate) {
    return '写真 · $formatShortDate';
  }

  @override
  String get photo2 => '写真';

  @override
  String get castPhotos => '写真をキャスト';

  @override
  String get select => '選択';

  @override
  String get noPhotosHere => '写真がありません';

  @override
  String get photosYouTakeOr => '撮影または保存した写真がこのアルバムに表示されます。';

  @override
  String photos2(Object name, Object count) {
    return '$name、$count枚';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return '$formatShortDateの写真';
  }

  @override
  String get allPhotos => 'すべての写真';

  @override
  String get slideshow => 'スライドショー';

  @override
  String get interval => '間隔';

  @override
  String get transition => '切り替え';

  @override
  String get fade => 'フェード';

  @override
  String get slide => 'スライド';

  @override
  String get zoom => 'ズーム';

  @override
  String get startSlideshow => 'スライドショーを開始';

  @override
  String get castVideos => '動画をキャスト';

  @override
  String get noVideosYet => 'まだ動画がありません';

  @override
  String get videosYouRecordOr => '撮影またはダウンロードした動画がここに表示され、すぐにキャストできます。';

  @override
  String video2(Object resolution) {
    return '動画 · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title、$formatDuration。キャスト';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => '画面ミラーリングセッション';

  @override
  String get mirroringDidntStartTap =>
      'ミラーリングが開始されませんでした。もう一度［開始］をタップして、一覧からテレビを選んでください。';

  @override
  String get openSmartViewOr =>
      'ミラーリングするには、スマートフォンのクイック設定からSmart ViewまたはCastを開いてください。';

  @override
  String get quality => '画質';

  @override
  String get adjustsToYourWi => 'Wi-Fiに合わせて調整し、最もなめらかな映像にします。';

  @override
  String upToLowerIt(Object label) {
    return '最大$label。映像がカクつく場合は下げてください。';
  }

  @override
  String get stillNeedHelp => 'お困りですか？';

  @override
  String get startingScreenMirroring => '画面ミラーリングを開始しています…';

  @override
  String mirroringTo(Object value) {
    return '$valueにミラーリング中';
  }

  @override
  String get stopping => '停止中…';

  @override
  String get readyToMirror => 'ミラーリングの準備完了';

  @override
  String get beforeYouStart => '開始する前に';

  @override
  String get phoneAndTvAre => 'スマートフォンとテレビが同じWi-Fiに接続されている';

  @override
  String get noVpnIsConnected => 'スマートフォンでVPNが接続されていない';

  @override
  String get tvIsOnWith => 'テレビの電源が入り、画面ミラーリングが有効になっている';

  @override
  String get phoneIsCloseTo => 'スマートフォンがテレビの近くにある';

  @override
  String get stopMirroring => 'ミラーリングを停止';

  @override
  String get startMirroring2 => 'ミラーリングを開始';

  @override
  String get stop => '停止';

  @override
  String get start => '開始';

  @override
  String get duration => '時間';

  @override
  String get adIsLoading => '広告を読み込み中';

  @override
  String get ad => '広告';

  @override
  String get mirrorYourScreenTo => 'どのテレビにも画面をミラーリング';

  @override
  String get showYourPhoneOnThe => 'ワンタップでスマートフォンを大画面に。ケーブルも手間も不要です。';

  @override
  String get shareMemoriesWithThe => '思い出を部屋のみんなと共有し、操作はスマートフォンで。';

  @override
  String get castFromWebApps => 'ウェブとアプリからキャスト';

  @override
  String get sendVideosFromYoutube =>
      'YouTube、Facebook、あらゆるウェブサイトの動画をテレビに直接送れます。';

  @override
  String pageOf(Object value, Object length) {
    return '$lengthページ中$valueページ';
  }

  @override
  String get getStarted => 'はじめる';

  @override
  String get localNetwork => 'ローカルネットワーク';

  @override
  String get findTvsAndStreaming => 'Wi-Fi上のテレビやストリーミングデバイスを見つけます。';

  @override
  String get notifications => '通知';

  @override
  String get showCastingControlsWhile => '他のアプリの使用中にキャストのコントロールを表示します。';

  @override
  String get photosVideosMusic => '写真・動画・音楽';

  @override
  String get pickWhatYouWantTo => 'ギャラリーやライブラリからキャストするものを選びます。';

  @override
  String get screenCapture => '画面キャプチャ';

  @override
  String get mirrorYourScreenYoull => '画面をミラーリングします。セッションごとに確認があります。';

  @override
  String get webVideo => 'ウェブ動画';

  @override
  String get link => 'リンク';

  @override
  String get screenMirroring2 => '画面ミラーリング';

  @override
  String nowCastingOpenRemote(Object title) {
    return '$titleをキャスト中。リモコンを開く';
  }

  @override
  String castingTo2(Object value) {
    return '$valueにキャスト中';
  }

  @override
  String get nowCasting => 'キャスト中';

  @override
  String get nothingIsCasting => 'キャスト中のものはありません';

  @override
  String get pickAPhotoVideo => 'テレビに送る写真、動画、曲、またはウェブ動画を選んでください。';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String slide2(Object formatDuration) {
    return 'スライド $formatDuration';
  }

  @override
  String get back10Seconds => '10秒戻る';

  @override
  String get forward10Seconds => '10秒進む';

  @override
  String get tvVolume => 'テレビの音量';

  @override
  String tvVolumePercent(Object round) {
    return 'テレビの音量 $roundパーセント';
  }

  @override
  String get upNext => '次の項目';

  @override
  String get addPhotos => '写真を追加';

  @override
  String get addVideos => '動画を追加';

  @override
  String get nothingElseInThe => 'キューに他に何もありません。';

  @override
  String play2(Object title) {
    return '$titleを再生';
  }

  @override
  String get unknownDevice => '不明なデバイス';

  @override
  String get perWeek => '週あたり';

  @override
  String get perYear => '年あたり';

  @override
  String get payOnce => '買い切り';

  @override
  String get wirelessScreenMirroring => 'ワイヤレス画面ミラーリング';

  @override
  String get castVideosPhotosMusic => '動画・写真・音楽をキャスト';

  @override
  String get fullTvRemoteControl => 'テレビのフルリモコン操作';

  @override
  String get worksWithAllMajor => '主要なテレビすべてに対応';

  @override
  String get smoothLagFreeStreaming => 'なめらかで遅延のないストリーミング';

  @override
  String get noAds => '広告なし';

  @override
  String get welcomeToCastflowPro => 'CastFlow Proへようこそ！';

  @override
  String get purchaseCancelled => '購入がキャンセルされました。';

  @override
  String get purchasePendingProUnlocks => '購入は保留中です。ストアが確認し次第、Proが有効になります。';

  @override
  String get purchaseFailedPleaseTry => '購入に失敗しました。もう一度お試しください。';

  @override
  String get theStoreIsntAvailable => 'ストアは現在利用できません。';

  @override
  String get close => '閉じる';

  @override
  String get goProWithCastflow => 'CASTFLOWでPROになろう';

  @override
  String get unlockEveryFeature => 'すべての機能を解放';

  @override
  String get renewsAutomaticallyUntilCancelled => 'キャンセルするまで自動的に更新されます。';

  @override
  String get oneTimePurchaseNo => '1回のみの購入。サブスクリプションなし。';

  @override
  String get continueAction => '続ける';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsAndConditions => '利用規約';

  @override
  String get cancelAnytime => 'いつでもキャンセル可能';

  @override
  String get loadingPrice => '価格を読み込み中…';

  @override
  String get pricesUnavailableTapTo => '価格を取得できません · タップして再試行';

  @override
  String get noPlansAvailableRight => '現在利用できるプランがありません。';

  @override
  String get weekly => '週間';

  @override
  String get yearly => '年間';

  @override
  String get lifetime => '買い切り';

  @override
  String get bestValue => 'おすすめ';

  @override
  String get disconnectFromTv => 'テレビから切断しますか？';

  @override
  String get thisStopsWhatIs => '再生中またはミラーリング中のものが停止します。';

  @override
  String get useTouchpad => 'タッチパッドを使う';

  @override
  String get useDPad => '十字キーを使う';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$labelレシーバーはリモコンコマンドを受け付けません。';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return '$labelでは使えないボタンがあります。';
  }

  @override
  String get idle => '待機中';

  @override
  String get playing => '再生中';

  @override
  String get paused => '一時停止中';

  @override
  String get noTvConnected => 'テレビが接続されていません';

  @override
  String get mute2 => 'ミュート';

  @override
  String vol(Object volume) {
    return '音量 $volume';
  }

  @override
  String get noTvConnectedTap => 'テレビが接続されていません。タップしてデバイスを選択';

  @override
  String get tapToChooseA => 'タップしてデバイスを選択';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$labelは$label2で対応していません';
  }

  @override
  String get touchpadSwipeToMove => 'タッチパッド。スワイプで移動、タップで選択。';

  @override
  String get swipeToMoveTap => 'スワイプで移動 · タップで選択';

  @override
  String get navigationIsntSupportedBy => 'このテレビはナビゲーションに対応していません';

  @override
  String get vol2 => '音量';

  @override
  String get auto => '自動';

  @override
  String get automatic => '自動';

  @override
  String get googleCastFirst => 'Google Castを優先';

  @override
  String get dlnaUpnpFirst => 'DLNA／UPnPを優先';

  @override
  String get miracastFirst => 'Miracastを優先';

  @override
  String get tvOnly => 'テレビのみ';

  @override
  String get phoneAndTv => 'スマートフォンとテレビ';

  @override
  String get phoneOnly => 'スマートフォンのみ';

  @override
  String get touchpad => 'タッチパッド';

  @override
  String get doMyPhoneAnd => 'スマートフォンとテレビは同じWi-Fiである必要がありますか？';

  @override
  String get yesDiscoveryAndCasting =>
      'はい。検出とキャストはローカルネットワーク内で行われるため、両方が同じWi-Fiに接続されている必要があります（似たバンド名でも別のネットワークの場合があります）。';

  @override
  String get myRouterHasAp => 'ルーターに「AP／クライアント分離」があります';

  @override
  String get isolationBlocksDevicesFrom =>
      '分離を有効にすると、デバイス同士が見えなくなります。ルーター設定でオフにするか、ゲスト以外のネットワークを使ってください。';

  @override
  String get findingYourTv => 'テレビを見つける';

  @override
  String get myTvDoesntAppear => 'テレビが一覧に表示されません';

  @override
  String get turnOnCastingScreen =>
      'テレビでキャスト／画面ミラーリングをオンにし、スタンバイから復帰させて、［再スキャン］をタップしてください。求められたらローカルネットワークの権限を許可してください。';

  @override
  String get onlySomeDevicesShow => '一部のデバイスしか表示されません';

  @override
  String get olderTvsMayNeed =>
      '古いテレビはファームウェアの更新が必要な場合があります。Miracastテレビは「画面ミラーリング」入力を開いている間だけ表示されます。';

  @override
  String get connectionFailsOrTimes => '接続に失敗する、またはタイムアウトする';

  @override
  String get restartTheTvApp =>
      'テレビアプリまたはテレビを再起動し、ルーターに近づいて、テレビ画面に表示されたメッセージを承認してください。';

  @override
  String get itKeepsReconnectingTo => '古いテレビに何度も再接続される';

  @override
  String get turnOffAutoConnect => '［設定］→［キャスト］で「最後のテレビに自動接続」をオフにしてください。';

  @override
  String get mirroringIsLaggy => 'ミラーリングが遅い';

  @override
  String get chooseALowerQuality =>
      '画質を下げ（720pまたは480p）、負荷の高いアプリを閉じ、5GHzのWi-Fiネットワークを使ってください。';

  @override
  String get thePictureIsRotated => '映像が回転している、または切れている';

  @override
  String get toggleAutoRotateOn => '画面ミラーリング画面で自動回転を切り替えてください。';

  @override
  String get sound => '音声';

  @override
  String get thereIsNoSound => 'テレビから音が出ません';

  @override
  String get makeSureAudioIs =>
      '画面ミラーリングで音声がオンか確認し、［設定］→［キャスト］→［音声出力］を確認してください。一部のレシーバーはスマートフォンの音声に対応していません。';

  @override
  String get tvRemote2 => 'テレビリモコン';

  @override
  String get someRemoteButtonsAre => '一部のリモコンボタンがグレーになっています';

  @override
  String get eachReceiverSupportsDifferent =>
      'レシーバーごとに対応コマンドが異なります。ChromecastとDLNAは再生と音量のみ対応で、Miracastにはリモコンチャネルがありません。';

  @override
  String get canCastflowTurnMy => 'CastFlowでテレビの電源オンや入力切り替えはできますか？';

  @override
  String get onlyOnTvsThat =>
      'それらのコマンドをネットワーク経由で公開しているテレビのみ可能です。非対応のボタンは動くふりをせず無効になります。';

  @override
  String get helpFaq => 'ヘルプとFAQ';

  @override
  String get stepByStepConnection => 'ステップごとの接続ガイド';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release（SDK $sdkInt）';
  }

  @override
  String get noEmailAppFound => 'メールアプリが見つかりません。';

  @override
  String get enjoyingCastflow => 'CastFlowを楽しんでいますか？';

  @override
  String get sorryToHearThat => '申し訳ありません';

  @override
  String get thanksHowCanWe => 'ありがとうございます！どう改善すればよいでしょうか？';

  @override
  String get wereGladYouLike => '気に入っていただけてうれしいです！';

  @override
  String get youMadeOurDay => '最高の一日になりました！';

  @override
  String get tapToExit => 'タップして終了';

  @override
  String get selectARating => '評価を選択';

  @override
  String get sendFeedback => 'フィードバックを送信';

  @override
  String get rateUs => '評価する';

  @override
  String get rateYourExperienceBefore => '終了する前に使い心地を評価してください。';

  @override
  String get tapAStarTo => '星をタップしてCastFlowを評価してください。';

  @override
  String get general => '一般';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'デフォルトの画質';

  @override
  String get autoConnectToLast => '最後のテレビに自動接続';

  @override
  String get hapticFeedback => '触覚フィードバック';

  @override
  String get clearCastingHistory => 'キャスト履歴を消去';

  @override
  String get clearCastingHistory2 => 'キャスト履歴を消去しますか？';

  @override
  String get onlyCastflowsListIs =>
      'CastFlowの一覧のみ消去されます。スマートフォン内のメディアは削除されません。';

  @override
  String get appearance => '外観';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get system => 'システム';

  @override
  String get aboutSupport => '概要とサポート';

  @override
  String get rateApp => 'アプリを評価';

  @override
  String get feedback => 'フィードバック';

  @override
  String get termsConditions => '利用規約';

  @override
  String get version => 'バージョン';

  @override
  String get castflowProIsActive => 'CastFlow Proは有効です';

  @override
  String get upgradeToPremium => 'プレミアムにアップグレード';

  @override
  String get castflowPremium => 'CastFlow プレミアム';

  @override
  String get thanksForYourSupport => 'ご支援ありがとうございます。広告なしでキャストをお楽しみください。';

  @override
  String get noAds1080pMirroring => '広告なし、1080pミラーリング、無制限キャスト';

  @override
  String get upgrade => 'アップグレード';

  @override
  String get mirrorCastBeautifullySimple => 'ミラーリングもキャストも、驚くほどシンプルに';

  @override
  String get thisActionMayContain => 'この操作には広告が含まれる場合があります';

  @override
  String get webCast => 'ウェブキャスト';

  @override
  String get castThisVideo => 'この動画をキャスト';

  @override
  String get searchOrTypeAWeb => '検索またはウェブアドレスを入力';

  @override
  String get removeBookmark => 'ブックマークを削除';

  @override
  String get bookmark => 'ブックマーク';

  @override
  String get quickAccess => 'クイックアクセス';

  @override
  String open2(Object title) {
    return '$titleを開く';
  }

  @override
  String get bookmarks => 'ブックマーク';

  @override
  String get noBookmarks => 'ブックマークなし';

  @override
  String get tapTheBookmarkIcon => 'アドレスバーのブックマークアイコンをタップするとページを保存できます。';

  @override
  String get noHistory => '履歴なし';

  @override
  String get pagesYouVisitShow => '訪れたページがここに表示されます。';

  @override
  String get remove => '削除';

  @override
  String resultOn(Object value, Object host) {
    return '$hostの結果 $value';
  }

  @override
  String get aSimulatedPageResult => 'シミュレートされたページ結果';

  @override
  String get videosOnThisPage => 'このページの動画';

  @override
  String get pickOneToSend => 'テレビに送るものを1つ選んでください。';

  @override
  String get onboardHotspotTitle => 'Wi-Fiがない？テザリングを使う';

  @override
  String get onboardHotspotBody =>
      'スマホのテザリングをオンにしてテレビを接続してください。Wi-Fiと同じようにキャストできます。';

  @override
  String get stillCantFindTitle => 'テレビが見つかりませんか？';

  @override
  String get stillCantFindBody => 'テレビをスマホのテザリングに接続してください：';

  @override
  String get hotspotStep4 => '再試行をタップしてリストからテレビを選ぶ';

  @override
  String get castOverHotspot => 'Wi-Fiがない？スマホのテザリングでキャスト：';

  @override
  String get queue => 'キュー';

  @override
  String get addMusic => '音楽を追加';

  @override
  String get connectWithWifi => 'Wi-Fiに接続';

  @override
  String get continueWithHotspot => 'テザリングで続ける';

  @override
  String get noWifiAlertMessage =>
      'モバイルデータを使用中です。スマホとテレビを同じWi-Fiに接続するか、スマホのテザリングをオンにしてテレビから接続してください。';
}
