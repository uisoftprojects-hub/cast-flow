import 'package:flutter/foundation.dart';

enum NetworkMode { none, wifi, hotspot }

/// One local network the phone is on: our IPv4 address and the subnet size.
@immutable
class LanAddress {
  const LanAddress(this.ip, {this.prefix = 24, this.interface});

  final String ip;

  /// Prefix length of the subnet (24 for 255.255.255.0).
  final int prefix;
  final String? interface;

  static int? _toInt(String ip) {
    final p = ip.split('.').map(int.tryParse).toList();
    if (p.length != 4 || p.any((b) => b == null || b < 0 || b > 255)) return null;
    return (p[0]! << 24) | (p[1]! << 16) | (p[2]! << 8) | p[3]!;
  }

  /// Whether [host] is on this subnet (so the TV can reach [ip] directly).
  bool contains(String host) {
    final a = _toInt(ip), b = _toInt(host);
    if (a == null || b == null) return false;
    final bits = prefix.clamp(8, 32);
    final mask = bits == 32 ? 0xFFFFFFFF : (0xFFFFFFFF << (32 - bits)) & 0xFFFFFFFF;
    return (a & mask) == (b & mask);
  }

  @override
  bool operator ==(Object other) =>
      other is LanAddress && other.ip == ip && other.prefix == prefix && other.interface == interface;

  @override
  int get hashCode => Object.hash(ip, prefix, interface);

  @override
  String toString() => '$ip/$prefix${interface == null ? '' : ' ($interface)'}';
}

/// Whether the phone can reach TVs: on Wi-Fi, or sharing its own hotspot.
@immutable
class NetworkStatus {
  const NetworkStatus({
    this.wifi = false,
    this.hotspot = false,
    this.hotspotIp,
    this.hotspotInterface,
    this.hotspotPrefix,
    this.wifiIp,
    this.wifiInterface,
    this.wifiPrefix,
    this.vpn = false,
    this.internet = true,
  });

  final bool wifi;
  final bool hotspot;

  /// Our address on the hotspot network (e.g. 192.168.43.1; random subnets on
  /// Android 11+).
  final String? hotspotIp;
  final String? hotspotInterface;
  final int? hotspotPrefix;

  /// Our address on the Wi-Fi we joined (the station side, e.g. wlan0).
  final String? wifiIp;
  final String? wifiInterface;
  final int? wifiPrefix;

  /// A VPN is on (it usually hides TVs from the phone).
  final bool vpn;

  /// The phone can reach the internet (store, ads), by any network. Unknown
  /// platforms report true.
  final bool internet;

  bool get ready => wifi || hotspot;

  /// Wi-Fi wins when both are up: TVs are most likely on the router.
  NetworkMode get mode => wifi ? NetworkMode.wifi : (hotspot ? NetworkMode.hotspot : NetworkMode.none);

  LanAddress? get wifiAddress =>
      wifiIp == null ? null : LanAddress(wifiIp!, prefix: wifiPrefix ?? 24, interface: wifiInterface);

  LanAddress? get hotspotAddress =>
      hotspotIp == null ? null : LanAddress(hotspotIp!, prefix: hotspotPrefix ?? 24, interface: hotspotInterface);

  /// The address discovery should send multicast from in the current mode.
  LanAddress? get discoveryAddress => mode == NetworkMode.hotspot ? hotspotAddress : wifiAddress;

  /// Our address as the TV at [tvHost] sees it: the network that contains the
  /// TV, otherwise the one we are casting over (hotspot when it is the only
  /// network, Wi-Fi otherwise). Never a mobile-data or VPN address.
  String? addressFor(String tvHost) {
    for (final a in [wifiAddress, hotspotAddress]) {
      if (a != null && a.contains(tvHost)) return a.ip;
    }
    return switch (mode) {
      NetworkMode.hotspot => hotspotIp,
      NetworkMode.wifi => wifiIp ?? hotspotIp,
      NetworkMode.none => null,
    };
  }

  factory NetworkStatus.fromMap(Map<String, Object?> m) => NetworkStatus(
    wifi: m['wifi'] == true,
    hotspot: m['hotspot'] == true,
    hotspotIp: m['hotspotIp'] as String?,
    hotspotInterface: m['hotspotInterface'] as String?,
    hotspotPrefix: (m['hotspotPrefix'] as num?)?.toInt(),
    wifiIp: m['wifiIp'] as String?,
    wifiInterface: m['wifiInterface'] as String?,
    wifiPrefix: (m['wifiPrefix'] as num?)?.toInt(),
    vpn: m['vpn'] == true,
    internet: m['internet'] != false,
  );

  @override
  bool operator ==(Object other) =>
      other is NetworkStatus &&
      other.wifi == wifi &&
      other.hotspot == hotspot &&
      other.hotspotIp == hotspotIp &&
      other.hotspotInterface == hotspotInterface &&
      other.hotspotPrefix == hotspotPrefix &&
      other.wifiIp == wifiIp &&
      other.wifiPrefix == wifiPrefix &&
      other.vpn == vpn &&
      other.internet == internet;

  @override
  int get hashCode =>
      Object.hash(wifi, hotspot, hotspotIp, hotspotInterface, hotspotPrefix, wifiIp, wifiPrefix, vpn, internet);
}
