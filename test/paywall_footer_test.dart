import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/widgets/buttons.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/devices/presentation/network_controller.dart';
import 'package:castflow/features/monetization/data/fake_ad_adapter.dart';
import 'package:castflow/features/monetization/presentation/ad_manager.dart';
import 'package:castflow/features/premium/data/fake_billing_service.dart';
import 'package:castflow/features/premium/presentation/billing_controller.dart';
import 'package:castflow/features/premium/presentation/paywall_screen.dart';
import 'package:castflow/core/app_providers.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'helpers.dart';

void main() {
  // Privacy Policy | Terms and Conditions | Cancel anytime stay on one line in
  // every language, including long ones, on a narrow phone.
  for (final lang in ['en', 'de', 'ru', 'hi', 'ar']) {
    testWidgets('paywall footer is one line in $lang', (tester) async {
      tester.view.physicalSize = const Size(320, 800) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      final c = await tester.runAsync(
        () => makeContainer(
          overrides: [
            adAdapterProvider.overrideWithValue(FakeAdAdapter(rootNavigatorKey, () => PreviewMode.live)),
            billingServiceProvider.overrideWithValue(FakeBillingService(() => PreviewMode.live)),
          ],
        ),
      );
      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        routes: [GoRoute(path: '/', builder: (_, _) => const PaywallScreen())],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c!,
          child: MaterialApp.router(
            theme: AppTheme.light,
            locale: Locale(lang),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      final l = lookupAppLocalizations(Locale(lang));
      final privacy = tester.getRect(find.text(l.privacyPolicy));
      final terms = tester.getRect(find.text(l.termsAndConditions));
      final cancel = tester.getRect(find.text(l.cancelAnytime));
      expect((privacy.center.dy - terms.center.dy).abs(), lessThan(4), reason: 'privacy and terms on one line');
      expect((terms.center.dy - cancel.center.dy).abs(), lessThan(4), reason: 'terms and cancel on one line');
      // Order: Privacy | Terms | Cancel anytime (cancel is third).
      final ltr = lang != 'ar';
      expect(ltr == (privacy.center.dx < terms.center.dx && terms.center.dx < cancel.center.dx), isTrue, reason: 'cancel third');
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      c.dispose();
      await tester.pump(const Duration(seconds: 5));
    });
  }

  testWidgets('Continue without internet says so instead of doing nothing', (tester) async {
    final c = await tester.runAsync(
      () => makeContainer(
        overrides: [
          adAdapterProvider.overrideWithValue(FakeAdAdapter(rootNavigatorKey, () => PreviewMode.live)),
          billingServiceProvider.overrideWithValue(FakeBillingService(() => PreviewMode.live)),
          internetCheckProvider.overrideWithValue(() async => false),
        ],
      ),
    );
    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      routes: [GoRoute(path: '/', builder: (_, _) => const PaywallScreen())],
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
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    final l = lookupAppLocalizations(const Locale('en'));
    await tester.tap(find.byType(GradientButton), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(l.noInternetConnection), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    c.dispose();
    await tester.pump(const Duration(seconds: 5));
  });
}
