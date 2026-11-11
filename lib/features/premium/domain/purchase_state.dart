import 'package:flutter/foundation.dart';
import 'billing.dart';

/// Centralized Google Play subscription purchase states.
enum PurchaseState {
  /// 1. Initial state before billing setup.
  initial,

  /// 2. Querying Google Play for subscription product details.
  loadingProduct,

  /// 3. Product details retrieved from Google Play.
  productLoaded,

  /// 4. User is eligible for a free trial on the matching base plan.
  freeTrialEligible,

  /// 5. User is not eligible for a free trial (or no trial configured).
  freeTrialUnavailable,

  /// 6. Purchase flow in progress with Google Play.
  purchasePending,

  /// 7. Google Play reported successful purchase.
  purchaseSuccessful,

  /// 8. User cancelled the purchase flow.
  purchaseCancelled,

  /// 9. Purchase failed (billing error, network error, etc.).
  purchaseFailed,

  /// 10. Purchase verification in progress.
  purchaseVerificationPending,

  /// 11. Entitlement confirmed and premium unlocked.
  premiumActive,

  /// 12. Verified subscription has expired.
  subscriptionExpired,
}

/// Immutable state container for the paywall and subscription purchase flow.
@immutable
class SubscriptionPurchaseState {
  const SubscriptionPurchaseState({
    this.status = PurchaseState.initial,
    this.product,
    this.errorMessage,
    this.isProcessing = false,
  });

  final PurchaseState status;
  final StoreProduct? product;
  final String? errorMessage;
  final bool isProcessing;

  /// Whether product details are currently loading.
  bool get isLoading => status == PurchaseState.loadingProduct;

  /// Whether a free trial is eligible and available.
  bool get isTrialEligible =>
      status == PurchaseState.freeTrialEligible || (product?.hasFreeTrial ?? false);

  /// Dynamic CTA text based on current state and eligibility.
  String get ctaText {
    if (isLoading) return 'Loading...';
    if (isTrialEligible && product?.freeTrialDurationText != null) {
      return '${product!.freeTrialDurationText} Free Trial';
    }
    return 'Continue';
  }

  SubscriptionPurchaseState copyWith({
    PurchaseState? status,
    StoreProduct? product,
    String? errorMessage,
    bool? isProcessing,
  }) {
    return SubscriptionPurchaseState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionPurchaseState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          product == other.product &&
          errorMessage == other.errorMessage &&
          isProcessing == other.isProcessing;

  @override
  int get hashCode => Object.hash(status, product, errorMessage, isProcessing);
}
