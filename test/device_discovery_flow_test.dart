import 'package:castflow/core/navigation.dart';
import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/presentation/connect_screen.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/devices/presentation/widgets/discovery_permission_cards.dart';
import 'package:castflow/features/devices/presentation/widgets/tv_radar.dart';
import 'package:castflow/features/permissions/domain/app_permission.dart';
import 'package:castflow/features/permissions/presentation/permissions_controller.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fakes/fake_device_repository.dart';
import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Critical Permission Flow: Scenarios A through E', () {
    test('Scenario A: Permission granted -> checks services -> starts device discovery', () async {
      final fakePerms = FakeDiscoveryPermissionService(
        initialStatus: DiscoveryPermissionStatus.notDetermined,
        requiresLocation: true,
        locationServiceEnabled: true,
      );

      final c = await makeContainer(
        overrides: [
          discoveryPermissionServiceProvider.overrideWithValue(fakePerms),
        ],
      );

      final discovery = c.read(discoveryProvider.notifier);
      final sub = c.listen(discoveryProvider, (_, _) {});

      // First-time Connect Device opened without user tap: checks permission
      await discovery.checkPermissionsAndStart(userInitiatedRequest: false);
      expect(c.read(discoveryProvider).phase, DiscoveryPhase.permissionRequired);
      expect(c.read(discoveryProvider).scanning, isFalse);

      // User taps "Grant Permission" -> native permission dialog approved
      fakePerms.setStatus(DiscoveryPermissionStatus.granted);
      await discovery.grantPermission();

      expect(fakePerms.requestCallCount, 1);
      // Automatically transitions to connectivity check and searching
      expect(c.read(discoveryProvider).phase, anyOf(DiscoveryPhase.searching, DiscoveryPhase.devicesFound));
      expect(c.read(discoveryProvider).scanning, isTrue);

      await Future<void>.delayed(const Duration(seconds: 5));
      expect(c.read(discoveryProvider).devices.length, FakeDeviceRepository.devices.length);
      sub.close();
    });

    test('Scenario B: Permission denied -> no discovery started -> retry works', () async {
      final fakePerms = FakeDiscoveryPermissionService(
        initialStatus: DiscoveryPermissionStatus.notDetermined,
        requiresLocation: false,
      );

      final c = await makeContainer(
        overrides: [
          discoveryPermissionServiceProvider.overrideWithValue(fakePerms),
        ],
      );

      final discovery = c.read(discoveryProvider.notifier);
      final sub = c.listen(discoveryProvider, (_, _) {});

      // User triggers permission request and denies
      fakePerms.setStatus(DiscoveryPermissionStatus.denied);
      await discovery.grantPermission();

      expect(c.read(discoveryProvider).phase, DiscoveryPhase.permissionDenied);
      expect(c.read(discoveryProvider).scanning, isFalse);
      expect(c.read(discoveryProvider).devices, isEmpty);

      // User taps "Try Again" / retry and grants
      fakePerms.setStatus(DiscoveryPermissionStatus.granted);
      await discovery.grantPermission();

      expect(c.read(discoveryProvider).phase, anyOf(DiscoveryPhase.searching, DiscoveryPhase.devicesFound));
      expect(c.read(discoveryProvider).scanning, isTrue);
      sub.close();
    });

    test('Scenario C: Permission permanently denied -> open settings -> recheck on resume', () async {
      final fakePerms = FakeDiscoveryPermissionService(
        initialStatus: DiscoveryPermissionStatus.permanentlyDenied,
        requiresLocation: true,
      );

      final c = await makeContainer(
        overrides: [
          discoveryPermissionServiceProvider.overrideWithValue(fakePerms),
        ],
      );

      final discovery = c.read(discoveryProvider.notifier);
      final sub = c.listen(discoveryProvider, (_, _) {});

      await discovery.checkPermissionsAndStart();
      expect(c.read(discoveryProvider).phase, DiscoveryPhase.permissionPermanentlyDenied);
      expect(c.read(discoveryProvider).scanning, isFalse);

      // User taps Open Settings
      await discovery.openSettings();
      expect(fakePerms.openedSettings, isTrue);

      // User grants in settings and returns to the app
      fakePerms.setStatus(DiscoveryPermissionStatus.granted);
      await discovery.recheckPermissions();

      expect(c.read(discoveryProvider).phase, anyOf(DiscoveryPhase.searching, DiscoveryPhase.devicesFound));
      expect(c.read(discoveryProvider).scanning, isTrue);
      sub.close();
    });

    test('Scenario D: Location services disabled (Android <= 12) -> open location settings -> resume', () async {
      final fakePerms = FakeDiscoveryPermissionService(
        initialStatus: DiscoveryPermissionStatus.granted,
        requiresLocation: true,
        locationServiceEnabled: false,
      );

      final c = await makeContainer(
        overrides: [
          discoveryPermissionServiceProvider.overrideWithValue(fakePerms),
        ],
      );

      final discovery = c.read(discoveryProvider.notifier);
      final sub = c.listen(discoveryProvider, (_, _) {});

      await discovery.checkPermissionsAndStart();
      expect(c.read(discoveryProvider).phase, DiscoveryPhase.locationServicesDisabled);
      expect(c.read(discoveryProvider).scanning, isFalse);

      // User opens location settings
      await discovery.openLocationSettings();
      expect(fakePerms.openedLocationSettings, isTrue);

      // User turns on GPS Location Services in system drawer and returns
      fakePerms.locationServiceEnabled = true;
      await discovery.recheckPermissions();

      expect(c.read(discoveryProvider).phase, anyOf(DiscoveryPhase.searching, DiscoveryPhase.devicesFound));
      expect(c.read(discoveryProvider).scanning, isTrue);
      sub.close();
    });

    test('Scenario E: Permission already granted -> skips dialog and begins scan immediately', () async {
      final fakePerms = FakeDiscoveryPermissionService(
        initialStatus: DiscoveryPermissionStatus.granted,
        requiresLocation: false,
        locationServiceEnabled: true,
      );

      final c = await makeContainer(
        overrides: [
          discoveryPermissionServiceProvider.overrideWithValue(fakePerms),
        ],
      );

      final discovery = c.read(discoveryProvider.notifier);
      final sub = c.listen(discoveryProvider, (_, _) {});

      // Opening Connect screen immediately proceeds to discovery
      await discovery.checkPermissionsAndStart(userInitiatedRequest: false);

      expect(fakePerms.requestCallCount, 0, reason: 'Must skip permission dialog if already granted');
      expect(c.read(discoveryProvider).phase, anyOf(DiscoveryPhase.searching, DiscoveryPhase.devicesFound));
      expect(c.read(discoveryProvider).scanning, isTrue);
      sub.close();
    });
  });

  group('Nearby Device Discovery Accuracy & Deduplication', () {
    test('mergeCastDevices correctly deduplicates and merges metadata across protocols', () {
      final now = DateTime.now();
      const devMdns = CastDevice(
        id: 'tv-livingroom-mdns',
        name: 'Samsung QLED TV',
        type: DeviceType.smartTv,
        address: '192.168.1.105',
        port: 8001,
        model: 'QN90B',
      );

      final devSsdp = CastDevice(
        id: 'tv-livingroom-ssdp',
        name: 'TV 192.168.1.105',
        type: DeviceType.smartTv,
        address: '192.168.1.105',
        port: 8002,
        model: 'Samsung QLED Series',
        lastSeen: now,
      );

      final merged = mergeCastDevices(devMdns, devSsdp);

      expect(merged.address, '192.168.1.105');
      // Preserved the friendly name over fallback 'TV ...'
      expect(merged.name, 'Samsung QLED TV');
      expect(merged.model, 'QN90B');
      expect(merged.port, 8001);
      expect(merged.lastSeen, now);
    });

    test('stop() cancels discovery stream and updates phase to stopped', () async {
      final c = await makeContainer();
      final discovery = c.read(discoveryProvider.notifier);
      final sub = c.listen(discoveryProvider, (_, _) {});

      await discovery.scan();
      expect(c.read(discoveryProvider).scanning, isTrue);

      discovery.stop();
      expect(c.read(discoveryProvider).scanning, isFalse);
      expect(c.read(discoveryProvider).phase, DiscoveryPhase.stopped);

      sub.close();
    });

    test('repeated scan() calls cancel prior session and prevent overlapping streams', () async {
      final c = await makeContainer();
      final discovery = c.read(discoveryProvider.notifier);
      final sub = c.listen(discoveryProvider, (_, _) {});

      // Call scan 3 times rapidly
      discovery.scan();
      discovery.scan();
      discovery.scan();

      expect(c.read(discoveryProvider).scanning, isTrue);
      await Future<void>.delayed(const Duration(seconds: 5));
      expect(c.read(discoveryProvider).devices.length, FakeDeviceRepository.devices.length);
      sub.close();
    });
  });

  group('Device Connection Lifecycle', () {
    test('connect() verifies connection and updates status to connected', () async {
      final c = await makeContainer();
      final conn = c.read(connectionProvider.notifier);
      final sub = c.listen(connectionProvider, (_, _) {});

      const targetDevice = CastDevice(
        id: 'dev-1',
        name: 'Living Room TV',
        type: DeviceType.smartTv,
        address: '192.168.1.50',
      );

      final ok = await conn.connect(targetDevice);
      expect(ok, isTrue);
      expect(c.read(connectionProvider).isConnected, isTrue);
      expect(c.read(connectionProvider).device?.name, 'Living Room TV');

      // Disconnect
      await conn.disconnect();
      expect(c.read(connectionProvider).isConnected, isFalse);
      expect(c.read(connectionProvider).device, isNull);

      sub.close();
    });

    test('connecting to another device automatically disconnects the previous device', () async {
      final c = await makeContainer();
      final conn = c.read(connectionProvider.notifier);
      final sub = c.listen(connectionProvider, (_, _) {});

      const device1 = CastDevice(id: 'dev-1', name: 'TV 1', type: DeviceType.smartTv, address: '192.168.1.51');
      const device2 = CastDevice(id: 'dev-2', name: 'TV 2', type: DeviceType.smartTv, address: '192.168.1.52');

      await conn.connect(device1);
      expect(c.read(connectionProvider).device?.id, 'dev-1');

      // Connect to device2 -> cleanly switches
      await conn.connect(device2);
      expect(c.read(connectionProvider).device?.id, 'dev-2');
      expect(c.read(connectionProvider).isConnected, isTrue);

      sub.close();
    });

    test('duplicate connection attempt is rejected while connecting', () async {
      final c = await makeContainer();
      final conn = c.read(connectionProvider.notifier);
      final sub = c.listen(connectionProvider, (_, _) {});

      const device = CastDevice(id: 'dev-1', name: 'TV 1', type: DeviceType.smartTv, address: '192.168.1.51');

      final f1 = conn.connect(device);
      // Immediate duplicate tap while connecting
      final f2 = conn.connect(device);

      final r2 = await f2;
      expect(r2, isFalse, reason: 'Duplicate connection attempt must be rejected');

      final r1 = await f1;
      expect(r1, isTrue);

      sub.close();
    });
  });

  group('Discovery UI States & Permission Cards', () {
    testWidgets('DiscoveryPermissionCard renders correctly for permissionRequired', (tester) async {
      bool grantTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          home: Scaffold(
            body: DiscoveryPermissionCard(
              phase: DiscoveryPhase.permissionRequired,
              requiresLocation: true,
              onGrant: () => grantTapped = true,
              onOpenSettings: () {},
              onOpenLocationSettings: () {},
              onRecheck: () {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(DiscoveryPermissionCard), findsOneWidget);
      expect(find.text('Allow Permission'), findsOneWidget);

      await tester.tap(find.text('Allow Permission'));
      expect(grantTapped, isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('DiscoveryPermissionCard renders locationServicesDisabled with open settings action', (tester) async {
      bool openLocationTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          home: Scaffold(
            body: DiscoveryPermissionCard(
              phase: DiscoveryPhase.locationServicesDisabled,
              requiresLocation: true,
              onGrant: () {},
              onOpenSettings: () {},
              onOpenLocationSettings: () => openLocationTapped = true,
              onRecheck: () {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Open Location Settings'), findsOneWidget);
      await tester.tap(find.text('Open Location Settings'));
      expect(openLocationTapped, isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('ConnectScreen requests built-in permission and shows radar without permission grant container', (tester) async {
      final fakePerms = FakeDiscoveryPermissionService(
        initialStatus: DiscoveryPermissionStatus.notDetermined,
        requiresLocation: true,
      );

      final c = await tester.runAsync(
        () => makeContainer(
          overrides: [
            discoveryPermissionServiceProvider.overrideWithValue(fakePerms),
          ],
        ),
      );

      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        routes: [GoRoute(path: '/', builder: (_, _) => const ConnectScreen(standalone: true))],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c!,
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      );

      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      expect(fakePerms.requestCallCount, 1);
      expect(find.byType(DiscoveryPermissionCard), findsNothing);
      expect(find.byType(TvRadar), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      c.dispose();
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('ConnectScreen shows radar and devices when permission granted', (tester) async {
      final fakePerms = FakeDiscoveryPermissionService(
        initialStatus: DiscoveryPermissionStatus.granted,
      );

      final c = await tester.runAsync(
        () => makeContainer(
          overrides: [
            discoveryPermissionServiceProvider.overrideWithValue(fakePerms),
          ],
        ),
      );

      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        routes: [GoRoute(path: '/', builder: (_, _) => const ConnectScreen(standalone: true))],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c!,
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      );

      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }

      // Shows TvRadar and device tiles
      expect(find.text('Samsung TV'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      c.dispose();
      await tester.pump(const Duration(seconds: 5));
    });
  });
}
