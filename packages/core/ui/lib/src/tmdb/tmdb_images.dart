/// TMDB image CDN URLs from the relative paths the API returns.
abstract final class TmdbImages {
  static const _base = 'https://image.tmdb.org/t/p';

  /// Width / height of each image kind, for `RemoteImage.sourceAspectRatio`.
  static const double posterAspectRatio = 2 / 3;
  static const double backdropAspectRatio = 16 / 9;
  static const double profileAspectRatio = 2 / 3;

  static String? poster(String? path) => _url('w500', path);
  static String? backdrop(String? path) => _url('w1280', path);
  static String? profile(String? path) => _url('w185', path);

  static String? _url(String size, String? path) => path == null ? null : '$_base/$size$path';
}

/// Display formatting shared by movie screens.
abstract final class MovieFormat {
  /// One decimal place (TMDB rates out of 10).
  static String rating(double voteAverage) => voteAverage.toStringAsFixed(1);

  /// Null when the date is unknown; widgets show the localized fallback.
  static String? year(DateTime? date) => date?.year.toString();
}
