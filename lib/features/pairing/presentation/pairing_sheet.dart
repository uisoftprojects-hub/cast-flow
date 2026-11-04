import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/l10n.dart';
import '../../../core/navigation.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/effects.dart';
import 'pairing_controller.dart';

/// Opens the pairing sheet whenever a TV asks for a code or approval, and
/// closes it when pairing finishes. Swiping it away cancels pairing.
class PairingSheetHost extends ConsumerStatefulWidget {
  const PairingSheetHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<PairingSheetHost> createState() => _PairingSheetHostState();
}

class _PairingSheetHostState extends ConsumerState<PairingSheetHost> {
  bool _open = false;

  Future<void> _show() async {
    final context = rootNavigatorKey.currentContext;
    if (context == null || _open) return;
    _open = true;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const SafeArea(top: false, child: _PairingSheet()),
    );
    _open = false;
    // Dismissed by swipe / back while pairing was still running.
    if (ref.read(pairingProvider) != null) ref.read(pairingProvider.notifier).cancel();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pairingProvider, (prev, next) {
      if (prev == null && next != null) {
        _show();
      } else if (prev != null && next == null && _open) {
        rootNavigatorKey.currentState?.maybePop();
      }
    });
    return widget.child;
  }
}

class _PairingSheet extends ConsumerStatefulWidget {
  const _PairingSheet();

  @override
  ConsumerState<_PairingSheet> createState() => _PairingSheetState();
}

