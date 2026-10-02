import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/error/exceptions.dart';

/// ببساطة كدا: ThemeMode + Locale stored في shared_preferences كـ strings
/// - theme_mode: 'light' | 'dark' | 'system'
/// - locale: 'en' | 'ar' | null (null → system default)
abstract class SettingsLocalDataSource {
  ThemeMode getThemeMode();
  Locale? getLocale();

  Future<void> saveThemeMode(ThemeMode mode);
  Future<void> saveLocale(Locale? locale);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  final SharedPreferences prefs;

  SettingsLocalDataSourceImpl(this.prefs);

  @override
  ThemeMode getThemeMode() {
    try {
      final value = prefs.getString(_themeModeKey);
      return switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => ThemeMode.dark, // default
      };
    } catch (e) {
      throw CacheException(message: 'Failed to read theme mode: $e');
    }
  }

  @override
  Locale? getLocale() {
    try {
      final code = prefs.getString(_localeKey);
      if (code == null || code.isEmpty) return null;
      return Locale(code);
    } catch (e) {
      throw CacheException(message: 'Failed to read locale: $e');
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      final value = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await prefs.setString(_themeModeKey, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save theme mode: $e');
    }
  }

  @override
  Future<void> saveLocale(Locale? locale) async {
    try {
      if (locale == null) {
        await prefs.remove(_localeKey);
      } else {
        await prefs.setString(_localeKey, locale.languageCode);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save locale: $e');
    }
  }
}
