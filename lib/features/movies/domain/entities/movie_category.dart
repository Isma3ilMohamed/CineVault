/// ببساطة كدا: enum للـ categories اللي على الـ home page
/// كل واحدة بيترجم لـ:
///  - repository method
///  - route parameter (slug)
///  - l10n key (للـ title)
///  - hero tag prefix
enum MovieCategory {
  trending,
  popular,
  topRated,
  nowPlaying,
  upcoming;

  /// Slug الـ URL — بيتستخدم في /list/:category
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
