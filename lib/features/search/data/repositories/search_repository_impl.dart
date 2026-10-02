import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/local/recent_searches_local_data_source.dart';
import '../datasources/remote/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final RecentSearchesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<List<Movie>>> searchMovies({
    required String query,
    required int page,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const Ok(<Movie>[]);
    }

    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.searchMovies(
        query: trimmed,
        page: page,
      );
      final movies = response.results.map((m) => m.toEntity()).toList();
      return Ok(movies);
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getRecentSearches() async {
    try {
      final list = await localDataSource.getRecentSearches();
      return Ok(list);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> saveRecentSearch(String query) async {
    try {
      await localDataSource.saveRecentSearch(query);
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> clearRecentSearches() async {
    try {
      await localDataSource.clearRecentSearches();
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }
}
