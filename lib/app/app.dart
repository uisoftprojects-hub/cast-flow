import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/tap_feedback.dart';
import '../features/monetization/presentation/ad_lifecycle_host.dart';
import '../features/pairing/presentation/pairing_sheet.dart';
import '../features/premium/presentation/billing_controller.dart';
import '../features/settings/domain/app_settings.dart';
import '../features/settings/presentation/settings_controller.dart';
import 'router.dart';

class CastFlowApp extends ConsumerStatefulWidget {
  const CastFlowApp({super.key});

  @override
  ConsumerState<CastFlowApp> createState() => _CastFlowAppState();
}

class _CastFlowAppState extends ConsumerState<CastFlowApp> {
  @override
  void initState() {
    super.initState();
    // Reflect purchases made, refunded or revoked on another device.
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(entitlementProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    final language = ref.watch(settingsProvider.select((s) => s.languageCode));
    TapFeedback.hapticsEnabled = ref.watch(settingsProvider.select((s) => s.hapticsEnabled));

    return MaterialApp.router(
      title: 'CastFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      themeAnimationDuration: const Duration(milliseconds: 350),
      locale: Locale(language),
      supportedLocales: [for (final code in supportedLanguages.keys) Locale(code)],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      builder: (context, child) => AdLifecycleHost(child: PairingSheetHost(child: child ?? const SizedBox.shrink())),
    );
  }
}
