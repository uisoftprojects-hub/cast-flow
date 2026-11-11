import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/app_providers.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/billing_factory.dart';
import '../domain/billing.dart';
import '../domain/premium_status_service.dart';
import '../domain/purchase_state.dart';

final billingServiceProvider = Provider<BillingService>((ref) {
  final service = createBillingService(() => ref.read(previewModeProvider));
  ref.onDispose(service.dispose);
  return service;
});

final storeProductsProvider = FutureProvider<List<StoreProduct>>((ref) {
  ref.watch(previewModeProvider);
  return ref.watch(billingServiceProvider).products();
});

/// Result status returned by [PurchaseStateManager.restorePurchases].
enum RestoreStatus {
  activeRestored,
  expired,
  noPurchasesFound,
  verificationFailed,
  billingUnavailable,
  error,
}

@immutable
class RestoreResult {
  const RestoreResult(this.status, {this.message});
  final RestoreStatus status;
  final String? message;
}

/// Centralized purchase state manager handling all 12 required purchase lifecycle states.
class PurchaseStateManager extends Notifier<SubscriptionPurchaseState> {
  @override
  SubscriptionPurchaseState build() {
    // Listen to store products and automatically populate the state
    ref.listen(storeProductsProvider, (_, next) {
      next.when(
        data: (products) => _onProductsLoaded(products),
        loading: () => state = state.copyWith(
          status: PurchaseState.loadingProduct,
          isProcessing: false,
        ),
        error: (err, _) => state = state.copyWith(
          status: PurchaseState.purchaseFailed,
          errorMessage: err.toString(),
          isProcessing: false,
        ),
      );
    });

    final initialProducts = ref.read(storeProductsProvider).asData?.value;
    if (initialProducts != null && initialProducts.isNotEmpty) {
      final weekly = initialProducts.where((p) => p.id == BillingConfig.weekly).firstOrNull ??
          initialProducts.first;
      final trialEligible = weekly.isFreeTrialEligible && weekly.freeTrialDurationText != null;
      return SubscriptionPurchaseState(
        status: trialEligible ? PurchaseState.freeTrialEligible : PurchaseState.freeTrialUnavailable,
        product: weekly,
      );
    }

    return const SubscriptionPurchaseState(status: PurchaseState.initial);
  }

  void _onProductsLoaded(List<StoreProduct> products) {
    if (products.isEmpty) {
      state = state.copyWith(
        status: PurchaseState.purchaseFailed,
        errorMessage: 'No subscription plans available.',
        isProcessing: false,
      );
      return;
    }

    // Match exact product ID `weekly_sub`
    final weekly = products.where((p) => p.id == BillingConfig.weekly).firstOrNull ??
        products.first;

    final isTrial = weekly.isFreeTrialEligible && weekly.freeTrialDurationText != null;
    state = state.copyWith(
      status: isTrial ? PurchaseState.freeTrialEligible : PurchaseState.freeTrialUnavailable,
      product: weekly,
      isProcessing: false,
      errorMessage: null,
    );
  }

  /// Selects a specific plan on the paywall.
  void selectProduct(StoreProduct product) {
    final isTrial = product.isFreeTrialEligible && product.freeTrialDurationText != null;
    state = state.copyWith(
      product: product,
      status: isTrial ? PurchaseState.freeTrialEligible : PurchaseState.freeTrialUnavailable,
    );
  }

  /// Executes purchase of [product] or current selected product.
  Future<PurchaseOutcome> buy([StoreProduct? target, String? source]) async {
    final product = target ?? state.product;
    if (product == null) return PurchaseOutcome.unavailable;
    if (state.isProcessing) return PurchaseOutcome.pending; // Prevent duplicate taps

    final analytics = ref.read(analyticsProvider);
    final params = <String, Object?>{
      AnalyticsParam.productId: product.id,
      AnalyticsParam.plan: product.period,
      AnalyticsParam.price: product.price,
      AnalyticsParam.source: source,
    };
    analytics.log(AnalyticsEvent.purchaseStart, params);

    // 6. Purchase pending
    state = state.copyWith(
      status: PurchaseState.purchasePending,
      isProcessing: true,
      errorMessage: null,
    );

    final service = ref.read(billingServiceProvider);
    if (!await service.isAvailable()) {
      state = state.copyWith(
        status: PurchaseState.purchaseFailed,
        errorMessage: 'Google Play Billing is unavailable.',
        isProcessing: false,
      );
      analytics.log(AnalyticsEvent.purchaseFail, {
        ...params,
        AnalyticsParam.reason: PurchaseOutcome.unavailable,
      });
      return PurchaseOutcome.unavailable;
    }

    // 10. Purchase verification pending
    state = state.copyWith(status: PurchaseState.purchaseVerificationPending);

    final outcome = await service.buy(product);

    switch (outcome) {
      case PurchaseOutcome.success:
        // 7. Purchase successful -> 11. Premium active
        state = state.copyWith(
          status: PurchaseState.premiumActive,
          isProcessing: false,
        );
        ref.read(premiumStatusServiceProvider).applyPurchase(productId: product.id);
        analytics.log(AnalyticsEvent.purchaseSuccess, params);
        analytics.userProperty(AnalyticsUserProperty.isPremium, 'true');
      case PurchaseOutcome.cancelled:
        // 8. Purchase cancelled
        final isTrial = product.isFreeTrialEligible && product.freeTrialDurationText != null;
        state = state.copyWith(
          status: isTrial ? PurchaseState.freeTrialEligible : PurchaseState.freeTrialUnavailable,
          isProcessing: false,
        );
        analytics.log(AnalyticsEvent.purchaseFail, {
          ...params,
          AnalyticsParam.reason: PurchaseOutcome.cancelled,
        });
      case PurchaseOutcome.pending:
        state = state.copyWith(
          status: PurchaseState.purchasePending,
          isProcessing: false,
        );
        analytics.log(AnalyticsEvent.purchaseFail, {
          ...params,
          AnalyticsParam.reason: PurchaseOutcome.pending,
        });
      case PurchaseOutcome.failed:
      case PurchaseOutcome.unavailable:
        // 9. Purchase failed
        state = state.copyWith(
          status: PurchaseState.purchaseFailed,
          errorMessage: 'Purchase could not be completed.',
          isProcessing: false,
        );
        analytics.log(AnalyticsEvent.purchaseFail, {
          ...params,
          AnalyticsParam.reason: outcome,
        });
    }

    return outcome;
  }

