import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/soft_card.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../devices/presentation/widgets/connection_guide_sheet.dart';

import '../../../core/l10n.dart';

const _sections = <(IconData, String, List<(String, String)>)>[
  (
    Iconsax.wifi_copy,
    'Wi-Fi',
    [
      (
        'Do my phone and TV need the same Wi-Fi?',
        'Yes. Discovery and casting stay on your local network, so both must be on the same Wi-Fi (same band names can still be different networks).',
      ),
      (
        'My router has “AP / client isolation”',
        'Isolation blocks devices from seeing each other. Turn it off in the router settings, or use a non-guest network.',
      ),
    ],
  ),
  (
    Iconsax.radar_2_copy,
    'Finding your TV',
    [
      (
        'My TV doesn’t appear in the list',
        'Turn on casting / screen mirroring on the TV, wake it from standby, then tap Rescan. Allow the Local Network permission if asked.',
      ),
      (
        'Only some devices show up',
        'Older TVs may need a firmware update. Miracast TVs only appear while their “Screen Mirroring” input is open.',
      ),
    ],
  ),
  (
    Iconsax.link_2_copy,
    'Connecting',
    [
      (
        'Connection fails or times out',
        'Restart the TV app or the TV, move closer to the router, and accept any prompt shown on the TV screen.',
      ),
      ('It keeps reconnecting to an old TV', 'Turn off “Auto-connect to last TV” in Settings → Casting.'),
    ],
  ),
  (
    Iconsax.screenmirroring_copy,
    'Screen mirroring',
    [
      ('Mirroring is laggy', 'Choose a lower quality (720p or 480p), close heavy apps and use a 5 GHz Wi-Fi network.'),
      ('The picture is rotated or cropped', 'Toggle Auto-rotate on the Screen Mirroring screen.'),
    ],
  ),
  (
    Iconsax.volume_high_copy,
    'Sound',
    [
      (
        'There is no sound on the TV',
        'Make sure Audio is on in Screen Mirroring and check Settings → Casting → Audio output. Some receivers don’t support phone audio.',
      ),
    ],
  ),
  (
    Iconsax.mobile_copy,
    'TV remote',
    [
      (
        'Some remote buttons are greyed out',
        'Each receiver supports different commands. Chromecast and DLNA only support playback and volume; Miracast has no remote channel.',
      ),
      (
        'Can CastFlow turn my TV on or change inputs?',
        'Only on TVs that expose those commands over the network. Unsupported buttons are disabled instead of pretending to work.',
      ),
    ],
  ),
];

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CastAppBar(title: context.l10n.helpFaq),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.xxxl),
        children: [
          for (final (icon, title, items) in _sections) ...[
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, bottom: AppSpace.sm, top: AppSpace.md),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: context.palette.primary),
                  const SizedBox(width: AppSpace.sm),
                  Text(context.tr(title), style: context.text.titleSmall),
                ],
              ),
            ),
            SoftCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (i, (q, a)) in items.indexed) ...[
                    if (i > 0) const Divider(indent: 16, endIndent: 16),
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: 2),
                        childrenPadding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
                        expandedAlignment: AlignmentDirectional.centerStart,
                        title: Text(context.tr(q), style: context.text.bodyLarge),
                        children: [Text(context.tr(a), style: context.text.bodyMedium)],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpace.xxl),
          TintedButton(
            label: context.l10n.stepByStepConnection,
            icon: Iconsax.book_copy,
            expand: true,
            onPressed: () => showConnectionGuide(context),
          ),
        ],
      ),
    );
  }
}
