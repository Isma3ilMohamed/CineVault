import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockGetMovieDetails extends Mock implements GetMovieDetails {}

class _MockGetSimilarMovies extends Mock implements GetSimilarMovies {}

class _MockGetMovieCredits extends Mock implements GetMovieCredits {}

class _MockGetMovieTrailer extends Mock implements GetMovieTrailer {}

class _MockGetGenres extends Mock implements GetGenres {}

void main() {
  late _MockGetMovieDetails getMovieDetails;
  late _MockGetSimilarMovies getSimilarMovies;
  late _MockGetMovieCredits getMovieCredits;
  late _MockGetMovieTrailer getMovieTrailer;
  late _MockGetGenres getGenres;

  setUpAll(() {
    registerFallbackValue(const MovieIdParams(movieId: 0));
    registerFallbackValue(const SimilarMoviesParams(movieId: 0));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getMovieDetails = _MockGetMovieDetails();
    getSimilarMovies = _MockGetSimilarMovies();
    getMovieCredits = _MockGetMovieCredits();
    getMovieTrailer = _MockGetMovieTrailer();
    getGenres = _MockGetGenres();

    when(() => getMovieDetails(any())).thenAnswer((_) async => Ok(movie(1)));
    when(() => getSimilarMovies(any())).thenAnswer((_) async => Ok([movie(2)]));
    when(() => getMovieCredits(any())).thenAnswer((_) async => const Ok(castMembers));
    when(() => getMovieTrailer(any())).thenAnswer((_) async => const Ok(trailer));
    when(() => getGenres(any())).thenAnswer((_) async => const Ok(genres));
  });

  MovieDetailsBloc build() => MovieDetailsBloc(
    movieId: 1,
    getMovieDetails: getMovieDetails,
    getSimilarMovies: getSimilarMovies,
    getMovieCredits: getMovieCredits,
    getMovieTrailer: getMovieTrailer,
    getGenres: getGenres,
  );

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
    verify: (_) => verify(() => getMovieDetails(const MovieIdParams(movieId: 1))).called(1),
  );

  blocTest<MovieDetailsBloc, MovieDetailsState>(
    'a details failure is the error state, carrying the Failure itself',
    setUp: () =>
        when(() => getMovieDetails(any())).thenAnswer((_) async => const Err(NetworkFailure())),
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
      when(() => getSimilarMovies(any())).thenAnswer((_) async => const Err(failure));
      when(() => getMovieCredits(any())).thenAnswer((_) async => const Err(failure));
      when(() => getMovieTrailer(any())).thenAnswer((_) async => const Err(failure));
      when(() => getGenres(any())).thenAnswer((_) async => const Err(failure));
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
