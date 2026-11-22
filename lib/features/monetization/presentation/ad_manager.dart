import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/app_providers.dart';
import '../../../core/navigation.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../premium/domain/premium_status_service.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/ad_adapter_factory.dart';
import '../domain/ad_adapter.dart';
import '../domain/ad_config.dart';
import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';
import '../domain/consent_manager.dart';
import 'ad_display_coordinator.dart';
import 'ad_route_observer.dart';
import 'app_open_ad_manager.dart';
import 'click_count_interstitial_manager.dart';
import 'native_ad_manager.dart';
import 'splash_interstitial_manager.dart';

final adAdapterProvider = Provider<AdAdapter>(
  (ref) =>
      createAdAdapter(rootNavigatorKey, () => ref.read(previewModeProvider)),
);

final adRouteObserverProvider = Provider<AdRouteObserver>((ref) {
  // Watches route stack for topIsSafe checks (App Open ad safety).
  // Does not double-count clicks; user taps are recorded directly by UI widgets.
  return AdRouteObserver();
});

/// Injectable clock so timing and cooldown rules can be tested cleanly.
final adClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final consentManagerProvider = Provider<ConsentManager>(
  (ref) => ConsentManager(),
);

/// Centralized AdManager acting as the top-level orchestration layer for all monetization subsystems:
/// - Enforces global Premium User Protection (Rule 1 priority).
/// - Splash Interstitial Manager.
/// - Native Ad Manager (Language & Onboarding).
/// - Click-Count Interstitial Manager (Bottom Navigation, max 1 per session).
/// - App Open Ad Manager (7-second transparent loading overlay, delayed show, freshness).
/// - AdDisplayCoordinator (Single full-screen ad presentation lock).
class AdManager extends Notifier<AdDiagnostics> {
  late AdAdapter _adapter;
  late DateTime Function() _now;
  Future<void>? _init;

  static const _clickKey = 'ad_click_count';
  static String _key(AdPlacement p) => 'ad_state_${p.name}';

