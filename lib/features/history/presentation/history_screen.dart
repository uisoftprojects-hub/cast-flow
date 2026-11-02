import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../domain/history_entry.dart';
import 'history_controller.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text('This removes everything you’ve cast from this list.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Clear', style: TextStyle(color: context.palette.error)),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(historyProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    final hasItems = history.value?.isNotEmpty ?? false;

    return Scaffold(
      appBar: CastAppBar(
        title: 'History',
        actions: [
          if (hasItems)
            SoftIconButton(
              icon: Iconsax.trash_copy,
              tooltip: 'Clear history',
              size: 44,
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: AsyncView<List<HistoryEntry>>(
        value: history,
        onRetry: () => ref.read(historyProvider.notifier).refresh(),
        isEmpty: (h) => h.isEmpty,
        empty: const EmptyState(
          icon: Iconsax.clock_copy,
          title: 'No history yet',
          message: 'Everything you cast will be listed here so you can find it again.',
        ),
        data: (items) {
          final groups = <DayBucket, List<HistoryEntry>>{};
          for (final e in items) {
            groups.putIfAbsent(dayBucket(e.castAt), () => []).add(e);
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(historyProvider.notifier).refresh(),
            child: ListView(
              padding: EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, navBottomPadding(context)),
              children: [
                for (final bucket in DayBucket.values)
                  if (groups[bucket] case final entries?) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpace.md, bottom: AppSpace.sm),
                      child: Text(
                        switch (bucket) {
                          DayBucket.today => 'Today',
                          DayBucket.yesterday => 'Yesterday',
                          DayBucket.earlier => 'Earlier',
                        },
                        style: context.text.labelMedium?.copyWith(color: context.palette.textSecondary),
                      ),
                    ),
                    for (final e in entries) _HistoryTile(entry: e),
                  ],
                const SizedBox(height: AppSpace.sm),
                Center(child: Text('Swipe an item to remove it', style: context.text.bodySmall)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.entry});
  final HistoryEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.sm),
      child: Dismissible(
        key: ValueKey(entry.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsetsDirectional.only(end: AppSpace.xxl),
          decoration: BoxDecoration(
            color: p.error.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Delete', style: context.text.labelMedium?.copyWith(color: p.error)),
              const SizedBox(width: 8),
              Icon(Iconsax.trash_copy, color: p.error),
            ],
          ),
        ),
        onDismissed: (_) async {
          final messenger = ScaffoldMessenger.of(context);
          final removed = await ref.read(historyProvider.notifier).remove(entry.id);
          if (removed == null) return;
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Removed “${removed.title}”'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => ref.read(historyProvider.notifier).restore(removed),
                ),
              ),
            );
        },
        child: SoftCard(
          padding: const EdgeInsets.all(AppSpace.sm),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 56,
                child: MediaArt(seed: entry.seed, icon: entry.kind.icon, iconSize: 20, radius: AppRadius.sm),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      '${entry.kind.label} · ${entry.deviceName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpace.sm),
                child: Text(
                  dayBucket(entry.castAt) == DayBucket.earlier ? formatShortDate(entry.castAt) : formatTime(entry.castAt),
                  style: context.text.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}
