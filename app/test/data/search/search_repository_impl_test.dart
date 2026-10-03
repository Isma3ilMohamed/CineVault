import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/app_exception.dart';
import 'package:cine_vault/data/models/movie_model.dart';
import 'package:cine_vault/data/repositories/search_repository_impl.dart';
import 'package:cine_vault/data/sources/recent_searches_local_data_source.dart';
import 'package:cine_vault/data/sources/search_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements SearchRemoteDataSource {}

class _MockLocal extends Mock implements RecentSearchesLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late SearchRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = SearchRepositoryImpl(remoteDataSource: remote, localDataSource: local);
  });

  test('a blank query returns no results without calling the API', () async {
    final result = await repository.searchMovies(query: '   ', page: 1);

    expect(result.valueOrNull, isEmpty);
    verifyZeroInteractions(remote);
  });

  test('trims the query before searching', () async {
    when(() => remote.searchMovies(query: 'dune', page: 1)).thenAnswer(
      (_) async => MoviesPageResponse(page: 1, results: const [], totalPages: 1, totalResults: 0),
    );

    await repository.searchMovies(query: '  dune ', page: 1);

    verify(() => remote.searchMovies(query: 'dune', page: 1)).called(1);
  });

  test('storage failures become CacheFailure', () async {
    when(local.getRecentSearches).thenThrow(const CacheException('Failed to read'));

    final result = await repository.getRecentSearches();

    expect(result.failureOrNull, const CacheFailure(message: 'Failed to read'));
  });
}
