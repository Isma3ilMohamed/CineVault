part of 'movies_bloc.dart';

/// ببساطة كدا: الـ Events دي اللي الـ UI بيرسلها للـ Bloc
/// زي Intents في MVI تماماً
/// User بيدوس على زر → Event → Bloc يعالجه → State جديد → UI يتحدث
sealed class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

/// أول ما الـ Home screen تفتح
class LoadHomeMovies extends MoviesEvent {
  const LoadHomeMovies();
}

/// Pull to refresh
class RefreshHomeMovies extends MoviesEvent {
  const RefreshHomeMovies();
}

/// Load more popular movies (pagination)
class LoadMorePopularMovies extends MoviesEvent {
  const LoadMorePopularMovies();
}
