import 'package:freezed_annotation/freezed_annotation.dart';

import 'shell_event.dart';

part 'shell_state.freezed.dart';

@freezed
abstract class ShellState with _$ShellState {
  const factory ShellState({
    @Default(ShellTab.home) ShellTab currentTab,
  }) = _ShellState;
}
