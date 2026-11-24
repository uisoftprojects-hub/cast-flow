import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/buttons.dart';

import '../../../../core/l10n.dart';

typedef _Step = (IconData, String, String, Widget);

/// TV brands with their own walkthrough (menu names and prompts differ).
enum TvBrand {
  all('All TVs', 'Any smart TV', Iconsax.monitor_copy),
  samsung('Samsung', 'Smart TV (Tizen)', Iconsax.monitor_copy),
  lg('LG', 'webOS TV', Iconsax.monitor_copy),
  sony('Sony', 'Bravia · Google TV', Iconsax.monitor_copy),
  roku('Roku', 'Roku TV · Roku players', Iconsax.monitor_copy),
  androidTv('Android / Google TV', 'TCL · Hisense · Philips · Xiaomi · Shield', Iconsax.monitor_copy);

  const TvBrand(this.label, this.models, this.icon);
  final String label;
  final String models;
  final IconData icon;
}

const _scanStep = (
  Iconsax.radar_2_copy,
  'Scan for devices',
  'Open Devices in Cast to TV and wait a few seconds for your TV to appear.',
  _ScanVisual(),
);

const _allSteps = <_Step>[
  (
    Iconsax.wifi_copy,
    'Join the same Wi-Fi',
    'Connect your phone and your TV to the same Wi-Fi network.',
    _WifiVisual(),
  ),
  (
    Iconsax.monitor_copy,
    'Turn on casting on your TV',
    'Enable Screen Mirroring, Miracast or Google Cast in the TV settings.',
    _TvSettingVisual(),
  ),
  _scanStep,
  (
    Iconsax.tick_circle_copy,
    'Tap Connect',
    'Accept the prompt on your TV if one appears. That’s it!',
    _ConnectVisual(),
  ),
];

const _wifiStepAndroid = (
  Iconsax.wifi_copy,
  'Check the TV’s Wi-Fi',
  'On the TV open Settings › Network & Internet and join the same Wi-Fi as your phone.',
  _MenuVisual(
    path: 'Settings › Network & Internet',
    rows: [
      _MenuRow('Wi-Fi', value: 'Home Wi-Fi ✓', focus: true),
      _MenuRow('Network status', value: 'Connected'),
    ],
  ),
);

const _pinStep = (
  Iconsax.lock_copy,
  'Enter the code shown on the TV',
  'Tap your TV in Cast to TV. A code appears on the TV screen: type it on your phone to pair once.',
  _PinVisual(),
);

