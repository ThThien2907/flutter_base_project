import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../core/storage/storage_keys.dart';
import 'app_theme_mode.dart';

@lazySingleton
class ThemeStorage {
  const ThemeStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<AppThemeMode> readThemeMode() async {
    try {
      final value = await _storage.read(key: StorageKeys.themeMode);
      return AppThemeMode.fromStorageValue(value);
    } catch (_) {
      return AppThemeMode.light;
    }
  }

  Future<void> writeThemeMode(AppThemeMode mode) async {
    try {
      await _storage.write(
        key: StorageKeys.themeMode,
        value: mode.storageValue,
      );
    } catch (_) {
      // Best effort write
    }
  }
}
