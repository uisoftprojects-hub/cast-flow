import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_providers.dart';
import '../../settings/presentation/settings_controller.dart';
import '../presentation/billing_controller.dart';
import 'billing.dart';

/// Centralized service providing authoritative verification of subscription entitlements.
/// Premium users NEVER receive advertisements.
class PremiumStatusService {
  // ignore: prefer_initializing_formals
  PremiumStatusService({
    required BillingService billingService,
    required this._prefs,
    required this._ref,
    DateTime Function()? clock,
  }) : _billing = billingService,
       _now = clock ?? DateTime.now {
    _init();
  }

  static const String cacheKey = 'authoritative_premium_entitlement';

  final BillingService _billing;
  final SharedPreferences _prefs;
  final Ref _ref;
  final DateTime Function() _now;

  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<EntitlementState>? _billingSub;

  EntitlementState _cached = const EntitlementState();
  bool _verificationPending = false;

  void _init() {
    _loadCache();
    _billingSub = _billing.entitlements.listen(_onEntitlementUpdate);
  }

  void _loadCache() {
    final raw = _prefs.getString(cacheKey);
    if (raw != null) {
      try {
        _cached = EntitlementState.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } catch (_) {
        _cached = const EntitlementState();
      }
    }
  }

  void _saveCache(EntitlementState state) {
    _cached = state;
    _prefs.setString(cacheKey, jsonEncode(state.toJson()));
  }

  /// A cached active entitlement that the store has not re-confirmed this
  /// session is only trusted for this long (covers offline use / billing hiccups
  /// without granting permanent access from a local flag).
  static const maxCacheAge = Duration(days: 10);

  /// How long startup waits for Google Play to answer a restore.
  static const restoreTimeout = Duration(seconds: 8);

  bool _verified = false;
  Future<bool>? _startup;
  DateTime? _lastRefreshAt;

  /// Authoritative check of premium status.
  /// Premium users must NEVER receive advertisements.
  bool get isPremium {
    if (!_cached.active) return false;
    // Check if subscription has expired (a cancelled sub stays active until then).
    final expiry = _cached.expiry;
    if (expiry != null && _now().isAfter(expiry)) return false;
    // Not re-confirmed by the store this session: trust the cache for a bounded time only.
    if (!_verified) {
      final checked = _cached.lastCheckedAt;
      if (checked == null || _now().difference(checked) > maxCacheAge) {
        return false;
      }
    }
    return true;
  }

  /// True once Google Play has answered (or the bounded wait ended). Until then
  /// the entitlement is "loading": UI must show neither paywalls nor promotions.
  bool get isEntitlementVerified => _verified;

  DateTime? get subscriptionExpiry => _cached.expiry;
  String? get activeProductId => _cached.active ? _cached.productId : null;

  /// Whether initial startup verification through Google Play Billing is in-flight
  bool get isVerificationPending => _verificationPending;

  /// Stream of premium status changes
  Stream<bool> get onPremiumChanged => _controller.stream;

  /// Notifies when [isPremium] or [isEntitlementVerified] may have changed.
  final _changes = StreamController<void>.broadcast();
  Stream<void> get changes => _changes.stream;

  /// Performs authoritative subscription verification and restoration on startup
  /// (also queries purchases after a reinstall). Safe to call repeatedly: the
  /// first call does the work, later calls share its result.
  Future<bool> verifyStartupEntitlement() => _startup ??= _verifyStartup();

  Future<bool> _verifyStartup() async {
    _verificationPending = true;
    try {
      if (await _billing.isAvailable()) {
        final answer = _billing.entitlements.first.timeout(restoreTimeout);
        await _billing.restore();
        try {
          await answer; // _onEntitlementUpdate has already applied it
        } on TimeoutException {
          // Unresolved: keep a still-valid cache, otherwise Free.
        }
      }
    } catch (_) {
      // Offline / billing error: keep last cached entitlement while it is valid.
    } finally {
      _verificationPending = false;
      _verified = true;
      _syncSettings();
      _changes.add(null);
    }
    return isPremium;
  }

  void _syncSettings() {
    _ref.read(settingsProvider.notifier).setPremium(isPremium);
  }

  /// Explicit purchase restoration triggered by user
  Future<bool> restorePurchases() async {
    try {
      if (!await _billing.isAvailable()) return false;
      final next = _billing.entitlements.first.timeout(
        const Duration(seconds: 10),
        onTimeout: () => _cached,
      );
      await _billing.restore();
      final res = await next;
      _onEntitlementUpdate(res);
      return isPremium;
    } catch (_) {
      return false;
    }
  }

