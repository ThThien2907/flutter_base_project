import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/storage/session_token_storage.dart';

import 'api_interceptor.dart';
import 'api_logger.dart';
import 'auth/token_refresh_service.dart';
import 'network_config.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(
    NetworkConfig config,
    SessionTokenStorage tokenStorage,
    TokenRefreshService tokenRefreshService,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        headers: config.defaultHeaders,
      ),
    );

    dio.interceptors.add(_UploadTimeoutInterceptor(config));
    dio.interceptors.add(
      ApiInterceptor(tokenStorage, tokenRefreshService, dio),
    );
    dio.interceptors.add(ApiLogger());
    return dio;
  }
}

class _UploadTimeoutInterceptor extends Interceptor {
  _UploadTimeoutInterceptor(this._config);

  final NetworkConfig _config;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isMultipartRequest(options)) {
      options.sendTimeout = _config.uploadSendTimeout;
      options.receiveTimeout = _config.uploadReceiveTimeout;
    }

    handler.next(options);
  }

  bool _isMultipartRequest(RequestOptions options) {
    final contentType = options.contentType?.toLowerCase() ?? '';
    return options.data is FormData ||
        contentType.contains('multipart/form-data');
  }
}
