import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/devices/domain/receiver_capabilities.dart';
import 'package:castflow/features/remote/data/dlna_client.dart';
import 'package:castflow/features/remote/data/network_remote_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// A button must never be enabled for a TV whose protocol has no command behind
/// it (it would only ever answer "isn't supported").
void main() {
  final implemented = <RemoteProtocol, Set<RemoteCommand>>{
    RemoteProtocol.roku: NetworkRemoteService.rokuKeys.keys.toSet(),
    RemoteProtocol.androidTv: NetworkRemoteService.androidKeyCodes.keys.toSet(),
    RemoteProtocol.samsung: NetworkRemoteService.samsungKeys.keys.toSet(),
    RemoteProtocol.lg: {...NetworkRemoteService.lgButtons.keys, ...NetworkRemoteService.lgRequests.keys},
    RemoteProtocol.dlna: DlnaClient.supported,
  };

  for (final p in RemoteProtocol.values) {
    test('${p.name}: every enabled remote button has a real command behind it', () {
      final enabled = protocolCapabilities[p]!;
      final missing = enabled.difference(implemented[p] ?? const {});
      expect(missing, isEmpty, reason: '$p enables ${missing.map((c) => c.label)} but sends nothing');
    });
  }

  test('key-protocol TVs (Roku, Android TV, Samsung) map all 19 buttons', () {
    for (final p in [RemoteProtocol.roku, RemoteProtocol.androidTv, RemoteProtocol.samsung]) {
      expect(implemented[p], containsAll(RemoteCommand.values), reason: p.name);
    }
  });

  test('distinct physical keys: no two different buttons send the same key on Android TV', () {
    final codes = NetworkRemoteService.androidKeyCodes.values;
    expect(codes.toSet().length, codes.length);
  });
}
