import 'package:cine_vault/data/models/movie_model.dart';
import 'package:cine_vault/data/repositories/movie_repository_impl.dart';
import 'package:cine_vault/data/sources/movie_remote_data_source.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements MovieRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late MovieRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = MovieRepositoryImpl(remoteDataSource: remote);
  });

  Future<MoviesPageResponse> empty() async =>
      MoviesPageResponse(page: 1, results: const [], totalPages: 1, totalResults: 0);

  final endpoints = <MovieCategory, Future<MoviesPageResponse> Function(int page)>{
    MovieCategory.trending: (page) => remote.getTrendingDayMovies(page: page),
    MovieCategory.popular: (page) => remote.getPopularMovies(page: page),
    MovieCategory.topRated: (page) => remote.getTopRatedMovies(page: page),
    MovieCategory.nowPlaying: (page) => remote.getNowPlayingMovies(page: page),
    MovieCategory.upcoming: (page) => remote.getUpcomingMovies(page: page),
  };

  test('covers every category', () {
    expect(endpoints.keys, unorderedEquals(MovieCategory.values));
  });

  for (final MapEntry(key: category, value: endpoint) in endpoints.entries) {
    test('${category.name} asks its own endpoint for the given page', () async {
      when(() => endpoint(3)).thenAnswer((_) => empty());

      await repository.getMoviesByCategory(category, page: 3);

      verify(() => endpoint(3)).called(1);
      verifyNoMoreInteractions(remote);
    });
  }

  test('defaults to the first page', () async {
    when(() => remote.getPopularMovies(page: 1)).thenAnswer((_) => empty());

    await repository.getMoviesByCategory(MovieCategory.popular);

    verify(() => remote.getPopularMovies(page: 1)).called(1);
  });
}
