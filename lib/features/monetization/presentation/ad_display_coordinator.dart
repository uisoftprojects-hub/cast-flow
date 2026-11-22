import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ad_logger.dart';
import '../domain/ad_models.dart';

/// Central coordinator ensuring strictly ONE full-screen advertisement (interstitial or app open)
/// can be displayed at any time across the entire application lifecycle.
class AdDisplayCoordinator {
  bool _isFullScreenShowing = false;
  bool _isPurchaseInProgress = false;

  static const _backLock = MethodChannel('castflow/ad_back_lock');

  /// Android: Back button / gesture does nothing while a full-screen ad is up.
  /// (Google's ad activity lives outside Flutter, so it is blocked natively.)
  static void _setBackLocked(bool locked) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    _backLock.invokeMethod<void>('setLocked', {'locked': locked}).catchError((_) {});
  }

  bool get isFullScreenShowing => _isFullScreenShowing;
  bool get isPurchaseInProgress => _isPurchaseInProgress;

  final _displayStream = StreamController<bool>.broadcast();
  Stream<bool> get onDisplayStateChanged => _displayStream.stream;

  void setPurchaseInProgress(bool inProgress) {
    _isPurchaseInProgress = inProgress;
    AdLogger.d(
      AdState.cooldownActive,
      adType: 'Coordinator',
      message: 'setPurchaseInProgress: $inProgress',
    );
  }

  /// Whether a new full-screen ad can be presented right now
  bool canShow({required bool isPremium}) {
    if (isPremium) return false;
    if (_isFullScreenShowing) return false;
    if (_isPurchaseInProgress) return false;
    return true;
  }

  /// Coordinates presenting a full-screen ad safely.
  /// Guarantees that no other full-screen ad can be presented concurrently.
  Future<bool> present({
    required String adType,
    AdPlacement? placement,
    required bool isPremium,
    required Future<void> Function() displayAction,
  }) async {
    if (!canShow(isPremium: isPremium)) {
      AdLogger.w(
        AdState.coordinatorLockRejected,
        placement: placement,
        adType: adType,
        message:
            'Presentation rejected: isPremium=$isPremium, isFullScreenShowing=$_isFullScreenShowing, isPurchaseInProgress=$_isPurchaseInProgress',
      );
      return false;
    }

    _isFullScreenShowing = true;
    _setBackLocked(true);
    _displayStream.add(true);
    AdLogger.i(
      AdState.coordinatorLockAcquired,
      placement: placement,
      adType: adType,
      message: 'Full-screen presentation lock acquired for $adType.',
    );

    try {
      await displayAction();
      return true;
    } catch (e) {
      AdLogger.e(
        AdState.showFailed,
        placement: placement,
        adType: adType,
        message: 'Error displaying $adType',
        error: e,
      );
      return false;
    } finally {
      _isFullScreenShowing = false;
      _setBackLocked(false);
      _displayStream.add(false);
      AdLogger.i(
        AdState.coordinatorLockReleased,
        placement: placement,
        adType: adType,
        message: 'Full-screen presentation lock released for $adType.',
      );
    }
  }

  void forceDismissAll() {
    AdLogger.i(
      AdState.coordinatorLockReleased,
      adType: 'Coordinator',
      message: 'Force-resetting all full-screen presentation locks.',
    );
    _isFullScreenShowing = false;
    _setBackLocked(false);
    _displayStream.add(false);
  }

  void dispose() {
    _displayStream.close();
  }
}

final adDisplayCoordinatorProvider = Provider<AdDisplayCoordinator>((ref) {
  final coordinator = AdDisplayCoordinator();
  ref.onDispose(coordinator.dispose);
  return coordinator;
});
