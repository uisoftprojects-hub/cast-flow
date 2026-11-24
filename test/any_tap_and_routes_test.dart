import 'package:castflow/core/widgets/any_tap_listener.dart';
import 'package:castflow/features/monetization/presentation/ad_route_observer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(AnyTapListener child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('AnyTapListener counts every real tap, once', () {
    testWidgets('a tap on a button counts (and the button still works)', (tester) async {
      var counted = 0, pressed = 0;
      await tester.pumpWidget(
        _app(
          AnyTapListener(
            onTap: () => counted++,
            child: Center(child: ElevatedButton(onPressed: () => pressed++, child: const Text('go'))),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pump();
      expect(pressed, 1);
      expect(counted, 1);
    });

    testWidgets('a tap on empty space counts too; two taps count twice', (tester) async {
      var counted = 0;
      await tester.pumpWidget(_app(AnyTapListener(onTap: () => counted++, child: const SizedBox.expand())));
      await tester.tapAt(const Offset(100, 300));
      await tester.pump();
      await tester.tapAt(const Offset(120, 320));
      await tester.pump();
      expect(counted, 2);
    });

    testWidgets('scrolling and long presses do not count', (tester) async {
      var counted = 0;
      await tester.pumpWidget(
        _app(
          AnyTapListener(
            onTap: () => counted++,
            child: ListView(children: [for (var i = 0; i < 40; i++) SizedBox(height: 80, child: Text('row $i'))]),
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();
      expect(counted, 0, reason: 'a scroll is not a click');
      // Events carry their own clock: down at 0 ms, up 700 ms later.
      GestureBinding.instance.handlePointerEvent(
        const PointerDownEvent(pointer: 9, position: Offset(200, 200), timeStamp: Duration.zero),
      );
      GestureBinding.instance.handlePointerEvent(
        const PointerUpEvent(pointer: 9, position: Offset(200, 200), timeStamp: Duration(milliseconds: 700)),
      );
      await tester.pump();
      expect(counted, 0, reason: 'a long press is not a click');
    });

    testWidgets('two fingers at once (pinch / multi-touch) do not count', (tester) async {
      var counted = 0;
      await tester.pumpWidget(_app(AnyTapListener(onTap: () => counted++, child: const SizedBox.expand())));
      final a = await tester.startGesture(const Offset(100, 200), pointer: 1);
      final b = await tester.startGesture(const Offset(300, 200), pointer: 2);
      await a.up();
      await b.up();
      await tester.pump();
      expect(counted, 0);
    });
  });

  group('App Open is only blocked on the startup screens', () {
    Route<void> route(String name) => PageRouteBuilder<void>(
      settings: RouteSettings(name: name),
      pageBuilder: (_, _, _) => const SizedBox(),
    );

    bool safeOn(String name) {
      final o = AdRouteObserver();
      o.didPush(route(name), null);
      return o.topIsSafe;
    }

    test('first-run Language is blocked, Settings → Language is not', () {
      expect(safeOn('/language'), isFalse);
      expect(safeOn('/settings/language'), isTrue, reason: 'App Open may show on the Settings language screen');
    });

    test('splash, onboarding and paywall stay blocked; Home and Settings are fine', () {
      for (final r in ['/splash', '/onboarding', '/paywall', '/premium']) {
        expect(safeOn(r), isFalse, reason: r);
      }
      for (final r in ['/home', '/settings', '/devices', '/photos']) {
        expect(safeOn(r), isTrue, reason: r);
      }
    });
  });
}
