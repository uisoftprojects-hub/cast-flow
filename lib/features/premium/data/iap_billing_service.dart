import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../domain/billing.dart';
import '../domain/purchase_verifier.dart';
import 'google_play_offer_inspector.dart';

/// Production-ready Google Play Billing and StoreKit implementation.
/// Retrieves dynamic prices, subscription base plans, and introductory trial offers.
class IapBillingService implements BillingService {
  IapBillingService({PurchaseVerifier? verifier})
    : _verifier = verifier ?? const GooglePlayPurchaseVerifier() {
    _sub = _iap.purchaseStream.listen(
      _onPurchases,
      onError: (Object error) {
        debugPrint('[Billing] purchaseStream error: $error');
        _complete(PurchaseOutcome.failed);
      },
    );
  }

  final InAppPurchase _iap = InAppPurchase.instance;
  final PurchaseVerifier _verifier;
  final _entitlements = StreamController<EntitlementState>.broadcast();
  late final StreamSubscription<List<PurchaseDetails>> _sub;
  final Map<String, ProductDetails> _details = {};
  Completer<PurchaseOutcome>? _pending;

  // Back-press on the Play billing sheet: Google Play often sends no cancel
  // event, which left the Continue button loading forever. When the app comes
  // back to the foreground and no purchase update arrives shortly after, the
  // sheet was dismissed, so the purchase is reported as cancelled.
  AppLifecycleListener? _lifecycle;
  Timer? _abandonTimer;
  bool _gotUpdate = false;

  void _onResumeWhilePending() {
    _abandonTimer?.cancel();
    _abandonTimer = Timer(const Duration(milliseconds: 500), () {
      if (_pending != null && !_gotUpdate) _complete(PurchaseOutcome.cancelled);
    });
  }

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<List<StoreProduct>> products() async {
    final available = await isAvailable();
    if (!available) {
      throw StateError('Google Play Billing is unavailable on this device.');
    }

    final response = await _iap.queryProductDetails(BillingConfig.ids);
    if (response.error != null) {
      throw StateError(response.error!.message);
    }

    for (final d in response.productDetails) {
      _details[d.id] = d;
    }

    const order = [BillingConfig.weekly];
    final result = <StoreProduct>[];

    for (final id in order) {
      final d = _details[id];
      if (d == null) continue;

      if (id == BillingConfig.weekly && d is GooglePlayProductDetails) {
        // Inspect base plan and subscription offers for Google Play
        final resolved = GooglePlayOfferInspector.inspect(
          productId: d.id,
          targetBasePlanId: BillingConfig.weeklyBasePlan,
          offers: d.productDetails.subscriptionOfferDetails,
        );

        if (resolved != null) {
          result.add(
            StoreProduct(
              id: d.id,
              title: d.title,
              price: resolved.recurringPrice,
              basePlanId: resolved.basePlanId,
              offerToken: resolved.offerToken,
              freeTrialPeriodIso: resolved.freeTrialPeriodIso,
              freeTrialDurationText: resolved.freeTrialDurationText,
              isFreeTrialEligible: resolved.isFreeTrialEligible,
              rawPrice: resolved.rawRecurringPrice,
              currencyCode: resolved.currencyCode,
            ),
          );
          continue;
        }
      }

      // Fallback for one-time purchases or other platforms
      result.add(
        StoreProduct(
          id: d.id,
          title: d.title,
          price: d.price,
          rawPrice: d.rawPrice,
          currencyCode: d.currencyCode,
          currencySymbol: d.currencySymbol,
        ),
      );
    }

    return result;
  }

  @override
  Future<PurchaseOutcome> buy(StoreProduct product) async {
    final details = _details[product.id];
    if (details == null) return PurchaseOutcome.unavailable;
    if (_pending != null) return _pending!.future; // Ignore duplicate taps

    _pending = Completer<PurchaseOutcome>();
    _gotUpdate = false;
    _lifecycle?.dispose();
    _lifecycle = AppLifecycleListener(
      onStateChange: (s) => debugPrint('[Billing] lifecycle -> $s'),
      onResume: _onResumeWhilePending,
    );
    try {
      PurchaseParam param;
      if (details is GooglePlayProductDetails) {
        param = GooglePlayPurchaseParam(
          productDetails: details,
          offerToken: product.offerToken,
        );
      } else {
        param = PurchaseParam(productDetails: details);
      }

      final started = await _iap.buyNonConsumable(purchaseParam: param);
      if (!started) _complete(PurchaseOutcome.failed);
    } catch (e) {
      debugPrint('[Billing] Purchase error: $e');
      _complete(PurchaseOutcome.failed);
    }
    return _pending?.future ?? Future.value(PurchaseOutcome.failed);
  }

  bool _restoring = false;

  @override
  Future<void> restore() async {
    _restoring = true;
    try {
      await _iap.restorePurchases();
    } catch (_) {
      _restoring = false;
      rethrow;
    }
  }

  @override
  Stream<EntitlementState> get entitlements => _entitlements.stream;

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    // A completed restore that found nothing means the store holds no
    // subscription (expired, refunded or never bought): report it explicitly so
    // startup verification can resolve to Free instead of waiting.
    if (_restoring && purchases.isEmpty) {
      _restoring = false;
      _entitlements.add(EntitlementState(lastCheckedAt: DateTime.now()));
      return;
    }
    if (purchases.isNotEmpty) {
      _restoring = false;
      _gotUpdate = true;
    }
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.pending:
          _complete(PurchaseOutcome.pending);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final verification = await _verifier.verify(p);
          if (verification.isValid && verification.isActive) {
            _entitlements.add(
              EntitlementState(
                productId: p.productID,
                active: true,
                expiry: verification.expiryDate,
                orderId: verification.orderId,
                purchaseToken: verification.purchaseToken,
                isAutoRenewing: verification.isAutoRenewing,
                lastCheckedAt: DateTime.now(),
              ),
            );
            _complete(PurchaseOutcome.success);
          } else {
            // Receipt invalid, revoked, or expired
            _entitlements.add(
              EntitlementState(
                productId: p.productID,
                active: false,
                expiry: verification.expiryDate,
                lastCheckedAt: DateTime.now(),
              ),
            );
            _complete(PurchaseOutcome.failed);
          }
        case PurchaseStatus.canceled:
          _complete(PurchaseOutcome.cancelled);
        case PurchaseStatus.error:
          _complete(PurchaseOutcome.failed);
      }

      if (p.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(p);
        } catch (e) {
          debugPrint('[Billing] completePurchase error: $e');
        }
      }
    }
  }

  void _complete(PurchaseOutcome outcome) {
    final c = _pending;
    _pending = null;
    _abandonTimer?.cancel();
    _lifecycle?.dispose();
    _lifecycle = null;
    if (c != null && !c.isCompleted) c.complete(outcome);
  }

  @override
  void dispose() {
    _sub.cancel();
    _entitlements.close();
  }
}
