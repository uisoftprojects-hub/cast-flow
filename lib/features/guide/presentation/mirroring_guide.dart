part of 'guide_screen.dart';

/// Step-by-step visual help for screen mirroring ("Still need help?").
final mirroringGuides = [
  const _Guide('Join the same Wi-Fi', _ConnectVisual(), [
    'Connect your phone to Wi-Fi.',
    'On the TV, open Settings → Network and join the same Wi-Fi.',
    'Guest or office networks often block mirroring; use your home Wi-Fi or your phone’s hotspot.',
  ]),
  const _Guide('Turn off VPN', _VpnVisual(), [
    'A VPN hides your TV from your phone.',
    'Pause or disconnect your VPN app before you start.',
    'You can turn it back on when you’re done.',
  ]),
  const _Guide('Turn on mirroring on the TV', _TvInputVisual(), [
    'Samsung, LG and most Android TVs accept mirroring automatically.',
    'Other TVs: open Input / Source and pick Screen Mirroring or Miracast.',
    'Keep the TV on that screen while your phone connects.',
  ]),
  const _Guide('Tap Start and pick your TV', _PickerVisual(), [
    'Tap Start on the Screen Mirroring screen.',
    'Android opens Smart View / Cast. Tap your TV in the list.',
    'If the TV asks, choose Allow or enter the PIN shown on screen.',
  ]),
  const _Guide('You’re mirroring', OnboardingScene(kind: SceneKind.mirror, size: 230), [
    'Everything on your phone now shows on the TV.',
    'Turn the phone sideways for full-screen videos and games.',
    'To stop, tap Stop or use the cast notification.',
  ]),
];

class _VpnVisual extends StatelessWidget {
  const _VpnVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 74,
          height: 132,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: const Color(0xFF1B1D2E), borderRadius: BorderRadius.circular(18)),
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.mainGradient, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Iconsax.shield_slash_copy, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(width: AppSpace.lg),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: AppShadows.soft(p),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(context.l10n.vpn, style: context.text.titleSmall),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 22,
                        padding: const EdgeInsets.all(3),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(color: p.divider, borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                )
                .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.06, 1.06), duration: 800.ms),
            const SizedBox(height: 10),
            Text(context.l10n.off, style: context.text.labelMedium?.copyWith(color: p.success)),
          ],
        ),
      ],
    );
  }
}

class _TvInputVisual extends StatelessWidget {
  const _TvInputVisual();

  @override
  Widget build(BuildContext context) {
    Widget tile(IconData icon, String label, {bool on = false}) => Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: on ? Colors.white : Colors.white12, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Icon(icon, size: 18, color: on ? AppColors.primary : Colors.white70),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: on ? AppColors.primary : Colors.white70),
          ),
        ],
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 240,
          height: 140,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: const Color(0xFF1B1D2E), borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF23263A), Color(0xFF0B0D1A)]),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tile(Iconsax.monitor_copy, context.l10n.hdmi1),
                tile(Iconsax.screenmirroring_copy, 'Screen\nMirroring', on: true)
                    .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 700.ms),
                tile(Iconsax.monitor_copy, context.l10n.hdmi2),
              ],
            ),
          ),
        ),
        Container(width: 14, height: 12, color: const Color(0xFF2B2E45)),
        Container(
          width: 80,
          height: 6,
          decoration: BoxDecoration(color: const Color(0xFF2B2E45), borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }
}

class _PickerVisual extends StatelessWidget {
  const _PickerVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget row(String name, {bool on = false}) {
      final r = Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: on ? p.primaryTint : p.background,
          borderRadius: BorderRadius.circular(10),
          border: on ? Border.all(color: p.primary, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Icon(Iconsax.monitor_copy, size: 16, color: on ? p.primary : p.textSecondary),
            const SizedBox(width: 8),
            Text(name, style: context.text.labelMedium),
          ],
        ),
      );
      return on
          ? r
                .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.04, 1.04), duration: 700.ms)
          : r;
    }

    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.soft(p),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Iconsax.screenmirroring_copy, size: 18, color: p.primary),
              const SizedBox(width: 6),
              Text(context.l10n.smartView, style: context.text.titleSmall),
            ],
          ),
          row(context.l10n.livingRoomTv, on: true),
          row(context.l10n.bedroomTv),
          row(context.l10n.officeDisplay),
        ],
      ),
    );
  }
}
