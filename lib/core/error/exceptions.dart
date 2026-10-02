class ServerException implements Exception {
  ServerException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class NetworkException implements Exception {
  NetworkException({this.message = 'No internet connection'});
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  CacheException({required this.message});
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  AuthException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'AuthException: $message';
}

class UnauthorizedException extends AuthException {
  UnauthorizedException({super.message = 'Unauthorized access'}) : super(statusCode: 401);
}

class NotFoundException implements Exception {
  NotFoundException({this.message = 'Resource not found'});
  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}
