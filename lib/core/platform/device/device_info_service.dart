import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeviceInfoService {
  DeviceInfoService() : _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceInfoService.custom(DeviceInfoPlugin plugin)
      : _deviceInfoPlugin = plugin;

  final DeviceInfoPlugin _deviceInfoPlugin;

  Future<String?> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.id;
      }

      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor ?? 'ios_device_id';
      }

      if (Platform.isMacOS) {
        final macInfo = await _deviceInfoPlugin.macOsInfo;
        return macInfo.systemGUID ?? 'macos_device_id';
      }

      return 'generic_device_id';
    } catch (_) {
      return 'generic_device_id';
    }
  }

  Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}'.trim();
      }

      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.modelName;
      }
    } catch (_) {
      return 'unknown_device_name';
    }

    return 'unknown_device_name';
  }

  Future<String> getPlatformName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return 'Android ${androidInfo.version.release}';
      }

      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return '${iosInfo.systemName} ${iosInfo.systemVersion}';
      }
    } catch (_) {
      return 'unknown_platform';
    }

    return 'unknown_platform';
  }
}
