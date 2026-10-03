import 'package:cine_vault/features/movies/data/models/movie_model.dart';
import 'package:domain/domain.dart';

/// Stored in Hive as a plain map (no codegen), keyed by movieId.
class FavoriteMovieModel {
  const FavoriteMovieModel({required this.movie, required this.addedAt});

  /// Hive returns `Map<dynamic, dynamic>`; copy to a typed map before parsing.
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
  static const String addedAtKey = '_added_at';

  final MovieModel movie;
  final DateTime addedAt;

  /// The movie JSON with `_added_at` merged into the same map.
  Map<String, dynamic> toStorage() {
    return {...movie.toJson(), addedAtKey: addedAt.toIso8601String()};
  }

  Movie toEntity() => movie.toEntity();
}
