import 'package:equatable/equatable.dart';

/// Why an operation failed, as seen by the domain.
///
/// Sealed so every `switch` over a failure is exhaustive: adding a new kind
/// forces each call site to decide how to handle it. [message] is for logs and
/// debugging; user-facing text should be chosen from the failure type.
sealed class Failure extends Equatable {
  const Failure({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// The server answered with an error status (4xx/5xx) or an unusable body.
final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// No connection, or the request timed out.
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Reading or writing local storage failed.
final class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Anything not covered above.
final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Unexpected error'});
}
