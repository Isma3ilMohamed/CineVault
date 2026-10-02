part of 'movies_bloc.dart';

sealed class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {
  const MoviesInitial();
}

class MoviesLoading extends MoviesState {
  const MoviesLoading();
}

class MoviesLoaded extends MoviesState {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> trendingDayMovies;

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

class MoviesError extends MoviesState {
  final String message;

  const MoviesError({required this.message});

  @override
  List<Object> get props => [message];
}
