import 'package:flutter/foundation.dart';
import 'trial_duration_parser.dart';

enum PlanPeriod {
  weekly('per week');

  const PlanPeriod(this.note);
  final String note;
}

/// Store product and subscription IDs.
///
/// Google Play Subscription Configuration:
/// - Subscription Product ID: `weekly_sub`
/// - Base Plan ID: `weeklysub`
abstract final class BillingConfig {
  /// Subscription Product ID configured in Google Play Console.
  static const subscriptionId = 'weekly_sub';

  /// Exact base plan ID in Google Play Console.
  static const weeklyBasePlan = 'weeklysub';

  static const weekly = 'weekly_sub';

  static const ids = {weekly};

  static PlanPeriod periodOf(String id) => switch (id) {
    _ => PlanPeriod.weekly,
  };
}

/// A product or subscription plan as reported dynamically by Google Play / StoreKit.
/// Prices and trial information are retrieved dynamically and never hardcoded.
@immutable
class StoreProduct {
  const StoreProduct({
    required this.id,
    required this.title,
    required this.price,
    this.basePlanId,
    this.offerToken,
    this.freeTrialPeriodIso,
    this.freeTrialDurationText,
    this.isFreeTrialEligible = false,
    this.rawPrice = 0.0,
    this.currencyCode = '',
    this.currencySymbol = '',
  });

  /// The store product identifier (e.g., `weekly_sub`).
  final String id;

  /// The product title from Google Play.
  final String title;

  /// The store's localized formatted recurring price string (e.g. '$1.99').
  final String price;

  /// Matching Google Play base plan ID (e.g., `weeklysub`).
  final String? basePlanId;

  /// The offer token required by Google Play Billing flow.
  final String? offerToken;

  /// ISO 8601 billing period for the free trial (e.g., 'P3D', 'P7D', 'P1W').
  final String? freeTrialPeriodIso;

  /// Human-readable free trial duration (e.g., '3 Days', '7 Days', '1 Week').
  final String? freeTrialDurationText;

  /// Whether the current user is eligible to redeem the free-trial offer.
  final bool isFreeTrialEligible;

  /// Numeric price for analytics or comparisons.
  final double rawPrice;

  /// Currency code (e.g., 'USD').
  final String currencyCode;

  /// Currency symbol (e.g., '$').
  final String currencySymbol;

  PlanPeriod get period => BillingConfig.periodOf(id);

  bool get isSubscription => true;

  /// A free trial is available only when eligible and duration text exists.
  bool get hasFreeTrial => isFreeTrialEligible && freeTrialDurationText != null;

  /// Dynamic CTA text for this product option.
  String ctaText({String continueLabel = 'Continue'}) {
    return TrialDurationParser.formatCta(
      isEligible: isFreeTrialEligible,
      trialDurationText: freeTrialDurationText,
      continueLabel: continueLabel,
    );
  }

  StoreProduct copyWith({
    String? id,
    String? title,
    String? price,
    String? basePlanId,
    String? offerToken,
    String? freeTrialPeriodIso,
    String? freeTrialDurationText,
    bool? isFreeTrialEligible,
    double? rawPrice,
    String? currencyCode,
    String? currencySymbol,
  }) {
    return StoreProduct(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      basePlanId: basePlanId ?? this.basePlanId,
      offerToken: offerToken ?? this.offerToken,
      freeTrialPeriodIso: freeTrialPeriodIso ?? this.freeTrialPeriodIso,
      freeTrialDurationText: freeTrialDurationText ?? this.freeTrialDurationText,
      isFreeTrialEligible: isFreeTrialEligible ?? this.isFreeTrialEligible,
      rawPrice: rawPrice ?? this.rawPrice,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreProduct &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price &&
          basePlanId == other.basePlanId &&
          offerToken == other.offerToken &&
          freeTrialPeriodIso == other.freeTrialPeriodIso &&
          freeTrialDurationText == other.freeTrialDurationText &&
          isFreeTrialEligible == other.isFreeTrialEligible;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    price,
    basePlanId,
    offerToken,
    freeTrialPeriodIso,
    freeTrialDurationText,
    isFreeTrialEligible,
  );
}

enum PurchaseOutcome { success, cancelled, pending, failed, unavailable }

/// Locally cached entitlement, refreshed from store APIs and verified.
@immutable
class EntitlementState {
  const EntitlementState({
    this.productId,
    this.active = false,
    this.expiry,
    this.lastCheckedAt,
    this.orderId,
    this.purchaseToken,
    this.isAutoRenewing = true,
  });

  final String? productId;
  final bool active;
  final DateTime? expiry;
  final DateTime? lastCheckedAt;
  final String? orderId;
  final String? purchaseToken;
  final bool isAutoRenewing;

  /// An entitlement is strictly active only if active is true AND expiry has not passed.
  /// (Cancelled subscriptions remain entitled until their expiry date).
  bool get isEntitled {
    if (!active) return false;
    if (expiry != null && DateTime.now().isAfter(expiry!)) return false;
    return true;
  }

  Map<String, Object?> toJson() => {
    'productId': productId,
    'active': active,
    'expiry': expiry?.millisecondsSinceEpoch,
    'lastCheckedAt': lastCheckedAt?.millisecondsSinceEpoch,
    'orderId': orderId,
    'purchaseToken': purchaseToken,
    'isAutoRenewing': isAutoRenewing,
  };

  factory EntitlementState.fromJson(Map<String, dynamic> j) {
    DateTime? t(String k) => j[k] == null ? null : DateTime.fromMillisecondsSinceEpoch(j[k] as int);
    return EntitlementState(
      productId: j['productId'] as String?,
      active: j['active'] as bool? ?? false,
      expiry: t('expiry'),
      lastCheckedAt: t('lastCheckedAt'),
      orderId: j['orderId'] as String?,
      purchaseToken: j['purchaseToken'] as String?,
      isAutoRenewing: j['isAutoRenewing'] as bool? ?? true,
    );
  }
}

abstract interface class BillingService {
  Future<bool> isAvailable();

  /// Products in display order, dynamically enriched with base plans and offers.
  Future<List<StoreProduct>> products();

  /// Buys the selected product or subscription using its designated offer token.
  Future<PurchaseOutcome> buy(StoreProduct product);

  /// Restores previous purchases; reports through [entitlements].
  Future<void> restore();

  /// Entitlement changes reported by the store.
  Stream<EntitlementState> get entitlements;

  void dispose();
}
