import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_entity.freezed.dart';

@freezed
abstract class LoginEntity with _$LoginEntity {
  const factory LoginEntity({
    required String accessToken,
    required String refreshToken,
    String? tokenType,
    int? expiresIn,
    String? userEmail,
    bool? isVerified,
  }) = _LoginEntity;
}
