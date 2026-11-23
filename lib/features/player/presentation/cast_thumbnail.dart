import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/effects.dart';
import '../../media/presentation/asset_thumbnail.dart';
import '../domain/cast_media.dart';

/// The picture for a cast item, from the best source it has:
/// - a gallery photo or video (`asset:<id>`): its MediaStore thumbnail;
/// - a picked photo file: the image itself;
/// - a web video's poster, when the page gave one;
/// otherwise the themed placeholder (music, streams, picked videos).
class CastThumbnail extends StatelessWidget {
  const CastThumbnail({super.key, required this.media, this.radius = 12, this.iconSize = 20, this.fit = BoxFit.cover});

  final CastMedia media;
  final double radius;
  final double iconSize;
  final BoxFit fit;

  static const _assetPrefix = 'asset:';

  @override
  Widget build(BuildContext context) {
    final url = media.url ?? '';
    final placeholder = MediaArt(seed: media.seed, icon: media.kind.icon, iconSize: iconSize, radius: radius);

    if (url.startsWith(_assetPrefix) && (media.kind == CastKind.photo || media.kind == CastKind.video)) {
      return AssetThumbnail(assetId: url.substring(_assetPrefix.length), radius: radius);
    }
    if (!kIsWeb && media.kind == CastKind.photo && url.isNotEmpty && File(url).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.file(File(url), fit: fit, cacheWidth: 600, errorBuilder: (_, _, _) => placeholder),
      );
    }
    final poster = media.thumbnail;
    if (poster != null && poster.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(poster, fit: fit, errorBuilder: (_, _, _) => placeholder),
      );
    }
    return placeholder;
  }
}
