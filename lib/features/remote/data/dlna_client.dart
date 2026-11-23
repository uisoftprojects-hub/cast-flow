import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../../devices/domain/cast_device.dart';
import '../../devices/domain/receiver_capabilities.dart';
import '../../player/domain/tv_formats.dart';

/// Controls a UPnP/DLNA MediaRenderer: transport (AVTransport) and volume
/// (RenderingControl) over SOAP. Works for any brand that publishes a
/// description XML, which is how the control URLs are found.
class DlnaClient {
  DlnaClient({http.Client? client, this.timeout = const Duration(seconds: 4)})
    : _http = client ?? http.Client();

  final http.Client _http;
  final Duration timeout;
  final _services = <String, _Services>{};

  static const volumeStep = 5;
  static const seekStep = Duration(seconds: 10);

  /// Commands this client really sends (mirrors the DLNA capabilities).
  static const supported = {
    RemoteCommand.playPause,
    RemoteCommand.previous,
    RemoteCommand.next,
    RemoteCommand.rewind,
    RemoteCommand.fastForward,
    RemoteCommand.volumeUp,
    RemoteCommand.volumeDown,
    RemoteCommand.mute,
  };

  Future<void> send(CastDevice device, RemoteCommand command) async {
    if (!supported.contains(command)) {
      throw UnsupportedError(
        '${command.label} isn’t supported by ${device.name}.',
      );
    }
    final s = await _servicesFor(device);
    try {
      await _dispatch(device, s, command);
    } on HttpException {
      // An idle renderer answers transport commands with a SOAP error. Say what
      // the user can do instead of "failed (500)".
      final idle = const {
        '',
        'STOPPED',
        'NO_MEDIA_PRESENT',
      }.contains(await _transportState(s).catchError((_) => ''));
      if (idle &&
          command != RemoteCommand.volumeUp &&
          command != RemoteCommand.volumeDown &&
          command != RemoteCommand.mute) {
        throw UnsupportedError(
          'Nothing is playing on ${device.name} yet. Cast a video, photo or song first.',
        );
      }
      rethrow;
    }
  }

  Future<void> _dispatch(
    CastDevice device,
    _Services s,
    RemoteCommand command,
  ) async {
    switch (command) {
      case RemoteCommand.playPause:
        final state = await _transportState(s);
        await _av(s, state == 'PLAYING' ? 'Pause' : 'Play', {
          if (state != 'PLAYING') 'Speed': '1',
        });
      case RemoteCommand.next:
        await _av(s, 'Next');
      case RemoteCommand.previous:
        await _av(s, 'Previous');
      case RemoteCommand.rewind:
        await _seekBy(s, -seekStep);
      case RemoteCommand.fastForward:
        await _seekBy(s, seekStep);
      case RemoteCommand.volumeUp:
        await _stepVolume(s, volumeStep);
      case RemoteCommand.volumeDown:
        await _stepVolume(s, -volumeStep);
      case RemoteCommand.mute:
        final muted = (await _rc(s, 'GetMute', {}))['CurrentMute'] == '1';
        await _rc(s, 'SetMute', {'DesiredMute': muted ? '0' : '1'});
      default:
        throw UnsupportedError(
          '${command.label} isn’t supported by ${device.name}.',
        );
    }
  }

  void forget(String deviceId) {
    _services.remove(deviceId);
    _formats.remove(deviceId);
  }

  final _formats = <String, TvFormats>{};

  /// What the TV can play: its ConnectionManager's GetProtocolInfo "Sink"
  /// list. Empty (unknown) when the TV doesn't publish one or doesn't answer;
  /// cached per device.
  Future<TvFormats> formats(CastDevice device) async {
    final cached = _formats[device.id];
    if (cached != null) return cached;
    var result = const TvFormats([]);
    try {
      final s = await _servicesFor(device);
      if (s.cm != null) {
        final info = await _call(s.cm, 'GetProtocolInfo', const {});
        result = TvFormats.parse(info['Sink'] ?? '');
      }
    } catch (_) {}
    // Don't cache a failure: the next item asks again.
    if (result.isKnown) _formats[device.id] = result;
    return result;
  }

  // -------------------------------------------------------------- casting

