// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get networkRequiredTitle => 'ไม่ได้เชื่อมต่อ Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'โทรศัพท์และทีวีต้องอยู่ในเครือข่าย Wi-Fi เดียวกันจึงจะแคสต์ได้';

  @override
  String get openWifiSettings => 'เปิดการตั้งค่า Wi-Fi';

  @override
  String get useMobileHotspot => 'ใช้ฮอตสปอตมือถือ';

  @override
  String get hotspotInstruction => 'เชื่อมต่อทีวีกับฮอตสปอตมือถือของโทรศัพท์';

  @override
  String get hotspotStep1 => 'เปิดฮอตสปอตมือถือ';

  @override
  String get hotspotStep2 => 'เชื่อมต่อทีวีของคุณเข้ากับฮอตสปอต';

  @override
  String get hotspotStep3 => 'กลับมาที่แอป';

  @override
  String get openHotspotSettings => 'เปิดการตั้งค่าฮอตสปอต';

  @override
  String get hotspotAutoCheck =>
      'เมื่อคุณกลับมา เราจะตรวจสอบอีกครั้งโดยอัตโนมัติ';

  @override
  String get hotspotDetected => 'เปิดฮอตสปอตแล้ว กำลังค้นหาทีวีของคุณ…';

  @override
  String get searchingDevices => 'กำลังค้นหาอุปกรณ์ใกล้เคียง...';

  @override
  String get waitingForTvOnHotspot => 'กำลังรอให้ทีวีเข้าร่วมฮอตสปอตของคุณ…';

  @override
  String get usingHotspot => 'กำลังใช้ฮอตสปอตมือถือของคุณ';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'พบ $count อุปกรณ์',
      one: 'พบ 1 อุปกรณ์',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get scanAgain => 'สแกนอีกครั้ง';

  @override
  String get isolationTitle => 'ทีวีไม่ตอบสนอง';

  @override
  String get isolationHint =>
      'มีอุปกรณ์เข้าร่วมฮอตสปอตของคุณแต่ไม่ตอบสนอง ฮอตสปอตอาจบล็อกการรับส่งข้อมูลระหว่างอุปกรณ์ (การแยกไคลเอนต์) ปิดฟีเจอร์นี้ในการตั้งค่าฮอตสปอต หรือใช้เครือข่าย Wi-Fi';

  @override
  String get connecting => 'กำลังเชื่อมต่อ…';

  @override
  String get connected => 'เชื่อมต่อแล้ว';

  @override
  String get connectionFailed => 'เชื่อมต่อไม่ได้';

  @override
  String get connectFailedHint =>
      'ตรวจสอบว่าโทรศัพท์และทีวีอยู่ในเครือข่ายเดียวกัน แล้วลองอีกครั้ง';

  @override
  String get hotspotConnectHint =>
      'ฮอตสปอตของคุณอาจบล็อกการรับส่งข้อมูลระหว่างอุปกรณ์ ตรวจสอบการตั้งค่าการแยกไคลเอนต์';

  @override
  String get networkLostTitle => 'การเชื่อมต่อเครือข่ายขาดหาย';

  @override
  String get networkLostMessage =>
      'เชื่อมต่อ Wi-Fi หรือฮอตสปอตอีกครั้ง แล้วเชื่อมต่อกับทีวีใหม่';

  @override
  String get reconnect => 'เชื่อมต่อใหม่';

  @override
  String reconnectTo(String name) {
    return 'เชื่อมต่อกับ $name ใหม่';
  }

  @override
  String get tapToReconnect => 'แตะเพื่อเชื่อมต่อใหม่';

  @override
  String get pairingRequired => 'ต้องจับคู่';

  @override
  String get pairingEnterCode => 'ป้อนรหัสที่แสดงบนทีวีของคุณ';

  @override
  String get pairingApproveOnTv => 'ดูที่ทีวีแล้วแตะอนุญาตเพื่อดำเนินการต่อ';

  @override
  String get connect => 'เชื่อมต่อ';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get pairingIncorrectCode => 'รหัสไม่ถูกต้อง ลองอีกครั้ง';

  @override
  String get pairingTimedOut => 'การจับคู่หมดเวลา';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get pairingDeclined => 'ทีวีปฏิเสธการเชื่อมต่อ';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'ป้อนรหัสผิดหลายครั้งเกินไป รอ $seconds วินาที แล้วขอรหัสใหม่';
  }

  @override
  String get pairingCooldownOver => 'ตอนนี้คุณขอรหัสใหม่ได้แล้ว';

  @override
  String get pairingRequestNewCode => 'ขอรหัสใหม่';

  @override
  String get pairingNetworkLost =>
      'เครือข่ายขาดหายระหว่างการจับคู่ เชื่อมต่อ Wi-Fi ใหม่แล้วลองอีกครั้ง';

  @override
  String get pairingFailed => 'จับคู่กับทีวีไม่ได้';

  @override
  String pairingCodeField(int length) {
    return 'รหัสจับคู่ $length หลัก';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'ช่องรหัส $index จาก $total';
  }

  @override
  String get pairingEmptyBox => 'ว่าง';

  @override
  String get pairingPaired => 'จับคู่แล้ว';

  @override
  String get forgetDevice => 'ลืมอุปกรณ์';

  @override
  String forgetDeviceMessage(String name) {
    return 'ครั้งหน้าต้องจับคู่ $name ใหม่';
  }

  @override
  String get forget => 'ลืม';

  @override
  String get castVideo => 'แคสต์วิดีโอ';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'พบ $count วิดีโอ แคสต์วิดีโอ',
      one: 'พบ 1 วิดีโอ แคสต์วิดีโอ',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'ยังไม่พบวิดีโอในหน้านี้';

  @override
  String get videoFound => 'พบวิดีโอ';

  @override
  String get videoFoundMessage => 'เล่นบนทีวีของคุณ';

  @override
  String get castAction => 'แคสต์';

  @override
  String get dismiss => 'ปิด';

  @override
  String videosFound(int count) {
    return 'วิดีโอที่พบ ($count)';
  }

  @override
  String get castToTv => 'แคสต์ไปที่ทีวี';

  @override
  String get protectedVideo => 'มีการป้องกัน แคสต์ไม่ได้';

  @override
  String get videoThumbnail => 'ภาพขนาดย่อของวิดีโอ';

  @override
  String castingTo(String device) {
    return 'กำลังแคสต์ไปที่ $device';
  }

  @override
  String get stopCasting => 'หยุดแคสต์';

  @override
  String get play => 'เล่น';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get volume => 'ระดับเสียง';

  @override
  String get seekPosition => 'ตำแหน่งการเล่น';

  @override
  String get showControls => 'แสดงตัวควบคุม';

  @override
  String get hideControls => 'ซ่อนตัวควบคุม';

  @override
  String get formatUnsupportedTitle => 'ไม่รองรับรูปแบบนี้';

  @override
  String formatUnsupported(String device, String format) {
    return '$device เล่นวิดีโอ $format ไม่ได้ ลองวิดีโออื่นในหน้านี้ หรือใช้การสะท้อนหน้าจอ';
  }

  @override
  String get videoExpired =>
      'ลิงก์วิดีโอนี้หมดอายุ โหลดหน้าใหม่แล้วลองอีกครั้ง';

  @override
  String get refreshingVideo => 'กำลังขอลิงก์วิดีโอใหม่…';

  @override
  String get browserBack => 'กลับ';

  @override
  String get browserForward => 'ไปข้างหน้า';

  @override
  String get browserStartPage => 'หน้าเริ่มต้น';

  @override
  String get browserReload => 'โหลดใหม่';

  @override
  String get ok => 'ตกลง';

  @override
  String get home => 'หน้าแรก';

  @override
  String get devices => 'อุปกรณ์';

  @override
  String get history => 'ประวัติ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get goodMorning => 'สวัสดีตอนเช้า';

  @override
  String get goodAfternoon => 'สวัสดีตอนบ่าย';

  @override
  String get goodEvening => 'สวัสดีตอนเย็น';

  @override
  String get couldntOpenTheLink => 'เปิดลิงก์ไม่ได้';

  @override
  String get castflowLogo => 'โลโก้ CastFlow';

  @override
  String get somethingWentWrong => 'เกิดข้อผิดพลาด';

  @override
  String get weCouldntLoadThis => 'ตอนนี้โหลดไม่ได้ โปรดลองอีกครั้ง';

  @override
  String get apps => 'แอป';

  @override
  String open(Object name) {
    return 'เปิด $name';
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
  String get up => 'ขึ้น';

  @override
  String get down => 'ลง';

  @override
  String get left => 'ซ้าย';

  @override
  String get right => 'ขวา';

  @override
  String get menu => 'เมนู';

  @override
  String get input => 'อินพุต';

  @override
  String get playPause => 'เล่น / หยุดชั่วคราว';

  @override
  String get previous => 'ก่อนหน้า';

  @override
  String get next => 'ถัดไป';

  @override
  String get rewind => 'กรอกลับ';

  @override
  String get volumeUp => 'เพิ่มเสียง';

  @override
  String get volumeDown => 'ลดเสียง';

  @override
  String get mute => 'ปิดเสียง';

  @override
  String connectedTo(Object name) {
    return 'เชื่อมต่อกับ $name แล้ว';
  }

  @override
  String get chooseADevice => 'เลือกอุปกรณ์';

  @override
  String get connectionGuide => 'คู่มือการเชื่อมต่อ';

  @override
  String get lookingForTvsOn => 'กำลังค้นหาทีวีใน Wi-Fi ของคุณ';

  @override
  String foundSoFar(Object found) {
    return 'พบแล้ว $found เครื่อง';
  }

  @override
  String deviceFound(Object found, Object value) {
    return 'พบ $found อุปกรณ์';
  }

  @override
  String get disconnect => 'ยกเลิกการเชื่อมต่อ';

  @override
  String signalOf4(Object level) {
    return 'สัญญาณ $level จาก 4';
  }

  @override
  String get connecting2 => 'กำลังเชื่อมต่อ';

  @override
  String get theTvRemoteNeeds =>
      'รีโมททีวีต้องมีทีวีที่เชื่อมต่ออยู่ เลือกหนึ่งเครื่องด้านล่าง';

  @override
  String get connectToATv => 'เชื่อมต่อทีวีเพื่อดำเนินการต่อ';

  @override
  String get findingTvs => 'กำลังค้นหาทีวี…';

  @override
  String get makeSureYourTv => 'ตรวจสอบว่าทีวีเปิดอยู่';

  @override
  String get notConnected => 'ไม่ได้เชื่อมต่อ';

  @override
  String get tapToFindYour => 'แตะเพื่อค้นหาทีวีของคุณ';

  @override
  String get connectionFailed2 => 'เชื่อมต่อไม่สำเร็จ';

  @override
  String tapToManageDevices(Object label) {
    return '$label แตะเพื่อจัดการอุปกรณ์';
  }

  @override
  String get joinTheSameWi => 'เข้าร่วม Wi-Fi เดียวกัน';

  @override
  String get connectYourPhoneAnd =>
      'เชื่อมต่อโทรศัพท์และทีวีกับเครือข่าย Wi-Fi เดียวกัน';

  @override
  String get turnOnCastingOn => 'เปิดการแคสต์บนทีวี';

  @override
  String get enableScreenMirroringMiracast =>
      'เปิดการสะท้อนหน้าจอ Miracast หรือ Google Cast ในการตั้งค่าทีวี';

  @override
  String get scanForDevices => 'สแกนอุปกรณ์';

  @override
  String get openDevicesInCastflow =>
      'เปิดอุปกรณ์ใน CastFlow แล้วรอสักครู่ให้ทีวีปรากฏ';

  @override
  String get tapConnect => 'แตะเชื่อมต่อ';

  @override
  String get acceptThePromptOn => 'ยอมรับข้อความบนทีวีหากมี เสร็จแล้ว!';

  @override
  String get howToConnect => 'วิธีเชื่อมต่อ';

  @override
  String get fourQuickStepsTo => 'สี่ขั้นตอนง่ายๆ เพื่อขึ้นจอใหญ่';

  @override
  String get gotIt => 'เข้าใจแล้ว';

  @override
  String step(Object number, Object title, Object body) {
    return 'ขั้นตอนที่ $number $title $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi บ้าน';

  @override
  String get router => 'เราเตอร์';

  @override
  String get settingsConnection => 'การตั้งค่า › การเชื่อมต่อ';

  @override
  String get inputHdmi1 => 'อินพุต: HDMI 1';

  @override
  String get screenMirroring => 'การสะท้อนหน้าจอ';

  @override
  String get networkHomeWiFi => 'เครือข่าย: Wi-Fi บ้าน';

  @override
  String get livingRoomTv => 'ทีวีห้องนั่งเล่น';

  @override
  String get allowCastflowToConnect => 'อนุญาตให้ CastFlow เชื่อมต่อไหม';

  @override
  String get deny => 'ปฏิเสธ';

  @override
  String get allow => 'อนุญาต';

  @override
  String get yourTv => 'ทีวีของคุณ';

  @override
  String get findYourTv => 'ค้นหาทีวีของคุณ';

  @override
  String connectTo(Object name) {
    return 'เชื่อมต่อกับ $name';
  }

  @override
  String connected2(Object label) {
    return 'เชื่อมต่อแล้ว · $label';
  }

  @override
  String get openTvRemote => 'เปิดรีโมททีวี';

  @override
  String get sameWiFiNetwork => 'เครือข่าย Wi-Fi เดียวกัน';

  @override
  String get yourPhoneAndTv => 'โทรศัพท์และทีวีต้องเชื่อมต่อ Wi-Fi เดียวกัน';

  @override
  String get tvIsOnAnd => 'ทีวีเปิดอยู่และพร้อมใช้งาน';

  @override
  String get turnOnScreenMirroring =>
      'เปิดการสะท้อนหน้าจอ Cast หรือ Miracast บนทีวี';

  @override
  String get noVpnOrGuest => 'ไม่ใช้ VPN หรือเครือข่ายผู้เยี่ยมชม';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN และ Wi-Fi ผู้เยี่ยมชม/แบบแยกจะทำให้อุปกรณ์มองไม่เห็นกัน';

  @override
  String get localNetworkAccess => 'การเข้าถึงเครือข่ายภายใน';

  @override
  String get allowCastflowToFind =>
      'เมื่อถูกถาม ให้อนุญาตให้ CastFlow ค้นหาอุปกรณ์ในเครือข่ายของคุณ';

  @override
  String get noTvFound => 'ไม่พบทีวี';

  @override
  String get checkThatYourPhone =>
      'ตรวจสอบว่าโทรศัพท์และทีวีอยู่ใน Wi-Fi เดียวกัน แล้วสแกนอีกครั้ง';

  @override
  String get noWiFiRouter => 'ไม่มีเราเตอร์ Wi-Fi ใช่ไหม ใช้ฮอตสปอตของคุณ';

  @override
  String searchingForTvsFound(Object length) {
    return 'กำลังค้นหาทีวี พบ $length เครื่อง';
  }

  @override
  String tvsFound(Object length) {
    return 'พบทีวี $length เครื่อง';
  }

  @override
  String get connectToYourTv => 'เชื่อมต่อกับทีวีของคุณ';

  @override
  String get connectYourPhoneAndTv =>
      'เชื่อมต่อโทรศัพท์และทีวีกับเครือข่าย Wi-Fi เดียวกัน';

  @override
  String get turnOnTheTv => 'เปิดทีวีแล้วเปิดอินพุตการสะท้อนหน้าจอ / Cast';

  @override
  String get tapTheConnectionBar =>
      'แตะแถบการเชื่อมต่อที่หน้าแรกเพื่อค้นหาทีวีของคุณ';

  @override
  String get tapConnectAndAccept => 'แตะเชื่อมต่อ แล้วยอมรับข้อความบนทีวีหากมี';

  @override
  String get mirrorYourScreen => 'สะท้อนหน้าจอของคุณ';

  @override
  String get connectToYourTvFirst => 'เชื่อมต่อกับทีวีก่อน';

  @override
  String get openScreenMirroringFrom => 'เปิดการสะท้อนหน้าจอจากหน้าแรก';

  @override
  String get pickAQualityAnd => 'เลือกคุณภาพแล้วแตะเริ่ม';

  @override
  String get allowScreenCaptureWhen => 'อนุญาตการจับภาพหน้าจอเมื่อ Android ถาม';

  @override
  String get castPhotosVideosMusic => 'แคสต์รูปภาพ วิดีโอ และเพลง';

  @override
  String get openPhotosVideosOr => 'เปิดรูปภาพ วิดีโอ หรือเพลงที่หน้าแรก';

  @override
  String get pickWhatYouWant => 'เลือกสิ่งที่ต้องการแสดง';

  @override
  String get itPlaysOnThe => 'จะเล่นบนทีวี ควบคุมจากโทรศัพท์หรือการแจ้งเตือน';

  @override
  String get useTheTvRemote => 'ใช้รีโมททีวี';

  @override
  String get openTvRemoteOn => 'เปิดรีโมททีวีที่หน้าแรก';

  @override
  String get useTheDPad =>
      'ใช้ปุ่มทิศทางหรือปัดบนทัชแพดเพื่อเลื่อน แตะ OK เพื่อเลือก';

  @override
  String get buttonsATvDoesnt => 'ปุ่มที่ทีวีไม่รองรับจะเป็นสีเทา';

  @override
  String get castFromTheWeb => 'แคสต์จากเว็บและแอป';

  @override
  String get tapTheBrowserBar => 'แตะแถบเบราว์เซอร์หรือแอปที่หน้าแรก';

  @override
  String get playAVideoOn => 'เล่นวิดีโอบนเว็บไซต์';

  @override
  String get tapCastThisVideo => 'แตะ “แคสต์วิดีโอนี้” เพื่อส่งไปที่ทีวี';

  @override
  String get screenMirroringHelp => 'ความช่วยเหลือการสะท้อนหน้าจอ';

  @override
  String get connectYourPhoneTo => 'เชื่อมต่อโทรศัพท์กับ Wi-Fi';

  @override
  String get onTheTvOpen =>
      'บนทีวี เปิดการตั้งค่า → เครือข่าย แล้วเข้าร่วม Wi-Fi เดียวกัน';

  @override
  String get guestOrOfficeNetworks =>
      'เครือข่ายผู้เยี่ยมชมหรือที่ทำงานมักบล็อกการสะท้อน ให้ใช้ Wi-Fi บ้านหรือฮอตสปอตของโทรศัพท์';

  @override
  String get turnOffVpn => 'ปิด VPN';

  @override
  String get aVpnHidesYour => 'VPN ทำให้โทรศัพท์มองไม่เห็นทีวีของคุณ';

  @override
  String get pauseOrDisconnectYour =>
      'หยุดหรือยกเลิกการเชื่อมต่อแอป VPN ก่อนเริ่ม';

  @override
  String get youCanTurnIt => 'เปิดกลับมาได้เมื่อเสร็จแล้ว';

  @override
  String get turnOnMirroringOn => 'เปิดการสะท้อนบนทีวี';

  @override
  String get samsungLgAndMost =>
      'ทีวี Samsung, LG และ Android TV ส่วนใหญ่ยอมรับการสะท้อนโดยอัตโนมัติ';

  @override
  String get otherTvsOpenInput =>
      'ทีวีอื่น: เปิดอินพุต / แหล่งสัญญาณ แล้วเลือกการสะท้อนหน้าจอหรือ Miracast';

  @override
  String get keepTheTvOn => 'ปล่อยให้ทีวีอยู่ที่หน้านั้นขณะโทรศัพท์เชื่อมต่อ';

  @override
  String get tapStartAndPick => 'แตะเริ่มแล้วเลือกทีวีของคุณ';

  @override
  String get tapStartOnThe => 'แตะเริ่มที่หน้าจอการสะท้อนหน้าจอ';

  @override
  String get androidOpensSmartView =>
      'Android จะเปิด Smart View / Cast แตะทีวีของคุณในรายการ';

  @override
  String get ifTheTvAsks =>
      'หากทีวีถาม ให้เลือกอนุญาตหรือป้อน PIN ที่แสดงบนหน้าจอ';

  @override
  String get youreMirroring => 'คุณกำลังสะท้อนหน้าจอ';

  @override
  String get everythingOnYourPhone => 'ทุกอย่างบนโทรศัพท์ของคุณแสดงบนทีวีแล้ว';

  @override
  String get turnThePhoneSideways =>
      'หมุนโทรศัพท์แนวนอนเพื่อดูวิดีโอและเล่นเกมเต็มจอ';

  @override
  String get toStopTapStop =>
      'หากต้องการหยุด แตะหยุดหรือใช้การแจ้งเตือนการแคสต์';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'ปิด';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'ทีวีห้องนอน';

  @override
  String get officeDisplay => 'จอแสดงผลที่ออฟฟิศ';

  @override
  String get clearHistory => 'ล้างประวัติไหม';

  @override
  String get thisRemovesEverythingYouve =>
      'การดำเนินการนี้จะลบทุกอย่างที่คุณแคสต์ออกจากรายการนี้';

  @override
  String get clear => 'ล้าง';

  @override
  String get clearHistory2 => 'ล้างประวัติ';

  @override
  String get noHistoryYet => 'ยังไม่มีประวัติ';

  @override
  String get everythingYouCastWill =>
      'ทุกอย่างที่คุณแคสต์จะแสดงที่นี่เพื่อให้หาเจออีกครั้ง';

  @override
  String get today => 'วันนี้';

  @override
  String get yesterday => 'เมื่อวาน';

  @override
  String get earlier => 'ก่อนหน้า';

  @override
  String get swipeAnItemTo => 'ปัดรายการเพื่อลบ';

  @override
  String get delete => 'ลบ';

  @override
  String removed(Object title) {
    return 'ลบ “$title” แล้ว';
  }

  @override
  String get undo => 'เลิกทำ';

  @override
  String get photos => 'รูปภาพ';

  @override
  String get albums => 'อัลบั้ม';

  @override
  String get videos => 'วิดีโอ';

  @override
  String get gallery => 'แกลเลอรี';

  @override
  String get music => 'เพลง';

  @override
  String get songs => 'เพลง';

  @override
  String get media => 'สื่อ';

  @override
  String get browseTheWeb => 'เรียกดูเว็บ';

  @override
  String get goPro => 'อัปเกรดเป็น Pro';

  @override
  String cast(Object title) {
    return 'แคสต์ $title';
  }

  @override
  String get screenMirroringStartMirroring => 'การสะท้อนหน้าจอ เริ่มการสะท้อน';

  @override
  String readyToMirrorTo(Object device) {
    return 'พร้อมสะท้อนไปที่ $device';
  }

  @override
  String get showYourPhoneOn => 'แสดงโทรศัพท์ของคุณบนทีวีแบบเรียลไทม์';

  @override
  String get startMirroring => 'เริ่มการสะท้อนหน้าจอ';

  @override
  String get tvRemote => 'รีโมททีวี';

  @override
  String get controlYourTv => 'ควบคุมทีวีของคุณ';

  @override
  String get youtubeMore => 'YouTube และอื่นๆ';

  @override
  String get openTheBrowser => 'เปิดเบราว์เซอร์';

  @override
  String get searchOrTypeA => 'ค้นหาหรือพิมพ์เว็บไซต์';

  @override
  String get howToConnectOpen => 'วิธีเชื่อมต่อ เปิดคู่มือภาพ';

  @override
  String get visualGuideForEvery => 'คู่มือภาพสำหรับทุกฟีเจอร์';

  @override
  String get language => 'ภาษา';

  @override
  String get done => 'เสร็จสิ้น';

  @override
  String get enterAValidHttp =>
      'ป้อนลิงก์ http(s) หรือ rtsp ที่ถูกต้อง เช่น URL .m3u8 หรือ .mp4';

  @override
  String get linkStream => 'สตรีมลิงก์';

  @override
  String get iptvLinkCast => 'IPTV / แคสต์ลิงก์';

  @override
  String get castALink => 'แคสต์ลิงก์';

  @override
  String get pasteADirectVideo => 'วาง URL วิดีโอโดยตรง M3U8 หรือสตรีม IPTV';

  @override
  String get paste => 'วาง';

  @override
  String get castLink => 'แคสต์ลิงก์';

  @override
  String get allowAccessToYour =>
      'อนุญาตการเข้าถึงสื่อของคุณเพื่อแคสต์ เปลี่ยนได้ในการตั้งค่า';

  @override
  String get video => 'วิดีโอ';

  @override
  String get castMusic => 'แคสต์เพลง';

  @override
  String get noMusicFound => 'ไม่พบเพลง';

  @override
  String get addSongsToYour => 'เพิ่มเพลงลงในโทรศัพท์แล้วจะแสดงที่นี่';

  @override
  String get shuffle => 'สุ่ม';

  @override
  String get playAll => 'เล่นทั้งหมด';

  @override
  String photo(Object formatShortDate) {
    return 'รูปภาพ · $formatShortDate';
  }

  @override
  String get photo2 => 'รูปภาพ';

  @override
  String get castPhotos => 'แคสต์รูปภาพ';

  @override
  String get select => 'เลือก';

  @override
  String get noPhotosHere => 'ไม่มีรูปภาพที่นี่';

  @override
  String get photosYouTakeOr => 'รูปภาพที่คุณถ่ายหรือบันทึกจะแสดงในอัลบั้มนี้';

  @override
  String photos2(Object name, Object count) {
    return '$name $count รูป';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'รูปภาพจาก $formatShortDate';
  }

  @override
  String get allPhotos => 'รูปภาพทั้งหมด';

  @override
  String get slideshow => 'สไลด์โชว์';

  @override
  String get interval => 'ช่วงเวลา';

  @override
  String get transition => 'การเปลี่ยนภาพ';

  @override
  String get fade => 'เฟด';

  @override
  String get slide => 'เลื่อน';

  @override
  String get zoom => 'ซูม';

  @override
  String get startSlideshow => 'เริ่มสไลด์โชว์';

  @override
  String get castVideos => 'แคสต์วิดีโอ';

  @override
  String get noVideosYet => 'ยังไม่มีวิดีโอ';

  @override
  String get videosYouRecordOr =>
      'วิดีโอที่คุณบันทึกหรือดาวน์โหลดจะแสดงที่นี่ พร้อมแคสต์';

  @override
  String video2(Object resolution) {
    return 'วิดีโอ · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title $formatDuration แคสต์';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'เซสชันการสะท้อนหน้าจอ';

  @override
  String get mirroringDidntStartTap =>
      'การสะท้อนไม่เริ่มต้น แตะเริ่มอีกครั้งแล้วเลือกทีวีของคุณในรายการ';

  @override
  String get openSmartViewOr =>
      'เปิด Smart View หรือ Cast จากการตั้งค่าด่วนของโทรศัพท์เพื่อสะท้อน';

  @override
  String get quality => 'คุณภาพ';

  @override
  String get adjustsToYourWi => 'ปรับตาม Wi-Fi ของคุณเพื่อภาพที่ลื่นไหลที่สุด';

  @override
  String upToLowerIt(Object label) {
    return 'สูงสุด $label ลดลงหากภาพกระตุก';
  }

  @override
  String get stillNeedHelp => 'ต้องการความช่วยเหลือไหม';

  @override
  String get startingScreenMirroring => 'กำลังเริ่มการสะท้อนหน้าจอ…';

  @override
  String mirroringTo(Object value) {
    return 'กำลังสะท้อนไปที่ $value';
  }

  @override
  String get stopping => 'กำลังหยุด…';

  @override
  String get readyToMirror => 'พร้อมสะท้อน';

  @override
  String get beforeYouStart => 'ก่อนเริ่ม';

  @override
  String get phoneAndTvAre => 'โทรศัพท์และทีวีอยู่ใน Wi-Fi เดียวกัน';

  @override
  String get noVpnIsConnected => 'ไม่มี VPN เชื่อมต่ออยู่บนโทรศัพท์ของคุณ';

  @override
  String get tvIsOnWith => 'ทีวีเปิดอยู่และเปิดใช้การสะท้อนหน้าจอ';

  @override
  String get phoneIsCloseTo => 'โทรศัพท์อยู่ใกล้ทีวี';

  @override
  String get stopMirroring => 'หยุดการสะท้อน';

  @override
  String get startMirroring2 => 'เริ่มการสะท้อน';

  @override
  String get stop => 'หยุด';

  @override
  String get start => 'เริ่ม';

  @override
  String get duration => 'ระยะเวลา';

  @override
  String get adIsLoading => 'กำลังโหลดโฆษณา';

  @override
  String get ad => 'โฆษณา';

  @override
  String get mirrorYourScreenTo => 'สะท้อนหน้าจอของคุณไปยังทีวีทุกเครื่อง';

  @override
  String get showYourPhoneOnThe =>
      'แสดงโทรศัพท์บนจอใหญ่ด้วยการแตะครั้งเดียว ไม่ต้องใช้สาย ไม่ยุ่งยาก';

  @override
  String get shareMemoriesWithThe =>
      'แบ่งปันความทรงจำกับทุกคนในห้องและควบคุมจากโทรศัพท์ของคุณ';

  @override
  String get castFromWebApps => 'แคสต์จากเว็บและแอป';

  @override
  String get sendVideosFromYoutube =>
      'ส่งวิดีโอจาก YouTube, Facebook และทุกเว็บไซต์ไปที่ทีวีของคุณโดยตรง';

  @override
  String pageOf(Object value, Object length) {
    return 'หน้า $value จาก $length';
  }

  @override
  String get getStarted => 'เริ่มต้นใช้งาน';

  @override
  String get localNetwork => 'เครือข่ายภายใน';

  @override
  String get findTvsAndStreaming =>
      'ค้นหาทีวีและอุปกรณ์สตรีมมิงใน Wi-Fi ของคุณ';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get showCastingControlsWhile => 'แสดงตัวควบคุมการแคสต์ขณะใช้แอปอื่น';

  @override
  String get photosVideosMusic => 'รูปภาพ วิดีโอ และเพลง';

  @override
  String get pickWhatYouWantTo =>
      'เลือกสิ่งที่ต้องการแคสต์จากแกลเลอรีและคลังของคุณ';

  @override
  String get screenCapture => 'การจับภาพหน้าจอ';

  @override
  String get mirrorYourScreenYoull => 'สะท้อนหน้าจอของคุณ คุณจะยืนยันทุกเซสชัน';

  @override
  String get webVideo => 'วิดีโอเว็บ';

  @override
  String get link => 'ลิงก์';

  @override
  String get screenMirroring2 => 'การสะท้อนหน้าจอ';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'กำลังแคสต์ $title เปิดรีโมท';
  }

  @override
  String castingTo2(Object value) {
    return 'กำลังแคสต์ไปที่ $value';
  }

  @override
  String get nowCasting => 'กำลังแคสต์';

  @override
  String get nothingIsCasting => 'ไม่มีอะไรกำลังแคสต์';

  @override
  String get pickAPhotoVideo =>
      'เลือกรูปภาพ วิดีโอ เพลง หรือวิดีโอเว็บเพื่อส่งไปที่ทีวีของคุณ';

  @override
  String get backToHome => 'กลับไปหน้าแรก';

  @override
  String slide2(Object formatDuration) {
    return 'สไลด์ $formatDuration';
  }

  @override
  String get back10Seconds => 'ย้อนกลับ 10 วินาที';

  @override
  String get forward10Seconds => 'ข้ามไปข้างหน้า 10 วินาที';

  @override
  String get tvVolume => 'เสียงทีวี';

  @override
  String tvVolumePercent(Object round) {
    return 'เสียงทีวี $round เปอร์เซ็นต์';
  }

  @override
  String get upNext => 'ถัดไป';

  @override
  String get addPhotos => 'เพิ่มรูปภาพ';

  @override
  String get addVideos => 'เพิ่มวิดีโอ';

  @override
  String get nothingElseInThe => 'ไม่มีอะไรเหลือในคิว';

  @override
  String play2(Object title) {
    return 'เล่น $title';
  }

  @override
  String get unknownDevice => 'อุปกรณ์ที่ไม่รู้จัก';

  @override
  String get perWeek => 'ต่อสัปดาห์';

  @override
  String get perYear => 'ต่อปี';

  @override
  String get payOnce => 'จ่ายครั้งเดียว';

  @override
  String get wirelessScreenMirroring => 'การสะท้อนหน้าจอแบบไร้สาย';

  @override
  String get castVideosPhotosMusic => 'แคสต์วิดีโอ รูปภาพ และเพลง';

  @override
  String get fullTvRemoteControl => 'ควบคุมทีวีด้วยรีโมทแบบเต็มรูปแบบ';

  @override
  String get worksWithAllMajor => 'ใช้งานได้กับทีวีหลักทุกยี่ห้อ';

  @override
  String get smoothLagFreeStreaming => 'สตรีมลื่นไหล ไม่กระตุก';

  @override
  String get noAds => 'ไม่มีโฆษณา';

  @override
  String get welcomeToCastflowPro => 'ยินดีต้อนรับสู่ CastFlow Pro!';

  @override
  String get purchaseCancelled => 'ยกเลิกการซื้อแล้ว';

  @override
  String get purchasePendingProUnlocks =>
      'การซื้อรอดำเนินการ Pro จะปลดล็อกเมื่อร้านค้ายืนยัน';

  @override
  String get purchaseFailedPleaseTry => 'การซื้อไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get theStoreIsntAvailable => 'ตอนนี้ร้านค้าไม่พร้อมใช้งาน';

  @override
  String get close => 'ปิด';

  @override
  String get goProWithCastflow => 'อัปเกรดเป็น PRO กับ CASTFLOW';

  @override
  String get unlockEveryFeature => 'ปลดล็อกทุกฟีเจอร์';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'ต่ออายุอัตโนมัติจนกว่าจะยกเลิก';

  @override
  String get oneTimePurchaseNo => 'ซื้อครั้งเดียว ไม่มีการสมัครสมาชิก';

  @override
  String get continueAction => 'ดำเนินการต่อ';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get termsAndConditions => 'ข้อกำหนดและเงื่อนไข';

  @override
  String get cancelAnytime => 'ยกเลิกได้ทุกเมื่อ';

  @override
  String get loadingPrice => 'กำลังโหลดราคา…';

  @override
  String get pricesUnavailableTapTo => 'ไม่มีราคา · แตะเพื่อลองอีกครั้ง';

  @override
  String get noPlansAvailableRight => 'ตอนนี้ไม่มีแพ็กเกจให้เลือก';

  @override
  String get weekly => 'รายสัปดาห์';

  @override
  String get yearly => 'รายปี';

  @override
  String get lifetime => 'ตลอดชีพ';

  @override
  String get bestValue => 'คุ้มที่สุด';

  @override
  String get disconnectFromTv => 'ยกเลิกการเชื่อมต่อกับทีวีไหม';

  @override
  String get thisStopsWhatIs =>
      'การดำเนินการนี้จะหยุดสิ่งที่กำลังเล่นหรือสะท้อนอยู่';

  @override
  String get useTouchpad => 'ใช้ทัชแพด';

  @override
  String get useDPad => 'ใช้ปุ่มทิศทาง';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'ตัวรับสัญญาณ $label ไม่รับคำสั่งรีโมท';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'บางปุ่มไม่พร้อมใช้งานบน $label';
  }

  @override
  String get idle => 'ว่าง';

  @override
  String get playing => 'กำลังเล่น';

  @override
  String get paused => 'หยุดชั่วคราว';

  @override
  String get noTvConnected => 'ไม่ได้เชื่อมต่อทีวี';

  @override
  String get mute2 => 'ปิดเสียง';

  @override
  String vol(Object volume) {
    return 'เสียง $volume';
  }

  @override
  String get noTvConnectedTap => 'ไม่ได้เชื่อมต่อทีวี แตะเพื่อเลือกอุปกรณ์';

  @override
  String get tapToChooseA => 'แตะเพื่อเลือกอุปกรณ์';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label2 ไม่รองรับ $label';
  }

  @override
  String get touchpadSwipeToMove => 'ทัชแพด ปัดเพื่อเลื่อน แตะเพื่อเลือก';

  @override
  String get swipeToMoveTap => 'ปัดเพื่อเลื่อน · แตะเพื่อเลือก';

  @override
  String get navigationIsntSupportedBy => 'ทีวีนี้ไม่รองรับการนำทาง';

  @override
  String get vol2 => 'เสียง';

  @override
  String get auto => 'อัตโนมัติ';

  @override
  String get automatic => 'อัตโนมัติ';

  @override
  String get googleCastFirst => 'Google Cast ก่อน';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP ก่อน';

  @override
  String get miracastFirst => 'Miracast ก่อน';

  @override
  String get tvOnly => 'ทีวีเท่านั้น';

  @override
  String get phoneAndTv => 'โทรศัพท์และทีวี';

  @override
  String get phoneOnly => 'โทรศัพท์เท่านั้น';

  @override
  String get touchpad => 'ทัชแพด';

  @override
  String get doMyPhoneAnd => 'โทรศัพท์และทีวีต้องใช้ Wi-Fi เดียวกันไหม';

  @override
  String get yesDiscoveryAndCasting =>
      'ใช่ การค้นหาและแคสต์อยู่ในเครือข่ายภายในของคุณ ทั้งสองต้องอยู่ใน Wi-Fi เดียวกัน (ชื่อความถี่ที่คล้ายกันอาจเป็นคนละเครือข่าย)';

  @override
  String get myRouterHasAp => 'เราเตอร์ของฉันมี “การแยก AP / ไคลเอนต์”';

  @override
  String get isolationBlocksDevicesFrom =>
      'การแยกทำให้อุปกรณ์มองไม่เห็นกัน ปิดในการตั้งค่าเราเตอร์ หรือใช้เครือข่ายที่ไม่ใช่เครือข่ายผู้เยี่ยมชม';

  @override
  String get findingYourTv => 'การค้นหาทีวีของคุณ';

  @override
  String get myTvDoesntAppear => 'ทีวีของฉันไม่แสดงในรายการ';

  @override
  String get turnOnCastingScreen =>
      'เปิดการแคสต์ / การสะท้อนหน้าจอบนทีวี ปลุกจากโหมดสแตนด์บาย แล้วแตะสแกนอีกครั้ง อนุญาตสิทธิ์เครือข่ายภายในหากถูกถาม';

  @override
  String get onlySomeDevicesShow => 'แสดงเพียงบางอุปกรณ์';

  @override
  String get olderTvsMayNeed =>
      'ทีวีรุ่นเก่าอาจต้องอัปเดตเฟิร์มแวร์ ทีวี Miracast จะปรากฏเมื่ออินพุต “การสะท้อนหน้าจอ” เปิดอยู่เท่านั้น';

  @override
  String get connectionFailsOrTimes => 'การเชื่อมต่อล้มเหลวหรือหมดเวลา';

  @override
  String get restartTheTvApp =>
      'รีสตาร์ตแอปทีวีหรือทีวี เข้าใกล้เราเตอร์ และยอมรับข้อความที่แสดงบนหน้าจอทีวี';

  @override
  String get itKeepsReconnectingTo => 'เชื่อมต่อกับทีวีเครื่องเก่าซ้ำๆ';

  @override
  String get turnOffAutoConnect =>
      'ปิด “เชื่อมต่อทีวีเครื่องล่าสุดอัตโนมัติ” ในการตั้งค่า → การแคสต์';

  @override
  String get mirroringIsLaggy => 'การสะท้อนกระตุก';

  @override
  String get chooseALowerQuality =>
      'เลือกคุณภาพต่ำลง (720p หรือ 480p) ปิดแอปที่ใช้ทรัพยากรมาก และใช้เครือข่าย Wi-Fi 5 GHz';

  @override
  String get thePictureIsRotated => 'ภาพหมุนหรือถูกตัด';

  @override
  String get toggleAutoRotateOn =>
      'สลับการหมุนอัตโนมัติที่หน้าจอการสะท้อนหน้าจอ';

  @override
  String get sound => 'เสียง';

  @override
  String get thereIsNoSound => 'ไม่มีเสียงบนทีวี';

  @override
  String get makeSureAudioIs =>
      'ตรวจสอบว่าเปิดเสียงในการสะท้อนหน้าจอ และดูที่การตั้งค่า → การแคสต์ → เอาต์พุตเสียง ตัวรับบางตัวไม่รองรับเสียงจากโทรศัพท์';

  @override
  String get tvRemote2 => 'รีโมททีวี';

  @override
  String get someRemoteButtonsAre => 'ปุ่มรีโมทบางปุ่มเป็นสีเทา';

  @override
  String get eachReceiverSupportsDifferent =>
      'ตัวรับแต่ละตัวรองรับคำสั่งต่างกัน Chromecast และ DLNA รองรับเฉพาะการเล่นและระดับเสียง Miracast ไม่มีช่องรีโมท';

  @override
  String get canCastflowTurnMy => 'CastFlow เปิดทีวีหรือเปลี่ยนอินพุตได้ไหม';

  @override
  String get onlyOnTvsThat =>
      'เฉพาะทีวีที่เปิดคำสั่งเหล่านั้นผ่านเครือข่าย ปุ่มที่ไม่รองรับจะถูกปิดใช้งานแทนที่จะแกล้งทำงาน';

  @override
  String get helpFaq => 'ความช่วยเหลือและคำถามที่พบบ่อย';

  @override
  String get stepByStepConnection => 'คู่มือการเชื่อมต่อทีละขั้นตอน';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'ไม่พบแอปอีเมล';

  @override
  String get enjoyingCastflow => 'ชอบ CastFlow ไหม';

  @override
  String get sorryToHearThat => 'เสียใจที่ได้ยินเช่นนั้น';

  @override
  String get thanksHowCanWe => 'ขอบคุณ! เราจะปรับปรุงได้อย่างไร';

  @override
  String get wereGladYouLike => 'ดีใจที่คุณชอบ!';

  @override
  String get youMadeOurDay => 'คุณทำให้วันของเรามีความสุข!';

  @override
  String get tapToExit => 'แตะเพื่อออก';

  @override
  String get selectARating => 'เลือกคะแนน';

  @override
  String get sendFeedback => 'ส่งความคิดเห็น';

  @override
  String get rateUs => 'ให้คะแนนเรา';

  @override
  String get rateYourExperienceBefore => 'ให้คะแนนประสบการณ์ของคุณก่อนไป';

  @override
  String get tapAStarTo => 'แตะดาวเพื่อให้คะแนน CastFlow';

  @override
  String get general => 'ทั่วไป';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'คุณภาพเริ่มต้น';

  @override
  String get autoConnectToLast => 'เชื่อมต่อทีวีเครื่องล่าสุดอัตโนมัติ';

  @override
  String get hapticFeedback => 'การตอบสนองแบบสัมผัส';

  @override
  String get clearCastingHistory => 'ล้างประวัติการแคสต์';

  @override
  String get clearCastingHistory2 => 'ล้างประวัติการแคสต์ไหม';

  @override
  String get onlyCastflowsListIs =>
      'ล้างเฉพาะรายการของ CastFlow สื่อในโทรศัพท์ของคุณจะไม่ถูกลบ';

  @override
  String get appearance => 'รูปลักษณ์';

  @override
  String get light => 'สว่าง';

  @override
  String get dark => 'มืด';

  @override
  String get system => 'ระบบ';

  @override
  String get aboutSupport => 'เกี่ยวกับและการสนับสนุน';

  @override
  String get rateApp => 'ให้คะแนนแอป';

  @override
  String get feedback => 'ความคิดเห็น';

  @override
  String get termsConditions => 'ข้อกำหนดและเงื่อนไข';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get castflowProIsActive => 'CastFlow Pro ใช้งานอยู่';

  @override
  String get upgradeToPremium => 'อัปเกรดเป็น Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'ขอบคุณที่สนับสนุน เพลิดเพลินกับการแคสต์แบบไม่มีโฆษณา';

  @override
  String get noAds1080pMirroring => 'ไม่มีโฆษณา สะท้อน 1080p และแคสต์ไม่จำกัด';

  @override
  String get upgrade => 'อัปเกรด';

  @override
  String get mirrorCastBeautifullySimple => 'สะท้อนและแคสต์ ง่ายและสวยงาม';

  @override
  String get thisActionMayContain => 'การดำเนินการนี้อาจมีโฆษณา';

  @override
  String get webCast => 'แคสต์เว็บ';

  @override
  String get castThisVideo => 'แคสต์วิดีโอนี้';

  @override
  String get searchOrTypeAWeb => 'ค้นหาหรือพิมพ์ที่อยู่เว็บ';

  @override
  String get removeBookmark => 'ลบบุ๊กมาร์ก';

  @override
  String get bookmark => 'บุ๊กมาร์ก';

  @override
  String get quickAccess => 'เข้าถึงด่วน';

  @override
  String open2(Object title) {
    return 'เปิด $title';
  }

  @override
  String get bookmarks => 'บุ๊กมาร์ก';

  @override
  String get noBookmarks => 'ไม่มีบุ๊กมาร์ก';

  @override
  String get tapTheBookmarkIcon =>
      'แตะไอคอนบุ๊กมาร์กในแถบที่อยู่เพื่อบันทึกหน้า';

  @override
  String get noHistory => 'ไม่มีประวัติ';

  @override
  String get pagesYouVisitShow => 'หน้าที่คุณเข้าชมจะแสดงที่นี่';

  @override
  String get remove => 'ลบ';

  @override
  String resultOn(Object value, Object host) {
    return 'ผลลัพธ์ $value บน $host';
  }

  @override
  String get aSimulatedPageResult => 'ผลลัพธ์หน้าจำลอง';

  @override
  String get videosOnThisPage => 'วิดีโอในหน้านี้';

  @override
  String get pickOneToSend => 'เลือกหนึ่งรายการเพื่อส่งไปที่ทีวีของคุณ';

  @override
  String get onboardHotspotTitle => 'ไม่มี Wi-Fi? ใช้ฮอตสปอต';

  @override
  String get onboardHotspotBody =>
      'เปิดฮอตสปอตในโทรศัพท์แล้วเชื่อมต่อทีวี การแคสต์จะทำงานเหมือนใช้ Wi-Fi';

  @override
  String get stillCantFindTitle => 'ยังหาทีวีไม่เจอ?';

  @override
  String get stillCantFindBody => 'เชื่อมต่อทีวีกับฮอตสปอตของโทรศัพท์:';

  @override
  String get hotspotStep4 => 'แตะลองอีกครั้งแล้วเลือกทีวีจากรายการ';

  @override
  String get castOverHotspot => 'ไม่มี Wi-Fi? แคสต์ผ่านฮอตสปอตของโทรศัพท์:';

  @override
  String get queue => 'คิว';

  @override
  String get addMusic => 'เพิ่มเพลง';

  @override
  String get connectWithWifi => 'เชื่อมต่อ Wi-Fi';

  @override
  String get continueWithHotspot => 'ดำเนินการต่อด้วยฮอตสปอต';

  @override
  String get noWifiAlertMessage =>
      'คุณกำลังใช้อินเทอร์เน็ตมือถือ เชื่อมต่อโทรศัพท์และทีวีกับ Wi-Fi เดียวกัน หรือเปิดฮอตสปอตของโทรศัพท์แล้วให้ทีวีเชื่อมต่อ';
}
