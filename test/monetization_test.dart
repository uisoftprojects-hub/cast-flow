import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/app_flow/domain/flow_config.dart';
import 'package:castflow/features/monetization/domain/ad_adapter.dart';
import 'package:castflow/features/monetization/domain/ad_config.dart';
import 'package:castflow/features/monetization/domain/ad_models.dart';
import 'package:castflow/features/monetization/presentation/native_ad_card.dart';
import 'package:castflow/features/monetization/presentation/native_ad_manager.dart';
import 'package:castflow/core/app_providers.dart';
import 'package:castflow/features/premium/data/fake_billing_service.dart';
import 'package:castflow/features/premium/domain/billing.dart';
import 'package:castflow/features/premium/domain/premium_status_service.dart';
import 'package:castflow/features/premium/presentation/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class _FakeNativeAd extends LoadedNativeAd {
  int buildCount = 0;
  bool isDisposed = false;

  @override
  Widget build(BuildContext context) {
    buildCount++;
    return const SizedBox(height: 120, child: Text('Fake Native Ad'));
  }

  @override
  void dispose() {
    isDisposed = true;
  }
}

class _TestAdapter implements AdAdapter {
  final List<String> loadedPlacements = [];

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> canRequestAds() async => true;

  @override
  Future<LoadedNativeAd> loadNative(
    AdPlacement p, {
    required bool medium,
    required VoidCallback onImpression,
    required VoidCallback onClicked,
  }) async {
    loadedPlacements.add(p.name);
    return _FakeNativeAd();
  }

  @override
  Future<LoadedFullScreenAd> loadInterstitial([
    AdPlacement placement = AdPlacement.clickInterstitial,
  ]) async {
    throw UnimplementedError();
  }

