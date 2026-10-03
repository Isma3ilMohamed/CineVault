import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/guard.dart';
import 'package:cine_vault/data/repositories/search_repository.dart';
import 'package:cine_vault/data/sources/recent_searches_local_data_source.dart';
import 'package:cine_vault/data/sources/search_remote_data_source.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required this.remoteDataSource, required this.localDataSource});
  final SearchRemoteDataSource remoteDataSource;
  final RecentSearchesLocalDataSource localDataSource;

  @override
  Future<Result<List<Movie>>> searchMovies({required String query, int page = 1}) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return Future.value(const Ok(<Movie>[]));

    return guard(() async {
      final response = await remoteDataSource.searchMovies(query: trimmed, page: page);
      return response.results.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<String>>> getRecentSearches() => guard(localDataSource.getRecentSearches);

  @override
  Future<Result<void>> saveRecentSearch(String query) =>
      guard(() => localDataSource.saveRecentSearch(query));

  @override
  Future<Result<void>> clearRecentSearches() => guard(localDataSource.clearRecentSearches);
}
