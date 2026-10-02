part of 'search_bloc.dart';

/// ببساطة كدا: الحالات اللي الـ UI ممكن يكون فيها
sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية — معندناش query وبنعرض recent searches
final class SearchIdle extends SearchState {
  final List<String> recentSearches;

  const SearchIdle({this.recentSearches = const []});

  @override
  List<Object> get props => [recentSearches];
}

/// Debounce تمام والـ API شغالة
final class SearchLoading extends SearchState {
  final String query;

  const SearchLoading({required this.query});

  @override
  List<Object> get props => [query];
}

/// نتائج موجودة
final class SearchLoaded extends SearchState {
  final String query;
  final List<Movie> results;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const SearchLoaded({
    required this.query,
    required this.results,
    required this.page,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });

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
  List<Object> get props =>
      [query, results, page, hasReachedMax, isLoadingMore];
}

/// مفيش نتائج للـ query
final class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty({required this.query});

  @override
  List<Object> get props => [query];
}

/// Error في الـ API
final class SearchError extends SearchState {
  final String query;
  final String message;

  const SearchError({required this.query, required this.message});

  @override
  List<Object> get props => [query, message];
}
