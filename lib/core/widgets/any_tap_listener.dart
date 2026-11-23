import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Calls [onTap] once for every tap anywhere inside [child], without taking part
/// in (or interfering with) the gestures of what is underneath. A tap is one
/// finger that goes down and up quickly without moving: scrolls, drags, long
/// presses and multi-finger gestures don't count.
class AnyTapListener extends StatefulWidget {
  const AnyTapListener({super.key, required this.onTap, required this.child});

  /// Runs after the tapped widget has handled its own tap (so a screen change
  /// or a dialog the tap caused is already in place).
  final VoidCallback onTap;
  final Widget child;

  /// Longest press that is still a tap.
  static const maxDuration = Duration(milliseconds: 350);

  @override
  State<AnyTapListener> createState() => _AnyTapListenerState();
}

class _AnyTapListenerState extends State<AnyTapListener> {
  final _down = <int, ({Offset at, Duration time})>{};
  var _fingers = 0;
  var _multi = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (e) {
        _fingers++;
        if (_fingers > 1) _multi = true;
        _down[e.pointer] = (at: e.position, time: e.timeStamp);
      },
      onPointerUp: (e) {
        final start = _down.remove(e.pointer);
        _fingers = (_fingers - 1).clamp(0, 99);
        final wasMulti = _multi;
        if (_fingers == 0) _multi = false;
        if (start == null || wasMulti) return;
        final quick = e.timeStamp - start.time <= AnyTapListener.maxDuration;
        final still = (e.position - start.at).distance <= kTouchSlop;
        if (!quick || !still) return;
        // Microtask: after the tapped widget's own onTap ran in this same event.
        Future.microtask(() {
          if (mounted) widget.onTap();
        });
      },
      onPointerCancel: (e) {
        _down.remove(e.pointer);
        _fingers = (_fingers - 1).clamp(0, 99);
        if (_fingers == 0) _multi = false;
      },
      child: widget.child,
    );
  }
}
