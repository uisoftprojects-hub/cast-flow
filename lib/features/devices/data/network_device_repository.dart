import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:multicast_dns/multicast_dns.dart';
import 'package:xml/xml.dart';

import '../../../core/platform/network_channel.dart';
import '../domain/cast_device.dart';
import '../domain/network_status.dart';

/// Finds real receivers on the local Wi-Fi:
/// - SSDP (UPnP): DLNA media renderers, Roku (ECP) and DIAL TVs
///   (Samsung, LG, Fire TV, Android TV…).
/// - mDNS: Google Cast devices and Android TVs.
class NetworkDeviceRepository implements DeviceRepository {
  NetworkDeviceRepository({this.scanTime = const Duration(seconds: 8)});

  final Duration scanTime;

  static const _ssdpTargets = [
    'urn:schemas-upnp-org:device:MediaRenderer:1',
    'urn:dial-multiscreen-org:service:dial:1',
    'roku:ecp',
  ];

  static const _mdnsServices = {
    '_googlecast._tcp.local': DeviceType.chromecast,
    '_androidtvremote2._tcp.local': DeviceType.smartTv,
  };

  @override
  int unidentifiedClients = 0;

  @override
  Stream<List<CastDevice>> discover({NetworkStatus? network}) {
    final out = StreamController<List<CastDevice>>();
    // On the phone's own hotspot, bind to the AP interface so multicast goes
    // to the TVs that joined it, and probe the hotspot subnet as a fallback.
    final hotspotIp = network?.mode == NetworkMode.hotspot ? network?.hotspotIp : null;
    unidentifiedClients = 0;
    final found = <String, CastDevice>{};
    // Same TV can answer over several protocols; key by address.
    void add(CastDevice d) {
      final existing = found[d.address];
      // Prefer the more specific type (e.g. Roku over generic DLNA).
      if (existing == null || existing.type == DeviceType.dlna) {
        found[d.address] = d;
        if (!out.isClosed) out.add(List.unmodifiable(found.values));
      }
    }

    () async {
      if (network != null ? !network.ready : !await _onWifi()) {
        out.addError(const SocketException('Not connected to Wi-Fi'));
        await out.close();
        return;
      }
      await NetworkChannel.acquireMulticastLock();
      try {
        await Future.wait([
          _ssdp(add, bindTo: hotspotIp).catchError((_) {}),
          _mdns(add, interfaceIp: hotspotIp).catchError((_) {}),
          if (hotspotIp != null) _scanSubnet(hotspotIp, add).catchError((_) {}),
        ]).timeout(scanTime + const Duration(seconds: 4), onTimeout: () => []);
      } finally {
        await NetworkChannel.releaseMulticastLock();
        if (!out.isClosed) {
          if (found.isEmpty) out.add(const []);
          await out.close();
        }
      }
    }();
    return out.stream;
  }

  Future<bool> _onWifi() async {
    try {
      final ifaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      return ifaces.any((i) => i.addresses.any((a) => !a.isLoopback && a.isPrivateLan));
    } catch (_) {
      return false;
    }
  }

  // ------------------------------------------------------------------ SSDP

  Future<void> _ssdp(void Function(CastDevice) add, {String? bindTo}) async {
    final socket = await RawDatagramSocket.bind(bindTo != null ? InternetAddress(bindTo) : InternetAddress.anyIPv4, 0);
    socket.multicastHops = 4;
    final seen = <String>{};
    final lookups = <Future<void>>[];

    socket.listen((event) {
      if (event != RawSocketEvent.read) return;
      final dg = socket.receive();
      if (dg == null) return;
      final headers = _headers(utf8.decode(dg.data, allowMalformed: true));
      final location = headers['location'];
      if (location == null || !seen.add(location)) return;
      lookups.add(
        _describe(location, headers)
            .then((d) {
              if (d != null) add(d);
            })
            .catchError((_) {}),
      );
    });

    final group = InternetAddress('239.255.255.250');
    for (var round = 0; round < 3; round++) {
      for (final st in _ssdpTargets) {
        final msg =
            'M-SEARCH * HTTP/1.1\r\n'
            'HOST: 239.255.255.250:1900\r\n'
            'MAN: "ssdp:discover"\r\n'
            'MX: 2\r\n'
            'ST: $st\r\n\r\n';
        socket.send(utf8.encode(msg), group, 1900);
      }
      await Future<void>.delayed(const Duration(milliseconds: 900));
    }
    await Future<void>.delayed(scanTime - const Duration(milliseconds: 2700));
    socket.close();
    await Future.wait(lookups);
  }

