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
