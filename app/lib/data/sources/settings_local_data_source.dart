import 'package:cine_vault/core/constants/storage_keys.dart';
import 'package:cine_vault/data/storage/storage_call.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted as strings: theme_mode is an [AppThemeMode] name ('light' |
/// 'dark' | 'system'); locale is a language code, or absent to follow the device.
/// Every method throws a `CacheException` on failure.
abstract class SettingsLocalDataSource {
  Future<AppThemeMode> getThemeMode();
  Future<String?> getLanguageCode();

  Future<void> saveThemeMode(AppThemeMode mode);
  Future<void> saveLanguageCode(String? languageCode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<AppThemeMode> getThemeMode() => storageCall(
    'read theme mode',
    () =>
        AppThemeMode.values.asNameMap()[prefs.getString(StorageKeys.themeMode)] ??
        AppThemeMode.dark,
  );

  @override
  Future<String?> getLanguageCode() => storageCall('read locale', () {
    final code = prefs.getString(StorageKeys.locale);
    return (code == null || code.isEmpty) ? null : code;
  });

  @override
  Future<void> saveThemeMode(AppThemeMode mode) =>
      storageCall('save theme mode', () => prefs.setString(StorageKeys.themeMode, mode.name));

  @override
  Future<void> saveLanguageCode(String? languageCode) => storageCall(
    'save locale',
    () => languageCode == null
        ? prefs.remove(StorageKeys.locale)
        : prefs.setString(StorageKeys.locale, languageCode),
  );
}
