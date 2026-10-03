import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/settings_repository.dart';
import 'package:cine_vault/domain/models/app_settings.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSettings implements UseCase<AppSettings, NoParams> {
  const GetSettings(this.repository);
  final SettingsRepository repository;

  @override
  Future<Result<AppSettings>> call(NoParams params) {
    return repository.getSettings();
  }
}