List<_Step> _stepsFor(TvBrand brand) => switch (brand) {
  TvBrand.all => _allSteps,
  TvBrand.samsung => const [
    (
      Iconsax.wifi_copy,
      'Check the TV’s Wi-Fi',
      'On the TV open Settings › General › Network and make sure it is on the same Wi-Fi as your phone.',
      _MenuVisual(
        path: 'Settings › General › Network',
        rows: [
          _MenuRow('Network Status', value: 'Home Wi-Fi ✓', focus: true),
          _MenuRow('Open Network Settings'),
          _MenuRow('Expert Settings'),
        ],
      ),
    ),
    (
      Iconsax.shield_tick_copy,
      'Let your phone connect',
      'Open Settings › General › External Device Manager › Device Connect Manager and set Access Notification to “First Time Only”.',
      _MenuVisual(
        path: 'General › External Device Manager › Device Connect Manager',
        rows: [
          _MenuRow('Device List'),
          _MenuRow('Access Notification', value: 'First Time Only', focus: true),
        ],
      ),
    ),
    _scanStep,
    (
      Iconsax.tick_circle_copy,
      'Tap Connect, then Allow',
      'Tap Connect. When the Samsung TV asks, choose Allow with the TV remote.',
      _ConnectVisual(),
    ),
  ],
  TvBrand.lg => const [
    (
      Iconsax.wifi_copy,
      'Check the TV’s Wi-Fi',
      'On the TV open Settings › All Settings › Network › Wi-Fi Connection and join the same Wi-Fi as your phone.',
      _MenuVisual(
        path: 'All Settings › Network',
        rows: [
          _MenuRow('Wi-Fi Connection', value: 'Home Wi-Fi ✓', focus: true),
          _MenuRow('Wired Connection (Ethernet)'),
        ],
      ),
    ),
    (
      Iconsax.shield_tick_copy,
      'Let your phone connect',
      'Open Settings › General › Devices › External Devices › TV On With Mobile and turn on “Turn on via Wi-Fi”.',
      _MenuVisual(
        path: 'General › Devices › External Devices',
        rows: [_MenuRow('TV On With Mobile', focus: true), _MenuRow('Turn on via Wi-Fi', on: true)],
      ),
    ),
    _scanStep,
    (
      Iconsax.tick_circle_copy,
      'Tap Connect, then Allow',
      'Tap Connect. When the LG TV asks, choose Allow with the Magic Remote.',
      _ConnectVisual(),
    ),
  ],
  TvBrand.sony => const [
    _wifiStepAndroid,
    (
      Iconsax.setting_2_copy,
      'Let your phone wake the TV',
      'Turn on “Remote start” in Settings › Network & Internet so the TV answers your phone while it is asleep.',
      _MenuVisual(
        path: 'Settings › Network & Internet',
        rows: [_MenuRow('Wi-Fi'), _MenuRow('Remote start', on: true, focus: true)],
      ),
    ),
    _scanStep,
    _pinStep,
  ],
  TvBrand.roku => const [
    (
      Iconsax.wifi_copy,
      'Check the Roku’s Wi-Fi',
      'On the Roku open Settings › Network › About and check it is connected to the same Wi-Fi as your phone.',
      _MenuVisual(
        path: 'Settings › Network › About',
        rows: [
          _MenuRow('Status', value: 'Connected ✓', focus: true),
          _MenuRow('Network name', value: 'Home Wi-Fi'),
        ],
      ),
    ),
    (
      Iconsax.shield_tick_copy,
      'Allow control from apps',
      'Open Settings › System › Advanced system settings › Control by mobile apps › Network access and choose Default (or Permissive).',
      _MenuVisual(
        path: 'System › Advanced system settings › Control by mobile apps',
        rows: [
          _MenuRow('Network access', value: 'Default', focus: true),
          _MenuRow('Disabled'),
        ],
      ),
    ),
    _scanStep,
    (
      Iconsax.tick_circle_copy,
      'Tap Connect',
      'Tap your Roku, then Connect. Roku does not ask for a code or permission, so it connects right away.',
      _ConnectVisual(prompt: false),
    ),
  ],
  TvBrand.androidTv => const [
    _wifiStepAndroid,
    (
      Iconsax.setting_2_copy,
      'Turn on the remote service',
      'Open Settings › Apps › Show system apps › Android TV Remote Service and make sure it is enabled.',
      _MenuVisual(
        path: 'Settings › Apps › System apps',
        rows: [
          _MenuRow('Android TV Remote Service', value: 'Enabled', focus: true),
          _MenuRow('Chromecast built-in'),
        ],
      ),
    ),
    _scanStep,
    _pinStep,
  ],
};

Future<void> showConnectionGuide(BuildContext context, {TvBrand brand = TvBrand.all}) {
  return showModalBottomSheet<void>(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => SafeArea(top: false, child: ConnectionGuideSheet(initialBrand: brand)),
  );
}

/// "How to connect": four illustrated steps, each with a small animated
/// picture of what the user should see on the phone and the TV. A brand picker
/// at the top swaps in that brand's own steps (menu names, prompts, codes).
class ConnectionGuideSheet extends StatefulWidget {
  const ConnectionGuideSheet({super.key, this.initialBrand = TvBrand.all});

  final TvBrand initialBrand;

  @override
  State<ConnectionGuideSheet> createState() => _ConnectionGuideSheetState();
}

class _ConnectionGuideSheetState extends State<ConnectionGuideSheet> {
  late TvBrand _brand = widget.initialBrand;

