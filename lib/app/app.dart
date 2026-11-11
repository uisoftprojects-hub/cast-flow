import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../features/monetization/domain/ad_config.dart';
import '../features/monetization/presentation/ad_lifecycle_host.dart';
import '../features/pairing/presentation/pairing_sheet.dart';
import '../features/premium/domain/premium_status_service.dart';
import '../features/settings/domain/app_settings.dart';
import '../features/settings/presentation/settings_controller.dart';
import 'router.dart';

const _nativeAdTheme = MethodChannel('castflow/native_ad_theme');

class CastFlowApp extends ConsumerStatefulWidget {
  const CastFlowApp({super.key});

  @override
  ConsumerState<CastFlowApp> createState() => _CastFlowAppState();
}

class _CastFlowAppState extends ConsumerState<CastFlowApp> {
  @override
  void initState() {
    super.initState();
    // Authoritative check and billing restoration on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(premiumStatusServiceProvider).verifyStartupEntitlement();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    final language = ref.watch(settingsProvider.select((s) => s.languageCode));
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      themeAnimationDuration: const Duration(milliseconds: 350),
      locale: Locale(language),
      supportedLocales: [for (final code in supportedLanguages.keys) Locale(code)],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      // Status bar background color and text/icon colors match the screen background
      builder: (context, child) {
        // Native ads follow the app theme. Reading MediaQuery's platform brightness makes this
        // rebuild when the OS theme flips while themeMode is "system".
        final osDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        final nativeDark = switch (themeMode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => osDark,
        };
        if (nativeDark != AdMobConfig.nativeAdIsDark) {
          AdMobConfig.nativeAdIsDark = nativeDark;
          // Re-colour ads that are already loaded; never re-request them.
          unawaited(_nativeAdTheme.invokeMethod<void>('setDark', {'dark': nativeDark}).catchError((_) {}));
        }
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: context.systemOverlayStyle(),
          child: AdLifecycleHost(child: PairingSheetHost(child: child ?? const SizedBox.shrink())),
        );
      },
    );
  }
}
