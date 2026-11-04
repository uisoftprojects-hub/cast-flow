import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/app_providers.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/billing_factory.dart';
import '../domain/billing.dart';

final billingServiceProvider = Provider<BillingService>((ref) {
  final service = createBillingService(() => ref.read(previewModeProvider));
  ref.onDispose(service.dispose);
  return service;
});

final storeProductsProvider = FutureProvider<List<StoreProduct>>((ref) {
  ref.watch(previewModeProvider);
  return ref.watch(billingServiceProvider).products();
});

/// Cached entitlement; kept in sync with what the store reports and mirrored
/// into settings.isPremium (which gates ads and paywalls).
class EntitlementController extends Notifier<EntitlementState> {
  static const _key = 'entitlement_state';
  StreamSubscription<EntitlementState>? _sub;

  @override
  EntitlementState build() {
    final service = ref.watch(billingServiceProvider);
    _sub = service.entitlements.listen(_apply);
    ref.onDispose(() => _sub?.cancel());
    final raw = ref.read(sharedPrefsProvider).getString(_key);
    return raw == null ? const EntitlementState() : EntitlementState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  void _apply(EntitlementState e) {
    state = e;
    ref.read(sharedPrefsProvider).setString(_key, jsonEncode(e.toJson()));
    ref.read(settingsProvider.notifier).setPremium(e.active);
  }

  /// Buys [product] from the paywall opened from [source], reporting the
  /// result to analytics.
  Future<PurchaseOutcome> buy(StoreProduct product, {String? source}) async {
    final analytics = ref.read(analyticsProvider);
    final params = <String, Object?>{
      AnalyticsParam.productId: product.id,
      AnalyticsParam.plan: product.period,
      AnalyticsParam.price: product.price,
      AnalyticsParam.source: source,
    };
    analytics.log(AnalyticsEvent.purchaseStart, params);
    final service = ref.read(billingServiceProvider);
    final outcome = await service.isAvailable() ? await service.buy(product) : PurchaseOutcome.unavailable;
    // Cancelled, pending, failed and unavailable all count as purchase_fail,
    // told apart by the reason.
    final ok = outcome == PurchaseOutcome.success;
    analytics.log(ok ? AnalyticsEvent.purchaseSuccess : AnalyticsEvent.purchaseFail, {
      ...params,
      if (!ok) AnalyticsParam.reason: outcome,
    });
    if (outcome == PurchaseOutcome.success) analytics.userProperty(AnalyticsUserProperty.isPremium, 'true');
    return outcome;
  }

  /// Restores purchases; returns whether an active entitlement was found.
  Future<bool> restore() async {
    final service = ref.read(billingServiceProvider);
    if (!await service.isAvailable()) return false;
    final next = service.entitlements.first.timeout(const Duration(seconds: 10), onTimeout: () => state);
    await service.restore();
    return (await next).active;
  }

  /// Silent refresh at startup so revoked/expired purchases are reflected.
  Future<void> refresh() async {
    final service = ref.read(billingServiceProvider);
    if (await service.isAvailable()) await service.restore();
  }
}

final entitlementProvider = NotifierProvider<EntitlementController, EntitlementState>(EntitlementController.new);
