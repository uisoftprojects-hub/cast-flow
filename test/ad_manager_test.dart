import 'dart:async';

import 'package:castflow/features/app_flow/domain/flow_config.dart';
import 'package:castflow/features/app_flow/presentation/app_flow_controller.dart';
import 'package:castflow/features/monetization/domain/ad_adapter.dart';
import 'package:castflow/features/monetization/domain/ad_config.dart';
import 'package:castflow/features/monetization/domain/ad_models.dart';
import 'package:castflow/features/monetization/presentation/ad_manager.dart';
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

/// Adapter whose loads complete only when the test says so.
class _Adapter implements AdAdapter {
  final interstitialLoads = <Completer<LoadedFullScreenAd>>[];
  final appOpenLoads = <Completer<LoadedFullScreenAd>>[];

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> canRequestAds() async => true;

  @override
  Future<LoadedNativeAd> loadNative(AdPlacement p,
          {required bool medium, required VoidCallback onImpression, required VoidCallback onClicked}) =>
      Completer<LoadedNativeAd>().future;

  @override
  Future<LoadedFullScreenAd> loadInterstitial() {
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

Future<void> _settle() => Future<void>.delayed(AdConfig.showDelay + const Duration(milliseconds: 100));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Adapter adapter;
  late DateTime now;
  late ProviderContainer c;
  late AdManager ads;

  setUp(() async {
    adapter = _Adapter();
    now = DateTime(2026, 11, 1, 12);
    c = await makeContainer(overrides: [
      adAdapterProvider.overrideWithValue(adapter),
      adClockProvider.overrideWithValue(() => now),
    ]);
    c.listen(adManagerProvider, (_, _) {});
    ads = c.read(adManagerProvider.notifier);
    c.read(adRouteObserverProvider).debugTopIsSafe = true;
    await ads.ensureInitialized();
  });

  PlacementState interstitial() => c.read(adManagerProvider).placements[AdPlacement.interstitial]!;

  group('five-click interstitial', () {
    test('clicks 1-2 request nothing, click 3 loads once, click 5 shows', () async {
      ads.registerEligibleClick();
      ads.registerEligibleClick();
      expect(adapter.interstitialLoads, isEmpty);

      ads.registerEligibleClick();
      expect(adapter.interstitialLoads.length, 1);
      ads.registerEligibleClick();
      expect(adapter.interstitialLoads.length, 1, reason: 'click 4 must not reload');

      final ad = _Ad();
      adapter.interstitialLoads.single.complete(ad);
      await Future<void>.delayed(Duration.zero);

      ads.registerEligibleClick();
      await _settle();
      expect(ad.shows, 1);
      expect(interstitial().impressionCount, 1);
      // The next cycle starts only after dismiss, with no request yet.
      expect(c.read(adManagerProvider).clickCount, 0);
      expect(adapter.interstitialLoads.length, 1);
    });

    test('an ad that loads after its click-5 opportunity is discarded', () async {
      for (var i = 0; i < 5; i++) {
        ads.registerEligibleClick();
      }
      expect(c.read(adManagerProvider).clickCount, 0, reason: 'cycle ended at click 5');

      final late = _Ad();
      adapter.interstitialLoads.single.complete(late);
      await Future<void>.delayed(Duration.zero);
      expect(late.disposed, isTrue);
      expect(late.shows, 0);

      // It must not appear on later clicks either.
      ads.registerEligibleClick();
      ads.registerEligibleClick();
      await _settle();
      expect(late.shows, 0);
      expect(c.read(adManagerProvider).events.any((e) => e.type == AdEventType.discarded), isTrue);
    });

    test('no fill ends the attempt and starts a cooldown without retrying', () async {
      for (var i = 0; i < 3; i++) {
        ads.registerEligibleClick();
      }
      adapter.interstitialLoads.single.completeError('no fill');
      await Future<void>.delayed(Duration.zero);

      expect(interstitial().inCooldown(now), isTrue);
      for (var i = 0; i < 5; i++) {
        ads.registerEligibleClick();
      }
      expect(adapter.interstitialLoads.length, 1, reason: 'no request spam during cooldown');

      now = now.add(AdConfig.failureCooldown + const Duration(seconds: 1));
      for (var i = 0; i < 3; i++) {
        ads.registerEligibleClick();
      }
      expect(adapter.interstitialLoads.length, 2);
    });

    test('a blocked screen at click 5 discards instead of showing', () async {
      for (var i = 0; i < 3; i++) {
        ads.registerEligibleClick();
      }
      final ad = _Ad();
      adapter.interstitialLoads.single.complete(ad);
      await Future<void>.delayed(Duration.zero);
      c.read(adRouteObserverProvider).debugTopIsSafe = false;
      ads.registerEligibleClick();
      ads.registerEligibleClick();
      await _settle();
      expect(ad.shows, 0);
      expect(ad.disposed, isTrue);
    });

    test('Pro users never get a request', () async {
      c.read(settingsProvider.notifier).setPremium(true);
      for (var i = 0; i < 5; i++) {
        ads.registerEligibleClick();
      }
      expect(adapter.interstitialLoads, isEmpty);
    });
  });

  group('App Open', () {
    void finishFlow() {
      c.read(settingsProvider.notifier).completeFirstLaunch();
      final flow = c.read(appFlowProvider.notifier)..start();

      flow.advance(FlowStep.paywallReturning);

    }

    test('not before the user has reached the app', () async {
      ads.onBackgrounded();
      now = now.add(const Duration(seconds: 10));
      await ads.onResumed();
      expect(adapter.appOpenLoads, isEmpty);
    });

    test('ignores very short trips to the background', () async {
      finishFlow();
      ads.onBackgrounded();
      now = now.add(const Duration(seconds: 1));
      await ads.onResumed();
      expect(adapter.appOpenLoads, isEmpty);
    });

    test('loads on a qualifying resume, shows once, then respects the cap', () async {
      finishFlow();
      ads.onBackgrounded();
      now = now.add(const Duration(seconds: 10));
      final resumed = ads.onResumed();
      expect(c.read(adManagerProvider).appOpenOverlay, isTrue);
      expect(adapter.appOpenLoads.length, 1);

      final ad = _Ad();
      adapter.appOpenLoads.single.complete(ad);
      await resumed;
      expect(ad.shows, 1);
      expect(c.read(adManagerProvider).appOpenOverlay, isFalse);

      ads.onBackgrounded();
      now = now.add(const Duration(minutes: 5));
      await ads.onResumed();
      expect(adapter.appOpenLoads.length, 1, reason: 'frequency cap');
    });

    test('a failed load removes the overlay', () async {
      finishFlow();
      ads.onBackgrounded();
      now = now.add(const Duration(seconds: 10));
      final resumed = ads.onResumed();
      adapter.appOpenLoads.single.completeError('timeout');
      await resumed;
      expect(c.read(adManagerProvider).appOpenOverlay, isFalse);
    });
  });
}
