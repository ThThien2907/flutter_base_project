import 'package:flutter/material.dart';

enum AppThemeMode {
  light('light'),
  dark('dark');

  const AppThemeMode(this.storageValue);

  final String storageValue;

  ThemeMode get materialThemeMode {
    return switch (this) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
  }

  static AppThemeMode fromStorageValue(String? value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.storageValue == value,
      orElse: () => AppThemeMode.light,
    );
  }

  String get translationKey => 'theme.$storageValue';
}
