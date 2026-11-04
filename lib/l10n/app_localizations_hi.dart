// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get networkRequiredTitle => 'वाई-फ़ाई से कनेक्ट नहीं है';

  @override
  String get networkRequiredMessage =>
      'कास्ट करने के लिए आपका फ़ोन और टीवी एक ही वाई-फ़ाई नेटवर्क पर होने चाहिए।';

  @override
  String get openWifiSettings => 'वाई-फ़ाई सेटिंग खोलें';

  @override
  String get useMobileHotspot => 'मोबाइल हॉटस्पॉट इस्तेमाल करें';

  @override
  String get hotspotInstruction =>
      'अपने टीवी को मोबाइल हॉटस्पॉट से कनेक्ट करें।';

  @override
  String get hotspotStep1 => 'मोबाइल हॉटस्पॉट चालू करें';

  @override
  String get hotspotStep2 => 'अपना टीवी उससे कनेक्ट करें';

  @override
  String get hotspotStep3 => 'ऐप में वापस आएँ';

  @override
  String get openHotspotSettings => 'हॉटस्पॉट सेटिंग खोलें';

  @override
  String get hotspotAutoCheck => 'आपके लौटने पर हम अपने आप फिर जाँच करेंगे।';

  @override
  String get hotspotDetected => 'हॉटस्पॉट चालू है। आपका टीवी खोजा जा रहा है…';

  @override
  String get searchingDevices => 'आस-पास के डिवाइस खोजे जा रहे हैं...';

  @override
  String get waitingForTvOnHotspot =>
      'आपके टीवी के हॉटस्पॉट से जुड़ने का इंतज़ार है…';

  @override
  String get usingHotspot => 'आपका मोबाइल हॉटस्पॉट इस्तेमाल हो रहा है';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count डिवाइस मिले',
      one: '1 डिवाइस मिला',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get scanAgain => 'दोबारा स्कैन करें';

  @override
  String get isolationTitle => 'टीवी जवाब नहीं दे रहा';

  @override
  String get isolationHint =>
      'एक डिवाइस आपके हॉटस्पॉट से जुड़ा है पर जवाब नहीं दे रहा। हो सकता है आपका हॉटस्पॉट डिवाइसों के बीच ट्रैफ़िक रोक रहा हो (क्लाइंट आइसोलेशन)। इसे हॉटस्पॉट सेटिंग में बंद करें या वाई-फ़ाई नेटवर्क इस्तेमाल करें।';

  @override
  String get connecting => 'कनेक्ट हो रहा है…';

  @override
  String get connected => 'कनेक्टेड';

  @override
  String get connectionFailed => 'कनेक्ट नहीं हो सका';

  @override
  String get connectFailedHint =>
      'पक्का करें कि फ़ोन और टीवी एक ही नेटवर्क पर हैं, फिर दोबारा कोशिश करें।';

  @override
  String get hotspotConnectHint =>
      'हो सकता है आपका हॉटस्पॉट डिवाइसों के बीच ट्रैफ़िक रोक रहा हो। उसकी क्लाइंट आइसोलेशन सेटिंग जाँचें।';

  @override
  String get networkLostTitle => 'नेटवर्क कनेक्शन टूट गया';

  @override
  String get networkLostMessage =>
      'वाई-फ़ाई या हॉटस्पॉट से दोबारा जुड़ें, फिर अपने टीवी से दोबारा कनेक्ट करें।';

  @override
  String get reconnect => 'दोबारा कनेक्ट करें';

  @override
  String reconnectTo(String name) {
    return '$name से दोबारा कनेक्ट करें';
  }

  @override
  String get tapToReconnect => 'दोबारा कनेक्ट करने के लिए टैप करें';

  @override
  String get pairingRequired => 'पेयरिंग ज़रूरी है';

  @override
  String get pairingEnterCode => 'आपके टीवी पर दिख रहा कोड डालें।';

  @override
  String get pairingApproveOnTv =>
      'अपने टीवी को देखें और जारी रखने के लिए अनुमति दें पर टैप करें।';

  @override
  String get connect => 'कनेक्ट करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get pairingIncorrectCode => 'कोड ग़लत है। फिर कोशिश करें।';

  @override
  String get pairingTimedOut => 'पेयरिंग का समय समाप्त हो गया';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get pairingDeclined => 'टीवी ने कनेक्शन अस्वीकार कर दिया';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'बहुत ज़्यादा ग़लत कोड। $seconds सेकंड रुकें, फिर नया कोड माँगें।';
  }

  @override
  String get pairingCooldownOver => 'अब आप नया कोड माँग सकते हैं।';

  @override
  String get pairingRequestNewCode => 'नया कोड माँगें';

  @override
  String get pairingNetworkLost =>
      'पेयरिंग के दौरान नेटवर्क चला गया। वाई-फ़ाई से दोबारा जुड़ें और फिर कोशिश करें।';

  @override
  String get pairingFailed => 'टीवी के साथ पेयर नहीं हो सका।';

  @override
  String pairingCodeField(int length) {
    return 'पेयरिंग कोड, $length अक्षर';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'कोड बॉक्स $index/$total';
  }

  @override
  String get pairingEmptyBox => 'ख़ाली';

  @override
  String get pairingPaired => 'पेयर हो गया';

  @override
  String get forgetDevice => 'डिवाइस भूलें';

  @override
  String forgetDeviceMessage(String name) {
    return 'अगली बार $name को दोबारा पेयर करना होगा।';
  }

  @override
  String get forget => 'भूलें';

  @override
  String get castVideo => 'वीडियो कास्ट करें';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वीडियो मिले। वीडियो कास्ट करें',
      one: '1 वीडियो मिला। वीडियो कास्ट करें',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'इस पेज पर अभी कोई वीडियो नहीं मिला।';

  @override
  String get videoFound => 'वीडियो मिला';

  @override
  String get videoFoundMessage => 'इसे अपने टीवी पर चलाएँ।';

  @override
  String get castAction => 'कास्ट';

  @override
  String get dismiss => 'हटाएँ';

  @override
  String videosFound(int count) {
    return 'मिले वीडियो ($count)';
  }

  @override
  String get castToTv => 'टीवी पर कास्ट करें';

  @override
  String get protectedVideo => 'सुरक्षित है, कास्ट नहीं हो सकता';

  @override
  String get videoThumbnail => 'वीडियो थंबनेल';

  @override
  String castingTo(String device) {
    return '$device पर कास्ट हो रहा है';
  }

  @override
  String get stopCasting => 'कास्टिंग रोकें';

  @override
  String get play => 'चलाएँ';

  @override
  String get pause => 'रोकें';

  @override
  String get volume => 'वॉल्यूम';

  @override
  String get seekPosition => 'प्लेबैक की जगह';

  @override
  String get showControls => 'कंट्रोल दिखाएँ';

  @override
  String get hideControls => 'कंट्रोल छिपाएँ';

  @override
  String get formatUnsupportedTitle => 'फ़ॉर्मैट समर्थित नहीं है';

  @override
  String formatUnsupported(String device, String format) {
    return '$device $format वीडियो नहीं चला सकता। इस पेज का कोई दूसरा वीडियो आज़माएँ या स्क्रीन मिररिंग इस्तेमाल करें।';
  }

  @override
  String get videoExpired =>
      'इस वीडियो का लिंक समाप्त हो गया। पेज रीलोड करके फिर कोशिश करें।';

  @override
  String get refreshingVideo => 'नया वीडियो लिंक लिया जा रहा है…';

  @override
  String get browserBack => 'पीछे';

  @override
  String get browserForward => 'आगे';

  @override
  String get browserStartPage => 'स्टार्ट पेज';

  @override
  String get browserReload => 'रीलोड करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get home => 'होम';

  @override
  String get devices => 'डिवाइस';

  @override
  String get history => 'इतिहास';

  @override
  String get settings => 'सेटिंग';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'नमस्कार';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get couldntOpenTheLink => 'लिंक नहीं खुल सका।';

  @override
  String get castflowLogo => 'CastFlow लोगो';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get weCouldntLoadThis =>
      'यह अभी लोड नहीं हो सका। कृपया फिर कोशिश करें।';

  @override
  String get apps => 'ऐप्स';

  @override
  String open(Object name) {
    return '$name खोलें';
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
  String get up => 'ऊपर';

  @override
  String get down => 'नीचे';

  @override
  String get left => 'बाएँ';

  @override
  String get right => 'दाएँ';

  @override
  String get menu => 'मेन्यू';

  @override
  String get input => 'इनपुट';

  @override
  String get playPause => 'चलाएँ / रोकें';

  @override
  String get previous => 'पिछला';

  @override
  String get next => 'अगला';

  @override
  String get rewind => 'रिवाइंड';

  @override
  String get volumeUp => 'वॉल्यूम बढ़ाएँ';

  @override
  String get volumeDown => 'वॉल्यूम घटाएँ';

  @override
  String get mute => 'म्यूट';

  @override
  String connectedTo(Object name) {
    return '$name से कनेक्टेड';
  }

  @override
  String get chooseADevice => 'डिवाइस चुनें';

  @override
  String get connectionGuide => 'कनेक्शन गाइड';

  @override
  String get lookingForTvsOn => 'आपके वाई-फ़ाई पर टीवी खोजे जा रहे हैं';

  @override
  String foundSoFar(Object found) {
    return 'अब तक $found मिले';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found डिवाइस मिले';
  }

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String signalOf4(Object level) {
    return 'सिग्नल 4 में से $level';
  }

  @override
  String get connecting2 => 'कनेक्ट हो रहा है';

  @override
  String get theTvRemoteNeeds =>
      'टीवी रिमोट के लिए कनेक्टेड टीवी चाहिए। नीचे से एक चुनें।';

  @override
  String get connectToATv => 'जारी रखने के लिए किसी टीवी से कनेक्ट करें।';

  @override
  String get findingTvs => 'टीवी खोजे जा रहे हैं…';

  @override
  String get makeSureYourTv => 'पक्का करें कि आपका टीवी चालू है';

  @override
  String get notConnected => 'कनेक्ट नहीं है';

  @override
  String get tapToFindYour => 'अपना टीवी खोजने के लिए टैप करें';

  @override
  String get connectionFailed2 => 'कनेक्शन विफल रहा';

  @override
  String tapToManageDevices(Object label) {
    return '$label। डिवाइस मैनेज करने के लिए टैप करें';
  }

  @override
  String get joinTheSameWi => 'एक ही वाई-फ़ाई से जुड़ें';

  @override
  String get connectYourPhoneAnd =>
      'अपने फ़ोन और टीवी को एक ही वाई-फ़ाई नेटवर्क से कनेक्ट करें।';

  @override
  String get turnOnCastingOn => 'अपने टीवी पर कास्टिंग चालू करें';

  @override
  String get enableScreenMirroringMiracast =>
      'टीवी सेटिंग में स्क्रीन मिररिंग, मिराकास्ट या गूगल कास्ट चालू करें।';

  @override
  String get scanForDevices => 'डिवाइस स्कैन करें';

  @override
  String get openDevicesInCastflow =>
      'CastFlow में डिवाइस खोलें और कुछ सेकंड रुकें, आपका टीवी दिख जाएगा।';

  @override
  String get tapConnect => 'कनेक्ट पर टैप करें';

  @override
  String get acceptThePromptOn =>
      'अगर आपके टीवी पर कोई संदेश आए तो उसे स्वीकार करें। बस इतना ही!';

  @override
  String get howToConnect => 'कनेक्ट कैसे करें';

  @override
  String get fourQuickStepsTo => 'बड़ी स्क्रीन तक पहुँचने के चार आसान कदम।';

  @override
  String get gotIt => 'समझ गया';

  @override
  String step(Object number, Object title, Object body) {
    return 'कदम $number। $title। $body';
  }

  @override
  String get homeWiFi => 'घर का वाई-फ़ाई';

  @override
  String get router => 'राउटर';

  @override
  String get settingsConnection => 'सेटिंग › कनेक्शन';

  @override
  String get inputHdmi1 => 'इनपुट: HDMI 1';

  @override
  String get screenMirroring => 'स्क्रीन मिररिंग';

  @override
  String get networkHomeWiFi => 'नेटवर्क: घर का वाई-फ़ाई';

  @override
  String get livingRoomTv => 'लिविंग रूम का टीवी';

  @override
  String get allowCastflowToConnect => 'क्या CastFlow को कनेक्ट होने दें?';

  @override
  String get deny => 'मना करें';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get yourTv => 'आपका टीवी';

  @override
  String get findYourTv => 'अपना टीवी खोजें';

  @override
  String connectTo(Object name) {
    return '$name से कनेक्ट करें';
  }

  @override
  String connected2(Object label) {
    return 'कनेक्टेड · $label';
  }

  @override
  String get openTvRemote => 'टीवी रिमोट खोलें';

  @override
  String get sameWiFiNetwork => 'एक ही वाई-फ़ाई नेटवर्क';

  @override
  String get yourPhoneAndTv =>
      'आपका फ़ोन और टीवी एक ही वाई-फ़ाई से जुड़े होने चाहिए।';

  @override
  String get tvIsOnAnd => 'टीवी चालू और तैयार है';

  @override
  String get turnOnScreenMirroring =>
      'टीवी पर स्क्रीन मिररिंग, कास्ट या मिराकास्ट चालू करें।';

  @override
  String get noVpnOrGuest => 'कोई VPN या गेस्ट नेटवर्क नहीं';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN और गेस्ट / आइसोलेटेड वाई-फ़ाई डिवाइसों को एक-दूसरे से छिपा देते हैं।';

  @override
  String get localNetworkAccess => 'लोकल नेटवर्क एक्सेस';

  @override
  String get allowCastflowToFind =>
      'माँगे जाने पर CastFlow को अपने नेटवर्क पर डिवाइस खोजने दें।';

  @override
  String get noTvFound => 'कोई टीवी नहीं मिला';

  @override
  String get checkThatYourPhone =>
      'जाँचें कि फ़ोन और टीवी एक ही वाई-फ़ाई से जुड़े हैं, फिर दोबारा स्कैन करें।';

  @override
  String get noWiFiRouter =>
      'वाई-फ़ाई राउटर नहीं है? अपना हॉटस्पॉट इस्तेमाल करें';

  @override
  String searchingForTvsFound(Object length) {
    return 'टीवी खोजे जा रहे हैं। $length मिले।';
  }

  @override
  String tvsFound(Object length) {
    return '$length टीवी मिले';
  }

  @override
  String get connectToYourTv => 'अपने टीवी से कनेक्ट करें';

  @override
  String get connectYourPhoneAndTv =>
      'अपने फ़ोन और टीवी को एक ही वाई-फ़ाई नेटवर्क से कनेक्ट करें।';

  @override
  String get turnOnTheTv =>
      'टीवी चालू करें और उसका स्क्रीन मिररिंग / कास्ट इनपुट खोलें।';

  @override
  String get tapTheConnectionBar =>
      'अपना टीवी खोजने के लिए होम पर कनेक्शन बार पर टैप करें।';

  @override
  String get tapConnectAndAccept =>
      'कनेक्ट पर टैप करें और टीवी पर संदेश आए तो उसे स्वीकार करें।';

  @override
  String get mirrorYourScreen => 'अपनी स्क्रीन मिरर करें';

  @override
  String get connectToYourTvFirst => 'पहले अपने टीवी से कनेक्ट करें।';

  @override
  String get openScreenMirroringFrom => 'होम से स्क्रीन मिररिंग खोलें।';

  @override
  String get pickAQualityAnd => 'क्वालिटी चुनें और स्टार्ट पर टैप करें।';

  @override
  String get allowScreenCaptureWhen =>
      'Android पूछे तो स्क्रीन कैप्चर की अनुमति दें।';

  @override
  String get castPhotosVideosMusic => 'फ़ोटो, वीडियो और संगीत कास्ट करें';

  @override
  String get openPhotosVideosOr => 'होम पर फ़ोटो, वीडियो या संगीत खोलें।';

  @override
  String get pickWhatYouWant => 'जो दिखाना है वह चुनें।';

  @override
  String get itPlaysOnThe =>
      'यह टीवी पर चलता है; इसे फ़ोन या नोटिफ़िकेशन से कंट्रोल करें।';

  @override
  String get useTheTvRemote => 'टीवी रिमोट इस्तेमाल करें';

  @override
  String get openTvRemoteOn => 'होम पर टीवी रिमोट खोलें।';

  @override
  String get useTheDPad =>
      'चलने के लिए D-पैड या टचपैड पर स्वाइप करें, चुनने के लिए OK टैप करें।';

  @override
  String get buttonsATvDoesnt =>
      'जो बटन टीवी में काम नहीं करते वे धूसर दिखते हैं।';

  @override
  String get castFromTheWeb => 'वेब और ऐप्स से कास्ट करें';

  @override
  String get tapTheBrowserBar => 'होम पर ब्राउज़र बार या कोई ऐप टैप करें।';

  @override
  String get playAVideoOn => 'साइट पर कोई वीडियो चलाएँ।';

  @override
  String get tapCastThisVideo =>
      'टीवी पर भेजने के लिए “यह वीडियो कास्ट करें” पर टैप करें।';

  @override
  String get screenMirroringHelp => 'स्क्रीन मिररिंग मदद';

  @override
  String get connectYourPhoneTo => 'अपने फ़ोन को वाई-फ़ाई से कनेक्ट करें।';

  @override
  String get onTheTvOpen =>
      'टीवी पर सेटिंग → नेटवर्क खोलें और उसी वाई-फ़ाई से जुड़ें।';

  @override
  String get guestOrOfficeNetworks =>
      'गेस्ट या ऑफ़िस नेटवर्क अक्सर मिररिंग रोक देते हैं; घर का वाई-फ़ाई या फ़ोन का हॉटस्पॉट इस्तेमाल करें।';

  @override
  String get turnOffVpn => 'VPN बंद करें';

  @override
  String get aVpnHidesYour => 'VPN आपके टीवी को आपके फ़ोन से छिपा देता है।';

  @override
  String get pauseOrDisconnectYour =>
      'शुरू करने से पहले अपना VPN ऐप रोकें या डिस्कनेक्ट करें।';

  @override
  String get youCanTurnIt => 'काम ख़त्म होने पर आप इसे फिर चालू कर सकते हैं।';

  @override
  String get turnOnMirroringOn => 'टीवी पर मिररिंग चालू करें';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG और ज़्यादातर Android टीवी मिररिंग अपने आप स्वीकार कर लेते हैं।';

  @override
  String get otherTvsOpenInput =>
      'दूसरे टीवी: इनपुट / सोर्स खोलकर स्क्रीन मिररिंग या मिराकास्ट चुनें।';

  @override
  String get keepTheTvOn =>
      'फ़ोन के कनेक्ट होने तक टीवी को उसी स्क्रीन पर रखें।';

  @override
  String get tapStartAndPick => 'स्टार्ट टैप करें और अपना टीवी चुनें';

  @override
  String get tapStartOnThe => 'स्क्रीन मिररिंग स्क्रीन पर स्टार्ट टैप करें।';

  @override
  String get androidOpensSmartView =>
      'Android स्मार्ट व्यू / कास्ट खोलेगा। सूची में अपना टीवी टैप करें।';

  @override
  String get ifTheTvAsks =>
      'टीवी पूछे तो अनुमति दें चुनें या स्क्रीन पर दिख रहा PIN डालें।';

  @override
  String get youreMirroring => 'आप मिरर कर रहे हैं';

  @override
  String get everythingOnYourPhone =>
      'आपके फ़ोन की हर चीज़ अब टीवी पर दिख रही है।';

  @override
  String get turnThePhoneSideways =>
      'फ़ुल-स्क्रीन वीडियो और गेम के लिए फ़ोन को आड़ा घुमाएँ।';

  @override
  String get toStopTapStop =>
      'रोकने के लिए स्टॉप टैप करें या कास्ट नोटिफ़िकेशन इस्तेमाल करें।';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'बंद';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'बेडरूम का टीवी';

  @override
  String get officeDisplay => 'ऑफ़िस डिस्प्ले';

  @override
  String get clearHistory => 'इतिहास मिटाएँ?';

  @override
  String get thisRemovesEverythingYouve =>
      'इससे इस सूची से आपके सारे कास्ट हटा दिए जाएँगे।';

  @override
  String get clear => 'मिटाएँ';

  @override
  String get clearHistory2 => 'इतिहास मिटाएँ';

  @override
  String get noHistoryYet => 'अभी कोई इतिहास नहीं';

  @override
  String get everythingYouCastWill =>
      'आप जो कुछ कास्ट करेंगे वह यहाँ दिखेगा ताकि आप उसे दोबारा ढूँढ सकें।';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get earlier => 'पहले';

  @override
  String get swipeAnItemTo => 'किसी आइटम को हटाने के लिए स्वाइप करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String removed(Object title) {
    return '“$title” हटाया गया';
  }

  @override
  String get undo => 'वापस लाएँ';

  @override
  String get photos => 'फ़ोटो';

  @override
  String get albums => 'एल्बम';

  @override
  String get videos => 'वीडियो';

  @override
  String get gallery => 'गैलरी';

  @override
  String get music => 'संगीत';

  @override
  String get songs => 'गाने';

  @override
  String get media => 'मीडिया';

  @override
  String get browseTheWeb => 'वेब ब्राउज़ करें';

  @override
  String get goPro => 'प्रो बनें';

  @override
  String cast(Object title) {
    return '$title कास्ट करें';
  }

  @override
  String get screenMirroringStartMirroring =>
      'स्क्रीन मिररिंग। मिररिंग शुरू करें';

  @override
  String readyToMirrorTo(Object device) {
    return '$device पर मिरर करने के लिए तैयार';
  }

  @override
  String get showYourPhoneOn => 'अपने फ़ोन की स्क्रीन टीवी पर लाइव दिखाएँ।';

  @override
  String get startMirroring => 'मिररिंग शुरू करें';

  @override
  String get tvRemote => 'टीवी रिमोट';

  @override
  String get controlYourTv => 'अपना टीवी कंट्रोल करें';

  @override
  String get youtubeMore => 'YouTube और बहुत कुछ';

  @override
  String get openTheBrowser => 'ब्राउज़र खोलें';

  @override
  String get searchOrTypeA => 'वेबसाइट खोजें या लिखें';

  @override
  String get howToConnectOpen => 'कनेक्ट कैसे करें। विज़ुअल गाइड खोलें';

  @override
  String get visualGuideForEvery => 'हर फ़ीचर के लिए विज़ुअल गाइड';

  @override
  String get language => 'भाषा';

  @override
  String get done => 'हो गया';

  @override
  String get enterAValidHttp =>
      'मान्य http(s) या rtsp लिंक डालें, जैसे .m3u8 या .mp4 URL।';

  @override
  String get linkStream => 'लिंक स्ट्रीम';

  @override
  String get iptvLinkCast => 'IPTV / लिंक कास्ट';

  @override
  String get castALink => 'लिंक कास्ट करें';

  @override
  String get pasteADirectVideo =>
      'सीधा वीडियो, M3U8 या IPTV स्ट्रीम URL पेस्ट करें।';

  @override
  String get paste => 'पेस्ट करें';

  @override
  String get castLink => 'लिंक कास्ट करें';

  @override
  String get allowAccessToYour =>
      'मीडिया कास्ट करने के लिए उसकी एक्सेस की अनुमति दें। आप इसे सेटिंग में बदल सकते हैं।';

  @override
  String get video => 'वीडियो';

  @override
  String get castMusic => 'संगीत कास्ट करें';

  @override
  String get noMusicFound => 'कोई संगीत नहीं मिला';

  @override
  String get addSongsToYour => 'अपने फ़ोन में गाने जोड़ें, वे यहाँ दिखेंगे।';

  @override
  String get shuffle => 'शफ़ल';

  @override
  String get playAll => 'सब चलाएँ';

  @override
  String photo(Object formatShortDate) {
    return 'फ़ोटो · $formatShortDate';
  }

  @override
  String get photo2 => 'फ़ोटो';

  @override
  String get castPhotos => 'फ़ोटो कास्ट करें';

  @override
  String get select => 'चुनें';

  @override
  String get noPhotosHere => 'यहाँ कोई फ़ोटो नहीं';

  @override
  String get photosYouTakeOr =>
      'आप जो फ़ोटो लेते या सेव करते हैं वे इस एल्बम में दिखेंगे।';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count फ़ोटो';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return '$formatShortDate की फ़ोटो';
  }

  @override
  String get allPhotos => 'सभी फ़ोटो';

  @override
  String get slideshow => 'स्लाइडशो';

  @override
  String get interval => 'अंतराल';

  @override
  String get transition => 'ट्रांज़िशन';

  @override
  String get fade => 'फ़ेड';

  @override
  String get slide => 'स्लाइड';

  @override
  String get zoom => 'ज़ूम';

  @override
  String get startSlideshow => 'स्लाइडशो शुरू करें';

  @override
  String get castVideos => 'वीडियो कास्ट करें';

  @override
  String get noVideosYet => 'अभी कोई वीडियो नहीं';

  @override
  String get videosYouRecordOr =>
      'आप जो वीडियो रिकॉर्ड या डाउनलोड करेंगे वे यहाँ कास्ट के लिए तैयार दिखेंगे।';

  @override
  String video2(Object resolution) {
    return 'वीडियो · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration। कास्ट करें';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'स्क्रीन मिररिंग सत्र';

  @override
  String get mirroringDidntStartTap =>
      'मिररिंग शुरू नहीं हुई। स्टार्ट फिर टैप करें और सूची में अपना टीवी चुनें।';

  @override
  String get openSmartViewOr =>
      'मिरर करने के लिए फ़ोन की क्विक सेटिंग से स्मार्ट व्यू या कास्ट खोलें।';

  @override
  String get quality => 'क्वालिटी';

  @override
  String get adjustsToYourWi =>
      'सबसे स्मूद तस्वीर के लिए आपके वाई-फ़ाई के हिसाब से ढल जाती है।';

  @override
  String upToLowerIt(Object label) {
    return '$label तक। तस्वीर अटके तो इसे घटाएँ।';
  }

  @override
  String get stillNeedHelp => 'और मदद चाहिए?';

  @override
  String get startingScreenMirroring => 'स्क्रीन मिररिंग शुरू हो रही है…';

  @override
  String mirroringTo(Object value) {
    return '$value पर मिरर हो रहा है';
  }

  @override
  String get stopping => 'रुक रहा है…';

  @override
  String get readyToMirror => 'मिरर करने के लिए तैयार';

  @override
  String get beforeYouStart => 'शुरू करने से पहले';

  @override
  String get phoneAndTvAre => 'फ़ोन और टीवी एक ही वाई-फ़ाई पर हैं';

  @override
  String get noVpnIsConnected => 'आपके फ़ोन पर कोई VPN कनेक्ट नहीं है';

  @override
  String get tvIsOnWith => 'टीवी चालू है और स्क्रीन मिररिंग सक्षम है';

  @override
  String get phoneIsCloseTo => 'फ़ोन टीवी के पास है';

  @override
  String get stopMirroring => 'मिररिंग रोकें';

  @override
  String get startMirroring2 => 'मिररिंग शुरू करें';

  @override
  String get stop => 'रोकें';

  @override
  String get start => 'शुरू करें';

  @override
  String get duration => 'अवधि';

  @override
  String get adIsLoading => 'विज्ञापन लोड हो रहा है';

  @override
  String get ad => 'विज्ञापन';

  @override
  String get mirrorYourScreenTo => 'अपनी स्क्रीन किसी भी टीवी पर मिरर करें';

  @override
  String get showYourPhoneOnThe =>
      'एक टैप में अपना फ़ोन बड़ी स्क्रीन पर दिखाएँ: न केबल, न झंझट।';

  @override
  String get shareMemoriesWithThe =>
      'यादें पूरे कमरे के साथ बाँटें और कंट्रोल अपने फ़ोन से रखें।';

  @override
  String get castFromWebApps => 'वेब और ऐप्स से कास्ट करें';

  @override
  String get sendVideosFromYoutube =>
      'YouTube, Facebook और किसी भी वेबसाइट से वीडियो सीधे अपने टीवी पर भेजें।';

  @override
  String pageOf(Object value, Object length) {
    return 'पेज $value/$length';
  }

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get localNetwork => 'लोकल नेटवर्क';

  @override
  String get findTvsAndStreaming =>
      'अपने वाई-फ़ाई पर टीवी और स्ट्रीमिंग डिवाइस खोजें।';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get showCastingControlsWhile =>
      'दूसरे ऐप इस्तेमाल करते समय कास्टिंग कंट्रोल दिखाएँ।';

  @override
  String get photosVideosMusic => 'फ़ोटो, वीडियो और संगीत';

  @override
  String get pickWhatYouWantTo =>
      'अपनी गैलरी और लाइब्रेरी से जो कास्ट करना है वह चुनें।';

  @override
  String get screenCapture => 'स्क्रीन कैप्चर';

  @override
  String get mirrorYourScreenYoull =>
      'अपनी स्क्रीन मिरर करें। हर सत्र की आप पुष्टि करेंगे।';

  @override
  String get webVideo => 'वेब वीडियो';

  @override
  String get link => 'लिंक';

  @override
  String get screenMirroring2 => 'स्क्रीन मिररिंग';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'अभी $title कास्ट हो रहा है। रिमोट खोलें';
  }

  @override
  String castingTo2(Object value) {
    return '$value पर कास्ट हो रहा है';
  }

  @override
  String get nowCasting => 'अभी कास्ट हो रहा है';

  @override
  String get nothingIsCasting => 'कुछ भी कास्ट नहीं हो रहा';

  @override
  String get pickAPhotoVideo =>
      'टीवी पर भेजने के लिए कोई फ़ोटो, वीडियो, गाना या वेब वीडियो चुनें।';

  @override
  String get backToHome => 'होम पर वापस';

  @override
  String slide2(Object formatDuration) {
    return 'स्लाइड $formatDuration';
  }

  @override
  String get back10Seconds => '10 सेकंड पीछे';

  @override
  String get forward10Seconds => '10 सेकंड आगे';

  @override
  String get tvVolume => 'टीवी वॉल्यूम';

  @override
  String tvVolumePercent(Object round) {
    return 'टीवी वॉल्यूम $round प्रतिशत';
  }

  @override
  String get upNext => 'आगे';

  @override
  String get addPhotos => 'फ़ोटो जोड़ें';

  @override
  String get addVideos => 'वीडियो जोड़ें';

  @override
  String get nothingElseInThe => 'क्यू में और कुछ नहीं है।';

  @override
  String play2(Object title) {
    return '$title चलाएँ';
  }

  @override
  String get unknownDevice => 'अज्ञात डिवाइस';

  @override
  String get perWeek => 'प्रति सप्ताह';

  @override
  String get perYear => 'प्रति वर्ष';

  @override
  String get payOnce => 'एक बार भुगतान';

  @override
  String get wirelessScreenMirroring => 'वायरलेस स्क्रीन मिररिंग';

  @override
  String get castVideosPhotosMusic => 'वीडियो, फ़ोटो और संगीत कास्ट करें';

  @override
  String get fullTvRemoteControl => 'टीवी का पूरा रिमोट कंट्रोल';

  @override
  String get worksWithAllMajor => 'सभी प्रमुख टीवी के साथ काम करता है';

  @override
  String get smoothLagFreeStreaming => 'स्मूद, बिना लैग की स्ट्रीमिंग';

  @override
  String get noAds => 'कोई विज्ञापन नहीं';

  @override
  String get welcomeToCastflowPro => 'CastFlow Pro में आपका स्वागत है!';

  @override
  String get purchaseCancelled => 'ख़रीदारी रद्द की गई।';

  @override
  String get purchasePendingProUnlocks =>
      'ख़रीदारी लंबित है। स्टोर की पुष्टि होते ही Pro चालू हो जाएगा।';

  @override
  String get purchaseFailedPleaseTry =>
      'ख़रीदारी विफल रही। कृपया फिर कोशिश करें।';

  @override
  String get theStoreIsntAvailable => 'स्टोर अभी उपलब्ध नहीं है।';

  @override
  String get close => 'बंद करें';

  @override
  String get goProWithCastflow => 'CASTFLOW के साथ PRO बनें';

  @override
  String get unlockEveryFeature => 'हर फ़ीचर अनलॉक करें';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'रद्द करने तक अपने आप नवीनीकृत होता है।';

  @override
  String get oneTimePurchaseNo => 'एक बार की ख़रीद। कोई सदस्यता नहीं।';

  @override
  String get continueAction => 'जारी रखें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get cancelAnytime => 'कभी भी रद्द करें';

  @override
  String get loadingPrice => 'क़ीमत लोड हो रही है…';

  @override
  String get pricesUnavailableTapTo =>
      'क़ीमतें उपलब्ध नहीं · फिर कोशिश के लिए टैप करें';

  @override
  String get noPlansAvailableRight => 'अभी कोई प्लान उपलब्ध नहीं है।';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get yearly => 'वार्षिक';

  @override
  String get lifetime => 'आजीवन';

  @override
  String get bestValue => 'सबसे बढ़िया';

  @override
  String get disconnectFromTv => 'टीवी से डिस्कनेक्ट करें?';

  @override
  String get thisStopsWhatIs =>
      'इससे जो चल रहा है या मिरर हो रहा है वह रुक जाएगा।';

  @override
  String get useTouchpad => 'टचपैड इस्तेमाल करें';

  @override
  String get useDPad => 'D-पैड इस्तेमाल करें';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label रिसीवर रिमोट कमांड स्वीकार नहीं करते।';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return '$label पर कुछ बटन उपलब्ध नहीं हैं।';
  }

  @override
  String get idle => 'निष्क्रिय';

  @override
  String get playing => 'चल रहा है';

  @override
  String get paused => 'रुका हुआ';

  @override
  String get noTvConnected => 'कोई टीवी कनेक्ट नहीं है';

  @override
  String get mute2 => 'म्यूट';

  @override
  String vol(Object volume) {
    return 'वॉल्यूम $volume';
  }

  @override
  String get noTvConnectedTap =>
      'कोई टीवी कनेक्ट नहीं है। डिवाइस चुनने के लिए टैप करें';

  @override
  String get tapToChooseA => 'डिवाइस चुनने के लिए टैप करें';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label को $label2 समर्थित नहीं करता';
  }

  @override
  String get touchpadSwipeToMove =>
      'टचपैड। चलने के लिए स्वाइप करें, चुनने के लिए टैप करें।';

  @override
  String get swipeToMoveTap => 'चलने के लिए स्वाइप · चुनने के लिए टैप';

  @override
  String get navigationIsntSupportedBy => 'यह टीवी नेविगेशन समर्थित नहीं करता';

  @override
  String get vol2 => 'वॉल्यूम';

  @override
  String get auto => 'ऑटो';

  @override
  String get automatic => 'स्वचालित';

  @override
  String get googleCastFirst => 'पहले गूगल कास्ट';

  @override
  String get dlnaUpnpFirst => 'पहले DLNA / UPnP';

  @override
  String get miracastFirst => 'पहले मिराकास्ट';

  @override
  String get tvOnly => 'सिर्फ़ टीवी';

  @override
  String get phoneAndTv => 'फ़ोन और टीवी';

  @override
  String get phoneOnly => 'सिर्फ़ फ़ोन';

  @override
  String get touchpad => 'टचपैड';

  @override
  String get doMyPhoneAnd =>
      'क्या मेरे फ़ोन और टीवी का एक ही वाई-फ़ाई पर होना ज़रूरी है?';

  @override
  String get yesDiscoveryAndCasting =>
      'हाँ। खोज और कास्टिंग आपके लोकल नेटवर्क पर ही रहती है, इसलिए दोनों एक ही वाई-फ़ाई पर होने चाहिए (मिलते-जुलते बैंड नाम अलग नेटवर्क हो सकते हैं)।';

  @override
  String get myRouterHasAp => 'मेरे राउटर में “AP / क्लाइंट आइसोलेशन” है';

  @override
  String get isolationBlocksDevicesFrom =>
      'आइसोलेशन डिवाइसों को एक-दूसरे को देखने से रोकता है। इसे राउटर सेटिंग में बंद करें या गेस्ट के अलावा कोई दूसरा नेटवर्क इस्तेमाल करें।';

  @override
  String get findingYourTv => 'अपना टीवी खोजना';

  @override
  String get myTvDoesntAppear => 'मेरा टीवी सूची में नहीं दिखता';

  @override
  String get turnOnCastingScreen =>
      'टीवी पर कास्टिंग / स्क्रीन मिररिंग चालू करें, उसे स्टैंडबाय से जगाएँ, फिर दोबारा स्कैन पर टैप करें। पूछे जाने पर लोकल नेटवर्क की अनुमति दें।';

  @override
  String get onlySomeDevicesShow => 'सिर्फ़ कुछ डिवाइस दिखते हैं';

  @override
  String get olderTvsMayNeed =>
      'पुराने टीवी को फ़र्मवेयर अपडेट की ज़रूरत हो सकती है। मिराकास्ट टीवी तभी दिखते हैं जब उनका “स्क्रीन मिररिंग” इनपुट खुला हो।';

  @override
  String get connectionFailsOrTimes => 'कनेक्शन फ़ेल या टाइमआउट हो जाता है';

  @override
  String get restartTheTvApp =>
      'टीवी ऐप या टीवी को रीस्टार्ट करें, राउटर के पास जाएँ और टीवी स्क्रीन पर दिखा कोई भी संदेश स्वीकार करें।';

  @override
  String get itKeepsReconnectingTo => 'यह बार-बार पुराने टीवी से जुड़ जाता है';

  @override
  String get turnOffAutoConnect =>
      'सेटिंग → कास्टिंग में “आख़िरी टीवी से अपने आप कनेक्ट करें” बंद करें।';

  @override
  String get mirroringIsLaggy => 'मिररिंग में लैग आता है';

  @override
  String get chooseALowerQuality =>
      'कम क्वालिटी (720p या 480p) चुनें, भारी ऐप बंद करें और 5 GHz वाई-फ़ाई नेटवर्क इस्तेमाल करें।';

  @override
  String get thePictureIsRotated => 'तस्वीर घूमी हुई या कटी हुई है';

  @override
  String get toggleAutoRotateOn =>
      'स्क्रीन मिररिंग स्क्रीन पर ऑटो-रोटेट चालू/बंद करें।';

  @override
  String get sound => 'आवाज़';

  @override
  String get thereIsNoSound => 'टीवी पर आवाज़ नहीं आ रही';

  @override
  String get makeSureAudioIs =>
      'पक्का करें कि स्क्रीन मिररिंग में ऑडियो चालू है और सेटिंग → कास्टिंग → ऑडियो आउटपुट देखें। कुछ रिसीवर फ़ोन की आवाज़ समर्थित नहीं करते।';

  @override
  String get tvRemote2 => 'टीवी रिमोट';

  @override
  String get someRemoteButtonsAre => 'कुछ रिमोट बटन धूसर हैं';

  @override
  String get eachReceiverSupportsDifferent =>
      'हर रिसीवर अलग कमांड समर्थित करता है। Chromecast और DLNA सिर्फ़ प्लेबैक और वॉल्यूम समर्थित करते हैं; मिराकास्ट में रिमोट चैनल नहीं होता।';

  @override
  String get canCastflowTurnMy =>
      'क्या CastFlow मेरा टीवी चालू कर सकता है या इनपुट बदल सकता है?';

  @override
  String get onlyOnTvsThat =>
      'सिर्फ़ उन टीवी पर जो ये कमांड नेटवर्क पर देते हैं। असमर्थित बटन काम करने का दिखावा करने की जगह बंद रहते हैं।';

  @override
  String get helpFaq => 'मदद और FAQ';

  @override
  String get stepByStepConnection => 'कनेक्शन की चरण-दर-चरण गाइड';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'कोई ईमेल ऐप नहीं मिला।';

  @override
  String get enjoyingCastflow => 'CastFlow पसंद आ रहा है?';

  @override
  String get sorryToHearThat => 'यह सुनकर दुख हुआ';

  @override
  String get thanksHowCanWe => 'धन्यवाद! हम कैसे बेहतर हो सकते हैं?';

  @override
  String get wereGladYouLike => 'हमें ख़ुशी है कि आपको पसंद आया!';

  @override
  String get youMadeOurDay => 'आपने हमारा दिन बना दिया!';

  @override
  String get tapToExit => 'बाहर निकलने के लिए टैप करें';

  @override
  String get selectARating => 'रेटिंग चुनें';

  @override
  String get sendFeedback => 'फ़ीडबैक भेजें';

  @override
  String get rateUs => 'हमें रेट करें';

  @override
  String get rateYourExperienceBefore => 'जाने से पहले अपना अनुभव रेट करें।';

  @override
  String get tapAStarTo => 'CastFlow को रेट करने के लिए तारे पर टैप करें।';

  @override
  String get general => 'सामान्य';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'डिफ़ॉल्ट क्वालिटी';

  @override
  String get autoConnectToLast => 'आख़िरी टीवी से अपने आप कनेक्ट करें';

  @override
  String get hapticFeedback => 'हैप्टिक फ़ीडबैक';

  @override
  String get clearCastingHistory => 'कास्टिंग इतिहास मिटाएँ';

  @override
  String get clearCastingHistory2 => 'कास्टिंग इतिहास मिटाएँ?';

  @override
  String get onlyCastflowsListIs =>
      'सिर्फ़ CastFlow की सूची मिटती है। आपके फ़ोन का मीडिया कभी नहीं हटता।';

  @override
  String get appearance => 'दिखावट';

  @override
  String get light => 'लाइट';

  @override
  String get dark => 'डार्क';

  @override
  String get system => 'सिस्टम';

  @override
  String get aboutSupport => 'जानकारी और सहायता';

  @override
  String get rateApp => 'ऐप रेट करें';

  @override
  String get feedback => 'फ़ीडबैक';

  @override
  String get termsConditions => 'नियम और शर्तें';

  @override
  String get version => 'वर्शन';

  @override
  String get castflowProIsActive => 'CastFlow Pro चालू है';

  @override
  String get upgradeToPremium => 'प्रीमियम में अपग्रेड करें';

  @override
  String get castflowPremium => 'CastFlow प्रीमियम';

  @override
  String get thanksForYourSupport =>
      'आपके सहयोग के लिए धन्यवाद। बिना विज्ञापन के कास्टिंग का आनंद लें।';

  @override
  String get noAds1080pMirroring =>
      'कोई विज्ञापन नहीं, 1080p मिररिंग और असीमित कास्टिंग';

  @override
  String get upgrade => 'अपग्रेड करें';

  @override
  String get mirrorCastBeautifullySimple => 'मिरर और कास्ट, बेहद आसान';

  @override
  String get thisActionMayContain => 'इस क्रिया में विज्ञापन हो सकते हैं';

  @override
  String get webCast => 'वेब कास्ट';

  @override
  String get castThisVideo => 'यह वीडियो कास्ट करें';

  @override
  String get searchOrTypeAWeb => 'वेब पता खोजें या लिखें';

  @override
  String get removeBookmark => 'बुकमार्क हटाएँ';

  @override
  String get bookmark => 'बुकमार्क';

  @override
  String get quickAccess => 'क्विक एक्सेस';

  @override
  String open2(Object title) {
    return '$title खोलें';
  }

  @override
  String get bookmarks => 'बुकमार्क';

  @override
  String get noBookmarks => 'कोई बुकमार्क नहीं';

  @override
  String get tapTheBookmarkIcon =>
      'पेज सेव करने के लिए एड्रेस बार में बुकमार्क आइकन टैप करें।';

  @override
  String get noHistory => 'कोई इतिहास नहीं';

  @override
  String get pagesYouVisitShow => 'आपके देखे पेज यहाँ दिखेंगे।';

  @override
  String get remove => 'हटाएँ';

  @override
  String resultOn(Object value, Object host) {
    return '$host पर परिणाम $value';
  }

  @override
  String get aSimulatedPageResult => 'एक नकली पेज परिणाम';

  @override
  String get videosOnThisPage => 'इस पेज के वीडियो';

  @override
  String get pickOneToSend => 'टीवी पर भेजने के लिए एक चुनें।';

  @override
  String get onboardHotspotTitle => 'वाई-फ़ाई नहीं? हॉटस्पॉट का उपयोग करें';

  @override
  String get onboardHotspotBody =>
      'अपने फ़ोन का हॉटस्पॉट चालू करें और अपना टीवी उससे जोड़ें। कास्टिंग वाई-फ़ाई की तरह ही काम करती है।';

  @override
  String get stillCantFindTitle => 'अभी भी आपका टीवी नहीं मिला?';

  @override
  String get stillCantFindBody => 'अपने टीवी को फ़ोन के हॉटस्पॉट से जोड़ें:';

  @override
  String get hotspotStep4 =>
      'फिर से कोशिश करें पर टैप करें और सूची से अपना टीवी चुनें';

  @override
  String get castOverHotspot =>
      'वाई-फ़ाई नहीं? फ़ोन के हॉटस्पॉट से कास्ट करें:';

  @override
  String get queue => 'कतार';

  @override
  String get addMusic => 'संगीत जोड़ें';

  @override
  String get connectWithWifi => 'वाई-फ़ाई से कनेक्ट करें';

  @override
  String get continueWithHotspot => 'हॉटस्पॉट से जारी रखें';

  @override
  String get noWifiAlertMessage =>
      'आप मोबाइल डेटा पर हैं। अपने फ़ोन और टीवी को एक ही वाई-फ़ाई से जोड़ें, या फ़ोन का हॉटस्पॉट चालू करके टीवी से उससे जुड़ें।';
}
