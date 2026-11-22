import 'package:flutter/foundation.dart';

import 'cast_media.dart';

/// What the TV says it can play: the "Sink" list of its UPnP
/// ConnectionManager (GetProtocolInfo), e.g.
/// `http-get:*:video/mp4:DLNA.ORG_PN=AVC_MP4_BL_CIF15_AAC_520,http-get:*:image/jpeg:*`.
@immutable
class TvFormats {
  const TvFormats(this.entries);

  /// Parses the comma-separated Sink value.
  factory TvFormats.parse(String sink) => TvFormats([
    for (final e in sink.split(','))
      if (e.trim().isNotEmpty) e.trim(),
  ]);

  final List<String> entries;

  /// The TV listed nothing (or couldn't be asked): we know nothing.
  bool get isKnown => entries.isNotEmpty;

  Iterable<String> get _mimes sync* {
    for (final e in entries) {
      final parts = e.split(':');
      if (parts.length >= 3 && parts[0].toLowerCase().startsWith('http'))
        yield parts[2].trim().toLowerCase();
    }
  }

  /// Whether the TV lists [mime] (or a wildcard that covers it).
  bool accepts(String mime) {
    final m = mime.toLowerCase();
    final family = m.split('/').first;
    for (final listed in _mimes) {
      if (listed == m ||
          listed == '*' ||
          listed == '*/*' ||
          listed == '$family/*')
        return true;
      // Common aliases renderers use for the same container.
      if (_aliases[m]?.contains(listed) ?? false) return true;
    }
    return false;
  }

  /// Whether any entry mentions [token] (a DLNA profile such as "HEVC").
  bool mentions(String token) =>
      entries.any((e) => e.toUpperCase().contains(token.toUpperCase()));

  static const _aliases = {
    'video/x-matroska': {'video/x-mkv', 'video/mkv'},
    'video/quicktime': {'video/mov'},
    'video/x-msvideo': {'video/avi', 'video/msvideo'},
    'image/jpeg': {'image/jpg'},
    'audio/mpeg': {'audio/mp3'},
  };
}

/// What a local file actually contains (from Android's MediaExtractor).
@immutable
class MediaProbe {
  const MediaProbe({this.mime, this.videoCodec, this.audioCodec});

  factory MediaProbe.fromMap(Map<Object?, Object?> m) => MediaProbe(
    mime: m['mime'] as String?,
    videoCodec: m['video'] as String?,
    audioCodec: m['audio'] as String?,
  );

  final String? mime;
  final String? videoCodec;
  final String? audioCodec;
}

enum Conversion { none, jpeg, mp4 }

/// Decides whether a file must be converted before the TV gets it.
///
/// Without a format list from the TV nothing is converted up front except
/// images no TV decodes (HEIC/HEIF/AVIF/WebP/TIFF/DNG); a playback error then
/// triggers conversion as a fallback (see PlayerController).
Conversion conversionFor({
  required CastKind kind,
  required String mime,
  MediaProbe? probe,
  TvFormats? formats,
}) {
  final m = mime.toLowerCase();
  final known = formats != null && formats.isKnown;
  switch (kind) {
    case CastKind.photo:
      if (m == 'image/jpeg' || m == 'image/jpg') return Conversion.none;
      if (known) return formats.accepts(m) ? Conversion.none : Conversion.jpeg;
      const exotic = {
        'image/heic',
        'image/heif',
        'image/heic-sequence',
        'image/heif-sequence',
        'image/avif',
        'image/webp',
        'image/tiff',
        'image/x-adobe-dng',
        'image/dng',
        'image/x-canon-cr2',
        'image/x-nikon-nef',
        'image/x-sony-arw',
      };
      return exotic.contains(m) ? Conversion.jpeg : Conversion.none;
    case CastKind.video:
      if (!known) return Conversion.none;
      if (!formats.accepts(m)) return Conversion.mp4;
      // The container is fine; the codec inside may not be.
      final video = probe?.videoCodec?.toLowerCase();
      if (video != null) {
        final needs = switch (video) {
          'video/hevc' =>
            !formats.mentions('HEVC') && !formats.mentions('H265'),
          'video/x-vnd.on2.vp9' => !formats.mentions('VP9'),
          'video/x-vnd.on2.vp8' => !formats.mentions('VP8'),
          'video/av01' => !formats.mentions('AV1'),
          'video/dolby-vision' => !formats.mentions('DOLBY'),
          _ => false,
        };
        if (needs) return Conversion.mp4;
      }
      return Conversion.none;
    default:
      return Conversion.none;
  }
}

/// The conversion to retry with after the TV failed to play [kind].
Conversion fallbackConversionFor(CastKind kind) => switch (kind) {
  CastKind.photo => Conversion.jpeg,
  CastKind.video => Conversion.mp4,
  _ => Conversion.none,
};
