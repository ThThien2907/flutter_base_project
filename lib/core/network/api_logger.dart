import 'package:dio/dio.dart';
import 'package:flutter_base_project/core/logging/app_logger.dart';
import 'url_sanitizer.dart';

class ApiLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      AppLogger().log(
        'REQUEST API',
        detail: {
          'method': options.method,
          'url': UrlSanitizer.sanitizeUrl(options.uri.toString()),
          'headers': _sanitizeMap(options.headers),
          'data': _sanitizeData(options.data),
        },
      );
    } catch (_) {}
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      AppLogger().log(
        'RESPONSE API',
        detail: {
          'statusCode': response.statusCode,
          'url': UrlSanitizer.sanitizeUrl(
            response.requestOptions.uri.toString(),
          ),
          'data': _sanitizeData(response.data),
        },
      );
    } catch (_) {}
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      AppLogger().log(
        'ERROR API',
        level: LogLevel.error,
        detail: {
          'type': err.type.name,
          'statusCode': err.response?.statusCode,
          'url': UrlSanitizer.sanitizeUrl(err.requestOptions.uri.toString()),
          'message': UrlSanitizer.sanitizeMessage(err.message),
          'error': UrlSanitizer.sanitizeMessage(err.error?.toString()),
          'responseData': _sanitizeData(err.response?.data),
        },
      );
    } catch (_) {}
    super.onError(err, handler);
  }

  dynamic _sanitizeData(dynamic data) {
    if (data is Map) {
      return _sanitizeMap(data);
    } else if (data is List) {
      return data.map(_sanitizeData).toList();
    } else if (data is FormData) {
      return '[FormData with ${data.fields.length} fields, ${data.files.length} files]';
    }
    return data;
  }

  Map<String, dynamic> _sanitizeMap(Map map) {
    final sanitized = <String, dynamic>{};
    for (final entry in map.entries) {
      final key = entry.key.toString();
      if (UrlSanitizer.isSensitiveKey(key)) {
        sanitized[key] = '***';
      } else {
        sanitized[key] = _sanitizeData(entry.value);
      }
    }
    return sanitized;
  }
}
