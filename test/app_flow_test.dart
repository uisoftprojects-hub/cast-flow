import 'package:castflow/features/app_flow/domain/flow_config.dart';
import 'package:castflow/features/app_flow/presentation/app_flow_controller.dart';
import 'package:castflow/features/settings/presentation/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

List<FlowStep> _flow({
  FlowConfig config = const FlowConfig(),
  bool firstLaunchCompleted = false,
  bool onboardingDone = false,
  bool languageChosen = false,
  bool isPremium = false,
}) =>
    buildFlow(
      config: config,
      firstLaunchCompleted: firstLaunchCompleted,
      onboardingDone: onboardingDone,
      languageChosen: languageChosen,
      isPremium: isPremium,
    );

void main() {
  group('buildFlow', () {
    test('first run: language, onboarding, paywall, home — each once', () {
      expect(_flow(), [FlowStep.language, FlowStep.onboarding, FlowStep.paywall, FlowStep.home]);
    });

    test('returning user: paywall, home', () {
      expect(_flow(firstLaunchCompleted: true, onboardingDone: true, languageChosen: true),
          [FlowStep.paywallReturning, FlowStep.home]);
    });

    test('Pro users skip the paywall', () {
      expect(_flow(isPremium: true), [FlowStep.language, FlowStep.onboarding, FlowStep.home]);
      expect(_flow(firstLaunchCompleted: true, isPremium: true), [FlowStep.home]);
    });

    test('paywall slots can be turned off', () {
      expect(_flow(config: const FlowConfig(firstRunPaywall: false)), [FlowStep.language, FlowStep.onboarding, FlowStep.home]);
    });

    test('an interrupted first run resumes at the next unfinished step', () {
      expect(_flow(languageChosen: true), [FlowStep.onboarding, FlowStep.paywall, FlowStep.home]);
      expect(_flow(languageChosen: true, onboardingDone: true), [FlowStep.paywall, FlowStep.home]);
    });
  });

  test('controller advances once per step and completes the first launch', () async {
    final c = await makeContainer();
    final flow = c.read(appFlowProvider.notifier);

    expect(flow.start(), '/language');
    expect(flow.advance(FlowStep.language), '/onboarding');
    // A stale/double tap on the previous step is ignored.
    expect(flow.advance(FlowStep.language), isNull);
    expect(flow.advance(FlowStep.onboarding), '/paywall?slot=first');
    expect(c.read(settingsProvider).firstLaunchCompleted, isFalse);
    expect(flow.advance(FlowStep.paywall), '/home');
    expect(c.read(settingsProvider).firstLaunchCompleted, isTrue);
    expect(c.read(appFlowProvider).finished, isTrue);
  });

  test('buying Pro mid-flow skips the paywall', () async {
    final c = await makeContainer();
    final flow = c.read(appFlowProvider.notifier)..start();
    flow.advance(FlowStep.language);
    c.read(settingsProvider.notifier).setPremium(true);
    expect(flow.advance(FlowStep.onboarding), '/home');
  });
}
