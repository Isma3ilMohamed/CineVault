import 'package:equatable/equatable.dart';

/// ببساطة كدا: ده الـ Movie في أنقى صورة ليه
/// ما بيعرفش حاجة عن JSON أو API أو Database
/// دي الـ Entity في الـ Domain Layer
///
/// Compare مع Kee:
///   - Entity = Domain Model
///   - ما فيهاش @JsonProperty أو @Entity (Room)
///   - Pure Kotlin/Dart class
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

  /// Helper للـ full poster URL
  String? get fullPosterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : null;

  String? get fullBackdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : null;

  /// Rating من 10
  String get formattedRating => voteAverage.toStringAsFixed(1);

  /// السنة فقط
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
