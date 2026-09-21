import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'app_theme_mode.dart';
import 'theme_event.dart';
import 'theme_state.dart';
import 'theme_storage.dart';

@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const Duration _themeChangeCooldown = Duration(seconds: 2);

  @factoryMethod
  ThemeBloc(this._themeStorage)
      : _nowProvider = DateTime.now,
        super(const ThemeState()) {
    on<ThemeModeLoaded>(_onThemeModeLoaded);
    on<ThemeModeChanged>(_onThemeModeChanged);
  }

  ThemeBloc.withNow(
    this._themeStorage, {
    required DateTime Function() now,
  })  : _nowProvider = now,
        super(const ThemeState()) {
    on<ThemeModeLoaded>(_onThemeModeLoaded);
    on<ThemeModeChanged>(_onThemeModeChanged);
  }

  final ThemeStorage _themeStorage;
  final DateTime Function() _nowProvider;
  DateTime? _lastThemeChangeAt;

  void loadThemeMode() => add(const ThemeModeLoaded());

  void changeThemeMode(AppThemeMode mode) {
    final now = _nowProvider();
    final lastThemeChangeAt = _lastThemeChangeAt;
    if (state.mode == mode ||
        (lastThemeChangeAt != null &&
            now.difference(lastThemeChangeAt) < _themeChangeCooldown)) {
      return;
    }

    _lastThemeChangeAt = now;
    add(ThemeModeChanged(mode));
  }

  Future<void> _onThemeModeLoaded(
    ThemeModeLoaded event,
    Emitter<ThemeState> emit,
  ) async {
    final mode = await _themeStorage.readThemeMode();
    emit(state.copyWith(mode: mode));
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(mode: event.mode));
    await _themeStorage.writeThemeMode(event.mode);
  }
}
