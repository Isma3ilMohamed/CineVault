import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettings implements UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;

  const GetSettings(this.repository);

  @override
  Future<Result<AppSettings>> call(NoParams params) {
    return repository.getSettings();
  }
}
