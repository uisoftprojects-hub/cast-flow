import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/storage/local_store.dart';
import '../../monetization/domain/ad_suppression.dart';
import '../../pairing/presentation/pairing_controller.dart';
import '../../permissions/domain/app_permission.dart';
import '../../permissions/presentation/permissions_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/hive_saved_devices_repository.dart';
import '../data/network_device_repository.dart';
import '../domain/cast_device.dart';
import '../domain/network_status.dart';
import 'network_controller.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) => NetworkDeviceRepository());

final savedDevicesProvider = Provider<SavedDevicesRepository>(
  (ref) => HiveSavedDevicesRepository(ref.watch(localStoreProvider).devices),
);

/// Nearby Wi-Fi permission check/request hook for backward compatibility in tests.
final nearbyPermissionProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await AdSuppression.around(() => Permission.nearbyWifiDevices.request());
    } catch (_) {}
  },
);

/// Resolves duplicate devices across multiple discovery protocols (mDNS, SSDP, subnet scan).
CastDevice mergeCastDevices(CastDevice existing, CastDevice incoming) {
  final bestName = (existing.name.isNotEmpty && !existing.name.startsWith('TV ')) ? existing.name : incoming.name;
  final bestType = existing.type != DeviceType.smartTv ? existing.type : incoming.type;
  final bestModel = existing.model ?? incoming.model;
  final bestPort = existing.port ?? incoming.port;
  final bestLastSeen = (existing.lastSeen != null && incoming.lastSeen != null)
      ? (incoming.lastSeen!.isAfter(existing.lastSeen!) ? incoming.lastSeen : existing.lastSeen)
      : (incoming.lastSeen ?? existing.lastSeen);

  return CastDevice(
    id: existing.id.isNotEmpty ? existing.id : incoming.id,
    name: bestName,
    type: bestType,
    address: existing.address.isNotEmpty ? existing.address : incoming.address,
    port: bestPort,
    model: bestModel,
    signal: incoming.signal > 0 ? incoming.signal : existing.signal,
    lastSeen: bestLastSeen,
    protocol: existing.protocol ?? incoming.protocol,
    location: existing.location ?? incoming.location,
  );
}

/// Runs discovery as a background stream with robust permission lifecycle management:
/// - Enforces Scenario A-E location and nearby permission checks before starting discovery
/// - Handles Android 12- location requirements vs Android 13+ nearby permissions
/// - Automatically restarts on lifecycle resume or system setting changes
/// - Guarantees accurate UI discovery phases (13 states)
/// - Deduplicates across protocols and enforces discovery timeouts
class DiscoveryController extends Notifier<DiscoveryState> {
  StreamSubscription<List<CastDevice>>? _sub;
  Timer? _rescan;
  Timer? _sessionTimeout;
  int _run = 0;

  static const hotspotRescanDelay = Duration(seconds: 4);

  @override
  DiscoveryState build() {
    ref.onDispose(_cancel);
    ref.listen(networkProvider, (prev, next) {
      if (next != null && next.ready && state.networkRequired) scan();
      if (next != null && !next.ready && (state.scanning || state.hotspot)) {
        _run++;
        _cancel();
        state = DiscoveryState(phase: DiscoveryPhase.failed, devices: state.devices, networkRequired: true);
      }
    });
    return const DiscoveryState();
  }

  void _cancel() {
    _sub?.cancel();
    _sub = null;
    _rescan?.cancel();
    _rescan = null;
    _sessionTimeout?.cancel();
    _sessionTimeout = null;
  }