  /// Points the renderer at [url] and starts playing it.
  /// [mime] and [kind] go into the DIDL-Lite metadata TVs use to pick a decoder.
  Future<void> load(
    CastDevice device, {
    required String url,
    required String title,
    required String mime,
    required String kind,
  }) async {
    final s = await _servicesFor(device);
    // A previous item must be stopped first on many renderers; failure is fine.
    await _av(s, 'Stop').catchError((_) => <String, String>{});
    await _av(s, 'SetAVTransportURI', {
      'CurrentURI': url,
      'CurrentURIMetaData': didl(url, title, mime, kind),
    });
    try {
      await _av(s, 'Play', {'Speed': '1'});
    } catch (_) {
      // Some TVs are not ready the instant the URI is set.
      await Future<void>.delayed(const Duration(milliseconds: 700));
      await _av(s, 'Play', {'Speed': '1'});
    }
  }

  Future<void> play(CastDevice d) async =>
      _av(await _servicesFor(d), 'Play', {'Speed': '1'});
  Future<void> pause(CastDevice d) async => _av(await _servicesFor(d), 'Pause');
  Future<void> stop(CastDevice d) async => _av(await _servicesFor(d), 'Stop');

  Future<void> seekTo(CastDevice d, Duration to) async => _av(
    await _servicesFor(d),
    'Seek',
    {'Unit': 'REL_TIME', 'Target': _format(to)},
  );

  /// [level] is 0..1.
  Future<void> setVolumeLevel(CastDevice d, double level) async => _rc(
    await _servicesFor(d),
    'SetVolume',
    {'DesiredVolume': '${(level * 100).round().clamp(0, 100)}'},
  );

  /// What the TV is doing right now.
  Future<({String state, Duration position, Duration length})> status(
    CastDevice d,
  ) async {
    final s = await _servicesFor(d);
    final state = await _transportState(s);
    final info = await _av(s, 'GetPositionInfo');
    return (
      state: state,
      position: _parse(info['RelTime'] ?? ''),
      length: _parse(info['TrackDuration'] ?? ''),
    );
  }

  /// DIDL-Lite item describing [url] (unescaped; escaped when put in SOAP).
  static String didl(String url, String title, String mime, String kind) {
    final cls = switch (kind) {
      'photo' => 'object.item.imageItem.photo',
      'music' => 'object.item.audioItem.musicTrack',
      _ => 'object.item.videoItem',
    };
    return '<DIDL-Lite xmlns="urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/" '
        'xmlns:dc="http://purl.org/dc/elements/1.1/" '
        'xmlns:upnp="urn:schemas-upnp-org:metadata-1-0/upnp/">'
        '<item id="0" parentID="-1" restricted="1">'
        '<dc:title>${_esc(title)}</dc:title><upnp:class>$cls</upnp:class>'
        '<res protocolInfo="http-get:*:$mime:*">${_esc(url)}</res>'
        '</item></DIDL-Lite>';
  }

  // ------------------------------------------------------------ discovery

  Future<_Services> _servicesFor(CastDevice d) async {
    final cached = _services[d.id];
    if (cached != null) return cached;
    final location = d.location;
    if (location == null || location.isEmpty) {
      throw UnsupportedError(
        '${d.name} must be found again (Devices → search) before it can be controlled.',
      );
    }
    final res = await _http.get(Uri.parse(location)).timeout(timeout);
    if (res.statusCode != 200)
      throw HttpException(
        '${d.name} didn’t describe itself (${res.statusCode}).',
      );
    final doc = XmlDocument.parse(res.body);
    final base = doc.findAllElements('URLBase').firstOrNull?.innerText.trim();
    final root = Uri.parse(base == null || base.isEmpty ? location : base);

    ({String type, Uri url})? find(String name) {
      for (final s in doc.findAllElements('service')) {
        final type = s.getElement('serviceType')?.innerText.trim() ?? '';
        final control = s.getElement('controlURL')?.innerText.trim();
        if (type.contains(':$name:') && control != null && control.isNotEmpty) {
          return (type: type, url: root.resolve(control));
        }
      }
      return null;
    }

    final av = find('AVTransport');
    final rc = find('RenderingControl');
    final cm = find('ConnectionManager');
    if (av == null && rc == null)
      throw UnsupportedError('${d.name} exposes no DLNA controls.');
    return _services[d.id] = _Services(av, rc, cm);
  }

