import 'package:castflow/core/app_providers.dart';
import 'package:castflow/features/history/domain/history_entry.dart';
import 'package:castflow/features/history/presentation/history_controller.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/premium/domain/billing.dart';
import 'package:castflow/features/premium/presentation/billing_controller.dart';
import 'package:castflow/features/settings/presentation/settings_controller.dart';
import 'package:castflow/features/webcast/domain/web_models.dart';
import 'package:castflow/features/webcast/presentation/browser_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  test('store prices come from the billing service, not the app', () async {
    final c = await makeContainer();
    final products = await c.read(storeProductsProvider.future);
    expect(products.map((p) => p.id), [BillingConfig.weekly, BillingConfig.yearly, BillingConfig.lifetime]);
    expect(products.every((p) => p.price.isNotEmpty), isTrue);
    expect(products.last.isSubscription, isFalse);
  });

  test('a purchase activates the entitlement and Pro', () async {
    final c = await makeContainer();
    c.listen(entitlementProvider, (_, _) {});
    final products = await c.read(storeProductsProvider.future);
    final outcome = await c.read(entitlementProvider.notifier).buy(products[1]);
    await Future<void>.delayed(Duration.zero);
    expect(outcome, PurchaseOutcome.success);
    expect(c.read(entitlementProvider).active, isTrue);
    expect(c.read(settingsProvider).isPremium, isTrue);
  });

  test('restore with nothing owned reports no entitlement', () async {
    final c = await makeContainer();
    c.listen(entitlementProvider, (_, _) {});
    expect(await c.read(entitlementProvider.notifier).restore(), isFalse);
  });

  test('purchase fails cleanly when the store is unavailable', () async {
    final c = await makeContainer();
    c.listen(entitlementProvider, (_, _) {});
    c.read(previewModeProvider.notifier).set(PreviewMode.error);
    const product = StoreProduct(id: BillingConfig.weekly, title: 'Weekly', price: '\$1');
    expect(await c.read(entitlementProvider.notifier).buy(product), PurchaseOutcome.unavailable);
    expect(c.read(settingsProvider).isPremium, isFalse);
  });

  test('history is kept on-device and bounded', () async {
    final c = await makeContainer();
    final repo = c.read(historyRepositoryProvider);
    final base = DateTime(2026, 1, 1);
    for (var i = 0; i < 205; i++) {
      await repo.add(HistoryEntry(
        id: 'h$i',
        title: 'Item $i',
        kind: CastKind.photo,
        deviceName: 'TV',
        castAt: base.add(Duration(minutes: i)),
        seed: i,
      ));
    }
    final items = await repo.list();
    expect(items.length, 200);
    expect(items.first.id, 'h204', reason: 'newest first');
    expect(items.any((e) => e.id == 'h0'), isFalse, reason: 'oldest dropped');
  });

  test('bookmarks and browser history persist and can be cleared', () async {
    final c = await makeContainer();
    final browser = c.read(browserProvider.notifier);
    await browser.toggleBookmark(WebLink(title: 'Vimeo', url: 'https://vimeo.com', visitedAt: DateTime.now()));
    await browser.visit(WebLink(title: 'Vimeo', url: 'https://vimeo.com', visitedAt: DateTime.now()));
    await browser.visit(WebLink(title: 'Vimeo', url: 'https://vimeo.com', visitedAt: DateTime.now()));
    expect(c.read(browserRepositoryProvider).bookmarks().length, 1);
    expect(c.read(browserRepositoryProvider).history().length, 1, reason: 'revisits move to top, no duplicates');

    await browser.clearHistory();
    await browser.clearBookmarks();
    expect(c.read(browserProvider).history, isEmpty);
    expect(c.read(browserProvider).bookmarks, isEmpty);
  });

  test('new settings round-trip through local storage', () async {
    final c = await makeContainer();
    final s = c.read(settingsProvider.notifier);
    s.setHaptics(false);
    s.setButtonSound(true);
    await s.confirmLanguage('ar');
    final reloaded = c.read(settingsRepositoryProvider).load();
    expect(reloaded.hapticsEnabled, isFalse);
    expect(reloaded.buttonSound, isTrue);
    expect(reloaded.languageCode, 'ar');
    expect(reloaded.languageChosen, isTrue);
  });
}
