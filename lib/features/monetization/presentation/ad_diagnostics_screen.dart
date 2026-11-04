import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/soft_card.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../domain/ad_config.dart';
import '../domain/ad_models.dart';
import 'ad_manager.dart';

/// Debug-only local diagnostics for QA: per-placement state, counters,
/// cooldowns and the recent event log. Nothing here is sent anywhere.
class AdDiagnosticsScreen extends ConsumerWidget {
  const AdDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(adManagerProvider);
    final now = DateTime.now();
    String t(DateTime? x) => x == null ? '—' : '${formatShortDate(x)} ${formatTime(x)}';

    return Scaffold(
      appBar: const CastAppBar(title: 'Ad diagnostics'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.xxxl),
        children: [
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv(context, 'Consent allows ads', d.consentAllowsAds ? 'yes' : 'no'),
                _kv(
                  context,
                  'Click counter',
                  '${d.clickCount} / ${AdConfig.showAtClick} (load at ${AdConfig.loadAtClick})',
                ),
                _kv(context, 'App Open overlay', d.appOpenOverlay ? 'showing' : 'hidden'),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          for (final p in AdPlacement.values) ...[
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.label, style: context.text.titleSmall),
                  const SizedBox(height: AppSpace.sm),
                  _kv(context, 'State', d.placements[p]!.requestState.name),
                  _kv(context, 'Requests', '${d.placements[p]!.requestCount}'),
                  _kv(context, 'Impressions', '${d.placements[p]!.impressionCount}'),
                  _kv(context, 'Last request', t(d.placements[p]!.lastRequestAt)),
                  _kv(context, 'Last impression', t(d.placements[p]!.lastImpressionAt)),
                  _kv(
                    context,
                    'Cooldown',
                    d.placements[p]!.inCooldown(now) ? 'until ${formatTime(d.placements[p]!.cooldownUntil!)}' : 'none',
                  ),
                  _kv(context, 'Last failure', d.placements[p]!.lastFailure ?? '—'),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.md),
          ],
          const SizedBox(height: AppSpace.sm),
          Text('Events', style: context.text.titleLarge),
          const SizedBox(height: AppSpace.sm),
          if (d.events.isEmpty) Text('No events yet.', style: context.text.bodyMedium),
          for (final e in d.events)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '${formatTime(e.at)}  ${e.placement.name}  ${e.type.name}${e.detail == null ? '' : '  · ${e.detail}'}',
                style: context.text.bodySmall?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 140, child: Text(k, style: context.text.bodySmall)),
        Expanded(child: Text(v, style: context.text.bodyLarge)),
      ],
    ),
  );
}
