import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/platform/network_channel.dart';
import '../domain/network_status.dart';

/// Reads the platform network state. Overridable in tests.
final networkStatusReaderProvider = Provider<Future<NetworkStatus> Function()>(
  (ref) =>
      () async => NetworkStatus.fromMap(await NetworkChannel.networkStatus()),
);

/// Network changes pushed by the platform as they happen (Android:
/// ConnectivityManager.NetworkCallback + the hotspot state broadcast).
/// Overridable in tests; empty off Android.
final networkEventsProvider = Provider<Stream<NetworkStatus>>(
  (ref) => NetworkChannel.networkEvents().map(NetworkStatus.fromMap),
);

/// Current Wi-Fi / hotspot state. Updated the moment Android reports a change,
/// re-checked when the user returns to the app (e.g. from Wi-Fi or hotspot
/// settings) and, as a safety net for OEMs that don't report hotspot changes,
/// every few seconds while the app is in the foreground.
class NetworkController extends Notifier<NetworkStatus?> {
  Timer? _poll;
  AppLifecycleListener? _lifecycle;
  StreamSubscription<NetworkStatus>? _events;

  @override
  NetworkStatus? build() {
    _lifecycle = AppLifecycleListener(
      onResume: () {
        refresh();
        _startPolling();
        _listen();
      },
      // In the background nothing needs the network state: no callbacks held.
      onHide: () {
        _poll?.cancel();
        _events?.cancel();
        _events = null;
      },
    );
    ref.onDispose(() {
      _poll?.cancel();
      _events?.cancel();
      _lifecycle?.dispose();
    });
    _startPolling();
    _listen();
    Future.microtask(refresh);
    return null; // unknown until the first check finishes
  }

  void _listen() {
    _events ??= ref
        .read(networkEventsProvider)
        .listen(
          (next) {
            if (ref.mounted && next != state) state = next;
          },
          onError: (Object _) {},
        );
  }

  void _startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 3), (_) => refresh());
  }

  Future<NetworkStatus> refresh() async {
    final next = await ref.read(networkStatusReaderProvider)();
    if (ref.mounted && next != state) state = next;
    return next;
  }
}

final networkProvider = NotifierProvider<NetworkController, NetworkStatus?>(NetworkController.new);
