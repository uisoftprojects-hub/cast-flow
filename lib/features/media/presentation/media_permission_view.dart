import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/soft_card.dart';
import '../data/device_media_repository.dart';

/// Shown instead of a generic error when photo / video / music access is denied.
/// "Open App Settings" jumps to the system page; coming back from it re-checks
/// access automatically, so the user lands straight in their library.
class MediaPermissionView extends StatefulWidget {
  const MediaPermissionView({
    super.key,
    required this.icon,
    required this.onRetry,
  });

  final IconData icon;
  final VoidCallback onRetry;

  /// Use as `errorBuilder`: only permission errors get this view.
  static Widget? forError(Object error, IconData icon, VoidCallback onRetry) =>
      error is MediaPermissionDenied
      ? MediaPermissionView(icon: icon, onRetry: onRetry)
      : null;

  @override
  State<MediaPermissionView> createState() => _MediaPermissionViewState();
}

class _MediaPermissionViewState extends State<MediaPermissionView>
    with WidgetsBindingObserver {
  bool _openedSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _openedSettings) {
      _openedSettings = false;
      widget.onRetry();
    }
  }

  Future<void> _openSettings() async {
    _openedSettings = true;
    await PhotoManager.openSetting();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.xxxl,
          vertical: AppSpace.xxl,
        ),
        child:
            Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconBubble(
                      icon: widget.icon,
                      size: 88,
                      color: context.palette.primary,
                    ),
                    const SizedBox(height: AppSpace.xl),
                    Text(
                      l.permissionNeeded,
                      textAlign: TextAlign.center,
                      style: context.text.headlineSmall,
                    ),
                    const SizedBox(height: AppSpace.sm),
                    Text(
                      l.allowAccessToYour,
                      textAlign: TextAlign.center,
                      style: context.text.bodyMedium,
                    ),
                    const SizedBox(height: AppSpace.xxl),
                    GradientButton(
                      label: l.openAppSettings,
                      icon: Iconsax.setting_2_copy,
                      expand: true,
                      onPressed: _openSettings,
                    ),
                    const SizedBox(height: AppSpace.md),
                    TintedButton(
                      label: l.tryAgain,
                      icon: Iconsax.refresh_copy,
                      expand: true,
                      onPressed: widget.onRetry,
                    ),
                  ],
                )
                .animate()
                .fadeIn(duration: AppDurations.slow)
                .slideY(begin: 0.06, end: 0),
      ),
    );
  }
}
