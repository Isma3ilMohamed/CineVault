import 'package:dio/dio.dart';

import '../../error/exceptions.dart';

/// Maps every [DioException] to one of our data-layer exceptions and attaches
/// it to [DioException.error].
///
/// The interceptor must `reject` instead of `throw`: Dio wraps anything thrown
/// inside an interceptor into a new [DioException], so a thrown
/// [NetworkException] would never reach the data source's `on NetworkException`.
/// Data sources unwrap the mapped exception via [DioExceptionMapping].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(err.copyWith(error: _map(err)));
  }

  Exception _map(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        NetworkException(message: 'Connection timeout'),
      DioExceptionType.connectionError =>
        NetworkException(message: 'No internet connection'),
      DioExceptionType.badResponse => _mapBadResponse(err.response),
      DioExceptionType.cancel => ServerException(message: 'Request cancelled'),
      DioExceptionType.badCertificate ||
      DioExceptionType.unknown =>
        ServerException(message: err.message ?? 'Unknown error occurred'),
    };
  }

  ServerException _mapBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode ?? 0;
    final message = statusCode >= 500
        ? 'Server error, try again later'
        : _extractErrorMessage(response?.data);
    return ServerException(message: message, statusCode: statusCode);
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // TMDB error format: { "status_message": "...", "status_code": ... }
      final message = data['status_message'] ?? data['message'] ?? data['error'];
      if (message is String) return message;
    }
    return 'Unknown error';
  }
}

extension DioExceptionMapping on DioException {
  /// The exception attached by [ErrorInterceptor], or a [ServerException]
  /// fallback when the request never went through the interceptor.
  Exception toAppException() {
    return switch (error) {
      final ServerException e => e,
      final NetworkException e => e,
      _ => ServerException(message: message ?? 'Unknown error occurred'),
    };
  }
}
