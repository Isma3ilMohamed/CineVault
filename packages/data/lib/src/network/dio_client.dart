import 'package:data/src/network/auth_interceptor.dart';
import 'package:data/src/network/network_config.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// The app's single HTTP client.
///
/// Errors are not mapped here: `processCall` does that at each call site.
@lazySingleton
class DioClient {
  DioClient(NetworkConfig config)
    : dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
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
