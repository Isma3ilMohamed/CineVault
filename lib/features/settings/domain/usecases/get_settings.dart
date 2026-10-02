import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/settings/domain/entities/app_settings.dart';
import 'package:cine_vault/features/settings/domain/repositories/settings_repository.dart';
import 'package:core_result/core_result.dart';

class GetSettings implements UseCase<AppSettings, NoParams> {
  const GetSettings(this.repository);
  final SettingsRepository repository;

  @override
  Future<Result<AppSettings>> call(NoParams params) {
    return repository.getSettings();
  }
}
