/// TMDB image CDN URLs from the relative paths the API returns.
abstract final class TmdbImages {
  static const _base = 'https://image.tmdb.org/t/p';

  static String? poster(String? path) => _url('w500', path);
  static String? backdrop(String? path) => _url('w1280', path);
  static String? profile(String? path) => _url('w185', path);

  static String? _url(String size, String? path) => path == null ? null : '$_base/$size$path';
}

/// Display formatting shared by movie screens.
abstract final class MovieFormat {
  /// One decimal place (TMDB rates out of 10).
  static String rating(double voteAverage) => voteAverage.toStringAsFixed(1);

  // TODO(phase-6): localize the 'N/A' fallback.
  static String year(DateTime? date) => date?.year.toString() ?? 'N/A';
}
