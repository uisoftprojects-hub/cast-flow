import 'dart:io';

import 'package:castflow/core/app_providers.dart';
import 'package:castflow/core/storage/local_store.dart';
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
  List overrides = const [],
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  final dir = await Directory.systemTemp.createTemp('castflow_test');
  Hive.init(dir.path);
  final store = await LocalStore.open();
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      sharedPrefsProvider.overrideWithValue(sp),
      localStoreProvider.overrideWithValue(store),
      // Tests use the scripted fake instead of real network discovery.
      deviceRepositoryProvider.overrideWith((ref) => FakeDeviceRepository(() => ref.read(previewModeProvider))),
      // On Wi-Fi unless a test says otherwise.
      networkStatusReaderProvider.overrideWithValue(() async => network()),
      nearbyPermissionProvider.overrideWithValue(() async {}),
      ...overrides,
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
