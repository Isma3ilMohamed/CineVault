import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/settings_repository.dart';

class SaveThemeMode implements UseCase<void, SaveThemeModeParams> {
  final SettingsRepository repository;

  const SaveThemeMode(this.repository);

  @override
  Future<Result<void>> call(SaveThemeModeParams params) {
    return repository.saveThemeMode(params.mode);
  }
}

class SaveThemeModeParams extends Equatable {
  final ThemeMode mode;

  const SaveThemeModeParams({required this.mode});

  @override
  List<Object> get props => [mode];
}
