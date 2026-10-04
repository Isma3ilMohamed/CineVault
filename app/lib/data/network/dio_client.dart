import 'package:cine_vault/core/constants/app_durations.dart';
import 'package:cine_vault/data/network/auth_interceptor.dart';
import 'package:cine_vault/data/network/network_config.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// The app's single HTTP client.
///
/// Errors are not mapped here: `processCall` does that at each call site.
class DioClient {
  DioClient(NetworkConfig config)
    : dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: AppDurations.networkTimeout,
          receiveTimeout: AppDurations.networkTimeout,
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        ),
      ) {
    dio.interceptors.addAll([
      AuthInterceptor(config.accessToken),
      if (config.enableNetworkLogs)
        PrettyDioLogger(requestHeader: true, requestBody: true, maxWidth: 120),
    ]);
  }

  final Dio dio;
}
