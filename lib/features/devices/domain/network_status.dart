import 'package:flutter/foundation.dart';

enum NetworkMode { none, wifi, hotspot }

/// Whether the phone can reach TVs: on Wi-Fi, or sharing its own hotspot.
@immutable
class NetworkStatus {
  const NetworkStatus({
    this.wifi = false,
    this.hotspot = false,
    this.hotspotIp,
    this.hotspotInterface,
    this.vpn = false,
  });

  final bool wifi;
  final bool hotspot;

  /// Our address on the hotspot network (usually 192.168.43.1).
  final String? hotspotIp;
  final String? hotspotInterface;

  /// A VPN is on (it usually hides TVs from the phone).
  final bool vpn;

  bool get ready => wifi || hotspot;

  /// Wi-Fi wins when both are up: TVs are most likely on the router.
  NetworkMode get mode => wifi ? NetworkMode.wifi : (hotspot ? NetworkMode.hotspot : NetworkMode.none);

  factory NetworkStatus.fromMap(Map<String, Object?> m) => NetworkStatus(
    wifi: m['wifi'] == true,
    hotspot: m['hotspot'] == true,
    hotspotIp: m['hotspotIp'] as String?,
    hotspotInterface: m['hotspotInterface'] as String?,
    vpn: m['vpn'] == true,
  );

  @override
  bool operator ==(Object other) =>
      other is NetworkStatus &&
      other.wifi == wifi &&
      other.hotspot == hotspot &&
      other.hotspotIp == hotspotIp &&
      other.vpn == vpn;

  @override
  int get hashCode => Object.hash(wifi, hotspot, hotspotIp, vpn);
}
