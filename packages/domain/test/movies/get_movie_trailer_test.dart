import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockMovieRepository extends Mock implements MovieRepository {}

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
      expect(GetMovieTrailer.pickTrailer(videos)?.id, 'official-trailer');
    });

    test('falls back to any YouTube trailer', () {
      final videos = [_video('teaser', type: 'Teaser'), _video('trailer')];
      expect(GetMovieTrailer.pickTrailer(videos)?.id, 'trailer');
    });

    test('falls back to any YouTube video', () {
      final videos = [_video('vimeo-trailer', site: 'Vimeo'), _video('clip', type: 'Clip')];
      expect(GetMovieTrailer.pickTrailer(videos)?.id, 'clip');
    });

    test('ignores videos that cannot be played', () {
      final videos = [
        _video('vimeo', site: 'Vimeo', official: true),
        _video('no-key', key: '', official: true),
      ];
      expect(GetMovieTrailer.pickTrailer(videos), isNull);
    });

    test('returns null for no videos', () {
      expect(GetMovieTrailer.pickTrailer(const []), isNull);
    });
  });

  test('passes repository failures through', () async {
    final repository = _MockMovieRepository();
    const failure = NetworkFailure();
    when(() => repository.getMovieVideos(movieId: 7)).thenAnswer((_) async => const Err(failure));

    final result = await GetMovieTrailer(repository)(const MovieIdParams(movieId: 7));

    expect(result, const Err<Video?>(failure));
  });

  test('returns the picked trailer on success', () async {
    final repository = _MockMovieRepository();
    final trailer = _video('t', official: true);
    when(() => repository.getMovieVideos(movieId: 7)).thenAnswer((_) async => Ok([trailer]));

    final result = await GetMovieTrailer(repository)(const MovieIdParams(movieId: 7));

    expect(result, Ok<Video?>(trailer));
  });
}
