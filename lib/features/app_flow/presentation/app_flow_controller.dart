import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
class AppFlowController extends Notifier<FlowState> {
  @override
  FlowState build() => const FlowState();

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
    return step.route;
  }
}

final appFlowProvider = NotifierProvider<AppFlowController, FlowState>(AppFlowController.new);
