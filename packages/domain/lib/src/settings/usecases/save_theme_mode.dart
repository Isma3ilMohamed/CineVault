import 'package:core_result/core_result.dart';
import 'package:domain/src/settings/app_settings.dart';
import 'package:domain/src/settings/settings_repository.dart';
import 'package:domain/src/usecase.dart';
import 'package:equatable/equatable.dart';

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
  final AppThemeMode mode;

  @override
  List<Object> get props => [mode];
}
