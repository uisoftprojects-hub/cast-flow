import 'dart:async';

import 'package:castflow/core/utils/serial_runner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('jobs started together run one after another, in order (a second permission prompt never overlaps)', () async {
    final runner = SerialRunner();
    final log = <String>[];
    var running = 0;
    var maxRunning = 0;

    Future<String> job(String name, int ms) => runner.run(() async {
      running++;
      maxRunning = maxRunning < running ? running : maxRunning;
      log.add('start $name');
      await Future<void>.delayed(Duration(milliseconds: ms));
      log.add('end $name');
      running--;
      return name;
    });

    // The albums and the photo grid both ask for access when Photos opens.
    final results = await Future.wait([job('albums', 60), job('photos', 10), job('third', 5)]);

    expect(results, ['albums', 'photos', 'third']);
    expect(maxRunning, 1);
    expect(log, ['start albums', 'end albums', 'start photos', 'end photos', 'start third', 'end third']);
  });

  test('the second job sees what the first one did (already granted, so no second prompt)', () async {
    final runner = SerialRunner();
    var granted = false;
    var prompts = 0;
    Future<void> ensureAccess() => runner.run(() async {
      if (granted) return;
      prompts++;
      await Future<void>.delayed(const Duration(milliseconds: 30)); // the dialog
      granted = true;
    });

    await Future.wait([ensureAccess(), ensureAccess()]);
    expect(prompts, 1);
  });

  test('a failing job does not block the ones behind it', () async {
    final runner = SerialRunner();
    final bad = runner.run<void>(() async => throw StateError('boom'));
    final good = runner.run(() async => 7);
    await expectLater(bad, throwsStateError);
    expect(await good, 7);
  });
}
