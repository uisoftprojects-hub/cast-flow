/// Steps of the startup journey. Each maps to exactly one route.
enum FlowStep {
  language('/language'),
  onboarding('/onboarding'),
  paywall('/paywall?slot=first'),
  paywallReturning('/paywall?slot=returning'),
  home('/home');

  const FlowStep(this.route);
  final String route;

  bool get isPaywall => this == paywall || this == paywallReturning;
}

/// Local build-time switches for the startup journey (no remote config).
class FlowConfig {
  const FlowConfig({this.firstRunPaywall = true, this.returningPaywall = true});

  final bool firstRunPaywall;
  final bool returningPaywall;
}

/// Builds the ordered steps for this launch. Every screen appears at most
/// once:
///
/// First run:  Language → Onboarding → Paywall → Home
/// Returning:  Paywall → Home
///
/// Finished milestones are skipped, so an interrupted first run resumes at
/// the next unfinished step.
List<FlowStep> buildFlow({
  required FlowConfig config,
  required bool firstLaunchCompleted,
  required bool onboardingDone,
  required bool languageChosen,
  required bool isPremium,
}) {
  return [
    if (!firstLaunchCompleted) ...[
      if (!languageChosen) FlowStep.language,
      if (!onboardingDone) FlowStep.onboarding,
      if (config.firstRunPaywall && !isPremium) FlowStep.paywall,
    ] else if (config.returningPaywall && !isPremium)
      FlowStep.paywallReturning,
    FlowStep.home,
  ];
}
