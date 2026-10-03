import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_details_contract.freezed.dart';

@freezed
sealed class MovieDetailsState with _$MovieDetailsState {
  const factory MovieDetailsState.initial() = MovieDetailsInitial;

  const factory MovieDetailsState.loading() = MovieDetailsLoading;

  const factory MovieDetailsState.loaded({
    required Movie movie,
    required List<Movie> similarMovies,
    required List<CastMember> cast,

    /// Genre names for `movie.genreIds`; empty when genres failed to load.
    required List<String> genres,
    Video? trailer,
  }) = MovieDetailsLoaded;

  const factory MovieDetailsState.error(Failure failure) = MovieDetailsError;
}

@freezed
sealed class MovieDetailsEvent with _$MovieDetailsEvent {
  /// Sent once by the Route when the bloc is created.
  const factory MovieDetailsEvent.started() = MovieDetailsStarted;

  /// Retry from the error state.
  const factory MovieDetailsEvent.retried() = MovieDetailsRetried;
}

// No MovieDetailsEffect: this screen has no one-off outputs. Navigation comes
// from taps (movie_details_navigation.dart) and the trailer is a UI dialog.
// Add an effect type and EffectEmitter when the bloc needs to trigger one.
