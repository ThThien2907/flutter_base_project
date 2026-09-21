import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/core/network/base_repository.dart';
import 'package:flutter_base_project/features/auth/data/datasources/auth_api.dart';
import 'package:flutter_base_project/features/auth/data/models/request/login_request.dart';
import 'package:flutter_base_project/features/auth/data/models/response/login_response.dart';
import 'package:flutter_base_project/features/auth/data/models/response/user_response.dart';
import 'package:flutter_base_project/features/auth/domain/entities/login_entity.dart';
import 'package:flutter_base_project/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_base_project/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  AuthRepositoryImpl(this._authApi);

  final AuthApi _authApi;

  @override
  Future<Resource<LoginEntity>> login({
    required String username,
    required String password,
    required String deviceId,
  }) async {
    final response = await request<LoginResponse, dynamic>(
      () => _authApi.login(
        LoginRequest(
          username: username,
          password: password,
          deviceId: deviceId,
        ),
      ),
    );

    return response.parse((data) => _mapLoginResponseToEntity(data));
  }

  @override
  Future<Resource<UserEntity>> fetchUserData() async {
    final response = await request<UserResponse, dynamic>(
      () => _authApi.fetchUserData(),
    );

    return response.parse((data) => _mapUserResponseToEntity(data));
  }

  @override
  Future<Resource<dynamic>> logout() async {
    final response = await request<dynamic, dynamic>(() => _authApi.logout());

    return response;
  }

  LoginEntity _mapLoginResponseToEntity(LoginResponse data) {
    return LoginEntity(
      accessToken: data.accessToken ?? '',
      refreshToken: data.refreshToken ?? '',
      tokenType: data.tokenType,
      expiresIn: data.expiresIn,
      userEmail: data.userEmail,
      isVerified: data.isVerified,
    );
  }

  UserEntity _mapUserResponseToEntity(UserResponse data) {
    return UserEntity(
      id: data.id ?? '',
      userLogin: data.userLogin,
      userCode: data.userCode,
      displayName: data.displayName,
      userEmail: data.userEmail,
      userPhone: data.userPhone,
      userRole: data.userRole,
    );
  }
}
