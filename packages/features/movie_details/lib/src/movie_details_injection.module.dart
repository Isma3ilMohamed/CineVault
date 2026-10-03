// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:domain/domain.dart' as _i494;
import 'package:injectable/injectable.dart' as _i526;
import 'package:movie_details/src/movie_details_bloc.dart' as _i65;

class MovieDetailsPackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factoryParam<_i65.MovieDetailsBloc, int, dynamic>(
      (movieId, _) => _i65.MovieDetailsBloc(
        movieId: movieId,
        getMovieDetails: gh<_i494.GetMovieDetails>(),
        getSimilarMovies: gh<_i494.GetSimilarMovies>(),
        getMovieCredits: gh<_i494.GetMovieCredits>(),
        getMovieTrailer: gh<_i494.GetMovieTrailer>(),
        getGenres: gh<_i494.GetGenres>(),
      ),
    );
  }
}
