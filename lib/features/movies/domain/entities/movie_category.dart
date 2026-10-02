enum MovieCategory {
  trending,
  popular,
  topRated,
  nowPlaying,
  upcoming;

  /// URL slug used in the `/list/:category` route.
  String get slug => switch (this) {
        MovieCategory.trending => 'trending',
        MovieCategory.popular => 'popular',
        MovieCategory.topRated => 'top_rated',
        MovieCategory.nowPlaying => 'now_playing',
        MovieCategory.upcoming => 'upcoming',
      };

  static MovieCategory? fromSlug(String? slug) {
    return switch (slug) {
      'trending' => MovieCategory.trending,
      'popular' => MovieCategory.popular,
      'top_rated' => MovieCategory.topRated,
      'now_playing' => MovieCategory.nowPlaying,
      'upcoming' => MovieCategory.upcoming,
      _ => null,
    };
  }
}
