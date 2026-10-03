import 'package:domain/domain.dart';

/// TMDB image URLs and display formatting for domain entities.
///
/// Presentation concerns: the domain does not know about TMDB's image CDN or
/// how values are shown on screen.
extension MovieDisplay on Movie {
  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get fullBackdropUrl =>
      backdropPath != null ? 'https://image.tmdb.org/t/p/w1280$backdropPath' : null;

  /// Formatted to one decimal place (TMDB rates out of 10).
  String get formattedRating => voteAverage.toStringAsFixed(1);

  // TODO(phase-6): localize the 'N/A' fallback.
  String get releaseYear => releaseDate != null ? releaseDate!.year.toString() : 'N/A';
}

extension CastMemberDisplay on CastMember {
  String? get fullProfileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : null;
}
