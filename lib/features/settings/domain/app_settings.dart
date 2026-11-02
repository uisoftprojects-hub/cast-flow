import 'package:flutter/material.dart';

enum MirrorQuality {
  auto('Auto'),
  p480('480p'),
  p720('720p'),
  p1080('1080p');

  const MirrorQuality(this.label);
  final String label;
}

/// Which receiver protocol to prefer when a TV supports several.
enum ConnectionPreference {
  auto('Automatic'),
  googleCast('Google Cast first'),
  dlna('DLNA / UPnP first'),
  miracast('Miracast first');

  const ConnectionPreference(this.label);
  final String label;
}

/// Where sound plays while mirroring or casting (where the receiver allows).
enum AudioOutput {
  tv('TV only'),
  phoneAndTv('Phone and TV'),
  phone('Phone only');

  const AudioOutput(this.label);
  final String label;
}

enum RemoteLayout {
  dpad('D-pad'),
  touchpad('Touchpad');

  const RemoteLayout(this.label);
  final String label;
}

/// The 20 most widely used app languages, in display order.
/// Value: (native name, English name, flag). Arabic, Urdu and Persian are RTL.
const supportedLanguages = <String, (String, String, String)>{
  'en': ('English', 'English', '🇺🇸'),
  'es': ('Español', 'Spanish', '🇪🇸'),
  'hi': ('हिन्दी', 'Hindi', '🇮🇳'),
  'ar': ('العربية', 'Arabic', '🇸🇦'),
  'pt': ('Português', 'Portuguese', '🇧🇷'),
  'bn': ('বাংলা', 'Bengali', '🇧🇩'),
  'ru': ('Русский', 'Russian', '🇷🇺'),
  'ur': ('اردو', 'Urdu', '🇵🇰'),
  'id': ('Bahasa Indonesia', 'Indonesian', '🇮🇩'),
  'fr': ('Français', 'French', '🇫🇷'),
  'de': ('Deutsch', 'German', '🇩🇪'),
  'ja': ('日本語', 'Japanese', '🇯🇵'),
  'zh': ('中文', 'Chinese', '🇨🇳'),
  'tr': ('Türkçe', 'Turkish', '🇹🇷'),
  'ko': ('한국어', 'Korean', '🇰🇷'),
  'vi': ('Tiếng Việt', 'Vietnamese', '🇻🇳'),
  'it': ('Italiano', 'Italian', '🇮🇹'),
  'th': ('ไทย', 'Thai', '🇹🇭'),
  'fa': ('فارسی', 'Persian', '🇮🇷'),
  'pl': ('Polski', 'Polish', '🇵🇱'),
};

@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.defaultQuality = MirrorQuality.auto,
    this.autoConnect = true,
    this.connectionPreference = ConnectionPreference.auto,
    this.audioOutput = AudioOutput.tv,
    this.languageCode = 'en',
    this.languageChosen = false,
    this.onboardingDone = false,
    this.firstLaunchCompleted = false,
    this.isPremium = false,
    this.hapticsEnabled = true,
    this.buttonSound = false,
    this.remoteLayout = RemoteLayout.dpad,
    this.lastDeviceId,
    this.lastPaywallAt,
    this.lastReviewPromptAt,
  });

  final ThemeMode themeMode;
  final MirrorQuality defaultQuality;
  final bool autoConnect;
  final ConnectionPreference connectionPreference;
  final AudioOutput audioOutput;
  final String languageCode;
  final bool languageChosen;
  final bool onboardingDone;
  final bool firstLaunchCompleted;
  final bool isPremium;
  final bool hapticsEnabled;
  final bool buttonSound;
  final RemoteLayout remoteLayout;
  final String? lastDeviceId;
  final DateTime? lastPaywallAt;
  final DateTime? lastReviewPromptAt;

  AppSettings copyWith({
    ThemeMode? themeMode,
    MirrorQuality? defaultQuality,
    bool? autoConnect,
    ConnectionPreference? connectionPreference,
    AudioOutput? audioOutput,
    String? languageCode,
    bool? languageChosen,
    bool? onboardingDone,
    bool? firstLaunchCompleted,
    bool? isPremium,
    bool? hapticsEnabled,
    bool? buttonSound,
    RemoteLayout? remoteLayout,
    String? lastDeviceId,
    DateTime? lastPaywallAt,
    DateTime? lastReviewPromptAt,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      defaultQuality: defaultQuality ?? this.defaultQuality,
      autoConnect: autoConnect ?? this.autoConnect,
      connectionPreference: connectionPreference ?? this.connectionPreference,
      audioOutput: audioOutput ?? this.audioOutput,
      languageCode: languageCode ?? this.languageCode,
      languageChosen: languageChosen ?? this.languageChosen,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      firstLaunchCompleted: firstLaunchCompleted ?? this.firstLaunchCompleted,
      isPremium: isPremium ?? this.isPremium,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      buttonSound: buttonSound ?? this.buttonSound,
      remoteLayout: remoteLayout ?? this.remoteLayout,
      lastDeviceId: lastDeviceId ?? this.lastDeviceId,
      lastPaywallAt: lastPaywallAt ?? this.lastPaywallAt,
      lastReviewPromptAt: lastReviewPromptAt ?? this.lastReviewPromptAt,
    );
  }
}
