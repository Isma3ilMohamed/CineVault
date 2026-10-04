import 'package:cine_vault/data/models/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> json(Map<String, dynamic> extra) => {
    'id': 1,
    'title': 'Inception',
    ...extra,
  };

  test('reads genre_ids from list endpoints', () {
    final model = MovieModel.fromJson(
      json({
        'genre_ids': [28, 878],
      }),
    );
    expect(model.genreIds, [28, 878]);
  });

  // Regression: the details endpoint has no genre_ids, so genres were always empty.
  test('reads genre ids from the details endpoint genres objects', () {
    final model = MovieModel.fromJson(
      json({
        'genres': [
          {'id': 28, 'name': 'Action'},
          {'id': 878, 'name': 'Science Fiction'},
        ],
      }),
    );
    expect(model.genreIds, [28, 878]);
  });

  test('no genres at all gives an empty list', () {
    expect(MovieModel.fromJson(json({})).genreIds, isEmpty);
  });
}
