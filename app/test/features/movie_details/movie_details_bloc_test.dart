import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late _MockMovieRepository repository;

  setUp(() {
    repository = _MockMovieRepository();
    when(() => repository.getMovieDetails(movieId: 1)).thenAnswer((_) async => Ok(movie(1)));
    when(() => repository.getSimilarMovies(movieId: 1)).thenAnswer((_) async => Ok([movie(2)]));
    when(() => repository.getMovieCredits(movieId: 1))
        .thenAnswer((_) async => const Ok(castMembers));
    when(() => repository.getMovieTrailer(movieId: 1)).thenAnswer((_) async => const Ok(trailer));
    when(() => repository.getGenres()).thenAnswer((_) async => const Ok(genres));
  });

  MovieDetailsBloc build() => MovieDetailsBloc(movieId: 1, movieRepository: repository);

  blocTest<MovieDetailsBloc, MovieDetailsState>(
    'started loads everything and maps genre ids to names',
    build: build,
    act: (bloc) => bloc.add(const MovieDetailsEvent.started()),
    expect: () => [
      const MovieDetailsState.loading(),
      MovieDetailsState.loaded(
        movie: movie(1),
        similarMovies: [movie(2)],
        cast: castMembers,
        genres: const ['Action', 'Science Fiction'],
        trailer: trailer,
      ),
    ],
    verify: (_) => verify(() => repository.getMovieDetails(movieId: 1)).called(1),
  );

  blocTest<MovieDetailsBloc, MovieDetailsState>(
    'a details failure is the error state, carrying the Failure itself',
    setUp: () =>
        when(() => repository.getMovieDetails(movieId: 1))
            .thenAnswer((_) async => const Err(NetworkFailure())),
    build: build,
    act: (bloc) => bloc.add(const MovieDetailsEvent.started()),
    expect: () => [
      const MovieDetailsState.loading(),
      const MovieDetailsState.error(NetworkFailure()),
    ],
  );

  blocTest<MovieDetailsBloc, MovieDetailsState>(
    'secondary failures fall back to empty values instead of failing the screen',
    setUp: () {
      const failure = ServerFailure(message: 'down');
      when(() => repository.getSimilarMovies(movieId: 1))
          .thenAnswer((_) async => const Err(failure));
      when(() => repository.getMovieCredits(movieId: 1))
          .thenAnswer((_) async => const Err(failure));
      when(() => repository.getMovieTrailer(movieId: 1))
          .thenAnswer((_) async => const Err(failure));
      when(() => repository.getGenres()).thenAnswer((_) async => const Err(failure));
    },
    build: build,
    act: (bloc) => bloc.add(const MovieDetailsEvent.started()),
    expect: () => [
      const MovieDetailsState.loading(),
      MovieDetailsState.loaded(
        movie: movie(1),
        similarMovies: const [],
        cast: const [],
        genres: const [],
      ),
    ],
  );

  blocTest<MovieDetailsBloc, MovieDetailsState>(
    'retried from the error state loads again',
    build: build,
    seed: () => const MovieDetailsState.error(NetworkFailure()),
    act: (bloc) => bloc.add(const MovieDetailsEvent.retried()),
    expect: () => [const MovieDetailsState.loading(), isA<MovieDetailsLoaded>()],
  );
}
