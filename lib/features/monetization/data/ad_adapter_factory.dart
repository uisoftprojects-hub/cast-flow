import 'package:flutter/widgets.dart';

import '../../../core/app_providers.dart';
import '../domain/ad_adapter.dart';
import 'ad_adapter_factory_stub.dart' if (dart.library.io) 'ad_adapter_factory_io.dart' as impl;

/// Google Mobile Ads on Android/iOS, the fake adapter everywhere else (web
/// preview, desktop, tests) or when built with --dart-define=FAKE_ADS=true.
AdAdapter createAdAdapter(GlobalKey<NavigatorState> navigator, PreviewMode Function() mode) =>
    impl.createPlatformAdAdapter(navigator, mode);
