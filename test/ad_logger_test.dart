import 'package:castflow/features/monetization/domain/ad_config.dart';
import 'package:castflow/features/monetization/domain/ad_logger.dart';
import 'package:castflow/features/monetization/domain/ad_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdLogger Logcat & Ad State Transitions', () {
    test('logs all AdState values without throwing', () {
      for (final state in AdState.values) {
        expect(
          () => AdLogger.log(
            state: state,
            placement: AdPlacement.clickInterstitial,
            adType: 'Interstitial',
            unitId: 'ca-app-pub-3940256099942544/1033173712',
            message: 'Test state transition ${state.name}',
            level: AdLogLevel.info,
          ),
          returnsNormally,
        );
      }
    });

    test('helper methods d, i, w, e work correctly', () {
      expect(
        () => AdLogger.d(
          AdState.requestStart,
          placement: AdPlacement.languageFirstRun,
          adType: 'Native',
          unitId: AdMobConfig.unitId(AdPlacement.languageFirstRun),
          message: 'Debug level state logged',
        ),
        returnsNormally,
      );

      expect(
        () => AdLogger.i(
          AdState.loaded,
          placement: AdPlacement.splashInterstitialFirst,
          adType: 'SplashInterstitial',
          message: 'Info level state logged',
        ),
        returnsNormally,
      );

      expect(
        () => AdLogger.w(
          AdState.overlayTimeout,
          placement: AdPlacement.appOpen,
          adType: 'AppOpen',
          message: 'Warn level state logged',
        ),
        returnsNormally,
      );

      expect(
        () => AdLogger.e(
          AdState.loadFailed,
          placement: AdPlacement.onboarding,
          adType: 'Native',
          message: 'Error level state logged',
          error: Exception('Test AdMob network timeout'),
        ),
        returnsNormally,
      );
    });

    test('verifies all state categories exist in AdState enum', () {
      // Consent & SDK
      expect(AdState.values.contains(AdState.consentCheckStart), isTrue);
      expect(AdState.values.contains(AdState.consentUpdated), isTrue);
      expect(AdState.values.contains(AdState.consentFormRequired), isTrue);
      expect(AdState.values.contains(AdState.consentFormLoaded), isTrue);
      expect(AdState.values.contains(AdState.consentFormDismissed), isTrue);
      expect(AdState.values.contains(AdState.consentError), isTrue);
      expect(AdState.values.contains(AdState.sdkInitStart), isTrue);
      expect(AdState.values.contains(AdState.sdkInitSuccess), isTrue);
      expect(AdState.values.contains(AdState.sdkInitFailed), isTrue);

      // Preload & Request
      expect(AdState.values.contains(AdState.requestStart), isTrue);
      expect(AdState.values.contains(AdState.requestSkipped), isTrue);
      expect(AdState.values.contains(AdState.preloadStart), isTrue);
      expect(AdState.values.contains(AdState.preloadSuccess), isTrue);
      expect(AdState.values.contains(AdState.preloadConsumed), isTrue);

      // Outcome
      expect(AdState.values.contains(AdState.loaded), isTrue);
      expect(AdState.values.contains(AdState.loadFailed), isTrue);
      expect(AdState.values.contains(AdState.noFill), isTrue);

      // Presentation
      expect(AdState.values.contains(AdState.showRequested), isTrue);
      expect(AdState.values.contains(AdState.showing), isTrue);
      expect(AdState.values.contains(AdState.opened), isTrue);
      expect(AdState.values.contains(AdState.impression), isTrue);
      expect(AdState.values.contains(AdState.clicked), isTrue);
      expect(AdState.values.contains(AdState.dismissed), isTrue);
      expect(AdState.values.contains(AdState.showFailed), isTrue);

      // App Open & Session
      expect(AdState.values.contains(AdState.backgrounded), isTrue);
      expect(AdState.values.contains(AdState.resumed), isTrue);
      expect(AdState.values.contains(AdState.expiredDiscarded), isTrue);
      expect(AdState.values.contains(AdState.overlayShowing), isTrue);
      expect(AdState.values.contains(AdState.overlayTimeout), isTrue);
      expect(AdState.values.contains(AdState.delayedShowCached), isTrue);
      expect(AdState.values.contains(AdState.clickCounterIncremented), isTrue);
      expect(AdState.values.contains(AdState.sessionCompleted), isTrue);
      expect(AdState.values.contains(AdState.coordinatorLockAcquired), isTrue);
      expect(AdState.values.contains(AdState.coordinatorLockReleased), isTrue);
      expect(AdState.values.contains(AdState.premiumPurge), isTrue);
      expect(AdState.values.contains(AdState.disposed), isTrue);
    });
  });
}
