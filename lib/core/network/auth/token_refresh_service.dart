import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/network/network_config.dart';
import 'package:flutter_base_project/core/platform/device/device_info_service.dart';
import 'package:flutter_base_project/core/storage/session_token_storage.dart';

@lazySingleton
class TokenRefreshService {
  TokenRefreshService(
    this._tokenStorage,
    this._deviceInfoService,
    NetworkConfig config,
  ) : _dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: config.connectTimeout,
          receiveTimeout: config.receiveTimeout,
          sendTimeout: config.sendTimeout,
        ),
      );

  TokenRefreshService.withClient(
    this._tokenStorage,
    this._deviceInfoService,
    this._dio,
  );

  final SessionTokenStorage _tokenStorage;
  final DeviceInfoService _deviceInfoService;
  final Dio _dio;

  Future<void>? _refreshFuture;

  Future<void> refreshAccessToken() async {
    final current = _refreshFuture;
    if (current != null) return current;

    final refresh = _refreshToken();
    _refreshFuture = refresh;

    try {
      await refresh;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError('No refresh token available');
    }

    final deviceId = await _deviceInfoService.getDeviceId();
    final startGeneration = _tokenStorage.sessionGeneration;

    final response = await _dio.post<dynamic>(
      '/api/v1/auth/refresh',
      queryParameters: {'deviceId': deviceId ?? 'device_unknown'},
      options: Options(headers: {'refresh-token': refreshToken}),
    );

    if (_tokenStorage.sessionGeneration != startGeneration) {
      return;
    }

    final data = response.data;
    final result = data is Map
        ? (data['result'] ?? data['data'] ?? data)
        : null;
    final accessToken = result is Map
        ? (result['access_token']?.toString() ??
              result['accessToken']?.toString())
        : null;

    if (accessToken == null || accessToken.trim().isEmpty) {
      throw StateError('Invalid token refresh response');
    }

    final newRefreshToken = result is Map
        ? (result['refresh_token']?.toString() ??
              result['refreshToken']?.toString())
        : null;

    await _tokenStorage.updateSessionTokens(
      accessToken: accessToken,
      refreshToken: newRefreshToken ?? refreshToken,
      expectedGeneration: startGeneration,
    );
  }
}
