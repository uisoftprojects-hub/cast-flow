import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/config/app_links.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/launch.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../app_flow/domain/flow_config.dart';
import '../../app_flow/presentation/app_flow_controller.dart';
import '../../monetization/presentation/ad_display_coordinator.dart';
import '../../monetization/presentation/ad_manager.dart';
import '../../monetization/presentation/native_ad_manager.dart';
import '../../monetization/presentation/splash_interstitial_manager.dart';
import '../domain/billing.dart';
import '../domain/premium_status_service.dart';
import 'billing_controller.dart';

import '../../../core/l10n.dart';

const _benefits = [
  (Iconsax.screenmirroring_copy, 'Wireless screen mirroring'),
  (Iconsax.video_play_copy, 'Cast videos, photos & music'),
  (Iconsax.mobile_copy, 'Full TV remote control'),
  (Iconsax.devices_copy, 'Works with all major TVs'),
  (Iconsax.flash_1_copy, 'Smooth, lag-free streaming'),
  (Iconsax.shield_cross_copy, 'No ads'),
];

/// Paywall screen: benefits with ticks, three plans, one Continue.
/// With [slot] it is a startup step (close continues the flow, back is
/// blocked); without it, it is a normal pushed screen.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.slot, this.from});

  final String? slot;

  /// Where a pushed paywall was opened from (analytics source).
  final String? from;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String? _selectedId;
  bool _buying = false;
  final _openedAt = DateTime.now();

  String get _source => switch (widget.slot) {
    'first' => 'first_open',
    'returning' => 'returning',
    _ => widget.from ?? 'other',
  };

  Analytics get _analytics => ref.read(analyticsProvider);

  @override
  void initState() {
    super.initState();
    _analytics.log(AnalyticsEvent.paywallView, {
      AnalyticsParam.source: _source,
    });
    // Section 6: Preload the onboarding native ad on the Paywall screen
    Future.microtask(() {
      final isPremium = ref.read(isPremiumProvider);
      if (!isPremium) {
        ref.read(nativeAdManagerProvider).preloadOnboardingAd(isPremium: false);
      }
    });
  }

  FlowStep? get _step => switch (widget.slot) {
    'first' => FlowStep.paywall,
    'returning' => FlowStep.paywallReturning,
    _ => null,
  };

  Future<void> _close() async {
    _analytics.log(AnalyticsEvent.paywallClose, {
      AnalyticsParam.source: _source,
      AnalyticsParam.elapsedMs: DateTime.now()
          .difference(_openedAt)
          .inMilliseconds,
    });

    // Section 4: If splash interstitial was not shown on language completion, show it on paywall close
    final isPremium = ref.read(isPremiumProvider);
    if (!isPremium) {
      await ref
          .read(splashInterstitialManagerProvider)
          .tryShowAtPaywallClose(isPremium: false);
    }

    if (!mounted) return;
    final step = _step;
    if (step == null) {
      if (context.canPop()) context.pop();
      return;
    }
    final next = ref.read(appFlowProvider.notifier).advance(step);
    if (next != null) context.go(next);
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _purchase(StoreProduct product) async {
    if (_buying) return;
    setState(() => _buying = true);

    // Section 11: Do not display ads during purchase processing
    ref.read(adDisplayCoordinatorProvider).setPurchaseInProgress(true);

    final outcome = await ref
        .read(purchaseStateProvider.notifier)
        .buy(product, _source);

    ref.read(adDisplayCoordinatorProvider).setPurchaseInProgress(false);

    if (!mounted) return;
    setState(() => _buying = false);

    switch (outcome) {
      case PurchaseOutcome.success:
        // Section 13: Stop future ad displays and dispose loaded ads immediately
        ref.read(adManagerProvider.notifier).onPremiumPurchased();
        // Advance to next step without showing any interstitial
        final step = _step;
        if (step == null) {
          if (context.canPop()) context.pop();
        } else {
          final next = ref.read(appFlowProvider.notifier).advance(step);
          if (next != null) context.go(next);
        }
      case PurchaseOutcome.cancelled:
        _snack(context.l10n.purchaseCancelled);
      case PurchaseOutcome.pending:
        _snack(context.l10n.purchasePendingProUnlocks);
      case PurchaseOutcome.failed:
        _snack(context.l10n.purchaseFailedPleaseTry);
      case PurchaseOutcome.unavailable:
        _snack(context.l10n.theStoreIsntAvailable);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Premium users never see the paywall (e.g. entitlement verified/restored while open).
    ref.listen<bool>(isPremiumProvider, (_, isPremium) {
      if (!isPremium || _buying || !mounted) return;
      final step = _step;
      if (step == null) {
        if (context.canPop()) context.pop();
      } else {
        final next = ref.read(appFlowProvider.notifier).advance(step);
        if (next != null) context.go(next);
      }
    });
    final products = ref.watch(storeProductsProvider);
    final list = products.value ?? const <StoreProduct>[];
    final selected =
        list.where((x) => x.id == _selectedId).firstOrNull ?? list.firstOrNull;

    // Follows the app theme (light/dark).
    return Builder(
      builder: (context) {
        final p = context.palette;
        final dark = context.isDark;
        final overlay = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: p.background,
          systemNavigationBarIconBrightness: dark
              ? Brightness.light
              : Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: PopScope(
            canPop: _step == null,
            // In the startup flow back behaves like the close (X): ad if it triggers, then on.
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop && _step != null) _close();
            },
            child: Scaffold(
              backgroundColor: p.background,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, c) => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.xxl,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                tooltip: context.l10n.close,
                                onPressed: _close,
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: p.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpace.sm + 50),
                            Center(
                              child:
                                  Icon(
                                    Iconsax.award_copy,
                                    size: 44,
                                    color: p.primary,
                                  ).animate().scale(
                                    begin: const Offset(0.6, 0.6),
                                    curve: Curves.easeOutBack,
                                    duration: 500.ms,
                                  ),
                            ),
                            const SizedBox(height: AppSpace.md),
                            Text(
                              context.l10n.goProWithCastflow,
                              textAlign: TextAlign.center,
                              style: context.text.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.unlockEveryFeature,
                              textAlign: TextAlign.center,
                              style: context.text.bodyMedium,
                            ),
                            const SizedBox(height: AppSpace.xxl),
                            for (final (i, (icon, label)) in _benefits.indexed)
                              Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(icon, size: 20, color: p.primary),
                                        const SizedBox(width: AppSpace.lg),
                                        Expanded(
                                          child: Text(
                                            context.tr(label),
                                            style: context.text.bodyLarge,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          size: 22,
                                          color: Color(0xFF22A55B),
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate(delay: (50 * i).ms)
                                  .fadeIn(duration: 250.ms),
                            const Spacer(),
                            const SizedBox(height: AppSpace.xl),
                            _Plans(
                              products: products,
                              selectedId: selected?.id,
                              onSelect: (id) =>
                                  setState(() => _selectedId = id),
                              onRetry: () =>
                                  ref.invalidate(storeProductsProvider),
                            ),
                            const SizedBox(height: AppSpace.md),
                            if (selected != null)
                              Text(
                                selected.isSubscription
                                    ? context
                                          .l10n
                                          .renewsAutomaticallyUntilCancelled
                                    : context.l10n.oneTimePurchaseNo,
                                textAlign: TextAlign.center,
                                style: context.text.bodySmall,
                              ),
                            const SizedBox(height: AppSpace.sm),
                            GradientButton(
                              label: products.isLoading
                                  ? context.l10n.loadingPrice
                                  : (selected?.ctaText(
                                          continueLabel:
                                              context.l10n.continueAction,
                                        ) ??
                                        context.l10n.continueAction),
                              expand: true,
                              loading: _buying,
                              onPressed:
                                  (selected == null || products.isLoading)
                                  ? null
                                  : () => _purchase(selected),
                            ),
                            const SizedBox(height: AppSpace.xs),
                            // One line always: it scales down instead of wrapping.
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _FooterLink(context.l10n.cancelAnytime, null),
                                  Text('|', style: context.text.bodySmall),
                                  _FooterLink(
                                    context.l10n.privacyPolicy,
                                    () => openExternal(
                                      context,
                                      AppLinks.privacyPolicy,
                                    ),
                                  ),
                                  Text('|', style: context.text.bodySmall),
                                  _FooterLink(
                                    context.l10n.termsAndConditions,
                                    () => openExternal(context, AppLinks.terms),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Plans extends StatelessWidget {
  const _Plans({
    required this.products,
    required this.selectedId,
    required this.onSelect,
    required this.onRetry,
  });

  final AsyncValue<List<StoreProduct>> products;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return products.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Iconsax.refresh_copy),
              label: Text(context.l10n.retry),
            ),
          );
        }
        return Row(
          children: [
            for (final (i, product) in list.indexed) ...[
              if (i > 0) const SizedBox(width: AppSpace.md),
              Expanded(
                child: _PlanCard(
                  product: product,
                  selected: product.id == selectedId,
                  best: false,
                  onTap: () => onSelect(product.id),
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpace.xl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, _) => Center(
        child: TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Iconsax.refresh_copy),
          label: Text(context.l10n.retry),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.product,
    required this.selected,
    required this.best,
    required this.onTap,
  });

  final StoreProduct product;
  final bool selected;
  final bool best;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return TapScale(
      onTap: onTap,
      semanticLabel:
          '${product.title}, ${product.price}, ${product.period.note}',
      child: AnimatedContainer(
        duration: AppDurations.medium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.sm,
          vertical: AppSpace.md,
        ),
        decoration: BoxDecoration(
          color: selected ? p.primaryTint : p.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? p.primary : p.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr(product.period.name),
                    style: context.text.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      product.price,
                      style: context.text.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tr(product.period.note),
                    style: context.text.labelSmall?.copyWith(
                      color: p.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (best)
              Positioned(
                top: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.mainGradient,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    context.l10n.bestValue,
                    style: context.text.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink(this.label, this.onTap);
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      minimumSize: const Size(0, kMinTap),
      foregroundColor: context.palette.textSecondary,
      textStyle: context.text.bodySmall,
    ),
    child: Text(label),
  );
}
