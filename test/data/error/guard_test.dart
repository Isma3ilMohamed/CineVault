import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/app_exception.dart';
import 'package:cine_vault/data/error/guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wraps a value in Ok', () async {
    expect(await guard(() async => 42), const Ok(42));
  });

  test('maps every AppException to its Failure', () async {
    Future<Failure?> failureOf(AppException e) async =>
        (await guard<int>(() async => throw e)).failureOrNull;

    expect(await failureOf(const NoInternetException()), isA<NetworkFailure>());
    expect(
      await failureOf(const ServerException('Not found', statusCode: 404)),
      const ServerFailure(message: 'Not found', statusCode: 404),
    );
    expect(await failureOf(const ParsingException('bad')), const ServerFailure(message: 'bad'));
    expect(await failureOf(const CacheException('disk')), const CacheFailure(message: 'disk'));
    expect(
      await failureOf(const UnknownException('cancelled')),
      const UnknownFailure(message: 'cancelled'),
    );
  });

  test('turns unexpected errors into UnknownFailure instead of crashing', () async {
    final result = await guard<int>(() async => throw StateError('mapper bug'));
    expect(result.failureOrNull, isA<UnknownFailure>());
  });
}
