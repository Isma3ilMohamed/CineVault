import 'package:get_it/get_it.dart';
import 'package:movie_details/src/movie_details_bloc.dart';

/// Registers this feature's bloc. The use cases must already be registered.
void registerMovieDetailsDependencies(GetIt getIt) {
  getIt.registerFactoryParam<MovieDetailsBloc, int, void>(
    (movieId, _) => MovieDetailsBloc(
      movieId: movieId,
      getMovieDetails: getIt(),
      getSimilarMovies: getIt(),
      getMovieCredits: getIt(),
      getMovieTrailer: getIt(),
      getGenres: getIt(),
    ),
  );
}
