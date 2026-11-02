import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

extension L10nX on BuildContext {
  /// App strings from lib/l10n/app_*.arb.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
