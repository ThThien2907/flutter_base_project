import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'session_token_storage.dart';
import 'storage_keys.dart';

@LazySingleton(as: SessionTokenStorage)
class TokenManager implements SessionTokenStorage {
  static const storageTimeout = Duration(seconds: 5);

  TokenManager(this._storage);

  final FlutterSecureStorage _storage;
  int _sessionGeneration = 0;
  bool _isSessionExplicitlyInvalidated = false;
  Future<void> _mutationQueue = Future.value();

  /// Monotonically increasing generation identifying the current active session.
  /// Incremented whenever a session is started, invalidated, or cleared.
  @override
  int get sessionGeneration => _sessionGeneration;

  /// Synchronously advances session generation to invalidate any in-flight operations.
  @override
  int invalidateSession() {
    _isSessionExplicitlyInvalidated = true;
    return ++_sessionGeneration;
  }

  Future<T> _enqueueMutation<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _mutationQueue = _mutationQueue.then((_) async {
      try {
        final result = await action();
        completer.complete(result);
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }

  /// Starts a new authenticated session atomically.
  /// Increments the session generation, clears any previous state, writes both tokens,
  /// and rolls back completely if any write operation fails.
  @override
  Future<int> startNewSession({
    required String accessToken,
    required String refreshToken,
  }) {
    final newGeneration = invalidateSession();
    _isSessionExplicitlyInvalidated = false;

    return _enqueueMutation(() async {
      try {
        await _storage
            .write(key: StorageKeys.accessToken, value: accessToken)
            .timeout(storageTimeout);
        await _storage
            .write(key: StorageKeys.refreshToken, value: refreshToken)
            .timeout(storageTimeout);
        return newGeneration;
      } catch (e) {
        // Rollback partial writes on failure
        _isSessionExplicitlyInvalidated = true;
        try {
          await _storage.delete(key: StorageKeys.accessToken).timeout(storageTimeout);
        } catch (_) {}
        try {
          await _storage.delete(key: StorageKeys.refreshToken).timeout(storageTimeout);
        } catch (_) {}
        rethrow;
      }
    });
  }

  /// Updates tokens for the existing active session.
  /// Rejects the update if the current session generation does not match [expectedGeneration].
  @override
  Future<void> updateSessionTokens({
    required String accessToken,
    String? refreshToken,
    required int expectedGeneration,
  }) {
    return _enqueueMutation(() async {
      if (_sessionGeneration != expectedGeneration || _isSessionExplicitlyInvalidated) {
        return;
      }

      await _storage
          .write(key: StorageKeys.accessToken, value: accessToken)
          .timeout(storageTimeout);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _storage
            .write(key: StorageKeys.refreshToken, value: refreshToken)
            .timeout(storageTimeout);
      }

      if (_sessionGeneration != expectedGeneration || _isSessionExplicitlyInvalidated) {
        // Session was invalidated while writing; clean up stale write
        try {
          await _storage.delete(key: StorageKeys.accessToken).timeout(storageTimeout);
          await _storage.delete(key: StorageKeys.refreshToken).timeout(storageTimeout);
        } catch (_) {}
      }
    });
  }

  @override
  Future<void> saveAccessToken(
    String accessToken, {
    int? expectedGeneration,
  }) {
    if (expectedGeneration == null) {
      _isSessionExplicitlyInvalidated = false;
    }
    return _enqueueMutation(() async {
      if (expectedGeneration != null &&
          (expectedGeneration != _sessionGeneration || _isSessionExplicitlyInvalidated)) {
        return;
      }
      _isSessionExplicitlyInvalidated = false;
      await _storage
          .write(key: StorageKeys.accessToken, value: accessToken)
          .timeout(storageTimeout);
    });
  }

  @override
  Future<void> saveRefreshToken(
    String refreshToken, {
    int? expectedGeneration,
  }) {
    if (expectedGeneration == null) {
      _isSessionExplicitlyInvalidated = false;
    }
    return _enqueueMutation(() async {
      if (expectedGeneration != null &&
          (expectedGeneration != _sessionGeneration || _isSessionExplicitlyInvalidated)) {
        return;
      }
      _isSessionExplicitlyInvalidated = false;
      await _storage
          .write(key: StorageKeys.refreshToken, value: refreshToken)
          .timeout(storageTimeout);
    });
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    int? expectedGeneration,
  }) {
    if (expectedGeneration == null) {
      _isSessionExplicitlyInvalidated = false;
    }
    return _enqueueMutation(() async {
      if (expectedGeneration != null &&
          (expectedGeneration != _sessionGeneration || _isSessionExplicitlyInvalidated)) {
        return;
      }
      _isSessionExplicitlyInvalidated = false;
      final targetGeneration = expectedGeneration ?? _sessionGeneration;
      try {
        await _storage
            .write(key: StorageKeys.accessToken, value: accessToken)
            .timeout(storageTimeout);
        await _storage
            .write(key: StorageKeys.refreshToken, value: refreshToken)
            .timeout(storageTimeout);
      } catch (e) {
        try {
          await _storage.delete(key: StorageKeys.accessToken).timeout(storageTimeout);
        } catch (_) {}
        try {
          await _storage.delete(key: StorageKeys.refreshToken).timeout(storageTimeout);
        } catch (_) {}
        rethrow;
      }

      if (expectedGeneration != null &&
          (_sessionGeneration != targetGeneration || _isSessionExplicitlyInvalidated)) {
        try {
          await _storage.delete(key: StorageKeys.accessToken).timeout(storageTimeout);
          await _storage.delete(key: StorageKeys.refreshToken).timeout(storageTimeout);
        } catch (_) {}
      }
    });
  }

  @override
  Future<String?> getAccessToken() async {
    if (_isSessionExplicitlyInvalidated) return null;
    try {
      return await _storage.read(key: StorageKeys.accessToken).timeout(storageTimeout);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    if (_isSessionExplicitlyInvalidated) return null;
    try {
      return await _storage.read(key: StorageKeys.refreshToken).timeout(storageTimeout);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.trim().isNotEmpty;
  }

  @override
  Future<void> clearTokens() {
    // Invalidate session generation synchronously right away so memory checks fail immediately
    invalidateSession();

    return _enqueueMutation(() async {
      try {
        await Future.wait([
          _storage.delete(key: StorageKeys.accessToken).timeout(storageTimeout),
          _storage.delete(key: StorageKeys.refreshToken).timeout(storageTimeout),
        ]);
      } catch (_) {
        // Even if hardware/storage delete fails, session remains marked invalid in memory
      }
    });
  }
}
