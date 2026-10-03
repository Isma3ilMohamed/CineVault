import 'dart:async';

import 'package:data/src/error/app_exception.dart';

/// Runs a local storage operation, turning any failure into a [CacheException]
/// that names the [action] (e.g. 'read favorites').
Future<T> storageCall<T>(String action, FutureOr<T> Function() body) async {
  try {
    return await body();
  } on Object catch (e, stackTrace) {
    Error.throwWithStackTrace(CacheException('Failed to $action: $e'), stackTrace);
  }
}