  /// Evaluates permissions and system services before beginning discovery.
  /// If permissions are already granted, immediately begins discovery.
  /// If not, transitions to [DiscoveryPhase.permissionRequired] with explanations.
  Future<void> checkPermissionsAndStart({bool userInitiatedRequest = false}) async {
    _cancel();
    final run = ++_run;
    state = state.copyWith(
      phase: DiscoveryPhase.checkingConnectivity,
      scanning: true,
      devices: state.hotspot ? state.devices : const [],
    );
    final permService = ref.read(discoveryPermissionServiceProvider);
    final requiresLocation = await permService.isLocationRequired();
    if (run != _run || !ref.mounted) return;

    final status = await permService.checkStatus();
    if (run != _run || !ref.mounted) return;

    switch (status) {
      case DiscoveryPermissionStatus.granted:
        await _proceedToConnectivityAndScan(run, requiresLocation);
      case DiscoveryPermissionStatus.locationServiceDisabled:
        state = DiscoveryState(
          phase: DiscoveryPhase.locationServicesDisabled,
          requiresLocation: true,
          devices: state.devices,
        );
      case DiscoveryPermissionStatus.permanentlyDenied:
        state = DiscoveryState(
          phase: DiscoveryPhase.permissionPermanentlyDenied,
          requiresLocation: requiresLocation,
          devices: state.devices,
        );
      case DiscoveryPermissionStatus.denied:
      case DiscoveryPermissionStatus.notDetermined:
        if (userInitiatedRequest) {
          await grantPermission();
        } else {
          state = DiscoveryState(
            phase: DiscoveryPhase.permissionRequired,
            requiresLocation: requiresLocation,
            devices: state.devices,
          );
        }
    }
  }

  /// Triggers the native runtime permission request following user tap.
  Future<void> grantPermission() async {
    _cancel();
    final run = ++_run;
    state = state.copyWith(
      phase: DiscoveryPhase.checkingConnectivity,
      scanning: true,
      devices: state.hotspot ? state.devices : const [],
    );
    final permService = ref.read(discoveryPermissionServiceProvider);
    final requiresLocation = await permService.isLocationRequired();
    if (run != _run || !ref.mounted) return;

    final result = await permService.requestPermission();
    if (run != _run || !ref.mounted) return;

    switch (result) {
      case DiscoveryPermissionStatus.granted:
        await _proceedToConnectivityAndScan(run, requiresLocation);
      case DiscoveryPermissionStatus.locationServiceDisabled:
        state = DiscoveryState(
          phase: DiscoveryPhase.locationServicesDisabled,
          requiresLocation: true,
          devices: state.devices,
        );
      case DiscoveryPermissionStatus.permanentlyDenied:
        state = DiscoveryState(
          phase: DiscoveryPhase.permissionPermanentlyDenied,
          requiresLocation: requiresLocation,
          devices: state.devices,
        );
      case DiscoveryPermissionStatus.denied:
      case DiscoveryPermissionStatus.notDetermined:
        state = DiscoveryState(
          phase: DiscoveryPhase.permissionDenied,
          requiresLocation: requiresLocation,
          devices: state.devices,
        );
    }
  }

  /// Called when returning to the app (e.g. from app settings or location settings).
  Future<void> recheckPermissions() async {
    // The system permission dialog pauses/resumes the app, which fires this while
    // the request that opened it is still running. Re-checking then restarts the
    // scan mid-flight and makes the screen flicker between states.
    if (state.phase == DiscoveryPhase.checkingConnectivity) return;
    final permService = ref.read(discoveryPermissionServiceProvider);
    final status = await permService.checkStatus();
    if (!ref.mounted) return;
    final requiresLocation = await permService.isLocationRequired();
    if (!ref.mounted) return;

    if (status == DiscoveryPermissionStatus.granted) {
      // Already searching or showing devices: nothing to restart.
      if (state.scanning || state.devices.isNotEmpty) return;
      final run = ++_run;
      await _proceedToConnectivityAndScan(run, requiresLocation);
    } else if (status == DiscoveryPermissionStatus.locationServiceDisabled) {
      state = state.copyWith(phase: DiscoveryPhase.locationServicesDisabled, requiresLocation: true);
    } else if (status == DiscoveryPermissionStatus.permanentlyDenied) {
      state = state.copyWith(phase: DiscoveryPhase.permissionPermanentlyDenied, requiresLocation: requiresLocation);
    }
  }

  Future<void> openSettings() async {
    await ref.read(discoveryPermissionServiceProvider).openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await ref.read(discoveryPermissionServiceProvider).openLocationSettings();
  }

  /// Standard scan entrypoint; checks permissions first.
  Future<void> scan() async {
    await grantPermission();
  }

