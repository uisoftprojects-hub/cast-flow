import 'package:castflow/core/app_providers.dart';
import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/devices/presentation/connect_screen.dart';
import 'package:castflow/features/guide/presentation/guide_screen.dart';
import 'package:castflow/features/home/presentation/home_screen.dart';
import 'package:castflow/features/language/presentation/language_screen.dart';
import 'package:castflow/features/mirroring/presentation/mirroring_controller.dart';
import 'package:castflow/features/mirroring/presentation/mirroring_screen.dart';
import 'package:castflow/features/monetization/data/fake_ad_adapter.dart';
import 'package:castflow/features/monetization/presentation/ad_manager.dart';
import 'package:castflow/features/onboarding/presentation/onboarding_screen.dart';
import 'package:castflow/features/premium/data/fake_billing_service.dart';
import 'package:castflow/features/premium/presentation/billing_controller.dart';
import 'package:castflow/features/premium/presentation/paywall_screen.dart';
import 'package:castflow/features/remote/presentation/remote_screen.dart';
import 'package:castflow/features/settings/presentation/settings_screen.dart';
import 'package:castflow/features/splash/presentation/splash_screen.dart';
import 'package:castflow/features/webcast/presentation/web_cast_screen.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'helpers.dart';

/// Renders each main screen at phone landscape and portrait sizes and fails
/// on any layout overflow.
void main() {
  final screens = <String, Widget Function()>{
    'splash': SplashScreen.new,
    'onboarding': OnboardingScreen.new,
    'language': () => const LanguageScreen(),
    'paywall': () => const PaywallScreen(),
    'home': HomeScreen.new,
    'remote': RemoteScreen.new,
    'mirroring': MirroringScreen.new,
    'connect': () => const ConnectScreen(standalone: true),
    'settings': SettingsScreen.new,
    'browser': () => const WebCastScreen(),
    'guide': () => const GuideScreen(topic: 'mirroring'),
  };

  for (final (label, size) in [('landscape', const Size(915, 412)), ('portrait', const Size(412, 915))]) {
    for (final e in screens.entries) {
      testWidgets('${e.key} fits in $label', (tester) async {
        tester.view.physicalSize = size * 2;
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);

        final c = await tester.runAsync(
          () => makeContainer(
            overrides: [
              adAdapterProvider.overrideWithValue(FakeAdAdapter(rootNavigatorKey, () => PreviewMode.live)),
              billingServiceProvider.overrideWithValue(FakeBillingService(() => PreviewMode.live)),
              mirroringStatusReaderProvider.overrideWithValue(() async => (active: false, name: null)),
            ],
          ),
        );
        final router = GoRouter(
          navigatorKey: rootNavigatorKey,
          routes: [GoRoute(path: '/', builder: (_, _) => e.value())],
        );
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: c!,
            child: MaterialApp.router(
              theme: AppTheme.light,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router,
            ),
          ),
        );
        for (var i = 0; i < 12; i++) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        expect(tester.takeException(), isNull);
        // Let pending timers (splash, ads) finish before teardown.
        await tester.pumpWidget(const SizedBox.shrink());
        c.dispose();
        await tester.pump(const Duration(seconds: 5));
      });
    }
  }
}
