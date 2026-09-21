import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../core/network/network_config.dart';
import '../config/app_config.dart';

@module
abstract class PlatformModule {
  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );

  @lazySingleton
  NetworkConfig get networkConfig => AppConfig.networkConfig;
}
