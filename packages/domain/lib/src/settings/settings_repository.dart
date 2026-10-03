import 'package:core_result/core_result.dart';
import 'package:domain/src/settings/app_settings.dart';

abstract class SettingsRepository {
  Future<Result<AppSettings>> getSettings();

  Future<Result<void>> saveThemeMode(AppThemeMode mode);

  /// A null [languageCode] means follow the device language.
  Future<Result<void>> saveLanguageCode(String? languageCode);
}
