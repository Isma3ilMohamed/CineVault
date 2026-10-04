part of 'home_bloc.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;

  const factory HomeState.loading() = HomeLoading;

  const factory HomeState.loaded({
    required Map<MovieCategory, List<Movie>> sections,

    /// Pull-to-refresh in progress; the old sections stay on screen.
    @Default(false) bool isRefreshing,

    /// The last refresh failed; the old sections stay and the view shows a
    /// snackbar once. Cleared by the next refresh.
    Failure? refreshFailure,
  }) = HomeLoaded;

  const factory HomeState.error(Failure failure) = HomeError;
}
