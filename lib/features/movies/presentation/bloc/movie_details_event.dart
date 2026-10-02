part of 'movie_details_bloc.dart';

/// ببساطة كدا: كل Event = action من الـ UI
/// Sealed class عشان الـ switch يبقى exhaustive
sealed class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// يحمل تفاصيل الفيلم + الأفلام الشبيهة
final class LoadMovieDetails extends MovieDetailsEvent {
  final int movieId;

  const LoadMovieDetails(this.movieId);

  @override
  List<Object> get props => [movieId];
}

/// Retry بعد error
final class RetryMovieDetails extends MovieDetailsEvent {
  final int movieId;

  const RetryMovieDetails(this.movieId);

  @override
  List<Object> get props => [movieId];
}
