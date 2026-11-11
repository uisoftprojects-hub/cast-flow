import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/l10n.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../player/domain/cast_media.dart';
import '../../player/presentation/player_controller.dart';
import 'picker_body.dart';

/// Songs come from the system file picker: no storage permission needed.
class MusicScreen extends ConsumerWidget {
  const MusicScreen({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final files = [
      for (final f in await FilePicker.pickFiles(type: FileType.audio))
        if (f.path != null) f,
    ];
    if (files.isEmpty || !context.mounted) return;
    await castAndOpenRemote(context, ref, [
      for (final f in files)
        CastMedia(
          id: f.path!,
          title: f.name.replaceAll(RegExp(r'\.[a-z0-9]{2,4}$', caseSensitive: false), ''),
          subtitle: context.l10n.addMusic,
          kind: CastKind.music,
          seed: f.path.hashCode,
          url: f.path,
        ),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CastAppBar(title: context.l10n.castMusic),
      body: PickerBody(
        icon: Iconsax.music_square_search_copy,
        message: context.l10n.pickOneToSend,
        label: context.l10n.addMusic,
        onPick: () => _pick(context, ref),
      ),
    );
  }
}
