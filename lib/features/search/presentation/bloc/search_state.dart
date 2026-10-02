part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

final class SearchIdle extends SearchState {
  const SearchIdle({this.recentSearches = const []});
  final List<String> recentSearches;

  @override
  List<Object> get props => [recentSearches];
}

final class SearchLoading extends SearchState {
  const SearchLoading({required this.query});
  final String query;

  @override
  List<Object> get props => [query];
}

final class SearchLoaded extends SearchState {
  const SearchLoaded({
    required this.query,
    required this.results,
    required this.page,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });
  final String query;
  final List<Movie> results;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;

  SearchLoaded copyWith({
    String? query,
    List<Movie>? results,
    int? page,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return SearchLoaded(
      query: query ?? this.query,
      results: results ?? this.results,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [query, results, page, hasReachedMax, isLoadingMore];
}

final class SearchEmpty extends SearchState {
  const SearchEmpty({required this.query});
  final String query;

  @override
  List<Object> get props => [query];
}

final class SearchError extends SearchState {
  const SearchError({required this.query, required this.message});
  final String query;
  final String message;

  @override
  List<Object> get props => [query, message];
}
