import 'package:domain/domain.dart';

/// Navigation requested by the UI (direct taps). The Route turns each one into
/// a call to the callback it received from the navigation layer.
sealed class HomeNavigation {
  const HomeNavigation();
}

final class OpenMovie extends HomeNavigation {
  const OpenMovie({required this.movieId, required this.heroTag});

  final int movieId;
  final String heroTag;
}

/// "See all" on a section.
final class OpenCategory extends HomeNavigation {
  const OpenCategory(this.category);

  final MovieCategory category;
}

final class OpenSearch extends HomeNavigation {
  const OpenSearch();
}
