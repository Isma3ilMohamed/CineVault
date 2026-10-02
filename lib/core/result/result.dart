import '../error/failures.dart';

/// ببساطة كدا: `Result<T>` هو sealed class بيمثل نتيجة عملية
/// ممكن تنجح (`Ok<T>`) أو تفشل (`Err<T>`)
///
/// الـ Rust + modern Kotlin equivalent:
///   sealed class `Result<out T>` {
///     data class `Ok<T>`(val value: T) : `Result<T>`()
///     data class Err(val failure: Failure) : `Result<Nothing>`()
///   }
///
/// الـ pattern matching في Dart 3:
///   switch (result) {
///     case Ok(:final value) =&gt; handleSuccess(value),
///     case Err(:final failure) =&gt; handleError(failure),
///   }
///
/// ليه `Result` بدل `Either<Failure, T>` (dartz)؟
///   - Dart 3 sealed classes + pattern matching = language-level support
///   - Compiler بيضمن إن الـ switch exhaustive
///   - مفيش dependency خارجية (dartz = Scala port قديم)
///   - اسامي أوضح: Ok/Err بدل Left/Right الـ ambiguous
sealed class Result<T> {
  const Result();

  /// factory shortcuts (اختياري، الـ constructors كفاية)
  const factory Result.ok(T value) = Ok<T>;
  const factory Result.err(Failure failure) = Err<T>;

  /// Convenience: fold-style مثل dartz
  /// بنفضل pattern matching مباشرة لكن ده مفيد في one-liners
  R when<R>({
    required R Function(T value) ok,
    required R Function(Failure failure) err,
  }) {
    return switch (this) {
      Ok<T>(:final value) => ok(value),
      Err<T>(:final failure) => err(failure),
    };
  }

  /// لو Ok بنرجع الـ value، لو Err بنرجع الـ fallback
  T getOrElse(T Function() fallback) {
    return switch (this) {
      Ok<T>(:final value) => value,
      Err<T>() => fallback(),
    };
  }

  /// Nullable getter
  T? get valueOrNull => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Ok<T>() => null,
        Err<T>(:final failure) => failure,
      };

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  /// Transform الـ value لو Ok (functor map)
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Ok<T>(:final value) => Ok(transform(value)),
      Err<T>(:final failure) => Err(failure),
    };
  }
}

final class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);

  @override
  bool operator ==(Object other) =>
      other is Ok<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Ok($value)';
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);

  @override
  bool operator ==(Object other) =>
      other is Err<T> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Err($failure)';
}