class _PairingSheetState extends ConsumerState<_PairingSheet> {
  final _field = TextEditingController();
  final _focus = FocusNode();
  int _shake = 0;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (ref.read(pairingProvider)?.phase == PairingPhase.cooldown && mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit(PairingUi ui) {
    if (_field.text.length == ui.codeLength) ref.read(pairingProvider.notifier).submitCode(_field.text);
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(pairingProvider);
    if (ui == null) return const SizedBox(height: 120);
    final l = context.l10n;
    final p = context.palette;
    final ctrl = ref.read(pairingProvider.notifier);

    ref.listen(pairingProvider, (prev, next) {
      if (next?.phase == PairingPhase.wrongCode && prev?.phase != PairingPhase.wrongCode) {
        // Shake, clear and refocus the first box.
        setState(() => _shake++);
        _field.clear();
        _focus.requestFocus();
      }
      if (next?.phase == PairingPhase.enterCode && prev?.phase != PairingPhase.enterCode) {
        _field.clear();
        _focus.requestFocus();
      }
    });

    final busy = ui.phase == PairingPhase.verifying;
    final codeMode =
        ui.isCode && const {PairingPhase.enterCode, PairingPhase.verifying, PairingPhase.wrongCode}.contains(ui.phase);

    final Widget body = switch (ui.phase) {
      PairingPhase.success => _Status(
        key: const ValueKey('ok'),
        icon: Icons.check_rounded,
        color: p.success,
        text: l.pairingPaired,
        pop: true,
      ),
      PairingPhase.timeout => _Retry(
        key: const ValueKey('timeout'),
        icon: Iconsax.timer_1_copy,
        text: l.pairingTimedOut,
        action: l.tryAgain,
        onAction: ctrl.restart,
      ),
      PairingPhase.rejected => _Retry(
        key: const ValueKey('rejected'),
        icon: Iconsax.close_circle_copy,
        text: l.pairingDeclined,
        action: l.tryAgain,
        onAction: ctrl.restart,
      ),
      PairingPhase.networkLost => _Retry(
        key: const ValueKey('net'),
        icon: Iconsax.wifi_square_copy,
        text: l.pairingNetworkLost,
        action: l.tryAgain,
        onAction: ctrl.restart,
      ),
      PairingPhase.failed => _Retry(
        key: const ValueKey('failed'),
        icon: Iconsax.danger_copy,
        text: l.pairingFailed,
        action: l.tryAgain,
        onAction: ctrl.restart,
      ),
      PairingPhase.cooldown => () {
        final left = ui.cooldownUntil == null
            ? 0
            : ui.cooldownUntil!.difference(DateTime.now()).inSeconds.clamp(0, 999);
        return _Retry(
          key: const ValueKey('cooldown'),
          icon: Iconsax.lock_1_copy,
          text: left > 0 ? l.pairingTooManyAttempts(left) : l.pairingCooldownOver,
          action: l.pairingRequestNewCode,
          onAction: left > 0 ? null : ctrl.restart,
        );
      }(),
      PairingPhase.approval => Column(
        key: const ValueKey('approval'),
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpace.md),
          PulseRipple(
            size: 140,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
              child: const Icon(Iconsax.monitor_copy, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Text(l.pairingApproveOnTv, textAlign: TextAlign.center, style: context.text.titleSmall),
        ],
      ),
      _ => Column(
        key: const ValueKey('code'),
        mainAxisSize: MainAxisSize.min,
        children: [
          _CodeBoxes(
            controller: _field,
            focusNode: _focus,
            length: ui.codeLength,
            hex: ui.hex,
            enabled: !busy,
            error: ui.phase == PairingPhase.wrongCode,
            onChanged: (_) {
              ctrl.clearError();
              setState(() {});
            },
            onComplete: () => _submit(ui),
          ).animate(key: ValueKey(_shake), target: _shake == 0 ? 0 : 1).shakeX(hz: 5, amount: 6, duration: 450.ms),
          AnimatedSize(
            duration: AppDurations.fast,
            child: ui.phase == PairingPhase.wrongCode
                ? Padding(
                    padding: const EdgeInsets.only(top: AppSpace.sm),
                    child: Text(l.pairingIncorrectCode, style: context.text.bodySmall?.copyWith(color: p.error)),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.xxl,
        0,
        AppSpace.xxl,
        AppSpace.xxl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Iconsax.monitor_copy, size: 18, color: p.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  ui.device.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Text(l.pairingRequired, style: context.text.headlineMedium),
          if (codeMode) ...[const SizedBox(height: 4), Text(l.pairingEnterCode, style: context.text.bodyMedium)],
          const SizedBox(height: AppSpace.xl),
          AnimatedSwitcher(duration: AppDurations.medium, child: body),
          const SizedBox(height: AppSpace.xl),
          if (codeMode)
            GradientButton(
              label: l.connect,
              expand: true,
              loading: busy,
              onPressed: _field.text.length == ui.codeLength && !busy ? () => _submit(ui) : null,
            ),
          if (ui.phase != PairingPhase.success) ...[
            const SizedBox(height: AppSpace.sm),
            TextButton(onPressed: ctrl.cancel, child: Text(l.cancel)),
          ],
        ],
      ),
    );
  }
}

/// OTP-style boxes over one hidden text field: auto-advance, backspace and
/// paste come from the field itself.
class _CodeBoxes extends StatelessWidget {
  const _CodeBoxes({
    required this.controller,
    required this.focusNode,
    required this.length,
    required this.hex,
    required this.enabled,
    required this.error,
    required this.onChanged,
    required this.onComplete,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final bool hex;
  final bool enabled;
  final bool error;
  final ValueChanged<String> onChanged;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    final text = controller.text;
    return Stack(
      children: [
        // Invisible input that receives typing and pastes.
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: Semantics(
              label: l.pairingCodeField(length),
              textField: true,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                enabled: enabled,
                maxLength: length,
                showCursor: false,
                enableInteractiveSelection: true,
                keyboardType: hex ? TextInputType.visiblePassword : TextInputType.number,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(hex ? r'[0-9a-fA-F]' : r'[0-9]')),
                  TextInputFormatter.withFunction((o, n) => n.copyWith(text: n.text.toUpperCase())),
                  LengthLimitingTextInputFormatter(length),
                ],
                decoration: const InputDecoration(counterText: '', border: InputBorder.none),
                onChanged: (v) {
                  onChanged(v);
                  if (v.length == length) onComplete();
                },
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: focusNode.requestFocus,
          child: Row(
            children: [
              for (var i = 0; i < length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpace.sm),
                Expanded(
                  child: Semantics(
                    label: l.pairingCodeBox(i + 1, length),
                    value: i < text.length ? text[i] : l.pairingEmptyBox,
                    excludeSemantics: true,
                    child: AnimatedContainer(
                      duration: AppDurations.fast,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          width: (i == text.length && focusNode.hasFocus) || error ? 2 : 1,
                          color: error ? p.error : (i == text.length && focusNode.hasFocus ? p.primary : p.divider),
                        ),
                      ),
                      child: Text(i < text.length ? text[i] : '', style: context.text.headlineSmall),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({super.key, required this.icon, required this.color, required this.text, this.pop = false});
  final IconData icon;
  final Color color;
  final String text;
  final bool pop;

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 44),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        pop
            ? circle.animate().scale(begin: const Offset(0.4, 0.4), curve: Curves.elasticOut, duration: 700.ms)
            : circle,
        const SizedBox(height: AppSpace.md),
        Text(text, style: context.text.titleMedium),
      ],
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({super.key, required this.icon, required this.text, required this.action, required this.onAction});
  final IconData icon;
  final String text;
  final String action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: p.error.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: Icon(icon, color: p.error, size: 32),
        ),
        const SizedBox(height: AppSpace.md),
        Text(text, textAlign: TextAlign.center, style: context.text.titleSmall),
        const SizedBox(height: AppSpace.lg),
        GradientButton(label: action, icon: Iconsax.refresh_copy, expand: true, onPressed: onAction),
      ],
    );
  }
}
