import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/settings_repository.dart';
import 'package:cine_vault/domain/models/app_settings.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
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
