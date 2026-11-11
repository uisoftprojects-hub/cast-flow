import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/app_flow/domain/flow_config.dart';
import 'package:castflow/features/monetization/domain/ad_adapter.dart';
import 'package:castflow/features/monetization/domain/ad_config.dart';
import 'package:castflow/features/monetization/domain/ad_models.dart';
import 'package:castflow/features/monetization/presentation/native_ad_card.dart';
import 'package:castflow/features/monetization/presentation/native_ad_manager.dart';
import 'package:castflow/features/premium/domain/billing.dart';
import 'package:castflow/features/premium/domain/premium_status_service.dart';
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
  Future<LoadedFullScreenAd> loadInterstitial([AdPlacement placement = AdPlacement.clickInterstitial]) async {
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
      expect(nativeId, AdMobConfig.testNativeAndroid);
      expect(appOpenId, AdMobConfig.testAppOpenAndroid);
      expect(interstitialId, contains('3940256099942544'));
      expect(nativeId, contains('3940256099942544'));
      expect(appOpenId, contains('3940256099942544'));

      // Check all centralized getters in debug mode
      expect(AdMobConfig.appOpenAdUnitId, AdMobConfig.testAppOpenAndroid);
      expect(AdMobConfig.languageNativeAdUnitId, AdMobConfig.testNativeAndroid);
      expect(AdMobConfig.onboardingNativeAdUnitId, AdMobConfig.testNativeAndroid);
      expect(AdMobConfig.splashInterstitialFirstAdUnitId, AdMobConfig.testInterstitialAndroid);
      expect(AdMobConfig.splashInterstitialSecondAdUnitId, AdMobConfig.testInterstitialAndroid);
      expect(AdMobConfig.clickInterstitialAdUnitId, AdMobConfig.testInterstitialAndroid);
      expect(AdMobConfig.homeNativeAdUnitId, AdMobConfig.testNativeAndroid);
    });

    test('Release mode strictly uses production Cast to TV IDs and rejects test IDs', () {
      AdMobConfig.debugOverrideIsRelease = true;
      AdMobConfig.debugOverrideNativeIds = null;

      // App ID
      expect(AdMobConfig.prodAppIdAndroid, 'ca-app-pub-3116238716336403~3352823507');

      // Verify exact production IDs for all 7 placements
      expect(AdMobConfig.appOpenAdUnitId, 'ca-app-pub-3116238716336403/1820249985');
      expect(AdMobConfig.languageNativeAdUnitId, 'ca-app-pub-3116238716336403/7288199082');
      expect(AdMobConfig.onboardingNativeAdUnitId, 'ca-app-pub-3116238716336403/4343692730');
      expect(AdMobConfig.splashInterstitialFirstAdUnitId, 'ca-app-pub-3116238716336403/9914362422');
      expect(AdMobConfig.splashInterstitialSecondAdUnitId, 'ca-app-pub-3116238716336403/5787415153');
      expect(AdMobConfig.clickInterstitialAdUnitId, 'ca-app-pub-3116238716336403/9252192456');
      expect(AdMobConfig.homeNativeAdUnitId, 'ca-app-pub-3116238716336403/2742624427');

      // Verify no test IDs in release mode
      for (final placement in AdPlacement.values) {
        final id = AdMobConfig.unitId(placement);
        expect(id, isNot(contains('3940256099942544')));
      }

      // Cleanup
      AdMobConfig.debugOverrideIsRelease = null;
    });

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

    test('fresh installation with no active subscription defaults to non-premium', () async {
      final service = c.read(premiumStatusServiceProvider);
      final isPremium = await service.verifyStartupEntitlement();
      expect(isPremium, isFalse);
      expect(service.isPremium, isFalse);
    });

    test('active verified purchase sets premium and persists authoritative entitlement', () async {
      final service = c.read(premiumStatusServiceProvider);
      final now = DateTime.now();

      service.applyPurchase(
        productId: BillingConfig.weekly,
        expiry: now.add(const Duration(days: 365)),
      );
      expect(service.isPremium, isTrue);

      // Startup verification recognizes active cached entitlement
      final verified = await service.verifyStartupEntitlement();
      expect(verified, isTrue);
    });

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
    test('Flow A (first-time user): Splash → Language → Paywall → Onboarding → Home', () {
      final flow = buildFlow(
        config: const FlowConfig(),
        firstLaunchCompleted: false,
        onboardingDone: false,
        languageChosen: false,
        isPremium: false,
      );

      expect(flow, [
        FlowStep.language,
        FlowStep.paywall,
        FlowStep.onboarding,
        FlowStep.home,
      ]);
    });

    test('Flow B (returning non-premium): Splash → Paywall → Home', () {
      final flow = buildFlow(
        config: const FlowConfig(),
        firstLaunchCompleted: true,
        onboardingDone: true,
        languageChosen: true,
        isPremium: false,
      );

      expect(flow, [
        FlowStep.paywallReturning,
        FlowStep.home,
      ]);
    });

    test('Flow C (premium user): Splash → Home (skips ads, paywall, onboarding)', () {
      final flow = buildFlow(
        config: const FlowConfig(),
        firstLaunchCompleted: false,
        onboardingDone: false,
        languageChosen: false,
        isPremium: true,
      );

      expect(flow, [FlowStep.home]);
    });
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

      // Serving it takes the loaded instance
      final ad = await nativeManager.getOrLoadLanguageAd(isPremium: false, fromSettings: false);
      expect(ad, isNotNull);
      expect(nativeManager.preloadedLanguageAd, isNull);
    });

    test('preloads single onboarding native ad instance across multiple slides', () async {
      await nativeManager.preloadOnboardingAd(isPremium: false);
      expect(testAdapter.loadedPlacements, contains('onboarding'));

      // Across slide 1, slide 2, slide 3, getOrLoadOnboardingAd returns the exact SAME loaded instance
      final instance1 = await nativeManager.getOrLoadOnboardingAd(isPremium: false);
      final instance2 = await nativeManager.getOrLoadOnboardingAd(isPremium: false);
      expect(identical(instance1, instance2), isTrue);
    });

    test('purchasing premium immediately disposes preloaded ads and clears cache', () async {
      await nativeManager.preloadLanguageAd(isPremium: false);
      await nativeManager.preloadOnboardingAd(isPremium: false);
      expect(nativeManager.preloadedLanguageAd, isNotNull);

      // Premium purchased!
      nativeManager.onPremiumPurchased();
      expect(nativeManager.preloadedLanguageAd, isNull);
      expect(nativeManager.activeOnboardingAd, isNull);
    });
  });

  group('5. Custom Native Ad Visual Design (35% Left / 65% Right)', () {
    testWidgets('NativeAdCard renders 35% left advertiser icon & 65% right content', (tester) async {
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
      expect(find.text('Advertiser description text goes here.'), findsOneWidget);
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
    });
  });
}