  @override
  Widget build(BuildContext context) {
    final steps = _stepsFor(_brand);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(AppSpace.xl, 0, AppSpace.xl, AppSpace.xxl),
        children: [
          Text(context.l10n.howToConnect, style: context.text.headlineMedium),
          const SizedBox(height: AppSpace.xs),
          Text(
            _brand == TvBrand.all ? context.l10n.fourQuickStepsTo : '${_brand.label} · ${context.tr(_brand.models)}',
            style: context.text.bodyMedium,
          ),
          const SizedBox(height: AppSpace.md),
          _BrandChips(selected: _brand, onSelected: (b) => setState(() => _brand = b)),
          const SizedBox(height: AppSpace.lg),
          AnimatedSwitcher(
            duration: AppDurations.medium,
            child: Column(
              key: ValueKey(_brand),
              children: [
                for (final (i, (icon, title, body, visual)) in steps.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpace.lg),
                    child: _StepCard(
                      number: i + 1,
                      icon: icon,
                      title: context.tr(title),
                      body: context.tr(body),
                      visual: visual,
                    ),
                  ),
              ],
            ),
          ),
          if (_brand != TvBrand.all)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.lg),
              child: Text(
                context.tr('Menu names can differ a little by model and year.'),
                style: context.text.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          GradientButton(label: context.l10n.gotIt, expand: true, onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

/// Brand picker: "All TVs" first, then the brands with their own guide. Wraps onto
/// a second row so every brand is visible without scrolling sideways.
class _BrandChips extends StatelessWidget {
  const _BrandChips({required this.selected, required this.onSelected});

  final TvBrand selected;
  final ValueChanged<TvBrand> onSelected;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Wrap(
      spacing: AppSpace.sm,
      runSpacing: AppSpace.sm,
      children: [
        for (final b in TvBrand.values)
          Semantics(
            button: true,
            selected: b == selected,
            label: b.label,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              onTap: () => onSelected(b),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: b == selected ? AppColors.mainGradient : null,
                  color: b == selected ? null : p.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: b == selected ? Colors.transparent : p.divider),
                ),
                child: Text(
                  b == TvBrand.all ? context.tr(b.label) : b.label,
                  style: context.text.labelLarge?.copyWith(color: b == selected ? Colors.white : p.textPrimary),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
    required this.visual,
  });

  final int number;
  final IconData icon;
  final String title;
  final String body;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      container: true,
      label: context.l10n.step(number, title, body),
      child: ExcludeSemantics(
        child: Container(
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: p.divider),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 168,
                color: p.primaryTint,
                alignment: Alignment.center,
                child: FittedBox(
                  child: Padding(padding: const EdgeInsets.all(AppSpace.md), child: visual),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(gradient: AppColors.mainGradient, shape: BoxShape.circle),
                      child: Text('$number', style: context.text.labelLarge?.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, size: 18, color: p.primary),
                              const SizedBox(width: 6),
                              Expanded(child: Text(title, style: context.text.titleSmall)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(body, style: context.text.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small drawn devices shared by the step pictures.

const _bezel = Color(0xFF1B1D2E);
const _tvScreen = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF2A2E4A), Color(0xFF0E1022)],
);

class _Phone extends StatelessWidget {
  const _Phone({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 140,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: _bezel, borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // Long translations (e.g. Arabic) shrink to fit instead of overflowing.
        child: ColoredBox(
          color: context.palette.surface,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 66), child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tv extends StatelessWidget {
  const _Tv({required this.child, this.width = 150});
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: width * 0.6,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: _bezel, borderRadius: BorderRadius.circular(8)),
          child: Container(
            decoration: BoxDecoration(gradient: _tvScreen, borderRadius: BorderRadius.circular(5)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width - 12),
                child: child,
              ),
            ),
          ),
        ),
        Container(width: 10, height: 8, color: const Color(0xFF2B2E45)),
        Container(
          width: width * 0.36,
          height: 5,
          decoration: BoxDecoration(color: const Color(0xFF2B2E45), borderRadius: BorderRadius.circular(3)),
        ),
      ],
    );
  }
}

class _WifiTag extends StatelessWidget {
  const _WifiTag({this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = dark ? Colors.white : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: dark ? Colors.white12 : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      // Shrinks to fit the phone or TV screen in any language.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.wifi_copy, size: 10, color: color),
            const SizedBox(width: 3),
            Text(
              context.l10n.homeWiFi,
              maxLines: 1,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// Step 1: phone and TV both on "Home Wi-Fi", with the router between them.
class _WifiVisual extends StatelessWidget {
  const _WifiVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Phone(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.wifi_copy, size: 26, color: p.primary),
              const SizedBox(height: 6),
              const _WifiTag(),
              const SizedBox(height: 4),
              Icon(Icons.check_circle_rounded, size: 14, color: p.success),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.wifi_copy,
              size: 30,
              color: AppColors.primary,
            ).animate(onPlay: (c) => context.loopMotion(c, reverse: true)).fade(begin: 0.35, end: 1, duration: 800.ms),
            const SizedBox(height: 4),
            Container(
              width: 46,
              height: 16,
              decoration: BoxDecoration(color: _bezel, borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: const BoxDecoration(color: Color(0xFF3DDC97), shape: BoxShape.circle),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(context.l10n.router, style: context.text.labelSmall),
          ],
        ),
        const SizedBox(width: 14),
        _Tv(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.wifi_copy, size: 24, color: Colors.white),
              const SizedBox(height: 6),
              const _WifiTag(dark: true),
              const SizedBox(height: 4),
              Icon(Icons.check_circle_rounded, size: 14, color: p.success),
            ],
          ),
        ),
      ],
    );
  }
}

