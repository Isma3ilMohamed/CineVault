/// ببساطة كدا: دي الثوابت الأساسية للتطبيق
/// زي الـ Constants object في Kotlin
class AppConstants {
  AppConstants._(); // private constructor - زي object في Kotlin

  // Cache
  static const Duration cacheValidDuration = Duration(hours: 1);
  static const int maxCacheItems = 100;

  // Pagination
  static const int defaultPageSize = 20;
  static const int initialPage = 1;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Image sizes (TMDB specific)
  static const String posterSize = 'w500';
  static const String backdropSize = 'w1280';
  static const String profileSize = 'w185';
}

/// TMDB API specific constants
class ApiConstants {
  ApiConstants._();

  // Endpoints
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String upcomingMovies = '/movie/upcoming';
  static const String nowPlayingMovies = '/movie/now_playing';
  static const String trendingDay = '/trending/movie/day';
  static const String movieDetails = '/movie';
  static const String searchMovies = '/search/movie';
  static const String genres = '/genre/movie/list';
  static const String movieVideos = '/movie/{id}/videos';
  static const String movieCredits = '/movie/{id}/credits';
  static const String similarMovies = '/movie/{id}/similar';
}
