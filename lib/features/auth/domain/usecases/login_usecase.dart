import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/core/storage/session_token_storage.dart';
import 'package:flutter_base_project/features/auth/domain/entities/login_entity.dart';
import 'package:flutter_base_project/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase {
  LoginUseCase(this._authRepository, this._tokenStorage);

  final AuthRepository _authRepository;
  final SessionTokenStorage _tokenStorage;

  Future<Resource<LoginEntity>> call({
    required String username,
    required String password,
    required String deviceId,
  }) async {
    final startGeneration = _tokenStorage.sessionGeneration;

    final result = await _authRepository.login(
      username: username,
      password: password,
      deviceId: deviceId,
    );

    // If session generation changed during login request (e.g. user logged out or cancelled), discard result
    if (_tokenStorage.sessionGeneration != startGeneration) {
      return const Resource.error('error.generic', 0);
    }

    if (result.isSuccess && result.data != null) {
      final loginData = result.data!;
      if (loginData.accessToken.trim().isEmpty ||
          loginData.refreshToken.trim().isEmpty) {
        return const Resource.error('error.unreadable_server_response', 0);
      }

      try {
        await _tokenStorage.startNewSession(
          accessToken: loginData.accessToken,
          refreshToken: loginData.refreshToken,
        );
      } catch (e) {
        return Resource.error('error.generic', 0, err: e);
      }
    }

    return result;
  }
}
