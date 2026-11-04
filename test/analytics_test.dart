import 'dart:async';
import 'dart:io';

import 'package:castflow/core/analytics/analytics.dart';
import 'package:castflow/core/app_providers.dart';
import 'package:castflow/features/app_flow/domain/flow_config.dart';
import 'package:castflow/features/app_flow/presentation/app_flow_controller.dart';
import 'package:castflow/features/monetization/domain/ad_adapter.dart';
import 'package:castflow/features/monetization/domain/ad_models.dart';
import 'package:castflow/features/monetization/presentation/ad_manager.dart';
import 'package:castflow/features/premium/domain/billing.dart';
import 'package:castflow/features/premium/presentation/billing_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class _Native extends LoadedNativeAd {
  @override
  Widget build(BuildContext context) => const SizedBox();

  @override
  void dispose() {}
}

/// Native loads succeed or fail with a message; full-screen ads never load.
class _Adapter implements AdAdapter {
  _Adapter(this.nativeError);
  final String? nativeError;

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
    if (nativeError != null) throw nativeError!;
    onImpression();
    return _Native();
  }

  @override
  Future<LoadedFullScreenAd> loadInterstitial() => Completer<LoadedFullScreenAd>().future;

  @override
  Future<LoadedFullScreenAd> loadAppOpen() => Completer<LoadedFullScreenAd>().future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every event and param name follows Firebase rules and is unique', () {
    final src = File('lib/core/analytics/analytics_events.dart').readAsStringSync();
    final names = RegExp(r"static const \w+ = '([^']+)';").allMatches(src).map((m) => m.group(1)!).toList();
    expect(names, isNotEmpty);
    for (final n in names) {
      expect(Analytics.isValidName(n), isTrue, reason: n);
    }
    final events = RegExp(
      r"class AnalyticsEvent \{(.*?)\n\}",
      dotAll: true,
    ).firstMatch(src)!.group(1)!;
    final eventNames = RegExp(r"= '([^']+)';").allMatches(events).map((m) => m.group(1)).toList();
    expect(eventNames.toSet().length, eventNames.length, reason: 'duplicate event name');
  });

  test('params are cleaned to what Firebase accepts', () {
    final sink = MemoryAnalyticsSink();
    Analytics(sink).log('test_event', {
      'flag': true,
      'kind': AdRequestState.ready,
      'gone': null,
      'long': 'x' * 150,
      'wait': const Duration(seconds: 2),
    });
    final p = sink.last('test_event')!;
    expect(p['flag'], 1);
    expect(p['kind'], 'ready');
    expect(p.containsKey('gone'), isFalse);
    expect((p['long']! as String).length, 100);
    expect(p['wait'], 2000);
  });

  test('screen names come from route paths', () {
    expect(screenNameFor('/web'), 'browser');
    expect(screenNameFor('/guide?topic=mirroring'), 'guide');
    expect(screenNameFor('/settings/language'), 'language_settings');
  });

  test('first run reports the splash → home funnel in order', () async {
    final sink = MemoryAnalyticsSink();
    final c = await makeContainer(overrides: [analyticsSinkProvider.overrideWithValue(sink)]);
    c.listen(appFlowProvider, (_, _) {});
    final flow = c.read(appFlowProvider.notifier)..splashShown();
    flow.start();
    flow.advance(FlowStep.language);
    flow.advance(FlowStep.onboarding);
    flow.advance(FlowStep.paywall);

    expect(sink.names, [
      'app_launch',
      'funnel_splash_view',
      'funnel_language_view',
      'funnel_language_done',
      'funnel_onboarding_view',
      'funnel_onboarding_done',
      'funnel_paywall_view',
      'funnel_home_view',
    ]);
    expect(sink.last('app_launch')!['first_open'], 1);
    expect(sink.last('funnel_paywall_view')!['source'], 'first_open');
  });

  group('ads', () {
    Future<MemoryAnalyticsSink> loadNative({String? error}) async {
      final sink = MemoryAnalyticsSink();
      final c = await makeContainer(
        overrides: [
          analyticsSinkProvider.overrideWithValue(sink),
          adAdapterProvider.overrideWithValue(_Adapter(error)),
        ],
      );
      c.listen(adManagerProvider, (_, _) {});
      final ads = c.read(adManagerProvider.notifier);
      await ads.ensureInitialized();
      await ads.loadNative(AdPlacement.languageFirstRun);
      return sink;
    }

    test('a filled native ad reports request, impression and load with its ad name', () async {
      final sink = await loadNative();
      expect(sink.names, containsAllInOrder(['ad_request', 'ad_impression_app', 'ad_load_success']));
      final p = sink.last('ad_load_success')!;
      expect(p['ad_name'], 'native_language_first_open');
      expect(p['ad_format'], 'native');
      expect(p['load_ms'], isA<int>());
    });

    test('no fill is reported apart from other load errors', () async {
      expect((await loadNative(error: 'No fill.')).names, contains('ad_no_fill'));
      final other = await loadNative(error: 'Network error');
      expect(other.names, contains('ad_load_fail'));
      expect(other.last('ad_load_fail')!['error_message'], 'Network error');
    });
  });

  test('a purchase reports start and success with the product and source', () async {
    final sink = MemoryAnalyticsSink();
    final c = await makeContainer(overrides: [analyticsSinkProvider.overrideWithValue(sink)]);
    c.listen(entitlementProvider, (_, _) {});
    final products = await c.read(storeProductsProvider.future);
    await c.read(entitlementProvider.notifier).buy(products[1], source: 'home_pro_button');
    expect(sink.names, containsAllInOrder(['purchase_start', 'purchase_success']));
    expect(sink.last('purchase_success')!['product_id'], BillingConfig.yearly);
    expect(sink.last('purchase_success')!['source'], 'home_pro_button');
  });

  test('a store outage reports purchase_fail with the reason', () async {
    final sink = MemoryAnalyticsSink();
    final c = await makeContainer(overrides: [analyticsSinkProvider.overrideWithValue(sink)]);
    c.listen(entitlementProvider, (_, _) {});
    c.read(previewModeProvider.notifier).set(PreviewMode.error);
    const product = StoreProduct(id: BillingConfig.weekly, title: 'Weekly', price: r'$1');
    await c.read(entitlementProvider.notifier).buy(product);
    expect(sink.last('purchase_fail')!['reason'], 'unavailable');
  });
}
