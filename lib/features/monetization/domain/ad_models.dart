import 'package:flutter/widgets.dart';

enum AdPlacement {
  languageFirstRun('Language (first run)'),
  languageSettings('Language (Settings)'),
  onboarding('Onboarding'),
  interstitial('5-click interstitial'),
  appOpen('App Open');

  const AdPlacement(this.label);
  final String label;
}

enum AdRequestState { idle, loading, ready, showing }

enum AdEventType { request, loaded, failed, impression, clicked, dismissed, discarded, skipped }

@immutable
class AdEvent {
  const AdEvent(this.placement, this.type, this.at, [this.detail]);
  final AdPlacement placement;
  final AdEventType type;
  final DateTime at;
  final String? detail;
}

/// Per-placement record. The timestamps are persisted locally; the request
/// state and counters are for diagnostics only.
@immutable
class PlacementState {
  const PlacementState({
    this.requestState = AdRequestState.idle,
    this.requestCount = 0,
    this.impressionCount = 0,
    this.lastRequestAt,
    this.lastImpressionAt,
    this.cooldownUntil,
    this.lastFailure,
  });

  final AdRequestState requestState;
  final int requestCount;
  final int impressionCount;
  final DateTime? lastRequestAt;
  final DateTime? lastImpressionAt;
  final DateTime? cooldownUntil;
  final String? lastFailure;

  bool inCooldown(DateTime now) => cooldownUntil != null && now.isBefore(cooldownUntil!);

  PlacementState copyWith({
    AdRequestState? requestState,
    int? requestCount,
    int? impressionCount,
    DateTime? lastRequestAt,
    DateTime? lastImpressionAt,
    DateTime? cooldownUntil,
    String? lastFailure,
    bool clearCooldown = false,
  }) {
    return PlacementState(
      requestState: requestState ?? this.requestState,
      requestCount: requestCount ?? this.requestCount,
      impressionCount: impressionCount ?? this.impressionCount,
      lastRequestAt: lastRequestAt ?? this.lastRequestAt,
      lastImpressionAt: lastImpressionAt ?? this.lastImpressionAt,
      cooldownUntil: clearCooldown ? null : (cooldownUntil ?? this.cooldownUntil),
      lastFailure: lastFailure ?? this.lastFailure,
    );
  }

  Map<String, Object?> toJson() => {
        'lastRequestAt': lastRequestAt?.millisecondsSinceEpoch,
        'lastImpressionAt': lastImpressionAt?.millisecondsSinceEpoch,
        'cooldownUntil': cooldownUntil?.millisecondsSinceEpoch,
      };

  factory PlacementState.fromJson(Map<String, dynamic> j) {
    DateTime? t(String k) => j[k] == null ? null : DateTime.fromMillisecondsSinceEpoch(j[k] as int);
    return PlacementState(
      lastRequestAt: t('lastRequestAt'),
      lastImpressionAt: t('lastImpressionAt'),
      cooldownUntil: t('cooldownUntil'),
    );
  }
}

@immutable
class AdDiagnostics {
  const AdDiagnostics({
    required this.placements,
    this.clickCount = 0,
    this.appOpenOverlay = false,
    this.consentAllowsAds = false,
    this.events = const [],
  });

  final Map<AdPlacement, PlacementState> placements;

  /// Eligible clicks in the current interstitial cycle.
  final int clickCount;
  final bool appOpenOverlay;
  final bool consentAllowsAds;
  final List<AdEvent> events;

  AdDiagnostics copyWith({
    Map<AdPlacement, PlacementState>? placements,
    int? clickCount,
    bool? appOpenOverlay,
    bool? consentAllowsAds,
    List<AdEvent>? events,
  }) {
    return AdDiagnostics(
      placements: placements ?? this.placements,
      clickCount: clickCount ?? this.clickCount,
      appOpenOverlay: appOpenOverlay ?? this.appOpenOverlay,
      consentAllowsAds: consentAllowsAds ?? this.consentAllowsAds,
      events: events ?? this.events,
    );
  }
}
