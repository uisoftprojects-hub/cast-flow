import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/devices/domain/network_status.dart';
import 'package:castflow/features/mirroring/domain/mirroring.dart';
import 'package:castflow/features/mirroring/presentation/mirroring_controller.dart';
import 'package:castflow/features/mirroring/presentation/mirroring_screen.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'helpers.dart';

void main() {
  noDeviceTests();
  testWidgets('on mobile data, Start mirroring shows the Wi-Fi / hotspot alert instead of starting', (tester) async {
    var pickerOpened = false;
    final c = await tester.runAsync(
      () => makeContainer(
        // Mobile data only: neither Wi-Fi nor the phone's hotspot.
        network: () => const NetworkStatus(),
        overrides: [
          mirroringStatusReaderProvider.overrideWithValue(() async => (active: false, name: null)),
          castSettingsOpenerProvider.overrideWithValue(() async {
            pickerOpened = true;
            return true;
          }),
        ],
      ),
    );
    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      routes: [GoRoute(path: '/', builder: (_, _) => const MirroringScreen())],
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
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Start'));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Connect with Wi-Fi'), findsOneWidget);
    expect(find.text('Continue with hotspot'), findsOneWidget);
    expect(c.read(mirroringProvider).phase, MirrorPhase.idle);
    expect(pickerOpened, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    c.dispose();
    await tester.pump(const Duration(seconds: 5));
  });
}

void noDeviceTests() {
  testWidgets('after the cast picker closes with no TV, Mirroring shows "No TV found" and the media shortcuts', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780) * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final c = await tester.runAsync(
      () => makeContainer(
        overrides: [mirroringStatusReaderProvider.overrideWithValue(() async => (active: false, name: null))],
      ),
    );
    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      routes: [GoRoute(path: '/', builder: (_, _) => const MirroringScreen())],
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
    await tester.pump(const Duration(milliseconds: 400));
    // The user tapped Start, went to Android's picker and came back with nothing.
    c.read(mirroringProvider.notifier).state = c
        .read(mirroringProvider)
        .copyWith(phase: MirrorPhase.idle, error: mirrorNotStarted);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('No TV found'), findsOneWidget);
    expect(find.text('Cast photos, videos & music'), findsOneWidget);
    expect(find.text('Photos'), findsOneWidget);
    expect(find.text('Music'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    c.dispose();
    await tester.pump(const Duration(seconds: 5));
  });
}
