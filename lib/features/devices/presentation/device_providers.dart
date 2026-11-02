import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/storage/local_store.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/hive_saved_devices_repository.dart';
import '../data/network_device_repository.dart';
import '../domain/cast_device.dart';
import '../domain/network_status.dart';
import '../../pairing/presentation/pairing_controller.dart';
import 'network_controller.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => NetworkDeviceRepository(),
);

final savedDevicesProvider = Provider<SavedDevicesRepository>(
  (ref) => HiveSavedDevicesRepository(ref.watch(localStoreProvider).devices),
);

/// Asks for Nearby Wi-Fi devices on Android 13+ (granted implicitly below).
final nearbyPermissionProvider = Provider<Future<void> Function()>((ref) => () async {
      if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
      try {
        await Permission.nearbyWifiDevices.request();
      } catch (_) {}
    });

/// Runs discovery as a background stream so scanning never blocks the UI.
/// Checks the network first; on the phone's own hotspot it keeps rescanning
/// so a TV appears as soon as it joins, without a manual refresh.
class DiscoveryController extends Notifier<DiscoveryState> {
  StreamSubscription<List<CastDevice>>? _sub;
  Timer? _rescan;
  int _run = 0;

  static const hotspotRescanDelay = Duration(seconds: 4);

  @override
  DiscoveryState build() {
    ref.onDispose(_cancel);
    ref.listen(networkProvider, (prev, next) {
      // Network came back while we were waiting for it: start automatically.
      if (next != null && next.ready && state.networkRequired) scan();
      if (next != null && !next.ready && (state.scanning || state.hotspot)) {
        _run++;
        _cancel();
        state = DiscoveryState(devices: state.devices, networkRequired: true);
      }
    });
    return const DiscoveryState();
  }

  void _cancel() {
    _sub?.cancel();
    _rescan?.cancel();
  }

  Future<void> scan() async {
    _cancel();
    final run = ++_run;
    state = DiscoveryState(scanning: true, hotspot: state.hotspot, devices: state.hotspot ? state.devices : const []);
    final network = await ref.read(networkProvider.notifier).refresh();
    if (run != _run) return;
    if (!network.ready) {
      state = const DiscoveryState(networkRequired: true);
      return;
    }
    await ref.read(nearbyPermissionProvider)();
    if (run != _run) return;
    _discover(network, run, keep: false);
  }

  void _discover(NetworkStatus network, int run, {required bool keep}) {
    final hotspot = network.mode == NetworkMode.hotspot;
    final repo = ref.read(deviceRepositoryProvider);
    final previous = keep ? state.devices : const <CastDevice>[];
    state = state.copyWith(scanning: true, hotspot: hotspot, networkRequired: false, clearError: true, devices: previous);
    _sub = repo.discover(network: network).listen(
      (found) {
        if (run != _run) return;
        // Merge with earlier rounds so the list only grows while live.
        final byAddress = {for (final d in previous) d.address: d, for (final d in found) d.address: d};
        state = state.copyWith(devices: List.unmodifiable(byAddress.values));
      },
      onError: (Object e) {
        if (run == _run) state = state.copyWith(scanning: false, error: e.toString());
      },
      onDone: () {
        if (run != _run) return;
        state = state.copyWith(
          scanning: hotspot, // the hotspot keeps searching
          isolationSuspected: hotspot && state.devices.isEmpty && repo.unidentifiedClients > 0,
        );
        if (!hotspot) return;
        _rescan = Timer(hotspotRescanDelay, () async {
          if (run != _run || !ref.mounted) return;
          final net = await ref.read(networkProvider.notifier).refresh();
          if (run != _run) return;
          if (!net.ready) {
            state = DiscoveryState(devices: state.devices, networkRequired: true);
            return;
          }
          _discover(net, run, keep: true);
        });
      },
    );
  }

  void stop() {
    _run++;
    _cancel();
    state = state.copyWith(scanning: false);
  }
}

final discoveryProvider = NotifierProvider<DiscoveryController, DiscoveryState>(DiscoveryController.new);

class ConnectionController extends Notifier<CastConnection> {
  /// [CastConnection.error] value when Wi-Fi / hotspot dropped.
  static const networkLost = 'network-lost';

  @override
  CastConnection build() {
    // Network lost mid-session: show it clearly and keep the device so the
    // user can reconnect in one tap once Wi-Fi / hotspot is back.
    ref.listen(networkProvider, (prev, next) {
      if (next != null && !next.ready && state.isConnected) {
        state = CastConnection(status: ConnectionStatus.failed, device: state.device, error: networkLost);
      }
    });
    return const CastConnection();
  }

  Future<bool> connect(CastDevice device) async {
    // Ignore double taps / a second TV while one connection is in progress.
    if (state.isConnecting) return false;
    state = CastConnection(status: ConnectionStatus.connecting, device: device);
    final network = await ref.read(networkProvider.notifier).refresh();
    if (!network.ready) {
      state = CastConnection(status: ConnectionStatus.failed, device: device, error: networkLost);
      return false;
    }
    try {
      await ref.read(deviceRepositoryProvider).connect(device);
      // Pairing (code or Allow on TV) when the protocol asks for it; saved
      // credentials skip the sheet. Cancelled → back to not connected.
      if (!await ref.read(pairingProvider.notifier).pair(device)) {
        state = const CastConnection();
        return false;
      }
      state = CastConnection(status: ConnectionStatus.connected, device: device);
      ref.read(settingsProvider.notifier).rememberDevice(device.id);
      await ref.read(savedDevicesProvider).save(device.seenNow());
      return true;
    } catch (e) {
      state = CastConnection(status: ConnectionStatus.failed, device: device, error: e.toString());
      return false;
    }
  }

  /// "Forget device": drops saved pairing credentials and the saved TV, and
  /// disconnects if it is the current one.
  Future<void> forget(CastDevice device) async {
    if (state.device?.id == device.id) await disconnect();
    await ref.read(pairingProvider.notifier).forget(device.id);
    await ref.read(savedDevicesProvider).delete(device.id);
  }

  Future<void> disconnect() async {
    await ref.read(deviceRepositoryProvider).disconnect();
    state = const CastConnection();
  }

  /// Reconnects to the last used device when "Auto-connect" is enabled.
  Future<void> autoConnect() async {
    final s = ref.read(settingsProvider);
    if (!s.autoConnect || s.lastDeviceId == null || state.isConnected) return;
    final device = ref.read(savedDevicesProvider).findById(s.lastDeviceId!) ??
        await ref.read(deviceRepositoryProvider).findById(s.lastDeviceId!);
    if (device == null) return;
    // A TV that is off or gone shouldn't show an error on launch.
    if (!await connect(device)) state = const CastConnection();
  }
}

final connectionProvider = NotifierProvider<ConnectionController, CastConnection>(ConnectionController.new);
