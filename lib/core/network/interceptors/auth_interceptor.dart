import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ببساطة كدا: ده بيضيف الـ Bearer token في كل request
/// TMDB v4 auth بيستخدم Bearer token
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = dotenv.env['TMDB_ACCESS_TOKEN'];
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }
}
