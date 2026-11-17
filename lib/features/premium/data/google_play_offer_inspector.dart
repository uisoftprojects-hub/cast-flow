import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import '../domain/trial_duration_parser.dart';

/// Resolved subscription offer details for a Google Play base plan.
class ResolvedSubscriptionOffer {
  const ResolvedSubscriptionOffer({
    required this.productId,
    required this.basePlanId,
    required this.offerToken,
    required this.recurringPrice,
    required this.isFreeTrialEligible,
    this.freeTrialPeriodIso,
    this.freeTrialDurationText,
    this.offerId,
    this.rawRecurringPrice = 0.0,
    this.currencyCode = '',
  });

  final String productId;
  final String basePlanId;
  final String offerToken;
  final String recurringPrice;
  final bool isFreeTrialEligible;
  final String? freeTrialPeriodIso;
  final String? freeTrialDurationText;
  final String? offerId;
  final double rawRecurringPrice;
  final String currencyCode;
}

/// Helper to inspect Google Play subscription pricing phases and determine
/// trial availability based strictly on Google Play Billing offer eligibility.
abstract final class GooglePlayOfferInspector {
  /// Inspects available subscription offers for [productId] matching [targetBasePlanId].
  ///
  /// Criteria for a free trial:
  /// - The matching base plan exists (`targetBasePlanId`).
  /// - An offer for that base plan exists.
  /// - The offer contains an actual free-trial pricing phase (`priceAmountMicros == 0`).
  /// - Google Play returned this offer (which confirms the current user is eligible).
  /// - The offer token is valid and non-empty.
  ///
  /// Distinctions:
  /// - A zero-cost phase (`priceAmountMicros == 0`) IS a free trial.
  /// - A discounted phase (`priceAmountMicros > 0`) is NOT a free trial.
  /// - A regular recurring price is NOT a free trial.
  static ResolvedSubscriptionOffer? inspect({
    required String productId,
    required String targetBasePlanId,
    required List<SubscriptionOfferDetailsWrapper>? offers,
  }) {
    if (offers == null || offers.isEmpty) return null;

    // 1. Filter for the exact base plan ID
    final matchingOffers = offers
        .where((o) => o.basePlanId == targetBasePlanId)
        .toList();
    if (matchingOffers.isEmpty) return null;

    SubscriptionOfferDetailsWrapper? freeTrialOffer;
    PricingPhaseWrapper? freeTrialPhase;
    PricingPhaseWrapper? recurringPhase;

    // 2. Search for an eligible free trial offer
    for (final offer in matchingOffers) {
      if (offer.offerIdToken.isEmpty) continue;

      final phases = offer.pricingPhases;
      if (phases.isEmpty) continue;

      // Check if any phase in this offer is a genuine zero-cost trial
      for (var i = 0; i < phases.length; i++) {
        final phase = phases[i];
        if (phase.priceAmountMicros == 0) {
          // Zero-cost phase: this is a free trial
          freeTrialOffer = offer;
          freeTrialPhase = phase;

          // The recurring phase is typically the next phase
          if (i + 1 < phases.length) {
            recurringPhase = phases[i + 1];
          }
          break;
        }
      }

      if (freeTrialOffer != null) break;
    }

    // 3. If an eligible free trial offer was found with valid phases
    if (freeTrialOffer != null && freeTrialPhase != null) {
      final isoPeriod = freeTrialPhase.billingPeriod;
      final durationText = TrialDurationParser.parse(isoPeriod);

      // Determine recurring price: either from the offer's second phase, or from the base plan
      final recurring =
          recurringPhase ??
          _findBasePlanRecurringPhase(matchingOffers) ??
          freeTrialOffer.pricingPhases.last;

      return ResolvedSubscriptionOffer(
        productId: productId,
        basePlanId: targetBasePlanId,
        offerId: freeTrialOffer.offerId,
        offerToken: freeTrialOffer.offerIdToken,
        recurringPrice: recurring.formattedPrice,
        rawRecurringPrice: recurring.priceAmountMicros / 1000000.0,
        currencyCode: recurring.priceCurrencyCode,
        isFreeTrialEligible: durationText != null,
        freeTrialPeriodIso: isoPeriod,
        freeTrialDurationText: durationText,
      );
    }

    // 4. Free trial unavailable: fallback to base plan default recurring offer
    final defaultOffer = matchingOffers.firstWhere(
      (o) => o.offerId == null || o.offerId!.isEmpty,
      orElse: () => matchingOffers.first,
    );

    if (defaultOffer.offerIdToken.isEmpty) return null;

    final basePhase = defaultOffer.pricingPhases.firstWhere(
      (p) => p.priceAmountMicros > 0,
      orElse: () => defaultOffer.pricingPhases.first,
    );

    return ResolvedSubscriptionOffer(
      productId: productId,
      basePlanId: targetBasePlanId,
      offerId: defaultOffer.offerId,
      offerToken: defaultOffer.offerIdToken,
      recurringPrice: basePhase.formattedPrice,
      rawRecurringPrice: basePhase.priceAmountMicros / 1000000.0,
      currencyCode: basePhase.priceCurrencyCode,
      isFreeTrialEligible: false,
      freeTrialPeriodIso: null,
      freeTrialDurationText: null,
    );
  }

  static PricingPhaseWrapper? _findBasePlanRecurringPhase(
    List<SubscriptionOfferDetailsWrapper> offers,
  ) {
    for (final o in offers) {
      if (o.offerId == null || o.offerId!.isEmpty) {
        for (final p in o.pricingPhases) {
          if (p.priceAmountMicros > 0) return p;
        }
      }
    }
    return null;
  }
}