// Step 2: the TV's settings with Screen Mirroring switched on.
class _TvSettingVisual extends StatelessWidget {
  const _TvSettingVisual();

  @override
  Widget build(BuildContext context) {
    Widget row(IconData icon, String label, {bool on = false}) => Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: on ? Colors.white : Colors.white10, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 12, color: on ? AppColors.primary : Colors.white70),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: on ? AppColors.primary : Colors.white70,
              ),
            ),
          ),
          if (on)
            Container(
              width: 24,
              height: 13,
              padding: const EdgeInsets.all(2),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(gradient: AppColors.mainGradient, borderRadius: BorderRadius.circular(8)),
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );

    return _Tv(
      width: 230,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.settingsConnection,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 6),
            row(Iconsax.monitor_copy, context.l10n.inputHdmi1),
            row(Iconsax.screenmirroring_copy, context.l10n.screenMirroring, on: true)
                .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 700.ms),
            row(Iconsax.wifi_copy, context.l10n.networkHomeWiFi),
          ],
        ),
      ),
    );
  }
}

// Step 3: Cast to TV scanning, with the TV showing up in the list.
class _ScanVisual extends StatelessWidget {
  const _ScanVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Phone(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                const SizedBox(height: 4),
                SizedBox(
                  width: 54,
                  height: 54,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: p.primary, width: 2),
                            ),
                          )
                          .animate(onPlay: (c) => context.loopMotion(c))
                          .scale(begin: const Offset(0.3, 0.3), end: const Offset(1, 1), duration: 1400.ms)
                          .fadeOut(duration: 1400.ms),
                      Icon(Iconsax.radar_2_copy, size: 22, color: p.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.primaryTint,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: p.primary),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.monitor_copy, size: 10, color: p.primary),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          context.l10n.livingRoomTv,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: p.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ).animate(onPlay: (c) => context.loopMotion(c, reverse: true)).fadeIn(duration: 900.ms),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 4; i++)
              Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                  )
                  .animate(onPlay: (c) => context.loopMotion(c, reverse: true), delay: (150 * i).ms)
                  .fade(begin: 0.2, end: 1, duration: 600.ms),
          ],
        ),
        const SizedBox(width: 18),
        const _Tv(
          child: Center(child: Icon(Iconsax.screenmirroring_copy, size: 30, color: Colors.white)),
        ),
      ],
    );
  }
}

// Step 4: tap Connect on the phone, then Allow on the TV if it asks.
class _ConnectVisual extends StatelessWidget {
  const _ConnectVisual({this.prompt = true});