  // ----------------------------------------------------------------- SOAP

  Future<Map<String, String>> _call(
    ({String type, Uri url})? service,
    String action,
    Map<String, String> args,
  ) async {
    if (service == null)
      throw UnsupportedError('The TV doesn’t offer this control.');
    final body = StringBuffer()
      ..write('<?xml version="1.0" encoding="utf-8"?>')
      ..write(
        '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" ',
      )
      ..write(
        's:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body>',
      )
      ..write('<u:$action xmlns:u="${service.type}">');
    args.forEach((k, v) => body.write('<$k>${_esc(v)}</$k>'));
    body.write('</u:$action></s:Body></s:Envelope>');

    final res = await _http
        .post(
          service.url,
          headers: {
            'Content-Type': 'text/xml; charset="utf-8"',
            'SOAPACTION': '"${service.type}#$action"',
          },
          body: body.toString(),
        )
        .timeout(timeout);
    if (res.statusCode != 200)
      throw HttpException('$action failed (${res.statusCode}).');
    final out = <String, String>{};
    try {
      // Match on the local name: renderers use any namespace prefix (u:, ns0:, none…).
      final resp = XmlDocument.parse(res.body).descendants
          .whereType<XmlElement>()
          .where((e) => e.name.local == '${action}Response')
          .firstOrNull;
      for (final e in resp?.childElements ?? const <XmlElement>[]) {
        out[e.name.local] = e.innerText.trim();
      }
    } catch (_) {}
    return out;
  }

  static String _esc(String v) => v
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');

  Future<Map<String, String>> _av(
    _Services s,
    String action, [
    Map<String, String> args = const {},
  ]) => _call(s.av, action, {'InstanceID': '0', ...args});

  Future<Map<String, String>> _rc(
    _Services s,
    String action,
    Map<String, String> args,
  ) => _call(s.rc, action, {
    'InstanceID': '0',
    if (action.endsWith('Volume') || action.endsWith('Mute'))
      'Channel': 'Master',
    ...args,
  });

  // ------------------------------------------------------------- helpers

  /// An idle renderer may answer with a SOAP error instead of "STOPPED"; both
  /// mean "not playing", so Play/Pause must still work.
  Future<String> _transportState(_Services s) async {
    try {
      return (await _av(
            s,
            'GetTransportInfo',
          ))['CurrentTransportState']?.toUpperCase() ??
          '';
    } on HttpException {
      return 'STOPPED';
    }
  }

  Future<void> _stepVolume(_Services s, int delta) async {
    final now =
        int.tryParse((await _rc(s, 'GetVolume', {}))['CurrentVolume'] ?? '') ??
        30;
    await _rc(s, 'SetVolume', {
      'DesiredVolume': '${(now + delta).clamp(0, 100)}',
    });
  }

  Future<void> _seekBy(_Services s, Duration delta) async {
    final info = await _av(s, 'GetPositionInfo');
    final now = _parse(info['RelTime'] ?? '');
    final length = _parse(info['TrackDuration'] ?? '');
    var to = now + delta;
    if (to < Duration.zero) to = Duration.zero;
    if (length > Duration.zero && to > length) to = length;
    await _av(s, 'Seek', {'Unit': 'REL_TIME', 'Target': _format(to)});
  }

  static Duration _parse(String t) {
    final p = t.split(':');
    if (p.length != 3) return Duration.zero;
    final sec = double.tryParse(p[2]) ?? 0;
    return Duration(
      hours: int.tryParse(p[0]) ?? 0,
      minutes: int.tryParse(p[1]) ?? 0,
      seconds: sec.floor(),
    );
  }

  static String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
  }
}

class _Services {
  const _Services(this.av, this.rc, [this.cm]);
  final ({String type, Uri url})? av;
  final ({String type, Uri url})? rc;

  /// ConnectionManager: tells which formats the TV can play.
  final ({String type, Uri url})? cm;
}

/// One DLNA client shared by the remote and the caster (they share the cached
/// control URLs).
final dlnaClientProvider = Provider<DlnaClient>((ref) => DlnaClient());
