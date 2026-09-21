enum ErrorCodeEnum {
  authInvalidCredentials,
  authTokenExpired,
  authUnauthorized,
  authAccountLocked,
  serverError,
  validationInvalidRequest,
  unknownError,
}

extension ErrorCodeEnumExt on ErrorCodeEnum {
  static const _mapKey = {
    ErrorCodeEnum.authInvalidCredentials: 'AUTH_INVALID_CREDENTIALS',
    ErrorCodeEnum.authTokenExpired: 'AUTH_TOKEN_EXPIRED',
    ErrorCodeEnum.authUnauthorized: 'AUTH_UNAUTHORIZED',
    ErrorCodeEnum.authAccountLocked: 'AUTH_ACCOUNT_LOCKED',
    ErrorCodeEnum.serverError: 'SERVER_ERROR',
    ErrorCodeEnum.validationInvalidRequest: 'INVALID_REQUEST',
    ErrorCodeEnum.unknownError: 'UNKNOWN_ERROR',
  };

  static const _mapValue = {
    ErrorCodeEnum.authInvalidCredentials: 'error_code.auth.invalid_credentials',
    ErrorCodeEnum.authTokenExpired: 'error_code.auth.token_expired',
    ErrorCodeEnum.authUnauthorized: 'error_code.auth.unauthorized',
    ErrorCodeEnum.authAccountLocked: 'error_code.auth.account_locked',
    ErrorCodeEnum.serverError: 'error_code.server_error',
    ErrorCodeEnum.validationInvalidRequest: 'error_code.validation.invalid_request',
    ErrorCodeEnum.unknownError: 'error_code.unknown',
  };

  String get key => _mapKey[this] ?? 'UNKNOWN_ERROR';
  String get translationKey => _mapValue[this] ?? 'error.generic';

  static String? getMessage(String? errorCode) {
    if (errorCode == null || errorCode.isEmpty) {
      return null;
    }

    final matched = _mapKey.entries.where((e) => e.value == errorCode);
    if (matched.isEmpty) {
      return null;
    }

    return _mapValue[matched.first.key];
  }

  static bool isTokenExpiredCode(String? errorCode) {
    if (errorCode == null) return false;
    return errorCode == 'AUTH_TOKEN_EXPIRED' ||
        errorCode == 'AUTH_005' ||
        errorCode == 'AUTH_006' ||
        errorCode == 'AUTH_007';
  }
}
