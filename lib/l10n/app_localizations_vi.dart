// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get networkRequiredTitle => 'Chưa kết nối Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Điện thoại và TV phải cùng một mạng Wi-Fi để truyền.';

  @override
  String get openWifiSettings => 'Mở cài đặt Wi-Fi';

  @override
  String get useMobileHotspot => 'Dùng điểm phát sóng di động';

  @override
  String get hotspotInstruction =>
      'Kết nối TV với điểm phát sóng di động của điện thoại.';

  @override
  String get hotspotStep1 => 'Bật điểm phát sóng di động';

  @override
  String get hotspotStep2 => 'Kết nối TV với điểm phát sóng';

  @override
  String get hotspotStep3 => 'Quay lại ứng dụng';

  @override
  String get openHotspotSettings => 'Mở cài đặt điểm phát sóng';

  @override
  String get hotspotAutoCheck =>
      'Chúng tôi sẽ tự động kiểm tra lại khi bạn quay lại.';

  @override
  String get hotspotDetected => 'Điểm phát sóng đã bật. Đang tìm TV của bạn…';

  @override
  String get searchingDevices => 'Đang tìm thiết bị lân cận...';

  @override
  String get waitingForTvOnHotspot =>
      'Đang chờ TV tham gia điểm phát sóng của bạn…';

  @override
  String get usingHotspot => 'Đang dùng điểm phát sóng di động';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tìm thấy $count thiết bị',
      one: 'Tìm thấy 1 thiết bị',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Thử lại';

  @override
  String get scanAgain => 'Quét lại';

  @override
  String get isolationTitle => 'TV không phản hồi';

  @override
  String get isolationHint =>
      'Một thiết bị đã tham gia điểm phát sóng nhưng không phản hồi. Điểm phát sóng có thể đang chặn lưu lượng giữa các thiết bị (cách ly máy khách). Hãy tắt tính năng này trong cài đặt điểm phát sóng hoặc dùng mạng Wi-Fi.';

  @override
  String get connecting => 'Đang kết nối…';

  @override
  String get connected => 'Đã kết nối';

  @override
  String get connectionFailed => 'Không thể kết nối';

  @override
  String get connectFailedHint =>
      'Hãy đảm bảo điện thoại và TV cùng một mạng, rồi thử lại.';

  @override
  String get hotspotConnectHint =>
      'Điểm phát sóng có thể đang chặn lưu lượng giữa các thiết bị. Hãy kiểm tra cài đặt cách ly máy khách.';

  @override
  String get networkLostTitle => 'Mất kết nối mạng';

  @override
  String get networkLostMessage =>
      'Hãy kết nối lại Wi-Fi hoặc điểm phát sóng, rồi kết nối lại với TV.';

  @override
  String get reconnect => 'Kết nối lại';

  @override
  String reconnectTo(String name) {
    return 'Kết nối lại với $name';
  }

  @override
  String get tapToReconnect => 'Chạm để kết nối lại';

  @override
  String get pairingRequired => 'Cần ghép nối';

  @override
  String get pairingEnterCode => 'Nhập mã hiển thị trên TV.';

  @override
  String get pairingApproveOnTv => 'Hãy nhìn TV và chạm Cho phép để tiếp tục.';

  @override
  String get connect => 'Kết nối';

  @override
  String get cancel => 'Hủy';

  @override
  String get pairingIncorrectCode => 'Mã không đúng. Hãy thử lại.';

  @override
  String get pairingTimedOut => 'Ghép nối đã hết thời gian';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get pairingDeclined => 'TV đã từ chối kết nối';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Quá nhiều mã sai. Hãy đợi $seconds giây rồi yêu cầu mã mới.';
  }

  @override
  String get pairingCooldownOver => 'Bây giờ bạn có thể yêu cầu mã mới.';

  @override
  String get pairingRequestNewCode => 'Yêu cầu mã mới';

  @override
  String get pairingNetworkLost =>
      'Mạng bị mất trong lúc ghép nối. Hãy kết nối lại Wi-Fi và thử lại.';

  @override
  String get pairingFailed => 'Không thể ghép nối với TV.';

  @override
  String pairingCodeField(int length) {
    return 'Mã ghép nối, $length ký tự';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Ô mã $index/$total';
  }

  @override
  String get pairingEmptyBox => 'trống';

  @override
  String get pairingPaired => 'Đã ghép nối';

  @override
  String get forgetDevice => 'Quên thiết bị';

  @override
  String forgetDeviceMessage(String name) {
    return 'Lần sau $name sẽ cần được ghép nối lại.';
  }

  @override
  String get forget => 'Quên';

  @override
  String get castVideo => 'Truyền video';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tìm thấy $count video. Truyền video',
      one: 'Tìm thấy 1 video. Truyền video',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Chưa tìm thấy video nào trên trang này.';

  @override
  String get videoFound => 'Đã tìm thấy video';

  @override
  String get videoFoundMessage => 'Phát trên TV của bạn.';

  @override
  String get castAction => 'Truyền';

  @override
  String get dismiss => 'Đóng';

  @override
  String videosFound(int count) {
    return 'Video đã tìm thấy ($count)';
  }

  @override
  String get castToTv => 'Truyền lên TV';

  @override
  String get protectedVideo => 'Được bảo vệ, không thể truyền';

  @override
  String get videoThumbnail => 'Ảnh thu nhỏ video';

  @override
  String castingTo(String device) {
    return 'Đang truyền tới $device';
  }

  @override
  String get stopCasting => 'Dừng truyền';

  @override
  String get play => 'Phát';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get volume => 'Âm lượng';

  @override
  String get seekPosition => 'Vị trí phát';

  @override
  String get showControls => 'Hiện điều khiển';

  @override
  String get hideControls => 'Ẩn điều khiển';

  @override
  String get formatUnsupportedTitle => 'Định dạng không được hỗ trợ';

  @override
  String formatUnsupported(String device, String format) {
    return '$device không thể phát video $format. Hãy thử video khác trên trang này hoặc dùng phản chiếu màn hình.';
  }

  @override
  String get videoExpired =>
      'Liên kết video đã hết hạn. Hãy tải lại trang và thử lại.';

  @override
  String get refreshingVideo => 'Đang lấy liên kết video mới…';

  @override
  String get browserBack => 'Quay lại';

  @override
  String get browserForward => 'Tiến';

  @override
  String get browserStartPage => 'Trang chủ';

  @override
  String get browserReload => 'Tải lại';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Trang chủ';

  @override
  String get devices => 'Thiết bị';

  @override
  String get history => 'Lịch sử';

  @override
  String get settings => 'Cài đặt';

  @override
  String get goodMorning => 'Chào buổi sáng';

  @override
  String get goodAfternoon => 'Chào buổi chiều';

  @override
  String get goodEvening => 'Chào buổi tối';

  @override
  String get couldntOpenTheLink => 'Không thể mở liên kết.';

  @override
  String get castflowLogo => 'Logo CastFlow';

  @override
  String get somethingWentWrong => 'Đã xảy ra lỗi';

  @override
  String get weCouldntLoadThis =>
      'Hiện không thể tải nội dung này. Vui lòng thử lại.';

  @override
  String get apps => 'Ứng dụng';

  @override
  String open(Object name) {
    return 'Mở $name';
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
  String get up => 'Lên';

  @override
  String get down => 'Xuống';

  @override
  String get left => 'Trái';

  @override
  String get right => 'Phải';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Đầu vào';

  @override
  String get playPause => 'Phát / Tạm dừng';

  @override
  String get previous => 'Trước';

  @override
  String get next => 'Tiếp';

  @override
  String get rewind => 'Tua lại';

  @override
  String get volumeUp => 'Tăng âm lượng';

  @override
  String get volumeDown => 'Giảm âm lượng';

  @override
  String get mute => 'Tắt tiếng';

  @override
  String connectedTo(Object name) {
    return 'Đã kết nối với $name';
  }

  @override
  String get chooseADevice => 'Chọn thiết bị';

  @override
  String get connectionGuide => 'Hướng dẫn kết nối';

  @override
  String get lookingForTvsOn => 'Đang tìm TV trên Wi-Fi của bạn';

  @override
  String foundSoFar(Object found) {
    return 'Đã tìm thấy $found cho đến nay';
  }

  @override
  String deviceFound(Object found, Object value) {
    return 'Tìm thấy $found thiết bị';
  }

  @override
  String get disconnect => 'Ngắt kết nối';

  @override
  String signalOf4(Object level) {
    return 'Tín hiệu $level/4';
  }

  @override
  String get connecting2 => 'Đang kết nối';

  @override
  String get theTvRemoteNeeds =>
      'Điều khiển TV cần một TV đã kết nối. Hãy chọn một TV bên dưới.';

  @override
  String get connectToATv => 'Hãy kết nối với TV để tiếp tục.';

  @override
  String get findingTvs => 'Đang tìm TV…';

  @override
  String get makeSureYourTv => 'Hãy đảm bảo TV đang bật';

  @override
  String get notConnected => 'Chưa kết nối';

  @override
  String get tapToFindYour => 'Chạm để tìm TV của bạn';

  @override
  String get connectionFailed2 => 'Kết nối thất bại';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Chạm để quản lý thiết bị';
  }

  @override
  String get joinTheSameWi => 'Tham gia cùng Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Kết nối điện thoại và TV với cùng một mạng Wi-Fi.';

  @override
  String get turnOnCastingOn => 'Bật truyền trên TV';

  @override
  String get enableScreenMirroringMiracast =>
      'Bật Phản chiếu màn hình, Miracast hoặc Google Cast trong cài đặt TV.';

  @override
  String get scanForDevices => 'Quét thiết bị';

  @override
  String get openDevicesInCastflow =>
      'Mở Thiết bị trong CastFlow và đợi vài giây để TV xuất hiện.';

  @override
  String get tapConnect => 'Chạm Kết nối';

  @override
  String get acceptThePromptOn =>
      'Chấp nhận lời nhắc trên TV nếu có. Vậy là xong!';

  @override
  String get howToConnect => 'Cách kết nối';

  @override
  String get fourQuickStepsTo => 'Bốn bước nhanh để lên màn hình lớn.';

  @override
  String get gotIt => 'Đã hiểu';

  @override
  String step(Object number, Object title, Object body) {
    return 'Bước $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi nhà';

  @override
  String get router => 'Bộ định tuyến';

  @override
  String get settingsConnection => 'Cài đặt › Kết nối';

  @override
  String get inputHdmi1 => 'Đầu vào: HDMI 1';

  @override
  String get screenMirroring => 'Phản chiếu màn hình';

  @override
  String get networkHomeWiFi => 'Mạng: Wi-Fi nhà';

  @override
  String get livingRoomTv => 'TV phòng khách';

  @override
  String get allowCastflowToConnect => 'Cho phép CastFlow kết nối?';

  @override
  String get deny => 'Từ chối';

  @override
  String get allow => 'Cho phép';

  @override
  String get yourTv => 'TV của bạn';

  @override
  String get findYourTv => 'Tìm TV của bạn';

  @override
  String connectTo(Object name) {
    return 'Kết nối với $name';
  }

  @override
  String connected2(Object label) {
    return 'Đã kết nối · $label';
  }

  @override
  String get openTvRemote => 'Mở điều khiển TV';

  @override
  String get sameWiFiNetwork => 'Cùng mạng Wi-Fi';

  @override
  String get yourPhoneAndTv => 'Điện thoại và TV phải kết nối cùng một Wi-Fi.';

  @override
  String get tvIsOnAnd => 'TV đã bật và sẵn sàng';

  @override
  String get turnOnScreenMirroring =>
      'Bật Phản chiếu màn hình, Cast hoặc Miracast trên TV.';

  @override
  String get noVpnOrGuest => 'Không dùng VPN hoặc mạng khách';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN và Wi-Fi khách / cách ly khiến các thiết bị không thấy nhau.';

  @override
  String get localNetworkAccess => 'Truy cập mạng cục bộ';

  @override
  String get allowCastflowToFind =>
      'Cho phép CastFlow tìm thiết bị trên mạng của bạn khi được hỏi.';

  @override
  String get noTvFound => 'Không tìm thấy TV';

  @override
  String get checkThatYourPhone =>
      'Hãy kiểm tra điện thoại và TV cùng một Wi-Fi, rồi quét lại.';

  @override
  String get noWiFiRouter =>
      'Không có bộ định tuyến Wi-Fi? Hãy dùng điểm phát sóng';

  @override
  String searchingForTvsFound(Object length) {
    return 'Đang tìm TV. Đã tìm thấy $length.';
  }

  @override
  String tvsFound(Object length) {
    return 'Tìm thấy $length TV';
  }

  @override
  String get connectToYourTv => 'Kết nối với TV của bạn';

  @override
  String get connectYourPhoneAndTv =>
      'Kết nối điện thoại và TV với cùng một mạng Wi-Fi.';

  @override
  String get turnOnTheTv => 'Bật TV và mở đầu vào Phản chiếu màn hình / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Chạm thanh kết nối ở Trang chủ để tìm TV của bạn.';

  @override
  String get tapConnectAndAccept =>
      'Chạm Kết nối và chấp nhận lời nhắc trên TV nếu có.';

  @override
  String get mirrorYourScreen => 'Phản chiếu màn hình của bạn';

  @override
  String get connectToYourTvFirst => 'Hãy kết nối với TV trước.';

  @override
  String get openScreenMirroringFrom => 'Mở Phản chiếu màn hình từ Trang chủ.';

  @override
  String get pickAQualityAnd => 'Chọn chất lượng và chạm Bắt đầu.';

  @override
  String get allowScreenCaptureWhen =>
      'Cho phép chụp màn hình khi Android hỏi.';

  @override
  String get castPhotosVideosMusic => 'Truyền ảnh, video & nhạc';

  @override
  String get openPhotosVideosOr => 'Mở Ảnh, Video hoặc Nhạc ở Trang chủ.';

  @override
  String get pickWhatYouWant => 'Chọn nội dung bạn muốn hiển thị.';

  @override
  String get itPlaysOnThe =>
      'Nội dung phát trên TV; điều khiển từ điện thoại hoặc thông báo.';

  @override
  String get useTheTvRemote => 'Dùng điều khiển TV';

  @override
  String get openTvRemoteOn => 'Mở Điều khiển TV ở Trang chủ.';

  @override
  String get useTheDPad =>
      'Dùng phím điều hướng hoặc vuốt trên bàn di chuột để di chuyển, chạm OK để chọn.';

  @override
  String get buttonsATvDoesnt => 'Các nút TV không hỗ trợ sẽ có màu xám.';

  @override
  String get castFromTheWeb => 'Truyền từ web & ứng dụng';

  @override
  String get tapTheBrowserBar =>
      'Chạm thanh trình duyệt hoặc một ứng dụng ở Trang chủ.';

  @override
  String get playAVideoOn => 'Phát một video trên trang web.';

  @override
  String get tapCastThisVideo => 'Chạm “Truyền video này” để gửi lên TV.';

  @override
  String get screenMirroringHelp => 'Trợ giúp phản chiếu màn hình';

  @override
  String get connectYourPhoneTo => 'Kết nối điện thoại với Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Trên TV, mở Cài đặt → Mạng và tham gia cùng Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Mạng khách hoặc văn phòng thường chặn phản chiếu; hãy dùng Wi-Fi nhà hoặc điểm phát sóng của điện thoại.';

  @override
  String get turnOffVpn => 'Tắt VPN';

  @override
  String get aVpnHidesYour => 'VPN khiến điện thoại không thấy TV của bạn.';

  @override
  String get pauseOrDisconnectYour =>
      'Hãy tạm dừng hoặc ngắt ứng dụng VPN trước khi bắt đầu.';

  @override
  String get youCanTurnIt => 'Bạn có thể bật lại khi xong.';

  @override
  String get turnOnMirroringOn => 'Bật phản chiếu trên TV';

  @override
  String get samsungLgAndMost =>
      'TV Samsung, LG và hầu hết TV Android tự động chấp nhận phản chiếu.';

  @override
  String get otherTvsOpenInput =>
      'TV khác: mở Đầu vào / Nguồn và chọn Phản chiếu màn hình hoặc Miracast.';

  @override
  String get keepTheTvOn =>
      'Giữ TV ở màn hình đó trong lúc điện thoại kết nối.';

  @override
  String get tapStartAndPick => 'Chạm Bắt đầu và chọn TV của bạn';

  @override
  String get tapStartOnThe => 'Chạm Bắt đầu trên màn hình Phản chiếu màn hình.';

  @override
  String get androidOpensSmartView =>
      'Android mở Smart View / Cast. Chạm vào TV của bạn trong danh sách.';

  @override
  String get ifTheTvAsks =>
      'Nếu TV hỏi, hãy chọn Cho phép hoặc nhập mã PIN hiển thị trên màn hình.';

  @override
  String get youreMirroring => 'Bạn đang phản chiếu';

  @override
  String get everythingOnYourPhone =>
      'Mọi thứ trên điện thoại giờ hiển thị trên TV.';

  @override
  String get turnThePhoneSideways =>
      'Xoay ngang điện thoại để xem video và chơi game toàn màn hình.';

  @override
  String get toStopTapStop => 'Để dừng, chạm Dừng hoặc dùng thông báo truyền.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Tắt';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'TV phòng ngủ';

  @override
  String get officeDisplay => 'Màn hình văn phòng';

  @override
  String get clearHistory => 'Xóa lịch sử?';

  @override
  String get thisRemovesEverythingYouve =>
      'Thao tác này xóa mọi thứ bạn đã truyền khỏi danh sách.';

  @override
  String get clear => 'Xóa';

  @override
  String get clearHistory2 => 'Xóa lịch sử';

  @override
  String get noHistoryYet => 'Chưa có lịch sử';

  @override
  String get everythingYouCastWill =>
      'Mọi thứ bạn truyền sẽ được liệt kê ở đây để dễ tìm lại.';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get earlier => 'Trước đó';

  @override
  String get swipeAnItemTo => 'Vuốt một mục để xóa';

  @override
  String get delete => 'Xóa';

  @override
  String removed(Object title) {
    return 'Đã xóa “$title”';
  }

  @override
  String get undo => 'Hoàn tác';

  @override
  String get photos => 'Ảnh';

  @override
  String get albums => 'Album';

  @override
  String get videos => 'Video';

  @override
  String get gallery => 'Thư viện';

  @override
  String get music => 'Nhạc';

  @override
  String get songs => 'Bài hát';

  @override
  String get media => 'Phương tiện';

  @override
  String get browseTheWeb => 'Duyệt web';

  @override
  String get goPro => 'Nâng cấp Pro';

  @override
  String cast(Object title) {
    return 'Truyền $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Phản chiếu màn hình. Bắt đầu phản chiếu';

  @override
  String readyToMirrorTo(Object device) {
    return 'Sẵn sàng phản chiếu tới $device';
  }

  @override
  String get showYourPhoneOn =>
      'Hiển thị điện thoại trên TV theo thời gian thực.';

  @override
  String get startMirroring => 'Bắt đầu phản chiếu';

  @override
  String get tvRemote => 'Điều khiển TV';

  @override
  String get controlYourTv => 'Điều khiển TV của bạn';

  @override
  String get youtubeMore => 'YouTube & hơn thế nữa';

  @override
  String get openTheBrowser => 'Mở trình duyệt';

  @override
  String get searchOrTypeA => 'Tìm kiếm hoặc nhập trang web';

  @override
  String get howToConnectOpen => 'Cách kết nối. Mở hướng dẫn trực quan';

  @override
  String get visualGuideForEvery => 'Hướng dẫn trực quan cho mọi tính năng';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get done => 'Xong';

  @override
  String get enterAValidHttp =>
      'Nhập liên kết http(s) hoặc rtsp hợp lệ, ví dụ URL .m3u8 hoặc .mp4.';

  @override
  String get linkStream => 'Luồng liên kết';

  @override
  String get iptvLinkCast => 'IPTV / Truyền liên kết';

  @override
  String get castALink => 'Truyền một liên kết';

  @override
  String get pasteADirectVideo =>
      'Dán URL video trực tiếp, M3U8 hoặc luồng IPTV.';

  @override
  String get paste => 'Dán';

  @override
  String get castLink => 'Truyền liên kết';

  @override
  String get allowAccessToYour =>
      'Cho phép truy cập phương tiện để truyền. Bạn có thể thay đổi trong Cài đặt.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Truyền nhạc';

  @override
  String get noMusicFound => 'Không tìm thấy nhạc';

  @override
  String get addSongsToYour =>
      'Thêm bài hát vào điện thoại và chúng sẽ xuất hiện ở đây.';

  @override
  String get shuffle => 'Ngẫu nhiên';

  @override
  String get playAll => 'Phát tất cả';

  @override
  String photo(Object formatShortDate) {
    return 'Ảnh · $formatShortDate';
  }

  @override
  String get photo2 => 'Ảnh';

  @override
  String get castPhotos => 'Truyền ảnh';

  @override
  String get select => 'Chọn';

  @override
  String get noPhotosHere => 'Chưa có ảnh ở đây';

  @override
  String get photosYouTakeOr =>
      'Ảnh bạn chụp hoặc lưu sẽ xuất hiện trong album này.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count ảnh';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Ảnh ngày $formatShortDate';
  }

  @override
  String get allPhotos => 'Tất cả ảnh';

  @override
  String get slideshow => 'Trình chiếu';

  @override
  String get interval => 'Khoảng cách';

  @override
  String get transition => 'Chuyển cảnh';

  @override
  String get fade => 'Mờ dần';

  @override
  String get slide => 'Trượt';

  @override
  String get zoom => 'Thu phóng';

  @override
  String get startSlideshow => 'Bắt đầu trình chiếu';

  @override
  String get castVideos => 'Truyền video';

  @override
  String get noVideosYet => 'Chưa có video';

  @override
  String get videosYouRecordOr =>
      'Video bạn quay hoặc tải xuống sẽ xuất hiện ở đây, sẵn sàng để truyền.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Truyền';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Phiên phản chiếu màn hình';

  @override
  String get mirroringDidntStartTap =>
      'Phản chiếu chưa bắt đầu. Chạm Bắt đầu lần nữa và chọn TV của bạn trong danh sách.';

  @override
  String get openSmartViewOr =>
      'Mở Smart View hoặc Cast từ cài đặt nhanh của điện thoại để phản chiếu.';

  @override
  String get quality => 'Chất lượng';

  @override
  String get adjustsToYourWi =>
      'Tự điều chỉnh theo Wi-Fi của bạn để hình ảnh mượt nhất.';

  @override
  String upToLowerIt(Object label) {
    return 'Tối đa $label. Hãy giảm nếu hình bị giật.';
  }

  @override
  String get stillNeedHelp => 'Cần trợ giúp?';

  @override
  String get startingScreenMirroring => 'Đang bắt đầu phản chiếu màn hình…';

  @override
  String mirroringTo(Object value) {
    return 'Đang phản chiếu tới $value';
  }

  @override
  String get stopping => 'Đang dừng…';

  @override
  String get readyToMirror => 'Sẵn sàng phản chiếu';

  @override
  String get beforeYouStart => 'Trước khi bắt đầu';

  @override
  String get phoneAndTvAre => 'Điện thoại và TV cùng một Wi-Fi';

  @override
  String get noVpnIsConnected =>
      'Không có VPN nào được kết nối trên điện thoại';

  @override
  String get tvIsOnWith => 'TV đang bật và đã bật Phản chiếu màn hình';

  @override
  String get phoneIsCloseTo => 'Điện thoại ở gần TV';

  @override
  String get stopMirroring => 'Dừng phản chiếu';

  @override
  String get startMirroring2 => 'Bắt đầu phản chiếu';

  @override
  String get stop => 'Dừng';

  @override
  String get start => 'Bắt đầu';

  @override
  String get duration => 'Thời lượng';

  @override
  String get adIsLoading => 'Đang tải quảng cáo';

  @override
  String get ad => 'Quảng cáo';

  @override
  String get mirrorYourScreenTo => 'Phản chiếu màn hình lên mọi TV';

  @override
  String get showYourPhoneOnThe =>
      'Hiển thị điện thoại trên màn hình lớn chỉ với một chạm — không cáp, không rắc rối.';

  @override
  String get shareMemoriesWithThe =>
      'Chia sẻ kỷ niệm với cả phòng và điều khiển từ điện thoại.';

  @override
  String get castFromWebApps => 'Truyền từ web & ứng dụng';

  @override
  String get sendVideosFromYoutube =>
      'Gửi video từ YouTube, Facebook và mọi trang web thẳng lên TV.';

  @override
  String pageOf(Object value, Object length) {
    return 'Trang $value/$length';
  }

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get localNetwork => 'Mạng cục bộ';

  @override
  String get findTvsAndStreaming =>
      'Tìm TV và thiết bị phát trực tuyến trên Wi-Fi của bạn.';

  @override
  String get notifications => 'Thông báo';

  @override
  String get showCastingControlsWhile =>
      'Hiển thị điều khiển truyền khi bạn dùng ứng dụng khác.';

  @override
  String get photosVideosMusic => 'Ảnh, video & nhạc';

  @override
  String get pickWhatYouWantTo =>
      'Chọn nội dung muốn truyền từ thư viện của bạn.';

  @override
  String get screenCapture => 'Chụp màn hình';

  @override
  String get mirrorYourScreenYoull =>
      'Phản chiếu màn hình của bạn. Bạn sẽ xác nhận mỗi phiên.';

  @override
  String get webVideo => 'Video web';

  @override
  String get link => 'Liên kết';

  @override
  String get screenMirroring2 => 'Phản chiếu màn hình';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Đang truyền $title. Mở điều khiển';
  }

  @override
  String castingTo2(Object value) {
    return 'Đang truyền tới $value';
  }

  @override
  String get nowCasting => 'Đang truyền';

  @override
  String get nothingIsCasting => 'Không có gì đang truyền';

  @override
  String get pickAPhotoVideo =>
      'Chọn một ảnh, video, bài hát hoặc video web để gửi lên TV.';

  @override
  String get backToHome => 'Về trang chủ';

  @override
  String slide2(Object formatDuration) {
    return 'Trang chiếu $formatDuration';
  }

  @override
  String get back10Seconds => 'Lùi 10 giây';

  @override
  String get forward10Seconds => 'Tiến 10 giây';

  @override
  String get tvVolume => 'Âm lượng TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Âm lượng TV $round phần trăm';
  }

  @override
  String get upNext => 'Tiếp theo';

  @override
  String get addPhotos => 'Thêm ảnh';

  @override
  String get addVideos => 'Thêm video';

  @override
  String get nothingElseInThe => 'Không còn gì trong hàng đợi.';

  @override
  String play2(Object title) {
    return 'Phát $title';
  }

  @override
  String get unknownDevice => 'Thiết bị không xác định';

  @override
  String get perWeek => 'mỗi tuần';

  @override
  String get perYear => 'mỗi năm';

  @override
  String get payOnce => 'trả một lần';

  @override
  String get wirelessScreenMirroring => 'Phản chiếu màn hình không dây';

  @override
  String get castVideosPhotosMusic => 'Truyền video, ảnh & nhạc';

  @override
  String get fullTvRemoteControl => 'Điều khiển TV đầy đủ';

  @override
  String get worksWithAllMajor => 'Hoạt động với mọi TV phổ biến';

  @override
  String get smoothLagFreeStreaming => 'Phát mượt mà, không giật lag';

  @override
  String get noAds => 'Không quảng cáo';

  @override
  String get welcomeToCastflowPro => 'Chào mừng đến với CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Đã hủy giao dịch mua.';

  @override
  String get purchasePendingProUnlocks =>
      'Giao dịch mua đang chờ xử lý. Pro sẽ mở khóa ngay khi cửa hàng xác nhận.';

  @override
  String get purchaseFailedPleaseTry => 'Mua thất bại. Vui lòng thử lại.';

  @override
  String get theStoreIsntAvailable => 'Cửa hàng hiện không khả dụng.';

  @override
  String get close => 'Đóng';

  @override
  String get goProWithCastflow => 'NÂNG CẤP PRO VỚI CASTFLOW';

  @override
  String get unlockEveryFeature => 'Mở khóa mọi tính năng';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Tự động gia hạn cho đến khi hủy.';

  @override
  String get oneTimePurchaseNo => 'Mua một lần. Không đăng ký.';

  @override
  String get continueAction => 'Tiếp tục';

  @override
  String get privacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get termsAndConditions => 'Điều khoản và điều kiện';

  @override
  String get cancelAnytime => 'Hủy bất cứ lúc nào';

  @override
  String get loadingPrice => 'Đang tải giá…';

  @override
  String get pricesUnavailableTapTo => 'Không có giá · Chạm để thử lại';

  @override
  String get noPlansAvailableRight => 'Hiện không có gói nào.';

  @override
  String get weekly => 'Hằng tuần';

  @override
  String get yearly => 'Hằng năm';

  @override
  String get lifetime => 'Trọn đời';

  @override
  String get bestValue => 'Giá trị nhất';

  @override
  String get disconnectFromTv => 'Ngắt kết nối khỏi TV?';

  @override
  String get thisStopsWhatIs =>
      'Thao tác này dừng nội dung đang phát hoặc phản chiếu.';

  @override
  String get useTouchpad => 'Dùng bàn di chuột';

  @override
  String get useDPad => 'Dùng phím điều hướng';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Bộ thu $label không nhận lệnh điều khiển từ xa.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Một số nút không khả dụng trên $label.';
  }

  @override
  String get idle => 'NGHỈ';

  @override
  String get playing => 'ĐANG PHÁT';

  @override
  String get paused => 'TẠM DỪNG';

  @override
  String get noTvConnected => 'Chưa kết nối TV';

  @override
  String get mute2 => 'TẮT TIẾNG';

  @override
  String vol(Object volume) {
    return 'ÂM LƯỢNG $volume';
  }

  @override
  String get noTvConnectedTap => 'Chưa kết nối TV. Chạm để chọn thiết bị';

  @override
  String get tapToChooseA => 'Chạm để chọn thiết bị';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label không được $label2 hỗ trợ';
  }

  @override
  String get touchpadSwipeToMove =>
      'Bàn di chuột. Vuốt để di chuyển, chạm để chọn.';

  @override
  String get swipeToMoveTap => 'Vuốt để di chuyển · Chạm để chọn';

  @override
  String get navigationIsntSupportedBy => 'TV này không hỗ trợ điều hướng';

  @override
  String get vol2 => 'ÂM LƯỢNG';

  @override
  String get auto => 'Tự động';

  @override
  String get automatic => 'Tự động';

  @override
  String get googleCastFirst => 'Ưu tiên Google Cast';

  @override
  String get dlnaUpnpFirst => 'Ưu tiên DLNA / UPnP';

  @override
  String get miracastFirst => 'Ưu tiên Miracast';

  @override
  String get tvOnly => 'Chỉ TV';

  @override
  String get phoneAndTv => 'Điện thoại và TV';

  @override
  String get phoneOnly => 'Chỉ điện thoại';

  @override
  String get touchpad => 'Bàn di chuột';

  @override
  String get doMyPhoneAnd => 'Điện thoại và TV có cần cùng Wi-Fi không?';

  @override
  String get yesDiscoveryAndCasting =>
      'Có. Việc tìm kiếm và truyền diễn ra trong mạng cục bộ, nên cả hai phải cùng một Wi-Fi (tên băng tần giống nhau vẫn có thể là mạng khác nhau).';

  @override
  String get myRouterHasAp =>
      'Bộ định tuyến của tôi có “cách ly AP / máy khách”';

  @override
  String get isolationBlocksDevicesFrom =>
      'Cách ly khiến các thiết bị không thấy nhau. Hãy tắt trong cài đặt bộ định tuyến hoặc dùng mạng không phải mạng khách.';

  @override
  String get findingYourTv => 'Tìm TV của bạn';

  @override
  String get myTvDoesntAppear => 'TV của tôi không xuất hiện trong danh sách';

  @override
  String get turnOnCastingScreen =>
      'Bật truyền / phản chiếu màn hình trên TV, đánh thức khỏi chế độ chờ, rồi chạm Quét lại. Cho phép quyền Mạng cục bộ nếu được hỏi.';

  @override
  String get onlySomeDevicesShow => 'Chỉ một số thiết bị xuất hiện';

  @override
  String get olderTvsMayNeed =>
      'TV cũ có thể cần cập nhật firmware. TV Miracast chỉ xuất hiện khi đầu vào “Phản chiếu màn hình” đang mở.';

  @override
  String get connectionFailsOrTimes => 'Kết nối thất bại hoặc hết thời gian';

  @override
  String get restartTheTvApp =>
      'Khởi động lại ứng dụng TV hoặc TV, lại gần bộ định tuyến và chấp nhận mọi lời nhắc trên màn hình TV.';

  @override
  String get itKeepsReconnectingTo => 'Cứ kết nối lại với TV cũ';

  @override
  String get turnOffAutoConnect =>
      'Tắt “Tự động kết nối TV gần nhất” trong Cài đặt → Truyền.';

  @override
  String get mirroringIsLaggy => 'Phản chiếu bị giật';

  @override
  String get chooseALowerQuality =>
      'Chọn chất lượng thấp hơn (720p hoặc 480p), đóng các ứng dụng nặng và dùng mạng Wi-Fi 5 GHz.';

  @override
  String get thePictureIsRotated => 'Hình bị xoay hoặc bị cắt';

  @override
  String get toggleAutoRotateOn =>
      'Bật/tắt Tự động xoay trên màn hình Phản chiếu màn hình.';

  @override
  String get sound => 'Âm thanh';

  @override
  String get thereIsNoSound => 'TV không có tiếng';

  @override
  String get makeSureAudioIs =>
      'Hãy đảm bảo Âm thanh đã bật trong Phản chiếu màn hình và kiểm tra Cài đặt → Truyền → Đầu ra âm thanh. Một số bộ thu không hỗ trợ âm thanh điện thoại.';

  @override
  String get tvRemote2 => 'Điều khiển TV';

  @override
  String get someRemoteButtonsAre => 'Một số nút điều khiển có màu xám';

  @override
  String get eachReceiverSupportsDifferent =>
      'Mỗi bộ thu hỗ trợ lệnh khác nhau. Chromecast và DLNA chỉ hỗ trợ phát và âm lượng; Miracast không có kênh điều khiển.';

  @override
  String get canCastflowTurnMy =>
      'CastFlow có thể bật TV hoặc đổi đầu vào không?';

  @override
  String get onlyOnTvsThat =>
      'Chỉ trên TV cung cấp các lệnh đó qua mạng. Nút không được hỗ trợ sẽ bị vô hiệu hóa thay vì giả vờ hoạt động.';

  @override
  String get helpFaq => 'Trợ giúp & Câu hỏi thường gặp';

  @override
  String get stepByStepConnection => 'Hướng dẫn kết nối từng bước';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Không tìm thấy ứng dụng email.';

  @override
  String get enjoyingCastflow => 'Bạn thích CastFlow chứ?';

  @override
  String get sorryToHearThat => 'Chúng tôi rất tiếc';

  @override
  String get thanksHowCanWe => 'Cảm ơn! Chúng tôi có thể cải thiện thế nào?';

  @override
  String get wereGladYouLike => 'Chúng tôi rất vui vì bạn thích!';

  @override
  String get youMadeOurDay => 'Bạn đã làm ngày của chúng tôi thật vui!';

  @override
  String get tapToExit => 'Chạm để thoát';

  @override
  String get selectARating => 'Chọn xếp hạng';

  @override
  String get sendFeedback => 'Gửi phản hồi';

  @override
  String get rateUs => 'Đánh giá chúng tôi';

  @override
  String get rateYourExperienceBefore =>
      'Hãy đánh giá trải nghiệm trước khi rời đi.';

  @override
  String get tapAStarTo => 'Chạm một ngôi sao để đánh giá CastFlow.';

  @override
  String get general => 'Chung';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Chất lượng mặc định';

  @override
  String get autoConnectToLast => 'Tự động kết nối TV gần nhất';

  @override
  String get hapticFeedback => 'Phản hồi xúc giác';

  @override
  String get clearCastingHistory => 'Xóa lịch sử truyền';

  @override
  String get clearCastingHistory2 => 'Xóa lịch sử truyền?';

  @override
  String get onlyCastflowsListIs =>
      'Chỉ danh sách của CastFlow bị xóa. Phương tiện trên điện thoại không bao giờ bị xóa.';

  @override
  String get appearance => 'Giao diện';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get system => 'Hệ thống';

  @override
  String get aboutSupport => 'Giới thiệu & hỗ trợ';

  @override
  String get rateApp => 'Đánh giá ứng dụng';

  @override
  String get feedback => 'Phản hồi';

  @override
  String get termsConditions => 'Điều khoản & Điều kiện';

  @override
  String get version => 'Phiên bản';

  @override
  String get castflowProIsActive => 'CastFlow Pro đang hoạt động';

  @override
  String get upgradeToPremium => 'Nâng cấp lên Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Cảm ơn bạn đã ủng hộ. Tận hưởng việc truyền không quảng cáo.';

  @override
  String get noAds1080pMirroring =>
      'Không quảng cáo, phản chiếu 1080p & truyền không giới hạn';

  @override
  String get upgrade => 'Nâng cấp';

  @override
  String get mirrorCastBeautifullySimple =>
      'Phản chiếu & truyền, đơn giản và đẹp';

  @override
  String get thisActionMayContain => 'Thao tác này có thể chứa quảng cáo';

  @override
  String get webCast => 'Truyền web';

  @override
  String get castThisVideo => 'Truyền video này';

  @override
  String get searchOrTypeAWeb => 'Tìm kiếm hoặc nhập địa chỉ web';

  @override
  String get removeBookmark => 'Xóa dấu trang';

  @override
  String get bookmark => 'Dấu trang';

  @override
  String get quickAccess => 'Truy cập nhanh';

  @override
  String open2(Object title) {
    return 'Mở $title';
  }

  @override
  String get bookmarks => 'Dấu trang';

  @override
  String get noBookmarks => 'Chưa có dấu trang';

  @override
  String get tapTheBookmarkIcon =>
      'Chạm biểu tượng dấu trang trên thanh địa chỉ để lưu trang.';

  @override
  String get noHistory => 'Chưa có lịch sử';

  @override
  String get pagesYouVisitShow => 'Các trang bạn truy cập sẽ xuất hiện ở đây.';

  @override
  String get remove => 'Xóa';

  @override
  String resultOn(Object value, Object host) {
    return 'Kết quả $value trên $host';
  }

  @override
  String get aSimulatedPageResult => 'Một kết quả trang mô phỏng';

  @override
  String get videosOnThisPage => 'Video trên trang này';

  @override
  String get pickOneToSend => 'Chọn một video để gửi lên TV.';

  @override
  String get onboardHotspotTitle => 'Không có Wi-Fi? Dùng điểm phát sóng';

  @override
  String get onboardHotspotBody =>
      'Bật điểm phát sóng trên điện thoại và kết nối TV. Truyền hình hoạt động như khi dùng Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Vẫn chưa tìm thấy TV?';

  @override
  String get stillCantFindBody =>
      'Kết nối TV với điểm phát sóng của điện thoại:';

  @override
  String get hotspotStep4 => 'Nhấn Thử lại và chọn TV trong danh sách';

  @override
  String get castOverHotspot =>
      'Không có Wi-Fi? Truyền qua điểm phát sóng của điện thoại:';

  @override
  String get queue => 'Hàng chờ';

  @override
  String get addMusic => 'Thêm nhạc';

  @override
  String get connectWithWifi => 'Kết nối Wi-Fi';

  @override
  String get continueWithHotspot => 'Tiếp tục bằng điểm phát sóng';

  @override
  String get noWifiAlertMessage =>
      'Bạn đang dùng dữ liệu di động. Hãy kết nối điện thoại và TV vào cùng một Wi-Fi, hoặc bật điểm phát sóng của điện thoại rồi kết nối TV vào đó.';
}
