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

enum Conversion { none, jpeg, mp4, aac }

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
    case CastKind.music:
      if (_plainAudio.contains(m)) return Conversion.none;
      if (known && formats.accepts(m)) return Conversion.none;
      // FLAC / OGG / Opus / WMA / AMR: many TVs show the file and play silence.
      return _unsafeAudioMimes.contains(m) || known ? Conversion.aac : Conversion.none;
    case CastKind.video:
      // A sound the TV can't decode plays as a silent video: convert (the
      // picture is passed through untouched when it is already H.264).
      if (!_audioPlayable(probe?.audioCodec, formats)) return Conversion.mp4;
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

const _plainAudio = {'audio/mpeg', 'audio/mp3', 'audio/mp4', 'audio/aac', 'audio/x-m4a', 'audio/wav', 'audio/x-wav'};

const _unsafeAudioMimes = {
  'audio/flac',
  'audio/x-flac',
  'audio/ogg',
  'audio/opus',
  'audio/x-ms-wma',
  'audio/amr',
  'audio/3gpp',
  'audio/x-matroska',
  'audio/webm',
  'audio/vorbis',
};

/// Whether a TV can be expected to decode [codec] (an Android MIME such as
/// `audio/mp4a-latm`). AAC and MP3 play everywhere; Dolby (AC-3 / E-AC-3) only
/// where the TV lists it; Opus, Vorbis, FLAC, DTS, TrueHD, PCM variants and the
/// rest are not assumed. No audio track at all is fine.
bool _audioPlayable(String? codec, TvFormats? formats) {
  final c = codec?.toLowerCase();
  if (c == null || c.isEmpty) return true;
  if (c == 'audio/mp4a-latm' || c == 'audio/mpeg' || c == 'audio/mpeg-l2') return true;
  if (c == 'audio/ac3' || c == 'audio/eac3' || c == 'audio/eac3-joc') {
    return formats != null && (formats.mentions('AC3') || formats.mentions('DD'));
  }
  return false;
}

/// A short, readable account of what a conversion changes, e.g.
/// "MKV · H.265 / DTS → MP4 · H.264 / AAC". Technical names are not translated.
String conversionLabel({required Conversion conversion, required String mime, MediaProbe? probe}) {
  String container(String m) => switch (m.toLowerCase()) {
    'video/x-matroska' => 'MKV',
    'video/webm' => 'WebM',
    'video/quicktime' => 'MOV',
    'video/x-msvideo' => 'AVI',
    'video/3gpp' => '3GP',
    'video/mp4' => 'MP4',
    'video/mp2t' => 'TS',
    'image/heic' || 'image/heif' => 'HEIC',
    'image/webp' => 'WebP',
    'image/png' => 'PNG',
    'image/avif' => 'AVIF',
    'audio/flac' || 'audio/x-flac' => 'FLAC',
    'audio/ogg' => 'OGG',
    'audio/opus' => 'Opus',
    'audio/x-ms-wma' => 'WMA',
    final other => other.split('/').last.toUpperCase(),
  };
  String video(String? c) => switch (c?.toLowerCase()) {
    'video/hevc' => 'H.265',
    'video/avc' => 'H.264',
    'video/x-vnd.on2.vp9' => 'VP9',
    'video/x-vnd.on2.vp8' => 'VP8',
    'video/av01' => 'AV1',
    'video/dolby-vision' => 'Dolby Vision',
    'video/mp4v-es' => 'MPEG-4',
    _ => '',
  };
  String audio(String? c) => switch (c?.toLowerCase()) {
    'audio/mp4a-latm' => 'AAC',
    'audio/mpeg' => 'MP3',
    'audio/ac3' => 'AC-3',
    'audio/eac3' || 'audio/eac3-joc' => 'E-AC-3',
    'audio/opus' => 'Opus',
    'audio/vorbis' => 'Vorbis',
    'audio/flac' => 'FLAC',
    'audio/vnd.dts' || 'audio/vnd.dts.hd' => 'DTS',
    'audio/true-hd' => 'TrueHD',
    _ => '',
  };
  String join(String a, String b) => [a, b].where((x) => x.isNotEmpty).join(' / ');
  switch (conversion) {
    case Conversion.mp4:
      final from = join(video(probe?.videoCodec), audio(probe?.audioCodec));
      return '${container(mime)}${from.isEmpty ? '' : ' · $from'} → MP4 · H.264 / AAC';
    case Conversion.aac:
      return '${container(mime)} → M4A · AAC';
    case Conversion.jpeg:
      return '${container(mime)} → JPEG';
    case Conversion.none:
      return '';
  }
}

/// The plain names in a [conversionLabel], e.g. "MKV · H.265 / DTS → MP4 · H.264 / AAC"
/// gives from "MKV" and to "MP4", for sentences like "your TV can't play MKV".
({String from, String to})? conversionNames(String? detail) {
  if (detail == null || !detail.contains('→')) return null;
  final parts = detail.split('→');
  String name(String s) => s.split('·').first.trim();
  final from = name(parts.first), to = name(parts.last);
  return from.isEmpty || to.isEmpty ? null : (from: from, to: to);
}

/// The conversion to retry with after the TV failed to play [kind].
Conversion fallbackConversionFor(CastKind kind) => switch (kind) {
  CastKind.photo => Conversion.jpeg,
  CastKind.video => Conversion.mp4,
  CastKind.music => Conversion.aac,
  _ => Conversion.none,
};
