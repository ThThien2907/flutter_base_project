import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_meta_response.freezed.dart';
part 'base_meta_response.g.dart';

@freezed
abstract class BaseMetaResponse with _$BaseMetaResponse {
  const factory BaseMetaResponse({
    @JsonKey(name: 'page') int? page,
    @JsonKey(name: 'limit') int? limit,
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'totalPages') int? totalPages,
    @JsonKey(name: 'hasPrevious') bool? hasPrevious,
    @JsonKey(name: 'hasNext') bool? hasNext,
  }) = _BaseMetaResponse;

  factory BaseMetaResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseMetaResponseFromJson(json);
}