  @override
  Future<LoadedFullScreenAd> loadAppOpen() async {
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('1. AdMob Configuration: Debug vs Release Isolation', () {
    test('Debug mode strictly uses official Google AdMob test IDs', () {
      AdMobConfig.debugOverrideIsRelease = false;

      // In debug mode, must return test IDs starting with official Google test publisher prefix
      final interstitialId = AdMobConfig.unitId(AdPlacement.interstitial);
      final nativeId = AdMobConfig.unitId(AdPlacement.languageFirstRun);
      final appOpenId = AdMobConfig.unitId(AdPlacement.appOpen);

      expect(interstitialId, AdMobConfig.testInterstitialAndroid);
      expect(nativeId, AdMobConfig.testNativeVideoAndroid);
      expect(appOpenId, AdMobConfig.testAppOpenAndroid);
      expect(interstitialId, contains('3940256099942544'));
      expect(nativeId, contains('3940256099942544'));
      expect(appOpenId, contains('3940256099942544'));

      // Check all centralized getters in debug mode
      expect(AdMobConfig.appOpenAdUnitId, AdMobConfig.testAppOpenAndroid);
      expect(
        AdMobConfig.languageNativeAdUnitId,
        AdMobConfig.testNativeVideoAndroid,
      );
      expect(
        AdMobConfig.onboardingNativeAdUnitId,
        AdMobConfig.testNativeVideoAndroid,
      );
      expect(
        AdMobConfig.splashInterstitialFirstAdUnitId,
        AdMobConfig.testInterstitialAndroid,
      );
      expect(
        AdMobConfig.splashInterstitialSecondAdUnitId,
        AdMobConfig.testInterstitialAndroid,
      );
      expect(
        AdMobConfig.clickInterstitialAdUnitId,
        AdMobConfig.testInterstitialAndroid,
      );
      expect(AdMobConfig.homeNativeAdUnitId, AdMobConfig.testNativeAndroid);
    });

    test(
      'Release mode strictly uses production Cast to TV IDs and rejects test IDs',
      () {
        AdMobConfig.debugOverrideIsRelease = true;
        AdMobConfig.debugOverrideNativeIds = null;

        // App ID
        expect(
          AdMobConfig.prodAppIdAndroid,
          'ca-app-pub-3116238716336403~3352823507',
        );

        // Verify exact production IDs for all 7 placements
        expect(
          AdMobConfig.appOpenAdUnitId,
          'ca-app-pub-3116238716336403/1820249985',
        );
        expect(
          AdMobConfig.languageNativeAdUnitId,
          'ca-app-pub-3116238716336403/7288199082',
        );
        expect(
          AdMobConfig.onboardingNativeAdUnitId,
          'ca-app-pub-3116238716336403/4343692730',
        );
        expect(
          AdMobConfig.splashInterstitialFirstAdUnitId,
          'ca-app-pub-3116238716336403/9914362422',
        );
        expect(
          AdMobConfig.splashInterstitialSecondAdUnitId,
          'ca-app-pub-3116238716336403/5787415153',
        );
        expect(
          AdMobConfig.clickInterstitialAdUnitId,
          'ca-app-pub-3116238716336403/9252192456',
        );
        expect(
          AdMobConfig.homeNativeAdUnitId,
          'ca-app-pub-3116238716336403/2742624427',
        );

        // Verify no test IDs in release mode
        for (final placement in AdPlacement.values) {
          final id = AdMobConfig.unitId(placement);
          expect(id, isNot(contains('3940256099942544')));
        }

        // Cleanup
        AdMobConfig.debugOverrideIsRelease = null;
      },
    );

    test('Release mode overrides take precedence over defaults', () {
      AdMobConfig.debugOverrideIsRelease = true;
      AdMobConfig.debugOverrideNativeIds = {
        'interstitial': 'ca-app-pub-1234567890123456/1111111111',
        'languageFirstRun': 'ca-app-pub-1234567890123456/2222222222',
        'appOpen': 'ca-app-pub-1234567890123456/3333333333',
      };

      final interstitialId = AdMobConfig.unitId(AdPlacement.interstitial);
      final nativeId = AdMobConfig.unitId(AdPlacement.languageFirstRun);
      final appOpenId = AdMobConfig.unitId(AdPlacement.appOpen);

      expect(interstitialId, 'ca-app-pub-1234567890123456/1111111111');
      expect(nativeId, 'ca-app-pub-1234567890123456/2222222222');
      expect(appOpenId, 'ca-app-pub-1234567890123456/3333333333');

      // Cleanup
      AdMobConfig.debugOverrideIsRelease = null;
      AdMobConfig.debugOverrideNativeIds = null;
    });
  });

  group('2. Premium Status Service (Rule 1 Priority)', () {
    late ProviderContainer c;

    setUp(() async {
      c = await makeContainer();
    });

    tearDown(() {
      c.dispose();
    });

    test(
      'fresh installation with no active subscription defaults to non-premium',
      () async {
        final service = c.read(premiumStatusServiceProvider);
        final isPremium = await service.verifyStartupEntitlement();
        expect(isPremium, isFalse);
        expect(service.isPremium, isFalse);
      },
    );

    test(
      'active verified purchase sets premium and persists authoritative entitlement',
      () async {
        // The store is the authority: it must still own the subscription when
        // startup verification asks, otherwise a local flag would be revoked.
        final expiry = DateTime.now().add(const Duration(days: 365));
        final store = FakeBillingService(() => PreviewMode.live)
          ..setSimulatedSubscription(
            productId: BillingConfig.weekly,
            active: true,
            expiry: expiry,
          );
        final owned = await makeContainer(
          overrides: [billingServiceProvider.overrideWithValue(store)],
        );
        final service = owned.read(premiumStatusServiceProvider);

        service.applyPurchase(productId: BillingConfig.weekly, expiry: expiry);
        expect(service.isPremium, isTrue);

        // Startup verification recognizes the entitlement the store confirms
        final verified = await service.verifyStartupEntitlement();
        expect(verified, isTrue);
      },
    );

    test(
      'a local purchase flag the store does not confirm is revoked at startup',
      () async {
        final service = c.read(
          premiumStatusServiceProvider,
        ); // store owns nothing
        service.applyPurchase(
          productId: BillingConfig.weekly,
          expiry: DateTime.now().add(const Duration(days: 365)),
        );
        expect(service.isPremium, isTrue);
        expect(await service.verifyStartupEntitlement(), isFalse);
      },
    );

    test('expired subscription safely revokes premium status', () async {
      final service = c.read(premiumStatusServiceProvider);
      final past = DateTime.now().subtract(const Duration(days: 10));

      service.applyPurchase(
        productId: BillingConfig.weekly,
        expiry: past, // Expired in the past
      );
      expect(service.isPremium, isFalse);
    });
  });

  group('3. Application Opening Flows (Flow A, B, C)', () {
    test(
      'Flow A (first-time user): Splash → Language → Onboarding → Paywall → Home',
      () {
        final flow = buildFlow(
          config: const FlowConfig(),
          firstLaunchCompleted: false,
          onboardingDone: false,
          languageChosen: false,
          isPremium: false,
        );

        expect(flow, [
          FlowStep.language,
          FlowStep.onboarding,
          FlowStep.paywall,
          FlowStep.home,
        ]);
      },
    );

    test('Flow B (returning non-premium): Splash → Paywall → Home', () {
      final flow = buildFlow(
        config: const FlowConfig(),
        firstLaunchCompleted: true,
        onboardingDone: true,
        languageChosen: true,
        isPremium: false,
      );

      expect(flow, [FlowStep.paywallReturning, FlowStep.home]);
    });

    test(
      'Flow C (premium user): never sees a paywall; first run still sets language + onboarding',
      () {
        final firstRun = buildFlow(
          config: const FlowConfig(),
          firstLaunchCompleted: false,
          onboardingDone: false,
          languageChosen: false,
          isPremium: true,
        );
        expect(firstRun, [
          FlowStep.language,
          FlowStep.onboarding,
          FlowStep.home,
        ]);

        final returning = buildFlow(
          config: const FlowConfig(),
          firstLaunchCompleted: true,
          onboardingDone: true,
          languageChosen: true,
          isPremium: true,
        );
        expect(returning, [FlowStep.home]);
      },
    );
  });

  group('4. Native Ads Preloading & Single Instance on Onboarding', () {
    late _TestAdapter testAdapter;
    late NativeAdManager nativeManager;

    setUp(() {
      testAdapter = _TestAdapter();
      nativeManager = NativeAdManager(adapter: testAdapter);
    });

    tearDown(() {
      nativeManager.dispose();
    });

    test('preloads language native ad for first launch', () async {
      await nativeManager.preloadLanguageAd(isPremium: false);
      expect(testAdapter.loadedPlacements, contains('languageFirstRun'));
      expect(nativeManager.preloadedLanguageAd, isNotNull);

      // Serving it reuses the loaded instance: no second request
      final ad = await nativeManager.getOrLoadLanguageAd(
        isPremium: false,
        fromSettings: false,
      );
      expect(ad, isNotNull);
      expect(nativeManager.preloadedLanguageAd, same(ad));
      expect(
        testAdapter.loadedPlacements.where((p) => p == 'languageFirstRun'),
        hasLength(1),
      );
    });

    test('reopening Language mid-load joins the running request', () async {
      final first = nativeManager.getOrLoadLanguageAd(
        isPremium: false,
        fromSettings: true,
      );
      final second = nativeManager.getOrLoadLanguageAd(
        isPremium: false,
        fromSettings: true,
      );
      expect(await first, same(await second));
      expect(testAdapter.loadedPlacements, hasLength(1));
    });

    test(
      'preloads single onboarding native ad instance across multiple slides',
      () async {
        await nativeManager.preloadOnboardingAd(isPremium: false);
        expect(testAdapter.loadedPlacements, contains('onboarding'));

        // Across slide 1, slide 2, slide 3, getOrLoadOnboardingAd returns the exact SAME loaded instance
        final instance1 = await nativeManager.getOrLoadOnboardingAd(
          isPremium: false,
        );
        final instance2 = await nativeManager.getOrLoadOnboardingAd(
          isPremium: false,
        );
        expect(identical(instance1, instance2), isTrue);
      },
    );

    test(
      'purchasing premium immediately disposes preloaded ads and clears cache',
      () async {
        await nativeManager.preloadLanguageAd(isPremium: false);
        await nativeManager.preloadOnboardingAd(isPremium: false);
        expect(nativeManager.preloadedLanguageAd, isNotNull);

        // Premium purchased!
        nativeManager.onPremiumPurchased();
        expect(nativeManager.preloadedLanguageAd, isNull);
        expect(nativeManager.activeOnboardingAd, isNull);
      },
    );
  });

  group('5. Native Ad On-Demand Loading Rules (No Preload)', () {
    late _TestAdapter testAdapter;
    late NativeAdManager nativeManager;

    setUp(() {
      testAdapter = _TestAdapter();
      nativeManager = NativeAdManager(adapter: testAdapter);
    });

    tearDown(() {
      nativeManager.dispose();
    });

    test(
      'Rule 1: First open language screen sends request strictly on landing (no preload)',
      () async {
        // Before landing, no preload exists and no ad request is dispatched
        expect(testAdapter.loadedPlacements, isEmpty);
        expect(nativeManager.preloadedLanguageAd, isNull);

        // User lands on LanguageScreen (fromSettings: false)
        final ad = await nativeManager.getOrLoadLanguageAd(
          isPremium: false,
          fromSettings: false,
        );

        // Request was sent directly for languageFirstRun on landing
        expect(testAdapter.loadedPlacements, equals(['languageFirstRun']));
        expect(ad, isNotNull);
      },
    );

    test(
      'Rule 2: Onboarding native ad sends request strictly on landing on 1st slide (no preload), and reuses instance',
      () async {
        // Before landing on onboarding, no preload exists
        expect(testAdapter.loadedPlacements, isEmpty);
        expect(nativeManager.activeOnboardingAd, isNull);

        // User lands on 1st onboarding screen
        final slide1Ad = await nativeManager.getOrLoadOnboardingAd(
          isPremium: false,
        );

        expect(testAdapter.loadedPlacements, equals(['onboarding']));
        expect(slide1Ad, isNotNull);

        // Across slide 2 and slide 3, NO new request is made; the same active instance is reused
        final slide2Ad = await nativeManager.getOrLoadOnboardingAd(
          isPremium: false,
        );
        final slide3Ad = await nativeManager.getOrLoadOnboardingAd(
          isPremium: false,
        );

        expect(testAdapter.loadedPlacements.length, equals(1));
        expect(identical(slide1Ad, slide2Ad), isTrue);
        expect(identical(slide2Ad, slide3Ad), isTrue);
      },
    );

    test(
      'Rule 3: Settings language screen sends fresh request strictly on landing with languageSettings (no preload)',
      () async {
        expect(testAdapter.loadedPlacements, isEmpty);

        // User lands on Settings -> Language
        final settingsAd = await nativeManager.getOrLoadLanguageAd(
          isPremium: false,
          fromSettings: true,
        );

        // Request was sent strictly for languageSettings on landing
        expect(testAdapter.loadedPlacements, equals(['languageSettings']));
        expect(settingsAd, isNotNull);
      },
    );
  });

  group('6. Custom Native Ad Visual Design (35% Left / 65% Right)', () {
    testWidgets(
      'NativeAdCard renders 35% left advertiser icon & 65% right content',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 360,
                  child: NativeAdCard(
                    title: 'Advertiser Title',
                    description: 'Advertiser description text goes here.',
                    ctaText: 'Install',
                    onCtaPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.text('AD'), findsOneWidget);
        expect(find.text('Advertiser Title'), findsOneWidget);
        expect(
          find.text('Advertiser description text goes here.'),
          findsOneWidget,
        );
        expect(find.text('Install'), findsOneWidget);

        // Find the two layout sections
        final leftFinder = find.byKey(const ValueKey('native_ad_left_35'));
        final rightFinder = find.byKey(const ValueKey('native_ad_right_65'));
        expect(leftFinder, findsOneWidget);
        expect(rightFinder, findsOneWidget);

        final leftSize = tester.getSize(leftFinder);
        final rightSize = tester.getSize(rightFinder);

        // Left section flex is 35, right section flex is 65 (ratio ~ 35/65)
        final ratio = leftSize.width / rightSize.width;
        expect(ratio, closeTo(35 / 65, 0.05));
      },
    );
  });
}
