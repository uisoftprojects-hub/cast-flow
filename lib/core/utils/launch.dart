import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_links.dart';

import '../l10n.dart';

/// Opens [url] outside the app, showing a snackbar if nothing can handle it.
Future<void> openExternal(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final l = context.l10n;
  final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).catchError((_) => false);
  if (!ok) messenger?.showSnackBar(SnackBar(content: Text(l.couldntOpenTheLink)));
}

String get storeListingUrl =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS ? AppLinks.appStore : AppLinks.playStore;
