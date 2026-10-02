import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/settings/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SaveThemeMode implements UseCase<void, SaveThemeModeParams> {
  const SaveThemeMode(this.repository);
  final SettingsRepository repository;

  @override
  Future<Result<void>> call(SaveThemeModeParams params) {
    return repository.saveThemeMode(params.mode);
  }
}

class SaveThemeModeParams extends Equatable {
  const SaveThemeModeParams({required this.mode});
  final ThemeMode mode;

  @override
  List<Object> get props => [mode];
}
