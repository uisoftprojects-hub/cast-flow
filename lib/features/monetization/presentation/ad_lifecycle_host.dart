import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../premium/domain/premium_status_service.dart';
import 'ad_manager.dart';

/// Feeds background/foreground lifecycle transitions to AdManager (for App Open ad triggers)
/// and initializes consent / AdMob SDK appropriately.
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

    // Section 9: Handle resumed, inactive, paused, detached lifecycle events.
    // Count genuine background-to-foreground transitions.
    _listener = AppLifecycleListener(
      onPause: manager.onBackgrounded,
      onHide: manager.onBackgrounded,
      onResume: _resumed,
      onShow: _resumed,
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => manager.ensureInitialized(),
    );
  }

  void _resumed() {
    // Re-check the subscription (renewal, expiry, refund, return from Google Play); throttled.
    ref.read(premiumStatusServiceProvider).refresh();
    ref.read(adManagerProvider.notifier).onResumed();
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
