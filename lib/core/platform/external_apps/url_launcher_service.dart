import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

typedef LaunchExternalUrl =
    Future<bool> Function(Uri uri, {required LaunchMode mode});

@lazySingleton
class UrlLauncherService {
  UrlLauncherService()
      : _launchExternalUrl =
            ((uri, {required mode}) => launchUrl(uri, mode: mode));

  @visibleForTesting
  UrlLauncherService.withLauncher(this._launchExternalUrl);

  final LaunchExternalUrl _launchExternalUrl;

  Future<bool> openPhoneDialer(String phoneNumber) async {
    final normalized = phoneNumber.trim();
    if (normalized.isEmpty) return false;

    final phoneUri = Uri(scheme: 'tel', path: normalized);
    try {
      return await _launchExternalUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> openEmailComposer(String email) async {
    final normalized = email.trim();
    if (normalized.isEmpty) return false;

    final emailUri = Uri(scheme: 'mailto', path: normalized);
    try {
      return await _launchExternalUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> openInAppBrowser(String url) async {
    final normalized = url.trim();
    if (normalized.isEmpty) return false;

    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.hasScheme) return false;

    try {
      return await _launchExternalUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> openExternalBrowser(String url) async {
    final normalized = url.trim();
    if (normalized.isEmpty) return false;

    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.hasScheme) return false;

    try {
      return await _launchExternalUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> openMapCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    if (!_isValidLatitude(latitude) || !_isValidLongitude(longitude)) {
      return false;
    }

    final mapUri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '$latitude,$longitude',
    });

    try {
      return await _launchExternalUrl(
        mapUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  bool _isValidLatitude(double value) {
    return value.isFinite && value >= -90 && value <= 90;
  }

  bool _isValidLongitude(double value) {
    return value.isFinite && value >= -180 && value <= 180;
  }
}
