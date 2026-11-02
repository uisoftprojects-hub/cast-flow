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

  CastDevice seenNow() => CastDevice(
        id: id,
        name: name,
        type: type,
        address: address,
        port: port,
        model: model,
        signal: signal,
        lastSeen: DateTime.now(),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'type': type.name,
        'address': address,
        'port': port,
        'model': model,
        'lastSeen': lastSeen?.millisecondsSinceEpoch,
      };

  factory CastDevice.fromMap(Map m) => CastDevice(
        id: m['id'] as String,
        name: m['name'] as String,
        type: DeviceType.values.asNameMap()[m['type']] ?? DeviceType.smartTv,
        address: m['address'] as String,
        port: m['port'] as int?,
        model: m['model'] as String?,
        lastSeen: m['lastSeen'] == null ? null : DateTime.fromMillisecondsSinceEpoch(m['lastSeen'] as int),
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

@immutable
class DiscoveryState {
  const DiscoveryState({
    this.scanning = false,
    this.devices = const [],
    this.error,
    this.networkRequired = false,
    this.hotspot = false,
    this.isolationSuspected = false,
  });

  final bool scanning;
  final List<CastDevice> devices;
  final String? error;

  /// Neither Wi-Fi nor the phone's hotspot is on, so nothing can be found.
  final bool networkRequired;

  /// Discovery is running on the phone's own hotspot (live, repeating).
  final bool hotspot;

  /// Clients joined the hotspot but none answered: the hotspot may block
  /// device-to-device traffic ("client isolation").
  final bool isolationSuspected;

  DiscoveryState copyWith({
    bool? scanning,
    List<CastDevice>? devices,
    String? error,
    bool clearError = false,
    bool? networkRequired,
    bool? hotspot,
    bool? isolationSuspected,
  }) {
    return DiscoveryState(
      scanning: scanning ?? this.scanning,
      devices: devices ?? this.devices,
      error: clearError ? null : (error ?? this.error),
      networkRequired: networkRequired ?? this.networkRequired,
      hotspot: hotspot ?? this.hotspot,
      isolationSuspected: isolationSuspected ?? this.isolationSuspected,
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

  Future<void> disconnect();
}