  @override
  AdDiagnostics build() {
    _adapter = ref.watch(adAdapterProvider);
    _now = ref.watch(adClockProvider);

    ref.listen<bool>(settingsProvider.select((s) => s.isPremium), (
      prev,
      isPremium,
    ) {
      if (isPremium) {
        onPremiumPurchased();
      }
    });

    final prefs = ref.read(sharedPrefsProvider);
    PlacementState load(AdPlacement p) {
      final raw = prefs.getString(_key(p));
      return raw == null
          ? const PlacementState()
          : PlacementState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    final clicks = prefs.getInt(_clickKey) ?? 0;
    return AdDiagnostics(
      placements: {for (final p in AdPlacement.values) p: load(p)},
      clickCount: clicks,
    );
  }

  bool get _isPremium =>
      ref.read(settingsProvider).isPremium ||
      ref.read(premiumStatusServiceProvider).isPremium;

  bool get _adsAllowed => !_isPremium && state.consentAllowsAds;

  /// Authoritative initialization of consent and SDK.
  /// Premium users skip ad requests and consent flows.
  Future<void> ensureInitialized() => _init ??= () async {
    await AdMobConfig.initializeNativeConfig();

    if (_isPremium) {
      state = state.copyWith(consentAllowsAds: false);
      return;
    }

    final consent = ref.read(consentManagerProvider);
    final ok = await consent.gatherConsentAndInitialize(isPremium: _isPremium);

    try {
      await _adapter.initialize();
    } catch (_) {}

    state = state.copyWith(consentAllowsAds: ok);
  }();

  // ---------------------------------------------------------------- Native

  /// Loads native ad for [placement].
  /// Never loads if user is premium.
  Future<LoadedNativeAd?> loadNative(AdPlacement placement) async {
    if (_isPremium) {
      return _skip(placement, 'premium user protected');
    }
    await ensureInitialized();
    final ps = state.placements[placement]!;
    if (!_adsAllowed) return _skip(placement, 'ads not allowed');
    if (ps.inCooldown(_now())) return _skip(placement, 'cooldown');
    if (ps.requestState == AdRequestState.loading) {
      return _skip(placement, 'request in flight');
    }

    _setPlacement(
      placement,
      (s) => s.copyWith(
        requestState: AdRequestState.loading,
        requestCount: s.requestCount + 1,
        lastRequestAt: _now(),
      ),
    );
    _log(placement, AdEventType.request);

    try {
      final ad = await _adapter.loadNative(
        placement,
        medium: placement != AdPlacement.onboarding,
        onImpression: () => _impression(placement),
        onClicked: () => _log(placement, AdEventType.clicked),
      );
      _setPlacement(
        placement,
        (s) => s.copyWith(requestState: AdRequestState.ready),
      );
      _log(placement, AdEventType.loaded);
      return ad;
    } catch (e) {
      _fail(placement, e, AdMobConfig.nativeFailureCooldown);
      return null;
    }
  }

  void releaseNative(AdPlacement placement, LoadedNativeAd? ad) {
    ad?.dispose();
    if (!ref.mounted) return;
    _setPlacement(
      placement,
      (s) => s.copyWith(requestState: AdRequestState.idle),
    );
  }

  // -------------------------------------------------------------- App Open

  /// Whether the app was minimized on an eligible screen (Home onwards, not
  /// splash / language / onboarding / paywall). Latched at background time so a
  /// splash that finishes while minimized can't make the return eligible.
  bool _backgroundedOnSafeScreen = false;

  void onBackgrounded() {
    final appOpen = ref.read(appOpenAdManagerProvider);
    // pause + hide both fire for one trip; only evaluate on the first.
    if (!appOpen.isBackgrounded) {
      _backgroundedOnSafeScreen =
          ref.read(appFlowProvider).finished &&
          ref.read(adRouteObserverProvider).topIsSafe;
    }
    appOpen.onBackgrounded();
  }

  Future<void> onResumed() async {
    if (_isPremium) return;
    // Only once the user has actually landed on Home (never during the
    // splash -> language/onboarding/paywall -> home journey), and never over
    // the paywall or any other blocked screen.
    // A merely preloaded interstitial is not an overlap; the full-screen
    // coordinator (canShow) blocks real overlap with a showing ad.
    final flowFinished = ref.read(appFlowProvider).finished;
    final routeSafe = ref.read(adRouteObserverProvider).topIsSafe;
    final isAppEligible =
        flowFinished && routeSafe && _backgroundedOnSafeScreen;
    _backgroundedOnSafeScreen = false;
    if (!isAppEligible) {
      AdLogger.d(
        AdState.requestSkipped,
        placement: AdPlacement.appOpen,
        adType: 'AppOpen',
        message:
            'App Open not eligible: flowFinished=$flowFinished, routeSafe=$routeSafe',
      );
    }

    await ref
        .read(appOpenAdManagerProvider)
        .onResumed(
          isPremium: _isPremium,
          isAppEligible: isAppEligible,
          onImpression: () => _impression(AdPlacement.appOpen),
          onClicked: () => _log(AdPlacement.appOpen, AdEventType.clicked),
        );
  }

  // ---------------------------------------------- Premium Purchase Event

  /// Immediately terminates all pending ad displays and disposes all loaded ads across all subsystems
  void onPremiumPurchased() {
    AdLogger.i(
      AdState.premiumPurge,
      adType: 'AdManager',
      message:
          'User purchased Premium. Purged all active and cached ads across all monetization subsystems.',
    );
    state = state.copyWith(consentAllowsAds: false);
    ref.read(splashInterstitialManagerProvider).onPremiumPurchased();
    ref.read(nativeAdManagerProvider).onPremiumPurchased();
    ref.read(clickCountInterstitialManagerProvider).onPremiumPurchased();
    ref.read(appOpenAdManagerProvider).onPremiumPurchased();
    ref.read(adDisplayCoordinatorProvider).forceDismissAll();
  }

  // ----------------------------------------------------------------- State & Telemetry

  void _impression(AdPlacement p) {
    _setPlacement(
      p,
      (s) => s.copyWith(
        impressionCount: s.impressionCount + 1,
        lastImpressionAt: _now(),
      ),
    );
    _log(p, AdEventType.impression);
  }

  void _fail(AdPlacement p, Object e, Duration cooldown) {
    _setPlacement(
      p,
      (s) => s.copyWith(
        requestState: AdRequestState.idle,
        lastFailure: e.toString(),
        cooldownUntil: cooldown == Duration.zero ? null : _now().add(cooldown),
      ),
    );
    _log(p, AdEventType.failed, e.toString());
  }

  Null _skip(AdPlacement p, String why) {
    _log(p, AdEventType.skipped, why);
    return null;
  }

  void _setPlacement(
    AdPlacement p,
    PlacementState Function(PlacementState) update,
  ) {
    final next = update(state.placements[p]!);
    state = state.copyWith(placements: {...state.placements, p: next});
    ref.read(sharedPrefsProvider).setString(_key(p), jsonEncode(next.toJson()));
  }

  void _log(AdPlacement p, AdEventType type, [String? detail]) {
    final events = [AdEvent(p, type, _now(), detail), ...state.events];
    state = state.copyWith(
      events: events.take(AdMobConfig.maxLoggedEvents).toList(),
    );

    AdState adState;
    switch (type) {
      case AdEventType.request:
        adState = AdState.requestStart;
      case AdEventType.loaded:
        adState = AdState.loaded;
      case AdEventType.failed:
        adState = AdState.loadFailed;
      case AdEventType.impression:
        adState = AdState.impression;
      case AdEventType.clicked:
        adState = AdState.clicked;
      case AdEventType.skipped:
        adState = AdState.requestSkipped;
      case AdEventType.dismissed:
        adState = AdState.dismissed;
      case AdEventType.discarded:
        adState = AdState.expiredDiscarded;
    }

    AdLogger.log(
      state: adState,
      placement: p,
      adType: p.format,
      unitId: AdMobConfig.unitId(p),
      message: detail,
      level: type == AdEventType.failed ? AdLogLevel.warn : AdLogLevel.info,
    );

    _track(p, type, detail);
  }

  final _requestedAt = <AdPlacement, DateTime>{};

  void _track(AdPlacement p, AdEventType type, String? detail) {
    final base = <String, Object?>{
      AnalyticsParam.adName: p.analyticsName,
      AnalyticsParam.adFormat: p.format,
      AnalyticsParam.adUnit: AdMobConfig.unitId(p).split('/').last,
    };
    final analytics = ref.read(analyticsProvider);
    switch (type) {
      case AdEventType.request:
        _requestedAt[p] = _now();
        analytics.log(AnalyticsEvent.adRequest, {
          ...base,
          AnalyticsParam.source: detail,
        });
      case AdEventType.loaded:
        final at = _requestedAt[p];
        analytics.log(AnalyticsEvent.adLoadSuccess, {
          ...base,
          AnalyticsParam.loadMs: at == null
              ? null
              : _now().difference(at).inMilliseconds,
        });
      case AdEventType.failed:
        final message = detail ?? '';
        final noFill = message.toLowerCase().contains('no fill');
        analytics.log(
          noFill ? AnalyticsEvent.adNoFill : AnalyticsEvent.adLoadFail,
          {...base, AnalyticsParam.errorMessage: message},
        );
      case AdEventType.impression:
        analytics.log(AnalyticsEvent.adImpression, base);
      case AdEventType.clicked:
        analytics.log(AnalyticsEvent.adClick, base);
      case AdEventType.dismissed ||
          AdEventType.discarded ||
          AdEventType.skipped:
        break;
    }
  }
}

final adManagerProvider = NotifierProvider<AdManager, AdDiagnostics>(
  AdManager.new,
);
