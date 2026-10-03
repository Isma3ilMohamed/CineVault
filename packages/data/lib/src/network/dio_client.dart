import 'package:data/src/network/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// The app's single HTTP client.
///
/// Errors are not mapped here: `processCall` does that at each call site.
class DioClient {
  DioClient({required String baseUrl, required String accessToken, bool enableNetworkLogs = false})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        ),
      ) {
    dio.interceptors.addAll([
      AuthInterceptor(accessToken),
      if (enableNetworkLogs) PrettyDioLogger(requestHeader: true, requestBody: true, maxWidth: 120),
    ]);
  }

  final Dio dio;
}
