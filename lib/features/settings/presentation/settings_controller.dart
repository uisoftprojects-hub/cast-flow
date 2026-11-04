import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/app_providers.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPrefsProvider)),
);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> _update(AppSettings next) {
    state = next;
    return ref.read(settingsRepositoryProvider).save(next);
  }

  void setThemeMode(ThemeMode mode) {
    _update(state.copyWith(themeMode: mode));
  }

  void setDefaultQuality(MirrorQuality q) => _update(state.copyWith(defaultQuality: q));

  void setAutoConnect(bool v) {
    _update(state.copyWith(autoConnect: v));
  }

  void setConnectionPreference(ConnectionPreference v) {
    _update(state.copyWith(connectionPreference: v));
  }

  void setAudioOutput(AudioOutput v) {
    _update(state.copyWith(audioOutput: v));
  }

  void setLanguage(String code) => _update(state.copyWith(languageCode: code));

  Future<void> confirmLanguage(String code) {
    if (code != state.languageCode) {
      ref.read(analyticsProvider)
        ..log(AnalyticsEvent.languageChange, {
          AnalyticsParam.fromLanguage: state.languageCode,
          AnalyticsParam.toLanguage: code,
          AnalyticsParam.firstOpen: !state.firstLaunchCompleted,
        })
        ..userProperty(AnalyticsUserProperty.appLanguage, code);
    }
    return _update(state.copyWith(languageCode: code, languageChosen: true));
  }

  Future<void> completeOnboarding() => _update(state.copyWith(onboardingDone: true));
  Future<void> completeFirstLaunch() => _update(state.copyWith(firstLaunchCompleted: true));
  void setPremium(bool v) => _update(state.copyWith(isPremium: v));
  void setHaptics(bool v) {
    _update(state.copyWith(hapticsEnabled: v));
  }

  void setButtonSound(bool v) {
    _update(state.copyWith(buttonSound: v));
  }

  void setRemoteLayout(RemoteLayout v) {
    _update(state.copyWith(remoteLayout: v));
  }

  void rememberDevice(String id) => _update(state.copyWith(lastDeviceId: id));
  void markPaywallShown() => _update(state.copyWith(lastPaywallAt: DateTime.now()));
  void markReviewPrompted() => _update(state.copyWith(lastReviewPromptAt: DateTime.now()));
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
