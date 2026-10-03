/// CineVault business layer: entities, repository contracts and use cases.
/// Pure Dart: no Flutter, no data-layer types.
library;

export '../data/repositories/favorites_repository.dart';
export '../data/repositories/movie_repository.dart';
export '../data/repositories/search_repository.dart';
export '../data/repositories/settings_repository.dart';
export 'models/app_settings.dart';
export 'models/cast_member.dart';
export 'models/genre.dart';
export 'models/movie.dart';
export 'models/movie_category.dart';
export 'models/video.dart';
export 'usecases/favorites/is_favorite.dart';
export 'usecases/favorites/toggle_favorite.dart';
export 'usecases/favorites/watch_favorite_ids.dart';
export 'usecases/favorites/watch_favorites.dart';
export 'usecases/movies/get_genres.dart';
export 'usecases/movies/get_movie_credits.dart';
export 'usecases/movies/get_movie_details.dart';
export 'usecases/movies/get_movie_trailer.dart';
export 'usecases/movies/get_movies_by_category.dart';
export 'usecases/movies/get_similar_movies.dart';
export 'usecases/search/clear_recent_searches.dart';
export 'usecases/search/get_recent_searches.dart';
export 'usecases/search/save_recent_search.dart';
export 'usecases/search/search_movies.dart';
export 'usecases/settings/get_settings.dart';
export 'usecases/settings/save_language.dart';
export 'usecases/settings/save_theme_mode.dart';
export 'usecases/usecase.dart';
