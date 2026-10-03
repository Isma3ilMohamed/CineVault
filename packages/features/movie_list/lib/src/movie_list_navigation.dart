/// Navigation requested by the UI (direct taps). The Route turns each one into
/// a call to the callback it received from the navigation layer.
sealed class MovieListNavigation {
  const MovieListNavigation();
}

final class NavigateBack extends MovieListNavigation {
  const NavigateBack();
}

final class OpenMovie extends MovieListNavigation {
  const OpenMovie({required this.movieId, required this.heroTag});

  final int movieId;
  final String heroTag;
}
