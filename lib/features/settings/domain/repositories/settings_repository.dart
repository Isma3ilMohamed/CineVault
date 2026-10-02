import 'package:flutter/material.dart';

import '../../../../core/result/result.dart';
import '../entities/app_settings.dart';

/// ببساطة كدا: contract بتاع settings feature
abstract class SettingsRepository {
  Future<Result<AppSettings>> getSettings();

  Future<Result<void>> saveThemeMode(ThemeMode mode);

  /// locale = null يعني "follow system"
  Future<Result<void>> saveLocale(Locale? locale);
}
