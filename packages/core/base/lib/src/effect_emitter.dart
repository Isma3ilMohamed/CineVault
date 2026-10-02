import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

/// Adds one-off side effects to a Bloc or Cubit: things that must happen once
/// and are not part of the state, like navigating after an async lookup or
/// showing a snackbar.
///
/// Delivery rules:
/// - Each effect is delivered once and never replayed to later listeners.
/// - Effects emitted while nobody listens are buffered and flushed, in order,
///   to the next listener. So an effect raised by the very first event is not
///   lost if it fires before the screen subscribes.
/// - One listener is expected (the feature's Route, via `BlocEffectListener`).
///
/// ```dart
/// class DetailsBloc extends Bloc<DetailsEvent, DetailsState>
///     with EffectEmitter<DetailsState, DetailsEffect> { ... }
/// ```
mixin EffectEmitter<S, E> on BlocBase<S> {
  late final StreamController<E> _effects = StreamController<E>.broadcast(onListen: _flushPending);
  final Queue<E> _pending = Queue<E>();

  Stream<E> get effects => _effects.stream;

  @protected
  void emitEffect(E effect) {
    if (_effects.isClosed) return;
    if (_effects.hasListener) {
      _effects.add(effect);
    } else {
      _pending.add(effect);
    }
  }

  void _flushPending() {
    while (_pending.isNotEmpty) {
      _effects.add(_pending.removeFirst());
    }
  }

  @override
  Future<void> close() async {
    _pending.clear();
    await _effects.close();
    await super.close();
  }
}
