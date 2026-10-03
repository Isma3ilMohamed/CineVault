/// Navigation requested by the UI (direct taps). The Route turns each one into
/// a call to the callback it received from the navigation layer.
sealed class SearchNavigation {
  const SearchNavigation();
}

final class NavigateBack extends SearchNavigation {
  const NavigateBack();
}

final class OpenMovie extends SearchNavigation {
  const OpenMovie({required this.movieId, required this.heroTag});

  final int movieId;
  final String heroTag;
}