  /// The TV asks "Allow?" (most TVs). Roku doesn't: it just shows connected.
  final bool prompt;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Phone(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.monitor_copy, size: 24, color: p.primary),
                const SizedBox(height: 4),
                Text(
                  context.l10n.livingRoomTv,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: p.textPrimary),
                ),
                const SizedBox(height: 8),
                Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: AppColors.mainGradient,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        context.l10n.connect,
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    )
                    .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(0.9, 0.9), duration: 700.ms),
                const SizedBox(height: 2),
                const Icon(Icons.touch_app_rounded, size: 18, color: Color(0xFFFFB020)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 22),
        _Tv(
          child: Center(
            child: prompt
                ? _AllowPrompt()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 34, color: Color(0xFF3DDC97)),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.connected,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// The TV's "Allow Cast to TV to connect?" dialog, with Allow pulsing.
class _AllowPrompt extends StatelessWidget {
  const _AllowPrompt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.allowCastflowToConnect,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: Color(0xFF1B1D2E)),
          ),
          const SizedBox(height: 5),
          // Long translations shrink to fit the little dialog instead of overflowing.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.deny, style: const TextStyle(fontSize: 7, color: Color(0xFF8A8FA8))),
                const SizedBox(width: 14),
                Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: AppColors.mainGradient,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        context.l10n.allow,
                        style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    )
                    .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.12, 1.12), duration: 700.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One line of a TV settings menu: a label, an optional value, or an on/off switch.
class _MenuRow {
  const _MenuRow(this.label, {this.value, this.on, this.focus = false});

  final String label;
  final String? value;

  /// Non-null: the row is a switch, shown on or off.
  final bool? on;

  /// The row the remote's cursor is on (highlighted, gently pulsing).
  final bool focus;
}

/// A TV screen showing one settings menu: the path at the top and the rows to
/// look at, with the one to open or switch highlighted. Drawn, not a photo, so
/// it stays sharp in light and dark and every language.
class _MenuVisual extends StatelessWidget {
  const _MenuVisual({required this.path, required this.rows});

  final String path;
  final List<_MenuRow> rows;

  @override
  Widget build(BuildContext context) {
    Widget row(_MenuRow r) {
      final on = r.focus;
      final line = Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(color: on ? Colors.white : Colors.white10, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                r.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: on ? const Color(0xFF1B1D2E) : Colors.white70,
                ),
              ),
            ),
            if (r.value != null) ...[
              const SizedBox(width: 6),
              Text(
                r.value!,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: on ? AppColors.primary : Colors.white54,
                ),
              ),
            ],
            if (r.on != null) ...[
              const SizedBox(width: 6),
              Container(
                width: 24,
                height: 13,
                padding: const EdgeInsets.all(2),
                alignment: r.on! ? Alignment.centerRight : Alignment.centerLeft,
                decoration: BoxDecoration(
                  gradient: r.on! ? AppColors.mainGradient : null,
                  color: r.on! ? null : Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ],
          ],
        ),
      );
      return on
          ? line
                .animate(onPlay: (c) => context.loopMotion(c, reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.04, 1.04), duration: 700.ms)
          : line;
    }

    return _Tv(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              path,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 6),
            for (final r in rows) row(r),
          ],
        ),
      ),
    );
  }
}

/// Android TV / Google TV pairing: a code on the TV, typed on the phone.
class _PinVisual extends StatelessWidget {
  const _PinVisual();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const code = ['4', '8', '2', '9', '1', '7'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Phone(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.lock_copy, size: 18, color: p.primary),
                const SizedBox(height: 6),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 2,
                  runSpacing: 2,
                  children: [
                    for (final (i, d) in code.indexed)
                      Container(
                            width: 14,
                            height: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: p.primaryTint,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: p.primary),
                            ),
                            child: Text(
                              d,
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: p.textPrimary),
                            ),
                          )
                          .animate(onPlay: (c) => context.loopMotion(c), delay: (160 * i).ms)
                          .fadeIn(duration: 250.ms)
                          .then(delay: 1400.ms)
                          .fadeOut(duration: 200.ms),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.mainGradient,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    context.l10n.connect,
                    style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 22),
        _Tv(
          child: Center(
            child: Container(
              width: 112,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('Pairing code'),
                    style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: Color(0xFF8A8FA8)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    code.join(' '),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: Color(0xFF1B1D2E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
