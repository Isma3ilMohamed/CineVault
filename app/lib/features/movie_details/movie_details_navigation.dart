/// Navigation requested by the UI (direct taps). The Route turns each one into
/// a call to the callback it received from the navigation layer.
sealed class MovieDetailsNavigation {
  const MovieDetailsNavigation();
}

final class NavigateBack extends MovieDetailsNavigation {
  const NavigateBack();
}

final class OpenSimilarMovie extends MovieDetailsNavigation {
  const OpenSimilarMovie({required this.movieId, required this.heroTag});

  final int movieId;
  final String heroTag;
}
