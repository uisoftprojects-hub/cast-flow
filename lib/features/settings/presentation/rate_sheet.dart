import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import 'feedback.dart';

/// 5-star rating sheet. In [exit] mode (back on Home) its button reads
/// "Tap to exit" until a star is filled, and goes back to it when all stars
/// are cleared. 1–3 stars → feedback, 4–5 stars → store rating.
Future<void> showRateSheet(BuildContext context, {bool exit = false}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    builder: (_) => SafeArea(top: false, child: _RateSheet(exit: exit)),
  );
}

class _RateSheet extends ConsumerStatefulWidget {
  const _RateSheet({required this.exit});
  final bool exit;

  @override
  ConsumerState<_RateSheet> createState() => _RateSheetState();
}

class _RateSheetState extends ConsumerState<_RateSheet> {
  int _rating = 0;

  /// Stars lit by the one-time intro animation (not the user's rating).
  int _intro = 0;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    // One-time hint: fill all five stars within 0.5 s, then clear.
    for (var i = 1; i <= 5; i++) {
      _timers.add(Timer(Duration(milliseconds: 100 * i), () => mounted ? setState(() => _intro = i) : null));
    }
    _timers.add(Timer(const Duration(milliseconds: 800), () => mounted ? setState(() => _intro = 0) : null));
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  void _tap(int star) {
    for (final t in _timers) {
      t.cancel();
    }
    setState(() {
      _intro = 0;
      // Tapping the current rating's last star clears one step, so the user
      // can unfill all stars.
      _rating = star == _rating ? star - 1 : star;
    });
  }

  Future<void> _primary() async {
    final nav = Navigator.of(context);
    if (_rating == 0) {
      if (widget.exit) SystemNavigator.pop();
      return;
    }
    nav.pop();
    if (_rating <= 3) {
      await sendFeedback(context, ref, rating: _rating);
    } else {
      await rateOnStore(context, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final lit = _intro > 0 ? _intro : _rating;
    final (IconData face, Color tone, String title) = switch (_rating) {
      0 => (Iconsax.heart_copy, p.primary, 'Enjoying CastFlow?'),
      1 || 2 => (Iconsax.emoji_sad_copy, p.error, 'Sorry to hear that'),
      3 => (Iconsax.emoji_normal_copy, p.warning, 'Thanks! How can we improve?'),
      _ => (Iconsax.emoji_happy_copy, p.success, 'We’re glad you like it!'),
    };
    final label = switch (_rating) {
      0 => widget.exit ? 'Tap to exit' : 'Select a rating',
      <= 3 => 'Send feedback',
      _ => 'Rate us',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: AppDurations.medium,
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: Container(
              key: ValueKey(face),
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: tone.withValues(alpha: 0.14), shape: BoxShape.circle),
              child: Icon(face, size: 36, color: tone),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Text(title, style: context.text.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            widget.exit ? 'Rate your experience before you go.' : 'Tap a star to rate CastFlow.',
            style: context.text.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpace.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                Semantics(
                  button: true,
                  label: '$i star${i == 1 ? '' : 's'}',
                  selected: i <= _rating,
                  child: GestureDetector(
                    onTap: () => _tap(i),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: i <= lit ? 1.12 : 1,
                        child: Icon(
                          i <= lit ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 44,
                          color: i <= lit ? const Color(0xFFF5B301) : p.divider,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.xl),
          AnimatedSwitcher(
            duration: AppDurations.fast,
            child: GradientButton(
              key: ValueKey(label),
              label: label,
              expand: true,
              onPressed: _rating == 0 && !widget.exit ? null : _primary,
            ),
          ),
        ],
      ),
    );
  }
}
