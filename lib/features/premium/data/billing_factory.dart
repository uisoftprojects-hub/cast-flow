import '../../../core/app_providers.dart';
import '../domain/billing.dart';
import 'billing_factory_stub.dart' if (dart.library.io) 'billing_factory_io.dart' as impl;

/// Store billing on Android/iOS, the fake store elsewhere (web preview,
/// desktop, tests) or with --dart-define=FAKE_BILLING=true.
BillingService createBillingService(PreviewMode Function() mode) => impl.createPlatformBilling(mode);
