import 'package:core_base/core_base.dart';
import 'package:core_base/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _EffectCubit extends Cubit<int> with EffectEmitter<int, String> {
  _EffectCubit() : super(0);

  void fire(String effect) => emitEffect(effect);
}

void main() {
  testWidgets('delivers effects from the provided bloc, including one fired on creation', (
    tester,
  ) async {
    final received = <String>[];

    await tester.pumpWidget(
      BlocProvider(
        // Fired before the listener subscribes: must still arrive (buffered).
        create: (_) => _EffectCubit()..fire('on-create'),
        child: BlocEffectListener<_EffectCubit, String>(
          onEffect: (_, effect) => received.add(effect),
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pump();
    expect(received, ['on-create']);

    tester.element(find.byType(SizedBox)).read<_EffectCubit>().fire('later');
    await tester.pump();
    expect(received, ['on-create', 'later']);
  });

  testWidgets('stops listening once removed from the tree', (tester) async {
    final cubit = _EffectCubit();
    addTearDown(cubit.close);
    final received = <String>[];

    await tester.pumpWidget(
      BlocEffectListener<_EffectCubit, String>(
        bloc: cubit,
        onEffect: (_, effect) => received.add(effect),
        child: const SizedBox(),
      ),
    );
    await tester.pumpWidget(const SizedBox());

    cubit.fire('after-dispose');
    await tester.pump();
    expect(received, isEmpty);
  });

  testWidgets('switches to a new bloc passed via the bloc parameter', (tester) async {
    final first = _EffectCubit();
    final second = _EffectCubit();
    addTearDown(first.close);
    addTearDown(second.close);
    final received = <String>[];

    Widget listenerFor(_EffectCubit cubit) => BlocEffectListener<_EffectCubit, String>(
      bloc: cubit,
      onEffect: (_, effect) => received.add(effect),
      child: const SizedBox(),
    );

    await tester.pumpWidget(listenerFor(first));
    await tester.pumpWidget(listenerFor(second));

    first.fire('from-first');
    second.fire('from-second');
    await tester.pump();

    expect(received, ['from-second']);
  });
}
