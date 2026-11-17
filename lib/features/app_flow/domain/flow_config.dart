/// Steps of the startup journey. Each maps to exactly one route.
enum FlowStep {
  language('/language'),
  paywall('/paywall?slot=first'),
  onboarding('/onboarding'),
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

/// Builds the ordered steps for this launch:
///
/// Flow A (First-time non-premium): Splash → Language → Paywall → Onboarding → Home
/// Flow B (Returning non-premium):   Splash → Paywall → Home
/// Flow C (Premium user):            Splash → Home (a first run still sets the
///                                   language and onboarding once; no paywalls)
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
  // Verified Premium (e.g. restored after a reinstall) still completes
  // language + onboarding once, but never sees a paywall.
  if (!firstLaunchCompleted) {
    return [
      if (!languageChosen) FlowStep.language,
      if (config.firstRunPaywall && !isPremium) FlowStep.paywall,
      if (!onboardingDone) FlowStep.onboarding,
      FlowStep.home,
    ];
  } else {
    return [
      if (config.returningPaywall && !isPremium) FlowStep.paywallReturning,
      FlowStep.home,
    ];
  }
}
