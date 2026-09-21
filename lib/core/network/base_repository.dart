import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_base_project/core/errors/error_code.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/core/logging/app_logger.dart';
import 'models/base_response.dart';
import 'url_sanitizer.dart';

abstract class BaseRepository {
  static const _networkErrorMessage = 'network_error_mess';
  static const _connectionTimeoutMessage = 'connection_timeout_mess';
  static const _sendTimeoutMessage = 'send_timeout_mess';
  static const _receiveTimeoutMessage = 'receive_timeout_mess';
  static const _connectionErrorMessage = 'connection_error_mess';
  static const _badCertificateMessage = 'bad_certificate_mess';
  static const _serverErrorMessage = 'error_code.server_error';
  static const _genericErrorMessage = 'error.generic';
  static const _uploadFileErrorMessage = 'upload_file_error_mess';
  static const _requestCancelledMessage = 'request_cancelled_mess';
  static const _unreadableServerResponseMessage =
      'error.unreadable_server_response';

  E? parseError<E>(
    Map<String, dynamic>? error, {
    required E Function(Map<String, dynamic>) parsing,
  }) {
    if (error == null) return null;
    return parsing(error);
  }

  Future<Resource<T>> request<T, E>(
    Future<BaseResponse<T, E>> Function() request, {
    E Function(Map<String, dynamic> errorJson)? errorParsing,
  }) async {
    try {
      final response = await request();
      final bool? apiResult = response.success;
      if (apiResult == true) {
        final result = response.result;
        if (result != null) {
          return Resource.success(result);
        }
        if (null is T) {
          return Resource.success(null as T);
        }
        return Resource.error(
          _unreadableServerResponseMessage,
          0,
          errorCode: response.errorCode,
          err: response.error,
        );
      } else if (apiResult == false) {
        return Resource.error(
          _resolveErrorMessage(response.errorCode),
          0,
          errorCode: response.errorCode,
          err: response.error,
        );
      } else {
        // Missing/null success flag is an unreadable/invalid contract response
        return Resource.error(
          _unreadableServerResponseMessage,
          0,
          errorCode: response.errorCode,
          err: response.error,
        );
      }
    } on DioException catch (e, stackTrace) {
      await _logDioException(e, stackTrace);

      if (_isUploadFileError(e.error)) {
        return Resource.error(
          _uploadFileErrorMessage,
          e.response?.statusCode ?? 0,
          err: e,
        );
      }

      final dioErrorMessage = _dioExceptionMessage(e);
      if (dioErrorMessage != null) {
        return Resource.error(
          dioErrorMessage,
          e.response?.statusCode ?? 0,
          err: e,
        );
      }

      if (e.type == DioExceptionType.cancel) {
        return Resource.error(
          _requestCancelledMessage,
          e.response?.statusCode ?? 0,
          err: e,
        );
      }

      if (e.response == null) {
        return Resource.error(_genericErrorMessage, 0, err: e);
      }

      return await _handleBadResponse(e, errorParsing);
    } catch (e, stackTrace) {
      await _logLocalException(e, stackTrace);

      if (_isUploadFileError(e)) {
        return Resource.error(_uploadFileErrorMessage, 0, err: e);
      }

      return Resource.error(_genericErrorMessage, 0, err: e);
    }
  }

  String? _dioExceptionMessage(DioException e) {
    if (e.error is SocketException) {
      return _networkErrorMessage;
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return _connectionTimeoutMessage;
      case DioExceptionType.sendTimeout:
        return _sendTimeoutMessage;
      case DioExceptionType.receiveTimeout:
        return _receiveTimeoutMessage;
      case DioExceptionType.connectionError:
        return _connectionErrorMessage;
      case DioExceptionType.badCertificate:
        return _badCertificateMessage;
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return null;
    }
  }

  bool _isUploadFileError(Object? error) {
    return error is FileSystemException;
  }

  Future<Resource<T>> _handleBadResponse<T, E>(
    DioException e,
    E Function(Map<String, dynamic> errorJson)? errorParsing,
  ) async {
    final responseData = e.response?.data;

    if (responseData is! Map) {
      return Resource.error(
        _messageForHttpStatus(e.response?.statusCode),
        e.response?.statusCode ?? 0,
        err: responseData ?? e,
      );
    }

    final response = Map<String, dynamic>.from(responseData);
    final error = response['error'];
    dynamic parsedErr;

    if (error is Map && errorParsing != null) {
      final errorMap = Map<String, dynamic>.from(error);
      try {
        parsedErr = parseError(errorMap, parsing: errorParsing);
      } catch (parseError, stackTrace) {
        await _logLocalException(parseError, stackTrace);
      }
    } else if (error is String) {
      parsedErr = error;
    }

    final errorCode = response['errorCode']?.toString();

    return Resource.error(
      _resolveErrorMessage(errorCode),
      e.response?.statusCode ?? 0,
      err: parsedErr ?? error,
      errorCode: errorCode,
    );
  }

  String _resolveErrorMessage(String? errorCode) {
    if (errorCode == null || errorCode.isEmpty) {
      return _genericErrorMessage;
    }

    return ErrorCodeEnumExt.getMessage(errorCode) ?? _genericErrorMessage;
  }

  String _messageForHttpStatus(int? statusCode) {
    if (statusCode != null && statusCode >= 500) {
      return _serverErrorMessage;
    }
    return _unreadableServerResponseMessage;
  }

  Future<void> _logDioException(
    DioException error,
    StackTrace stackTrace,
  ) async {
    await _safeLog(
      'API ${_classifyDioException(error)}',
      detail: {
        'type': error.type.name,
        'message': UrlSanitizer.sanitizeMessage(error.message),
        'error': UrlSanitizer.sanitizeMessage(error.error?.toString()),
        'method': error.requestOptions.method,
        'uri': UrlSanitizer.sanitizeUrl(error.requestOptions.uri.toString()),
        'statusCode': error.response?.statusCode,
      },
    );
  }

  String _classifyDioException(DioException error) {
    if (_isUploadFileError(error.error)) return 'UPLOAD_ERROR';
    if (error.error is SocketException) return 'SOCKET_ERROR';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'CONNECTION_TIMEOUT';
      case DioExceptionType.sendTimeout:
        return 'SEND_TIMEOUT';
      case DioExceptionType.receiveTimeout:
        return 'RECEIVE_TIMEOUT';
      case DioExceptionType.connectionError:
        return 'CONNECTION_ERROR';
      case DioExceptionType.badCertificate:
        return 'BAD_CERTIFICATE';
      case DioExceptionType.cancel:
        return 'REQUEST_CANCELLED';
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        break;
    }

    if (error.response != null) {
      final statusCode = error.response?.statusCode ?? 0;
      return statusCode >= 500 ? 'SERVER_ERROR' : 'HTTP_ERROR';
    }
    return 'LOCAL_ERROR';
  }

  Future<void> _logLocalException(Object error, StackTrace stackTrace) async {
    await _safeLog(
      _isUploadFileError(error) ? 'API UPLOAD_ERROR' : 'API LOCAL_ERROR',
      detail: {
        'error': UrlSanitizer.sanitizeMessage(error.toString()),
        'stackTrace': stackTrace.toString(),
      },
    );
  }

  Future<void> _safeLog(
    String message, {
    LogLevel level = LogLevel.error,
    dynamic detail,
  }) async {
    try {
      await AppLogger().log(message, level: level, detail: detail);
    } catch (_) {
      // Logging must never break execution
    }
  }
}
