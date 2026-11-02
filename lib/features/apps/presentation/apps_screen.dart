import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/soft_card.dart';
import '../../devices/presentation/widgets/connection_chip.dart';

class _App {
  const _App(this.name, this.icon, this.color, this.route);
  final String name;
  final IconData icon;
  final Color color;
  final String route;
}

String _web(String url) => '/web?url=${Uri.encodeComponent(url)}';

/// Every supported app. Each opens in the built-in browser, where videos on
/// the page can be cast; IPTV / Link opens the link caster.
final _apps = [
  _App('YouTube', Iconsax.youtube_copy, const Color(0xFFE62117), _web('https://m.youtube.com')),
  _App('Facebook', Iconsax.facebook_copy, const Color(0xFF1877F2), _web('https://m.facebook.com/watch')),
  _App('Instagram', Iconsax.instagram_copy, const Color(0xFFE1306C), _web('https://www.instagram.com')),
  _App('Google', Iconsax.google_copy, const Color(0xFF4285F4), _web('https://www.google.com')),
  _App('Google Photos', Iconsax.gallery_favorite_copy, const Color(0xFFFBBC04), _web('https://photos.google.com')),
  _App('Google Drive', Iconsax.google_drive, const Color(0xFF0F9D58), _web('https://drive.google.com')),
  _App('Vimeo', Iconsax.video_circle_copy, const Color(0xFF1AB7EA), _web('https://vimeo.com')),
  _App('Dailymotion', Iconsax.video_square_copy, const Color(0xFF0066DC), _web('https://www.dailymotion.com')),
  _App('Twitch', Iconsax.twitch_copy, const Color(0xFF9146FF), _web('https://m.twitch.tv')),
  const _App('IPTV / Link', Iconsax.link_2_copy, Color(0xFFF59E0B), '/link'),
];

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CastAppBar(title: 'Apps'),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, AppSpace.xxxl),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisSpacing: AppSpace.md,
          crossAxisSpacing: AppSpace.md,
          mainAxisExtent: 112 + MediaQuery.textScalerOf(context).scale(20),
        ),
        itemCount: _apps.length,
        itemBuilder: (context, i) {
          final a = _apps[i];
          return SoftCard(
            padding: const EdgeInsets.all(AppSpace.md),
            onTap: () => context.push(a.route),
            semanticLabel: 'Open ${a.name}',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: a.color,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: AppShadows.glow(a.color),
                  ),
                  child: Icon(a.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  a.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.text.labelMedium,
                ),
              ],
            ),
          ).animate(delay: (30 * i).ms).fadeIn(duration: 250.ms).scale(begin: const Offset(0.94, 0.94));
        },
      ),
    );
  }
}
