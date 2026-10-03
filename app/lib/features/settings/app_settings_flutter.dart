import 'package:cine_vault/domain/domain.dart';
import 'package:flutter/material.dart';

/// Bridges the Flutter-free [AppSettings] to what MaterialApp expects.
extension AppSettingsFlutter on AppSettings {
  ThemeMode get flutterThemeMode => switch (themeMode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  /// Null follows the device locale.
  Locale? get locale => languageCode == null ? null : Locale(languageCode!);
}
