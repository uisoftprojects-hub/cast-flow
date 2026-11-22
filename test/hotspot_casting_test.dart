import 'dart:convert';
import 'dart:io';

import 'package:castflow/features/devices/data/network_device_repository.dart';
import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/domain/network_status.dart';
import 'package:castflow/features/player/data/media_caster.dart';
import 'package:castflow/features/player/data/media_server.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/remote/data/dlna_client.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dummy hotspot network, all on loopback:
///
///   phone (hotspot / AP interface)  = 127.0.0.1   (what Android reports as hotspotIp)
///   TV that joined the hotspot      = 127.0.0.2
///
/// The "TV" is a Roku-style device (ECP on 8060, which the hotspot subnet scan
/// identifies; multicast is often filtered on hotspots) that is also a DLNA
/// renderer, and, like a real TV, fetches the media URL it is told to play.
class _HotspotTv {
  static const ip = '127.0.0.2';
  late HttpServer ecp; // 8060: identification
  late HttpServer upnp; // description + SOAP
  final actions = <String>[];
  String? mediaUrl;
  final fetched = <int>[];
  int fetchStatus = 0;
  String? fetchedFrom;

  Future<void> start() async {
    ecp = await HttpServer.bind(ip, 8060);
    ecp.listen((req) async {
      if (req.uri.path == '/query/device-info') {
        req.response
          ..headers.contentType = ContentType('text', 'xml')
          ..write('<device-info><user-device-name>Hotspot Roku</user-device-name></device-info>');
      } else {
        req.response.statusCode = 404;
      }
      await req.response.close();
    });
    upnp = await HttpServer.bind(ip, 0);
    upnp.listen((req) async {
      if (req.method == 'GET') {
        req.response
          ..headers.contentType = ContentType('text', 'xml')
          ..write('''<root><device><serviceList>
            <service><serviceType>urn:schemas-upnp-org:service:AVTransport:1</serviceType><controlURL>/avt</controlURL></service>
            <service><serviceType>urn:schemas-upnp-org:service:RenderingControl:1</serviceType><controlURL>/rc</controlURL></service>
          </serviceList></device></root>''');
        await req.response.close();
        return;
      }
      final body = await utf8.decoder.bind(req).join();
      final action = (req.headers.value('soapaction') ?? '').replaceAll('"', '').split('#').last;
      actions.add(action);
      if (action == 'SetAVTransportURI') {
        final raw = RegExp('<CurrentURI>(.*?)</CurrentURI>', dotAll: true).firstMatch(body)![1]!;
        mediaUrl = raw.replaceAll('&amp;', '&');
        // The TV now opens the URL: from ITS address, over the hotspot network.
        final c = HttpClient()..connectionFactory = (uri, proxyHost, proxyPort) => Socket.startConnect(
          uri.host,
          uri.port,
          sourceAddress: InternetAddress(ip),
        );
        try {
          final res = await (await c.getUrl(Uri.parse(mediaUrl!))).close();
          fetchStatus = res.statusCode;
          fetched.addAll(await res.fold<List<int>>([], (a, b) => a..addAll(b)));
        } finally {
          c.close();
        }
      }
      req.response
        ..headers.contentType = ContentType('text', 'xml')
        ..write(
          '<s:Envelope xmlns:s="x"><s:Body><u:${action}Response xmlns:u="y"></u:${action}Response></s:Body></s:Envelope>',
        );
      await req.response.close();
    });
  }

  Future<void> stop() async {
    await ecp.close(force: true);
    await upnp.close(force: true);
  }

  CastDevice get device => CastDevice(
    id: 'roku-$ip',
    name: 'Hotspot Roku',
    type: DeviceType.roku,
    address: ip,
    port: 8060,
    protocol: RemoteProtocol.dlna,
    location: 'http://$ip:${upnp.port}/desc.xml',
  );
}

