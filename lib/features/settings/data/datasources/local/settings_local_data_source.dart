import 'package:cine_vault/core/error/exceptions.dart';
import 'package:domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted as strings: theme_mode is an [AppThemeMode] name ('light' |
/// 'dark' | 'system'); locale is a language code, or absent to follow the device.
abstract class SettingsLocalDataSource {
  AppThemeMode getThemeMode();
  String? getLanguageCode();

  Future<void> saveThemeMode(AppThemeMode mode);
  Future<void> saveLanguageCode(String? languageCode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this.prefs);
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  final SharedPreferences prefs;

  @override
  AppThemeMode getThemeMode() {
    try {
      final value = prefs.getString(_themeModeKey);
      return AppThemeMode.values.asNameMap()[value] ?? AppThemeMode.dark;
    } catch (e) {
      throw CacheException(message: 'Failed to read theme mode: $e');
    }
  }

  @override
  String? getLanguageCode() {
    try {
      final code = prefs.getString(_localeKey);
      return (code == null || code.isEmpty) ? null : code;
    } catch (e) {
      throw CacheException(message: 'Failed to read locale: $e');
    }
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    try {
      await prefs.setString(_themeModeKey, mode.name);
    } catch (e) {
      throw CacheException(message: 'Failed to save theme mode: $e');
    }
  }

  @override
  Future<void> saveLanguageCode(String? languageCode) async {
    try {
      if (languageCode == null) {
        await prefs.remove(_localeKey);
      } else {
        await prefs.setString(_localeKey, languageCode);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save locale: $e');
    }
  }
}
