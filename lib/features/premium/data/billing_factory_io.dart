import 'dart:io';

import '../../../core/app_providers.dart';
import '../domain/billing.dart';
import 'fake_billing_service.dart';
import 'iap_billing_service.dart';

const _forceFake = bool.fromEnvironment('FAKE_BILLING');

BillingService createPlatformBilling(PreviewMode Function() mode) {
  if (!_forceFake && (Platform.isAndroid || Platform.isIOS)) return IapBillingService();
  return FakeBillingService(mode);
}
