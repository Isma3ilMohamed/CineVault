/// CineVault data layer. Everything is wired through the injectable module;
/// repositories, data sources, DTOs, `processCall`, `storageCall`, `guard`
/// and `AppException` are internal: callers only ever see domain types and
/// `Result`s.
library;

export 'src/data_injection.module.dart';
export 'src/network/network_config.dart';
