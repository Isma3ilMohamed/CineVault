import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/settings/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SaveLocale implements UseCase<void, SaveLocaleParams> {
  const SaveLocale(this.repository);
  final SettingsRepository repository;

  @override
  Future<Result<void>> call(SaveLocaleParams params) {
    return repository.saveLocale(params.locale);
  }
}

class SaveLocaleParams extends Equatable {
  const SaveLocaleParams({required this.locale});

  /// A null locale means follow the device locale.
  final Locale? locale;

  @override
  List<Object?> get props => [locale];
}
