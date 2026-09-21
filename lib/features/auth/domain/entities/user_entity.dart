import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    String? userLogin,
    String? userCode,
    String? displayName,
    String? userEmail,
    String? userPhone,
    String? userRole,
  }) = _UserEntity;
}
