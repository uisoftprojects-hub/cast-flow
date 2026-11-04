import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/tap_scale.dart';

/// Photos / Videos / Music shortcuts as three compact tiles. Shown on
/// screens that otherwise have nothing to cast, so the user can still start
/// casting from their own media.
class MediaShortcuts extends StatelessWidget {
  const MediaShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (Iconsax.gallery_copy, l.photos, '/photos', AppColors.primary),
      (Iconsax.video_play_copy, l.videos, '/videos', const Color(0xFFFF7A59)),
      (Iconsax.music_copy, l.music, '/music', const Color(0xFF12B886)),
    ];
    return Row(
      children: [
        for (final (i, (icon, label, route, color)) in items.indexed) ...[
          if (i > 0) const SizedBox(width: AppSpace.sm),
          Expanded(
            child: TapScale(
              onTap: () => context.push(route),
              semanticLabel: context.l10n.cast(label),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: context.palette.divider),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconBubble(icon: icon, color: color, size: 36, filled: true),
                    const SizedBox(height: 6),
                    Text(label, style: context.text.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
