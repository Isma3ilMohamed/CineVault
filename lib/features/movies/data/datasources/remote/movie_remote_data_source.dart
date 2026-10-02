import 'package:cine_vault/core/constants/app_constants.dart';
import 'package:cine_vault/core/error/exceptions.dart';
import 'package:cine_vault/core/network/interceptors/error_interceptor.dart';
import 'package:cine_vault/features/movies/data/models/cast_member_model.dart';
import 'package:cine_vault/features/movies/data/models/genre_model.dart';
import 'package:cine_vault/features/movies/data/models/movie_model.dart';
import 'package:cine_vault/features/movies/data/models/video_model.dart';
import 'package:dio/dio.dart';

abstract class MovieRemoteDataSource {
  Future<MoviesPageResponse> getPopularMovies({required int page});
  Future<MoviesPageResponse> getTopRatedMovies({required int page});
  Future<MoviesPageResponse> getUpcomingMovies({required int page});
  Future<MoviesPageResponse> getNowPlayingMovies({required int page});
  Future<MoviesPageResponse> getTrendingDayMovies({required int page});
  Future<MovieModel> getMovieDetails({required int movieId});
  Future<MoviesPageResponse> getSimilarMovies({required int movieId, required int page});

  Future<GenresResponse> getGenres();

  Future<CreditsResponse> getMovieCredits({required int movieId});

  Future<VideosResponse> getMovieVideos({required int movieId});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  MovieRemoteDataSourceImpl(this.dio);
  final Dio dio;

  @override
  Future<MoviesPageResponse> getPopularMovies({required int page}) async {
    return _fetchMoviesPage(endpoint: ApiConstants.popularMovies, page: page);
  }

  @override
  Future<MoviesPageResponse> getTopRatedMovies({required int page}) async {
    return _fetchMoviesPage(endpoint: ApiConstants.topRatedMovies, page: page);
  }

  @override
  Future<MoviesPageResponse> getUpcomingMovies({required int page}) async {
    return _fetchMoviesPage(endpoint: ApiConstants.upcomingMovies, page: page);
  }

  @override
  Future<MoviesPageResponse> getNowPlayingMovies({required int page}) async {
    return _fetchMoviesPage(endpoint: ApiConstants.nowPlayingMovies, page: page);
  }

  @override
  Future<MoviesPageResponse> getTrendingDayMovies({required int page}) async {
    return _fetchMoviesPage(endpoint: ApiConstants.trendingDay, page: page);
  }

  @override
  Future<MovieModel> getMovieDetails({required int movieId}) async {
    try {
      final response = await dio.get('${ApiConstants.movieDetails}/$movieId');
      return MovieModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.toAppException();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MoviesPageResponse> getSimilarMovies({required int movieId, required int page}) async {
    return _fetchMoviesPage(endpoint: '${ApiConstants.movieDetails}/$movieId/similar', page: page);
  }

  @override
  Future<GenresResponse> getGenres() async {
    try {
      final response = await dio.get(ApiConstants.genres, queryParameters: {'language': 'en-US'});
      return GenresResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.toAppException();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch genres: $e');
    }
  }

  @override
  Future<CreditsResponse> getMovieCredits({required int movieId}) async {
    try {
      final response = await dio.get('${ApiConstants.movieDetails}/$movieId/credits');
      return CreditsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.toAppException();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch credits: $e');
    }
  }

  @override
  Future<VideosResponse> getMovieVideos({required int movieId}) async {
    try {
      final response = await dio.get('${ApiConstants.movieDetails}/$movieId/videos');
      return VideosResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.toAppException();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch videos: $e');
    }
  }

  Future<MoviesPageResponse> _fetchMoviesPage({required String endpoint, required int page}) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: {'page': page, 'language': 'en-US'},
      );
      return MoviesPageResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.toAppException();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
