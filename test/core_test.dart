import 'package:castflow/core/utils/format.dart';
import 'package:castflow/features/webcast/domain/web_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDuration', () {
    test('minutes and seconds', () => expect(formatDuration(const Duration(minutes: 3, seconds: 7)), '03:07'));
    test('hours', () => expect(formatDuration(const Duration(hours: 1, minutes: 2, seconds: 3)), '1:02:03'));
  });

  group('formatBytes', () {
    test('bytes', () => expect(formatBytes(512), '512 B'));
    test('megabytes', () => expect(formatBytes(148000000), '141 MB'));
    test('gigabytes', () => expect(formatBytes(1240000000), '1.2 GB'));
  });

  group('dayBucket', () {
    final now = DateTime(2026, 11, 1, 10);
    test('today', () => expect(dayBucket(DateTime(2026, 11, 1, 0, 5), now), DayBucket.today));
    test('yesterday', () => expect(dayBucket(DateTime(2026, 10, 31, 23, 59), now), DayBucket.yesterday));
    test('earlier', () => expect(dayBucket(DateTime(2026, 10, 28), now), DayBucket.earlier));
  });

  group('normalizeUrl', () {
    test('keeps full urls', () => expect(normalizeUrl('https://vimeo.com/x'), 'https://vimeo.com/x'));
    test('adds scheme to domains', () => expect(normalizeUrl('vimeo.com'), 'https://vimeo.com'));
    test('turns text into a search', () {
      expect(normalizeUrl('cat videos'), 'https://www.google.com/search?q=cat+videos');
    });
  });
}