  Map<String, String> _headers(String response) {
    final map = <String, String>{};
    for (final line in const LineSplitter().convert(response)) {
      final i = line.indexOf(':');
      if (i > 0) map[line.substring(0, i).trim().toLowerCase()] = line.substring(i + 1).trim();
    }
    return map;
  }

  /// Reads the UPnP description to get the TV's real name and brand.
  Future<CastDevice?> _describe(String location, Map<String, String> headers) async {
    final uri = Uri.parse(location);
    final res = await http.get(uri).timeout(const Duration(seconds: 3));
    if (res.statusCode != 200) return null;
    final doc = XmlDocument.parse(utf8.decode(res.bodyBytes, allowMalformed: true));
    String text(String tag) => doc.findAllElements(tag).firstOrNull?.innerText.trim() ?? '';

    final name = text('friendlyName');
    final manufacturer = text('manufacturer');
    final model = text('modelName');
    final deviceType = text('deviceType');
    final udn = text('UDN');
    final st = headers['st'] ?? '';
    final m = manufacturer.toLowerCase();

    final DeviceType type;
    if (st.contains('roku') || m.contains('roku')) {
      type = DeviceType.roku;
    } else if (m.contains('amazon') || model.startsWith('AFT')) {
      type = DeviceType.fireTv;
    } else if (m.contains('google') && st.contains('dial')) {
      type = DeviceType.chromecast;
    } else if (st.contains('dial') ||
        [
          'samsung',
          'lg ',
          'lg electronics',
          'sony',
          'tcl',
          'hisense',
          'philips',
          'vizio',
          'panasonic',
          'sharp',
          'xiaomi',
        ].any(m.contains)) {
      type = DeviceType.smartTv;
    } else if (deviceType.contains('MediaRenderer')) {
      type = DeviceType.dlna;
    } else {
      return null;
    }

    return CastDevice(
      id: udn.isNotEmpty ? udn : (headers['usn'] ?? location),
      name: name.isNotEmpty ? name : (model.isNotEmpty ? model : uri.host),
      type: type,
      address: uri.host,
      port: uri.port,
      model: [manufacturer, model].where((s) => s.isNotEmpty).join(' '),
    );
  }

  // ------------------------------------------------------------------ mDNS

