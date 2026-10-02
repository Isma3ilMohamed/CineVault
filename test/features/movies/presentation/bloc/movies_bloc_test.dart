import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/core/error/failures.dart';
import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:cine_vault/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockMovieRepository extends Mock implements MovieRepository {}

class FakePageParams extends Fake implements PageParams {}

void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late MockMovieRepository mockMovieRepository;
  late MoviesBloc moviesBloc;

  setUpAll(() {
    registerFallbackValue(FakePageParams());
  });

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    mockMovieRepository = MockMovieRepository();
    moviesBloc = MoviesBloc(
      getPopularMovies: mockGetPopularMovies,
      movieRepository: mockMovieRepository,
    );
  });

  tearDown(() async {
    await moviesBloc.close();
  });

  final testMovie = Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'Test overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.5,
    voteCount: 1000,
    releaseDate: DateTime(2024),
    genreIds: const [28, 12],
    originalLanguage: 'en',
    popularity: 100,
    adult: false,
  );

  final testMovies = [testMovie];

  group('MoviesBloc', () {
    test('initial state is MoviesInitial', () {
      expect(moviesBloc.state, equals(const MoviesInitial()));
    });

    group('LoadHomeMovies', () {
      blocTest<MoviesBloc, MoviesState>(
        'emits [Loading, Loaded] when all categories succeed',
        setUp: () {
          when(() => mockGetPopularMovies(any())).thenAnswer((_) async => Ok(testMovies));
          when(() => mockMovieRepository.getTopRatedMovies(page: 1))
              .thenAnswer((_) async => Ok(testMovies));
          when(() => mockMovieRepository.getUpcomingMovies(page: 1))
              .thenAnswer((_) async => Ok(testMovies));
          when(() => mockMovieRepository.getNowPlayingMovies(page: 1))
              .thenAnswer((_) async => Ok(testMovies));
          when(() => mockMovieRepository.getTrendingDayMovies(page: 1))
              .thenAnswer((_) async => Ok(testMovies));
        },
        build: () => moviesBloc,
        act: (bloc) => bloc.add(const LoadHomeMovies()),
        expect: () => [const MoviesLoading(), isA<MoviesLoaded>()],
      );

      blocTest<MoviesBloc, MoviesState>(
        'emits [Loading, Error] when getPopularMovies fails',
        setUp: () {
          when(() => mockGetPopularMovies(any()))
              .thenAnswer((_) async => const Err(ServerFailure(message: 'Server error')));
          when(() => mockMovieRepository.getTopRatedMovies(page: 1))
              .thenAnswer((_) async => Ok(testMovies));
          when(() => mockMovieRepository.getUpcomingMovies(page: 1))
              .thenAnswer((_) async => Ok(testMovies));
          when(() => mockMovieRepository.getNowPlayingMovies(page: 1))
              .thenAnswer((_) async => Ok(testMovies));
          when(() => mockMovieRepository.getTrendingDayMovies(page: 1))
              .thenAnswer((_) async => Ok(testMovies));
        },
        build: () => moviesBloc,
        act: (bloc) => bloc.add(const LoadHomeMovies()),
        expect: () => [const MoviesLoading(), const MoviesError(message: 'Server error')],
      );
    });
  });
}
