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

/// Current Wi-Fi / hotspot state. Re-checked every few seconds while the app
/// is in the foreground and immediately when the user returns to the app
/// (e.g. from Wi-Fi or hotspot settings).
class NetworkController extends Notifier<NetworkStatus?> {
  Timer? _poll;
  AppLifecycleListener? _lifecycle;

  @override
  NetworkStatus? build() {
    _lifecycle = AppLifecycleListener(
      onResume: () {
        refresh();
        _startPolling();
      },
      onHide: () => _poll?.cancel(),
    );
    ref.onDispose(() {
      _poll?.cancel();
      _lifecycle?.dispose();
    });
    _startPolling();
    Future.microtask(refresh);
    return null; // unknown until the first check finishes
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
