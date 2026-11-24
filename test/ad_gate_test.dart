import 'dart:async';

import 'package:castflow/features/monetization/domain/ad_gate.dart';
import 'package:castflow/features/monetization/domain/ad_suppression.dart';
import 'package:castflow/features/monetization/presentation/ad_display_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AdDisplayCoordinator coordinator;

  setUp(() {
    coordinator = AdDisplayCoordinator();
    AdGate.register(coordinator.waitUntilClear);
    AdGate.settle = const Duration(milliseconds: 10);
    AdGate.afterClose = const Duration(milliseconds: 20);
  });

  tearDown(() {
    AdGate.unregister(coordinator.waitUntilClear);
    AdGate.settle = const Duration(milliseconds: 80);
    AdGate.afterClose = const Duration(milliseconds: 300);
    AdSuppression.reset();
    coordinator.dispose();
  });

  test('no ad on screen: the prompt opens right away', () async {
    var prompted = false;
    await AdGate.afterAds(() async => prompted = true);
    expect(prompted, isTrue);
  });

  test('an interstitial is showing: the permission prompt opens only after it is dismissed', () async {
    final dismissed = Completer<void>();
    final events = <String>[];
    // The ad goes up first (as when the same tap counted toward the click interstitial)...
    unawaited(
      coordinator.present(
        adType: 'click_interstitial',
        isPremium: false,
        displayAction: () async {
          events.add('ad shown');
          await dismissed.future;
          events.add('ad dismissed');
        },
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 5));
    // ...and the screen asks for a permission at the same moment.
    final prompt = AdGate.afterAds(() async => events.add('permission prompt'));
    await Future<void>.delayed(const Duration(milliseconds: 150));
    expect(events, ['ad shown'], reason: 'the prompt must not appear over the ad');

    dismissed.complete();
    await prompt;
    expect(events, ['ad shown', 'ad dismissed', 'permission prompt']);
  });

  test('an ad that starts a moment after the tap is still waited for', () async {
    final dismissed = Completer<void>();
    final events = <String>[];
    final prompt = AdGate.afterAds(() async => events.add('permission prompt'));
    // The tap's click is counted a few ms later and the ad goes up while the gate settles.
    await Future<void>.delayed(const Duration(milliseconds: 2));
    unawaited(
      coordinator.present(
        adType: 'click_interstitial',
        isPremium: false,
        displayAction: () async {
          events.add('ad shown');
          await dismissed.future;
        },
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(events, ['ad shown']);
    dismissed.complete();
    await prompt;
    expect(events, ['ad shown', 'permission prompt']);
  });

  test('the prompt still runs App Open suppressed (returning from it is not an App Open moment)', () async {
    var marked = false;
    await AdGate.afterAds(() async => marked = AdSuppression.take());
    expect(marked, isTrue);
  });
}
