import 'dart:async';

import '../../../core/app_providers.dart';
import '../domain/billing.dart';
import '../domain/trial_duration_parser.dart';

/// Simulated store for previews and tests.
/// Supports testing dynamic free trial eligibility, ISO duration parsing,
/// subscription expiration, and purchase restoration.
class FakeBillingService implements BillingService {
  FakeBillingService(
    this._mode, {
    bool initialTrialEligible = true,
    String trialPeriodIso = 'P7D',
    this.weeklyPrice = 'US\$3.99',
  })  : _trialEligible = initialTrialEligible,
        _trialPeriod = trialPeriodIso;

  final PreviewMode Function() _mode;
  final _controller = StreamController<EntitlementState>.broadcast();

  bool _trialEligible;
  String _trialPeriod;
  final String weeklyPrice;
  String? _owned;
  DateTime? _ownedExpiry;

  /// Update simulated trial eligibility at runtime for testing.
  void setTrialEligibility({required bool eligible, String isoPeriod = 'P7D'}) {
    _trialEligible = eligible;
    _trialPeriod = isoPeriod;
  }

  /// Simulate an expired subscription for testing.
  void setSimulatedSubscription({required String productId, required bool active, DateTime? expiry}) {
    _owned = active ? productId : null;
    _ownedExpiry = expiry;
  }

  @override
  Future<bool> isAvailable() async => _mode() != PreviewMode.error;

  @override
  Future<List<StoreProduct>> products() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (_mode() == PreviewMode.error) {
      throw const FakeServiceException('Store is unavailable right now.');
    }
    if (_mode() == PreviewMode.empty) return const [];

    final durationText = _trialEligible ? TrialDurationParser.parse(_trialPeriod) : null;

    return [
      StoreProduct(
        id: BillingConfig.weekly,
        title: 'Weekly',
        price: weeklyPrice,
        basePlanId: BillingConfig.weeklyBasePlan,
        offerToken: _trialEligible ? 'token_weekly_trial' : 'token_weekly_base',
        freeTrialPeriodIso: _trialEligible ? _trialPeriod : null,
        freeTrialDurationText: durationText,
        isFreeTrialEligible: _trialEligible && durationText != null,
        rawPrice: 3.99,
        currencyCode: 'USD',
      ),
    ];
  }

  @override
  Future<PurchaseOutcome> buy(StoreProduct product) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (_mode() == PreviewMode.error) return PurchaseOutcome.failed;

    _owned = product.id;
    // Weekly subscription default expiry 7 days in future
    _ownedExpiry = DateTime.now().add(const Duration(days: 7));

    // Once purchased, introductory trial is considered used
    _trialEligible = false;

    _controller.add(
      EntitlementState(
        productId: product.id,
        active: true,
        expiry: _ownedExpiry,
        lastCheckedAt: DateTime.now(),
        orderId: 'GPA.fake-order-${DateTime.now().millisecondsSinceEpoch}',
        purchaseToken: product.offerToken ?? 'fake-token',
      ),
    );
    return PurchaseOutcome.success;
  }

  @override
  Future<void> restore() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final hasActive = _owned != null && (_ownedExpiry == null || _ownedExpiry!.isAfter(DateTime.now()));
    _controller.add(
      EntitlementState(
        productId: _owned,
        active: hasActive,
        expiry: _ownedExpiry,
        lastCheckedAt: DateTime.now(),
      ),
    );
  }

  @override
  Stream<EntitlementState> get entitlements => _controller.stream;

  @override
  void dispose() => _controller.close();
}
