import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late _MockMovieRepository repository;
  late GetMoviesByCategory getMoviesByCategory;

  setUp(() {
    repository = _MockMovieRepository();
    getMoviesByCategory = GetMoviesByCategory(repository);
  });

  Future<Result<List<Movie>>> ok() async => const Ok(<Movie>[]);

  final routes = <MovieCategory, Future<Result<List<Movie>>> Function()>{
    MovieCategory.trending: () => repository.getTrendingDayMovies(page: 3),
    MovieCategory.popular: () => repository.getPopularMovies(page: 3),
    MovieCategory.topRated: () => repository.getTopRatedMovies(page: 3),
    MovieCategory.nowPlaying: () => repository.getNowPlayingMovies(page: 3),
    MovieCategory.upcoming: () => repository.getUpcomingMovies(page: 3),
  };

  test('covers every category', () {
    expect(routes.keys, unorderedEquals(MovieCategory.values));
  });

  for (final MapEntry(key: category, value: call) in routes.entries) {
    test('${category.name} asks the repository for its list with the given page', () async {
      when(call).thenAnswer((_) => ok());

      await getMoviesByCategory(MoviesByCategoryParams(category: category, page: 3));

      verify(call).called(1);
      verifyNoMoreInteractions(repository);
    });
  }

  test('defaults to the first page', () {
    expect(const MoviesByCategoryParams(category: MovieCategory.popular).page, 1);
  });
}
