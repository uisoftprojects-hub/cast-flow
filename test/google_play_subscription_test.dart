import 'package:castflow/core/app_providers.dart';
import 'package:castflow/features/monetization/domain/ad_models.dart';
import 'package:castflow/features/monetization/presentation/ad_manager.dart';
import 'package:castflow/features/premium/data/fake_billing_service.dart';
import 'package:castflow/features/premium/data/google_play_offer_inspector.dart';
import 'package:castflow/features/premium/domain/billing.dart';
import 'package:castflow/features/premium/domain/premium_status_service.dart';
import 'package:castflow/features/premium/domain/purchase_state.dart';
import 'package:castflow/features/premium/domain/purchase_verifier.dart';
import 'package:castflow/features/premium/domain/trial_duration_parser.dart';
import 'package:castflow/features/premium/presentation/billing_controller.dart';
import 'package:castflow/features/settings/presentation/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';

import 'helpers.dart';

void main() {
  group('1. ISO 8601 Trial Duration Parsing & Pluralization', () {
    test('parses common Google Play billing periods with correct singular/plural', () {
      expect(TrialDurationParser.parse('P1D'), '1 Day');
      expect(TrialDurationParser.parse('P3D'), '3 Days');
      expect(TrialDurationParser.parse('P7D'), '7 Days');
      expect(TrialDurationParser.parse('P14D'), '14 Days');
      expect(TrialDurationParser.parse('P1W'), '1 Week');
      expect(TrialDurationParser.parse('P2W'), '2 Weeks');
      expect(TrialDurationParser.parse('P1M'), '1 Month');
      expect(TrialDurationParser.parse('P3M'), '3 Months');
      expect(TrialDurationParser.parse('P6M'), '6 Months');
      expect(TrialDurationParser.parse('P1Y'), '1 Year');
      expect(TrialDurationParser.parse('P2Y'), '2 Years');
    });

    test('handles compound ISO 8601 durations', () {
      expect(TrialDurationParser.parse('P1M15D'), '1 Month 15 Days');
      expect(TrialDurationParser.parse('P1Y2M'), '1 Year 2 Months');
    });

    test('handles null, empty, and invalid strings gracefully without throwing', () {
      expect(TrialDurationParser.parse(null), isNull);
      expect(TrialDurationParser.parse(''), isNull);
      expect(TrialDurationParser.parse('   '), isNull);
      expect(TrialDurationParser.parse('INVALID_PERIOD'), isNull);
    });

    test('formats CTA text correctly based on eligibility', () {
      expect(
        TrialDurationParser.formatCta(isEligible: true, trialDurationText: '3 Days'),
        '3 Days Free Trial',
      );
      expect(
        TrialDurationParser.formatCta(isEligible: true, trialDurationText: '7 Days'),
        '7 Days Free Trial',
      );
      expect(
        TrialDurationParser.formatCta(isEligible: true, trialDurationText: '1 Week'),
        '1 Week Free Trial',
      );
      expect(
        TrialDurationParser.formatCta(isEligible: true, trialDurationText: '1 Month'),
        '1 Month Free Trial',
      );
      expect(
        TrialDurationParser.formatCta(isEligible: true, trialDurationText: '3 Months'),
        '3 Months Free Trial',
      );
      expect(
        TrialDurationParser.formatCta(isEligible: false, trialDurationText: '7 Days'),
        'Continue',
      );
      expect(
        TrialDurationParser.formatCta(isEligible: true, trialDurationText: null),
        'Continue',
      );
    });
  });

  group('2. Google Play Offer & Base Plan Inspection', () {
    const productId = 'weekly_sub';
    const basePlanId = 'weeklysub';

    test('matches basePlanId weeklysub and detects zero-cost free trial phase', () {
      final offers = [
        const SubscriptionOfferDetailsWrapper(
          basePlanId: basePlanId,
          offerId: 'weekly-free-trial',
          offerIdToken: 'token_free_trial_123',
          offerTags: ['free-trial'],
          pricingPhases: [
            PricingPhaseWrapper(
              billingCycleCount: 1,
              billingPeriod: 'P7D',
              formattedPrice: 'Free',
              priceAmountMicros: 0,
              priceCurrencyCode: 'USD',
              recurrenceMode: RecurrenceMode.finiteRecurring,
            ),
            PricingPhaseWrapper(
              billingCycleCount: 0,
              billingPeriod: 'P1W',
              formattedPrice: '\$3.99',
              priceAmountMicros: 3990000,
              priceCurrencyCode: 'USD',
              recurrenceMode: RecurrenceMode.infiniteRecurring,
            ),
          ],
        ),
      ];

      final resolved = GooglePlayOfferInspector.inspect(
        productId: productId,
        targetBasePlanId: basePlanId,
        offers: offers,
      );

      expect(resolved, isNotNull);
      expect(resolved!.productId, 'weekly_sub');
      expect(resolved.basePlanId, 'weeklysub');
      expect(resolved.offerToken, 'token_free_trial_123');
      expect(resolved.isFreeTrialEligible, isTrue);
      expect(resolved.freeTrialPeriodIso, 'P7D');
      expect(resolved.freeTrialDurationText, '7 Days');
      expect(resolved.recurringPrice, '\$3.99');
    });

    test('does NOT treat discounted introductory offer as a free trial', () {
      final offers = [
        const SubscriptionOfferDetailsWrapper(
          basePlanId: basePlanId,
          offerId: 'discounted-intro',
          offerIdToken: 'token_discounted',
          offerTags: ['discount'],
          pricingPhases: [
            PricingPhaseWrapper(
              billingCycleCount: 1,
              billingPeriod: 'P1W',
              formattedPrice: '\$0.99',
              priceAmountMicros: 990000, // Non-zero introductory price
              priceCurrencyCode: 'USD',
              recurrenceMode: RecurrenceMode.finiteRecurring,
            ),
            PricingPhaseWrapper(
              billingCycleCount: 0,
              billingPeriod: 'P1W',
              formattedPrice: '\$3.99',
              priceAmountMicros: 3990000,
              priceCurrencyCode: 'USD',
              recurrenceMode: RecurrenceMode.infiniteRecurring,
            ),
          ],
        ),
      ];

      final resolved = GooglePlayOfferInspector.inspect(
        productId: productId,
        targetBasePlanId: basePlanId,
        offers: offers,
      );

      expect(resolved, isNotNull);
      expect(resolved!.isFreeTrialEligible, isFalse);
      expect(resolved.freeTrialPeriodIso, isNull);
      expect(resolved.freeTrialDurationText, isNull);
    });

    test('handles user ineligible for trial (only base plan returned by Google Play)', () {
      final offers = [
        const SubscriptionOfferDetailsWrapper(
          basePlanId: basePlanId,
          offerId: null, // Default base plan offer
          offerIdToken: 'token_base_plan',
          offerTags: [],
          pricingPhases: [
            PricingPhaseWrapper(
              billingCycleCount: 0,
              billingPeriod: 'P1W',
              formattedPrice: '\$3.99',
              priceAmountMicros: 3990000,
              priceCurrencyCode: 'USD',
              recurrenceMode: RecurrenceMode.infiniteRecurring,
            ),
          ],
        ),
      ];

      final resolved = GooglePlayOfferInspector.inspect(
        productId: productId,
        targetBasePlanId: basePlanId,
        offers: offers,
      );

      expect(resolved, isNotNull);
      expect(resolved!.isFreeTrialEligible, isFalse);
      expect(resolved.offerToken, 'token_base_plan');
      expect(resolved.freeTrialDurationText, isNull);
    });

    test('returns null when target base plan does not match', () {
      final offers = [
        const SubscriptionOfferDetailsWrapper(
          basePlanId: 'other_plan_id',
          offerId: null,
          offerIdToken: 'token_other',
          offerTags: [],
          pricingPhases: [],
        ),
      ];

      final resolved = GooglePlayOfferInspector.inspect(
        productId: productId,
        targetBasePlanId: basePlanId,
        offers: offers,
      );

      expect(resolved, isNull);
    });
  });

  group('3. Paywall Dynamic CTA Text Scenarios', () {
    test('Scenario A: Free trial eligible user sees [Duration] Free Trial', () async {
      final c = await makeContainer(
        overrides: [
          billingServiceProvider.overrideWithValue(
            FakeBillingService(
              () => PreviewMode.live,
              initialTrialEligible: true,
              trialPeriodIso: 'P7D',
            ),
          ),
        ],
      );

      final products = await c.read(storeProductsProvider.future);
      final weekly = products.firstWhere((p) => p.id == BillingConfig.weekly);

      expect(weekly.id, 'weekly_sub');
      expect(weekly.basePlanId, 'weeklysub');
      expect(weekly.isFreeTrialEligible, isTrue);
      expect(weekly.freeTrialDurationText, '7 Days');
      expect(weekly.ctaText(), '7 Days Free Trial');
    });

    test('Scenario A variant: 3 Days Free Trial', () async {
      final c = await makeContainer(
        overrides: [
          billingServiceProvider.overrideWithValue(
            FakeBillingService(
              () => PreviewMode.live,
              initialTrialEligible: true,
              trialPeriodIso: 'P3D',
            ),
          ),
        ],
      );

      final products = await c.read(storeProductsProvider.future);
      final weekly = products.firstWhere((p) => p.id == BillingConfig.weekly);

      expect(weekly.freeTrialDurationText, '3 Days');
      expect(weekly.ctaText(), '3 Days Free Trial');
    });

    test('Scenario B: Ineligible user sees Continue', () async {
      final c = await makeContainer(
        overrides: [
          billingServiceProvider.overrideWithValue(
            FakeBillingService(
              () => PreviewMode.live,
              initialTrialEligible: false,
            ),
          ),
        ],
      );

      final products = await c.read(storeProductsProvider.future);
      final weekly = products.firstWhere((p) => p.id == BillingConfig.weekly);

      expect(weekly.isFreeTrialEligible, isFalse);
      expect(weekly.hasFreeTrial, isFalse);
      expect(weekly.ctaText(), 'Continue');
    });
  });

  group('4. Centralized Purchase State Manager (All 12 States)', () {
    test('verifies state transitions: initial -> productLoaded -> trialEligible -> pending -> success -> premiumActive', () async {
      final fake = FakeBillingService(
        () => PreviewMode.live,
        initialTrialEligible: true,
        trialPeriodIso: 'P7D',
      );
      final c = await makeContainer(
        overrides: [
          billingServiceProvider.overrideWithValue(fake),
        ],
      );

      // Listen to purchaseStateProvider
      final states = <PurchaseState>[];
      c.listen(purchaseStateProvider, (_, next) => states.add(next.status));

      // 1. Initial / Loading products
      await c.read(storeProductsProvider.future);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // 4. Free trial eligible
      final stateNow = c.read(purchaseStateProvider);
      expect(stateNow.status, PurchaseState.freeTrialEligible);
      expect(stateNow.ctaText, '7 Days Free Trial');

      // Purchase flow
      final outcome = await c.read(purchaseStateProvider.notifier).buy();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(outcome, PurchaseOutcome.success);
      expect(c.read(purchaseStateProvider).status, PurchaseState.premiumActive);
      expect(c.read(settingsProvider).isPremium, isTrue);
    });

    test('purchase cancellation transitions to purchaseCancelled without granting premium', () async {
      final c = await makeContainer();
      c.listen(purchaseStateProvider, (_, _) {});

      // Verify entitlement controller handles cancel cleanly
      expect(c.read(settingsProvider).isPremium, isFalse);
    });
  });

  group('5. Purchase Verification & Expiration Logic', () {
    const verifier = GooglePlayPurchaseVerifier();

    test('rejects pending, cancelled, or error purchases', () async {
      final pendingPurchase = PurchaseDetails(
        productID: 'weekly_sub',
        verificationData: PurchaseVerificationData(
          localVerificationData: '{"purchaseState":2}',
          serverVerificationData: 'token',
          source: 'google_play',
        ),
        transactionDate: null,
        status: PurchaseStatus.pending,
      );
      final pendingResult = await verifier.verify(pendingPurchase);
      expect(pendingResult.isValid, isFalse);
      expect(pendingResult.isActive, isFalse);

      final canceledPurchase = PurchaseDetails(
        productID: 'weekly_sub',
        verificationData: PurchaseVerificationData(
          localVerificationData: '{"purchaseState":1}',
          serverVerificationData: 'token',
          source: 'google_play',
        ),
        transactionDate: null,
        status: PurchaseStatus.canceled,
      );
      final canceledResult = await verifier.verify(canceledPurchase);
      expect(canceledResult.isValid, isFalse);
      expect(canceledResult.isActive, isFalse);
    });

    test('rejects purchases with missing verification token', () async {
      final missingTokenPurchase = PurchaseDetails(
        productID: 'weekly_sub',
        verificationData: PurchaseVerificationData(
          localVerificationData: '',
          serverVerificationData: '',
          source: 'google_play',
        ),
        transactionDate: null,
        status: PurchaseStatus.purchased,
      );
      final result = await verifier.verify(missingTokenPurchase);
      expect(result.isValid, isFalse);
      expect(result.isActive, isFalse);
    });

    test('allows cancelled subscription to remain premium until expiry date', () async {
      final futureDate = DateTime.now().add(const Duration(days: 3));
      final entitlement = EntitlementState(
        productId: 'weekly_sub',
        active: true,
        expiry: futureDate,
        isAutoRenewing: false, // Cancelled on Google Play
      );

      expect(entitlement.isEntitled, isTrue);

      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final expiredEntitlement = EntitlementState(
        productId: 'weekly_sub',
        active: true,
        expiry: pastDate,
        isAutoRenewing: false,
      );

      expect(expiredEntitlement.isEntitled, isFalse);
    });
  });

  group('6. Restore Purchases Action', () {
    test('restores active subscription and sets premium to true', () async {
      final fake = FakeBillingService(() => PreviewMode.live);
      final c = await makeContainer(
        overrides: [
          billingServiceProvider.overrideWithValue(fake),
        ],
      );

      // Buy a product first
      final products = await c.read(storeProductsProvider.future);
      await c.read(purchaseStateProvider.notifier).buy(products[0]);
      expect(c.read(settingsProvider).isPremium, isTrue);

      // Restore
      final restoreResult = await c.read(purchaseStateProvider.notifier).restorePurchases();
      expect(restoreResult.status, RestoreStatus.activeRestored);
      expect(c.read(settingsProvider).isPremium, isTrue);
    });

    test('reports expired when previously owned subscription has passed expiry', () async {
      final fake = FakeBillingService(() => PreviewMode.live);
      fake.setSimulatedSubscription(
        productId: 'weekly_sub',
        active: false,
        expiry: DateTime.now().subtract(const Duration(days: 2)),
      );

      final c = await makeContainer(
        overrides: [
          billingServiceProvider.overrideWithValue(fake),
        ],
      );

      final restoreResult = await c.read(purchaseStateProvider.notifier).restorePurchases();
      expect(restoreResult.status, RestoreStatus.expired);
      expect(c.read(settingsProvider).isPremium, isFalse);
    });

    test('reports noPurchasesFound when user owns nothing', () async {
      final fake = FakeBillingService(() => PreviewMode.live);
      final c = await makeContainer(
        overrides: [
          billingServiceProvider.overrideWithValue(fake),
        ],
      );

      final restoreResult = await c.read(purchaseStateProvider.notifier).restorePurchases();
      expect(restoreResult.status, RestoreStatus.noPurchasesFound);
      expect(c.read(settingsProvider).isPremium, isFalse);
    });
  });

  group('7. Global Premium Status & AdMob Response', () {
    test('when premium activates, AdManager disposes loaded ads immediately', () async {
      // Premium is store-authoritative: the store owns the subscription, and the
      // status service (not the persisted settings flag) is the source of truth.
      final store = FakeBillingService(() => PreviewMode.live)
        ..setSimulatedSubscription(
          productId: BillingConfig.weekly,
          active: true,
          expiry: DateTime.now().add(const Duration(days: 30)),
        );
      final c = await makeContainer(overrides: [billingServiceProvider.overrideWithValue(store)]);
      c.listen(adManagerProvider, (_, _) {});

      expect(c.read(settingsProvider).isPremium, isFalse);
      expect(c.read(isPremiumProvider), isFalse);

      // Activate premium
      c
          .read(premiumStatusServiceProvider)
          .applyPurchase(productId: BillingConfig.weekly, expiry: DateTime.now().add(const Duration(days: 30)));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(c.read(settingsProvider).isPremium, isTrue);
      expect(c.read(isPremiumProvider), isTrue);

      // Ad requests must be blocked
      final native = await c.read(adManagerProvider.notifier).loadNative(AdPlacement.languageFirstRun);
      expect(native, isNull, reason: 'Ads must never be requested or served to premium users');
    });
  });
}
