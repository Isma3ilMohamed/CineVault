import 'package:bloc/bloc.dart';
import 'package:core_base/core_base.dart';
import 'package:flutter_test/flutter_test.dart';

sealed class _Event {}

final class _Increment extends _Event {}

final class _Decrement extends _Event {}

/// Counter that refuses to go below zero.
class _GuardedBloc extends Bloc<_Event, int> with EventGuard<_Event, int> {
  _GuardedBloc() : super(0) {
    on<_Increment>((_, emit) => emit(state + 1));
    on<_Decrement>((_, emit) => emit(state - 1));
  }

  int handled = 0;

  @override
  void onEvent(_Event event) {
    super.onEvent(event);
    handled++;
  }

  @override
  bool isEventAllowed(_Event event, int state) => switch ((state, event)) {
    (0, _Decrement()) => false,
    _ => true,
  };
}

void main() {
  late _GuardedBloc bloc;

  setUp(() => bloc = _GuardedBloc());
  tearDown(() => bloc.close());

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  test('allowed events reach their handlers', () async {
    bloc
      ..add(_Increment())
      ..add(_Increment());
    await flush();

    expect(bloc.state, 2);
    expect(bloc.handled, 2);
  });

  test('a rejected event fails an assert and never reaches a handler', () async {
    expect(() => bloc.add(_Decrement()), throwsA(isA<AssertionError>()));
    await flush();

    expect(bloc.state, 0);
    expect(bloc.handled, 0);
  });

  test('the decision uses the current state', () async {
    bloc.add(_Increment());
    await flush();
    bloc.add(_Decrement());
    await flush();

    expect(bloc.state, 0);
    expect(bloc.handled, 2);
  });

  test('the state is checked when add() is called, not when the event is handled', () async {
    bloc.add(_Increment());
    // _Increment is still queued, so the state is 0 and _Decrement is rejected.
    expect(() => bloc.add(_Decrement()), throwsA(isA<AssertionError>()));
    await flush();

    expect(bloc.state, 1);
  });
}
