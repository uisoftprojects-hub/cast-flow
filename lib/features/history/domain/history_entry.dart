import 'package:flutter/foundation.dart';

import '../../player/domain/cast_media.dart';

@immutable
class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.title,
    required this.kind,
    required this.deviceName,
    required this.castAt,
    required this.seed,
  });

  final String id;
  final String title;
  final CastKind kind;
  final String deviceName;
  final DateTime castAt;
  final int seed;

  Map<String, Object> toMap() => {
    'id': id,
    'title': title,
    'kind': kind.name,
    'deviceName': deviceName,
    'castAt': castAt.millisecondsSinceEpoch,
    'seed': seed,
  };

  factory HistoryEntry.fromMap(Map m) => HistoryEntry(
    id: m['id'] as String,
    title: m['title'] as String,
    kind: CastKind.values.asNameMap()[m['kind']] ?? CastKind.video,
    deviceName: m['deviceName'] as String,
    castAt: DateTime.fromMillisecondsSinceEpoch(m['castAt'] as int),
    seed: m['seed'] as int,
  );
}

abstract interface class HistoryRepository {
  Future<List<HistoryEntry>> list();
  Future<void> add(HistoryEntry entry);
  Future<void> remove(String id);
  Future<void> clear();
}
