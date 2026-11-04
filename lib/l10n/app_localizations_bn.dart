// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get networkRequiredTitle => 'ওয়াই-ফাইয়ের সাথে সংযুক্ত নেই';

  @override
  String get networkRequiredMessage =>
      'কাস্ট করতে আপনার ফোন ও টিভি একই ওয়াই-ফাই নেটওয়ার্কে থাকতে হবে।';

  @override
  String get openWifiSettings => 'ওয়াই-ফাই সেটিংস খুলুন';

  @override
  String get useMobileHotspot => 'মোবাইল হটস্পট ব্যবহার করুন';

  @override
  String get hotspotInstruction =>
      'আপনার টিভি ফোনের মোবাইল হটস্পটে সংযুক্ত করুন।';

  @override
  String get hotspotStep1 => 'মোবাইল হটস্পট চালু করুন';

  @override
  String get hotspotStep2 => 'আপনার টিভি সেটির সাথে সংযুক্ত করুন';

  @override
  String get hotspotStep3 => 'অ্যাপে ফিরে আসুন';

  @override
  String get openHotspotSettings => 'হটস্পট সেটিংস খুলুন';

  @override
  String get hotspotAutoCheck =>
      'আপনি ফিরে এলে আমরা আবার স্বয়ংক্রিয়ভাবে যাচাই করব।';

  @override
  String get hotspotDetected => 'হটস্পট চালু আছে। আপনার টিভি খোঁজা হচ্ছে…';

  @override
  String get searchingDevices => 'কাছাকাছি ডিভাইস খোঁজা হচ্ছে...';

  @override
  String get waitingForTvOnHotspot =>
      'আপনার টিভি হটস্পটে যোগ দেওয়ার অপেক্ষা করা হচ্ছে…';

  @override
  String get usingHotspot => 'আপনার মোবাইল হটস্পট ব্যবহার হচ্ছে';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ডিভাইস পাওয়া গেছে',
      one: '১টি ডিভাইস পাওয়া গেছে',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get scanAgain => 'আবার স্ক্যান করুন';

  @override
  String get isolationTitle => 'টিভি সাড়া দিচ্ছে না';

  @override
  String get isolationHint =>
      'একটি ডিভাইস আপনার হটস্পটে যোগ দিয়েছে কিন্তু সাড়া দিচ্ছে না। আপনার হটস্পট ডিভাইসগুলোর মধ্যে ট্রাফিক আটকে দিচ্ছে হতে পারে (ক্লায়েন্ট আইসোলেশন)। হটস্পট সেটিংসে সেটি বন্ধ করুন অথবা ওয়াই-ফাই নেটওয়ার্ক ব্যবহার করুন।';

  @override
  String get connecting => 'সংযুক্ত হচ্ছে…';

  @override
  String get connected => 'সংযুক্ত';

  @override
  String get connectionFailed => 'সংযোগ করা যায়নি';

  @override
  String get connectFailedHint =>
      'ফোন ও টিভি একই নেটওয়ার্কে আছে কি না নিশ্চিত করুন, তারপর আবার চেষ্টা করুন।';

  @override
  String get hotspotConnectHint =>
      'আপনার হটস্পট ডিভাইসগুলোর মধ্যে ট্রাফিক আটকে দিচ্ছে হতে পারে। ক্লায়েন্ট আইসোলেশন সেটিং দেখুন।';

  @override
  String get networkLostTitle => 'নেটওয়ার্ক সংযোগ বিচ্ছিন্ন হয়েছে';

  @override
  String get networkLostMessage =>
      'ওয়াই-ফাই বা হটস্পটে আবার সংযুক্ত হন, তারপর টিভিতে আবার সংযুক্ত হন।';

  @override
  String get reconnect => 'আবার সংযুক্ত করুন';

  @override
  String reconnectTo(String name) {
    return '$name-এ আবার সংযুক্ত করুন';
  }

  @override
  String get tapToReconnect => 'আবার সংযুক্ত করতে ট্যাপ করুন';

  @override
  String get pairingRequired => 'পেয়ারিং প্রয়োজন';

  @override
  String get pairingEnterCode => 'আপনার টিভিতে দেখানো কোডটি লিখুন।';

  @override
  String get pairingApproveOnTv =>
      'টিভির দিকে তাকিয়ে চালিয়ে যেতে অনুমতি দিন-এ ট্যাপ করুন।';

  @override
  String get connect => 'সংযুক্ত করুন';

  @override
  String get cancel => 'বাতিল';

  @override
  String get pairingIncorrectCode => 'কোড ভুল। আবার চেষ্টা করুন।';

  @override
  String get pairingTimedOut => 'পেয়ারিংয়ের সময় শেষ হয়েছে';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get pairingDeclined => 'টিভি সংযোগ প্রত্যাখ্যান করেছে';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'অনেক ভুল কোড। $seconds সেকেন্ড অপেক্ষা করুন, তারপর নতুন কোড চান।';
  }

  @override
  String get pairingCooldownOver => 'এখন আপনি নতুন কোড চাইতে পারেন।';

  @override
  String get pairingRequestNewCode => 'নতুন কোড চান';

  @override
  String get pairingNetworkLost =>
      'পেয়ারিংয়ের সময় নেটওয়ার্ক চলে গেছে। ওয়াই-ফাইয়ে আবার সংযুক্ত হয়ে চেষ্টা করুন।';

  @override
  String get pairingFailed => 'টিভির সাথে পেয়ার করা যায়নি।';

  @override
  String pairingCodeField(int length) {
    return 'পেয়ারিং কোড, $lengthটি অক্ষর';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'কোড বক্স $index/$total';
  }

  @override
  String get pairingEmptyBox => 'খালি';

  @override
  String get pairingPaired => 'পেয়ার হয়েছে';

  @override
  String get forgetDevice => 'ডিভাইস ভুলে যান';

  @override
  String forgetDeviceMessage(String name) {
    return 'পরের বার $name আবার পেয়ার করতে হবে।';
  }

  @override
  String get forget => 'ভুলে যান';

  @override
  String get castVideo => 'ভিডিও কাস্ট করুন';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ভিডিও পাওয়া গেছে। ভিডিও কাস্ট করুন',
      one: '১টি ভিডিও পাওয়া গেছে। ভিডিও কাস্ট করুন',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'এই পেজে এখনও কোনো ভিডিও পাওয়া যায়নি।';

  @override
  String get videoFound => 'ভিডিও পাওয়া গেছে';

  @override
  String get videoFoundMessage => 'আপনার টিভিতে চালান।';

  @override
  String get castAction => 'কাস্ট';

  @override
  String get dismiss => 'বন্ধ করুন';

  @override
  String videosFound(int count) {
    return 'পাওয়া ভিডিও ($count)';
  }

  @override
  String get castToTv => 'টিভিতে কাস্ট করুন';

  @override
  String get protectedVideo => 'সুরক্ষিত, কাস্ট করা যাবে না';

  @override
  String get videoThumbnail => 'ভিডিওর থাম্বনেইল';

  @override
  String castingTo(String device) {
    return '$device-এ কাস্ট হচ্ছে';
  }

  @override
  String get stopCasting => 'কাস্ট বন্ধ করুন';

  @override
  String get play => 'চালান';

  @override
  String get pause => 'বিরতি';

  @override
  String get volume => 'ভলিউম';

  @override
  String get seekPosition => 'প্লেব্যাকের অবস্থান';

  @override
  String get showControls => 'কন্ট্রোল দেখান';

  @override
  String get hideControls => 'কন্ট্রোল লুকান';

  @override
  String get formatUnsupportedTitle => 'ফরম্যাট সমর্থিত নয়';

  @override
  String formatUnsupported(String device, String format) {
    return '$device $format ভিডিও চালাতে পারে না। এই পেজের অন্য ভিডিও চেষ্টা করুন বা স্ক্রিন মিররিং ব্যবহার করুন।';
  }

  @override
  String get videoExpired =>
      'এই ভিডিও লিঙ্কের মেয়াদ শেষ। পেজ রিলোড করে আবার চেষ্টা করুন।';

  @override
  String get refreshingVideo => 'নতুন ভিডিও লিঙ্ক আনা হচ্ছে…';

  @override
  String get browserBack => 'পেছনে';

  @override
  String get browserForward => 'সামনে';

  @override
  String get browserStartPage => 'স্টার্ট পেজ';

  @override
  String get browserReload => 'রিলোড';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get home => 'হোম';

  @override
  String get devices => 'ডিভাইস';

  @override
  String get history => 'ইতিহাস';

  @override
  String get settings => 'সেটিংস';

  @override
  String get goodMorning => 'সুপ্রভাত';

  @override
  String get goodAfternoon => 'শুভ অপরাহ্ণ';

  @override
  String get goodEvening => 'শুভ সন্ধ্যা';

  @override
  String get couldntOpenTheLink => 'লিঙ্কটি খোলা যায়নি।';

  @override
  String get castflowLogo => 'CastFlow লোগো';

  @override
  String get somethingWentWrong => 'কিছু ভুল হয়েছে';

  @override
  String get weCouldntLoadThis =>
      'এখন এটি লোড করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get apps => 'অ্যাপ';

  @override
  String open(Object name) {
    return '$name খুলুন';
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
  String get up => 'উপরে';

  @override
  String get down => 'নিচে';

  @override
  String get left => 'বামে';

  @override
  String get right => 'ডানে';

  @override
  String get menu => 'মেনু';

  @override
  String get input => 'ইনপুট';

  @override
  String get playPause => 'চালান / বিরতি';

  @override
  String get previous => 'আগের';

  @override
  String get next => 'পরের';

  @override
  String get rewind => 'রিওয়াইন্ড';

  @override
  String get volumeUp => 'ভলিউম বাড়ান';

  @override
  String get volumeDown => 'ভলিউম কমান';

  @override
  String get mute => 'মিউট';

  @override
  String connectedTo(Object name) {
    return '$name-এ সংযুক্ত';
  }

  @override
  String get chooseADevice => 'একটি ডিভাইস বেছে নিন';

  @override
  String get connectionGuide => 'সংযোগ গাইড';

  @override
  String get lookingForTvsOn => 'আপনার ওয়াই-ফাইয়ে টিভি খোঁজা হচ্ছে';

  @override
  String foundSoFar(Object found) {
    return 'এ পর্যন্ত $foundটি পাওয়া গেছে';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$foundটি ডিভাইস পাওয়া গেছে';
  }

  @override
  String get disconnect => 'সংযোগ বিচ্ছিন্ন করুন';

  @override
  String signalOf4(Object level) {
    return 'সিগন্যাল ৪-এর মধ্যে $level';
  }

  @override
  String get connecting2 => 'সংযুক্ত হচ্ছে';

  @override
  String get theTvRemoteNeeds =>
      'টিভি রিমোটের জন্য সংযুক্ত টিভি দরকার। নিচ থেকে একটি বেছে নিন।';

  @override
  String get connectToATv => 'চালিয়ে যেতে একটি টিভিতে সংযুক্ত হন।';

  @override
  String get findingTvs => 'টিভি খোঁজা হচ্ছে…';

  @override
  String get makeSureYourTv => 'আপনার টিভি চালু আছে কি না নিশ্চিত করুন';

  @override
  String get notConnected => 'সংযুক্ত নয়';

  @override
  String get tapToFindYour => 'আপনার টিভি খুঁজতে ট্যাপ করুন';

  @override
  String get connectionFailed2 => 'সংযোগ ব্যর্থ হয়েছে';

  @override
  String tapToManageDevices(Object label) {
    return '$label। ডিভাইস পরিচালনা করতে ট্যাপ করুন';
  }

  @override
  String get joinTheSameWi => 'একই ওয়াই-ফাইয়ে যোগ দিন';

  @override
  String get connectYourPhoneAnd =>
      'আপনার ফোন ও টিভি একই ওয়াই-ফাই নেটওয়ার্কে সংযুক্ত করুন।';

  @override
  String get turnOnCastingOn => 'আপনার টিভিতে কাস্টিং চালু করুন';

  @override
  String get enableScreenMirroringMiracast =>
      'টিভি সেটিংসে স্ক্রিন মিররিং, মিরাকাস্ট বা গুগল কাস্ট চালু করুন।';

  @override
  String get scanForDevices => 'ডিভাইস স্ক্যান করুন';

  @override
  String get openDevicesInCastflow =>
      'CastFlow-এ ডিভাইস খুলুন এবং টিভি দেখা যাওয়া পর্যন্ত কয়েক সেকেন্ড অপেক্ষা করুন।';

  @override
  String get tapConnect => 'সংযুক্ত করুন-এ ট্যাপ করুন';

  @override
  String get acceptThePromptOn =>
      'টিভিতে কোনো বার্তা এলে গ্রহণ করুন। ব্যস, হয়ে গেল!';

  @override
  String get howToConnect => 'কীভাবে সংযুক্ত করবেন';

  @override
  String get fourQuickStepsTo => 'বড় পর্দায় যেতে চারটি দ্রুত ধাপ।';

  @override
  String get gotIt => 'বুঝেছি';

  @override
  String step(Object number, Object title, Object body) {
    return 'ধাপ $number। $title। $body';
  }

  @override
  String get homeWiFi => 'বাড়ির ওয়াই-ফাই';

  @override
  String get router => 'রাউটার';

  @override
  String get settingsConnection => 'সেটিংস › সংযোগ';

  @override
  String get inputHdmi1 => 'ইনপুট: HDMI 1';

  @override
  String get screenMirroring => 'স্ক্রিন মিররিং';

  @override
  String get networkHomeWiFi => 'নেটওয়ার্ক: বাড়ির ওয়াই-ফাই';

  @override
  String get livingRoomTv => 'বসার ঘরের টিভি';

  @override
  String get allowCastflowToConnect => 'CastFlow-কে সংযুক্ত হতে দেবেন?';

  @override
  String get deny => 'প্রত্যাখ্যান';

  @override
  String get allow => 'অনুমতি দিন';

  @override
  String get yourTv => 'আপনার টিভি';

  @override
  String get findYourTv => 'আপনার টিভি খুঁজুন';

  @override
  String connectTo(Object name) {
    return '$name-এ সংযুক্ত করুন';
  }

  @override
  String connected2(Object label) {
    return 'সংযুক্ত · $label';
  }

  @override
  String get openTvRemote => 'টিভি রিমোট খুলুন';

  @override
  String get sameWiFiNetwork => 'একই ওয়াই-ফাই নেটওয়ার্ক';

  @override
  String get yourPhoneAndTv =>
      'আপনার ফোন ও টিভি একই ওয়াই-ফাইয়ে সংযুক্ত থাকতে হবে।';

  @override
  String get tvIsOnAnd => 'টিভি চালু ও প্রস্তুত';

  @override
  String get turnOnScreenMirroring =>
      'টিভিতে স্ক্রিন মিররিং, কাস্ট বা মিরাকাস্ট চালু করুন।';

  @override
  String get noVpnOrGuest => 'কোনো VPN বা গেস্ট নেটওয়ার্ক নয়';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN এবং গেস্ট / আইসোলেটেড ওয়াই-ফাই ডিভাইসগুলোকে একে অপরের থেকে লুকিয়ে রাখে।';

  @override
  String get localNetworkAccess => 'লোকাল নেটওয়ার্ক অ্যাক্সেস';

  @override
  String get allowCastflowToFind =>
      'জিজ্ঞাসা করলে CastFlow-কে আপনার নেটওয়ার্কে ডিভাইস খুঁজতে দিন।';

  @override
  String get noTvFound => 'কোনো টিভি পাওয়া যায়নি';

  @override
  String get checkThatYourPhone =>
      'ফোন ও টিভি একই ওয়াই-ফাইয়ে আছে কি না দেখুন, তারপর আবার স্ক্যান করুন।';

  @override
  String get noWiFiRouter => 'ওয়াই-ফাই রাউটার নেই? আপনার হটস্পট ব্যবহার করুন';

  @override
  String searchingForTvsFound(Object length) {
    return 'টিভি খোঁজা হচ্ছে। $lengthটি পাওয়া গেছে।';
  }

  @override
  String tvsFound(Object length) {
    return '$lengthটি টিভি পাওয়া গেছে';
  }

  @override
  String get connectToYourTv => 'আপনার টিভিতে সংযুক্ত হন';

  @override
  String get connectYourPhoneAndTv =>
      'আপনার ফোন ও টিভি একই ওয়াই-ফাই নেটওয়ার্কে সংযুক্ত করুন।';

  @override
  String get turnOnTheTv =>
      'টিভি চালু করে এর স্ক্রিন মিররিং / কাস্ট ইনপুট খুলুন।';

  @override
  String get tapTheConnectionBar =>
      'আপনার টিভি খুঁজতে হোমের সংযোগ বারে ট্যাপ করুন।';

  @override
  String get tapConnectAndAccept =>
      'সংযুক্ত করুন-এ ট্যাপ করুন এবং টিভিতে বার্তা এলে গ্রহণ করুন।';

  @override
  String get mirrorYourScreen => 'আপনার স্ক্রিন মিরর করুন';

  @override
  String get connectToYourTvFirst => 'আগে আপনার টিভিতে সংযুক্ত হন।';

  @override
  String get openScreenMirroringFrom => 'হোম থেকে স্ক্রিন মিররিং খুলুন।';

  @override
  String get pickAQualityAnd => 'একটি মান বেছে স্টার্ট-এ ট্যাপ করুন।';

  @override
  String get allowScreenCaptureWhen =>
      'Android জিজ্ঞাসা করলে স্ক্রিন ক্যাপচারের অনুমতি দিন।';

  @override
  String get castPhotosVideosMusic => 'ছবি, ভিডিও ও গান কাস্ট করুন';

  @override
  String get openPhotosVideosOr => 'হোমে ছবি, ভিডিও বা গান খুলুন।';

  @override
  String get pickWhatYouWant => 'যা দেখাতে চান তা বেছে নিন।';

  @override
  String get itPlaysOnThe =>
      'এটি টিভিতে চলে; ফোন বা নোটিফিকেশন থেকে নিয়ন্ত্রণ করুন।';

  @override
  String get useTheTvRemote => 'টিভি রিমোট ব্যবহার করুন';

  @override
  String get openTvRemoteOn => 'হোমে টিভি রিমোট খুলুন।';

  @override
  String get useTheDPad =>
      'চলতে ডি-প্যাড ব্যবহার করুন বা টাচপ্যাডে সোয়াইপ করুন, বাছতে OK-তে ট্যাপ করুন।';

  @override
  String get buttonsATvDoesnt =>
      'টিভি যে বোতাম সমর্থন করে না সেগুলো ধূসর দেখায়।';

  @override
  String get castFromTheWeb => 'ওয়েব ও অ্যাপ থেকে কাস্ট করুন';

  @override
  String get tapTheBrowserBar => 'হোমে ব্রাউজার বার বা কোনো অ্যাপে ট্যাপ করুন।';

  @override
  String get playAVideoOn => 'সাইটে একটি ভিডিও চালান।';

  @override
  String get tapCastThisVideo =>
      'টিভিতে পাঠাতে “এই ভিডিও কাস্ট করুন”-এ ট্যাপ করুন।';

  @override
  String get screenMirroringHelp => 'স্ক্রিন মিররিং সহায়তা';

  @override
  String get connectYourPhoneTo => 'আপনার ফোন ওয়াই-ফাইয়ে সংযুক্ত করুন।';

  @override
  String get onTheTvOpen =>
      'টিভিতে সেটিংস → নেটওয়ার্ক খুলে একই ওয়াই-ফাইয়ে যোগ দিন।';

  @override
  String get guestOrOfficeNetworks =>
      'গেস্ট বা অফিস নেটওয়ার্ক প্রায়ই মিররিং আটকে দেয়; বাড়ির ওয়াই-ফাই বা ফোনের হটস্পট ব্যবহার করুন।';

  @override
  String get turnOffVpn => 'VPN বন্ধ করুন';

  @override
  String get aVpnHidesYour => 'VPN আপনার টিভিকে ফোন থেকে লুকিয়ে রাখে।';

  @override
  String get pauseOrDisconnectYour =>
      'শুরু করার আগে আপনার VPN অ্যাপ থামান বা সংযোগ বিচ্ছিন্ন করুন।';

  @override
  String get youCanTurnIt => 'কাজ শেষে আবার চালু করতে পারেন।';

  @override
  String get turnOnMirroringOn => 'টিভিতে মিররিং চালু করুন';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG এবং বেশিরভাগ Android টিভি স্বয়ংক্রিয়ভাবে মিররিং গ্রহণ করে।';

  @override
  String get otherTvsOpenInput =>
      'অন্য টিভি: ইনপুট / সোর্স খুলে স্ক্রিন মিররিং বা মিরাকাস্ট বেছে নিন।';

  @override
  String get keepTheTvOn => 'ফোন সংযুক্ত হওয়ার সময় টিভিকে ওই স্ক্রিনে রাখুন।';

  @override
  String get tapStartAndPick => 'স্টার্ট ট্যাপ করে আপনার টিভি বেছে নিন';

  @override
  String get tapStartOnThe => 'স্ক্রিন মিররিং স্ক্রিনে স্টার্ট-এ ট্যাপ করুন।';

  @override
  String get androidOpensSmartView =>
      'Android স্মার্ট ভিউ / কাস্ট খুলবে। তালিকায় আপনার টিভিতে ট্যাপ করুন।';

  @override
  String get ifTheTvAsks =>
      'টিভি জিজ্ঞাসা করলে অনুমতি দিন বেছে নিন বা স্ক্রিনে দেখানো PIN লিখুন।';

  @override
  String get youreMirroring => 'আপনি মিরর করছেন';

  @override
  String get everythingOnYourPhone =>
      'আপনার ফোনের সবকিছু এখন টিভিতে দেখা যাচ্ছে।';

  @override
  String get turnThePhoneSideways =>
      'ফুল-স্ক্রিন ভিডিও ও গেমের জন্য ফোন আড়াআড়ি ঘোরান।';

  @override
  String get toStopTapStop =>
      'বন্ধ করতে স্টপ ট্যাপ করুন বা কাস্ট নোটিফিকেশন ব্যবহার করুন।';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'বন্ধ';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'শোবার ঘরের টিভি';

  @override
  String get officeDisplay => 'অফিস ডিসপ্লে';

  @override
  String get clearHistory => 'ইতিহাস মুছবেন?';

  @override
  String get thisRemovesEverythingYouve =>
      'এটি এই তালিকা থেকে আপনার কাস্ট করা সবকিছু সরিয়ে দেবে।';

  @override
  String get clear => 'মুছুন';

  @override
  String get clearHistory2 => 'ইতিহাস মুছুন';

  @override
  String get noHistoryYet => 'এখনও কোনো ইতিহাস নেই';

  @override
  String get everythingYouCastWill =>
      'আপনি যা কাস্ট করবেন তা এখানে তালিকাভুক্ত হবে যাতে আবার সহজে খুঁজে পান।';

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get earlier => 'আগে';

  @override
  String get swipeAnItemTo => 'সরাতে কোনো আইটেম সোয়াইপ করুন';

  @override
  String get delete => 'মুছুন';

  @override
  String removed(Object title) {
    return '“$title” সরানো হয়েছে';
  }

  @override
  String get undo => 'পূর্বাবস্থায়';

  @override
  String get photos => 'ছবি';

  @override
  String get albums => 'অ্যালবাম';

  @override
  String get videos => 'ভিডিও';

  @override
  String get gallery => 'গ্যালারি';

  @override
  String get music => 'গান';

  @override
  String get songs => 'গানসমূহ';

  @override
  String get media => 'মিডিয়া';

  @override
  String get browseTheWeb => 'ওয়েব ব্রাউজ করুন';

  @override
  String get goPro => 'প্রো নিন';

  @override
  String cast(Object title) {
    return '$title কাস্ট করুন';
  }

  @override
  String get screenMirroringStartMirroring =>
      'স্ক্রিন মিররিং। মিররিং শুরু করুন';

  @override
  String readyToMirrorTo(Object device) {
    return '$device-এ মিরর করতে প্রস্তুত';
  }

  @override
  String get showYourPhoneOn => 'আপনার ফোন টিভিতে রিয়েল টাইমে দেখান।';

  @override
  String get startMirroring => 'মিররিং শুরু করুন';

  @override
  String get tvRemote => 'টিভি রিমোট';

  @override
  String get controlYourTv => 'আপনার টিভি নিয়ন্ত্রণ করুন';

  @override
  String get youtubeMore => 'YouTube ও আরও';

  @override
  String get openTheBrowser => 'ব্রাউজার খুলুন';

  @override
  String get searchOrTypeA => 'খুঁজুন বা ওয়েবসাইট লিখুন';

  @override
  String get howToConnectOpen => 'কীভাবে সংযুক্ত করবেন। ভিজ্যুয়াল গাইড খুলুন';

  @override
  String get visualGuideForEvery => 'প্রতিটি ফিচারের ভিজ্যুয়াল গাইড';

  @override
  String get language => 'ভাষা';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get enterAValidHttp =>
      'একটি বৈধ http(s) বা rtsp লিঙ্ক দিন, যেমন .m3u8 বা .mp4 URL।';

  @override
  String get linkStream => 'লিঙ্ক স্ট্রিম';

  @override
  String get iptvLinkCast => 'IPTV / লিঙ্ক কাস্ট';

  @override
  String get castALink => 'একটি লিঙ্ক কাস্ট করুন';

  @override
  String get pasteADirectVideo =>
      'সরাসরি ভিডিও, M3U8 বা IPTV স্ট্রিম URL পেস্ট করুন।';

  @override
  String get paste => 'পেস্ট';

  @override
  String get castLink => 'লিঙ্ক কাস্ট করুন';

  @override
  String get allowAccessToYour =>
      'মিডিয়া কাস্ট করতে অ্যাক্সেসের অনুমতি দিন। আপনি সেটিংসে এটি বদলাতে পারেন।';

  @override
  String get video => 'ভিডিও';

  @override
  String get castMusic => 'গান কাস্ট করুন';

  @override
  String get noMusicFound => 'কোনো গান পাওয়া যায়নি';

  @override
  String get addSongsToYour => 'ফোনে গান যোগ করুন, সেগুলো এখানে দেখা যাবে।';

  @override
  String get shuffle => 'শাফল';

  @override
  String get playAll => 'সব চালান';

  @override
  String photo(Object formatShortDate) {
    return 'ছবি · $formatShortDate';
  }

  @override
  String get photo2 => 'ছবি';

  @override
  String get castPhotos => 'ছবি কাস্ট করুন';

  @override
  String get select => 'নির্বাচন';

  @override
  String get noPhotosHere => 'এখানে কোনো ছবি নেই';

  @override
  String get photosYouTakeOr =>
      'আপনার তোলা বা সংরক্ষণ করা ছবি এই অ্যালবামে দেখা যাবে।';

  @override
  String photos2(Object name, Object count) {
    return '$name, $countটি ছবি';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return '$formatShortDate-এর ছবি';
  }

  @override
  String get allPhotos => 'সব ছবি';

  @override
  String get slideshow => 'স্লাইডশো';

  @override
  String get interval => 'বিরতি';

  @override
  String get transition => 'ট্রানজিশন';

  @override
  String get fade => 'ফেড';

  @override
  String get slide => 'স্লাইড';

  @override
  String get zoom => 'জুম';

  @override
  String get startSlideshow => 'স্লাইডশো শুরু করুন';

  @override
  String get castVideos => 'ভিডিও কাস্ট করুন';

  @override
  String get noVideosYet => 'এখনও কোনো ভিডিও নেই';

  @override
  String get videosYouRecordOr =>
      'আপনার রেকর্ড বা ডাউনলোড করা ভিডিও এখানে কাস্টের জন্য প্রস্তুত অবস্থায় দেখা যাবে।';

  @override
  String video2(Object resolution) {
    return 'ভিডিও · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration। কাস্ট করুন';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'স্ক্রিন মিররিং সেশন';

  @override
  String get mirroringDidntStartTap =>
      'মিররিং শুরু হয়নি। স্টার্ট আবার ট্যাপ করে তালিকা থেকে আপনার টিভি বেছে নিন।';

  @override
  String get openSmartViewOr =>
      'মিরর করতে ফোনের কুইক সেটিংস থেকে স্মার্ট ভিউ বা কাস্ট খুলুন।';

  @override
  String get quality => 'মান';

  @override
  String get adjustsToYourWi =>
      'সবচেয়ে মসৃণ ছবির জন্য আপনার ওয়াই-ফাই অনুযায়ী মানিয়ে নেয়।';

  @override
  String upToLowerIt(Object label) {
    return '$label পর্যন্ত। ছবি আটকে গেলে কমান।';
  }

  @override
  String get stillNeedHelp => 'আরও সাহায্য লাগবে?';

  @override
  String get startingScreenMirroring => 'স্ক্রিন মিররিং শুরু হচ্ছে…';

  @override
  String mirroringTo(Object value) {
    return '$value-এ মিরর হচ্ছে';
  }

  @override
  String get stopping => 'বন্ধ হচ্ছে…';

  @override
  String get readyToMirror => 'মিরর করতে প্রস্তুত';

  @override
  String get beforeYouStart => 'শুরু করার আগে';

  @override
  String get phoneAndTvAre => 'ফোন ও টিভি একই ওয়াই-ফাইয়ে আছে';

  @override
  String get noVpnIsConnected => 'আপনার ফোনে কোনো VPN সংযুক্ত নেই';

  @override
  String get tvIsOnWith => 'টিভি চালু এবং স্ক্রিন মিররিং সক্রিয়';

  @override
  String get phoneIsCloseTo => 'ফোন টিভির কাছে আছে';

  @override
  String get stopMirroring => 'মিররিং বন্ধ করুন';

  @override
  String get startMirroring2 => 'মিররিং শুরু করুন';

  @override
  String get stop => 'বন্ধ';

  @override
  String get start => 'শুরু';

  @override
  String get duration => 'সময়কাল';

  @override
  String get adIsLoading => 'বিজ্ঞাপন লোড হচ্ছে';

  @override
  String get ad => 'বিজ্ঞাপন';

  @override
  String get mirrorYourScreenTo => 'যেকোনো টিভিতে আপনার স্ক্রিন মিরর করুন';

  @override
  String get showYourPhoneOnThe =>
      'এক ট্যাপে ফোন বড় পর্দায় দেখান — তার নেই, ঝামেলা নেই।';

  @override
  String get shareMemoriesWithThe =>
      'পুরো ঘরের সাথে স্মৃতি ভাগ করুন এবং ফোন থেকে নিয়ন্ত্রণ রাখুন।';

  @override
  String get castFromWebApps => 'ওয়েব ও অ্যাপ থেকে কাস্ট করুন';

  @override
  String get sendVideosFromYoutube =>
      'YouTube, Facebook এবং যেকোনো ওয়েবসাইটের ভিডিও সরাসরি আপনার টিভিতে পাঠান।';

  @override
  String pageOf(Object value, Object length) {
    return 'পৃষ্ঠা $value/$length';
  }

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get localNetwork => 'লোকাল নেটওয়ার্ক';

  @override
  String get findTvsAndStreaming =>
      'আপনার ওয়াই-ফাইয়ে টিভি ও স্ট্রিমিং ডিভাইস খুঁজুন।';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get showCastingControlsWhile =>
      'অন্য অ্যাপ ব্যবহারের সময় কাস্টিং কন্ট্রোল দেখান।';

  @override
  String get photosVideosMusic => 'ছবি, ভিডিও ও গান';

  @override
  String get pickWhatYouWantTo =>
      'গ্যালারি ও লাইব্রেরি থেকে যা কাস্ট করতে চান তা বেছে নিন।';

  @override
  String get screenCapture => 'স্ক্রিন ক্যাপচার';

  @override
  String get mirrorYourScreenYoull =>
      'আপনার স্ক্রিন মিরর করুন। প্রতিটি সেশনে আপনি নিশ্চিত করবেন।';

  @override
  String get webVideo => 'ওয়েব ভিডিও';

  @override
  String get link => 'লিঙ্ক';

  @override
  String get screenMirroring2 => 'স্ক্রিন মিররিং';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'এখন $title কাস্ট হচ্ছে। রিমোট খুলুন';
  }

  @override
  String castingTo2(Object value) {
    return '$value-এ কাস্ট হচ্ছে';
  }

  @override
  String get nowCasting => 'এখন কাস্ট হচ্ছে';

  @override
  String get nothingIsCasting => 'কিছুই কাস্ট হচ্ছে না';

  @override
  String get pickAPhotoVideo =>
      'টিভিতে পাঠাতে একটি ছবি, ভিডিও, গান বা ওয়েব ভিডিও বেছে নিন।';

  @override
  String get backToHome => 'হোমে ফিরুন';

  @override
  String slide2(Object formatDuration) {
    return 'স্লাইড $formatDuration';
  }

  @override
  String get back10Seconds => '১০ সেকেন্ড পেছনে';

  @override
  String get forward10Seconds => '১০ সেকেন্ড এগিয়ে';

  @override
  String get tvVolume => 'টিভির ভলিউম';

  @override
  String tvVolumePercent(Object round) {
    return 'টিভির ভলিউম $round শতাংশ';
  }

  @override
  String get upNext => 'এরপর';

  @override
  String get addPhotos => 'ছবি যোগ করুন';

  @override
  String get addVideos => 'ভিডিও যোগ করুন';

  @override
  String get nothingElseInThe => 'সারিতে আর কিছু নেই।';

  @override
  String play2(Object title) {
    return '$title চালান';
  }

  @override
  String get unknownDevice => 'অজানা ডিভাইস';

  @override
  String get perWeek => 'প্রতি সপ্তাহে';

  @override
  String get perYear => 'প্রতি বছর';

  @override
  String get payOnce => 'একবার পরিশোধ';

  @override
  String get wirelessScreenMirroring => 'ওয়্যারলেস স্ক্রিন মিররিং';

  @override
  String get castVideosPhotosMusic => 'ভিডিও, ছবি ও গান কাস্ট করুন';

  @override
  String get fullTvRemoteControl => 'সম্পূর্ণ টিভি রিমোট নিয়ন্ত্রণ';

  @override
  String get worksWithAllMajor => 'সব প্রধান টিভির সাথে কাজ করে';

  @override
  String get smoothLagFreeStreaming => 'মসৃণ, ল্যাগমুক্ত স্ট্রিমিং';

  @override
  String get noAds => 'বিজ্ঞাপন নেই';

  @override
  String get welcomeToCastflowPro => 'CastFlow Pro-তে স্বাগতম!';

  @override
  String get purchaseCancelled => 'কেনা বাতিল হয়েছে।';

  @override
  String get purchasePendingProUnlocks =>
      'কেনা মুলতুবি আছে। স্টোর নিশ্চিত করলেই Pro চালু হবে।';

  @override
  String get purchaseFailedPleaseTry =>
      'কেনা ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get theStoreIsntAvailable => 'স্টোর এখন পাওয়া যাচ্ছে না।';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get goProWithCastflow => 'CASTFLOW-এর সাথে PRO নিন';

  @override
  String get unlockEveryFeature => 'সব ফিচার আনলক করুন';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'বাতিল না করা পর্যন্ত স্বয়ংক্রিয়ভাবে নবায়ন হয়।';

  @override
  String get oneTimePurchaseNo => 'এককালীন কেনা। কোনো সাবস্ক্রিপশন নয়।';

  @override
  String get continueAction => 'চালিয়ে যান';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get termsAndConditions => 'শর্তাবলি';

  @override
  String get cancelAnytime => 'যেকোনো সময় বাতিল করুন';

  @override
  String get loadingPrice => 'মূল্য লোড হচ্ছে…';

  @override
  String get pricesUnavailableTapTo =>
      'মূল্য পাওয়া যাচ্ছে না · আবার চেষ্টা করতে ট্যাপ করুন';

  @override
  String get noPlansAvailableRight => 'এখন কোনো প্ল্যান পাওয়া যাচ্ছে না।';

  @override
  String get weekly => 'সাপ্তাহিক';

  @override
  String get yearly => 'বার্ষিক';

  @override
  String get lifetime => 'আজীবন';

  @override
  String get bestValue => 'সেরা মূল্য';

  @override
  String get disconnectFromTv => 'টিভি থেকে সংযোগ বিচ্ছিন্ন করবেন?';

  @override
  String get thisStopsWhatIs => 'এটি এখন যা চলছে বা মিরর হচ্ছে তা বন্ধ করবে।';

  @override
  String get useTouchpad => 'টাচপ্যাড ব্যবহার করুন';

  @override
  String get useDPad => 'ডি-প্যাড ব্যবহার করুন';

  @override
  String receiversDontAcceptRemote(Object label) {
    return '$label রিসিভার রিমোট কমান্ড গ্রহণ করে না।';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return '$label-এ কিছু বোতাম উপলব্ধ নয়।';
  }

  @override
  String get idle => 'নিষ্ক্রিয়';

  @override
  String get playing => 'চলছে';

  @override
  String get paused => 'বিরতিতে';

  @override
  String get noTvConnected => 'কোনো টিভি সংযুক্ত নেই';

  @override
  String get mute2 => 'মিউট';

  @override
  String vol(Object volume) {
    return 'ভলিউম $volume';
  }

  @override
  String get noTvConnectedTap =>
      'কোনো টিভি সংযুক্ত নেই। ডিভাইস বাছতে ট্যাপ করুন';

  @override
  String get tapToChooseA => 'ডিভাইস বাছতে ট্যাপ করুন';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label2 $label সমর্থন করে না';
  }

  @override
  String get touchpadSwipeToMove =>
      'টাচপ্যাড। চলতে সোয়াইপ করুন, বাছতে ট্যাপ করুন।';

  @override
  String get swipeToMoveTap => 'চলতে সোয়াইপ · বাছতে ট্যাপ';

  @override
  String get navigationIsntSupportedBy => 'এই টিভি নেভিগেশন সমর্থন করে না';

  @override
  String get vol2 => 'ভলিউম';

  @override
  String get auto => 'অটো';

  @override
  String get automatic => 'স্বয়ংক্রিয়';

  @override
  String get googleCastFirst => 'আগে গুগল কাস্ট';

  @override
  String get dlnaUpnpFirst => 'আগে DLNA / UPnP';

  @override
  String get miracastFirst => 'আগে মিরাকাস্ট';

  @override
  String get tvOnly => 'শুধু টিভি';

  @override
  String get phoneAndTv => 'ফোন ও টিভি';

  @override
  String get phoneOnly => 'শুধু ফোন';

  @override
  String get touchpad => 'টাচপ্যাড';

  @override
  String get doMyPhoneAnd => 'আমার ফোন ও টিভির কি একই ওয়াই-ফাই লাগবে?';

  @override
  String get yesDiscoveryAndCasting =>
      'হ্যাঁ। খোঁজা ও কাস্টিং আপনার লোকাল নেটওয়ার্কেই থাকে, তাই দুটোই একই ওয়াই-ফাইয়ে থাকতে হবে (একই রকম ব্যান্ড নাম আলাদা নেটওয়ার্ক হতে পারে)।';

  @override
  String get myRouterHasAp => 'আমার রাউটারে “AP / ক্লায়েন্ট আইসোলেশন” আছে';

  @override
  String get isolationBlocksDevicesFrom =>
      'আইসোলেশন ডিভাইসগুলোকে একে অপরকে দেখতে দেয় না। রাউটার সেটিংসে এটি বন্ধ করুন বা গেস্ট নয় এমন নেটওয়ার্ক ব্যবহার করুন।';

  @override
  String get findingYourTv => 'আপনার টিভি খোঁজা';

  @override
  String get myTvDoesntAppear => 'আমার টিভি তালিকায় দেখা যাচ্ছে না';

  @override
  String get turnOnCastingScreen =>
      'টিভিতে কাস্টিং / স্ক্রিন মিররিং চালু করুন, স্ট্যান্ডবাই থেকে জাগান, তারপর আবার স্ক্যান-এ ট্যাপ করুন। জিজ্ঞাসা করলে লোকাল নেটওয়ার্কের অনুমতি দিন।';

  @override
  String get onlySomeDevicesShow => 'শুধু কিছু ডিভাইস দেখা যাচ্ছে';

  @override
  String get olderTvsMayNeed =>
      'পুরোনো টিভিতে ফার্মওয়্যার আপডেট লাগতে পারে। মিরাকাস্ট টিভি কেবল তাদের “স্ক্রিন মিররিং” ইনপুট খোলা থাকলে দেখা যায়।';

  @override
  String get connectionFailsOrTimes => 'সংযোগ ব্যর্থ হয় বা সময় শেষ হয়';

  @override
  String get restartTheTvApp =>
      'টিভি অ্যাপ বা টিভি রিস্টার্ট করুন, রাউটারের কাছে যান এবং টিভির পর্দায় আসা যেকোনো বার্তা গ্রহণ করুন।';

  @override
  String get itKeepsReconnectingTo => 'এটি বারবার পুরোনো টিভিতে সংযুক্ত হয়';

  @override
  String get turnOffAutoConnect =>
      'সেটিংস → কাস্টিং-এ “শেষ টিভিতে স্বয়ংক্রিয় সংযোগ” বন্ধ করুন।';

  @override
  String get mirroringIsLaggy => 'মিররিং আটকে আটকে চলে';

  @override
  String get chooseALowerQuality =>
      'কম মান (720p বা 480p) বেছে নিন, ভারী অ্যাপ বন্ধ করুন এবং 5 GHz ওয়াই-ফাই নেটওয়ার্ক ব্যবহার করুন।';

  @override
  String get thePictureIsRotated => 'ছবি ঘোরানো বা কাটা';

  @override
  String get toggleAutoRotateOn =>
      'স্ক্রিন মিররিং স্ক্রিনে অটো-রোটেট চালু/বন্ধ করুন।';

  @override
  String get sound => 'শব্দ';

  @override
  String get thereIsNoSound => 'টিভিতে কোনো শব্দ নেই';

  @override
  String get makeSureAudioIs =>
      'স্ক্রিন মিররিংয়ে অডিও চালু আছে কি না নিশ্চিত করুন এবং সেটিংস → কাস্টিং → অডিও আউটপুট দেখুন। কিছু রিসিভার ফোনের অডিও সমর্থন করে না।';

  @override
  String get tvRemote2 => 'টিভি রিমোট';

  @override
  String get someRemoteButtonsAre => 'কিছু রিমোট বোতাম ধূসর';

  @override
  String get eachReceiverSupportsDifferent =>
      'প্রতিটি রিসিভার আলাদা কমান্ড সমর্থন করে। Chromecast ও DLNA শুধু প্লেব্যাক ও ভলিউম সমর্থন করে; মিরাকাস্টে রিমোট চ্যানেল নেই।';

  @override
  String get canCastflowTurnMy =>
      'CastFlow কি আমার টিভি চালু করতে বা ইনপুট বদলাতে পারে?';

  @override
  String get onlyOnTvsThat =>
      'শুধু সেই টিভিতে যেগুলো নেটওয়ার্কে এই কমান্ড দেয়। অসমর্থিত বোতাম কাজ করার ভান না করে নিষ্ক্রিয় থাকে।';

  @override
  String get helpFaq => 'সহায়তা ও FAQ';

  @override
  String get stepByStepConnection => 'ধাপে ধাপে সংযোগ গাইড';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'কোনো ইমেইল অ্যাপ পাওয়া যায়নি।';

  @override
  String get enjoyingCastflow => 'CastFlow কেমন লাগছে?';

  @override
  String get sorryToHearThat => 'শুনে দুঃখিত';

  @override
  String get thanksHowCanWe => 'ধন্যবাদ! আমরা কীভাবে আরও ভালো হতে পারি?';

  @override
  String get wereGladYouLike => 'আপনার ভালো লেগেছে জেনে আমরা খুশি!';

  @override
  String get youMadeOurDay => 'আপনি আমাদের দিন সুন্দর করে দিলেন!';

  @override
  String get tapToExit => 'বের হতে ট্যাপ করুন';

  @override
  String get selectARating => 'একটি রেটিং বেছে নিন';

  @override
  String get sendFeedback => 'মতামত পাঠান';

  @override
  String get rateUs => 'আমাদের রেট করুন';

  @override
  String get rateYourExperienceBefore => 'যাওয়ার আগে আপনার অভিজ্ঞতা রেট করুন।';

  @override
  String get tapAStarTo => 'CastFlow রেট করতে একটি তারায় ট্যাপ করুন।';

  @override
  String get general => 'সাধারণ';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'ডিফল্ট মান';

  @override
  String get autoConnectToLast => 'শেষ টিভিতে স্বয়ংক্রিয় সংযোগ';

  @override
  String get hapticFeedback => 'হ্যাপটিক ফিডব্যাক';

  @override
  String get clearCastingHistory => 'কাস্টিং ইতিহাস মুছুন';

  @override
  String get clearCastingHistory2 => 'কাস্টিং ইতিহাস মুছবেন?';

  @override
  String get onlyCastflowsListIs =>
      'শুধু CastFlow-এর তালিকা মোছা হয়। আপনার ফোনের মিডিয়া কখনও মোছা হয় না।';

  @override
  String get appearance => 'চেহারা';

  @override
  String get light => 'হালকা';

  @override
  String get dark => 'গাঢ়';

  @override
  String get system => 'সিস্টেম';

  @override
  String get aboutSupport => 'সম্পর্কে ও সহায়তা';

  @override
  String get rateApp => 'অ্যাপ রেট করুন';

  @override
  String get feedback => 'মতামত';

  @override
  String get termsConditions => 'শর্তাবলি';

  @override
  String get version => 'সংস্করণ';

  @override
  String get castflowProIsActive => 'CastFlow Pro সক্রিয়';

  @override
  String get upgradeToPremium => 'প্রিমিয়ামে আপগ্রেড করুন';

  @override
  String get castflowPremium => 'CastFlow প্রিমিয়াম';

  @override
  String get thanksForYourSupport =>
      'আপনার সহযোগিতার জন্য ধন্যবাদ। বিজ্ঞাপনমুক্ত কাস্টিং উপভোগ করুন।';

  @override
  String get noAds1080pMirroring =>
      'বিজ্ঞাপন নেই, 1080p মিররিং ও সীমাহীন কাস্টিং';

  @override
  String get upgrade => 'আপগ্রেড';

  @override
  String get mirrorCastBeautifullySimple => 'মিরর ও কাস্ট, সুন্দর ও সহজ';

  @override
  String get thisActionMayContain => 'এই কাজে বিজ্ঞাপন থাকতে পারে';

  @override
  String get webCast => 'ওয়েব কাস্ট';

  @override
  String get castThisVideo => 'এই ভিডিও কাস্ট করুন';

  @override
  String get searchOrTypeAWeb => 'খুঁজুন বা ওয়েব ঠিকানা লিখুন';

  @override
  String get removeBookmark => 'বুকমার্ক সরান';

  @override
  String get bookmark => 'বুকমার্ক';

  @override
  String get quickAccess => 'দ্রুত অ্যাক্সেস';

  @override
  String open2(Object title) {
    return '$title খুলুন';
  }

  @override
  String get bookmarks => 'বুকমার্ক';

  @override
  String get noBookmarks => 'কোনো বুকমার্ক নেই';

  @override
  String get tapTheBookmarkIcon =>
      'পেজ সংরক্ষণ করতে ঠিকানা বারে বুকমার্ক আইকনে ট্যাপ করুন।';

  @override
  String get noHistory => 'কোনো ইতিহাস নেই';

  @override
  String get pagesYouVisitShow => 'আপনার দেখা পেজ এখানে দেখা যাবে।';

  @override
  String get remove => 'সরান';

  @override
  String resultOn(Object value, Object host) {
    return '$host-এ ফলাফল $value';
  }

  @override
  String get aSimulatedPageResult => 'একটি নকল পেজ ফলাফল';

  @override
  String get videosOnThisPage => 'এই পেজের ভিডিও';

  @override
  String get pickOneToSend => 'টিভিতে পাঠাতে একটি বেছে নিন।';

  @override
  String get onboardHotspotTitle => 'ওয়াই-ফাই নেই? হটস্পট ব্যবহার করুন';

  @override
  String get onboardHotspotBody =>
      'ফোনের হটস্পট চালু করে টিভি সংযুক্ত করুন। কাস্টিং ওয়াই-ফাইয়ের মতোই কাজ করে।';

  @override
  String get stillCantFindTitle => 'এখনও টিভি খুঁজে পাচ্ছেন না?';

  @override
  String get stillCantFindBody => 'টিভিকে ফোনের হটস্পটে সংযুক্ত করুন:';

  @override
  String get hotspotStep4 =>
      'আবার চেষ্টা করুন চাপুন এবং তালিকা থেকে টিভি বেছে নিন';

  @override
  String get castOverHotspot => 'ওয়াই-ফাই নেই? ফোনের হটস্পট দিয়ে কাস্ট করুন:';

  @override
  String get queue => 'সারি';

  @override
  String get addMusic => 'গান যোগ করুন';

  @override
  String get connectWithWifi => 'ওয়াই-ফাই দিয়ে সংযোগ করুন';

  @override
  String get continueWithHotspot => 'হটস্পট দিয়ে চালিয়ে যান';

  @override
  String get noWifiAlertMessage =>
      'আপনি মোবাইল ডেটা ব্যবহার করছেন। ফোন ও টিভি একই ওয়াই-ফাইতে যুক্ত করুন, অথবা ফোনের হটস্পট চালু করে টিভি থেকে তাতে যুক্ত হন।';
}
