import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/any_tap_listener.dart';
import '../features/app_flow/presentation/app_flow_controller.dart';
import '../features/monetization/presentation/ad_manager.dart';
import '../features/monetization/presentation/click_count_interstitial_manager.dart';
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
  /// A tap anywhere. Not during the startup flow (splash, language, onboarding,
  /// paywall) where an ad would cover a step the user has to take; the manager
  /// itself skips Premium users and an ad that is already showing.
  void _countClick() {
    if (!ref.read(appFlowProvider).finished) return;
    if (!ref.read(adRouteObserverProvider).topIsSafe) return;
    ref
        .read(clickCountInterstitialManagerProvider)
        .onUserClick(isPremium: ref.read(isPremiumProvider), contextTag: 'tap');
  }

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
          // Every tap counts toward the click interstitial (1st loads, 2nd shows).
          child: AnyTapListener(
            onTap: _countClick,
            child: AdLifecycleHost(child: PairingSheetHost(child: child ?? const SizedBox.shrink())),
          ),
        );
      },
    );
  }
}
