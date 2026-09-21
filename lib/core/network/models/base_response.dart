import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class BaseResponse<T, E> with _$BaseResponse<T, E> {
  const factory BaseResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'errorCode') String? errorCode,
    @JsonKey(name: 'error') E? error,
    @JsonKey(name: 'result') T? result,
    @JsonKey(name: 'timestamp') DateTime? timestamp,
    @JsonKey(name: 'path') String? path,
  }) = _BaseResponse<T, E>;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
    E Function(Object?) fromJsonE,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT, fromJsonE);
}
