import 'package:flutter/widgets.dart';

/// Root navigator, shared by the router and by services that must present
/// full-screen UI (ad overlays) above whatever screen is active.
final rootNavigatorKey = GlobalKey<NavigatorState>();
