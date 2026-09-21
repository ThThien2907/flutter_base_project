import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_theme_mode.dart';

part 'theme_state.freezed.dart';

@freezed
abstract class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(AppThemeMode.light) AppThemeMode mode,
  }) = _ThemeState;
}
