import 'dart:io';

import 'package:data/src/error/app_exception.dart';
import 'package:dio/dio.dart';

/// Runs a Dio request and decodes its JSON body with [decode], throwing a typed
/// [AppException] on any failure.
///
/// The single place where transport and parsing errors are classified, at the
/// call site. The original stack trace is kept ([Error.throwWithStackTrace]),
/// so crash reports still point at the data source that made the call.
///
/// ```dart
/// Future<CreditsResponse> getMovieCredits(int id) => processCall(
///   () => dio.get('/movie/$id/credits'),
///   decode: CreditsResponse.fromJson,
/// );
/// ```
Future<T> processCall<T>(
  Future<Response<dynamic>> Function() call, {
  required T Function(Map<String, dynamic> json) decode,
}) async {
  final Response<dynamic> response;
  try {
    response = await call();
  } on DioException catch (e, stackTrace) {
    Error.throwWithStackTrace(_fromDio(e), stackTrace);
  }

  final data = response.data;
  if (data is! Map<String, dynamic>) {
    throw ParsingException('Expected a JSON object, got ${data.runtimeType}');
  }
  try {
    return decode(data);
    // fromJson casts (`as String`, `as List`) fail with TypeError when the API
    // shape changes. Only the decode step is guarded, so real bugs elsewhere
    // are not hidden.
    // ignore: avoid_catching_errors
  } on TypeError catch (e, stackTrace) {
    Error.throwWithStackTrace(ParsingException(e.toString()), stackTrace);
  }
}

AppException _fromDio(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => const NoInternetException(),
    DioExceptionType.badResponse => _fromResponse(e.response),
    DioExceptionType.cancel => const UnknownException('Request cancelled'),
    DioExceptionType.badCertificate => UnknownException(e.message ?? 'Bad certificate'),
    // Lower-level socket failures can surface as `unknown`.
    DioExceptionType.unknown when e.error is SocketException => const NoInternetException(),
    DioExceptionType.unknown => UnknownException(e.message ?? '${e.error}'),
  };
}

ServerException _fromResponse(Response<dynamic>? response) {
  final statusCode = response?.statusCode;
  final message = (statusCode ?? 0) >= 500
      ? 'Server error, try again later'
      : _readErrorMessage(response?.data) ?? 'Request failed';
  return ServerException(message, statusCode: statusCode);
}

/// Best-effort read of TMDB's `{"status_message": ...}` error body.
String? _readErrorMessage(Object? body) {
  if (body is! Map) return null;
  final message = body['status_message'] ?? body['message'];
  return message is String && message.isNotEmpty ? message : null;
}
