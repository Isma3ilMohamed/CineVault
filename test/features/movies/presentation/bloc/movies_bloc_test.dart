import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMoviesByCategory extends Mock implements GetMoviesByCategory {}

void main() {
  late MockGetMoviesByCategory mockGetMoviesByCategory;
  late MoviesBloc moviesBloc;

  setUpAll(() {
    registerFallbackValue(const MoviesByCategoryParams(category: MovieCategory.popular));
  });

  setUp(() {
    mockGetMoviesByCategory = MockGetMoviesByCategory();
    moviesBloc = MoviesBloc(getMoviesByCategory: mockGetMoviesByCategory);
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
        'emits [Loading, Loaded] with every category when all succeed',
        setUp: () {
          when(() => mockGetMoviesByCategory(any())).thenAnswer((_) async => Ok(testMovies));
        },
        build: () => moviesBloc,
        act: (bloc) => bloc.add(const LoadHomeMovies()),
        expect: () => [const MoviesLoading(), isA<MoviesLoaded>()],
        verify: (_) {
          for (final category in MovieCategory.values) {
            verify(() => mockGetMoviesByCategory(MoviesByCategoryParams(category: category)))
                .called(1);
          }
        },
      );

      blocTest<MoviesBloc, MoviesState>(
        'emits [Loading, Error] when one category fails',
        setUp: () {
          when(() => mockGetMoviesByCategory(any())).thenAnswer((_) async => Ok(testMovies));
          when(
            () => mockGetMoviesByCategory(
              const MoviesByCategoryParams(category: MovieCategory.popular),
            ),
          ).thenAnswer((_) async => const Err(ServerFailure(message: 'Server error')));
        },
        build: () => moviesBloc,
        act: (bloc) => bloc.add(const LoadHomeMovies()),
        expect: () => [const MoviesLoading(), const MoviesError(message: 'Server error')],
      );
    });
  });
}
