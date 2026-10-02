import '../../../movies/data/models/movie_model.dart';
import '../../../movies/domain/entities/movie.dart';

/// ببساطة كدا: wrapper حول MovieModel مع timestamp
/// بنخزنها في Hive كـ `Map<String, dynamic>` (دون codegen)
/// مفتاح الـ box = movieId (int)
///
/// ليه مش class كامل في domain؟
/// عشان الـ Favorites feature من الـ UI angle هو مجرد list من Movie
/// بتترتب بـ addedAt. الـ timestamp detail للـ data layer بس.
class FavoriteMovieModel {
  static const String addedAtKey = '_added_at';

  final MovieModel movie;
  final DateTime addedAt;

  const FavoriteMovieModel({
    required this.movie,
    required this.addedAt,
  });

  /// Convert إلى `Map<String, dynamic>` بنخزنه في Hive
  /// بنضيف `_added_at` على نفس الـ map بتاع الـ movie
  Map<String, dynamic> toStorage() {
    return {
      ...movie.toJson(),
      addedAtKey: addedAt.toIso8601String(),
    };
  }

  /// نقرا من الـ Hive value
  /// الـ `box<dynamic>` بيرجع `Map<dynamic, dynamic>` فلازم نعمل copy مع cast
  factory FavoriteMovieModel.fromStorage(Map<dynamic, dynamic> raw) {
    final normalized = Map<String, dynamic>.from(raw);
    final added = normalized.remove(addedAtKey) as String?;
    return FavoriteMovieModel(
      movie: MovieModel.fromJson(normalized),
      addedAt: added != null
          ? (DateTime.tryParse(added) ?? DateTime.fromMillisecondsSinceEpoch(0))
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  factory FavoriteMovieModel.fromEntity(Movie entity, {DateTime? addedAt}) {
    return FavoriteMovieModel(
      movie: MovieModel.fromEntity(entity),
      addedAt: addedAt ?? DateTime.now(),
    );
  }

  Movie toEntity() => movie.toEntity();
}
