import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// ببساطة كدا: ده use case واحد بيعمل حاجة واحدة بس
/// Single Responsibility Principle
class GetPopularMovies implements UseCase<List<Movie>, PageParams> {
  final MovieRepository repository;

  const GetPopularMovies(this.repository);

  @override
  Future<Result<List<Movie>>> call(PageParams params) {
    return repository.getPopularMovies(page: params.page);
  }
}

/// Params class للـ use case
/// أحسن من تمرير primitive types مباشرة
class PageParams extends Equatable {
  final int page;

  const PageParams({required this.page});

  @override
  List<Object> get props => [page];
}
