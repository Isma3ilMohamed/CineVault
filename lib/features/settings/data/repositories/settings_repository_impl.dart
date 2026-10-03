import 'package:cine_vault/core/error/exceptions.dart';
import 'package:cine_vault/features/settings/data/datasources/local/settings_local_data_source.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.localDataSource});
  final SettingsLocalDataSource localDataSource;

  @override
  Future<Result<AppSettings>> getSettings() async {
    try {
      return Ok(
        AppSettings(
          themeMode: localDataSource.getThemeMode(),
          languageCode: localDataSource.getLanguageCode(),
        ),
      );
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } on Object catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> saveThemeMode(AppThemeMode mode) async {
    try {
      await localDataSource.saveThemeMode(mode);
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } on Object catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> saveLanguageCode(String? languageCode) async {
    try {
      await localDataSource.saveLanguageCode(languageCode);
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } on Object catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }
}
