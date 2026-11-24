import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/analytics/analytics.dart';
import 'core/analytics/firebase_analytics_sink.dart';
import 'core/app_providers.dart';
import 'core/debug_log.dart';
import 'core/storage/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _installErrorHandlers();
  // Portrait only: the whole app is laid out for a tall screen.
  await SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  // Independent startup work runs in parallel so the first frame appears sooner.
  final firebaseFuture = FirebaseAnalyticsSink.tryCreate();
  final prefsFuture = SharedPreferences.getInstance();
  await Hive.initFlutter();
  final store = await LocalStore.open();
  final prefs = await prefsFuture;
  final firebase = await firebaseFuture;
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
        if (firebase != null) analyticsSinkProvider.overrideWithValue(firebase),
      ],
      child: const CastFlowApp(),
    ),
  );
}

/// Release builds never show the framework's grey error box and never let a stray
/// asynchronous error take the app down; debug builds keep the full red screen
/// and console output so mistakes are still loud during development.
void _installErrorHandlers() {
  if (kReleaseMode) {
    ErrorWidget.builder = (_) => const SizedBox.shrink();
  }
  final framework = FlutterError.onError;
  FlutterError.onError = (details) {
    if (kDebugMode) {
      (framework ?? FlutterError.presentError)(details);
    } else {
      dlog('[ERROR] Flutter error: ${details.exceptionAsString()}\n${details.stack}');
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // One searchable marker (and the stack) so a log can be grepped for [ERROR].
    dlog('[ERROR] Unhandled error: $error\n$stack');
    return kReleaseMode; // debug: let the VM print it as before
  };
}
