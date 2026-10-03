import 'package:cine_vault/data/error/app_exception.dart';
import 'package:cine_vault/data/storage/storage_call.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns the value of a sync or async body', () async {
    expect(await storageCall('read', () => 1), 1);
    expect(await storageCall('read', () async => 2), 2);
  });

  test('wraps any failure in a CacheException naming the action', () async {
    await expectLater(
      storageCall<int>('read favorites', () => throw const FormatException('corrupt')),
      throwsA(
        isA<CacheException>().having(
          (e) => e.message,
          'message',
          allOf(contains('read favorites'), contains('corrupt')),
        ),
      ),
    );
  });
}
