import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/core/storage/session_token_storage.dart';
import 'package:flutter_base_project/features/splash/domain/repositories/splash_repository.dart';

@LazySingleton(as: SplashRepository)
class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl(this._tokenStorage);

  final SessionTokenStorage _tokenStorage;

  @override
  Future<Resource<bool>> checkCurrentSession() async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      final refreshToken = await _tokenStorage.getRefreshToken();

      final hasAccessToken = accessToken != null && accessToken.isNotEmpty;
      final hasRefreshToken = refreshToken != null && refreshToken.isNotEmpty;

      if (hasAccessToken && hasRefreshToken) {
        return const Resource.success(true);
      }

      if (hasAccessToken || hasRefreshToken) {
        await _tokenStorage.clearTokens();
      }

      return const Resource.success(false);
    } catch (e) {
      return Resource.error('error.storage', 0, err: e);
    }
  }
}
