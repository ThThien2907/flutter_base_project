import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';

part 'splash_state.freezed.dart';

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    @Default(Resource.initial()) Resource<bool> checkSessionResource,
  }) = _SplashState;
}
