/// CineVault data layer: repository implementations and what they need to be
/// wired up. DTOs, `processCall`, `storageCall`, `guard` and `AppException` are
/// internal: callers only ever see domain types and `Result`s.
library;

export 'src/favorites/favorites_local_data_source.dart';
export 'src/favorites/favorites_repository_impl.dart';
export 'src/movies/movie_remote_data_source.dart';
export 'src/movies/movie_repository_impl.dart';
export 'src/network/dio_client.dart';
export 'src/search/recent_searches_local_data_source.dart';
export 'src/search/search_remote_data_source.dart';
export 'src/search/search_repository_impl.dart';
export 'src/settings/settings_local_data_source.dart';
export 'src/settings/settings_repository_impl.dart';
