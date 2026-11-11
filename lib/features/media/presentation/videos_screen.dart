import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../player/domain/cast_media.dart';
import '../../player/presentation/player_controller.dart';
import 'picker_body.dart';

/// Videos come from the system picker: no storage permission needed.
class VideosScreen extends ConsumerWidget {
  const VideosScreen({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final v = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (v == null || !context.mounted) return;
    await castAndOpenRemote(context, ref, [
      CastMedia(
        id: v.path,
        title: v.name.replaceAll(RegExp(r'\.[a-z0-9]{2,4}$', caseSensitive: false), ''),
        subtitle: context.l10n.video,
        kind: CastKind.video,
        seed: v.path.hashCode,
        url: v.path,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CastAppBar(title: context.l10n.castVideos),
      body: PickerBody(
        icon: Iconsax.video_add_copy,
        message: context.l10n.pickOneToSend,
        label: context.l10n.addVideos,
        onPick: () => _pick(context, ref),
      ),
    );
  }
}
