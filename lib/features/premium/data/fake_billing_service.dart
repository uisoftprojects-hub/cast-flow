import 'dart:async';

import '../../../core/app_providers.dart';
import '../domain/billing.dart';

/// Simulated store for previews and tests. "Error states" preview mode makes
/// the store unavailable.
class FakeBillingService implements BillingService {
  FakeBillingService(this._mode);

  final PreviewMode Function() _mode;
  final _controller = StreamController<EntitlementState>.broadcast();
  String? _owned;

  @override
  Future<bool> isAvailable() async => _mode() != PreviewMode.error;

  @override
  Future<List<StoreProduct>> products() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (_mode() == PreviewMode.error) throw const FakeServiceException('Store is unavailable right now.');
    if (_mode() == PreviewMode.empty) return const [];
    // Shaped like store responses; real prices come from the store.
    return const [
      StoreProduct(id: BillingConfig.weekly, title: 'Weekly', price: 'US\$3.99'),
      StoreProduct(id: BillingConfig.yearly, title: 'Yearly', price: 'US\$29.99'),
      StoreProduct(id: BillingConfig.lifetime, title: 'Lifetime', price: 'US\$49.99'),
    ];
  }

  @override
  Future<PurchaseOutcome> buy(StoreProduct product) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (_mode() == PreviewMode.error) return PurchaseOutcome.failed;
    _owned = product.id;
    _controller.add(EntitlementState(productId: product.id, active: true, lastCheckedAt: DateTime.now()));
    return PurchaseOutcome.success;
  }

  @override
  Future<void> restore() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _controller.add(EntitlementState(productId: _owned, active: _owned != null, lastCheckedAt: DateTime.now()));
  }

  @override
  Stream<EntitlementState> get entitlements => _controller.stream;

  @override
  void dispose() => _controller.close();
}
