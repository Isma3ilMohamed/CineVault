import 'package:core_result/core_result.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

abstract class StreamUseCase<T, Params> {
  Stream<Result<T>> call(Params params);
}
