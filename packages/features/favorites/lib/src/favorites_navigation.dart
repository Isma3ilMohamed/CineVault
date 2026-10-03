/// Navigation requested by the UI (direct taps). The Route turns each one into
/// a call to the callback it received from the navigation layer.
sealed class FavoritesNavigation {
  const FavoritesNavigation();
}

final class OpenMovie extends FavoritesNavigation {
  const OpenMovie({required this.movieId, required this.heroTag});

  final int movieId;
  final String heroTag;
}

/// From the empty state's call to action.
final class OpenSearch extends FavoritesNavigation {
  const OpenSearch();
}
