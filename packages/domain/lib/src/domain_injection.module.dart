// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:domain/src/favorites/favorites_repository.dart' as _i476;
import 'package:domain/src/favorites/usecases/is_favorite.dart' as _i915;
import 'package:domain/src/favorites/usecases/toggle_favorite.dart' as _i356;
import 'package:domain/src/favorites/usecases/watch_favorite_ids.dart' as _i521;
import 'package:domain/src/favorites/usecases/watch_favorites.dart' as _i587;
import 'package:domain/src/movies/movie_repository.dart' as _i702;
import 'package:domain/src/movies/usecases/get_genres.dart' as _i979;
import 'package:domain/src/movies/usecases/get_movie_credits.dart' as _i753;
import 'package:domain/src/movies/usecases/get_movie_details.dart' as _i884;
import 'package:domain/src/movies/usecases/get_movie_trailer.dart' as _i800;
import 'package:domain/src/movies/usecases/get_movies_by_category.dart' as _i543;
import 'package:domain/src/movies/usecases/get_similar_movies.dart' as _i389;
import 'package:domain/src/search/search_repository.dart' as _i860;
import 'package:domain/src/search/usecases/clear_recent_searches.dart' as _i306;
import 'package:domain/src/search/usecases/get_recent_searches.dart' as _i714;
import 'package:domain/src/search/usecases/save_recent_search.dart' as _i28;
import 'package:domain/src/search/usecases/search_movies.dart' as _i703;
import 'package:domain/src/settings/settings_repository.dart' as _i52;
import 'package:domain/src/settings/usecases/get_settings.dart' as _i602;
import 'package:domain/src/settings/usecases/save_language.dart' as _i817;
import 'package:domain/src/settings/usecases/save_theme_mode.dart' as _i925;
import 'package:injectable/injectable.dart' as _i526;

class DomainPackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i979.GetGenres>(() => _i979.GetGenres(gh<_i702.MovieRepository>()));
    gh.lazySingleton<_i753.GetMovieCredits>(
      () => _i753.GetMovieCredits(gh<_i702.MovieRepository>()),
    );
    gh.lazySingleton<_i884.GetMovieDetails>(
      () => _i884.GetMovieDetails(gh<_i702.MovieRepository>()),
    );
    gh.lazySingleton<_i800.GetMovieTrailer>(
      () => _i800.GetMovieTrailer(gh<_i702.MovieRepository>()),
    );
    gh.lazySingleton<_i543.GetMoviesByCategory>(
      () => _i543.GetMoviesByCategory(gh<_i702.MovieRepository>()),
    );
    gh.lazySingleton<_i389.GetSimilarMovies>(
      () => _i389.GetSimilarMovies(gh<_i702.MovieRepository>()),
    );
    gh.lazySingleton<_i915.IsFavorite>(() => _i915.IsFavorite(gh<_i476.FavoritesRepository>()));
    gh.lazySingleton<_i356.ToggleFavorite>(
      () => _i356.ToggleFavorite(gh<_i476.FavoritesRepository>()),
    );
    gh.lazySingleton<_i521.WatchFavoriteIds>(
      () => _i521.WatchFavoriteIds(gh<_i476.FavoritesRepository>()),
    );
    gh.lazySingleton<_i587.WatchFavorites>(
      () => _i587.WatchFavorites(gh<_i476.FavoritesRepository>()),
    );
    gh.lazySingleton<_i602.GetSettings>(() => _i602.GetSettings(gh<_i52.SettingsRepository>()));
    gh.lazySingleton<_i817.SaveLanguage>(() => _i817.SaveLanguage(gh<_i52.SettingsRepository>()));
    gh.lazySingleton<_i925.SaveThemeMode>(() => _i925.SaveThemeMode(gh<_i52.SettingsRepository>()));
    gh.lazySingleton<_i306.ClearRecentSearches>(
      () => _i306.ClearRecentSearches(gh<_i860.SearchRepository>()),
    );
    gh.lazySingleton<_i714.GetRecentSearches>(
      () => _i714.GetRecentSearches(gh<_i860.SearchRepository>()),
    );
    gh.lazySingleton<_i28.SaveRecentSearch>(
      () => _i28.SaveRecentSearch(gh<_i860.SearchRepository>()),
    );
    gh.lazySingleton<_i703.SearchMovies>(() => _i703.SearchMovies(gh<_i860.SearchRepository>()));
  }
}
