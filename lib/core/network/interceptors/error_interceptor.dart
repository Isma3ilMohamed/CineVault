import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

/// ببساطة كدا: ده بيمسك أي error من Dio
/// ويحوله لـ exception بتاعنا عشان الـ data layer يفهمه
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(message: 'Connection timeout');

      case DioExceptionType.connectionError:
        throw NetworkException(message: 'No internet connection');

      case DioExceptionType.badResponse:
        _handleBadResponse(err);
        break;

      case DioExceptionType.cancel:
        throw ServerException(message: 'Request cancelled');

      case DioExceptionType.unknown:
      default:
        throw ServerException(
          message: err.message ?? 'Unknown error occurred',
        );
    }

    super.onError(err, handler);
  }

  void _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode ?? 0;
    final message = _extractErrorMessage(err.response?.data);

    switch (statusCode) {
      case 401:
        throw UnauthorizedException(message: message);
      case 404:
        throw NotFoundException(message: message);
      case 400:
      case 422:
        throw ServerException(message: message, statusCode: statusCode);
      case 500:
      case 502:
      case 503:
        throw ServerException(
          message: 'Server error, try again later',
          statusCode: statusCode,
        );
      default:
        throw ServerException(message: message, statusCode: statusCode);
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // TMDB error format: { "status_message": "...", "status_code": ... }
      return data['status_message'] ??
          data['message'] ??
          data['error'] ??
          'Unknown error';
    }
    return 'Unknown error';
  }
}
