import 'package:castflow/core/theme/app_theme.dart';
import 'package:castflow/features/player/domain/cast_media.dart';
import 'package:castflow/features/player/domain/tv_formats.dart';
import 'package:castflow/features/player/presentation/cast_thumbnail.dart';
import 'package:castflow/features/player/presentation/now_playing_screen.dart';
import 'package:castflow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  final tv = TvFormats.parse('http-get:*:video/mp4:*,http-get:*:audio/mpeg:*,http-get:*:image/jpeg:*');

  group('a video whose sound the TV cannot play is converted (otherwise it plays silent)', () {
    test('DTS / Opus / FLAC / Vorbis audio inside an otherwise fine MP4', () {
      for (final codec in ['audio/vnd.dts', 'audio/opus', 'audio/flac', 'audio/vorbis', 'audio/true-hd']) {
        expect(
          conversionFor(
            kind: CastKind.video,
            mime: 'video/mp4',
            formats: tv,
            probe: MediaProbe(videoCodec: 'video/avc', audioCodec: codec),
          ),
          Conversion.mp4,
          reason: codec,
        );
      }
    });

    test('AAC and MP3 are left alone; AC-3 only where the TV lists it', () {
      for (final codec in ['audio/mp4a-latm', 'audio/mpeg']) {
        expect(
          conversionFor(
            kind: CastKind.video,
            mime: 'video/mp4',
            formats: tv,
            probe: MediaProbe(videoCodec: 'video/avc', audioCodec: codec),
          ),
          Conversion.none,
        );
      }
      const ac3 = MediaProbe(videoCodec: 'video/avc', audioCodec: 'audio/ac3');
      expect(conversionFor(kind: CastKind.video, mime: 'video/mp4', formats: tv, probe: ac3), Conversion.mp4);
      final dolby = TvFormats.parse('http-get:*:video/mp4:*,http-get:*:audio/ac3:DLNA.ORG_PN=AC3');
      expect(conversionFor(kind: CastKind.video, mime: 'video/mp4', formats: dolby, probe: ac3), Conversion.none);
    });

    test('works even when the TV publishes no format list', () {
      expect(
        conversionFor(
          kind: CastKind.video,
          mime: 'video/mp4',
          formats: const TvFormats([]),
          probe: const MediaProbe(videoCodec: 'video/avc', audioCodec: 'audio/opus'),
        ),
        Conversion.mp4,
      );
    });
  });

  test('music the TV cannot decode becomes AAC; MP3 / M4A / WAV stay', () {
    expect(conversionFor(kind: CastKind.music, mime: 'audio/flac', formats: tv), Conversion.aac);
    expect(conversionFor(kind: CastKind.music, mime: 'audio/ogg', formats: const TvFormats([])), Conversion.aac);
    expect(conversionFor(kind: CastKind.music, mime: 'audio/mpeg', formats: tv), Conversion.none);
    expect(conversionFor(kind: CastKind.music, mime: 'audio/mp4', formats: const TvFormats([])), Conversion.none);
  });

  test('the conversion label says what turns into what', () {
    expect(
      conversionLabel(
        conversion: Conversion.mp4,
        mime: 'video/x-matroska',
        probe: const MediaProbe(videoCodec: 'video/hevc', audioCodec: 'audio/vnd.dts'),
      ),
      'MKV · H.265 / DTS → MP4 · H.264 / AAC',
    );
    expect(conversionLabel(conversion: Conversion.jpeg, mime: 'image/heic'), 'HEIC → JPEG');
    expect(conversionLabel(conversion: Conversion.aac, mime: 'audio/flac'), 'FLAC → M4A · AAC');
  });

  testWidgets('while checking the TV, the preview says so (no codec jargon, no bar yet)', (tester) async {
    await tester.pumpWidget(_wrap(const ConversionBar()));
    expect(find.text('Checking what your TV can play…'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget, reason: 'an indeterminate ring');
  });

  testWidgets('while converting, the preview explains why, what, how far and that it starts by itself', (tester) async {
    const detail = 'MKV · H.265 / DTS → MP4 · H.264 / AAC';
    await tester.pumpWidget(_wrap(const ConversionBar(progress: 0.0, detail: detail)));
    expect(find.text("Converting to your TV's format"), findsOneWidget);
    expect(find.text("Your TV can't play MKV directly, so it is being converted to MP4."), findsOneWidget);
    expect(find.text(detail), findsOneWidget);
    expect(find.textContaining('Keep the app open'), findsOneWidget);

    await tester.pumpWidget(_wrap(const ConversionBar(progress: 0.5, detail: detail)));
    await tester.pump(const Duration(milliseconds: 300));
    final midway = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value!;
    expect(midway, inExclusiveRange(0.0, 0.5), reason: 'animates, does not jump');
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('50%'), findsOneWidget, reason: 'the ring shows the percentage');
    expect(tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value, closeTo(0.5, 0.01));
  });

  testWidgets('a photo conversion (no percentage yet) shows the explanation with a spinner and an endless bar', (tester) async {
    await tester.pumpWidget(_wrap(const ConversionBar(detail: 'HEIC → JPEG')));
    expect(find.text("Your TV can't play HEIC directly, so it is being converted to JPEG."), findsOneWidget);
    expect(tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value, isNull);
    expect(tester.takeException(), isNull);
  });

  test('names for the sentence come from the conversion label', () {
    expect(conversionNames('MKV · H.265 / DTS → MP4 · H.264 / AAC'), (from: 'MKV', to: 'MP4'));
    expect(conversionNames('HEIC → JPEG'), (from: 'HEIC', to: 'JPEG'));
    expect(conversionNames('FLAC → M4A · AAC'), (from: 'FLAC', to: 'M4A'));
    expect(conversionNames(null), isNull);
    expect(conversionNames('nothing here'), isNull);
  });

  testWidgets('a video with no gallery id still shows the themed placeholder, never blank', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          width: 80,
          height: 80,
          child: CastThumbnail(
            media: CastMedia(id: 'x', title: 'v', kind: CastKind.video, seed: 3, url: '/nope/clip.mp4'),
          ),
        ),
      ),
    );
    expect(find.byType(CastThumbnail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
