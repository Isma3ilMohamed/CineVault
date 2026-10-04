/// Why a data source call failed. Thrown by `processCall` / `storageCall` and
/// turned into a domain `Failure` by `guard` in the repositories.
///
/// Sealed so that mapping to a `Failure` is an exhaustive switch.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => 'AppException: $message';
}

/// No connection, DNS failure or timeout.
final class NoInternetException extends AppException {
  const NoInternetException([super.message = 'No internet connection']);
}

/// The server answered with a non-2xx status.
final class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

/// The response did not have the shape the DTO expects (schema drift).
final class ParsingException extends AppException {
  const ParsingException(super.message);
}

/// Reading or writing local storage failed.
final class CacheException extends AppException {
  const CacheException(super.message);
}

/// Anything else: cancelled requests, bad certificates, unexpected errors.
final class UnknownException extends AppException {
  const UnknownException(super.message);
}
