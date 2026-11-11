import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/selectors.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../player/domain/cast_media.dart';
import '../../player/presentation/player_controller.dart';
import 'picker_body.dart';

/// Photos come from the system Photo Picker: no storage permission needed.
class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref, {bool slideshow = false}) async {
    Duration? interval;
    if (slideshow) {
      interval = await showModalBottomSheet<Duration>(
        useRootNavigator: true,
        context: context,
        useSafeArea: true,
        builder: (_) => const SafeArea(top: false, child: _SlideshowSheet()),
      );
      if (interval == null || !context.mounted) return;
    }
    final files = await ImagePicker().pickMultiImage();
    if (files.isEmpty || !context.mounted) return;
    final queue = [
      for (final f in files)
        CastMedia(
          id: f.path,
          title: f.name.replaceAll(RegExp(r'\.[a-z0-9]{2,4}$', caseSensitive: false), ''),
          subtitle: context.l10n.photo2,
          kind: CastKind.photo,
          seed: f.path.hashCode,
          url: f.path,
        ),
    ];
    await castAndOpenRemote(context, ref, queue, slideshowInterval: interval);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CastAppBar(title: context.l10n.castPhotos),
      body: PickerBody(
        icon: Iconsax.gallery_add_copy,
        message: context.l10n.pickOneToSend,
        label: context.l10n.addPhotos,
        onPick: () => _pick(context, ref),
        secondaryLabel: context.l10n.slideshow,
        secondaryIcon: Iconsax.play_circle_copy,
        onSecondary: () => _pick(context, ref, slideshow: true),
      ),
    );
  }
}

enum _Transition { fade, slide, zoom }

class _SlideshowSheet extends StatefulWidget {
  const _SlideshowSheet();

  @override
  State<_SlideshowSheet> createState() => _SlideshowSheetState();
}

class _SlideshowSheetState extends State<_SlideshowSheet> {
  int _seconds = 5;
  _Transition _transition = _Transition.fade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.slideshow, style: context.text.headlineMedium),
          const SizedBox(height: AppSpace.xl),
          Text(context.l10n.interval, style: context.text.titleSmall),
          const SizedBox(height: AppSpace.sm),
          SegmentedPills<int>(
            values: const [3, 5, 10, 15],
            selected: _seconds,
            labelOf: (s) => '${s}s',
            onChanged: (s) => setState(() => _seconds = s),
          ),
          const SizedBox(height: AppSpace.xl),
          Text(context.l10n.transition, style: context.text.titleSmall),
          const SizedBox(height: AppSpace.sm),
          SegmentedPills<_Transition>(
            values: _Transition.values,
            selected: _transition,
            labelOf: (t) => switch (t) {
              _Transition.fade => context.l10n.fade,
              _Transition.slide => context.l10n.slide,
              _Transition.zoom => context.l10n.zoom,
            },
            onChanged: (t) => setState(() => _transition = t),
          ),
          const SizedBox(height: AppSpace.xxl),
          GradientButton(
            label: context.l10n.startSlideshow,
            icon: Iconsax.play_copy,
            expand: true,
            onPressed: () => Navigator.of(context).pop(Duration(seconds: _seconds)),
          ),
        ],
      ),
    );
  }
}
