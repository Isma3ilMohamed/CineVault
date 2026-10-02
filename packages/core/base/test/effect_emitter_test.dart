import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core_base/core_base.dart';
import 'package:flutter_test/flutter_test.dart';

class _EffectCubit extends Cubit<int> with EffectEmitter<int, String> {
  _EffectCubit() : super(0);

  void fire(String effect) => emitEffect(effect);
}

void main() {
  late _EffectCubit cubit;

  setUp(() => cubit = _EffectCubit());
  tearDown(() => cubit.close());

  /// Lets the broadcast controller deliver queued events.
  Future<void> flush() => Future<void>.delayed(Duration.zero);

  test('delivers effects to a live listener in order', () async {
    final received = <String>[];
    final sub = cubit.effects.listen(received.add);

    cubit
      ..fire('a')
      ..fire('b');
    await flush();

    expect(received, ['a', 'b']);
    await sub.cancel();
  });

  test('buffers effects emitted before anyone listens', () async {
    cubit
      ..fire('early-1')
      ..fire('early-2');

    final received = <String>[];
    final sub = cubit.effects.listen(received.add);
    await flush();

    expect(received, ['early-1', 'early-2']);
    await sub.cancel();
  });

  test('never replays an effect to a later listener', () async {
    final first = <String>[];
    final firstSub = cubit.effects.listen(first.add);
    cubit.fire('once');
    await flush();
    await firstSub.cancel();

    final second = <String>[];
    final secondSub = cubit.effects.listen(second.add);
    await flush();

    expect(first, ['once']);
    expect(second, isEmpty);
    await secondSub.cancel();
  });

  test('close ends the stream and ignores later effects', () async {
    final done = Completer<void>();
    cubit.effects.listen(null, onDone: done.complete);

    await cubit.close();
    cubit.fire('after-close');

    await expectLater(done.future, completes);
  });
}
