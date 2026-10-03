/// CineVault business layer: entities, repository contracts and use cases.
/// Pure Dart: no Flutter, no data-layer types.
library;

export 'src/favorites/favorites_repository.dart';
export 'src/favorites/usecases/is_favorite.dart';
export 'src/favorites/usecases/toggle_favorite.dart';
export 'src/favorites/usecases/watch_favorite_ids.dart';
export 'src/favorites/usecases/watch_favorites.dart';
export 'src/movies/entities/cast_member.dart';
export 'src/movies/entities/genre.dart';
export 'src/movies/entities/movie.dart';
export 'src/movies/entities/movie_category.dart';
export 'src/movies/entities/video.dart';
export 'src/movies/movie_repository.dart';
export 'src/movies/usecases/get_genres.dart';
export 'src/movies/usecases/get_movie_credits.dart';
export 'src/movies/usecases/get_movie_details.dart';
export 'src/movies/usecases/get_movie_videos.dart';
export 'src/movies/usecases/get_popular_movies.dart';
export 'src/movies/usecases/get_similar_movies.dart';
export 'src/search/search_repository.dart';
export 'src/search/usecases/clear_recent_searches.dart';
export 'src/search/usecases/get_recent_searches.dart';
export 'src/search/usecases/save_recent_search.dart';
export 'src/search/usecases/search_movies.dart';
export 'src/settings/app_settings.dart';
export 'src/settings/settings_repository.dart';
export 'src/settings/usecases/get_settings.dart';
export 'src/settings/usecases/save_language.dart';
export 'src/settings/usecases/save_theme_mode.dart';
export 'src/usecase.dart';
