import 'package:cine_vault/core/config/app_config.dart';
import 'package:cine_vault/core/constants/app_constants.dart';
import 'package:cine_vault/core/network/interceptors/auth_interceptor.dart';
import 'package:cine_vault/core/network/interceptors/error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        ),
      ) {
    dio.interceptors.addAll([
      AuthInterceptor(config.tmdbAccessToken),
      ErrorInterceptor(),
      if (config.enableNetworkLogs)
        PrettyDioLogger(requestHeader: true, requestBody: true, maxWidth: 120),
    ]);
  }

  final Dio dio;
}
