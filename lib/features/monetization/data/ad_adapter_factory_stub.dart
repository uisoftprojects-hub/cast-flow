import 'package:flutter/widgets.dart';

import '../../../core/app_providers.dart';
import '../domain/ad_adapter.dart';
import 'fake_ad_adapter.dart';

AdAdapter createPlatformAdAdapter(GlobalKey<NavigatorState> navigator, PreviewMode Function() mode) =>
    FakeAdAdapter(navigator, mode);
