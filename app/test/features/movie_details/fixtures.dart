import 'package:domain/domain.dart';

Movie movie(int id, {List<int> genreIds = const [28, 878]}) => Movie(
  id: id,
  title: id == 1 ? 'Inception' : 'Movie $id',
  overview: 'A thief who steals corporate secrets through dream-sharing technology.',
  posterPath: '/poster$id.jpg',
  backdropPath: '/backdrop$id.jpg',
  voteAverage: 8.4,
  voteCount: 35000,
  releaseDate: DateTime(2010, 7, 16),
  genreIds: genreIds,
  originalLanguage: 'en',
  popularity: 100,
  adult: false,
);

const castMembers = [
  CastMember(id: 1, name: 'Leonardo DiCaprio', character: 'Cobb', order: 0),
  CastMember(id: 2, name: 'Joseph Gordon-Levitt', character: 'Arthur', order: 1),
  CastMember(id: 3, name: 'Elliot Page', character: 'Ariadne', order: 2),
];

const trailer = Video(
  id: 'v1',
  key: 'YoHD9XEInc0',
  site: 'YouTube',
  name: 'Official Trailer',
  type: 'Trailer',
  official: true,
);

const genres = [Genre(id: 28, name: 'Action'), Genre(id: 878, name: 'Science Fiction')];
