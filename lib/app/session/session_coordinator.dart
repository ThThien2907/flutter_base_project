import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/logging/app_logger.dart';
import '../../core/storage/session_token_storage.dart';
import 'session_cleanup.dart';

@lazySingleton
class SessionCoordinator {
  SessionCoordinator(this._tokenStorage);

  final SessionTokenStorage _tokenStorage;
  final List<SessionCleanable> _cleanables = [];
  final StreamController<void> _sessionExpiredController =
      StreamController<void>.broadcast();
  final StreamController<SessionEndReason> _sessionEndedController =
      StreamController<SessionEndReason>.broadcast();

  Future<void>? _activeCleanupFuture;

  Stream<void> get sessionExpiredStream => _sessionExpiredController.stream;
  Stream<SessionEndReason> get sessionEndedStream =>
      _sessionEndedController.stream;

  void registerCleanable(SessionCleanable cleanable) {
    if (!_cleanables.contains(cleanable)) {
      _cleanables.add(cleanable);
    }
  }

  void unregisterCleanable(SessionCleanable cleanable) {
    _cleanables.remove(cleanable);
  }

  Future<void> handleSessionExpired() =>
      _endSession(SessionEndReason.tokenExpired);

  Future<void> logout() => _endSession(SessionEndReason.logout);

  Future<void> _endSession(SessionEndReason reason) {
    final active = _activeCleanupFuture;
    if (active != null) return active;

    final future = _runCleanup(reason);
    _activeCleanupFuture = future;
    return future.whenComplete(() {
      _activeCleanupFuture = null;
    });
  }

  Future<void> _runCleanup(SessionEndReason reason) async {
    // 1. Invalidate session generation immediately
    _tokenStorage.invalidateSession();

    // 2. Clear secure storage tokens
    try {
      await _tokenStorage.clearTokens();
    } catch (e, st) {
      await _safeLog(
        'Failed to clear secure storage tokens during session cleanup',
        detail: {'error': e.toString(), 'stackTrace': st.toString()},
      );
    }

    // 3. Run all registered cleanables (one copy, each in try-catch)
    final cleanables = List<SessionCleanable>.from(_cleanables);
    for (final cleanable in cleanables) {
      try {
        await cleanable.onSessionClean(reason);
      } catch (e, st) {
        await _safeLog(
          'Error in cleanable ${cleanable.runtimeType} during session cleanup',
          detail: {'error': e.toString(), 'stackTrace': st.toString()},
        );
      }
    }

    // 4. Emit notifications if controllers are still open
    if (!_sessionEndedController.isClosed) {
      _sessionEndedController.add(reason);
    }

    if (reason == SessionEndReason.tokenExpired &&
        !_sessionExpiredController.isClosed) {
      _sessionExpiredController.add(null);
    }
  }

  Future<void> _safeLog(String msg, {dynamic detail}) async {
    try {
      await AppLogger().log(msg, level: LogLevel.error, detail: detail);
    } catch (_) {}
  }

  @disposeMethod
  void dispose() {
    _cleanables.clear();
    if (!_sessionExpiredController.isClosed) {
      _sessionExpiredController.close();
    }
    if (!_sessionEndedController.isClosed) {
      _sessionEndedController.close();
    }
  }
}
