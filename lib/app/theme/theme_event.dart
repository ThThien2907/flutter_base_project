import 'app_theme_mode.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class ThemeModeLoaded extends ThemeEvent {
  const ThemeModeLoaded();
}

class ThemeModeChanged extends ThemeEvent {
  const ThemeModeChanged(this.mode);

  final AppThemeMode mode;
}
