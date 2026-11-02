import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ad_manager.dart';

/// Feeds real background/foreground transitions to AdManager (for App Open)
/// and starts consent + SDK initialization once.
class AdLifecycleHost extends ConsumerStatefulWidget {
  const AdLifecycleHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AdLifecycleHost> createState() => _AdLifecycleHostState();
}

class _AdLifecycleHostState extends ConsumerState<AdLifecycleHost> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    final manager = ref.read(adManagerProvider.notifier);
    // onHide fires only when the app is really backgrounded, not for system
    // dialogs (those only make the app "inactive").
    _listener = AppLifecycleListener(onHide: manager.onBackgrounded, onShow: manager.onResumed);
    WidgetsBinding.instance.addPostFrameCallback((_) => manager.ensureInitialized());
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
