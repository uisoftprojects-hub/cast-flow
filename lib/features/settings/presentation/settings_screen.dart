import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/config/app_links.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/launch.dart';
import '../../../core/widgets/selectors.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../history/presentation/history_controller.dart';
import '../domain/app_settings.dart';
import 'feedback.dart';
import 'rate_sheet.dart';
import 'settings_controller.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<bool> _confirm(BuildContext context, String title, String body, String action) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action, style: TextStyle(color: context.palette.error)),
          ),
        ],
      ),
    );
    return ok == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);
    final version = ref.watch(packageInfoProvider).value;

    return Scaffold(
      appBar: const CastAppBar(title: 'Settings'),
      body: ListView(
        padding: EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, navBottomPadding(context)),
        children: [
          _PremiumCard(active: s.isPremium),
          const SizedBox(height: AppSpace.xxl),
          const _GroupTitle('General'),
          _Group(
            children: [
              _Tile(
                icon: Iconsax.language_square_copy,
                title: 'Language',
                trailing: _Value(supportedLanguages[s.languageCode]?.$1 ?? 'English'),
                onTap: () => context.push('/settings/language'),
              ),
              _Tile(
                icon: Iconsax.video_horizontal_copy,
                title: 'Default quality',
                trailing: _Value(s.defaultQuality.label),
                onTap: () => _pick<MirrorQuality>(
                  context,
                  title: 'Default quality',
                  values: MirrorQuality.values,
                  selected: s.defaultQuality,
                  labelOf: (q) => q.label,
                  onSelected: ctrl.setDefaultQuality,
                ),
              ),
              _Tile(
                icon: Iconsax.refresh_copy,
                title: 'Auto-connect to last TV',
                trailing: Switch(value: s.autoConnect, onChanged: ctrl.setAutoConnect),
                onTap: () => ctrl.setAutoConnect(!s.autoConnect),
              ),
              _Tile(
                icon: Iconsax.mobile_copy,
                title: 'Haptic feedback',
                trailing: Switch(value: s.hapticsEnabled, onChanged: ctrl.setHaptics),
                onTap: () => ctrl.setHaptics(!s.hapticsEnabled),
              ),
              _Tile(
                icon: Iconsax.clock_copy,
                title: 'Clear casting history',
                onTap: () async {
                  if (await _confirm(context, 'Clear casting history?',
                      'Only CastFlow’s list is cleared. Media on your phone is never deleted.', 'Clear')) {
                    await ref.read(historyProvider.notifier).clear();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpace.xxl),
          const _GroupTitle('Appearance'),
          SegmentedPills<ThemeMode>(
            values: const [ThemeMode.system, ThemeMode.light, ThemeMode.dark],
            selected: s.themeMode,
            labelOf: (m) => switch (m) {
              ThemeMode.light => 'Light',
              ThemeMode.dark => 'Dark',
              ThemeMode.system => 'System',
            },
            onChanged: ctrl.setThemeMode,
          ),
          const SizedBox(height: AppSpace.xxl),
          const _GroupTitle('About & support'),
          _Group(
            children: [
              _Tile(icon: Iconsax.message_question_copy, title: 'How to connect', onTap: () => context.push('/guide')),
              _Tile(icon: Iconsax.star_1_copy, title: 'Rate app', onTap: () => showRateSheet(context)),
              _Tile(
                icon: Iconsax.message_edit_copy,
                title: 'Feedback',
                onTap: () => sendFeedback(context, ref),
              ),
              _Tile(
                icon: Iconsax.shield_tick_copy,
                title: 'Privacy Policy',
                onTap: () => openExternal(context, AppLinks.privacyPolicy),
              ),
              _Tile(
                icon: Iconsax.document_text_copy,
                title: 'Terms & Conditions',
                onTap: () => openExternal(context, AppLinks.terms),
              ),
              _Tile(
                icon: Iconsax.info_circle_copy,
                title: 'Version',
                trailing: _Value(version == null ? '…' : '${version.version} (${version.buildNumber})'),
                onTap: () => openExternal(context, storeListingUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pick<T>(
    BuildContext context, {
    required String title,
    required List<T> values,
    required T selected,
    required String Function(T) labelOf,
    required ValueChanged<T> onSelected,
  }) async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      builder: (context) => SafeArea(top: false, child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpace.xl, 0, AppSpace.xl, AppSpace.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
              child: Text(title, style: context.text.headlineMedium),
            ),
            const SizedBox(height: AppSpace.md),
            for (final v in values)
              ListTile(
                minTileHeight: kMinTap + 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                selected: v == selected,
                selectedTileColor: context.palette.primaryTint,
                title: Text(labelOf(v), style: context.text.bodyLarge),
                trailing: v == selected ? Icon(Iconsax.tick_circle_copy, color: context.palette.primary) : null,
                onTap: () => Navigator.pop(context, v),
              ),
          ],
        ),
      )),
    );
    if (picked != null) onSelected(picked);
  }
}

class _PremiumCard extends StatelessWidget {
  const _PremiumCard({required this.active});

  /// Reflects an active entitlement instead of upselling.
  final bool active;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: active ? null : () => context.push('/premium'),
      semanticLabel: active ? 'CastFlow Pro is active' : 'Upgrade to Premium',
      child: Container(
        padding: const EdgeInsets.all(AppSpace.xl),
        decoration: BoxDecoration(
          gradient: AppColors.mainGradient,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.glow(AppColors.primary),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), shape: BoxShape.circle),
              child: const Icon(Iconsax.crown_1_copy, color: Colors.white, size: 28),
            )
                .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                .rotate(begin: -0.02, end: 0.02, duration: 1400.ms),
            const SizedBox(width: AppSpace.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(active ? 'CastFlow Pro is active' : 'CastFlow Premium', style: context.text.titleLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(active ? 'Thanks for your support. Enjoy ad-free casting.' : 'No ads, 1080p mirroring & unlimited casting',
                      style: context.text.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            if (!active) const SoftBadge('Upgrade'),
          ],
        ),
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 4, bottom: AppSpace.sm),
        child: Text(text, style: context.text.labelMedium?.copyWith(color: context.palette.textSecondary)),
      );
}

class _Group extends StatelessWidget {
  const _Group({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const Divider(indent: 68, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, this.trailing, this.onTap});
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.sm),
          child: Row(
            children: [
              IconBubble(icon: icon, size: 38),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.text.bodyLarge),
                  ],
                ),
              ),
              trailing ?? const ForwardChevron(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: context.text.bodyMedium),
          const ForwardChevron(),
        ],
      );
}
