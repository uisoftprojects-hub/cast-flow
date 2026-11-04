import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/devices/presentation/widgets/connection_guide_sheet.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The "How to connect" pictures must not overflow in any language, long or RTL.
  for (final lang in ['en', 'ar', 'fa', 'ur', 'de', 'ru', 'hi', 'th', 'ja']) {
    testWidgets('How to connect fits in $lang', (tester) async {
      tester.view.physicalSize = const Size(360, 800) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          locale: Locale(lang),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ConnectionGuideSheet()),
        ),
      );
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      final ex = tester.takeException();
      if (ex is FlutterError) debugPrint(ex.toStringDeep());
      expect(ex, isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 2));
    });
  }
}
