import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_providers.dart';
import '../../../core/navigation.dart';
import '../../../core/theme/app_theme.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../devices/presentation/device_providers.dart';
import '../../mirroring/presentation/mirroring_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/ad_adapter_factory.dart';
import '../domain/ad_adapter.dart';
import '../domain/ad_config.dart';
import '../domain/ad_models.dart';
import 'ad_route_observer.dart';

final adAdapterProvider = Provider<AdAdapter>(
  (ref) => createAdAdapter(rootNavigatorKey, () => ref.read(previewModeProvider)),
);

final adRouteObserverProvider = Provider<AdRouteObserver>((ref) => AdRouteObserver());

/// Injectable clock so the cooldown rules can be tested.
final adClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Owns every ad decision: eligibility, one request per placement, the
/// five-click interstitial cycle, App Open on resume, cooldowns and the
/// local event log. Screens never create ad objects themselves.
class AdManager extends Notifier<AdDiagnostics> {
  late AdAdapter _adapter;
  late AdRouteObserver _routes;
  late DateTime Function() _now;
  Future<void>? _init;

  // Interstitial cycle.
  LoadedFullScreenAd? _interstitial;
  bool _interstitialLoading = false;
  int _cycle = 0;

  // Full-screen / App Open.
  bool _fullScreenActive = false;
  bool _foreground = true;
  DateTime? _backgroundedAt;
  Route<void>? _overlayRoute;

  static const _clickKey = 'ad_click_count';
  static String _key(AdPlacement p) => 'ad_state_${p.name}';

