import 'package:flutter/material.dart';

import '../../../../core/result/result.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Result<AppSettings>> getSettings();

  Future<Result<void>> saveThemeMode(ThemeMode mode);

  /// A null [locale] means follow the device locale.
  Future<Result<void>> saveLocale(Locale? locale);
}
