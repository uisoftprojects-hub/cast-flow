import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_links.dart';
import '../../../core/utils/launch.dart';
import '../../devices/presentation/device_providers.dart';
import 'settings_controller.dart';

/// Opens the mail app with diagnostics pre-filled. The user reviews and
/// sends it; nothing is transmitted silently.
Future<void> sendFeedback(BuildContext context, WidgetRef ref, {int? rating}) async {
  final messenger = ScaffoldMessenger.of(context);
  final info = await PackageInfo.fromPlatform();
  var os = defaultTargetPlatform.name;
  var model = 'unknown';
  try {
    final d = DeviceInfoPlugin();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final a = await d.androidInfo;
      os = 'Android ${a.version.release} (SDK ${a.version.sdkInt})';
      model = '${a.manufacturer} ${a.model}';
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final i = await d.iosInfo;
      os = '${i.systemName} ${i.systemVersion}';
      model = i.utsname.machine;
    }
  } catch (_) {}
  final receiver = ref.read(connectionProvider).device?.type.label ??
      ref.read(savedDevicesProvider).all().firstOrNull?.type.label ??
      'none';
  final body = '\n\n---\n${rating == null ? '' : 'Rating: $rating/5\n'}'
      'App: ${info.version} (${info.buildNumber})\nOS: $os\nPhone: $model\nReceiver: $receiver';
  final uri = Uri(
    scheme: 'mailto',
    path: AppLinks.supportEmail,
    query: 'subject=${Uri.encodeComponent('CastFlow feedback')}&body=${Uri.encodeComponent(body)}',
  );
  final ok = await launchUrl(uri).catchError((_) => false);
  if (!ok) messenger.showSnackBar(const SnackBar(content: Text('No email app found.')));
}

/// Official store review flow, falling back to the store page.
Future<void> rateOnStore(BuildContext context, WidgetRef ref) async {
  ref.read(settingsProvider.notifier).markReviewPrompted();
  final review = InAppReview.instance;
  if (!kIsWeb && await review.isAvailable()) {
    await review.requestReview();
  } else if (context.mounted) {
    await openExternal(context, storeListingUrl);
  }
}
