import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/settings/presentation/rate_sheet.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Settings rate popup: after the intro animation 5 stars are selected', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          navigatorKey: rootNavigatorKey,
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => TextButton(onPressed: () => showRateDialog(context), child: const Text('open')),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Select a rating'), findsOneWidget, reason: 'nothing selected while the hint plays');
    await tester.pump(const Duration(seconds: 1));
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
    expect(find.text('Rate us'), findsOneWidget);
  });
}
