import 'package:flutter/services.dart' show appFlavor;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppEnv {
  static const endpointKey = 'ENDPOINT';
  static const imgEndpointKey = 'IMG_ENDPOINT';
  static const versionNameKey = 'VERSION_NAME';
  static const versionCodeKey = 'VERSION_CODE';
  static const envKey = 'ENV';

  static const devEnv = 'development';
  static const prodEnv = 'production';
  
  static const devFlavor = 'dev';
  static const prodFlavor = 'prod';

  static String get baseUrl => dotenv.env[endpointKey] ?? '';
  static String get imgUrl => dotenv.env[imgEndpointKey] ?? '';
  static String get flavor =>
      appFlavor ??
      const String.fromEnvironment('FLAVOR', defaultValue: devFlavor);
  static String get env => dotenv.env[envKey] ?? devEnv;
  static String get versionName => dotenv.env[versionNameKey] ?? '';
  static String get versionCode => dotenv.env[versionCodeKey] ?? '';
  static String get appName => dotenv.env['APP_NAME'] ?? 'Base App';
  static String get androidBundleId => dotenv.env['ANDROID_BUNDLE_ID'] ?? '';
  static String get iosBundleId => dotenv.env['IOS_BUNDLE_ID'] ?? '';

  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
  static const sendTimeout = Duration(seconds: 30);
  static const uploadReceiveTimeout = Duration(seconds: 120);
  static const uploadSendTimeout = Duration(seconds: 120);
}
