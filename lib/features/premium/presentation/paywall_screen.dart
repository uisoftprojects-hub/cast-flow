import 'package:flutter/material.dart';
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
import '../domain/billing.dart';
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

/// Simple white paywall: benefits with ticks, three plans, one Continue.
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
    _analytics.log(AnalyticsEvent.paywallView, {AnalyticsParam.source: _source});
  }

  FlowStep? get _step => switch (widget.slot) {
    'first' => FlowStep.paywall,
    'returning' => FlowStep.paywallReturning,
    _ => null,
  };

  void _close() {
    _analytics.log(AnalyticsEvent.paywallClose, {
      AnalyticsParam.source: _source,
      AnalyticsParam.elapsedMs: DateTime.now().difference(_openedAt).inMilliseconds,
    });
    final step = _step;
    if (step == null) {
      if (context.canPop()) context.pop();
      return;
    }
    final next = ref.read(appFlowProvider.notifier).advance(step);
    if (next != null) context.go(next);
  }

  void _snack(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _purchase(StoreProduct product) async {
    if (_buying) return;
    setState(() => _buying = true);
    final outcome = await ref.read(entitlementProvider.notifier).buy(product, source: _source);
    if (!mounted) return;
    setState(() => _buying = false);
    switch (outcome) {
      case PurchaseOutcome.success:
        _snack(context.l10n.welcomeToCastflowPro);
        _close();
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
    final products = ref.watch(storeProductsProvider);
    final list = products.value ?? const <StoreProduct>[];
    final selected =
        list.where((x) => x.id == _selectedId).firstOrNull ??
        list.where((x) => x.id == BillingConfig.yearly).firstOrNull ??
        list.firstOrNull;

    // Always white, whatever the app theme.
    return Theme(
      data: AppTheme.light,
      child: Builder(
        builder: (context) {
          final p = context.palette;
          return PopScope(
            canPop: _step == null,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, c) => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.xxl),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: IconButton(
                                tooltip: context.l10n.close,
                                onPressed: _close,
                                icon: Icon(Icons.close_rounded, color: p.textPrimary),
                              ),
                            ),
                            const SizedBox(height: AppSpace.sm),
                            Center(
                              child: Icon(Iconsax.award_copy, size: 44, color: p.primary).animate().scale(
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
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(icon, size: 20, color: p.primary),
                                    const SizedBox(width: AppSpace.lg),
                                    Expanded(child: Text(context.tr(label), style: context.text.bodyLarge)),
                                    const Icon(Icons.check_circle_rounded, size: 22, color: Color(0xFF22A55B)),
                                  ],
                                ),
                              ).animate(delay: (50 * i).ms).fadeIn(duration: 250.ms),
                            const Spacer(),
                            const SizedBox(height: AppSpace.xl),
                            _Plans(
                              products: products,
                              selectedId: selected?.id,
                              onSelect: (id) => setState(() => _selectedId = id),
                              onRetry: () => ref.invalidate(storeProductsProvider),
                            ),
                            const SizedBox(height: AppSpace.md),
                            if (selected != null)
                              Text(
                                selected.isSubscription
                                    ? context.l10n.renewsAutomaticallyUntilCancelled
                                    : context.l10n.oneTimePurchaseNo,
                                textAlign: TextAlign.center,
                                style: context.text.bodySmall,
                              ),
                            const SizedBox(height: AppSpace.sm),
                            GradientButton(
                              label: context.l10n.continueAction,
                              expand: true,
                              loading: _buying,
                              onPressed: selected == null ? null : () => _purchase(selected),
                            ),
                            const SizedBox(height: AppSpace.xs),
                            // One line always: it scales down instead of wrapping.
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _FooterLink(
                                    context.l10n.privacyPolicy,
                                    () => openExternal(context, AppLinks.privacyPolicy),
                                  ),
                                  Text('|', style: context.text.bodySmall),
                                  _FooterLink(
                                    context.l10n.termsAndConditions,
                                    () => openExternal(context, AppLinks.terms),
                                  ),
                                  Text('|', style: context.text.bodySmall),
                                  _FooterLink(context.l10n.cancelAnytime, null),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpace.sm),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Plans extends StatelessWidget {
  const _Plans({required this.products, required this.selectedId, required this.onSelect, required this.onRetry});

  final AsyncValue<List<StoreProduct>> products;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return products.when(
      skipLoadingOnRefresh: false,
      loading: () => Center(child: Text(context.l10n.loadingPrice, style: context.text.bodySmall)),
      error: (_, _) => Center(
        child: TextButton(onPressed: onRetry, child: Text(context.l10n.pricesUnavailableTapTo)),
      ),
      data: (items) => items.isEmpty
          ? Center(child: Text(context.l10n.noPlansAvailableRight, style: context.text.bodySmall))
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, product) in items.indexed) ...[
                  if (i > 0) const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: _PlanOption(
                      product: product,
                      selected: product.id == selectedId,
                      onTap: () => onSelect(product.id),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({required this.product, required this.selected, required this.onTap});

  final StoreProduct product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final name = switch (product.period) {
      PlanPeriod.weekly => context.l10n.weekly,
      PlanPeriod.yearly => context.l10n.yearly,
      PlanPeriod.lifetime => context.l10n.lifetime,
    };
    final best = product.period == PlanPeriod.yearly;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: TapScale(
        onTap: onTap,
        semanticLabel: '$name, ${product.price}',
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            AnimatedContainer(
              duration: AppDurations.medium,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(6, 16, 6, 12),
              decoration: BoxDecoration(
                color: selected ? p.primaryTint : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: selected ? p.primary : p.divider, width: selected ? 2 : 1),
              ),
              child: Column(
                children: [
                  Text(name, style: context.text.labelMedium),
                  const SizedBox(height: 4),
                  FittedBox(child: Text(product.price, style: context.text.titleLarge)),
                  Text(context.tr(product.period.note), style: context.text.labelSmall),
                ],
              ),
            ),
            if (best)
              Positioned(
                top: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: AppColors.mainGradient,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(context.l10n.bestValue, style: context.text.labelSmall?.copyWith(color: Colors.white)),
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
