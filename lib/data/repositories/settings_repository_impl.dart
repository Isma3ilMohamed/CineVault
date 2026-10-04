import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/guard.dart';
import 'package:cine_vault/data/repositories/settings_repository.dart';
import 'package:cine_vault/data/sources/settings_local_data_source.dart';
import 'package:cine_vault/domain/domain.dart';

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
