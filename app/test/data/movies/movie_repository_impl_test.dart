import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/app_exception.dart';
import 'package:cine_vault/data/models/cast_member_model.dart';
import 'package:cine_vault/data/models/movie_model.dart';
import 'package:cine_vault/data/repositories/movie_repository_impl.dart';
import 'package:cine_vault/data/sources/movie_remote_data_source.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements MovieRemoteDataSource {}

MovieModel _movieModel(int id) => MovieModel(
  id: id,
  title: 'Movie $id',
  overview: '',
  voteAverage: 7.5,
  voteCount: 10,
  genreIds: const [1],
  originalLanguage: 'en',
  popularity: 1,
  adult: false,
);

void main() {
  late _MockRemote remote;
  late MovieRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = MovieRepositoryImpl(remoteDataSource: remote);
  });

  test('maps a page of DTOs to domain movies', () async {
    when(() => remote.getPopularMovies(page: 2)).thenAnswer(
      (_) async => MoviesPageResponse(
        page: 2,
        results: [_movieModel(1), _movieModel(2)],
        totalPages: 5,
        totalResults: 100,
      ),
    );

    final result = await repository.getPopularMovies(page: 2);

    expect(result.valueOrNull?.map((m) => m.id), [1, 2]);
    expect(result.valueOrNull?.first.title, 'Movie 1');
  });

  test('sorts the cast by billing order', () async {
    when(() => remote.getMovieCredits(movieId: 7)).thenAnswer(
      (_) async => const CreditsResponse(
        cast: [
          CastMemberModel(id: 1, name: 'Third', character: '', order: 2),
          CastMemberModel(id: 2, name: 'First', character: '', order: 0),
          CastMemberModel(id: 3, name: 'Second', character: '', order: 1),
        ],
      ),
    );

    final result = await repository.getMovieCredits(movieId: 7);

    expect(result.valueOrNull?.map((c) => c.name), ['First', 'Second', 'Third']);
  });

  test('turns data source exceptions into failures', () async {
    when(() => remote.getMovieDetails(movieId: 7)).thenThrow(const NoInternetException());
    when(() => remote.getTopRatedMovies(page: 1))
        .thenThrow(const ServerException('Invalid API key', statusCode: 401));

    expect((await repository.getMovieDetails(movieId: 7)).failureOrNull, isA<NetworkFailure>());
    expect(
      (await repository.getTopRatedMovies(page: 1)).failureOrNull,
      const ServerFailure(message: 'Invalid API key', statusCode: 401),
    );
  });

  test('details are mapped to an entity', () async {
    when(() => remote.getMovieDetails(movieId: 7)).thenAnswer((_) async => _movieModel(7));

    final result = await repository.getMovieDetails(movieId: 7);

    expect(result, isA<Ok<Movie>>());
    expect(result.valueOrNull?.id, 7);
  });
}
