import 'package:flutter/foundation.dart';

/// TEMPORARY: forces cast logs on in release/APK builds so casting errors show
/// in logcat (filter: `CastFlow`). Set back to `false` before publishing; the
/// logs include TV names and addresses.
const bool _forceLogs = true;

/// Console logging for development only. `debugPrint` still prints in release
/// builds (to logcat), so anything that mentions a TV's address or name goes
/// through here and is dropped from release builds (unless [_forceLogs]).
void dlog(String message) {
  if (kDebugMode || _forceLogs) debugPrint('CastFlow: $message');
}