void main() {
  setUpAll(() => HttpOverrides.global = null);

  // What Android's NetworkMonitor reports with the hotspot on and Wi-Fi off.
  const hotspot = NetworkStatus(
    hotspot: true,
    hotspotIp: '127.0.0.1',
    hotspotPrefix: 24,
    hotspotInterface: 'ap0',
    wifiIp: '192.168.1.20', // a stale wlan0 address must never be used
    wifiPrefix: 24,
  );

  test('discovery over the hotspot finds a TV that joined it (subnet scan; multicast is filtered)', () async {
    final tv = _HotspotTv();
    await tv.start();
    addTearDown(tv.stop);

    final repo = NetworkDeviceRepository(scanTime: const Duration(seconds: 3));
    final batches = await repo.discover(network: hotspot).toList();
    final found = batches.expand((b) => b).toList();

    expect(found.map((d) => d.address), contains(_HotspotTv.ip));
    final d = found.firstWhere((d) => d.address == _HotspotTv.ip);
    expect(d.type, DeviceType.roku);
    expect(d.name, 'Hotspot Roku');
  }, timeout: const Timeout(Duration(seconds: 40)));

  test('discovery does not start at all without Wi-Fi or hotspot', () async {
    final repo = NetworkDeviceRepository(scanTime: const Duration(seconds: 1));
    expect(repo.discover(network: const NetworkStatus()).toList(), throwsA(isA<SocketException>()));
  });

  test('casting over the hotspot: the TV is given the AP address and really fetches the media from it', () async {
    final tv = _HotspotTv();
    await tv.start();
    addTearDown(tv.stop);
    final dir = await Directory.systemTemp.createTemp('castflow_hotspot');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/clip.mp4')..writeAsBytesSync(List.generate(2000, (i) => i % 251));

    final server = MediaServer();
    addTearDown(server.stop);
    final caster = DlnaMediaCaster(
      DlnaClient(),
      server,
      // The same decision MediaServer.lanIpFor makes from Android's report.
      hostFor: (tvHost) async => hotspot.addressFor(tvHost),
    );

    await caster.load(
      tv.device,
      CastMedia(id: 'v', title: 'Clip', kind: CastKind.video, seed: 1, url: file.path),
    );

    expect(tv.actions, containsAllInOrder(['Stop', 'SetAVTransportURI', 'Play']));
    final url = Uri.parse(tv.mediaUrl!);
    expect(url.host, '127.0.0.1', reason: 'the hotspot (AP) address, never the stale wlan0 192.168.1.20');
    expect(url.port, inInclusiveRange(8765, 8769), reason: 'stable preferred port');
    expect(tv.fetchStatus, 200);
    expect(tv.fetched.length, 2000);
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('casting a web video over the hotspot: the TV gets a URL on the phone, with the page headers applied', () async {
    final tv = _HotspotTv();
    await tv.start();
    addTearDown(tv.stop);
    final seen = <String?>[];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => origin.close(force: true));
    origin.listen((req) async {
      seen.add(req.headers.value('referer'));
      req.response
        ..headers.contentType = ContentType('video', 'mp4')
        ..add(List.filled(500, 7));
      await req.response.close();
    });

    final server = MediaServer();
    addTearDown(server.stop);
    final caster = DlnaMediaCaster(DlnaClient(), server, hostFor: (h) async => hotspot.addressFor(h));
    await caster.load(
      tv.device,
      CastMedia(
        id: 'w',
        title: 'Web',
        kind: CastKind.web,
        seed: 1,
        url: 'https://cdn.example/v.mp4'.replaceFirst('https://cdn.example', 'http://127.0.0.1:${origin.port}'),
        headers: const {'Referer': 'https://page.example/'},
      ),
    );

    expect(Uri.parse(tv.mediaUrl!).host, '127.0.0.1');
    expect(tv.fetched.length, 500);
    expect(seen, ['https://page.example/']);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
