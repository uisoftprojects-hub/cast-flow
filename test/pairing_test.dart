import 'dart:async';

import 'package:castflow/features/devices/domain/cast_device.dart';
import 'package:castflow/features/pairing/domain/pairing.dart';
import 'package:castflow/features/pairing/presentation/pairing_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

const _tv = CastDevice(id: 'atv-1', name: 'Living Room TV', type: DeviceType.smartTv, address: '192.168.1.9', port: 6466);

class _MemoryStore implements CredentialStore {
  final data = <String, String>{};
  @override
  Future<String?> read(String id) async => data[id];
  @override
  Future<void> write(String id, String c) async => data[id] = c;
  @override
  Future<void> delete(String id) async => data.remove(id);
}

/// Code "123456" is correct; a saved credential "good" is accepted.
class _FakeSession implements PairingSession {
  _FakeSession(String? saved, {this.approval = false}) {
    scheduleMicrotask(() {
      if (saved == 'good') {
        _c.add(const PairingDone('good'));
      } else if (saved != null) {
        _c.add(const SavedCredentialRejected());
      } else {
        _c.add(approval ? const AwaitingApproval() : const NeedsCode(length: 6));
      }
    });
  }

  final bool approval;
  final _c = StreamController<PairingStep>();

  @override
  Stream<PairingStep> get steps => _c.stream;
  @override
  Future<void> submitCode(String code) async =>
      _c.add(code == '123456' ? const PairingDone('token-1') : const PairingWrongCode());
  void reject() => _c.add(const PairingRejected());
  @override
  Future<void> close() => _c.close();
}

class _FakeProtocol implements PairingProtocol {
  _FakeProtocol({this.approval = false});
  final bool approval;
  _FakeSession? last;
  int starts = 0;
  @override
  bool handles(CastDevice d) => d.id == _tv.id;
  @override
  PairingSession start(CastDevice device, {String? saved}) {
    starts++;
    return last = _FakeSession(saved, approval: approval);
  }
}

Future<void> _tick() => Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  late _MemoryStore store;
  late _FakeProtocol protocol;
  late ProviderContainer c;

  Future<void> setUpWith({bool approval = false, Map<String, String> saved = const {}}) async {
    store = _MemoryStore()..data.addAll(saved);
    protocol = _FakeProtocol(approval: approval);
    c = await makeContainer(overrides: [
      credentialStoreProvider.overrideWithValue(store),
      pairingProtocolsProvider.overrideWithValue([protocol]),
    ]);
    c.listen(pairingProvider, (_, _) {});
  }

  test('devices without a pairing protocol connect directly', () async {
    await setUpWith();
    const roku = CastDevice(id: 'r', name: 'Roku', type: DeviceType.roku, address: '1.2.3.4');
    expect(await c.read(pairingProvider.notifier).pair(roku), isTrue);
    expect(c.read(pairingProvider), isNull);
  });

  test('code pairing: wrong code shakes, right code succeeds and is remembered', () async {
    await setUpWith();
    final result = c.read(pairingProvider.notifier).pair(_tv);
    await _tick();
    expect(c.read(pairingProvider)!.phase, PairingPhase.enterCode);

    await c.read(pairingProvider.notifier).submitCode('000000');
    await _tick();
    expect(c.read(pairingProvider)!.phase, PairingPhase.wrongCode);
    expect(c.read(pairingProvider)!.attempts, 1);

    await c.read(pairingProvider.notifier).submitCode('123456');
    await _tick();
    expect(c.read(pairingProvider)!.phase, PairingPhase.success);
    expect(await result, isTrue);
    expect(store.data[_tv.id], 'token-1');
  });

  test('a valid saved credential skips the sheet entirely', () async {
    await setUpWith(saved: {_tv.id: 'good'});
    expect(await c.read(pairingProvider.notifier).pair(_tv), isTrue);
    expect(c.read(pairingProvider), isNull);
  });

  test('a rejected saved credential is cleared and pairing starts again', () async {
    await setUpWith(saved: {_tv.id: 'stale'});
    c.read(pairingProvider.notifier).pair(_tv);
    await _tick();
    expect(store.data.containsKey(_tv.id), isFalse);
    expect(protocol.starts, 2);
    expect(c.read(pairingProvider)!.phase, PairingPhase.enterCode);
  });

  test('three wrong codes lock pairing until a new code is requested', () async {
    await setUpWith();
    c.read(pairingProvider.notifier).pair(_tv);
    await _tick();
    for (var i = 0; i < 3; i++) {
      await c.read(pairingProvider.notifier).submitCode('999999');
      await _tick();
    }
    expect(c.read(pairingProvider)!.phase, PairingPhase.cooldown);
  });

  test('approval declined on the TV shows the declined state; cancel resolves false', () async {
    await setUpWith(approval: true);
    final result = c.read(pairingProvider.notifier).pair(_tv);
    await _tick();
    expect(c.read(pairingProvider)!.phase, PairingPhase.approval);
    protocol.last!.reject();
    await _tick();
    expect(c.read(pairingProvider)!.phase, PairingPhase.rejected);
    c.read(pairingProvider.notifier).cancel();
    expect(await result, isFalse);
    expect(c.read(pairingProvider), isNull);
  });

  test('a second tap while pairing reuses the same session', () async {
    await setUpWith();
    final a = c.read(pairingProvider.notifier).pair(_tv);
    final b = c.read(pairingProvider.notifier).pair(_tv);
    await _tick();
    expect(protocol.starts, 1);
    c.read(pairingProvider.notifier).cancel();
    expect(await a, isFalse);
    expect(await b, isFalse);
  });
}
