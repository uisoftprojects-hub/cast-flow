import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';

/// Real thumbnail of a gallery photo or video, loaded from MediaStore.
class AssetThumbnail extends StatefulWidget {
  const AssetThumbnail({super.key, required this.assetId, this.radius = AppRadius.md, this.child});

  final String assetId;
  final double radius;

  /// Overlay (badges, selection check) drawn on top of the image.
  final Widget? child;

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  // Small LRU-style cache so scrolling back doesn't reload.
  static final _cache = <String, Future<Uint8List?>>{};

  late Future<Uint8List?> _bytes = _load(widget.assetId);

  static Future<Uint8List?> _load(String id) {
    if (_cache.length > 300) _cache.remove(_cache.keys.first);
    return _cache.putIfAbsent(id, () async {
      final entity = await AssetEntity.fromId(id);
      return entity?.thumbnailDataWithSize(const ThumbnailSize.square(300), quality: 80);
    });
  }

  @override
  void didUpdateWidget(AssetThumbnail old) {
    super.didUpdateWidget(old);
    if (old.assetId != widget.assetId) _bytes = _load(widget.assetId);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: context.palette.surfaceHigh),
          FutureBuilder<Uint8List?>(
            future: _bytes,
            builder: (context, snap) => snap.data == null
                ? const SizedBox.shrink()
                : Image.memory(snap.data!, fit: BoxFit.cover, gaplessPlayback: true),
          ),
          ?widget.child,
        ],
      ),
    );
  }
}
