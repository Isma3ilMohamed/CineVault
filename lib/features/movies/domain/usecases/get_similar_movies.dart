import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// ببساطة كدا: use case بيجيب أفلام شبيهة بفيلم معين
class GetSimilarMovies implements UseCase<List<Movie>, SimilarMoviesParams> {
  final MovieRepository repository;

  const GetSimilarMovies(this.repository);

  @override
  Future<Result<List<Movie>>> call(SimilarMoviesParams params) {
    return repository.getSimilarMovies(
      movieId: params.movieId,
      page: params.page,
    );
  }
}

class SimilarMoviesParams extends Equatable {
  final int movieId;
  final int page;

  const SimilarMoviesParams({
    required this.movieId,
    this.page = 1,
  });

  @override
  List<Object> get props => [movieId, page];
}
