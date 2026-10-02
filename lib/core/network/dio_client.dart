import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// ببساطة كدا: ده الـ HTTP client الرئيسي
/// زي Retrofit + OkHttp في Android
///
/// Interceptors = Middleware:
///   - AuthInterceptor: بيحط الـ API key في كل request
///   - ErrorInterceptor: بيحول DioException لـ custom exceptions
///   - PrettyDioLogger: بيطبع الـ requests في console (debug فقط)
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3',
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        compact: true,
        maxWidth: 120,
      ),
    ]);
  }
}