  Future<void> _mdns(void Function(CastDevice) add, {String? interfaceIp}) async {
    final client = MDnsClient(
      // Android doesn't support SO_REUSEPORT on these sockets.
      rawDatagramSocketFactory: (
        dynamic host,
        int port, {
        bool reuseAddress = true,
        bool reusePort = false,
        int ttl = 1,
      }) => RawDatagramSocket.bind(host, port, reuseAddress: true, reusePort: false, ttl: ttl),
    );
    await client.start(
      // On the hotspot, query only on the AP interface.
      interfacesFactory: interfaceIp == null
          ? null
          : (type) async =>
                (await NetworkInterface.list(type: InternetAddressType.IPv4))
                    .where((i) => i.addresses.any((a) => a.address == interfaceIp))
                    .toList(),
    );
    try {
      for (final entry in _mdnsServices.entries) {
        final ptrs = await client
            .lookup<PtrResourceRecord>(
              ResourceRecordQuery.serverPointer(entry.key),
              timeout: Duration(milliseconds: scanTime.inMilliseconds ~/ 2),
            )
            .toList();
        for (final ptr in ptrs) {
          final srv = await client
              .lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))
              .first
              .timeout(const Duration(seconds: 2));
          final txt = await client
              .lookup<TxtResourceRecord>(ResourceRecordQuery.text(ptr.domainName))
              .toList()
              .timeout(const Duration(seconds: 2), onTimeout: () => []);
          final ip = await client
              .lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))
              .first
              .timeout(const Duration(seconds: 2));
          final props = <String, String>{
            for (final r in txt)
              for (final line in r.text.split('\n'))
                if (line.contains('=')) line.substring(0, line.indexOf('=')): line.substring(line.indexOf('=') + 1),
          };
          final label = ptr.domainName.split('._').first;
          add(
            CastDevice(
              id: props['id'] ?? ptr.domainName,
              name: props['fn'] ?? label,
              type: entry.value,
              address: ip.address.address,
              port: srv.port,
              model: props['md'],
            ),
          );
        }
      }
    } finally {
      client.stop();
    }
  }

  // ------------------------------------------------------- hotspot subnet

  /// Control ports TVs listen on, in identification order.
  static const _tvPorts = [8008, 8060, 8001, 3000, 9197, 49152, 7000];

  /// Fallback for hotspots, where multicast is often filtered: probe every
  /// client on the hotspot /24 and identify TVs by their control port.
  Future<void> _scanSubnet(String ownIp, void Function(CastDevice) add) async {
    final parts = ownIp.split('.');
    if (parts.length != 4) return;
    final prefix = parts.take(3).join('.');
    final hosts = [for (var i = 1; i < 255; i++) '$prefix.$i']..remove(ownIp);

    // Probe in small batches so we don't open hundreds of sockets at once.
    for (var i = 0; i < hosts.length; i += 16) {
      await Future.wait(hosts.skip(i).take(16).map((h) => _probeHost(h, add)));
    }
  }

  Future<void> _probeHost(String host, void Function(CastDevice) add) async {
    var alive = false;
    // All ports at once; the first in _tvPorts order that is open wins.
    final results = await Future.wait(
      _tvPorts.map((port) async {
        try {
          final s = await Socket.connect(host, port, timeout: const Duration(milliseconds: 400));
          s.destroy();
          return true;
        } on SocketException catch (e) {
          // "Connection refused" means a device is there, just not on this port.
          if (e.osError?.errorCode == 111 || e.osError?.errorCode == 10061) alive = true;
          return false;
        }
      }),
    );
    final i = results.indexOf(true);
    final open = i < 0 ? null : _tvPorts[i];
    if (open == null) {
      if (alive) unidentifiedClients++;
      return;
    }
    final device = await _identify(host, open).catchError((_) => null);
    if (device != null) add(device);
  }

  Future<CastDevice?> _identify(String host, int port) async {
    Future<String?> get(String path) async {
      final r = await http.get(Uri.parse('http://$host:$port$path')).timeout(const Duration(seconds: 2));
      return r.statusCode == 200 ? utf8.decode(r.bodyBytes, allowMalformed: true) : null;
    }

    String? xmlTag(String? body, String tag) =>
        body == null ? null : XmlDocument.parse(body).findAllElements(tag).firstOrNull?.innerText.trim();

    switch (port) {
      case 8008:
        final name = xmlTag(await get('/ssdp/device-desc.xml').catchError((_) => null), 'friendlyName');
        return CastDevice(
          id: 'cast-$host',
          name: name ?? 'Chromecast',
          type: DeviceType.chromecast,
          address: host,
          port: 8009,
        );
      case 8060:
        final info = await get('/query/device-info').catchError((_) => null);
        final name = xmlTag(info, 'user-device-name') ?? xmlTag(info, 'friendly-device-name');
        return CastDevice(id: 'roku-$host', name: name ?? 'Roku', type: DeviceType.roku, address: host, port: 8060);
      case 8001:
        final body = await get('/api/v2/').catchError((_) => null);
        String? name;
        try {
          name = ((jsonDecode(body ?? '{}') as Map)['device'] as Map?)?['name'] as String?;
        } catch (_) {}
        return CastDevice(
          id: 'samsung-$host',
          name: name ?? 'Samsung TV',
          type: DeviceType.smartTv,
          address: host,
          port: 8001,
        );
      case 3000:
        return CastDevice(id: 'lg-$host', name: 'LG TV', type: DeviceType.smartTv, address: host, port: 3000);
      default:
        return CastDevice(id: 'tv-$host', name: 'TV ($host)', type: DeviceType.dlna, address: host, port: port);
    }
  }

  // ------------------------------------------------------------ connection

  @override
  Future<CastDevice?> findById(String id) async => null;

  /// Confirms the receiver is reachable on its control port.
  @override
  Future<void> connect(CastDevice device) async {
    final port =
        device.port ??
        switch (device.type) {
          DeviceType.chromecast => 8009,
          DeviceType.roku => 8060,
          _ => 80,
        };
    try {
      final s = await Socket.connect(device.address, port, timeout: const Duration(seconds: 4));
      s.destroy();
    } on SocketException {
      throw SocketException('${device.name} isn’t reachable. Make sure it’s on and on the same Wi-Fi.');
    }
  }

  @override
  Future<void> disconnect() async {}
}

extension on InternetAddress {
  bool get isPrivateLan {
    final b = rawAddress;
    return b.length == 4 && (b[0] == 10 || (b[0] == 172 && b[1] >= 16 && b[1] <= 31) || (b[0] == 192 && b[1] == 168));
  }
}
