import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/app_providers.dart';
import 'core/storage/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  final store = await LocalStore.open();
  await purgeDemoDevices(
    store,
    lastDeviceId: prefs.getString('last_device_id'),
    clearLastDevice: () => prefs.remove('last_device_id'),
  );
  runApp(
    ProviderScope(
      // Errors are surfaced to the UI with a manual retry instead of
      // Riverpod's automatic retry.
      retry: (_, _) => null,
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        localStoreProvider.overrideWithValue(store),
      ],
      child: const CastFlowApp(),
    ),
  );
}
