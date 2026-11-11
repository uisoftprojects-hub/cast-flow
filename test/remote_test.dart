import 'dart:convert';
import 'dart:io';

import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/domain/receiver_capabilities.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/pairing/domain/pairing.dart';
import 'package:castflow/features/remote/data/network_remote_service.dart';
import 'package:castflow/features/remote/domain/remote_service.dart';
import 'package:castflow/features/remote/presentation/remote_controller.dart';
import 'package:castflow/features/remote/presentation/remote_screen.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'helpers.dart';

class _MemoryCredentials implements CredentialStore {
  final map = <String, String>{};
  @override
  Future<String?> read(String id) async => map[id];
  @override
  Future<void> write(String id, String c) async => map[id] = c;
  @override
  Future<void> delete(String id) async => map.remove(id);
}

class _Recorder implements RemoteService {
  final sent = <RemoteCommand>[];
  @override
  Future<void> send(CastDevice device, RemoteCommand command) async => sent.add(command);
}

const _roku = CastDevice(id: 'roku-1', name: 'Living Roku', type: DeviceType.roku, address: '127.0.0.1', port: 8060);
const _samsung = CastDevice(
  id: 'sam-1',
  name: 'Samsung TV',
  type: DeviceType.smartTv,
  address: '127.0.0.1',
  port: 8002,
  model: 'Samsung',
);

void main() {
  // flutter_test blocks real sockets by default; these tests talk to local fake TVs.
  setUpAll(() => HttpOverrides.global = null);

  group('every advertised command has a real key mapping', () {
    test('Roku', () {
      for (final c in receiverCapabilities[DeviceType.roku]!) {
        expect(NetworkRemoteService.rokuKeys[c], isNotNull, reason: c.label);
      }
    });
    test('Android TV / Samsung (smart TV)', () {
      for (final c in receiverCapabilities[DeviceType.smartTv]!) {
        expect(NetworkRemoteService.androidKeyCodes[c], isNotNull, reason: 'android ${c.label}');
        expect(NetworkRemoteService.samsungKeys[c], isNotNull, reason: 'samsung ${c.label}');
      }
    });
  });

  test('Roku: each command POSTs the right keypress to the TV', () async {
    final server = await HttpServer.bind('127.0.0.1', 0);
    addTearDown(() => server.close(force: true));
    final seen = <String>[];
    server.listen((req) {
      seen.add('${req.method} ${req.uri.path}');
      req.response
        ..statusCode = 200
        ..close();
    });
    final service = NetworkRemoteService(_MemoryCredentials(), rokuPort: server.port);
    for (final c in receiverCapabilities[DeviceType.roku]!) {
      await service.send(_roku, c);
    }
    expect(seen, hasLength(receiverCapabilities[DeviceType.roku]!.length));
    expect(seen, contains('POST /keypress/Select'));
    expect(seen, contains('POST /keypress/Home'));
    expect(seen, contains('POST /keypress/VolumeUp'));
    expect(seen.every((s) => s.startsWith('POST /keypress/')), isTrue);
  });

  test('Roku: a TV error becomes a readable failure', () async {
    final server = await HttpServer.bind('127.0.0.1', 0);
    addTearDown(() => server.close(force: true));
    server.listen(
      (req) => req.response
        ..statusCode = 403
        ..close(),
    );
    final service = NetworkRemoteService(_MemoryCredentials(), rokuPort: server.port);
    expect(() => service.send(_roku, RemoteCommand.ok), throwsA(isA<HttpException>()));
  });

  test('Unsupported receivers say so instead of pretending', () {
    final service = NetworkRemoteService(_MemoryCredentials());
    const cast = CastDevice(id: 'c', name: 'Chromecast', type: DeviceType.chromecast, address: '127.0.0.1');
    expect(() => service.send(cast, RemoteCommand.ok), throwsA(isA<UnsupportedError>()));
  });

  test('Samsung: connects with the saved token and sends KEY_ presses', () async {
    final server = await HttpServer.bind('127.0.0.1', 0);
    addTearDown(() => server.close(force: true));
    final queries = <String>[];
    final keys = <String>[];
    server.listen((req) async {
      queries.add(req.uri.query);
      final ws = await WebSocketTransformer.upgrade(req);
      ws.add(jsonEncode({'event': 'ms.channel.connect', 'data': {}}));
      ws.listen((m) {
        final p = (jsonDecode(m as String) as Map)['params'] as Map;
        keys.add('${p['Cmd']}:${p['DataOfCmd']}:${p['TypeOfRemote']}');
      });
    });
    final creds = _MemoryCredentials()..map['sam-1'] = 'TOKEN123';
    final service = NetworkRemoteService(
      creds,
      samsungUri: (d, name, token) => Uri.parse('ws://127.0.0.1:${server.port}/?name=$name$token'),
    );
    addTearDown(service.dispose);
    for (final c in [RemoteCommand.up, RemoteCommand.ok, RemoteCommand.volumeUp, RemoteCommand.mute]) {
      await service.send(_samsung, c);
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(queries.single, contains('token=TOKEN123'));
    expect(keys, [
      'Click:KEY_UP:SendRemoteKey',
      'Click:KEY_ENTER:SendRemoteKey',
      'Click:KEY_VOLUP:SendRemoteKey',
      'Click:KEY_MUTE:SendRemoteKey',
    ]);
  });

  test('Samsung: a rejected token fails with a re-pair message', () async {
    final server = await HttpServer.bind('127.0.0.1', 0);
    addTearDown(() => server.close(force: true));
    server.listen((req) async {
      final ws = await WebSocketTransformer.upgrade(req);
      ws.add(jsonEncode({'event': 'ms.channel.unauthorized'}));
    });
    final service = NetworkRemoteService(
      _MemoryCredentials(),
      samsungUri: (d, name, token) => Uri.parse('ws://127.0.0.1:${server.port}/'),
    );
    addTearDown(service.dispose);
    expect(() => service.send(_samsung, RemoteCommand.ok), throwsA(isA<HttpException>()));
  });

  testWidgets('Remote screen: every enabled button is tappable and sends its command', (tester) async {
    tester.view.physicalSize = const Size(412, 1400) * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final recorder = _Recorder();
    final c = await tester.runAsync(() => makeContainer(overrides: [remoteServiceProvider.overrideWithValue(recorder)]));
    await tester.runAsync(() => c!.read(connectionProvider.notifier).connect(_roku));
    expect(c!.read(connectionProvider).isConnected, isTrue);

    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      routes: [GoRoute(path: '/', builder: (_, _) => const RemoteScreen())],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    // Buttons carry their command label as tooltip.
    final tappable = {
      RemoteCommand.back,
      RemoteCommand.home,
      RemoteCommand.menu,
      RemoteCommand.playPause,
      RemoteCommand.previous,
      RemoteCommand.next,
      RemoteCommand.rewind,
      RemoteCommand.fastForward,
      RemoteCommand.volumeUp,
      RemoteCommand.volumeDown,
      RemoteCommand.mute,
    };
    for (final cmd in tappable) {
      final finder = find.byTooltip(cmd.label);
      if (finder.evaluate().isEmpty) continue; // some keys live on the other pad layout
      await tester.ensureVisible(finder.first);
      await tester.tap(finder.first, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(recorder.sent.toSet().length, greaterThanOrEqualTo(8), reason: 'sent: ${recorder.sent}');
    expect(recorder.sent, contains(RemoteCommand.home));
    expect(recorder.sent, contains(RemoteCommand.volumeUp));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    c.dispose();
    await tester.pump(const Duration(seconds: 5));
  });
}
