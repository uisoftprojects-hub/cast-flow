import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'analytics.dart';

/// Sends events to Firebase Analytics.
class FirebaseAnalyticsSink implements AnalyticsSink {
  FirebaseAnalyticsSink(this._fa);
  final FirebaseAnalytics _fa;

  /// Starts Firebase and returns its sink, or null when Firebase isn't set
  /// up for this build (no google-services.json / GoogleService-Info.plist).
  static Future<FirebaseAnalyticsSink?> tryCreate() async {
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
      return FirebaseAnalyticsSink(FirebaseAnalytics.instance);
    } catch (e) {
      debugPrint('Firebase Analytics not configured, using debug analytics: $e');
      return null;
    }
  }

  @override
  Future<void> logEvent(String name, Map<String, Object> params) => _fa.logEvent(name: name, parameters: params);

  @override
  Future<void> logScreen(String screenName) => _fa.logScreenView(screenName: screenName, screenClass: screenName);

  @override
  Future<void> setUserProperty(String name, String? value) => _fa.setUserProperty(name: name, value: value);
}
