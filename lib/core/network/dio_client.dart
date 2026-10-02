import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// The app's single HTTP client.
///
/// Interceptor order matters: auth runs first on the way out, errors are mapped
/// before the logger prints them.
class DioClient {
  DioClient(AppConfig config)
      : dio = Dio(
          BaseOptions(
            baseUrl: config.tmdbBaseUrl,
            connectTimeout: AppConstants.connectionTimeout,
            receiveTimeout: AppConstants.receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.addAll([
      AuthInterceptor(config.tmdbAccessToken),
      ErrorInterceptor(),
      if (config.enableNetworkLogs)
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

  final Dio dio;
}