  /// Refreshes entitlement from billing system
  /// Throttled so resume events don't hammer Google Play.
  Future<void> refresh({bool force = false}) async {
    final last = _lastRefreshAt;
    if (!force &&
        last != null &&
        _now().difference(last) < const Duration(seconds: 30)) {
      return;
    }
    _lastRefreshAt = _now();
    try {
      if (await _billing.isAvailable()) {
        await _billing.restore();
      }
    } catch (_) {}
  }

  void _onEntitlementUpdate(EntitlementState update) {
    _verified = true;
    final now = _now();
    final effectiveState = EntitlementState(
      productId: update.productId,
      active: update.active,
      expiry: update.expiry,
      lastCheckedAt: now,
    );
    _saveCache(effectiveState);

    final premium = isPremium;
    _ref.read(settingsProvider.notifier).setPremium(premium);
    _controller.add(premium);
    _changes.add(null);
  }

  /// Immediately applies an active entitlement on purchase success
  void applyPurchase({required String productId, DateTime? expiry}) {
    final state = EntitlementState(
      productId: productId,
      active: true,
      expiry: expiry,
      lastCheckedAt: _now(),
    );
    _onEntitlementUpdate(state);
  }

  void dispose() {
    _billingSub?.cancel();
    _controller.close();
    _changes.close();
  }
}

enum PremiumStatus { loading, premium, free }

/// Single source of truth the UI reads. Promotions show only for a *verified*
/// free user, so nothing flashes while billing is still being checked.
@immutable
class PremiumEntitlement {
  const PremiumEntitlement({
    required this.isPremium,
    required this.isEntitlementVerified,
    this.expiry,
    this.productId,
  });

  final bool isPremium;
  final bool isEntitlementVerified;
  final DateTime? expiry;
  final String? productId;

  bool get isSubscriptionActive => isPremium;
  bool get isSubscriptionLoading => !isEntitlementVerified && !isPremium;
  bool get hasLifetimePurchase => false; // only the weekly subscription exists
  bool get shouldShowPremiumPromotion => isEntitlementVerified && !isPremium;
  PremiumStatus get status => isPremium
      ? PremiumStatus.premium
      : (isEntitlementVerified ? PremiumStatus.free : PremiumStatus.loading);

  @override
  bool operator ==(Object other) =>
      other is PremiumEntitlement &&
      other.isPremium == isPremium &&
      other.isEntitlementVerified == isEntitlementVerified &&
      other.expiry == expiry &&
      other.productId == productId;

  @override
  int get hashCode =>
      Object.hash(isPremium, isEntitlementVerified, expiry, productId);
}

class PremiumEntitlementNotifier extends Notifier<PremiumEntitlement> {
  @override
  PremiumEntitlement build() {
    final service = ref.watch(premiumStatusServiceProvider);
    final sub = service.changes.listen((_) => state = _read(service));
    ref.onDispose(sub.cancel);
    return _read(service);
  }

  PremiumEntitlement _read(PremiumStatusService s) => PremiumEntitlement(
    isPremium: s.isPremium,
    isEntitlementVerified: s.isEntitlementVerified,
    expiry: s.subscriptionExpiry,
    productId: s.activeProductId,
  );
}

final premiumEntitlementProvider =
    NotifierProvider<PremiumEntitlementNotifier, PremiumEntitlement>(
      PremiumEntitlementNotifier.new,
    );

/// `isEntitlementVerified && !isPremium` – the only gate for promotional UI.
final shouldShowPremiumPromotionProvider = Provider<bool>(
  (ref) => ref.watch(
    premiumEntitlementProvider.select((e) => e.shouldShowPremiumPromotion),
  ),
);

final premiumStatusServiceProvider = Provider<PremiumStatusService>((ref) {
  final billing = ref.watch(billingServiceProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  final service = PremiumStatusService(
    billingService: billing,
    prefs: prefs,
    ref: ref,
  );
  ref.onDispose(service.dispose);
  return service;
});

final isPremiumProvider = Provider<bool>((ref) {
  // Authoritative + reactive; the persisted settings flag is only a mirror.
  return ref.watch(premiumEntitlementProvider.select((e) => e.isPremium));
});
