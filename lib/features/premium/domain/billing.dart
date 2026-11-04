import 'package:flutter/foundation.dart';

enum PlanPeriod {
  weekly('per week'),
  yearly('per year'),
  lifetime('pay once');

  const PlanPeriod(this.note);
  final String note;
}

/// Store product IDs (create these in Play Console / App Store Connect).
abstract final class BillingConfig {
  static const weekly = 'castflow_pro_weekly';
  static const yearly = 'castflow_pro_yearly';
  static const lifetime = 'castflow_pro_lifetime';

  static const ids = {weekly, yearly, lifetime};

  static PlanPeriod periodOf(String id) => switch (id) {
    weekly => PlanPeriod.weekly,
    yearly => PlanPeriod.yearly,
    _ => PlanPeriod.lifetime,
  };
}

/// A product as reported by the store; [price] is the store's localized
/// price string and is never hardcoded in the app.
@immutable
class StoreProduct {
  const StoreProduct({required this.id, required this.title, required this.price});
  final String id;
  final String title;
  final String price;

  PlanPeriod get period => BillingConfig.periodOf(id);
  bool get isSubscription => period != PlanPeriod.lifetime;
}

enum PurchaseOutcome { success, cancelled, pending, failed, unavailable }

/// Locally cached entitlement, refreshed from the store APIs. Client-side
/// only (no receipt-validation server in the no-backend baseline).
@immutable
class EntitlementState {
  const EntitlementState({this.productId, this.active = false, this.expiry, this.lastCheckedAt});
  final String? productId;
  final bool active;
  final DateTime? expiry;
  final DateTime? lastCheckedAt;

  Map<String, Object?> toJson() => {
    'productId': productId,
    'active': active,
    'expiry': expiry?.millisecondsSinceEpoch,
    'lastCheckedAt': lastCheckedAt?.millisecondsSinceEpoch,
  };

  factory EntitlementState.fromJson(Map<String, dynamic> j) {
    DateTime? t(String k) => j[k] == null ? null : DateTime.fromMillisecondsSinceEpoch(j[k] as int);
    return EntitlementState(
      productId: j['productId'] as String?,
      active: j['active'] as bool? ?? false,
      expiry: t('expiry'),
      lastCheckedAt: t('lastCheckedAt'),
    );
  }
}

abstract interface class BillingService {
  Future<bool> isAvailable();

  /// Products in display order (weekly, yearly, lifetime).
  Future<List<StoreProduct>> products();

  Future<PurchaseOutcome> buy(StoreProduct product);

  /// Restores previous purchases; reports through [entitlements].
  Future<void> restore();

  /// Entitlement changes reported by the store (purchase, restore, revoke).
  Stream<EntitlementState> get entitlements;

  void dispose();
}
