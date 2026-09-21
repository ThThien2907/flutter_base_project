import 'app_env.dart';

final class AppIdentityAssets {
  const AppIdentityAssets({
    required this.logo,
    required this.logoWhite,
    required this.logoHorizontal,
    required this.logoHorizontalWhite,
  });

  final String logo;
  final String logoWhite;
  final String logoHorizontal;
  final String logoHorizontalWhite;
}

final class AppIdentity {
  const AppIdentity({
    required this.name,
    required this.flavor,
    required this.env,
    required this.versionName,
    required this.versionCode,
    this.assets,
  });

  final String name;
  final String flavor;
  final String env;
  final String versionName;
  final String versionCode;
  final AppIdentityAssets? assets;

  static AppIdentity get current => AppIdentity(
        name: AppEnv.appName,
        flavor: AppEnv.flavor,
        env: AppEnv.env,
        versionName: AppEnv.versionName,
        versionCode: AppEnv.versionCode,
      );
}
