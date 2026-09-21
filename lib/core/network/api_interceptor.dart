import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_base_project/core/errors/error_code.dart';
import 'package:flutter_base_project/core/storage/session_token_storage.dart';
import 'auth/token_refresh_service.dart';

class ApiInterceptor extends Interceptor {
  static const _retriedKey = 'auth.tokenRefreshRetried';

  ApiInterceptor(
    this.tokenManager,
    this.tokenRefreshService,
    this.dio, {
    this.onUnauthorized,
  });

  final SessionTokenStorage tokenManager;
  final TokenRefreshService tokenRefreshService;
  final Dio dio;

  Future<void> Function()? onUnauthorized;
  Future<void>? _unauthorizedFuture;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await tokenManager.getAccessToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_isTokenExpired(err)) {
      handler.next(err);
      return;
    }

    final startGeneration = tokenManager.sessionGeneration;

    try {
      if (err.requestOptions.extra[_retriedKey] == true) {
        if (tokenManager.sessionGeneration == startGeneration) {
          await _handleUnauthorized();
        }
        handler.next(err);
        return;
      }

      final refreshToken = await tokenManager.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        if (tokenManager.sessionGeneration == startGeneration) {
          await _handleUnauthorized();
        }
        handler.next(err);
        return;
      }

      await tokenRefreshService.refreshAccessToken();

      if (tokenManager.sessionGeneration != startGeneration) {
        handler.next(err);
        return;
      }

      final accessToken = await tokenManager.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        if (tokenManager.sessionGeneration == startGeneration) {
          await _handleUnauthorized();
        }
        handler.next(err);
        return;
      }

      final request = err.requestOptions.copyWith(
        headers: {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer $accessToken',
        },
        extra: {
          ...err.requestOptions.extra,
          _retriedKey: true,
        },
      );

      handler.resolve(await dio.fetch<dynamic>(request));
    } catch (refreshError, stackTrace) {
      if (_isRefreshTokenRejected(refreshError)) {
        if (tokenManager.sessionGeneration == startGeneration) {
          await _handleUnauthorized();
        }
      }

      handler.next(
        refreshError is DioException
            ? refreshError
            : DioException(
                requestOptions: err.requestOptions,
                error: refreshError,
                stackTrace: stackTrace,
              ),
      );
    }
  }

  bool _isTokenExpired(DioException err) {
    final data = err.response?.data;
    if (err.response?.statusCode != 401 || data is! Map) {
      return false;
    }
    final errorCode = data['errorCode']?.toString() ?? data['code']?.toString();
    return ErrorCodeEnumExt.isTokenExpiredCode(errorCode);
  }

  bool _isRefreshTokenRejected(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return true;
      }
      final data = error.response?.data;
      if (data is Map) {
        final code = data['errorCode']?.toString() ?? data['code']?.toString();
        return ErrorCodeEnumExt.isTokenExpiredCode(code);
      }
    }
    return false;
  }

  Future<void> _handleUnauthorized() async {
    final current = _unauthorizedFuture;
    if (current != null) return current;

    final cleanup = _notifyUnauthorized();
    _unauthorizedFuture = cleanup;
    try {
      await cleanup;
    } finally {
      _unauthorizedFuture = null;
    }
  }

  Future<void> _notifyUnauthorized() async {
    try {
      await onUnauthorized?.call();
    } catch (_) {}
  }
}
