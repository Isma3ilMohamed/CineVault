/// TMDB v3 endpoints. Paths are relative to [baseUrl] (the default; each
/// flavor's config can override it).
abstract final class ApiEndpoints {
  static const String baseUrl = 'https://api.themoviedb.org/3';

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