  Future<void> _proceedToConnectivityAndScan(int run, bool requiresLocation) async {
    if (run != _run || !ref.mounted) return;
    state = DiscoveryState(
      phase: DiscoveryPhase.checkingConnectivity,
      scanning: true,
      hotspot: state.hotspot,
      requiresLocation: requiresLocation,
      devices: state.hotspot ? state.devices : const [],
    );

    final network = await ref.read(networkProvider.notifier).refresh();
    if (run != _run || !ref.mounted) return;

    if (!network.ready) {
      ref.read(analyticsProvider).log(AnalyticsEvent.networkNoWifi, {AnalyticsParam.source: 'device_scan'});
      state = DiscoveryState(
        phase: DiscoveryPhase.failed,
        networkRequired: true,
        requiresLocation: requiresLocation,
        devices: state.devices,
      );
      return;
    }

    // Call legacy hook if present in test environment.
    await ref.read(nearbyPermissionProvider)();
    if (run != _run || !ref.mounted) return;

    _discover(network, run, requiresLocation: requiresLocation, keep: false);
  }

  void _discover(NetworkStatus network, int run, {required bool requiresLocation, required bool keep}) {
    final hotspot = network.mode == NetworkMode.hotspot;
    final repo = ref.read(deviceRepositoryProvider);
    final previous = keep ? state.devices : const <CastDevice>[];

    state = state.copyWith(
      phase: DiscoveryPhase.searching,
      scanning: true,
      hotspot: hotspot,
      networkRequired: false,
      clearError: true,
      requiresLocation: requiresLocation,
      devices: previous,
    );

    // Discovery timeout (12s): transitions to noDevicesFound if no devices discovered
    _sessionTimeout = Timer(const Duration(seconds: 12), () {
      if (run != _run || !ref.mounted) return;
      if (state.devices.isEmpty && state.scanning) {
        state = state.copyWith(phase: DiscoveryPhase.noDevicesFound, scanning: false);
      }
    });

    _sub = repo
        .discover(network: network)
        .listen(
          (found) {
            if (run != _run || !ref.mounted) return;
            // Clean composite deduplication
            final map = <String, CastDevice>{};
            for (final d in state.devices) {
              final key = d.address.isNotEmpty ? d.address : d.id;
              map[key] = d;
            }
            for (final d in found) {
              final key = d.address.isNotEmpty ? d.address : d.id;
              if (map.containsKey(key)) {
                map[key] = mergeCastDevices(map[key]!, d);
              } else {
                map[key] = d;
              }
            }
            final list = List<CastDevice>.unmodifiable(map.values);
            state = state.copyWith(devices: list, phase: list.isNotEmpty ? DiscoveryPhase.devicesFound : state.phase);
          },
          onError: (Object e) {
            if (run == _run && ref.mounted) {
              _sessionTimeout?.cancel();
              state = state.copyWith(phase: DiscoveryPhase.failed, scanning: false, error: e.toString());
            }
          },
          onDone: () {
            if (run != _run || !ref.mounted) return;
            _sessionTimeout?.cancel();
            if (!keep) {
              final count = state.devices.length;
              if (count == 0) {
                ref.read(analyticsProvider).log(AnalyticsEvent.deviceNoneFound, {
                  AnalyticsParam.networkMode: network.mode,
                });
              }
            }

            final nextPhase = state.devices.isEmpty ? DiscoveryPhase.noDevicesFound : DiscoveryPhase.devicesFound;
            state = state.copyWith(
              phase: hotspot ? DiscoveryPhase.searching : nextPhase,
              scanning: hotspot, // the hotspot keeps searching
              isolationSuspected: hotspot && state.devices.isEmpty && repo.unidentifiedClients > 0,
            );

            if (!hotspot) return;
            _rescan = Timer(hotspotRescanDelay, () async {
              if (run != _run || !ref.mounted) return;
              final net = await ref.read(networkProvider.notifier).refresh();
              if (run != _run || !ref.mounted) return;
              if (!net.ready) {
                state = DiscoveryState(
                  phase: DiscoveryPhase.failed,
                  devices: state.devices,
                  networkRequired: true,
                  requiresLocation: requiresLocation,
                );
                return;
              }
              _discover(net, run, requiresLocation: requiresLocation, keep: true);
            });
          },
        );
  }

