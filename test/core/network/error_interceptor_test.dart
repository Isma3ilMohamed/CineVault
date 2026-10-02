import 'dart:convert';
import 'dart:typed_data';

import 'package:cine_vault/core/error/exceptions.dart';
import 'package:cine_vault/core/network/interceptors/error_interceptor.dart';
import 'package:cine_vault/features/movies/data/datasources/remote/movie_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fakes the transport so requests go through the real interceptor chain.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final Future<ResponseBody> Function(RequestOptions options) _respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) =>
      _respond(options);

  @override
  void close({bool force = false}) {}
}

MovieRemoteDataSource _dataSourceWith(_FakeAdapter adapter) {
  final dio = Dio()
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return MovieRemoteDataSourceImpl(dio);
}

void main() {
  group('ErrorInterceptor + remote data source', () {
    test('connection error surfaces as NetworkException', () async {
      final dataSource = _dataSourceWith(
        _FakeAdapter(
          (options) => throw DioException.connectionError(
            requestOptions: options,
            reason: 'offline',
          ),
        ),
      );

      await expectLater(
        dataSource.getMovieDetails(movieId: 1),
        throwsA(isA<NetworkException>()),
      );
    });

    test('404 surfaces as ServerException with TMDB message', () async {
      final dataSource = _dataSourceWith(
        _FakeAdapter(
          (_) async => ResponseBody.fromString(
            jsonEncode({'status_message': 'Not found', 'status_code': 34}),
            404,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          ),
        ),
      );

      await expectLater(
        dataSource.getPopularMovies(page: 1),
        throwsA(
          isA<ServerException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.message, 'message', 'Not found'),
        ),
      );
    });
  });
}
