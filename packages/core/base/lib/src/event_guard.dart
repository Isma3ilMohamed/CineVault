import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

/// Rejects events that make no sense in the current state, e.g. `Retried`
/// while already loading, before they reach any handler.
///
/// A rejected event fails an assert in debug builds, so the UI that sent it
/// gets fixed; in release builds it is logged and dropped.
///
/// The check runs when [add] is called, against the state at that moment, not
/// when the event is eventually handled. Events still queued don't count.
///
/// ```dart
/// @override
/// bool isEventAllowed(DetailsEvent event, DetailsState state) =>
///     switch ((state, event)) {
///       (DetailsLoading(), DetailsRetried()) => false,
///       _ => true,
///     };
/// ```
mixin EventGuard<E, S> on Bloc<E, S> {
  /// Whether [event] is valid while the bloc is in [state].
  /// Everything is allowed unless overridden.
  @protected
  bool isEventAllowed(E event, S state) => true;

  @override
  void add(E event) {
    if (isEventAllowed(event, state)) {
      super.add(event);
      return;
    }
    final message = '$runtimeType: ${event.runtimeType} is not allowed in ${state.runtimeType}';
    developer.log(message, name: 'EventGuard');
    assert(false, message);
  }
}
