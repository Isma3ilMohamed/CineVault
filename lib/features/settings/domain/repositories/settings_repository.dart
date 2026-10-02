import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/features/settings/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<Result<AppSettings>> getSettings();

  Future<Result<void>> saveThemeMode(ThemeMode mode);

  /// A null [locale] means follow the device locale.
  Future<Result<void>> saveLocale(Locale? locale);
}
