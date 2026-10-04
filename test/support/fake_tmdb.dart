import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Answers the app's TMDB requests from canned JSON, so the whole stack (real
/// Dio, interceptors, processCall, DTOs, repositories, blocs) runs offline.
class FakeTmdbAdapter implements HttpClientAdapter {
  /// Paths requested so far, e.g. `/movie/popular`.
  final List<String> requestedPaths = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedPaths.add(options.path);
    final body = _route(options.path, options.queryParameters);
    if (body == null) {
      return ResponseBody.fromString('{"status_message":"not found"}', 404, headers: _json);
    }
    return ResponseBody.fromString(jsonEncode(body), 200, headers: _json);
  }

  @override
  void close({bool force = false}) {}

  static const Map<String, List<String>> _json = {
    Headers.contentTypeHeader: ['application/json'],
  };

  static Map<String, Object?>? _route(String path, Map<String, dynamic> query) {
    final details = RegExp(r'^/movie/(\d+)$').firstMatch(path);
    if (details != null) {
      return {
        ..._movie(int.parse(details.group(1)!)),
        'genres': [
          {'id': 878, 'name': 'Science Fiction'},
        ],
      };
    }
    return switch (path) {
      '/movie/popular' ||
      '/movie/top_rated' ||
      '/movie/upcoming' ||
      '/movie/now_playing' ||
      '/trending/movie/day' => _page([_movie(1), _movie(2)]),
      '/search/movie' => _page([_movie(3)]),
      '/genre/movie/list' => {
        'genres': [
          {'id': 878, 'name': 'Science Fiction'},
        ],
      },
      _ when path.endsWith('/similar') => _page([_movie(1)]),
      _ when path.endsWith('/credits') => {
        'cast': [
          {'id': 10, 'name': 'Matthew McConaughey', 'character': 'Cooper', 'order': 0},
        ],
      },
      _ when path.endsWith('/videos') => {'results': <Object>[]},
      _ => null,
    };
  }

  static const _titles = {1: 'Inception', 2: 'Interstellar', 3: 'Tenet'};

  static Map<String, Object?> _movie(int id) => {
    'id': id,
    'title': _titles[id] ?? 'Movie $id',
    'overview': 'Overview of movie $id.',
    'poster_path': '/poster$id.jpg',
    'backdrop_path': '/backdrop$id.jpg',
    'vote_average': 8.1,
    'vote_count': 1000,
    'release_date': '2014-11-05',
    'genre_ids': [878],
    'original_language': 'en',
    'popularity': 100.0,
    'adult': false,
  };

  static Map<String, Object?> _page(List<Map<String, Object?>> results) => {
    'page': 1,
    'results': results,
    'total_pages': 1,
    'total_results': results.length,
  };
}
