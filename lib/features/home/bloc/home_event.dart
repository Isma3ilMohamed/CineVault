part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  /// Sent once by the page when the bloc is created.
  const factory HomeEvent.started() = HomeStarted;

  /// Retry from the error state.
  const factory HomeEvent.retried() = HomeRetried;

  /// Pull-to-refresh on the loaded screen.
  const factory HomeEvent.refreshed() = HomeRefreshed;
}
