import 'package:data/src/movies/models/movie_model.dart';
import 'package:data/src/network/process_call.dart';
import 'package:data/src/network/tmdb_endpoints.dart';
import 'package:dio/dio.dart';

/// TMDB search. Throws an `AppException` on failure.
abstract class SearchRemoteDataSource {
  Future<MoviesPageResponse> searchMovies({required String query, required int page});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(this.dio);
  final Dio dio;

  @override
  Future<MoviesPageResponse> searchMovies({required String query, required int page}) =>
      processCall(
        () => dio.get<dynamic>(
          TmdbEndpoints.searchMovies,
          queryParameters: {
            'query': query,
            'page': page,
            'language': 'en-US',
            'include_adult': false,
          },
        ),
        decode: MoviesPageResponse.fromJson,
      );
}
