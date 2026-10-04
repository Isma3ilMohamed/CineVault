import 'package:cine_vault/core/result/core_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const failure = ServerFailure(message: 'boom', statusCode: 500);

  group('Result', () {
    test('when picks the branch matching the variant', () {
      expect(const Ok(2).when(ok: (v) => 'ok $v', err: (_) => 'err'), 'ok 2');
      expect(const Err<int>(failure).when(ok: (_) => 'ok', err: (f) => f.message), 'boom');
    });

    test('getOrElse returns the value or the fallback', () {
      expect(const Ok(2).getOrElse(() => 0), 2);
      expect(const Err<int>(failure).getOrElse(() => 0), 0);
    });

    test('valueOrNull / failureOrNull expose one side', () {
      expect(const Ok(2).valueOrNull, 2);
      expect(const Ok(2).failureOrNull, isNull);
      expect(const Err<int>(failure).valueOrNull, isNull);
      expect(const Err<int>(failure).failureOrNull, failure);
    });

    test('map transforms Ok and passes Err through untouched', () {
      expect(const Ok(2).map((v) => v * 10), const Ok(20));
      expect(const Err<int>(failure).map((v) => v * 10), const Err<int>(failure));
    });

    test('equality is by value', () {
      expect(const Ok(1), const Ok(1));
      expect(
        const Err<int>(failure),
        const Err<int>(ServerFailure(message: 'boom', statusCode: 500)),
      );
      expect(const Ok(1), isNot(const Ok(2)));
    });
  });

  group('Failure', () {
    test('is sealed: a switch over it is exhaustive without a default', () {
      String describe(Failure f) => switch (f) {
        ServerFailure() => 'server',
        NetworkFailure() => 'network',
        CacheFailure() => 'cache',
        UnknownFailure() => 'unknown',
      };

      expect(describe(const NetworkFailure()), 'network');
      expect(describe(const CacheFailure(message: 'disk')), 'cache');
    });

    test('equality uses message and status code', () {
      expect(
        const ServerFailure(message: 'a', statusCode: 1),
        const ServerFailure(message: 'a', statusCode: 1),
      );
      expect(
        const ServerFailure(message: 'a', statusCode: 1),
        isNot(const ServerFailure(message: 'a', statusCode: 2)),
      );
    });
  });
}
