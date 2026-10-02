part of 'movies_bloc.dart';

/// ببساطة كدا: الـ State دي اللي الـ UI بيرسمها
/// كل حاجة الـ UI محتاج يعرفها موجودة هنا
///
/// استخدمنا sealed class عشان نستفيد من exhaustive checks
/// في switch statements (زي when في Kotlin)
sealed class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية - الصفحة لسه ما فتحتش
class MoviesInitial extends MoviesState {
  const MoviesInitial();
}

/// بنحمل الداتا لأول مرة
class MoviesLoading extends MoviesState {
  const MoviesLoading();
}

/// نجحنا - عندنا الداتا
/// ليه في كذا list هنا؟ عشان الـ Home screen بيعرض 4 sections
class MoviesLoaded extends MoviesState {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> trendingDayMovies;

  /// pagination state for popular movies
  final int popularPage;
  final bool hasReachedMaxPopular;
  final bool isLoadingMore;

  const MoviesLoaded({
    required this.popularMovies,
    required this.topRatedMovies,
    required this.upcomingMovies,
    required this.nowPlayingMovies,
    required this.trendingDayMovies,
    this.popularPage = 1,
    this.hasReachedMaxPopular = false,
    this.isLoadingMore = false,
  });

  /// Immutable state update pattern
  /// زي data class copy() في Kotlin
  MoviesLoaded copyWith({
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upcomingMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? trendingDayMovies,
    int? popularPage,
    bool? hasReachedMaxPopular,
    bool? isLoadingMore,
  }) {
    return MoviesLoaded(
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      trendingDayMovies: trendingDayMovies ?? this.trendingDayMovies,
      popularPage: popularPage ?? this.popularPage,
      hasReachedMaxPopular: hasReachedMaxPopular ?? this.hasReachedMaxPopular,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [
        popularMovies,
        topRatedMovies,
        upcomingMovies,
        nowPlayingMovies,
        trendingDayMovies,
        popularPage,
        hasReachedMaxPopular,
        isLoadingMore,
      ];
}

/// حصل error
class MoviesError extends MoviesState {
  final String message;

  const MoviesError({required this.message});

  @override
  List<Object> get props => [message];
}
