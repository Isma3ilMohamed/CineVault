import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/app_exception.dart';
import 'package:cine_vault/data/models/video_model.dart';
import 'package:cine_vault/data/repositories/movie_repository_impl.dart';
import 'package:cine_vault/data/sources/movie_remote_data_source.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements MovieRemoteDataSource {}

Video _video(
  String id, {
  String site = 'YouTube',
  String type = 'Trailer',
  bool official = false,
  String key = 'k',
}) => Video(id: id, key: key, site: site, name: id, type: type, official: official);

void main() {
  group('pickTrailer', () {
    test('prefers an official YouTube trailer', () {
      final videos = [
        _video('teaser', type: 'Teaser', official: true),
        _video('fan-trailer'),
        _video('official-trailer', official: true),
      ];
      expect(MovieRepositoryImpl.pickTrailer(videos)?.id, 'official-trailer');
    });

    test('falls back to any YouTube trailer', () {
      final videos = [_video('teaser', type: 'Teaser'), _video('trailer')];
      expect(MovieRepositoryImpl.pickTrailer(videos)?.id, 'trailer');
    });

    test('falls back to any YouTube video', () {
      final videos = [_video('vimeo-trailer', site: 'Vimeo'), _video('clip', type: 'Clip')];
      expect(MovieRepositoryImpl.pickTrailer(videos)?.id, 'clip');
    });

    test('ignores videos that cannot be played', () {
      final videos = [
        _video('vimeo', site: 'Vimeo', official: true),
        _video('no-key', key: '', official: true),
      ];
      expect(MovieRepositoryImpl.pickTrailer(videos), isNull);
    });

    test('returns null for no videos', () {
      expect(MovieRepositoryImpl.pickTrailer(const []), isNull);
    });
  });

  group('getMovieTrailer', () {
    late _MockRemote remote;
    late MovieRepositoryImpl repository;

    setUp(() {
      remote = _MockRemote();
      repository = MovieRepositoryImpl(remoteDataSource: remote);
    });

    test('turns a data source failure into a Failure', () async {
      when(() => remote.getMovieVideos(movieId: 7)).thenThrow(const NoInternetException());

      final result = await repository.getMovieTrailer(movieId: 7);

      expect(result, const Err<Video?>(NetworkFailure()));
    });

    test('returns the picked trailer', () async {
      when(() => remote.getMovieVideos(movieId: 7)).thenAnswer(
        (_) async => const VideosResponse(
          results: [
            VideoModel(
              id: 'c',
              key: 'k1',
              site: 'YouTube',
              name: 'c',
              type: 'Clip',
              official: true,
            ),
            VideoModel(
              id: 't',
              key: 'k2',
              site: 'YouTube',
              name: 't',
              type: 'Trailer',
              official: true,
            ),
          ],
        ),
      );

      final result = await repository.getMovieTrailer(movieId: 7);

      expect(result.valueOrNull?.id, 't');
    });
  });
}
