import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'buttons.dart';
import 'soft_card.dart';

import '../l10n.dart';

/// Friendly empty state with an icon bubble, message and optional action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    // Scrolls instead of overflowing when space is short (landscape).
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpace.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBubble(icon: icon, size: 88),
            const SizedBox(height: AppSpace.xl),
            Text(title, textAlign: TextAlign.center, style: context.text.headlineSmall),
            const SizedBox(height: AppSpace.sm),
            Text(message, textAlign: TextAlign.center, style: context.text.bodyMedium),
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpace.xxl),
              GradientButton(label: actionLabel!, onPressed: onAction, icon: Iconsax.refresh_copy),
            ],
          ],
        ).animate().fadeIn(duration: AppDurations.slow).slideY(begin: 0.06, end: 0),
      ),
    );
  }
}

/// Error state with a retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    // Scrolls instead of overflowing when space is short (landscape).
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpace.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBubble(icon: Iconsax.danger_copy, size: 88, color: p.error),
            const SizedBox(height: AppSpace.xl),
            Text(context.l10n.somethingWentWrong, textAlign: TextAlign.center, style: context.text.headlineSmall),
            const SizedBox(height: AppSpace.sm),
            Text(
              message ?? context.l10n.weCouldntLoadThis,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpace.xxl),
              TintedButton(label: context.l10n.tryAgain, icon: Iconsax.refresh_copy, onPressed: onRetry),
            ],
          ],
        ).animate().fadeIn(duration: AppDurations.slow),
      ),
    );
  }
}

/// Wraps children in a theme-aware shimmer.
class SoftShimmer extends StatelessWidget {
  const SoftShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Shimmer.fromColors(
      baseColor: p.surfaceHigh,
      highlightColor: p.surface,
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, this.width, this.height = 16, this.radius = AppRadius.sm});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: context.palette.surfaceHigh, borderRadius: BorderRadius.circular(radius)),
    );
  }
}

/// Shimmering list of rows used while lists load.
class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.count = 6, this.leadingSize = 56, this.padding});

  final int count;
  final double leadingSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SoftShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding ?? const EdgeInsets.all(AppSpace.page),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpace.lg),
        itemBuilder: (_, _) => Row(
          children: [
            ShimmerBox(width: leadingSize, height: leadingSize, radius: AppRadius.md),
            const SizedBox(width: AppSpace.lg),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 14),
                  SizedBox(height: 10),
                  FractionallySizedBox(widthFactor: 0.55, child: ShimmerBox(height: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmering grid used while galleries load.
class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({super.key, this.crossAxisCount = 3, this.count = 12, this.padding});

  final int crossAxisCount;
  final int count;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SoftShimmer(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding ?? const EdgeInsets.all(AppSpace.page),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: count,
        itemBuilder: (_, _) => const ShimmerBox(radius: AppRadius.md),
      ),
    );
  }
}

/// Maps an [AsyncValue] to loading (shimmer), error, empty and data views.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.onRetry,
    this.isEmpty,
    this.empty,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.medium,
      child: value.when(
        skipLoadingOnRefresh: false,
        loading: () => KeyedSubtree(key: const ValueKey('loading'), child: loading ?? const ShimmerList()),
        error: (e, _) => KeyedSubtree(
          key: const ValueKey('error'),
          child: ErrorState(onRetry: onRetry),
        ),
        data: (d) {
          if (empty != null && (isEmpty?.call(d) ?? false)) {
            return KeyedSubtree(key: const ValueKey('empty'), child: empty!);
          }
          return KeyedSubtree(key: const ValueKey('data'), child: data(d));
        },
      ),
    );
  }
}
