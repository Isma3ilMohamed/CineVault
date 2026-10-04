part of 'search_bloc.dart';

@freezed
sealed class SearchState with _$SearchState {
  /// No query: shows the recent searches.
  const factory SearchState.idle({@Default(<String>[]) List<String> recentSearches}) = SearchIdle;

  const factory SearchState.loading({required String query}) = SearchLoading;

  const factory SearchState.loaded({
    required String query,
    required List<Movie> results,
    required int page,
    required bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = SearchLoaded;

  const factory SearchState.empty({required String query}) = SearchEmpty;

  const factory SearchState.error({required String query, required Failure failure}) = SearchError;
}
