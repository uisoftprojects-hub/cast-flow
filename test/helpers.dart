import 'dart:io';

import 'package:castflow/core/app_providers.dart';
import 'package:castflow/core/storage/local_store.dart';
import 'package:castflow/features/monetization/domain/consent_manager.dart';
import 'package:castflow/features/monetization/presentation/ad_manager.dart';
import 'package:castflow/features/permissions/domain/app_permission.dart';
import 'package:castflow/features/permissions/presentation/permissions_controller.dart';
import 'fakes/fake_device_repository.dart';
import 'package:castflow/features/devices/domain/network_status.dart';
import 'package:castflow/features/devices/presentation/device_providers.dart';
import 'package:castflow/features/devices/presentation/network_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fresh container with mock prefs and a Hive store in a temp directory.
Future<ProviderContainer> makeContainer({
  Map<String, Object> prefs = const {},
  NetworkStatus Function() network = _wifi,
  DiscoveryPermissionService? discoveryPermissionService,
  List overrides = const [],
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  final dir = await Directory.systemTemp.createTemp('castflow_test');
  Hive.init(dir.path);
  final store = await LocalStore.open();

  final overrideOrigins = overrides.map((o) => (o as dynamic).origin).toSet();

  final defaultOverrides = <dynamic>[
    sharedPrefsProvider.overrideWithValue(sp),
    localStoreProvider.overrideWithValue(store),
    deviceRepositoryProvider.overrideWith((ref) => FakeDeviceRepository(() => ref.read(previewModeProvider))),
    networkStatusReaderProvider.overrideWithValue(() async => network()),
    // No native side in tests: changes come from the reader above.
    networkEventsProvider.overrideWithValue(const Stream<NetworkStatus>.empty()),
    nearbyPermissionProvider.overrideWithValue(() async {}),
    discoveryPermissionServiceProvider.overrideWithValue(
      discoveryPermissionService ?? FakeDiscoveryPermissionService(),
    ),
    consentManagerProvider.overrideWithValue(ConsentManager(debugCanRequestAds: true)),
  ];

  final effectiveOverrides = [
    for (final d in defaultOverrides)
      if (!overrideOrigins.contains(d.origin)) d,
    ...overrides,
  ];

  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      for (final o in effectiveOverrides) o,
    ],
  );
  addTearDown(() async {
    c.dispose();
    await Hive.close();
    await dir.delete(recursive: true);
  });
  return c;
}

NetworkStatus _wifi() => const NetworkStatus(wifi: true);