  /// Restores previous purchases through Google Play sync.
  Future<RestoreResult> restorePurchases() async {
    final service = ref.read(billingServiceProvider);
    if (!await service.isAvailable()) {
      return const RestoreResult(
        RestoreStatus.billingUnavailable,
        message: 'Google Play Billing is unavailable.',
      );
    }

    state = state.copyWith(isProcessing: true);

    try {
      final next = service.entitlements.first.timeout(
        const Duration(seconds: 10),
        onTimeout: () => ref.read(entitlementProvider),
      );

      await service.restore();
      final entitlement = await next;

      state = state.copyWith(isProcessing: false);

      if (entitlement.productId == null || !entitlement.active) {
        // If it was previously owned but expired
        if (entitlement.expiry != null && DateTime.now().isAfter(entitlement.expiry!)) {
          state = state.copyWith(status: PurchaseState.subscriptionExpired);
          ref.read(settingsProvider.notifier).setPremium(false);
          return const RestoreResult(
            RestoreStatus.expired,
            message: 'Your subscription has expired.',
          );
        }
        return const RestoreResult(
          RestoreStatus.noPurchasesFound,
          message: 'No active purchases found for this account.',
        );
      }

      // Check if subscription has expired
      if (entitlement.expiry != null && DateTime.now().isAfter(entitlement.expiry!)) {
        state = state.copyWith(status: PurchaseState.subscriptionExpired);
        ref.read(settingsProvider.notifier).setPremium(false);
        return const RestoreResult(
          RestoreStatus.expired,
          message: 'Your subscription has expired.',
        );
      }

      // Valid and active
      state = state.copyWith(status: PurchaseState.premiumActive);
      ref.read(settingsProvider.notifier).setPremium(true);
      return const RestoreResult(
        RestoreStatus.activeRestored,
        message: 'Subscription restored successfully.',
      );
    } catch (e) {
      state = state.copyWith(isProcessing: false);
      return RestoreResult(RestoreStatus.error, message: e.toString());
    }
  }
}

final purchaseStateProvider =
    NotifierProvider<PurchaseStateManager, SubscriptionPurchaseState>(PurchaseStateManager.new);

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
    if (raw == null) return const EntitlementState();

    try {
      final loaded = EntitlementState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      // Validate expiration on startup
      if (loaded.active && loaded.expiry != null && DateTime.now().isAfter(loaded.expiry!)) {
        // Expired: revoke
        return EntitlementState(
          productId: loaded.productId,
          active: false,
          expiry: loaded.expiry,
          lastCheckedAt: DateTime.now(),
        );
      }
      return loaded;
    } catch (_) {
      return const EntitlementState();
    }
  }

  void _apply(EntitlementState e) {
    // If expired, active must be false
    final isExpired = e.expiry != null && DateTime.now().isAfter(e.expiry!);
    final effectiveActive = e.active && !isExpired;

    final effectiveState = EntitlementState(
      productId: e.productId,
      active: effectiveActive,
      expiry: e.expiry,
      orderId: e.orderId,
      purchaseToken: e.purchaseToken,
      isAutoRenewing: e.isAutoRenewing,
      lastCheckedAt: DateTime.now(),
    );

    state = effectiveState;
    ref.read(sharedPrefsProvider).setString(_key, jsonEncode(effectiveState.toJson()));
    ref.read(settingsProvider.notifier).setPremium(effectiveActive);
  }

  /// Buys [product] from the paywall opened from [source], reporting the
  /// result to analytics.
  Future<PurchaseOutcome> buy(StoreProduct product, {String? source}) async {
    return ref.read(purchaseStateProvider.notifier).buy(product, source);
  }

  /// Restores purchases; returns whether an active entitlement was found.
  Future<bool> restore() async {
    final res = await ref.read(purchaseStateProvider.notifier).restorePurchases();
    return res.status == RestoreStatus.activeRestored;
  }

  /// Silent refresh at startup so revoked/expired purchases are reflected.
  Future<void> refresh() async {
    await ref.read(premiumStatusServiceProvider).refresh();
  }
}

final entitlementProvider =
    NotifierProvider<EntitlementController, EntitlementState>(EntitlementController.new);
