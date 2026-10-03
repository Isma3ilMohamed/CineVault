import 'package:domain/domain.dart';

/// Every location in the app. Nothing else writes a path by hand: screens
/// navigate with these constants and builders, and the router matches them.
abstract final class AppRoutes {
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String search = '/search';
  static const String movieList = '$_movies/:${RouteParams.category}';
  static const String movieDetails = '$_movie/:${RouteParams.id}';

  static const String _movies = '/movies';
  static const String _movie = '/movie';

  /// `/movies/topRated`
  static String movieListOf(MovieCategory category) => '$_movies/${category.name}';

  /// `/movie/27205`, or `/movie/27205?heroTag=trending_27205` for a Hero
  /// animation. A plain URL, so it also works as a deep link.
  static String movieDetailsOf(int id, {String? heroTag}) => Uri(
    path: '$_movie/$id',
    queryParameters: heroTag == null ? null : {RouteParams.heroTag: heroTag},
  ).toString();
}

/// Names of the path and query parameters used in [AppRoutes].
abstract final class RouteParams {
  static const String id = 'id';
  static const String category = 'category';
  static const String heroTag = 'heroTag';
}
