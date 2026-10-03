import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/movie.dart';
import 'package:domain/src/movies/entities/movie_category.dart';
import 'package:domain/src/movies/movie_repository.dart';
import 'package:domain/src/usecase.dart';
import 'package:equatable/equatable.dart';

/// One page of movies for a [MovieCategory] list.
class GetMoviesByCategory implements UseCase<List<Movie>, MoviesByCategoryParams> {
  const GetMoviesByCategory(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Movie>>> call(MoviesByCategoryParams params) {
    final page = params.page;
    return switch (params.category) {
      MovieCategory.trending => repository.getTrendingDayMovies(page: page),
      MovieCategory.popular => repository.getPopularMovies(page: page),
      MovieCategory.topRated => repository.getTopRatedMovies(page: page),
      MovieCategory.nowPlaying => repository.getNowPlayingMovies(page: page),
      MovieCategory.upcoming => repository.getUpcomingMovies(page: page),
    };
  }
}

class MoviesByCategoryParams extends Equatable {
  const MoviesByCategoryParams({required this.category, this.page = 1});
  final MovieCategory category;
  final int page;

  @override
  List<Object> get props => [category, page];
}
