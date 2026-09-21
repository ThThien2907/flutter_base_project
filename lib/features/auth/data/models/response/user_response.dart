import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response.freezed.dart';
part 'user_response.g.dart';

@freezed
abstract class UserResponse with _$UserResponse {
  const factory UserResponse({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'userLogin') String? userLogin,
    @JsonKey(name: 'userCode') String? userCode,
    @JsonKey(name: 'displayName') String? displayName,
    @JsonKey(name: 'userEmail') String? userEmail,
    @JsonKey(name: 'userPhone') String? userPhone,
    @JsonKey(name: 'userRole') String? userRole,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}
