import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_contract.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;

  const factory HomeState.loading() = HomeLoading;

  const factory HomeState.loaded({
    required Map<MovieCategory, List<Movie>> sections,

    /// Pull-to-refresh in progress; the old sections stay on screen.
    @Default(false) bool isRefreshing,
  }) = HomeLoaded;

  const factory HomeState.error(Failure failure) = HomeError;
}

@freezed
sealed class HomeEvent with _$HomeEvent {
  /// Sent once by the Route when the bloc is created.
  const factory HomeEvent.started() = HomeStarted;

  /// Retry from the error state.
  const factory HomeEvent.retried() = HomeRetried;

  /// Pull-to-refresh on the loaded screen.
  const factory HomeEvent.refreshed() = HomeRefreshed;
}

@freezed
sealed class HomeEffect with _$HomeEffect {
  /// A refresh failed. The old sections stay; the Route shows a snackbar.
  const factory HomeEffect.refreshFailed(Failure failure) = HomeRefreshFailed;
}
