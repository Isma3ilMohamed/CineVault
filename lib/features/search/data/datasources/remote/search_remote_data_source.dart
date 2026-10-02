import 'package:cine_vault/core/constants/app_constants.dart';
import 'package:cine_vault/core/error/exceptions.dart';
import 'package:cine_vault/core/network/interceptors/error_interceptor.dart';
import 'package:cine_vault/features/movies/data/models/movie_model.dart';
import 'package:dio/dio.dart';

abstract class SearchRemoteDataSource {
  Future<MoviesPageResponse> searchMovies({required String query, required int page});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(this.dio);
  final Dio dio;

  @override
  Future<MoviesPageResponse> searchMovies({required String query, required int page}) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiConstants.searchMovies,
        queryParameters: {
          'query': query,
          'page': page,
          'language': 'en-US',
          'include_adult': false,
        },
      );
      return MoviesPageResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.toAppException();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Search failed: $e');
    }
  }
}
