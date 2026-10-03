import 'package:cine_vault/domain/domain.dart';

Movie movie(int id) => Movie(
  id: id,
  title: 'Movie $id',
  overview: '',
  posterPath: '/poster$id.jpg',
  voteAverage: 7.5,
  voteCount: 100,
  releaseDate: DateTime(2020 + id),
  genreIds: const [],
  originalLanguage: 'en',
  popularity: 1,
  adult: false,
);
