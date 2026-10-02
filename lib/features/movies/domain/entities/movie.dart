import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final DateTime? releaseDate;
  final List<int> genreIds;
  final String originalLanguage;
  final double popularity;
  final bool adult;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    this.releaseDate,
    required this.genreIds,
    required this.originalLanguage,
    required this.popularity,
    required this.adult,
  });

  String? get fullPosterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : null;

  String? get fullBackdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : null;

  /// Formatted to one decimal place (TMDB rates out of 10).
  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get releaseYear =>
      releaseDate != null ? releaseDate!.year.toString() : 'N/A';

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        releaseDate,
        genreIds,
        originalLanguage,
        popularity,
        adult,
      ];
}
