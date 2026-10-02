import 'package:cine_vault/features/movies/domain/entities/genre.dart';

class GenreModel {
  const GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'] as int, name: json['name'] as String? ?? '');
  }
  final int id;
  final String name;

  Genre toEntity() => Genre(id: id, name: name);
}

class GenresResponse {
  const GenresResponse({required this.genres});

  factory GenresResponse.fromJson(Map<String, dynamic> json) {
    return GenresResponse(
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
  final List<GenreModel> genres;
}
