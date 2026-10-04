import 'dart:developer' as developer;

import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/app_exception.dart';

/// Runs a repository operation and returns its value as a [Result].
///
/// [AppException]s become the matching `Failure`. Anything else is a bug (for
/// example a mapper throwing); it is logged and still returned as an
/// [UnknownFailure] so one bad item cannot crash a screen.
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Ok(await body());
  } on AppException catch (e) {
    return Err(e.toFailure());
  } on Object catch (e, stackTrace) {
    developer.log(
      'Unexpected error in repository',
      name: 'guard',
      error: e,
      stackTrace: stackTrace,
    );
    return Err(UnknownFailure(message: e.toString()));
  }
}

extension AppExceptionToFailure on AppException {
  Failure toFailure() => switch (this) {
    NoInternetException() => const NetworkFailure(),
    ServerException(:final message, :final statusCode) => ServerFailure(
      message: message,
      statusCode: statusCode,
    ),
    ParsingException(:final message) => ServerFailure(message: message),
    CacheException(:final message) => CacheFailure(message: message),
    UnknownException(:final message) => UnknownFailure(message: message),
  };
}
