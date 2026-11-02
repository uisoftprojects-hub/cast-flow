import '../../../core/app_providers.dart';
import '../domain/billing.dart';
import 'fake_billing_service.dart';

BillingService createPlatformBilling(PreviewMode Function() mode) => FakeBillingService(mode);