  @override
  AdDiagnostics build() {
    _adapter = ref.watch(adAdapterProvider);
    _routes = ref.watch(adRouteObserverProvider)..onEligiblePush = (_) => registerEligibleClick();
    _now = ref.watch(adClockProvider);
    ref.onDispose(() => _interstitial?.dispose());

    final prefs = ref.read(sharedPrefsProvider);
    PlacementState load(AdPlacement p) {
      final raw = prefs.getString(_key(p));
      return raw == null ? const PlacementState() : PlacementState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    // A load that was in flight cannot survive a restart, so a cycle that had
    // already reached click 3 starts over.
    final clicks = prefs.getInt(_clickKey) ?? 0;
    return AdDiagnostics(
      placements: {for (final p in AdPlacement.values) p: load(p)},
      clickCount: clicks >= AdConfig.loadAtClick ? 0 : clicks,
    );
  }

  bool get _adsAllowed => !ref.read(settingsProvider).isPremium && state.consentAllowsAds;

  /// Gathers consent and initializes the SDK once.
  Future<void> ensureInitialized() => _init ??= () async {
        try {
          await _adapter.initialize();
        } catch (_) {}
        final ok = await _adapter.canRequestAds().catchError((_) => false);
        state = state.copyWith(consentAllowsAds: ok);
      }();

  // ---------------------------------------------------------------- native

  /// Loads the native ad for [placement]. Call only from the screen that
  /// shows it, once per visit; returns null when not eligible or no fill.
  Future<LoadedNativeAd?> loadNative(AdPlacement placement) async {
    await ensureInitialized();
    final ps = state.placements[placement]!;
    if (!_adsAllowed) return _skip(placement, 'not eligible');
    if (ps.inCooldown(_now())) return _skip(placement, 'cooldown');
    if (ps.requestState == AdRequestState.loading) return _skip(placement, 'request already in flight');

    _setPlacement(placement, (s) => s.copyWith(
          requestState: AdRequestState.loading,
          requestCount: s.requestCount + 1,
          lastRequestAt: _now(),
        ));
    _log(placement, AdEventType.request);
    try {
      final ad = await _adapter.loadNative(
        placement,
        medium: placement != AdPlacement.onboarding,
        onImpression: () => _impression(placement),
        onClicked: () => _log(placement, AdEventType.clicked),
      );
      _setPlacement(placement, (s) => s.copyWith(requestState: AdRequestState.ready));
      _log(placement, AdEventType.loaded);
      return ad;
    } catch (e) {
      _fail(placement, e, AdConfig.nativeFailureCooldown);
      return null;
    }
  }

  /// Disposes a screen's native ad when the screen is left.
  void releaseNative(AdPlacement placement, LoadedNativeAd? ad) {
    ad?.dispose();
    if (!ref.mounted) return;
    _setPlacement(placement, (s) => s.copyWith(requestState: AdRequestState.idle));
  }

  // ---------------------------------------------------------- interstitial

  /// Counts an eligible user action. Click 3 starts exactly one load; click 5
  /// shows it only if it is ready at that moment, otherwise it is discarded.
  void registerEligibleClick() {
    if (!_adsAllowed || _fullScreenActive) return;
    const p = AdPlacement.interstitial;
    if (state.placements[p]!.inCooldown(_now())) return;

    final clicks = state.clickCount + 1;
    _setClicks(clicks);

    if (clicks == AdConfig.loadAtClick && _interstitial == null && !_interstitialLoading) {
      _loadInterstitial(_cycle);
    }
    if (clicks >= AdConfig.showAtClick) _fifthClick(_cycle);
  }

  Future<void> _loadInterstitial(int cycle) async {
    const p = AdPlacement.interstitial;
    _interstitialLoading = true;
    _setPlacement(p, (s) => s.copyWith(
          requestState: AdRequestState.loading,
          requestCount: s.requestCount + 1,
          lastRequestAt: _now(),
        ));
    _log(p, AdEventType.request, 'click ${AdConfig.loadAtClick}');
    try {
      final ad = await _adapter.loadInterstitial();
      _interstitialLoading = false;
      if (!ref.mounted) return ad.dispose();
      if (cycle != _cycle) {
        // Its click-5 opportunity already passed: never show it later.
        ad.dispose();
        _setPlacement(p, (s) => s.copyWith(requestState: AdRequestState.idle));
        _log(p, AdEventType.discarded, 'loaded after its click-5 opportunity');
        return;
      }
      _interstitial = ad;
      _setPlacement(p, (s) => s.copyWith(requestState: AdRequestState.ready));
      _log(p, AdEventType.loaded);
    } catch (e) {
      _interstitialLoading = false;
      if (!ref.mounted) return;
      _fail(p, e, AdConfig.failureCooldown);
      // End this attempt; the next cycle starts after the cooldown.
      if (cycle == _cycle) _endCycle();
    }
  }

  Future<void> _fifthClick(int cycle) async {
    const p = AdPlacement.interstitial;
    final ad = _interstitial;
    if (ad == null) {
      _log(p, AdEventType.discarded, 'not ready at click ${AdConfig.showAtClick}');
      _endCycle();
      return;
    }
    // Let the click's navigation settle, then re-check the show policy.
    await Future<void>.delayed(AdConfig.showDelay);
    if (!ref.mounted || cycle != _cycle) return;
    if (!_canShowFullScreen()) {
      ad.dispose();
      _log(p, AdEventType.discarded, 'blocked by current screen');
      _endCycle();
      return;
    }
    _interstitial = null;
    _fullScreenActive = true;
    _setPlacement(p, (s) => s.copyWith(requestState: AdRequestState.showing));
    await ad.show(onImpression: () => _impression(p), onClicked: () => _log(p, AdEventType.clicked));
    ad.dispose();
    _fullScreenActive = false;
    if (!ref.mounted) return;
    _log(p, AdEventType.dismissed);
    // The next cycle begins only now, after dismiss; no request here.
    _endCycle();
  }

  void _endCycle() {
    _cycle++;
    _interstitial?.dispose();
    _interstitial = null;
    _setClicks(0);
    _setPlacement(AdPlacement.interstitial, (s) => s.copyWith(requestState: AdRequestState.idle));
  }

  bool _canShowFullScreen() {
    if (_fullScreenActive || state.appOpenOverlay) return false;
    if (!_routes.topIsSafe) return false;
    if (ref.read(connectionProvider).isConnecting) return false;
    if (ref.read(mirroringProvider).isBusy) return false;
    return true;
  }

  // -------------------------------------------------------------- App Open

  void onBackgrounded() {
    _foreground = false;
    _backgroundedAt = _now();
  }

  /// Called on a background → foreground transition only (never on route
  /// changes or system dialogs).
  Future<void> onResumed() async {
    _foreground = true;
    final since = _backgroundedAt;
    _backgroundedAt = null;
    const p = AdPlacement.appOpen;
    if (since == null || _now().difference(since) < AdConfig.appOpenMinBackground) return;
    if (!_adsAllowed) return;
    // Not before the user has reached the usable app.
    if (!ref.read(settingsProvider).firstLaunchCompleted || !ref.read(appFlowProvider).finished) return;
    final last = state.placements[p]!.lastImpressionAt;
    if (last != null && _now().difference(last) < AdConfig.appOpenMinInterval) {
      _skip(p, 'frequency cap');
      return;
    }
    if (!_canShowFullScreen()) return;

    _setOverlay(true);
    _setPlacement(p, (s) => s.copyWith(
          requestState: AdRequestState.loading,
          requestCount: s.requestCount + 1,
          lastRequestAt: _now(),
        ));
    _log(p, AdEventType.request, 'resume');
    LoadedFullScreenAd ad;
    try {
      ad = await _adapter.loadAppOpen().timeout(AdConfig.appOpenLoadTimeout);
    } catch (e) {
      if (!ref.mounted) return;
      _fail(p, e, Duration.zero);
      _setOverlay(false);
      return;
    }
    if (!ref.mounted) return ad.dispose();
    if (!_foreground) {
      ad.dispose();
      _setOverlay(false);
      _log(p, AdEventType.discarded, 'app left foreground');
      return;
    }
    _fullScreenActive = true;
    _setPlacement(p, (s) => s.copyWith(requestState: AdRequestState.showing));
    await ad.show(onImpression: () => _impression(p), onClicked: () => _log(p, AdEventType.clicked));
    ad.dispose();
    _fullScreenActive = false;
    if (!ref.mounted) return;
    _setPlacement(p, (s) => s.copyWith(requestState: AdRequestState.idle));
    _log(p, AdEventType.dismissed);
    _setOverlay(false);
  }

  /// "Ad is loading" surface above the current screen. Back is blocked only
  /// while it is up; it is always removed on success, failure or timeout.
  void _setOverlay(bool on) {
    state = state.copyWith(appOpenOverlay: on);
    final nav = rootNavigatorKey.currentState;
    if (on && nav != null && _overlayRoute == null) {
      _overlayRoute = PageRouteBuilder<void>(
        settings: const RouteSettings(name: '/ad-loading'),
        opaque: false,
        transitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, _, _) => const _AdLoadingOverlay(),
        transitionsBuilder: (_, a, _, child) => FadeTransition(opacity: a, child: child),
      );
      nav.push(_overlayRoute!);
    } else if (!on && _overlayRoute != null) {
      final route = _overlayRoute!;
      _overlayRoute = null;
      if (route.isActive) route.navigator?.removeRoute(route);
    }
  }

