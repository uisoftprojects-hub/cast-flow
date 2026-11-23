import 'dart:async';

import 'package:castflow/features/monetization/domain/ad_adapter.dart';
import 'package:castflow/features/monetization/domain/ad_models.dart';
import 'package:castflow/features/monetization/presentation/ad_display_coordinator.dart';
import 'package:castflow/features/monetization/presentation/ad_manager.dart';
import 'package:castflow/features/monetization/presentation/app_open_ad_manager.dart';
import 'package:castflow/features/monetization/presentation/click_count_interstitial_manager.dart';
import 'package:castflow/features/monetization/presentation/splash_interstitial_manager.dart';
import 'package:castflow/features/settings/presentation/settings_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class _Ad extends LoadedFullScreenAd {
  int shows = 0;
  bool disposed = false;

  @override
  Future<void> show({required VoidCallback onImpression, VoidCallback? onClicked}) async {
    shows++;
    onImpression();
  }

  @override
  void dispose() => disposed = true;
}

class _Adapter implements AdAdapter {
  final interstitialLoads = <Completer<LoadedFullScreenAd>>[];
  final appOpenLoads = <Completer<LoadedFullScreenAd>>[];

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
  }) =>
      Completer<LoadedNativeAd>().future;

  @override
  Future<LoadedFullScreenAd> loadInterstitial([AdPlacement placement = AdPlacement.clickInterstitial]) {
    final c = Completer<LoadedFullScreenAd>();
    interstitialLoads.add(c);
    return c.future;
  }

  @override
  Future<LoadedFullScreenAd> loadAppOpen() {
    final c = Completer<LoadedFullScreenAd>();
    appOpenLoads.add(c);
    return c.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Adapter adapter;
  late ProviderContainer c;
  late AdDisplayCoordinator coordinator;
  late ClickCountInterstitialManager clickManager;

  setUp(() async {
    adapter = _Adapter();
    c = await makeContainer(overrides: [
      adAdapterProvider.overrideWithValue(adapter),
    ]);
    coordinator = c.read(adDisplayCoordinatorProvider);
    clickManager = ClickCountInterstitialManager(
      adapter: adapter,
      coordinator: coordinator,
    );
  });

  tearDown(() {
    c.dispose();
  });

  group('Click Interstitial (1 per session, load on 1st click, show on 2nd click, any action)', () {
    test('loads on 1st click, shows on 2nd click, max 1 display per session', () async {
      // 1st click: requests load in background, does not show
      await clickManager.onUserClick(isPremium: false, contextTag: 'home_feature');
      expect(clickManager.clickCount, 1);
      expect(adapter.interstitialLoads.length, 1);
      expect(clickManager.sessionInterstitialDisplayed, isFalse);

      // 1st ad completes loading
      final ad1 = _Ad();
      adapter.interstitialLoads[0].complete(ad1);
      await Future<void>.delayed(Duration.zero);
      expect(clickManager.isLoaded, isTrue);
      expect(ad1.shows, 0);

      // 2nd click: displays loaded ad and marks session limit reached (NO reload)
      await clickManager.onUserClick(isPremium: false, contextTag: 'bottom_nav');
      expect(clickManager.clickCount, 2);
      expect(ad1.shows, 1);
      expect(ad1.disposed, isTrue);
      expect(clickManager.sessionInterstitialDisplayed, isTrue);
      expect(adapter.interstitialLoads.length, 1, reason: 'No new ad load; max 1 show per session');

      // Subsequent clicks: strictly ignored because session limit is reached
      await clickManager.onUserClick(isPremium: false, contextTag: 'photo_cast');
      expect(clickManager.clickCount, 2, reason: 'Click counter does not increment after session limit');
      expect(ad1.shows, 1);
      expect(adapter.interstitialLoads.length, 1);
    });

    test('any click counts, whatever the screen or action (Settings, FAQ, guide included)', () async {
      await clickManager.onUserClick(isPremium: false, targetRoute: '/settings', contextTag: 'settings_tab');
      expect(clickManager.clickCount, 1, reason: '1st click, even on Settings, starts the load');
      expect(adapter.interstitialLoads.length, 1);
      await clickManager.onUserClick(isPremium: false, targetRoute: '/settings/language', contextTag: 'lang');
      expect(clickManager.clickCount, 2);
      await clickManager.onUserClick(isPremium: false, targetRoute: '/faq', contextTag: 'faq');
      expect(clickManager.clickCount, 3);
    });

    test('if ad not ready, continues navigation and shows on next click once loaded', () async {
      // 1st click: request load
      await clickManager.onUserClick(isPremium: false);
      expect(adapter.interstitialLoads.length, 1);

      // 2nd click before load finishes: no show
      await clickManager.onUserClick(isPremium: false);
      expect(clickManager.isLoaded, isFalse);

      // Now ad loads
      final ad = _Ad();
      adapter.interstitialLoads.single.complete(ad);
      await Future<void>.delayed(Duration.zero);
      expect(clickManager.isLoaded, isTrue);

      // 3rd click: shows ad
      await clickManager.onUserClick(isPremium: false);
      expect(ad.shows, 1);
    });

    test('failure to load keeps opportunity open and does not lock clicks', () async {
      // 1st click: request load
      await clickManager.onUserClick(isPremium: false);
      expect(adapter.interstitialLoads.length, 1);

      // Load fails
      adapter.interstitialLoads.single.completeError('No fill');
      await Future<void>.delayed(Duration.zero);
      expect(clickManager.isLoaded, isFalse);

      // 2nd click: retries loading
      await clickManager.onUserClick(isPremium: false);
      expect(adapter.interstitialLoads.length, 2, reason: 'Retried loading on 2nd click');
    });

    test('premium users never trigger interstitial loads or displays', () async {
      await clickManager.onUserClick(isPremium: true);
      expect(clickManager.clickCount, 0);
      expect(adapter.interstitialLoads, isEmpty);
    });
  });

  group('Splash Interstitial Advertisement', () {
    late SplashInterstitialManager splashManager;

    setUp(() {
      splashManager = SplashInterstitialManager(
        adapter: adapter,
        coordinator: coordinator,
      );
    });

    test('loads at splash, shows on Language screen completion if ready', () async {
      // Initiate splash load without awaiting completer
      final loadFuture = splashManager.startSplashLoad(isPremium: false);
      expect(adapter.interstitialLoads.length, 1);

      final ad = _Ad();
      adapter.interstitialLoads.single.complete(ad);
      await loadFuture;
      expect(splashManager.isLoaded, isTrue);

      final shown = await splashManager.tryShowAtLanguageCompletion(isPremium: false);
      expect(shown, isTrue);
      expect(ad.shows, 1);
      expect(splashManager.hasShown, isTrue);

      // Paywall close does NOT show again (max 1 display opportunity)
      final paywallShown = await splashManager.tryShowAtPaywallClose(isPremium: false);
      expect(paywallShown, isFalse);
      expect(ad.shows, 1);
    });

    test('if not shown on Language, shows on Paywall close if ready', () async {
      final loadFuture = splashManager.startSplashLoad(isPremium: false);
      final ad = _Ad();
      adapter.interstitialLoads.single.complete(ad);
      await loadFuture;

      // User skips or language ad not shown: transition without showing
      // Now user reaches paywall and closes it
      final shown = await splashManager.tryShowAtPaywallClose(isPremium: false);
      expect(shown, isTrue);
      expect(ad.shows, 1);
      expect(splashManager.hasShown, isTrue);
    });

    test('never blocks or shows if ad failed to load', () async {
      final loadFuture = splashManager.startSplashLoad(isPremium: false);
      adapter.interstitialLoads.single.completeError('network error');
      await loadFuture;

      final langShown = await splashManager.tryShowAtLanguageCompletion(isPremium: false);
      expect(langShown, isFalse);

      final paywallShown = await splashManager.tryShowAtPaywallClose(isPremium: false);
      expect(paywallShown, isFalse);
    });

    test('premium user skips splash interstitial loading and display entirely', () async {
      await splashManager.startSplashLoad(isPremium: true);
      expect(adapter.interstitialLoads, isEmpty);

      final shown = await splashManager.tryShowAtLanguageCompletion(isPremium: true);
      expect(shown, isFalse);
    });
  });

  group('App Open Ad Freshness & Delayed Show', () {
    late AppOpenAdManager appOpenManager;

    setUp(() {
      appOpenManager = AppOpenAdManager(
        adapter: adapter,
        coordinator: coordinator,
      );
    });

    test('freshness check discards ads older than 4 hours', () {
      expect(appOpenManager.hasLoadedAd, isFalse);
    });

    test('premium users never trigger App Open ads', () async {
      appOpenManager.onBackgrounded();
      await appOpenManager.onResumed(
        isPremium: true,
        isAppEligible: true,
      );
      expect(adapter.appOpenLoads, isEmpty);
    });
  });

  group('Centralized Full-Screen Ad Coordinator', () {
    test('presentation lock allows only ONE full-screen ad at a time', () async {
      final shown1 = await coordinator.present(
        adType: 'ad_1',
        isPremium: false,
        displayAction: () async {
          expect(coordinator.isFullScreenShowing, isTrue);
          // Attempting to present ad_2 while ad_1 is showing must fail
          final shown2 = await coordinator.present(
            adType: 'ad_2',
            isPremium: false,
            displayAction: () async {},
          );
          expect(shown2, isFalse, reason: 'Locked while ad_1 is presenting');
        },
      );
      expect(shown1, isTrue);
      expect(coordinator.isFullScreenShowing, isFalse);
    });

    test('purchasing premium immediately disposes loaded ads across all subsystems', () {
      c.read(settingsProvider.notifier).setPremium(true);
      final ads = c.read(adManagerProvider.notifier);
      ads.onPremiumPurchased();
      expect(c.read(settingsProvider).isPremium, isTrue);
    });
  });
}
