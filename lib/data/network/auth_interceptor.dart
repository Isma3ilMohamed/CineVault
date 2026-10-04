import 'package:dio/dio.dart';

/// Adds the TMDB v4 Bearer token to every request.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._accessToken);

  final String _accessToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_accessToken';
    super.onRequest(options, handler);
  }
}