  void stop() {
    _run++;
    _cancel();
    state = state.copyWith(phase: DiscoveryPhase.stopped, scanning: false);
  }
}

final discoveryProvider = NotifierProvider<DiscoveryController, DiscoveryState>(DiscoveryController.new);

class ConnectionController extends Notifier<CastConnection> {
  static const networkLost = 'network-lost';

  @override
  CastConnection build() {
    ref.listen(networkProvider, (prev, next) {
      if (next != null && !next.ready && state.isConnected) {
        state = CastConnection(status: ConnectionStatus.failed, device: state.device, error: networkLost);
      }
    });
    return const CastConnection();
  }

  Analytics get _analytics => ref.read(analyticsProvider);

  void _connectFailed(CastDevice device, String reason) => _analytics.log(AnalyticsEvent.deviceConnectFail, {
    AnalyticsParam.deviceType: device.type,
    AnalyticsParam.reason: reason,
  });

  Future<bool> connect(CastDevice device) async {
    // Ignore double taps / duplicate connection requests while in progress
    if (state.isConnecting) return false;

    // Cleanly switch if already connected to a different device
    if (state.isConnected && state.device?.id != device.id) {
      await disconnect();
    }

    state = CastConnection(status: ConnectionStatus.connecting, device: device);
    final network = await ref.read(networkProvider.notifier).refresh();
    if (!network.ready) {
      state = CastConnection(status: ConnectionStatus.failed, device: device, error: networkLost);
      _connectFailed(device, networkLost);
      return false;
    }

    try {
      final repo = ref.read(deviceRepositoryProvider);
      await repo.connect(device);
      // Ask the TV how it is controlled, so any brand works (not just listed ones).
      device = await repo.identify(device);
      // Pairing flow
      if (!await ref.read(pairingProvider.notifier).pair(device)) {
        state = const CastConnection();
        _connectFailed(device, 'pairing_cancelled');
        return false;
      }
      state = CastConnection(status: ConnectionStatus.connected, device: device);
      _analytics.log(AnalyticsEvent.deviceConnectSuccess, {AnalyticsParam.deviceType: device.type});
      ref.read(settingsProvider.notifier).rememberDevice(device.id);
      await ref.read(savedDevicesProvider).save(device.seenNow());
      return true;
    } catch (e) {
      state = CastConnection(status: ConnectionStatus.failed, device: device, error: e.toString());
      _connectFailed(device, e.toString());
      return false;
    }
  }

  /// Replaces the connected device with a better-identified copy of itself
  /// (e.g. a DLNA-only smart TV that has just proved it takes Android TV keys).
  void adopt(CastDevice better) {
    if (state.isConnected && state.device?.id == better.id) {
      state = CastConnection(status: ConnectionStatus.connected, device: better);
    }
  }

  Future<void> forget(CastDevice device) async {
    if (state.device?.id == device.id) await disconnect();
    await ref.read(pairingProvider.notifier).forget(device.id);
    await ref.read(savedDevicesProvider).delete(device.id);
  }

  /// Forgets an old failed attempt so a fresh scan starts from a clean screen.
  void clearFailure() {
    if (state.status == ConnectionStatus.failed) state = const CastConnection();
  }

  Future<void> disconnect() async {
    await ref.read(deviceRepositoryProvider).disconnect();
    state = const CastConnection();
  }

  Future<void> autoConnect() async {
    final s = ref.read(settingsProvider);
    if (!s.autoConnect || s.lastDeviceId == null || state.isConnected) return;
    final device =
        ref.read(savedDevicesProvider).findById(s.lastDeviceId!) ??
        await ref.read(deviceRepositoryProvider).findById(s.lastDeviceId!);
    if (device == null) return;
    if (!await connect(device)) state = const CastConnection();
  }
}

final connectionProvider = NotifierProvider<ConnectionController, CastConnection>(ConnectionController.new);
