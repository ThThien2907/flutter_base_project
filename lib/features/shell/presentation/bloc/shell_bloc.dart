import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/app/session/session_cleanup.dart';
import 'package:flutter_base_project/features/shell/presentation/bloc/shell_event.dart';
import 'package:flutter_base_project/features/shell/presentation/bloc/shell_state.dart';

@lazySingleton
class ShellBloc extends Bloc<ShellEvent, ShellState>
    implements SessionCleanable {
  ShellBloc() : super(const ShellState()) {
    on<ShellStartedEvent>(_onStarted);
    on<ShellTabChangedEvent>(_onTabChanged);
  }

  void init() => add(const ShellStartedEvent());

  void changeTab(ShellTab tab) => add(ShellTabChangedEvent(tab));

  @override
  Future<void> onSessionClean(SessionEndReason reason) async {
    init();
  }

  @override
  Future<void> onSessionExpired() async {
    init();
  }

  void _onStarted(ShellStartedEvent event, Emitter<ShellState> emit) {
    emit(const ShellState(currentTab: ShellTab.home));
  }

  void _onTabChanged(ShellTabChangedEvent event, Emitter<ShellState> emit) {
    emit(state.copyWith(currentTab: event.tab));
  }
}
