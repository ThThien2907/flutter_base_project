import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/splash/domain/usecases/check_current_session_usecase.dart';
import 'package:flutter_base_project/features/splash/presentation/bloc/splash_event.dart';
import 'package:flutter_base_project/features/splash/presentation/bloc/splash_state.dart';

@lazySingleton
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(this._checkCurrentSessionUseCase) : super(const SplashState()) {
    on<SplashStartedEvent>(_onStarted);
    on<SplashRetriedEvent>(_onRetried);
  }

  final CheckCurrentSessionUseCase _checkCurrentSessionUseCase;

  void checkSession() => add(const SplashStartedEvent());

  void retry() => add(const SplashRetriedEvent());

  Future<void> _onStarted(
    SplashStartedEvent event,
    Emitter<SplashState> emit,
  ) async {
    if (state.checkSessionResource.isLoading) return;
    emit(state.copyWith(checkSessionResource: const Resource.loading()));
    final result = await _checkCurrentSessionUseCase();
    emit(state.copyWith(checkSessionResource: result));
  }

  Future<void> _onRetried(
    SplashRetriedEvent event,
    Emitter<SplashState> emit,
  ) async {
    if (state.checkSessionResource.isLoading) return;
    emit(state.copyWith(checkSessionResource: const Resource.loading()));
    final result = await _checkCurrentSessionUseCase();
    emit(state.copyWith(checkSessionResource: result));
  }
}
