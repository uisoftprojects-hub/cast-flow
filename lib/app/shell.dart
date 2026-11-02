import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_tokens.dart';
import '../features/player/presentation/mini_player_bar.dart';
import '../features/settings/presentation/rate_sheet.dart';

const _tabs = [
  (Iconsax.home_2_copy, 'Home'),
  (Iconsax.monitor_copy, 'Devices'),
  (Iconsax.clock_copy, 'History'),
  (Iconsax.setting_2_copy, 'Settings'),
];

/// Hosts the four main tabs with the floating, blurred bottom navigation
/// and the "now casting" mini bar above it.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // Back from any tab returns to Home; back on Home asks for a rating with
    // a one-tap exit.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
        } else {
          showRateSheet(context, exit: true);
        }
      },
      child: _scaffold(context),
    );
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MiniPlayerBar(),
            const SizedBox(height: AppSpace.sm),
            _FloatingNavBar(
              index: navigationShell.currentIndex,
              onTap: (i) => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [BoxShadow(color: p.shadow, blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(AppSpace.sm),
            decoration: BoxDecoration(
              color: p.surface.withValues(alpha: context.isDark ? 0.85 : 0.88),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                for (final (i, (icon, label)) in _tabs.indexed)
                  Expanded(
                    flex: i == index ? 5 : 3,
                    child: _NavItem(icon: icon, label: label, selected: i == index, onTap: () => onTap(i)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.medium,
          curve: Curves.easeOutCubic,
          height: 52,
          decoration: BoxDecoration(
            gradient: selected ? AppColors.mainGradient : null,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: selected ? Colors.white : p.textSecondary),
              if (selected) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: context.text.labelMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
