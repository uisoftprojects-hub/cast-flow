import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/app_providers.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/flow_config.dart';

final flowConfigProvider = Provider<FlowConfig>((ref) => const FlowConfig());

@immutable
class FlowState {
  const FlowState({this.steps = const [], this.index = -1});
  final List<FlowStep> steps;
  final int index;

  FlowStep? get current => index >= 0 && index < steps.length ? steps[index] : null;
  bool get finished => current == FlowStep.home;
}

/// The single place that decides where the startup journey goes next.
/// Screens never check first-run flags themselves; they call [advance].
///
/// Also reports the splash → home funnel: a `_view` event when each step is
/// entered, a `_done` event when it is completed, and `funnel_drop` when the
/// user leaves the app before reaching Home.
class AppFlowController extends Notifier<FlowState> {
  static const _launchCountKey = 'analytics_launch_count';

  final _launchedAt = DateTime.now();
  bool _firstOpen = false;
  AppLifecycleListener? _lifecycle;

  @override
  FlowState build() {
    _lifecycle = AppLifecycleListener(
      onHide: () {
        if (state.current != null && !state.finished) {
          _analytics.log(AnalyticsEvent.funnelDrop, {
            AnalyticsParam.step: state.current!.name,
            AnalyticsParam.firstOpen: _firstOpen,
            AnalyticsParam.elapsedMs: _elapsed,
          });
        }
      },
    );
    ref.onDispose(() => _lifecycle?.dispose());
    return const FlowState();
  }

  Analytics get _analytics => ref.read(analyticsProvider);
  int get _elapsed => DateTime.now().difference(_launchedAt).inMilliseconds;

  /// Called by Splash as soon as it appears.
  void splashShown() {
    final s = ref.read(settingsProvider);
    _firstOpen = !s.firstLaunchCompleted;
    final prefs = ref.read(sharedPrefsProvider);
    final launches = (prefs.getInt(_launchCountKey) ?? 0) + 1;
    prefs.setInt(_launchCountKey, launches);
    _analytics
      ..userProperty(AnalyticsUserProperty.isPremium, s.isPremium.toString())
      ..userProperty(AnalyticsUserProperty.appLanguage, s.languageCode)
      ..userProperty(AnalyticsUserProperty.firstOpenDone, s.firstLaunchCompleted.toString())
      ..log(AnalyticsEvent.appLaunch, {
        AnalyticsParam.firstOpen: _firstOpen,
        AnalyticsParam.launchCount: launches,
        AnalyticsParam.language: s.languageCode,
      })
      ..log(AnalyticsEvent.funnelSplashView, {AnalyticsParam.firstOpen: _firstOpen});
  }

  /// Called once by Splash. Returns the first route of this launch.
  String start() {
    final s = ref.read(settingsProvider);
    final steps = buildFlow(
      config: ref.read(flowConfigProvider),
      firstLaunchCompleted: s.firstLaunchCompleted,
      onboardingDone: s.onboardingDone,
      languageChosen: s.languageChosen,
      isPremium: s.isPremium,
    );
    state = FlowState(steps: steps, index: 0);
    return _enter(steps.first);
  }

  /// Completes [from] and returns the next route. Ignores stale calls (e.g. a
  /// double tap) so a step can never be advanced twice.
  String? advance(FlowStep from) {
    if (state.current != from) return null;
    _funnel(from, done: true);
    var next = state.index + 1;
    // Skip paywalls if the user became Pro during this launch.
    while (next < state.steps.length && state.steps[next].isPaywall && ref.read(settingsProvider).isPremium) {
      next++;
    }
    if (next >= state.steps.length) return FlowStep.home.route;
    state = FlowState(steps: state.steps, index: next);
    return _enter(state.steps[next]);
  }

  String _enter(FlowStep step) {
    final settings = ref.read(settingsProvider.notifier);
    if (step.isPaywall) settings.markPaywallShown();
    if (step == FlowStep.home && !ref.read(settingsProvider).firstLaunchCompleted) {
      settings.completeFirstLaunch();
    }
    _funnel(step, done: false);
    return step.route;
  }

  void _funnel(FlowStep step, {required bool done}) {
    // Paywall completion is covered by paywall_close; Home has no "done".
    final String? name = switch ((step, done)) {
      (FlowStep.language, false) => AnalyticsEvent.funnelLanguageView,
      (FlowStep.language, true) => AnalyticsEvent.funnelLanguageDone,
      (FlowStep.onboarding, false) => AnalyticsEvent.funnelOnboardingView,
      (FlowStep.onboarding, true) => AnalyticsEvent.funnelOnboardingDone,
      (FlowStep.paywall || FlowStep.paywallReturning, false) => AnalyticsEvent.funnelPaywallView,
      (FlowStep.paywall || FlowStep.paywallReturning, true) => null,
      (FlowStep.home, false) => AnalyticsEvent.funnelHomeView,
      (FlowStep.home, true) => null,
    };
    if (name == null) return;
    _analytics.log(name, {
      AnalyticsParam.firstOpen: _firstOpen,
      AnalyticsParam.elapsedMs: _elapsed,
      if (step.isPaywall) AnalyticsParam.source: step == FlowStep.paywall ? 'first_open' : 'returning',
      if (step == FlowStep.language && done) AnalyticsParam.language: ref.read(settingsProvider).languageCode,
    });
  }
}

final appFlowProvider = NotifierProvider<AppFlowController, FlowState>(AppFlowController.new);
