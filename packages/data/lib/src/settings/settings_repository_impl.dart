import 'package:core_result/core_result.dart';
import 'package:data/src/error/guard.dart';
import 'package:data/src/settings/settings_local_data_source.dart';
import 'package:domain/domain.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.localDataSource});
  final SettingsLocalDataSource localDataSource;

  @override
  Future<Result<AppSettings>> getSettings() => guard(
    () async => AppSettings(
      themeMode: await localDataSource.getThemeMode(),
      languageCode: await localDataSource.getLanguageCode(),
    ),
  );

  @override
  Future<Result<void>> saveThemeMode(AppThemeMode mode) =>
      guard(() => localDataSource.saveThemeMode(mode));

  @override
  Future<Result<void>> saveLanguageCode(String? languageCode) =>
      guard(() => localDataSource.saveLanguageCode(languageCode));
}
