import 'package:equatable/equatable.dart';

/// ببساطة كدا: الـ Failure هو الـ error بس في الـ Domain Layer
/// إحنا بنفصل الـ Exceptions (اللي بتحصل في Data Layer) عن الـ Failures
/// عشان الـ Domain ما يعرفش حاجة عن Dio أو Firebase أو أي external lib
///
/// Think of it like: sealed class Failure في Kotlin
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server returned an error (500, 404, etc.)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

/// Network connection issue (no internet, timeout)
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'مفيش اتصال بالإنترنت',
  });
}

/// Cache/Local DB error
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });
}

/// Authentication/Authorization error
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
  });
}

/// Input validation error
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });
}

/// Unknown/unexpected error
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'حصل خطأ غير متوقع',
  });
}
