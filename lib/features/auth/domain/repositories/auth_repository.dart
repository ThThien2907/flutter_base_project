import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/auth/domain/entities/login_entity.dart';
import 'package:flutter_base_project/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Resource<LoginEntity>> login({
    required String username,
    required String password,
    required String deviceId,
  });

  Future<Resource<UserEntity>> fetchUserData();

  Future<Resource<dynamic>> logout();
}
