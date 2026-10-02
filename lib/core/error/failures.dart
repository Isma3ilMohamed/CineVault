import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server returned an error (500, 404, etc.)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Network connection issue (no internet, timeout)
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'مفيش اتصال بالإنترنت'});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'حصل خطأ غير متوقع'});
}
