import 'package:intl/intl.dart';

String formatDuration(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

String formatBytes(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB'];
  var size = bytes.toDouble();
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  return '${size.toStringAsFixed(size >= 100 || unit == 0 ? 0 : 1)} ${units[unit]}';
}

String formatTime(DateTime t) => DateFormat.jm().format(t);

String formatShortDate(DateTime t) => DateFormat.MMMd().format(t);

/// "Today" / "Yesterday" / "Earlier" bucket used by History.
enum DayBucket { today, yesterday, earlier }

DayBucket dayBucket(DateTime t, [DateTime? now]) {
  final n = now ?? DateTime.now();
  final today = DateTime(n.year, n.month, n.day);
  final day = DateTime(t.year, t.month, t.day);
  final diff = today.difference(day).inDays;
  if (diff <= 0) return DayBucket.today;
  if (diff == 1) return DayBucket.yesterday;
  return DayBucket.earlier;
}

String greeting([DateTime? now]) {
  final h = (now ?? DateTime.now()).hour;
  if (h < 12) return 'Good morning';
  if (h < 17) return 'Good afternoon';
  return 'Good evening';
}
