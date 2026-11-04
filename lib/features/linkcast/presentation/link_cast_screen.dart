import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/soft_card.dart';
import '../../devices/presentation/widgets/connection_chip.dart';
import '../../player/domain/cast_media.dart';
import '../../player/presentation/player_controller.dart';

import '../../../core/l10n.dart';

class LinkCastScreen extends ConsumerStatefulWidget {
  const LinkCastScreen({super.key});

  @override
  ConsumerState<LinkCastScreen> createState() => _LinkCastScreenState();
}

class _LinkCastScreenState extends ConsumerState<LinkCastScreen> {
  final _ctrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) setState(() => _ctrl.text = data!.text!.trim());
  }

  void _castLink() {
    final uri = Uri.tryParse(_ctrl.text.trim());
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https') || uri.isScheme('rtsp')) || uri.host.isEmpty) {
      setState(() => _error = context.l10n.enterAValidHttp);
      return;
    }
    setState(() => _error = null);
    final name = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : uri.host;
    _cast(name, uri.toString());
  }

  void _cast(String title, String url) {
    castAndOpenRemote(context, ref, [
      CastMedia(
        id: url,
        title: title,
        subtitle: context.l10n.linkStream,
        kind: CastKind.link,
        seed: url.hashCode,
        duration: const Duration(hours: 1),
        url: url,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      appBar: CastAppBar(title: context.l10n.iptvLinkCast),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.xxxl),
        children: [
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.castALink, style: context.text.titleLarge),
                const SizedBox(height: 4),
                Text(context.l10n.pasteADirectVideo, style: context.text.bodySmall),
                const SizedBox(height: AppSpace.lg),
                TextField(
                  controller: _ctrl,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  onSubmitted: (_) => _castLink(),
                  decoration: InputDecoration(
                    fillColor: p.surfaceHigh,
                    hintText: 'https://…/stream.m3u8',
                    prefixIcon: Icon(Iconsax.link_2_copy, color: p.textSecondary, size: 20),
                    suffixIcon: IconButton(
                      tooltip: context.l10n.paste,
                      onPressed: _paste,
                      icon: Icon(Iconsax.document_copy, color: p.primary, size: 20),
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpace.sm),
                  Text(
                    _error!,
                    style: context.text.bodySmall?.copyWith(color: p.error),
                  ).animate().fadeIn().shakeX(hz: 3, amount: 3),
                ],
                const SizedBox(height: AppSpace.lg),
                GradientButton(
                  label: context.l10n.castLink,
                  icon: Iconsax.screenmirroring_copy,
                  expand: true,
                  onPressed: _castLink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
