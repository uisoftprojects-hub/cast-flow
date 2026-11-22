import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

/// Small round "eye" button drawn over a thumbnail to open the full preview.
class PreviewButton extends StatelessWidget {
  const PreviewButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.45),
      ),
      child: const Icon(Icons.visibility_rounded, size: 16, color: Colors.white),
    ),
  );
}

/// Full-screen preview of a gallery photo (pinch to zoom).
Future<void> showPhotoPreview(BuildContext context, String assetId) =>
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _PreviewScaffold(child: _PhotoBody(assetId: assetId)),
      ),
    );

/// Full-screen preview of a gallery video with play / pause and a seek bar.
Future<void> showVideoPreview(BuildContext context, String assetId) =>
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _PreviewScaffold(child: _VideoBody(assetId: assetId)),
      ),
    );

class _PreviewScaffold extends StatelessWidget {
  const _PreviewScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    body: SafeArea(child: Center(child: child)),
  );
}

class _PhotoBody extends StatelessWidget {
  const _PhotoBody({required this.assetId});
  final String assetId;

  Future<Uint8List?> _load() async {
    final e = await AssetEntity.fromId(assetId);
    return e?.thumbnailDataWithSize(const ThumbnailSize(1600, 1600), quality: 90);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List?>(
    future: _load(),
    builder: (_, snap) {
      if (snap.connectionState != ConnectionState.done) {
        return const CircularProgressIndicator(color: Colors.white);
      }
      final data = snap.data;
      if (data == null) {
        return const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 56);
      }
      return InteractiveViewer(
        maxScale: 5,
        child: Image.memory(data, fit: BoxFit.contain),
      );
    },
  );
}

class _VideoBody extends StatefulWidget {
  const _VideoBody({required this.assetId});
  final String assetId;

  @override
  State<_VideoBody> createState() => _VideoBodyState();
}

class _VideoBodyState extends State<_VideoBody> {
  VideoPlayerController? _c;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final file = await (await AssetEntity.fromId(widget.assetId))?.file;
      if (file == null) throw StateError('no file');
      final c = VideoPlayerController.file(File(file.path));
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      await c.play();
      setState(() => _c = c);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return const Icon(Icons.error_outline, color: Colors.white54, size: 56);
    }
    final c = _c;
    if (c == null) return const CircularProgressIndicator(color: Colors.white);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: c.value.aspectRatio == 0 ? 16 / 9 : c.value.aspectRatio,
          child: GestureDetector(
            onTap: () => setState(() => c.value.isPlaying ? c.pause() : c.play()),
            child: VideoPlayer(c),
          ),
        ),
        VideoProgressIndicator(
          c,
          allowScrubbing: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: c,
          builder: (_, v, _) => IconButton(
            iconSize: 48,
            color: Colors.white,
            icon: Icon(v.isPlaying ? Icons.pause_circle : Icons.play_circle),
            onPressed: () => v.isPlaying ? c.pause() : c.play(),
          ),
        ),
      ],
    );
  }
}
