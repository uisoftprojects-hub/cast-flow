import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import 'l10n_lookup.dart';

extension L10nX on BuildContext {
  /// App strings from lib/l10n/app_*.arb.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension L10nTrX on BuildContext {
  /// Translates a fixed English label kept in data lists and enums.
  String tr(String en) => l10n.lookup(en);
}
