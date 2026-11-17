import 'package:castflow/app/shell.dart';
import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/core/widgets/buttons.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'helpers.dart';

const _paths = ['/home', '/devices', '/history', '/settings'];

void main() {
  late int exitCalls;
  late bool? frameworkHandlesBack;
  ProviderContainer? container;

  Future<void> shutdown(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    container?.dispose();
    await tester.pump(const Duration(seconds: 5));
  }

  setUp(() {
    exitCalls = 0;
    frameworkHandlesBack = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemNavigator.pop') exitCalls++;
        if (call.method == 'SystemNavigator.setFrameworkHandlesBack') {
          frameworkHandlesBack = call.arguments as bool;
        }
        return null;
      },
    );
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  Future<GoRouter> pumpApp(WidgetTester tester, {String initial = '/home'}) async {
    tester.view.physicalSize = const Size(360, 780) * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final c = await tester.runAsync(() => makeContainer());
    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initial,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => AppShell(navigationShell: shell),
          branches: [
            for (final p in _paths)
              StatefulShellBranch(
                routes: [GoRoute(path: p, builder: (_, _) => Center(child: Text('page $p')))],
              ),
          ],
        ),
        GoRoute(
          path: '/detail',
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const Scaffold(body: Center(child: Text('detail page'))),
        ),
      ],
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
    container = c;
    return router;
  }

  Future<void> back(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pump(const Duration(milliseconds: 600));
  }

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.uri.path;

  testWidgets('framework keeps handling Back on every tab', (tester) async {
    final router = await pumpApp(tester);
    for (final p in _paths) {
      router.go(p);
      await tester.pump(const Duration(milliseconds: 500));
      expect(frameworkHandlesBack, isNot(false), reason: 'tab $p');
    }
    await shutdown(tester);
  });

  testWidgets('Back on a non-home tab goes Home with no sheet and no exit', (tester) async {
    final router = await pumpApp(tester);
    for (final p in _paths.skip(1)) {
      router.go(p);
      await tester.pump(const Duration(milliseconds: 500));
      await back(tester);
      expect(path(router), '/home', reason: 'from $p');
      expect(find.byType(BottomSheet), findsNothing);
    }
    expect(exitCalls, 0);
    await shutdown(tester);
  });

  testWidgets('Back on Home shows exactly one sheet; second Back only closes it', (tester) async {
    final router = await pumpApp(tester);
    await back(tester);
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(exitCalls, 0);
    expect(path(router), '/home');

    // Back (like a tap outside the sheet) dismisses the sheet; the app stays open.
    await back(tester);
    expect(find.byType(BottomSheet), findsNothing);
    expect(exitCalls, 0);
    expect(path(router), '/home');
    await shutdown(tester);
  });

  testWidgets('two rapid Backs never stack two sheets', (tester) async {
    await pumpApp(tester);
    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.binding.handlePopRoute();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(BottomSheet).evaluate().length, lessThanOrEqualTo(1));
    expect(exitCalls, lessThanOrEqualTo(1));
    await shutdown(tester);
  });

  testWidgets('Back on a pushed detail screen returns to its tab', (tester) async {
    final router = await pumpApp(tester);
    router.go('/history');
    await tester.pump(const Duration(milliseconds: 500));
    router.push('/detail');
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('detail page'), findsOneWidget);

    await back(tester);
    expect(find.text('detail page'), findsNothing);
    expect(path(router), '/history');
    expect(find.byType(BottomSheet), findsNothing);
    expect(exitCalls, 0);
    await shutdown(tester);
  });

  testWidgets('exit sheet button exits the app', (tester) async {
    await pumpApp(tester);
    await back(tester);
    expect(find.byType(BottomSheet), findsOneWidget);
    tester.widget<GradientButton>(find.byType(GradientButton)).onPressed!();
    await tester.pump();
    expect(exitCalls, 1);
    await shutdown(tester);
  });
}
