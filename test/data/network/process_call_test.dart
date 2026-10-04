import 'dart:convert';
import 'dart:typed_data';

import 'package:cine_vault/data/error/app_exception.dart';
import 'package:cine_vault/data/network/process_call.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fakes the transport so requests go through a real Dio instance.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final Future<ResponseBody> Function(RequestOptions options) _respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => _respond(options);

  @override
  void close({bool force = false}) {}
}

Dio _dio(Future<ResponseBody> Function(RequestOptions options) respond) =>
    Dio()..httpClientAdapter = _FakeAdapter(respond);

Future<ResponseBody> _json(Object body, int status) async => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

class _Dto {
  _Dto(this.name);
  factory _Dto.fromJson(Map<String, dynamic> json) => _Dto(json['name'] as String);
  final String name;
}

Future<_Dto> _call(Dio dio) => processCall(() => dio.get<dynamic>('/x'), decode: _Dto.fromJson);

void main() {
  test('decodes a successful JSON body', () async {
    final dto = await _call(_dio((_) => _json({'name': 'Dune'}, 200)));
    expect(dto.name, 'Dune');
  });

  test('connection errors become NoInternetException', () async {
    final dio = _dio(
      (options) => throw DioException.connectionError(requestOptions: options, reason: 'offline'),
    );
    await expectLater(_call(dio), throwsA(isA<NoInternetException>()));
  });

  test('timeouts become NoInternetException', () async {
    final dio = _dio(
      (options) => throw DioException.receiveTimeout(
        timeout: const Duration(seconds: 1),
        requestOptions: options,
      ),
    );
    await expectLater(_call(dio), throwsA(isA<NoInternetException>()));
  });

  test('4xx becomes ServerException with the TMDB message and status', () async {
    final dio = _dio((_) => _json({'status_message': 'Not found', 'status_code': 34}, 404));
    await expectLater(
      _call(dio),
      throwsA(
        isA<ServerException>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.message, 'message', 'Not found'),
      ),
    );
  });

  test('5xx becomes ServerException with a generic message', () async {
    final dio = _dio((_) => _json({'status_message': 'stack trace leak'}, 503));
    await expectLater(
      _call(dio),
      throwsA(
        isA<ServerException>()
            .having((e) => e.statusCode, 'statusCode', 503)
            .having((e) => e.message, 'message', 'Server error, try again later'),
      ),
    );
  });

  test('a body with the wrong shape becomes ParsingException', () async {
    final dio = _dio((_) => _json({'name': 42}, 200));
    await expectLater(_call(dio), throwsA(isA<ParsingException>()));
  });

  test('a non-object body becomes ParsingException', () async {
    final dio = _dio((_) => _json([1, 2, 3], 200));
    await expectLater(_call(dio), throwsA(isA<ParsingException>()));
  });

  test('keeps the original stack trace of the failure', () async {
    final dio = _dio((_) => _json({'name': 42}, 200));
    try {
      await _call(dio);
      fail('expected a ParsingException');
    } on ParsingException catch (_, stackTrace) {
      // The trace points at the DTO's fromJson, not at processCall's rethrow.
      expect(stackTrace.toString(), contains('_Dto.fromJson'));
    }
  });
}
