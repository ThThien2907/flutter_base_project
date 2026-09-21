import '../../core/network/network_config.dart';
import 'app_env.dart';

abstract final class AppConfig {
  static NetworkConfig get networkConfig => NetworkConfig(
        baseUrl: AppEnv.baseUrl,
        imageEndpoint: AppEnv.imgUrl,
        connectTimeout: AppEnv.connectTimeout,
        receiveTimeout: AppEnv.receiveTimeout,
        sendTimeout: AppEnv.sendTimeout,
        uploadReceiveTimeout: AppEnv.uploadReceiveTimeout,
        uploadSendTimeout: AppEnv.uploadSendTimeout,
      );
}
