import 'package:dio/dio.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/interceptors/error_interceptor.dart';
import '../../../../movies/data/models/movie_model.dart';

abstract class SearchRemoteDataSource {
  Future<MoviesPageResponse> searchMovies({
    required String query,
    required int page,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl(this.dio);

  @override
  Future<MoviesPageResponse> searchMovies({
    required String query,
    required int page,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.searchMovies,
        queryParameters: {
          'query': query,
          'page': page,
          'language': 'en-US',
          'include_adult': false,
        },
      );
      return MoviesPageResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.toAppException();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Search failed: ${e.toString()}');
    }
  }
}
