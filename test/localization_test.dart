import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/guide/presentation/guide_screen.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('every language has its own text, not a copy of English', () {
    final en = AppLocalizations.supportedLocales.firstWhere((l) => l.languageCode == 'en');
    final english = lookupAppLocalizations(en);
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == 'en') continue;
      final l = lookupAppLocalizations(locale);
      expect(l.networkRequiredTitle, isNot(english.networkRequiredTitle), reason: '${locale.languageCode} title');
      expect(l.howToConnect, isNot(english.howToConnect), reason: '${locale.languageCode} guide');
      expect(l.stillNeedHelp, isNot(english.stillNeedHelp), reason: '${locale.languageCode} help');
      expect(l.connectWithWifi, isNot(english.connectWithWifi), reason: '${locale.languageCode} wifi');
    }
  });

  test('the same message is translated with its values filled in', () {
    final hi = lookupAppLocalizations(const Locale('hi'));
    expect(hi.reconnectTo('टीवी'), contains('टीवी'));
    expect(hi.devicesFound(3), contains('3'));
  });

  testWidgets('choosing Hindi shows the guide in Hindi', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const GuideScreen(topic: 'mirroring'),
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light,
        locale: const Locale('hi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('स्क्रीन मिररिंग मदद'), findsOneWidget);
    expect(find.text('एक ही वाई-फ़ाई से जुड़ें'), findsOneWidget);
    expect(find.text('Join the same Wi-Fi'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
  });
}
