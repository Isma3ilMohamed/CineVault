import 'package:equatable/equatable.dart';

import '../result/result.dart';

/// ببساطة كدا: الـ UseCase = حاجة واحدة بس (single responsibility)
/// كل action في التطبيق = UseCase
/// زي: GetPopularMovies, SearchMovies, AddToFavorites
///
/// الـ `Result<T>` بيخلينا نرجع success OR failure (instead of throwing).
/// ده مشابه لـ Result في Kotlin بعد Kotlin 1.5:
///   sealed class `Result<out T>`
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// للـ use cases اللي مش محتاجة parameters
/// زي: GetCurrentUser
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// للـ Streams (Reactive use cases)
abstract class StreamUseCase<T, Params> {
  Stream<Result<T>> call(Params params);
}
