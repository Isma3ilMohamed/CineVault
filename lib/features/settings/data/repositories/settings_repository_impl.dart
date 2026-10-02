import 'package:flutter/material.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<AppSettings>> getSettings() async {
    try {
      return Ok(AppSettings(
        themeMode: localDataSource.getThemeMode(),
        locale: localDataSource.getLocale(),
      ));
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> saveThemeMode(ThemeMode mode) async {
    try {
      await localDataSource.saveThemeMode(mode);
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> saveLocale(Locale? locale) async {
    try {
      await localDataSource.saveLocale(locale);
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }
}
