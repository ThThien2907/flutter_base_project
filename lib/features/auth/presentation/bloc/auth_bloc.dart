import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/app/session/session_cleanup.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> implements SessionCleanable {
  AuthBloc(this._loginUseCase, this._getMeUseCase, this._logoutUseCase)
    : super(const AuthState()) {
    on<LoginEvent>(_loginEvent);
    on<FetchUserDataEvent>(_fetchUserDataEvent);
    on<LogoutEvent>(_logoutEvent);
    on<ResetAuthEvent>(_resetAuthEvent);
  }

  final LoginUseCase _loginUseCase;
  final GetMeUseCase _getMeUseCase;
  final LogoutUseCase _logoutUseCase;

  void logIn({
    required String username,
    required String password,
    required String deviceId,
  }) {
    if (state.loginResource.isLoading) return;
    add(LoginEvent(username: username, password: password, deviceId: deviceId));
  }

  void fetchUserData() {
    if (state.userResource.isLoading) return;
    add(const FetchUserDataEvent());
  }

  void logout() {
    if (state.logoutResource.isLoading) return;
    add(const LogoutEvent());
  }

  void reset() {
    add(const ResetAuthEvent());
  }

  @override
  Future<void> onSessionClean(SessionEndReason reason) async {
    reset();
  }

  @override
  Future<void> onSessionExpired() async {
    reset();
  }

  Future<void> _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginResource: const Resource.loading()));

    final response = await _loginUseCase(
      username: event.username,
      password: event.password,
      deviceId: event.deviceId,
    );

    emit(state.copyWith(loginResource: response));
  }

  Future<void> _fetchUserDataEvent(
    FetchUserDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(userResource: const Resource.loading()));

    final response = await _getMeUseCase();

    if (response.state == Result.success) {
      emit(state.copyWith(userResource: response, userEntity: response.data));
      return;
    }

    emit(state.copyWith(userResource: response));
  }

  Future<void> _logoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(logoutResource: const Resource.loading()));

    final response = await _logoutUseCase();

    emit(state.copyWith(logoutResource: response, userEntity: null));
  }

  void _resetAuthEvent(ResetAuthEvent event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }
}
