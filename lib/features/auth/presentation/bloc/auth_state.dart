import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/auth/domain/entities/login_entity.dart';
import 'package:flutter_base_project/features/auth/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(Resource.initial()) Resource<LoginEntity> loginResource,
    @Default(Resource.initial()) Resource<UserEntity> userResource,
    @Default(Resource.initial()) Resource<dynamic> logoutResource,
    UserEntity? userEntity,
  }) = _AuthState;
}
