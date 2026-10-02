class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'No internet connection'});

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  AuthException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'AuthException: $message';
}

class UnauthorizedException extends AuthException {
  UnauthorizedException({String message = 'Unauthorized access'})
      : super(message: message, statusCode: 401);
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException({this.message = 'Resource not found'});

  @override
  String toString() => 'NotFoundException: $message';
}
