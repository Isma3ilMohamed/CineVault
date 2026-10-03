/// TMDB v3 endpoints, relative to the configured base URL.
abstract final class TmdbEndpoints {
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String upcomingMovies = '/movie/upcoming';
  static const String nowPlayingMovies = '/movie/now_playing';
  static const String trendingDay = '/trending/movie/day';
  static const String genres = '/genre/movie/list';
  static const String searchMovies = '/search/movie';

  static String movie(int id) => '/movie/$id';
  static String similar(int id) => '/movie/$id/similar';
  static String credits(int id) => '/movie/$id/credits';
  static String videos(int id) => '/movie/$id/videos';
}
