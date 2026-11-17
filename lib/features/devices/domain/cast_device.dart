import 'network_status.dart';

import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

enum DeviceType {
  smartTv('Smart TV', Iconsax.monitor_copy),
  chromecast('Chromecast', Iconsax.screenmirroring_copy),
  fireTv('Fire TV', Iconsax.monitor_recorder_copy),
  roku('Roku', Iconsax.driver_copy),
  dlna('DLNA renderer', Iconsax.speaker_copy),
  miracast('Miracast', Iconsax.mirroring_screen_copy);

  const DeviceType(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// How a TV is actually controlled, found by asking the TV (open control
/// ports), never by guessing from its brand. Any brand that speaks one of these
/// works, listed or not.
enum RemoteProtocol {
  /// Roku External Control Protocol (HTTP 8060). Also TCL/Hisense/… Roku TVs.
  roku,

  /// Android TV / Google TV remote v2 (6466 / 6467). Also TCL, Sony, Xiaomi, Philips…
  androidTv,

  /// Samsung Tizen remote WebSocket (8001 / 8002).
  samsung,

  /// LG webOS SSAP WebSocket (3000 / 3001).
  lg,

  /// Only a UPnP/DLNA media renderer was found: transport and volume, no keys.
  dlna,
}

@immutable
class CastDevice {
  const CastDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    this.port,
    this.model,
    this.signal = 1,
    this.lastSeen,
    this.protocol,
    this.location,
  });

  final String id;
  final String name;
  final DeviceType type;
  final String address;
  final int? port;
  final String? model;

  /// Wi-Fi signal strength 0..1.
  final double signal;
  final DateTime? lastSeen;

  /// Detected control protocol; null until the TV has been probed.
  final RemoteProtocol? protocol;

  /// UPnP device-description URL (from SSDP); the DLNA backend finds the
  /// renderer's control URLs from it.
  final String? location;

  CastDevice copyWith({DeviceType? type, RemoteProtocol? protocol, String? location}) => CastDevice(
    id: id,
    name: name,
    type: type ?? this.type,
    address: address,
    port: port,
    model: model,
    signal: signal,
    lastSeen: lastSeen,
    protocol: protocol ?? this.protocol,
    location: location ?? this.location,
  );

  CastDevice seenNow() => CastDevice(
    id: id,
    name: name,
    type: type,
    address: address,
    port: port,
    model: model,
    signal: signal,
    lastSeen: DateTime.now(),
    protocol: protocol,
    location: location,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'type': type.name,
    'address': address,
    'port': port,
    'model': model,
    'lastSeen': lastSeen?.millisecondsSinceEpoch,
    'protocol': protocol?.name,
    'location': location,
  };

  factory CastDevice.fromMap(Map m) => CastDevice(
    id: m['id'] as String,
    name: m['name'] as String,
    type: DeviceType.values.asNameMap()[m['type']] ?? DeviceType.smartTv,
    address: m['address'] as String,
    port: m['port'] as int?,
    model: m['model'] as String?,
    lastSeen: m['lastSeen'] == null ? null : DateTime.fromMillisecondsSinceEpoch(m['lastSeen'] as int),
    protocol: RemoteProtocol.values.asNameMap()[m['protocol']],
    location: m['location'] as String?,
  );

  @override
  bool operator ==(Object other) => other is CastDevice && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

enum ConnectionStatus { disconnected, connecting, connected, failed }

@immutable
class CastConnection {
  const CastConnection({this.status = ConnectionStatus.disconnected, this.device, this.error});

  final ConnectionStatus status;
  final CastDevice? device;
  final String? error;

  bool get isConnected => status == ConnectionStatus.connected && device != null;
  bool get isConnecting => status == ConnectionStatus.connecting;
}

/// The specific stage of the device discovery lifecycle.
enum DiscoveryPhase {
  /// Screen opened, not yet initiated.
  initial,

  /// Location / Nearby Wi-Fi permission is required before starting.
  permissionRequired,

  /// Permission was denied by the user.
  permissionDenied,

  /// Permission was permanently denied; requires app settings.
  permissionPermanentlyDenied,

  /// Required location services (GPS toggle) are disabled on the system.
  locationServicesDisabled,

  /// Checking Wi-Fi / hotspot readiness.
  checkingConnectivity,

  /// Actively probing local network for receivers.
  searching,

  /// At least one device found.
  devicesFound,

  /// Scan completed without finding any devices.
  noDevicesFound,

  /// Scan failed with an error.
  failed,

  /// Scan was explicitly stopped by user.
  stopped,
}

@immutable
class DiscoveryState {
  const DiscoveryState({
    this.phase = DiscoveryPhase.initial,
    bool? scanning,
    this.devices = const [],
    this.error,
    this.networkRequired = false,
    this.hotspot = false,
    this.isolationSuspected = false,
    this.requiresLocation = false,
  }) : _scanningExplicit = scanning;

  final DiscoveryPhase phase;
  final bool? _scanningExplicit;
  final List<CastDevice> devices;
  final String? error;

  /// True when actively searching or checking connectivity.
  bool get scanning =>
      _scanningExplicit ?? (phase == DiscoveryPhase.searching || phase == DiscoveryPhase.checkingConnectivity);

  /// Neither Wi-Fi nor the phone's hotspot is on, so nothing can be found.
  final bool networkRequired;

  /// Discovery is running on the phone's own hotspot (live, repeating).
  final bool hotspot;

  /// Clients joined the hotspot but none answered: the hotspot may block
  /// device-to-device traffic ("client isolation").
  final bool isolationSuspected;

  /// Whether location permission specifically is required by the OS version.
  final bool requiresLocation;

  DiscoveryState copyWith({
    DiscoveryPhase? phase,
    bool? scanning,
    List<CastDevice>? devices,
    String? error,
    bool clearError = false,
    bool? networkRequired,
    bool? hotspot,
    bool? isolationSuspected,
    bool? requiresLocation,
  }) {
    return DiscoveryState(
      phase: phase ?? this.phase,
      scanning: scanning ?? _scanningExplicit,
      devices: devices ?? this.devices,
      error: clearError ? null : (error ?? this.error),
      networkRequired: networkRequired ?? this.networkRequired,
      hotspot: hotspot ?? this.hotspot,
      isolationSuspected: isolationSuspected ?? this.isolationSuspected,
      requiresLocation: requiresLocation ?? this.requiresLocation,
    );
  }
}

/// Receivers the user has connected to before (for auto-connect).
abstract interface class SavedDevicesRepository {
  List<CastDevice> all();
  CastDevice? findById(String id);
  Future<void> save(CastDevice device);
  Future<void> delete(String id);
}

/// Abstraction over mDNS / SSDP / Google Cast discovery and session control.
abstract interface class DeviceRepository {
  /// Emits the growing list of devices found on the local network.
  Stream<List<CastDevice>> discover({NetworkStatus? network});

  /// Hotspot clients from the last scan that answered nothing a TV would
  /// (a sign of client isolation when no TV was found).
  int get unidentifiedClients;

  /// Looks up a previously seen device (used for auto-connect).
  Future<CastDevice?> findById(String id);

  Future<void> connect(CastDevice device);

  /// Asks the receiver which control protocol it speaks and returns the device
  /// tagged with it (and a corrected type). Never throws; on any failure the
  /// device comes back unchanged.
  Future<CastDevice> identify(CastDevice device);

  Future<void> disconnect();
}
