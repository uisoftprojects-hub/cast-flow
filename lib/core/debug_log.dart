import 'package:flutter/foundation.dart';

/// Console logging for development only. `debugPrint` still prints in release
/// builds (to logcat), so anything that mentions a TV's address or name goes
/// through here and is dropped from release builds.
void dlog(String message) {
  if (kDebugMode) debugPrint(message);
}
