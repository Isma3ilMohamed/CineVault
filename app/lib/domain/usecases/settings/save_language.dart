import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/settings_repository.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveLanguage implements UseCase<void, SaveLanguageParams> {
  const SaveLanguage(this.repository);
  final SettingsRepository repository;

  @override
  Future<Result<void>> call(SaveLanguageParams params) {
    return repository.saveLanguageCode(params.languageCode);
  }
}

class SaveLanguageParams extends Equatable {
  const SaveLanguageParams({required this.languageCode});

  /// A null code means follow the device language.
  final String? languageCode;

  @override
  List<Object?> get props => [languageCode];
}
