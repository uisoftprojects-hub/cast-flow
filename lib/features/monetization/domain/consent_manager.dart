import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_logger.dart';
import 'ad_suppression.dart';

/// Centralized Google User Messaging Platform (UMP) Consent Manager.
/// Respects global premium status: skips consent and ad initialization for premium users.
class ConsentManager {
  ConsentManager({this.debugCanRequestAds});

  final bool? debugCanRequestAds;
  bool _initialized = false;
  bool _canRequest = false;

  bool get isInitialized => _initialized;
  bool get canRequestAdsValue => _canRequest;

  /// Gathers UMP consent and initializes Google Mobile Ads SDK if allowed.
  /// If [isPremium] is true, entirely skips consent and ad initialization.
  Future<bool> gatherConsentAndInitialize({required bool isPremium}) async {
    if (isPremium) {
      AdLogger.i(AdState.requestSkipped, adType: 'UMP_Consent', message: 'Consent gathering skipped for premium user.');
      _initialized = true;
      _canRequest = false;
      return false;
    }

    if (debugCanRequestAds != null) {
      _initialized = true;
      _canRequest = debugCanRequestAds!;
      AdLogger.d(
        AdState.consentCanRequestStatus,
        adType: 'UMP_Consent',
        message: 'Debug override applied: canRequestAds=$_canRequest',
      );
      return _canRequest;
    }

    AdLogger.i(AdState.consentCheckStart, adType: 'UMP_Consent', message: 'Requesting UMP consent information update.');

    final completer = Completer<void>();

    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () {
          AdLogger.d(
            AdState.consentUpdated,
            adType: 'UMP_Consent',
            message: 'Consent info updated; checking if consent form is required.',
          );
          ConsentForm.loadAndShowConsentFormIfRequired((formError) {
            if (formError != null) {
              AdLogger.w(
                AdState.consentError,
                adType: 'UMP_Consent',
                message: 'Consent form error: [${formError.errorCode}] ${formError.message}',
              );
            } else {
              AdLogger.i(
                AdState.consentFormDismissed,
                adType: 'UMP_Consent',
                message: 'Consent form dismissed or not required.',
              );
            }
            if (!completer.isCompleted) completer.complete();
          });
        },
        (formError) {
          AdLogger.w(
            AdState.consentError,
            adType: 'UMP_Consent',
            message: 'Consent info update failed: [${formError.errorCode}] ${formError.message}',
          );
          if (!completer.isCompleted) completer.complete();
        },
      );
    } catch (e) {
      AdLogger.e(AdState.consentError, adType: 'UMP_Consent', message: 'Exception in consent gathering', error: e);
      if (!completer.isCompleted) completer.complete();
    }

    // Wait for UMP consent determination
    await completer.future;

    try {
      _canRequest = await ConsentInformation.instance.canRequestAds();
    } catch (e) {
      AdLogger.e(AdState.consentError, adType: 'UMP_Consent', message: 'Failed to inspect canRequestAds()', error: e);
      _canRequest = false;
    }

    AdLogger.i(AdState.consentCanRequestStatus, adType: 'UMP_Consent', message: 'canRequestAds() result: $_canRequest');

    if (_canRequest) {
      AdLogger.i(AdState.sdkInitStart, adType: 'GoogleMobileAds', message: 'Initializing Google Mobile Ads SDK.');
      try {
        final status = await MobileAds.instance.initialize();
        AdLogger.i(
          AdState.sdkInitSuccess,
          adType: 'GoogleMobileAds',
          message: 'SDK initialized successfully with ${status.adapterStatuses.length} adapter(s).',
        );
      } catch (e) {
        AdLogger.e(AdState.sdkInitFailed, adType: 'GoogleMobileAds', message: 'SDK initialization failed', error: e);
      }
    }

    _initialized = true;
    return _canRequest;
  }

  /// Opens the privacy options / consent form (e.g. for GDPR users in Settings).
  /// Respects premium user status: never opens for premium users.
  Future<bool> showPrivacyOptionsForm({required bool isPremium}) async {
    if (isPremium) {
      AdLogger.d(
        AdState.requestSkipped,
        adType: 'PrivacyOptionsForm',
        message: 'Privacy options form skipped for premium user.',
      );
      return false;
    }

    AdLogger.i(AdState.showing, adType: 'PrivacyOptionsForm', message: 'Opening user privacy options form.');

    final completer = Completer<bool>();
    AdSuppression.suppressNextAppOpen();
    try {
      ConsentForm.showPrivacyOptionsForm((formError) {
        if (formError != null) {
          AdLogger.w(
            AdState.showFailed,
            adType: 'PrivacyOptionsForm',
            message: 'Privacy options form failed: [${formError.errorCode}] ${formError.message}',
          );
          completer.complete(false);
        } else {
          AdLogger.i(
            AdState.dismissed,
            adType: 'PrivacyOptionsForm',
            message: 'Privacy options form completed successfully.',
          );
          completer.complete(true);
        }
      });
    } catch (e) {
      AdLogger.e(
        AdState.showFailed,
        adType: 'PrivacyOptionsForm',
        message: 'Exception showing privacy options form',
        error: e,
      );
      return false;
    }
    return completer.future;
  }

  /// Checks if GDPR privacy options form is required.
  Future<bool> isPrivacyOptionsRequired({required bool isPremium}) async {
    if (isPremium) return false;
    try {
      final status = await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      return false;
    }
  }
}
