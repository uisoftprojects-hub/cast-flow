import 'package:castflow/core/platform/cast_session_channel.dart';
import 'package:castflow/features/history/presentation/history_controller.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/player/presentation/player_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

const _a = CastMedia(id: 'a', title: 'A', kind: CastKind.photo, seed: 1, url: '/x/a.jpg');
const _b = CastMedia(id: 'b', title: 'B', kind: CastKind.photo, seed: 2, url: '/x/b.jpg');

Future<ProviderContainer> _player(PlayMode mode) async {
  final c = await makeContainer();
  await c.read(historyProvider.future);
  c.read(playerProvider.notifier).setPlayMode(mode);
  // One-second slideshow: items end after a second, like a short clip.
  c.read(playerProvider.notifier).play([_a, _b], slideshowInterval: const Duration(seconds: 1));
  return c;
}

void main() {
  Future<void> wait(double s) => Future<void>.delayed(Duration(milliseconds: (s * 1000).round()));

  test('Play once: the item ends and playback stops (no next, no repeat)', () async {
    final c = await _player(PlayMode.once);
    await wait(1.4);
    final s = c.read(playerProvider);
    expect(s.index, 0);
    expect(s.playing, isFalse);
    c.read(playerProvider.notifier).stop();
    c.dispose();
  });

  test('Autoplay: plays on to the next item', () async {
    final c = await _player(PlayMode.autoplay);
    await wait(1.4);
    expect(c.read(playerProvider).index, 1);
    expect(c.read(playerProvider).playing, isTrue);
    c.read(playerProvider.notifier).stop();
    c.dispose();
  });

  test('Repeat all: after the last item it starts again from the first', () async {
    final c = await _player(PlayMode.repeatAll);
    await wait(1.4);
    expect(c.read(playerProvider).index, 1);
    await wait(1.1);
    expect(c.read(playerProvider).index, 0);
    expect(c.read(playerProvider).playing, isTrue);
    c.read(playerProvider.notifier).stop();
    c.dispose();
  });

  test('Repeat one: the same item plays again and again', () async {
    final c = await _player(PlayMode.repeatOne);
    await wait(2.3);
    final s = c.read(playerProvider);
    expect(s.index, 0);
    expect(s.playing, isTrue);
    c.read(playerProvider.notifier).stop();
    c.dispose();
  });

  test('the loop button steps once → autoplay → repeat all → repeat one and keeps the choice between casts', () async {
    final c = await makeContainer();
    await c.read(historyProvider.future);
    final p = c.read(playerProvider.notifier);
    expect(c.read(playerProvider).playMode, PlayMode.autoplay);
    p.cyclePlayMode();
    expect(c.read(playerProvider).playMode, PlayMode.repeatAll);
    p.cyclePlayMode();
    expect(c.read(playerProvider).playMode, PlayMode.repeatOne);
    p.cyclePlayMode();
    expect(c.read(playerProvider).playMode, PlayMode.once);
    p.cyclePlayMode();
    expect(c.read(playerProvider).playMode, PlayMode.autoplay);
    p.setPlayMode(PlayMode.repeatOne);
    p.play([_a, _b]);
    expect(c.read(playerProvider).playMode, PlayMode.repeatOne, reason: 'a new cast keeps the loop choice');
    p.stop();
    expect(c.read(playerProvider).playMode, PlayMode.repeatOne);
    await wait(0.2); // let the history write finish before the store closes
    c.dispose();
  });

  test('the notification buttons and seek bar drive the player', () async {
    final c = await makeContainer();
    await c.read(historyProvider.future);
    final p = c.read(playerProvider.notifier);
    p.play([
      _a,
      const CastMedia(
        id: 'v',
        title: 'V',
        kind: CastKind.video,
        seed: 3,
        url: '/x/v.mp4',
        duration: Duration(minutes: 3),
      ),
    ]);
    final cmd = CastSessionChannel.onCommand!;
    expect(c.read(playerProvider).playing, isTrue);
    cmd('pause', Duration.zero);
    expect(c.read(playerProvider).playing, isFalse);
    cmd('pause', Duration.zero); // already paused: nothing flips back
    expect(c.read(playerProvider).playing, isFalse);
    cmd('play', Duration.zero);
    expect(c.read(playerProvider).playing, isTrue);
    cmd('next', Duration.zero);
    expect(c.read(playerProvider).index, 1);
    cmd('seek', const Duration(seconds: 90));
    expect(c.read(playerProvider).position, const Duration(seconds: 90));
    cmd('previous', Duration.zero); // past 3 s into the item: back to its start
    expect(c.read(playerProvider).position, Duration.zero);
    cmd('stop', Duration.zero);
    expect(c.read(playerProvider).isActive, isFalse);
    await wait(0.2);
    c.dispose();
  });
}
