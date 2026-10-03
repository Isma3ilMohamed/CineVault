import 'package:domain/domain.dart';

class MovieModel {
  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.originalLanguage,
    required this.popularity,
    required this.adult,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      releaseDate: json['release_date'] as String?,
      genreIds: _genreIds(json),
      originalLanguage: json['original_language'] as String? ?? 'en',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      adult: json['adult'] as bool? ?? false,
    );
  }

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      releaseDate: movie.releaseDate?.toIso8601String().split('T').first,
      genreIds: movie.genreIds,
      originalLanguage: movie.originalLanguage,
      popularity: movie.popularity,
      adult: movie.adult,
    );
  }

  /// List endpoints send `genre_ids: [28]`; the details endpoint sends
  /// `genres: [{"id": 28, "name": "Action"}]` instead.
  static List<int> _genreIds(Map<String, dynamic> json) {
    final ids = json['genre_ids'] as List<dynamic>?;
    if (ids != null) return ids.map((e) => e as int).toList();
    final genres = json['genres'] as List<dynamic>?;
    return genres?.map((g) => (g as Map<String, dynamic>)['id'] as int).toList() ?? [];
  }

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<int> genreIds;
  final String originalLanguage;
  final double popularity;
  final bool adult;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'release_date': releaseDate,
    'genre_ids': genreIds,
    'original_language': originalLanguage,
    'popularity': popularity,
    'adult': adult,
  };

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      releaseDate: releaseDate != null && releaseDate!.isNotEmpty
          ? DateTime.tryParse(releaseDate!)
          : null,
      genreIds: genreIds,
      originalLanguage: originalLanguage,
      popularity: popularity,
      adult: adult,
    );
  }
}

class MoviesPageResponse {
  MoviesPageResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesPageResponse.fromJson(Map<String, dynamic> json) {
    return MoviesPageResponse(
      page: json['page'] as int? ?? 1,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;
}
