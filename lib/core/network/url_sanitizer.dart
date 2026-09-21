class UrlSanitizer {
  UrlSanitizer._();

  static const _sensitiveKeyPatterns = [
    'password',
    'pass',
    'pwd',
    'token',
    'accesstoken',
    'refreshtoken',
    'auth',
    'authorization',
    'secret',
    'secretkey',
    'apikey',
    'pin',
    'otp',
  ];

  static bool isSensitiveKey(String key) {
    final normalized =
        key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return _sensitiveKeyPatterns.any((pattern) => normalized.contains(pattern));
  }

  static String sanitizeUrl(String urlString) {
    if (urlString.isEmpty) return urlString;
    try {
      final uri = Uri.tryParse(urlString);
      if (uri == null) return _maskSensitiveString(urlString);
      return Uri.decodeFull(sanitizeUri(uri).toString());
    } catch (_) {
      return _maskSensitiveString(urlString);
    }
  }

  static Uri sanitizeUri(Uri uri) {
    try {
      // 1. Sanitize userInfo (e.g. https://user:pass@host)
      String? userInfo;
      if (uri.userInfo.isNotEmpty) {
        userInfo = '***:***';
      }

      // 2. Sanitize query parameters
      Map<String, dynamic>? sanitizedQueryParameters;
      if (uri.queryParametersAll.isNotEmpty) {
        final newParams = <String, List<String>>{};
        for (final entry in uri.queryParametersAll.entries) {
          final key = entry.key;
          if (isSensitiveKey(key)) {
            newParams[key] = entry.value.map((_) => '***').toList();
          } else {
            newParams[key] = entry.value.map((val) {
              if (val.contains('http://') || val.contains('https://')) {
                return sanitizeUrl(val);
              }
              return val;
            }).toList();
          }
        }
        sanitizedQueryParameters = newParams;
      }

      // 3. Sanitize fragment
      String? fragment = uri.hasFragment ? uri.fragment : null;
      if (fragment != null && isSensitiveKey(fragment)) {
        fragment = '***';
      }

      return uri.replace(
        userInfo: userInfo,
        queryParameters: sanitizedQueryParameters,
        fragment: fragment,
      );
    } catch (_) {
      try {
        final maskedStr = _maskSensitiveString(uri.toString());
        return Uri.tryParse(maskedStr) ?? Uri(path: '***');
      } catch (_) {
        return Uri(path: '***');
      }
    }
  }

  static String _maskSensitiveString(String input) {
    var result = input;
    for (final pattern in _sensitiveKeyPatterns) {
      result = result.replaceAllMapped(
        RegExp('($pattern\\s*[:=]\\s*)([^&\\s,]+)', caseSensitive: false),
        (m) => '${m[1]}***',
      );
    }
    return result;
  }

  static String sanitizeMessage(String? message) {
    if (message == null) return '';
    try {
      final sanitizedUrls = message.replaceAllMapped(
        RegExp(r'https?://[^\s]+', caseSensitive: false),
        (match) => sanitizeUrl(match.group(0)!),
      );
      return _maskSensitiveString(sanitizedUrls);
    } catch (_) {
      return _maskSensitiveString(message);
    }
  }
}
