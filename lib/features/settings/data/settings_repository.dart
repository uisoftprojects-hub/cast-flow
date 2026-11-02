import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _theme = 'theme_mode';
  static const _quality = 'default_quality';
  static const _autoConnect = 'auto_connect';
  static const _connection = 'connection_preference';
  static const _audio = 'audio_output';
  static const _language = 'language';
  static const _languageChosen = 'language_chosen';
  static const _onboarding = 'onboarding_done';
  static const _firstLaunch = 'first_launch_completed';
  static const _premium = 'is_premium';
  static const _haptics = 'haptics_enabled';
  static const _buttonSound = 'button_sound';
  static const _remoteLayout = 'remote_layout';
  static const _lastDevice = 'last_device_id';
  static const _lastPaywall = 'last_paywall_at';
  static const _lastReview = 'last_review_prompt_at';

  T _enum<T>(List<T> values, String key, T fallback) {
    final i = _prefs.getInt(key);
    return i != null && i >= 0 && i < values.length ? values[i] : fallback;
  }

  DateTime? _time(String key) {
    final ms = _prefs.getInt(key);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  AppSettings load() {
    return AppSettings(
      themeMode: _enum(ThemeMode.values, _theme, ThemeMode.light),
      defaultQuality: _enum(MirrorQuality.values, _quality, MirrorQuality.auto),
      autoConnect: _prefs.getBool(_autoConnect) ?? true,
      connectionPreference: _enum(ConnectionPreference.values, _connection, ConnectionPreference.auto),
      audioOutput: _enum(AudioOutput.values, _audio, AudioOutput.tv),
      languageCode: _prefs.getString(_language) ?? 'en',
      languageChosen: _prefs.getBool(_languageChosen) ?? false,
      onboardingDone: _prefs.getBool(_onboarding) ?? false,
      firstLaunchCompleted: _prefs.getBool(_firstLaunch) ?? false,
      isPremium: _prefs.getBool(_premium) ?? false,
      hapticsEnabled: _prefs.getBool(_haptics) ?? true,
      buttonSound: _prefs.getBool(_buttonSound) ?? false,
      remoteLayout: _enum(RemoteLayout.values, _remoteLayout, RemoteLayout.dpad),
      lastDeviceId: _prefs.getString(_lastDevice),
      lastPaywallAt: _time(_lastPaywall),
      lastReviewPromptAt: _time(_lastReview),
    );
  }

  Future<void> save(AppSettings s) async {
    await Future.wait([
      _prefs.setInt(_theme, s.themeMode.index),
      _prefs.setInt(_quality, s.defaultQuality.index),
      _prefs.setBool(_autoConnect, s.autoConnect),
      _prefs.setInt(_connection, s.connectionPreference.index),
      _prefs.setInt(_audio, s.audioOutput.index),
      _prefs.setString(_language, s.languageCode),
      _prefs.setBool(_languageChosen, s.languageChosen),
      _prefs.setBool(_onboarding, s.onboardingDone),
      _prefs.setBool(_firstLaunch, s.firstLaunchCompleted),
      _prefs.setBool(_premium, s.isPremium),
      _prefs.setBool(_haptics, s.hapticsEnabled),
      _prefs.setBool(_buttonSound, s.buttonSound),
      _prefs.setInt(_remoteLayout, s.remoteLayout.index),
      if (s.lastDeviceId != null) _prefs.setString(_lastDevice, s.lastDeviceId!),
      if (s.lastPaywallAt != null) _prefs.setInt(_lastPaywall, s.lastPaywallAt!.millisecondsSinceEpoch),
      if (s.lastReviewPromptAt != null) _prefs.setInt(_lastReview, s.lastReviewPromptAt!.millisecondsSinceEpoch),
    ]);
  }
}
