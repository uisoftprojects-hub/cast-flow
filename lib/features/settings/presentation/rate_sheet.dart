import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/buttons.dart';
import 'feedback.dart';

import '../../../core/l10n.dart';

/// 5-star rating sheet. In [exit] mode (back on Home) its button reads
/// "Tap to exit" until a star is filled, and goes back to it when all stars
/// are cleared. 1–3 stars → feedback, 4–5 stars → store rating.
Future<void> showRateSheet(BuildContext context, {bool exit = false}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => SafeArea(
      top: false,
      child: SingleChildScrollView(child: _RateSheet(exit: exit)),
    ),
  );
}

/// Same rating panel as a centered popup (Settings → Rate app).
Future<void> showRateDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppSpace.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close_rounded, color: context.palette.textSecondary),
              ),
            ),
            const _RateSheet(exit: false),
          ],
        ),
      ),
    ),
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
    final analytics = ref.read(analyticsProvider);
    if (_rating == 0) {
      if (widget.exit) SystemNavigator.pop();
      return;
    }
    analytics.log(AnalyticsEvent.rateSubmit, {
      AnalyticsParam.rating: _rating,
      AnalyticsParam.source: widget.exit ? 'home_back' : 'settings',
    });
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
    final (String face, Color tone, String title) = switch (_rating) {
      0 => ('🤩', p.primary, context.l10n.enjoyingCastflow),
      1 => ('😞', p.error, context.l10n.sorryToHearThat),
      2 => ('🙁', p.error, context.l10n.sorryToHearThat),
      3 => ('😐', p.warning, context.l10n.thanksHowCanWe),
      4 => ('😊', p.success, context.l10n.wereGladYouLike),
      _ => ('😍', p.success, context.l10n.youMadeOurDay),
    };
    final label = switch (_rating) {
      0 => widget.exit ? context.l10n.tapToExit : context.l10n.selectARating,
      <= 3 => context.l10n.sendFeedback,
      _ => context.l10n.rateUs,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.xxl, 0, AppSpace.xxl, AppSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: AppDurations.medium,
            transitionBuilder: (c, a) => ScaleTransition(
              scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
              child: c,
            ),
            child: Container(
              key: ValueKey(face),
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: tone.withValues(alpha: 0.14), shape: BoxShape.circle),
              child: ExcludeSemantics(child: Text(face, style: const TextStyle(fontSize: 46, height: 1.1))),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Text(title, style: context.text.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            widget.exit ? context.l10n.rateYourExperienceBefore : context.l10n.tapAStarTo,
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
