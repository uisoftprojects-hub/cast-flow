import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../domain/billing.dart';

/// Google Play Billing / StoreKit through the official in_app_purchase
/// plugin. Entitlement is checked on-device only (no receipt server).
class IapBillingService implements BillingService {
  IapBillingService() {
    _sub = _iap.purchaseStream.listen(_onPurchases, onError: (_) {});
  }

  final _iap = InAppPurchase.instance;
  final _entitlements = StreamController<EntitlementState>.broadcast();
  late final StreamSubscription<List<PurchaseDetails>> _sub;
  final Map<String, ProductDetails> _details = {};
  Completer<PurchaseOutcome>? _pending;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<List<StoreProduct>> products() async {
    if (!await isAvailable()) throw StateError('Billing is unavailable on this device.');
    final response = await _iap.queryProductDetails(BillingConfig.ids);
    if (response.error != null) throw StateError(response.error!.message);
    for (final d in response.productDetails) {
      _details[d.id] = d;
    }
    const order = [BillingConfig.weekly, BillingConfig.yearly, BillingConfig.lifetime];
    return [
      for (final id in order)
        if (_details[id] case final d?) StoreProduct(id: d.id, title: d.title, price: d.price),
    ];
  }

  @override
  Future<PurchaseOutcome> buy(StoreProduct product) async {
    final details = _details[product.id];
    if (details == null) return PurchaseOutcome.unavailable;
    if (_pending != null) return _pending!.future; // ignore duplicate taps
    _pending = Completer<PurchaseOutcome>();
    try {
      final started = await _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: details));
      if (!started) _complete(PurchaseOutcome.failed);
    } catch (_) {
      _complete(PurchaseOutcome.failed);
    }
    return _pending?.future ?? Future.value(PurchaseOutcome.failed);
  }

  @override
  Future<void> restore() => _iap.restorePurchases();

  @override
  Stream<EntitlementState> get entitlements => _entitlements.stream;

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.pending:
          _complete(PurchaseOutcome.pending);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _entitlements.add(EntitlementState(productId: p.productID, active: true, lastCheckedAt: DateTime.now()));
          _complete(PurchaseOutcome.success);
        case PurchaseStatus.canceled:
          _complete(PurchaseOutcome.cancelled);
        case PurchaseStatus.error:
          _complete(PurchaseOutcome.failed);
      }
      if (p.pendingCompletePurchase) await _iap.completePurchase(p);
    }
  }

  void _complete(PurchaseOutcome outcome) {
    final c = _pending;
    _pending = null;
    if (c != null && !c.isCompleted) c.complete(outcome);
  }

  @override
  void dispose() {
    _sub.cancel();
    _entitlements.close();
  }
}