  // ----------------------------------------------------------------- state

  void _impression(AdPlacement p) {
    _setPlacement(p, (s) => s.copyWith(impressionCount: s.impressionCount + 1, lastImpressionAt: _now()));
    _log(p, AdEventType.impression);
  }

  void _fail(AdPlacement p, Object e, Duration cooldown) {
    _setPlacement(p, (s) => s.copyWith(
          requestState: AdRequestState.idle,
          lastFailure: e.toString(),
          cooldownUntil: cooldown == Duration.zero ? null : _now().add(cooldown),
        ));
    _log(p, AdEventType.failed, e.toString());
  }

  Null _skip(AdPlacement p, String why) {
    _log(p, AdEventType.skipped, why);
    return null;
  }

  void _setClicks(int clicks) {
    state = state.copyWith(clickCount: clicks);
    ref.read(sharedPrefsProvider).setInt(_clickKey, clicks);
  }

  void _setPlacement(AdPlacement p, PlacementState Function(PlacementState) update) {
    final next = update(state.placements[p]!);
    state = state.copyWith(placements: {...state.placements, p: next});
    ref.read(sharedPrefsProvider).setString(_key(p), jsonEncode(next.toJson()));
  }

  void _log(AdPlacement p, AdEventType type, [String? detail]) {
    final events = [AdEvent(p, type, _now(), detail), ...state.events];
    state = state.copyWith(events: events.take(AdConfig.maxLoggedEvents).toList());
  }
}

final adManagerProvider = NotifierProvider<AdManager, AdDiagnostics>(AdManager.new);

class _AdLoadingOverlay extends StatelessWidget {
  const _AdLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: context.palette.background,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox.square(dimension: 32, child: CircularProgressIndicator(strokeWidth: 3)),
              const SizedBox(height: 16),
              Text('Ad is loading', style: context.text.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
