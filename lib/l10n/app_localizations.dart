import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @networkRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Not connected to Wi-Fi'**
  String get networkRequiredTitle;

  /// No description provided for @networkRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your phone and TV must be on the same Wi-Fi network to cast.'**
  String get networkRequiredMessage;

  /// No description provided for @openWifiSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Wi-Fi Settings'**
  String get openWifiSettings;

  /// No description provided for @useMobileHotspot.
  ///
  /// In en, this message translates to:
  /// **'Use Mobile Hotspot'**
  String get useMobileHotspot;

  /// No description provided for @hotspotInstruction.
  ///
  /// In en, this message translates to:
  /// **'Connect your LCD/TV to your mobile hotspot.'**
  String get hotspotInstruction;

  /// No description provided for @hotspotStep1.
  ///
  /// In en, this message translates to:
  /// **'Turn on mobile hotspot'**
  String get hotspotStep1;

  /// No description provided for @hotspotStep2.
  ///
  /// In en, this message translates to:
  /// **'Connect your TV to it'**
  String get hotspotStep2;

  /// No description provided for @hotspotStep3.
  ///
  /// In en, this message translates to:
  /// **'Come back to the app'**
  String get hotspotStep3;

  /// No description provided for @openHotspotSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Hotspot Settings'**
  String get openHotspotSettings;

  /// No description provided for @hotspotAutoCheck.
  ///
  /// In en, this message translates to:
  /// **'We\'ll check again automatically when you come back.'**
  String get hotspotAutoCheck;

  /// No description provided for @hotspotDetected.
  ///
  /// In en, this message translates to:
  /// **'Hotspot is on. Looking for your TV…'**
  String get hotspotDetected;

  /// No description provided for @searchingDevices.
  ///
  /// In en, this message translates to:
  /// **'Searching for nearby devices...'**
  String get searchingDevices;

  /// No description provided for @waitingForTvOnHotspot.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your TV to join your hotspot…'**
  String get waitingForTvOnHotspot;

  /// No description provided for @usingHotspot.
  ///
  /// In en, this message translates to:
  /// **'Using your mobile hotspot'**
  String get usingHotspot;

  /// No description provided for @devicesFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 device found} other{{count} devices found}}'**
  String devicesFound(int count);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get scanAgain;

  /// No description provided for @isolationTitle.
  ///
  /// In en, this message translates to:
  /// **'TV not responding'**
  String get isolationTitle;

  /// No description provided for @isolationHint.
  ///
  /// In en, this message translates to:
  /// **'A device joined your hotspot but isn\'t responding. Your hotspot may be blocking device-to-device traffic (client isolation). Turn that off in hotspot settings, or use a Wi-Fi network.'**
  String get isolationHint;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect'**
  String get connectionFailed;

  /// No description provided for @connectFailedHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure your phone and TV are on the same network, then try again.'**
  String get connectFailedHint;

  /// No description provided for @hotspotConnectHint.
  ///
  /// In en, this message translates to:
  /// **'Your hotspot may be blocking device-to-device traffic. Check its client isolation setting.'**
  String get hotspotConnectHint;

  /// No description provided for @networkLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Network connection lost'**
  String get networkLostTitle;

  /// No description provided for @networkLostMessage.
  ///
  /// In en, this message translates to:
  /// **'Reconnect to Wi-Fi or your hotspot, then reconnect to your TV.'**
  String get networkLostMessage;

  /// No description provided for @reconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnect;

  /// No description provided for @reconnectTo.
  ///
  /// In en, this message translates to:
  /// **'Reconnect to {name}'**
  String reconnectTo(String name);

  /// No description provided for @tapToReconnect.
  ///
  /// In en, this message translates to:
  /// **'Tap to reconnect'**
  String get tapToReconnect;

  /// No description provided for @pairingRequired.
  ///
  /// In en, this message translates to:
  /// **'Pairing required'**
  String get pairingRequired;

  /// No description provided for @pairingEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code shown on your TV.'**
  String get pairingEnterCode;

  /// No description provided for @pairingApproveOnTv.
  ///
  /// In en, this message translates to:
  /// **'Look at your TV and tap Allow to continue.'**
  String get pairingApproveOnTv;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @pairingIncorrectCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. Try again.'**
  String get pairingIncorrectCode;

  /// No description provided for @pairingTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Pairing timed out'**
  String get pairingTimedOut;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @pairingDeclined.
  ///
  /// In en, this message translates to:
  /// **'The TV declined the connection'**
  String get pairingDeclined;

  /// No description provided for @pairingTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong codes. Wait {seconds} s, then request a new code.'**
  String pairingTooManyAttempts(int seconds);

  /// No description provided for @pairingCooldownOver.
  ///
  /// In en, this message translates to:
  /// **'You can request a new code now.'**
  String get pairingCooldownOver;

  /// No description provided for @pairingRequestNewCode.
  ///
  /// In en, this message translates to:
  /// **'Request new code'**
  String get pairingRequestNewCode;

  /// No description provided for @pairingNetworkLost.
  ///
  /// In en, this message translates to:
  /// **'The network was lost during pairing. Reconnect to Wi-Fi and try again.'**
  String get pairingNetworkLost;

  /// No description provided for @pairingFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t pair with the TV.'**
  String get pairingFailed;

  /// No description provided for @pairingCodeField.
  ///
  /// In en, this message translates to:
  /// **'Pairing code, {length} characters'**
  String pairingCodeField(int length);

  /// No description provided for @pairingCodeBox.
  ///
  /// In en, this message translates to:
  /// **'Code box {index} of {total}'**
  String pairingCodeBox(int index, int total);

  /// No description provided for @pairingEmptyBox.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get pairingEmptyBox;

  /// No description provided for @pairingPaired.
  ///
  /// In en, this message translates to:
  /// **'Paired'**
  String get pairingPaired;

  /// No description provided for @forgetDevice.
  ///
  /// In en, this message translates to:
  /// **'Forget device'**
  String get forgetDevice;

  /// No description provided for @forgetDeviceMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} will need to be paired again next time.'**
  String forgetDeviceMessage(String name);

  /// No description provided for @forget.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get forget;

  /// No description provided for @castVideo.
  ///
  /// In en, this message translates to:
  /// **'Cast video'**
  String get castVideo;

  /// No description provided for @castVideoCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 video found. Cast video} other{{count} videos found. Cast video}}'**
  String castVideoCount(int count);

  /// No description provided for @noVideoYet.
  ///
  /// In en, this message translates to:
  /// **'No video found on this page yet.'**
  String get noVideoYet;

  /// No description provided for @videoFound.
  ///
  /// In en, this message translates to:
  /// **'Video found'**
  String get videoFound;

  /// No description provided for @videoFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Play it on your TV.'**
  String get videoFoundMessage;

  /// No description provided for @castAction.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get castAction;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @videosFound.
  ///
  /// In en, this message translates to:
  /// **'Videos found ({count})'**
  String videosFound(int count);

  /// No description provided for @castToTv.
  ///
  /// In en, this message translates to:
  /// **'Cast to TV'**
  String get castToTv;

  /// No description provided for @protectedVideo.
  ///
  /// In en, this message translates to:
  /// **'Protected, can\'t be cast'**
  String get protectedVideo;

  /// No description provided for @videoThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Video thumbnail'**
  String get videoThumbnail;

  /// No description provided for @castingTo.
  ///
  /// In en, this message translates to:
  /// **'Casting to {device}'**
  String castingTo(String device);

  /// No description provided for @stopCasting.
  ///
  /// In en, this message translates to:
  /// **'Stop casting'**
  String get stopCasting;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @seekPosition.
  ///
  /// In en, this message translates to:
  /// **'Playback position'**
  String get seekPosition;

  /// No description provided for @showControls.
  ///
  /// In en, this message translates to:
  /// **'Show controls'**
  String get showControls;

  /// No description provided for @hideControls.
  ///
  /// In en, this message translates to:
  /// **'Hide controls'**
  String get hideControls;

  /// No description provided for @formatUnsupportedTitle.
  ///
  /// In en, this message translates to:
  /// **'Format not supported'**
  String get formatUnsupportedTitle;

  /// No description provided for @formatUnsupported.
  ///
  /// In en, this message translates to:
  /// **'{device} can\'t play {format} videos. Try another video on this page, or use screen mirroring.'**
  String formatUnsupported(String device, String format);

  /// No description provided for @videoExpired.
  ///
  /// In en, this message translates to:
  /// **'This video link expired. Reload the page and try again.'**
  String get videoExpired;

  /// No description provided for @refreshingVideo.
  ///
  /// In en, this message translates to:
  /// **'Getting a fresh video link…'**
  String get refreshingVideo;

  /// No description provided for @browserBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get browserBack;

  /// No description provided for @browserForward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get browserForward;

  /// No description provided for @browserStartPage.
  ///
  /// In en, this message translates to:
  /// **'Start page'**
  String get browserStartPage;

  /// No description provided for @browserReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get browserReload;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @couldntOpenTheLink.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open the link.'**
  String get couldntOpenTheLink;

  /// No description provided for @castflowLogo.
  ///
  /// In en, this message translates to:
  /// **'CastFlow logo'**
  String get castflowLogo;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @weCouldntLoadThis.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load this right now. Please try again.'**
  String get weCouldntLoadThis;

  /// No description provided for @apps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get apps;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open {name}'**
  String open(Object name);

  /// No description provided for @smartTv.
  ///
  /// In en, this message translates to:
  /// **'Smart TV'**
  String get smartTv;

  /// No description provided for @chromecast.
  ///
  /// In en, this message translates to:
  /// **'Chromecast'**
  String get chromecast;

  /// No description provided for @fireTv.
  ///
  /// In en, this message translates to:
  /// **'Fire TV'**
  String get fireTv;

  /// No description provided for @roku.
  ///
  /// In en, this message translates to:
  /// **'Roku'**
  String get roku;

  /// No description provided for @dlnaRenderer.
  ///
  /// In en, this message translates to:
  /// **'DLNA renderer'**
  String get dlnaRenderer;

  /// No description provided for @miracast.
  ///
  /// In en, this message translates to:
  /// **'Miracast'**
  String get miracast;

  /// No description provided for @up.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get up;

  /// No description provided for @down.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get down;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// No description provided for @right.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get right;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @input.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// No description provided for @playPause.
  ///
  /// In en, this message translates to:
  /// **'Play / Pause'**
  String get playPause;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @rewind.
  ///
  /// In en, this message translates to:
  /// **'Rewind'**
  String get rewind;

  /// No description provided for @volumeUp.
  ///
  /// In en, this message translates to:
  /// **'Volume up'**
  String get volumeUp;

  /// No description provided for @volumeDown.
  ///
  /// In en, this message translates to:
  /// **'Volume down'**
  String get volumeDown;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @connectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to {name}'**
  String connectedTo(Object name);

  /// No description provided for @chooseADevice.
  ///
  /// In en, this message translates to:
  /// **'Choose a device'**
  String get chooseADevice;

  /// No description provided for @connectionGuide.
  ///
  /// In en, this message translates to:
  /// **'Connection guide'**
  String get connectionGuide;

  /// No description provided for @lookingForTvsOn.
  ///
  /// In en, this message translates to:
  /// **'Looking for TVs on your Wi-Fi'**
  String get lookingForTvsOn;

  /// No description provided for @foundSoFar.
  ///
  /// In en, this message translates to:
  /// **'{found} found so far'**
  String foundSoFar(Object found);

  /// No description provided for @deviceFound.
  ///
  /// In en, this message translates to:
  /// **'{found} device{value} found'**
  String deviceFound(Object found, Object value);

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @signalOf4.
  ///
  /// In en, this message translates to:
  /// **'Signal {level} of 4'**
  String signalOf4(Object level);

  /// No description provided for @connecting2.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get connecting2;

  /// No description provided for @theTvRemoteNeeds.
  ///
  /// In en, this message translates to:
  /// **'The TV remote needs a connected TV. Pick one below.'**
  String get theTvRemoteNeeds;

  /// No description provided for @connectToATv.
  ///
  /// In en, this message translates to:
  /// **'Connect to a TV to continue.'**
  String get connectToATv;

  /// No description provided for @findingTvs.
  ///
  /// In en, this message translates to:
  /// **'Finding TVs…'**
  String get findingTvs;

  /// No description provided for @makeSureYourTv.
  ///
  /// In en, this message translates to:
  /// **'Make sure your TV is on'**
  String get makeSureYourTv;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @tapToFindYour.
  ///
  /// In en, this message translates to:
  /// **'Tap to find your TV'**
  String get tapToFindYour;

  /// No description provided for @connectionFailed2.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailed2;

  /// No description provided for @tapToManageDevices.
  ///
  /// In en, this message translates to:
  /// **'{label}. Tap to manage devices'**
  String tapToManageDevices(Object label);

  /// No description provided for @joinTheSameWi.
  ///
  /// In en, this message translates to:
  /// **'Join the same Wi-Fi'**
  String get joinTheSameWi;

  /// No description provided for @connectYourPhoneAnd.
  ///
  /// In en, this message translates to:
  /// **'Connect your phone and your TV to the same Wi-Fi network.'**
  String get connectYourPhoneAnd;

  /// No description provided for @turnOnCastingOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on casting on your TV'**
  String get turnOnCastingOn;

  /// No description provided for @enableScreenMirroringMiracast.
  ///
  /// In en, this message translates to:
  /// **'Enable Screen Mirroring, Miracast or Google Cast in the TV settings.'**
  String get enableScreenMirroringMiracast;

  /// No description provided for @scanForDevices.
  ///
  /// In en, this message translates to:
  /// **'Scan for devices'**
  String get scanForDevices;

  /// No description provided for @openDevicesInCastflow.
  ///
  /// In en, this message translates to:
  /// **'Open Devices in CastFlow and wait a few seconds for your TV to appear.'**
  String get openDevicesInCastflow;

  /// No description provided for @tapConnect.
  ///
  /// In en, this message translates to:
  /// **'Tap Connect'**
  String get tapConnect;

  /// No description provided for @acceptThePromptOn.
  ///
  /// In en, this message translates to:
  /// **'Accept the prompt on your TV if one appears. That’s it!'**
  String get acceptThePromptOn;

  /// No description provided for @howToConnect.
  ///
  /// In en, this message translates to:
  /// **'How to connect'**
  String get howToConnect;

  /// No description provided for @fourQuickStepsTo.
  ///
  /// In en, this message translates to:
  /// **'Four quick steps to get on the big screen.'**
  String get fourQuickStepsTo;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step {number}. {title}. {body}'**
  String step(Object number, Object title, Object body);

  /// No description provided for @homeWiFi.
  ///
  /// In en, this message translates to:
  /// **'Home Wi-Fi'**
  String get homeWiFi;

  /// No description provided for @router.
  ///
  /// In en, this message translates to:
  /// **'Router'**
  String get router;

  /// No description provided for @settingsConnection.
  ///
  /// In en, this message translates to:
  /// **'Settings › Connection'**
  String get settingsConnection;

  /// No description provided for @inputHdmi1.
  ///
  /// In en, this message translates to:
  /// **'Input: HDMI 1'**
  String get inputHdmi1;

  /// No description provided for @screenMirroring.
  ///
  /// In en, this message translates to:
  /// **'Screen Mirroring'**
  String get screenMirroring;

  /// No description provided for @networkHomeWiFi.
  ///
  /// In en, this message translates to:
  /// **'Network: Home Wi-Fi'**
  String get networkHomeWiFi;

  /// No description provided for @livingRoomTv.
  ///
  /// In en, this message translates to:
  /// **'Living Room TV'**
  String get livingRoomTv;

  /// No description provided for @allowCastflowToConnect.
  ///
  /// In en, this message translates to:
  /// **'Allow CastFlow to connect?'**
  String get allowCastflowToConnect;

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @yourTv.
  ///
  /// In en, this message translates to:
  /// **'Your TV'**
  String get yourTv;

  /// No description provided for @findYourTv.
  ///
  /// In en, this message translates to:
  /// **'Find your TV'**
  String get findYourTv;

  /// No description provided for @connectTo.
  ///
  /// In en, this message translates to:
  /// **'Connect to {name}'**
  String connectTo(Object name);

  /// No description provided for @connected2.
  ///
  /// In en, this message translates to:
  /// **'Connected · {label}'**
  String connected2(Object label);

  /// No description provided for @openTvRemote.
  ///
  /// In en, this message translates to:
  /// **'Open TV remote'**
  String get openTvRemote;

  /// No description provided for @sameWiFiNetwork.
  ///
  /// In en, this message translates to:
  /// **'Same Wi-Fi network'**
  String get sameWiFiNetwork;

  /// No description provided for @yourPhoneAndTv.
  ///
  /// In en, this message translates to:
  /// **'Your phone and TV must be connected to the same Wi-Fi.'**
  String get yourPhoneAndTv;

  /// No description provided for @tvIsOnAnd.
  ///
  /// In en, this message translates to:
  /// **'TV is on and ready'**
  String get tvIsOnAnd;

  /// No description provided for @turnOnScreenMirroring.
  ///
  /// In en, this message translates to:
  /// **'Turn on Screen Mirroring, Cast or Miracast on the TV.'**
  String get turnOnScreenMirroring;

  /// No description provided for @noVpnOrGuest.
  ///
  /// In en, this message translates to:
  /// **'No VPN or guest network'**
  String get noVpnOrGuest;

  /// No description provided for @vpnsAndGuestIsolated.
  ///
  /// In en, this message translates to:
  /// **'VPNs and guest / isolated Wi-Fi hide devices from each other.'**
  String get vpnsAndGuestIsolated;

  /// No description provided for @localNetworkAccess.
  ///
  /// In en, this message translates to:
  /// **'Local network access'**
  String get localNetworkAccess;

  /// No description provided for @allowCastflowToFind.
  ///
  /// In en, this message translates to:
  /// **'Allow CastFlow to find devices on your network when asked.'**
  String get allowCastflowToFind;

  /// No description provided for @noTvFound.
  ///
  /// In en, this message translates to:
  /// **'No TV found'**
  String get noTvFound;

  /// No description provided for @checkThatYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Check that your phone and TV are connected to the same Wi-Fi, then scan again.'**
  String get checkThatYourPhone;

  /// No description provided for @noWiFiRouter.
  ///
  /// In en, this message translates to:
  /// **'No Wi-Fi router? Use your hotspot'**
  String get noWiFiRouter;

  /// No description provided for @searchingForTvsFound.
  ///
  /// In en, this message translates to:
  /// **'Searching for TVs. {length} found.'**
  String searchingForTvsFound(Object length);

  /// No description provided for @tvsFound.
  ///
  /// In en, this message translates to:
  /// **'{length} TVs found'**
  String tvsFound(Object length);

  /// No description provided for @connectToYourTv.
  ///
  /// In en, this message translates to:
  /// **'Connect to your TV'**
  String get connectToYourTv;

  /// No description provided for @connectYourPhoneAndTv.
  ///
  /// In en, this message translates to:
  /// **'Connect your phone and TV to the same Wi-Fi network.'**
  String get connectYourPhoneAndTv;

  /// No description provided for @turnOnTheTv.
  ///
  /// In en, this message translates to:
  /// **'Turn on the TV and open its Screen Mirroring / Cast input.'**
  String get turnOnTheTv;

  /// No description provided for @tapTheConnectionBar.
  ///
  /// In en, this message translates to:
  /// **'Tap the connection bar on Home to find your TV.'**
  String get tapTheConnectionBar;

  /// No description provided for @tapConnectAndAccept.
  ///
  /// In en, this message translates to:
  /// **'Tap Connect and accept the prompt on the TV if one appears.'**
  String get tapConnectAndAccept;

  /// No description provided for @mirrorYourScreen.
  ///
  /// In en, this message translates to:
  /// **'Mirror your screen'**
  String get mirrorYourScreen;

  /// No description provided for @connectToYourTvFirst.
  ///
  /// In en, this message translates to:
  /// **'Connect to your TV first.'**
  String get connectToYourTvFirst;

  /// No description provided for @openScreenMirroringFrom.
  ///
  /// In en, this message translates to:
  /// **'Open Screen Mirroring from Home.'**
  String get openScreenMirroringFrom;

  /// No description provided for @pickAQualityAnd.
  ///
  /// In en, this message translates to:
  /// **'Pick a quality and tap Start.'**
  String get pickAQualityAnd;

  /// No description provided for @allowScreenCaptureWhen.
  ///
  /// In en, this message translates to:
  /// **'Allow screen capture when Android asks.'**
  String get allowScreenCaptureWhen;

  /// No description provided for @castPhotosVideosMusic.
  ///
  /// In en, this message translates to:
  /// **'Cast photos, videos & music'**
  String get castPhotosVideosMusic;

  /// No description provided for @openPhotosVideosOr.
  ///
  /// In en, this message translates to:
  /// **'Open Photos, Videos or Music on Home.'**
  String get openPhotosVideosOr;

  /// No description provided for @pickWhatYouWant.
  ///
  /// In en, this message translates to:
  /// **'Pick what you want to show.'**
  String get pickWhatYouWant;

  /// No description provided for @itPlaysOnThe.
  ///
  /// In en, this message translates to:
  /// **'It plays on the TV; control it from your phone or the notification.'**
  String get itPlaysOnThe;

  /// No description provided for @useTheTvRemote.
  ///
  /// In en, this message translates to:
  /// **'Use the TV remote'**
  String get useTheTvRemote;

  /// No description provided for @openTvRemoteOn.
  ///
  /// In en, this message translates to:
  /// **'Open TV Remote on Home.'**
  String get openTvRemoteOn;

  /// No description provided for @useTheDPad.
  ///
  /// In en, this message translates to:
  /// **'Use the D-pad or swipe on the touchpad to move, tap OK to select.'**
  String get useTheDPad;

  /// No description provided for @buttonsATvDoesnt.
  ///
  /// In en, this message translates to:
  /// **'Buttons a TV doesn’t support are greyed out.'**
  String get buttonsATvDoesnt;

  /// No description provided for @castFromTheWeb.
  ///
  /// In en, this message translates to:
  /// **'Cast from the web & apps'**
  String get castFromTheWeb;

  /// No description provided for @tapTheBrowserBar.
  ///
  /// In en, this message translates to:
  /// **'Tap the browser bar or an app on Home.'**
  String get tapTheBrowserBar;

  /// No description provided for @playAVideoOn.
  ///
  /// In en, this message translates to:
  /// **'Play a video on the site.'**
  String get playAVideoOn;

  /// No description provided for @tapCastThisVideo.
  ///
  /// In en, this message translates to:
  /// **'Tap “Cast this video” to send it to your TV.'**
  String get tapCastThisVideo;

  /// No description provided for @screenMirroringHelp.
  ///
  /// In en, this message translates to:
  /// **'Screen mirroring help'**
  String get screenMirroringHelp;

  /// No description provided for @connectYourPhoneTo.
  ///
  /// In en, this message translates to:
  /// **'Connect your phone to Wi-Fi.'**
  String get connectYourPhoneTo;

  /// No description provided for @onTheTvOpen.
  ///
  /// In en, this message translates to:
  /// **'On the TV, open Settings → Network and join the same Wi-Fi.'**
  String get onTheTvOpen;

  /// No description provided for @guestOrOfficeNetworks.
  ///
  /// In en, this message translates to:
  /// **'Guest or office networks often block mirroring; use your home Wi-Fi or your phone’s hotspot.'**
  String get guestOrOfficeNetworks;

  /// No description provided for @turnOffVpn.
  ///
  /// In en, this message translates to:
  /// **'Turn off VPN'**
  String get turnOffVpn;

  /// No description provided for @aVpnHidesYour.
  ///
  /// In en, this message translates to:
  /// **'A VPN hides your TV from your phone.'**
  String get aVpnHidesYour;

  /// No description provided for @pauseOrDisconnectYour.
  ///
  /// In en, this message translates to:
  /// **'Pause or disconnect your VPN app before you start.'**
  String get pauseOrDisconnectYour;

  /// No description provided for @youCanTurnIt.
  ///
  /// In en, this message translates to:
  /// **'You can turn it back on when you’re done.'**
  String get youCanTurnIt;

  /// No description provided for @turnOnMirroringOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on mirroring on the TV'**
  String get turnOnMirroringOn;

  /// No description provided for @samsungLgAndMost.
  ///
  /// In en, this message translates to:
  /// **'Samsung, LG and most Android TVs accept mirroring automatically.'**
  String get samsungLgAndMost;

  /// No description provided for @otherTvsOpenInput.
  ///
  /// In en, this message translates to:
  /// **'Other TVs: open Input / Source and pick Screen Mirroring or Miracast.'**
  String get otherTvsOpenInput;

  /// No description provided for @keepTheTvOn.
  ///
  /// In en, this message translates to:
  /// **'Keep the TV on that screen while your phone connects.'**
  String get keepTheTvOn;

  /// No description provided for @tapStartAndPick.
  ///
  /// In en, this message translates to:
  /// **'Tap Start and pick your TV'**
  String get tapStartAndPick;

  /// No description provided for @tapStartOnThe.
  ///
  /// In en, this message translates to:
  /// **'Tap Start on the Screen Mirroring screen.'**
  String get tapStartOnThe;

  /// No description provided for @androidOpensSmartView.
  ///
  /// In en, this message translates to:
  /// **'Android opens Smart View / Cast. Tap your TV in the list.'**
  String get androidOpensSmartView;

  /// No description provided for @ifTheTvAsks.
  ///
  /// In en, this message translates to:
  /// **'If the TV asks, choose Allow or enter the PIN shown on screen.'**
  String get ifTheTvAsks;

  /// No description provided for @youreMirroring.
  ///
  /// In en, this message translates to:
  /// **'You’re mirroring'**
  String get youreMirroring;

  /// No description provided for @everythingOnYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Everything on your phone now shows on the TV.'**
  String get everythingOnYourPhone;

  /// No description provided for @turnThePhoneSideways.
  ///
  /// In en, this message translates to:
  /// **'Turn the phone sideways for full-screen videos and games.'**
  String get turnThePhoneSideways;

  /// No description provided for @toStopTapStop.
  ///
  /// In en, this message translates to:
  /// **'To stop, tap Stop or use the cast notification.'**
  String get toStopTapStop;

  /// No description provided for @vpn.
  ///
  /// In en, this message translates to:
  /// **'VPN'**
  String get vpn;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @hdmi1.
  ///
  /// In en, this message translates to:
  /// **'HDMI 1'**
  String get hdmi1;

  /// No description provided for @hdmi2.
  ///
  /// In en, this message translates to:
  /// **'HDMI 2'**
  String get hdmi2;

  /// No description provided for @smartView.
  ///
  /// In en, this message translates to:
  /// **'Smart View'**
  String get smartView;

  /// No description provided for @bedroomTv.
  ///
  /// In en, this message translates to:
  /// **'Bedroom TV'**
  String get bedroomTv;

  /// No description provided for @officeDisplay.
  ///
  /// In en, this message translates to:
  /// **'Office display'**
  String get officeDisplay;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history?'**
  String get clearHistory;

  /// No description provided for @thisRemovesEverythingYouve.
  ///
  /// In en, this message translates to:
  /// **'This removes everything you’ve cast from this list.'**
  String get thisRemovesEverythingYouve;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearHistory2.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory2;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @everythingYouCastWill.
  ///
  /// In en, this message translates to:
  /// **'Everything you cast will be listed here so you can find it again.'**
  String get everythingYouCastWill;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @earlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get earlier;

  /// No description provided for @swipeAnItemTo.
  ///
  /// In en, this message translates to:
  /// **'Swipe an item to remove it'**
  String get swipeAnItemTo;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'Removed “{title}”'**
  String removed(Object title);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @browseTheWeb.
  ///
  /// In en, this message translates to:
  /// **'Browse the web'**
  String get browseTheWeb;

  /// No description provided for @goPro.
  ///
  /// In en, this message translates to:
  /// **'Go Pro'**
  String get goPro;

  /// No description provided for @cast.
  ///
  /// In en, this message translates to:
  /// **'Cast {title}'**
  String cast(Object title);

  /// No description provided for @screenMirroringStartMirroring.
  ///
  /// In en, this message translates to:
  /// **'Screen Mirroring. Start mirroring'**
  String get screenMirroringStartMirroring;

  /// No description provided for @readyToMirrorTo.
  ///
  /// In en, this message translates to:
  /// **'Ready to mirror to {device}'**
  String readyToMirrorTo(Object device);

  /// No description provided for @showYourPhoneOn.
  ///
  /// In en, this message translates to:
  /// **'Show your phone on the TV in real time.'**
  String get showYourPhoneOn;

  /// No description provided for @startMirroring.
  ///
  /// In en, this message translates to:
  /// **'Start Mirroring'**
  String get startMirroring;

  /// No description provided for @tvRemote.
  ///
  /// In en, this message translates to:
  /// **'TV Remote'**
  String get tvRemote;

  /// No description provided for @controlYourTv.
  ///
  /// In en, this message translates to:
  /// **'Control your TV'**
  String get controlYourTv;

  /// No description provided for @youtubeMore.
  ///
  /// In en, this message translates to:
  /// **'YouTube & more'**
  String get youtubeMore;

  /// No description provided for @openTheBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open the browser'**
  String get openTheBrowser;

  /// No description provided for @searchOrTypeA.
  ///
  /// In en, this message translates to:
  /// **'Search or type a website'**
  String get searchOrTypeA;

  /// No description provided for @howToConnectOpen.
  ///
  /// In en, this message translates to:
  /// **'How to connect. Open the visual guide'**
  String get howToConnectOpen;

  /// No description provided for @visualGuideForEvery.
  ///
  /// In en, this message translates to:
  /// **'Visual guide for every feature'**
  String get visualGuideForEvery;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @enterAValidHttp.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid http(s) or rtsp link, e.g. an .m3u8 or .mp4 URL.'**
  String get enterAValidHttp;

  /// No description provided for @linkStream.
  ///
  /// In en, this message translates to:
  /// **'Link stream'**
  String get linkStream;

  /// No description provided for @iptvLinkCast.
  ///
  /// In en, this message translates to:
  /// **'IPTV / Link Cast'**
  String get iptvLinkCast;

  /// No description provided for @castALink.
  ///
  /// In en, this message translates to:
  /// **'Cast a link'**
  String get castALink;

  /// No description provided for @pasteADirectVideo.
  ///
  /// In en, this message translates to:
  /// **'Paste a direct video, M3U8 or IPTV stream URL.'**
  String get pasteADirectVideo;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @castLink.
  ///
  /// In en, this message translates to:
  /// **'Cast link'**
  String get castLink;

  /// No description provided for @allowAccessToYour.
  ///
  /// In en, this message translates to:
  /// **'Allow access to your media to cast it. You can change this in Settings.'**
  String get allowAccessToYour;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @castMusic.
  ///
  /// In en, this message translates to:
  /// **'Cast Music'**
  String get castMusic;

  /// No description provided for @noMusicFound.
  ///
  /// In en, this message translates to:
  /// **'No music found'**
  String get noMusicFound;

  /// No description provided for @addSongsToYour.
  ///
  /// In en, this message translates to:
  /// **'Add songs to your phone and they’ll show up here.'**
  String get addSongsToYour;

  /// No description provided for @shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @playAll.
  ///
  /// In en, this message translates to:
  /// **'Play all'**
  String get playAll;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo · {formatShortDate}'**
  String photo(Object formatShortDate);

  /// No description provided for @photo2.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo2;

  /// No description provided for @castPhotos.
  ///
  /// In en, this message translates to:
  /// **'Cast Photos'**
  String get castPhotos;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @noPhotosHere.
  ///
  /// In en, this message translates to:
  /// **'No photos here'**
  String get noPhotosHere;

  /// No description provided for @photosYouTakeOr.
  ///
  /// In en, this message translates to:
  /// **'Photos you take or save will show up in this album.'**
  String get photosYouTakeOr;

  /// No description provided for @photos2.
  ///
  /// In en, this message translates to:
  /// **'{name}, {count} photos'**
  String photos2(Object name, Object count);

  /// No description provided for @photoFrom.
  ///
  /// In en, this message translates to:
  /// **'Photo from {formatShortDate}'**
  String photoFrom(Object formatShortDate);

  /// No description provided for @allPhotos.
  ///
  /// In en, this message translates to:
  /// **'All photos'**
  String get allPhotos;

  /// No description provided for @slideshow.
  ///
  /// In en, this message translates to:
  /// **'Slideshow'**
  String get slideshow;

  /// No description provided for @interval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get interval;

  /// No description provided for @transition.
  ///
  /// In en, this message translates to:
  /// **'Transition'**
  String get transition;

  /// No description provided for @fade.
  ///
  /// In en, this message translates to:
  /// **'Fade'**
  String get fade;

  /// No description provided for @slide.
  ///
  /// In en, this message translates to:
  /// **'Slide'**
  String get slide;

  /// No description provided for @zoom.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoom;

  /// No description provided for @startSlideshow.
  ///
  /// In en, this message translates to:
  /// **'Start slideshow'**
  String get startSlideshow;

  /// No description provided for @castVideos.
  ///
  /// In en, this message translates to:
  /// **'Cast Videos'**
  String get castVideos;

  /// No description provided for @noVideosYet.
  ///
  /// In en, this message translates to:
  /// **'No videos yet'**
  String get noVideosYet;

  /// No description provided for @videosYouRecordOr.
  ///
  /// In en, this message translates to:
  /// **'Videos you record or download will appear here, ready to cast.'**
  String get videosYouRecordOr;

  /// No description provided for @video2.
  ///
  /// In en, this message translates to:
  /// **'Video · {resolution}'**
  String video2(Object resolution);

  /// No description provided for @cast2.
  ///
  /// In en, this message translates to:
  /// **'{title}, {formatDuration}. Cast'**
  String cast2(Object title, Object formatDuration);

  /// No description provided for @tv.
  ///
  /// In en, this message translates to:
  /// **'TV'**
  String get tv;

  /// No description provided for @screenMirroringSession.
  ///
  /// In en, this message translates to:
  /// **'Screen mirroring session'**
  String get screenMirroringSession;

  /// No description provided for @mirroringDidntStartTap.
  ///
  /// In en, this message translates to:
  /// **'Mirroring didn’t start. Tap Start again and pick your TV in the list.'**
  String get mirroringDidntStartTap;

  /// No description provided for @openSmartViewOr.
  ///
  /// In en, this message translates to:
  /// **'Open Smart View or Cast from your phone’s quick settings to mirror.'**
  String get openSmartViewOr;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @adjustsToYourWi.
  ///
  /// In en, this message translates to:
  /// **'Adjusts to your Wi-Fi for the smoothest picture.'**
  String get adjustsToYourWi;

  /// No description provided for @upToLowerIt.
  ///
  /// In en, this message translates to:
  /// **'Up to {label}. Lower it if the picture stutters.'**
  String upToLowerIt(Object label);

  /// No description provided for @stillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get stillNeedHelp;

  /// No description provided for @startingScreenMirroring.
  ///
  /// In en, this message translates to:
  /// **'Starting screen mirroring…'**
  String get startingScreenMirroring;

  /// No description provided for @mirroringTo.
  ///
  /// In en, this message translates to:
  /// **'Mirroring to {value}'**
  String mirroringTo(Object value);

  /// No description provided for @stopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping…'**
  String get stopping;

  /// No description provided for @readyToMirror.
  ///
  /// In en, this message translates to:
  /// **'Ready to mirror'**
  String get readyToMirror;

  /// No description provided for @beforeYouStart.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get beforeYouStart;

  /// No description provided for @phoneAndTvAre.
  ///
  /// In en, this message translates to:
  /// **'Phone and TV are on the same Wi-Fi'**
  String get phoneAndTvAre;

  /// No description provided for @noVpnIsConnected.
  ///
  /// In en, this message translates to:
  /// **'No VPN is connected on your phone'**
  String get noVpnIsConnected;

  /// No description provided for @tvIsOnWith.
  ///
  /// In en, this message translates to:
  /// **'TV is on with Screen Mirroring enabled'**
  String get tvIsOnWith;

  /// No description provided for @phoneIsCloseTo.
  ///
  /// In en, this message translates to:
  /// **'Phone is close to the TV'**
  String get phoneIsCloseTo;

  /// No description provided for @stopMirroring.
  ///
  /// In en, this message translates to:
  /// **'Stop mirroring'**
  String get stopMirroring;

  /// No description provided for @startMirroring2.
  ///
  /// In en, this message translates to:
  /// **'Start mirroring'**
  String get startMirroring2;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @adIsLoading.
  ///
  /// In en, this message translates to:
  /// **'Ad is loading'**
  String get adIsLoading;

  /// No description provided for @ad.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get ad;

  /// No description provided for @mirrorYourScreenTo.
  ///
  /// In en, this message translates to:
  /// **'Mirror your screen to any TV'**
  String get mirrorYourScreenTo;

  /// No description provided for @showYourPhoneOnThe.
  ///
  /// In en, this message translates to:
  /// **'Show your phone on the big screen in one tap — no cables, no fuss.'**
  String get showYourPhoneOnThe;

  /// No description provided for @shareMemoriesWithThe.
  ///
  /// In en, this message translates to:
  /// **'Share memories with the whole room and keep control from your phone.'**
  String get shareMemoriesWithThe;

  /// No description provided for @castFromWebApps.
  ///
  /// In en, this message translates to:
  /// **'Cast from web & apps'**
  String get castFromWebApps;

  /// No description provided for @sendVideosFromYoutube.
  ///
  /// In en, this message translates to:
  /// **'Send videos from YouTube, Facebook and any website straight to your TV.'**
  String get sendVideosFromYoutube;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {value} of {length}'**
  String pageOf(Object value, Object length);

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @localNetwork.
  ///
  /// In en, this message translates to:
  /// **'Local Network'**
  String get localNetwork;

  /// No description provided for @findTvsAndStreaming.
  ///
  /// In en, this message translates to:
  /// **'Find TVs and streaming devices on your Wi-Fi.'**
  String get findTvsAndStreaming;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @showCastingControlsWhile.
  ///
  /// In en, this message translates to:
  /// **'Show casting controls while you use other apps.'**
  String get showCastingControlsWhile;

  /// No description provided for @photosVideosMusic.
  ///
  /// In en, this message translates to:
  /// **'Photos, Videos & Music'**
  String get photosVideosMusic;

  /// No description provided for @pickWhatYouWantTo.
  ///
  /// In en, this message translates to:
  /// **'Pick what you want to cast from your gallery and library.'**
  String get pickWhatYouWantTo;

  /// No description provided for @screenCapture.
  ///
  /// In en, this message translates to:
  /// **'Screen Capture'**
  String get screenCapture;

  /// No description provided for @mirrorYourScreenYoull.
  ///
  /// In en, this message translates to:
  /// **'Mirror your screen. You’ll confirm each session.'**
  String get mirrorYourScreenYoull;

  /// No description provided for @webVideo.
  ///
  /// In en, this message translates to:
  /// **'Web video'**
  String get webVideo;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @screenMirroring2.
  ///
  /// In en, this message translates to:
  /// **'Screen mirroring'**
  String get screenMirroring2;

  /// No description provided for @nowCastingOpenRemote.
  ///
  /// In en, this message translates to:
  /// **'Now casting {title}. Open remote'**
  String nowCastingOpenRemote(Object title);

  /// No description provided for @castingTo2.
  ///
  /// In en, this message translates to:
  /// **'Casting to {value}'**
  String castingTo2(Object value);

  /// No description provided for @nowCasting.
  ///
  /// In en, this message translates to:
  /// **'Now casting'**
  String get nowCasting;

  /// No description provided for @nothingIsCasting.
  ///
  /// In en, this message translates to:
  /// **'Nothing is casting'**
  String get nothingIsCasting;

  /// No description provided for @pickAPhotoVideo.
  ///
  /// In en, this message translates to:
  /// **'Pick a photo, video, song or web video to send it to your TV.'**
  String get pickAPhotoVideo;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @slide2.
  ///
  /// In en, this message translates to:
  /// **'Slide {formatDuration}'**
  String slide2(Object formatDuration);

  /// No description provided for @back10Seconds.
  ///
  /// In en, this message translates to:
  /// **'Back 10 seconds'**
  String get back10Seconds;

  /// No description provided for @forward10Seconds.
  ///
  /// In en, this message translates to:
  /// **'Forward 10 seconds'**
  String get forward10Seconds;

  /// No description provided for @tvVolume.
  ///
  /// In en, this message translates to:
  /// **'TV volume'**
  String get tvVolume;

  /// No description provided for @tvVolumePercent.
  ///
  /// In en, this message translates to:
  /// **'TV volume {round} percent'**
  String tvVolumePercent(Object round);

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get upNext;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @addVideos.
  ///
  /// In en, this message translates to:
  /// **'Add videos'**
  String get addVideos;

  /// No description provided for @nothingElseInThe.
  ///
  /// In en, this message translates to:
  /// **'Nothing else in the queue.'**
  String get nothingElseInThe;

  /// No description provided for @play2.
  ///
  /// In en, this message translates to:
  /// **'Play {title}'**
  String play2(Object title);

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get unknownDevice;

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **'per week'**
  String get perWeek;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'per year'**
  String get perYear;

  /// No description provided for @payOnce.
  ///
  /// In en, this message translates to:
  /// **'pay once'**
  String get payOnce;

  /// No description provided for @wirelessScreenMirroring.
  ///
  /// In en, this message translates to:
  /// **'Wireless screen mirroring'**
  String get wirelessScreenMirroring;

  /// No description provided for @castVideosPhotosMusic.
  ///
  /// In en, this message translates to:
  /// **'Cast videos, photos & music'**
  String get castVideosPhotosMusic;

  /// No description provided for @fullTvRemoteControl.
  ///
  /// In en, this message translates to:
  /// **'Full TV remote control'**
  String get fullTvRemoteControl;

  /// No description provided for @worksWithAllMajor.
  ///
  /// In en, this message translates to:
  /// **'Works with all major TVs'**
  String get worksWithAllMajor;

  /// No description provided for @smoothLagFreeStreaming.
  ///
  /// In en, this message translates to:
  /// **'Smooth, lag-free streaming'**
  String get smoothLagFreeStreaming;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get noAds;

  /// No description provided for @welcomeToCastflowPro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CastFlow Pro!'**
  String get welcomeToCastflowPro;

  /// No description provided for @purchaseCancelled.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled.'**
  String get purchaseCancelled;

  /// No description provided for @purchasePendingProUnlocks.
  ///
  /// In en, this message translates to:
  /// **'Purchase pending. Pro unlocks as soon as the store confirms it.'**
  String get purchasePendingProUnlocks;

  /// No description provided for @purchaseFailedPleaseTry.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get purchaseFailedPleaseTry;

  /// No description provided for @theStoreIsntAvailable.
  ///
  /// In en, this message translates to:
  /// **'The store isn’t available right now.'**
  String get theStoreIsntAvailable;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @goProWithCastflow.
  ///
  /// In en, this message translates to:
  /// **'GO PRO WITH CASTFLOW'**
  String get goProWithCastflow;

  /// No description provided for @unlockEveryFeature.
  ///
  /// In en, this message translates to:
  /// **'Unlock every feature'**
  String get unlockEveryFeature;

  /// No description provided for @renewsAutomaticallyUntilCancelled.
  ///
  /// In en, this message translates to:
  /// **'Renews automatically until cancelled.'**
  String get renewsAutomaticallyUntilCancelled;

  /// No description provided for @oneTimePurchaseNo.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase. No subscription.'**
  String get oneTimePurchaseNo;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @cancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get cancelAnytime;

  /// No description provided for @loadingPrice.
  ///
  /// In en, this message translates to:
  /// **'Loading price…'**
  String get loadingPrice;

  /// No description provided for @pricesUnavailableTapTo.
  ///
  /// In en, this message translates to:
  /// **'Prices unavailable · Tap to retry'**
  String get pricesUnavailableTapTo;

  /// No description provided for @noPlansAvailableRight.
  ///
  /// In en, this message translates to:
  /// **'No plans available right now.'**
  String get noPlansAvailableRight;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @lifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetime;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get bestValue;

  /// No description provided for @disconnectFromTv.
  ///
  /// In en, this message translates to:
  /// **'Disconnect from TV?'**
  String get disconnectFromTv;

  /// No description provided for @thisStopsWhatIs.
  ///
  /// In en, this message translates to:
  /// **'This stops what is currently playing or being mirrored.'**
  String get thisStopsWhatIs;

  /// No description provided for @useTouchpad.
  ///
  /// In en, this message translates to:
  /// **'Use touchpad'**
  String get useTouchpad;

  /// No description provided for @useDPad.
  ///
  /// In en, this message translates to:
  /// **'Use D-pad'**
  String get useDPad;

  /// No description provided for @receiversDontAcceptRemote.
  ///
  /// In en, this message translates to:
  /// **'{label} receivers don’t accept remote commands.'**
  String receiversDontAcceptRemote(Object label);

  /// No description provided for @someButtonsAreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Some buttons are unavailable on {label}.'**
  String someButtonsAreUnavailable(Object label);

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'IDLE'**
  String get idle;

  /// No description provided for @playing.
  ///
  /// In en, this message translates to:
  /// **'PLAYING'**
  String get playing;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get paused;

  /// No description provided for @noTvConnected.
  ///
  /// In en, this message translates to:
  /// **'No TV connected'**
  String get noTvConnected;

  /// No description provided for @mute2.
  ///
  /// In en, this message translates to:
  /// **'MUTE'**
  String get mute2;

  /// No description provided for @vol.
  ///
  /// In en, this message translates to:
  /// **'VOL {volume}'**
  String vol(Object volume);

  /// No description provided for @noTvConnectedTap.
  ///
  /// In en, this message translates to:
  /// **'No TV connected. Tap to choose a device'**
  String get noTvConnectedTap;

  /// No description provided for @tapToChooseA.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose a device'**
  String get tapToChooseA;

  /// No description provided for @isntSupportedBy.
  ///
  /// In en, this message translates to:
  /// **'{label} isn’t supported by {label2}'**
  String isntSupportedBy(Object label, Object label2);

  /// No description provided for @touchpadSwipeToMove.
  ///
  /// In en, this message translates to:
  /// **'Touchpad. Swipe to move, tap to select.'**
  String get touchpadSwipeToMove;

  /// No description provided for @swipeToMoveTap.
  ///
  /// In en, this message translates to:
  /// **'Swipe to move · Tap to select'**
  String get swipeToMoveTap;

  /// No description provided for @navigationIsntSupportedBy.
  ///
  /// In en, this message translates to:
  /// **'Navigation isn’t supported by this TV'**
  String get navigationIsntSupportedBy;

  /// No description provided for @vol2.
  ///
  /// In en, this message translates to:
  /// **'VOL'**
  String get vol2;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @googleCastFirst.
  ///
  /// In en, this message translates to:
  /// **'Google Cast first'**
  String get googleCastFirst;

  /// No description provided for @dlnaUpnpFirst.
  ///
  /// In en, this message translates to:
  /// **'DLNA / UPnP first'**
  String get dlnaUpnpFirst;

  /// No description provided for @miracastFirst.
  ///
  /// In en, this message translates to:
  /// **'Miracast first'**
  String get miracastFirst;

  /// No description provided for @tvOnly.
  ///
  /// In en, this message translates to:
  /// **'TV only'**
  String get tvOnly;

  /// No description provided for @phoneAndTv.
  ///
  /// In en, this message translates to:
  /// **'Phone and TV'**
  String get phoneAndTv;

  /// No description provided for @phoneOnly.
  ///
  /// In en, this message translates to:
  /// **'Phone only'**
  String get phoneOnly;

  /// No description provided for @touchpad.
  ///
  /// In en, this message translates to:
  /// **'Touchpad'**
  String get touchpad;

  /// No description provided for @doMyPhoneAnd.
  ///
  /// In en, this message translates to:
  /// **'Do my phone and TV need the same Wi-Fi?'**
  String get doMyPhoneAnd;

  /// No description provided for @yesDiscoveryAndCasting.
  ///
  /// In en, this message translates to:
  /// **'Yes. Discovery and casting stay on your local network, so both must be on the same Wi-Fi (same band names can still be different networks).'**
  String get yesDiscoveryAndCasting;

  /// No description provided for @myRouterHasAp.
  ///
  /// In en, this message translates to:
  /// **'My router has “AP / client isolation”'**
  String get myRouterHasAp;

  /// No description provided for @isolationBlocksDevicesFrom.
  ///
  /// In en, this message translates to:
  /// **'Isolation blocks devices from seeing each other. Turn it off in the router settings, or use a non-guest network.'**
  String get isolationBlocksDevicesFrom;

  /// No description provided for @findingYourTv.
  ///
  /// In en, this message translates to:
  /// **'Finding your TV'**
  String get findingYourTv;

  /// No description provided for @myTvDoesntAppear.
  ///
  /// In en, this message translates to:
  /// **'My TV doesn’t appear in the list'**
  String get myTvDoesntAppear;

  /// No description provided for @turnOnCastingScreen.
  ///
  /// In en, this message translates to:
  /// **'Turn on casting / screen mirroring on the TV, wake it from standby, then tap Rescan. Allow the Local Network permission if asked.'**
  String get turnOnCastingScreen;

  /// No description provided for @onlySomeDevicesShow.
  ///
  /// In en, this message translates to:
  /// **'Only some devices show up'**
  String get onlySomeDevicesShow;

  /// No description provided for @olderTvsMayNeed.
  ///
  /// In en, this message translates to:
  /// **'Older TVs may need a firmware update. Miracast TVs only appear while their “Screen Mirroring” input is open.'**
  String get olderTvsMayNeed;

  /// No description provided for @connectionFailsOrTimes.
  ///
  /// In en, this message translates to:
  /// **'Connection fails or times out'**
  String get connectionFailsOrTimes;

  /// No description provided for @restartTheTvApp.
  ///
  /// In en, this message translates to:
  /// **'Restart the TV app or the TV, move closer to the router, and accept any prompt shown on the TV screen.'**
  String get restartTheTvApp;

  /// No description provided for @itKeepsReconnectingTo.
  ///
  /// In en, this message translates to:
  /// **'It keeps reconnecting to an old TV'**
  String get itKeepsReconnectingTo;

  /// No description provided for @turnOffAutoConnect.
  ///
  /// In en, this message translates to:
  /// **'Turn off “Auto-connect to last TV” in Settings → Casting.'**
  String get turnOffAutoConnect;

  /// No description provided for @mirroringIsLaggy.
  ///
  /// In en, this message translates to:
  /// **'Mirroring is laggy'**
  String get mirroringIsLaggy;

  /// No description provided for @chooseALowerQuality.
  ///
  /// In en, this message translates to:
  /// **'Choose a lower quality (720p or 480p), close heavy apps and use a 5 GHz Wi-Fi network.'**
  String get chooseALowerQuality;

  /// No description provided for @thePictureIsRotated.
  ///
  /// In en, this message translates to:
  /// **'The picture is rotated or cropped'**
  String get thePictureIsRotated;

  /// No description provided for @toggleAutoRotateOn.
  ///
  /// In en, this message translates to:
  /// **'Toggle Auto-rotate on the Screen Mirroring screen.'**
  String get toggleAutoRotateOn;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @thereIsNoSound.
  ///
  /// In en, this message translates to:
  /// **'There is no sound on the TV'**
  String get thereIsNoSound;

  /// No description provided for @makeSureAudioIs.
  ///
  /// In en, this message translates to:
  /// **'Make sure Audio is on in Screen Mirroring and check Settings → Casting → Audio output. Some receivers don’t support phone audio.'**
  String get makeSureAudioIs;

  /// No description provided for @tvRemote2.
  ///
  /// In en, this message translates to:
  /// **'TV remote'**
  String get tvRemote2;

  /// No description provided for @someRemoteButtonsAre.
  ///
  /// In en, this message translates to:
  /// **'Some remote buttons are greyed out'**
  String get someRemoteButtonsAre;

  /// No description provided for @eachReceiverSupportsDifferent.
  ///
  /// In en, this message translates to:
  /// **'Each receiver supports different commands. Chromecast and DLNA only support playback and volume; Miracast has no remote channel.'**
  String get eachReceiverSupportsDifferent;

  /// No description provided for @canCastflowTurnMy.
  ///
  /// In en, this message translates to:
  /// **'Can CastFlow turn my TV on or change inputs?'**
  String get canCastflowTurnMy;

  /// No description provided for @onlyOnTvsThat.
  ///
  /// In en, this message translates to:
  /// **'Only on TVs that expose those commands over the network. Unsupported buttons are disabled instead of pretending to work.'**
  String get onlyOnTvsThat;

  /// No description provided for @helpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFaq;

  /// No description provided for @stepByStepConnection.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step connection guide'**
  String get stepByStepConnection;

  /// No description provided for @androidSdk.
  ///
  /// In en, this message translates to:
  /// **'Android {release} (SDK {sdkInt})'**
  String androidSdk(Object release, Object sdkInt);

  /// No description provided for @noEmailAppFound.
  ///
  /// In en, this message translates to:
  /// **'No email app found.'**
  String get noEmailAppFound;

  /// No description provided for @enjoyingCastflow.
  ///
  /// In en, this message translates to:
  /// **'Enjoying CastFlow?'**
  String get enjoyingCastflow;

  /// No description provided for @sorryToHearThat.
  ///
  /// In en, this message translates to:
  /// **'Sorry to hear that'**
  String get sorryToHearThat;

  /// No description provided for @thanksHowCanWe.
  ///
  /// In en, this message translates to:
  /// **'Thanks! How can we improve?'**
  String get thanksHowCanWe;

  /// No description provided for @wereGladYouLike.
  ///
  /// In en, this message translates to:
  /// **'We’re glad you like it!'**
  String get wereGladYouLike;

  /// No description provided for @youMadeOurDay.
  ///
  /// In en, this message translates to:
  /// **'You made our day!'**
  String get youMadeOurDay;

  /// No description provided for @tapToExit.
  ///
  /// In en, this message translates to:
  /// **'Tap to exit'**
  String get tapToExit;

  /// No description provided for @selectARating.
  ///
  /// In en, this message translates to:
  /// **'Select a rating'**
  String get selectARating;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get rateUs;

  /// No description provided for @rateYourExperienceBefore.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience before you go.'**
  String get rateYourExperienceBefore;

  /// No description provided for @tapAStarTo.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate CastFlow.'**
  String get tapAStarTo;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @defaultQuality.
  ///
  /// In en, this message translates to:
  /// **'Default quality'**
  String get defaultQuality;

  /// No description provided for @autoConnectToLast.
  ///
  /// In en, this message translates to:
  /// **'Auto-connect to last TV'**
  String get autoConnectToLast;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticFeedback;

  /// No description provided for @clearCastingHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear casting history'**
  String get clearCastingHistory;

  /// No description provided for @clearCastingHistory2.
  ///
  /// In en, this message translates to:
  /// **'Clear casting history?'**
  String get clearCastingHistory2;

  /// No description provided for @onlyCastflowsListIs.
  ///
  /// In en, this message translates to:
  /// **'Only CastFlow’s list is cleared. Media on your phone is never deleted.'**
  String get onlyCastflowsListIs;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @aboutSupport.
  ///
  /// In en, this message translates to:
  /// **'About & support'**
  String get aboutSupport;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate app'**
  String get rateApp;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @castflowProIsActive.
  ///
  /// In en, this message translates to:
  /// **'CastFlow Pro is active'**
  String get castflowProIsActive;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @castflowPremium.
  ///
  /// In en, this message translates to:
  /// **'CastFlow Premium'**
  String get castflowPremium;

  /// No description provided for @thanksForYourSupport.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your support. Enjoy ad-free casting.'**
  String get thanksForYourSupport;

  /// No description provided for @noAds1080pMirroring.
  ///
  /// In en, this message translates to:
  /// **'No ads, 1080p mirroring & unlimited casting'**
  String get noAds1080pMirroring;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @mirrorCastBeautifullySimple.
  ///
  /// In en, this message translates to:
  /// **'Mirror & cast, beautifully simple'**
  String get mirrorCastBeautifullySimple;

  /// No description provided for @thisActionMayContain.
  ///
  /// In en, this message translates to:
  /// **'This action may contain ads'**
  String get thisActionMayContain;

  /// No description provided for @webCast.
  ///
  /// In en, this message translates to:
  /// **'Web Cast'**
  String get webCast;

  /// No description provided for @castThisVideo.
  ///
  /// In en, this message translates to:
  /// **'Cast this video'**
  String get castThisVideo;

  /// No description provided for @searchOrTypeAWeb.
  ///
  /// In en, this message translates to:
  /// **'Search or type a web address'**
  String get searchOrTypeAWeb;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmark;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get quickAccess;

  /// No description provided for @open2.
  ///
  /// In en, this message translates to:
  /// **'Open {title}'**
  String open2(Object title);

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks'**
  String get noBookmarks;

  /// No description provided for @tapTheBookmarkIcon.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark icon in the address bar to save a page.'**
  String get tapTheBookmarkIcon;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history'**
  String get noHistory;

  /// No description provided for @pagesYouVisitShow.
  ///
  /// In en, this message translates to:
  /// **'Pages you visit show up here.'**
  String get pagesYouVisitShow;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @resultOn.
  ///
  /// In en, this message translates to:
  /// **'Result {value} on {host}'**
  String resultOn(Object value, Object host);

  /// No description provided for @aSimulatedPageResult.
  ///
  /// In en, this message translates to:
  /// **'A simulated page result'**
  String get aSimulatedPageResult;

  /// No description provided for @videosOnThisPage.
  ///
  /// In en, this message translates to:
  /// **'Videos on this page'**
  String get videosOnThisPage;

  /// No description provided for @pickOneToSend.
  ///
  /// In en, this message translates to:
  /// **'Pick one to send to your TV.'**
  String get pickOneToSend;

  /// No description provided for @onboardHotspotTitle.
  ///
  /// In en, this message translates to:
  /// **'No Wi-Fi? Use your hotspot'**
  String get onboardHotspotTitle;

  /// No description provided for @onboardHotspotBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on your phone’s hotspot and connect your TV to it. Casting works just like on Wi-Fi.'**
  String get onboardHotspotBody;

  /// No description provided for @stillCantFindTitle.
  ///
  /// In en, this message translates to:
  /// **'Still can’t find your TV?'**
  String get stillCantFindTitle;

  /// No description provided for @stillCantFindBody.
  ///
  /// In en, this message translates to:
  /// **'Connect your TV to your phone’s hotspot instead:'**
  String get stillCantFindBody;

  /// No description provided for @hotspotStep4.
  ///
  /// In en, this message translates to:
  /// **'Tap Retry and pick your TV from the list'**
  String get hotspotStep4;

  /// No description provided for @castOverHotspot.
  ///
  /// In en, this message translates to:
  /// **'No Wi-Fi? Cast over your phone’s hotspot:'**
  String get castOverHotspot;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// No description provided for @addMusic.
  ///
  /// In en, this message translates to:
  /// **'Add music'**
  String get addMusic;

  /// No description provided for @connectWithWifi.
  ///
  /// In en, this message translates to:
  /// **'Connect with Wi-Fi'**
  String get connectWithWifi;

  /// No description provided for @continueWithHotspot.
  ///
  /// In en, this message translates to:
  /// **'Continue with hotspot'**
  String get continueWithHotspot;

  /// No description provided for @noWifiAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'You’re on mobile data. Connect your phone and TV to the same Wi-Fi, or turn on your phone’s hotspot and join it from the TV.'**
  String get noWifiAlertMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'fa',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pl',
    'pt',
    'ru',
    'th',
    'tr',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
