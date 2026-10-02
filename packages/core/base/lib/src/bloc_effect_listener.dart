import 'dart:async';

import 'package:core_base/src/effect_emitter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Calls [onEffect] for every effect emitted by [B].
///
/// The bloc comes from [bloc] or, when null, from the nearest `BlocProvider<B>`.
/// Effects are consumed in one place per feature: its Route.
class BlocEffectListener<B extends EffectEmitter<Object?, E>, E> extends StatefulWidget {
  const BlocEffectListener({required this.onEffect, required this.child, this.bloc, super.key});

  final B? bloc;
  final void Function(BuildContext context, E effect) onEffect;
  final Widget child;

  @override
  State<BlocEffectListener<B, E>> createState() => _BlocEffectListenerState<B, E>();
}

class _BlocEffectListenerState<B extends EffectEmitter<Object?, E>, E>
    extends State<BlocEffectListener<B, E>> {
  late B _bloc;
  StreamSubscription<E>? _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocEffectListener<B, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resubscribeIfBlocChanged();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resubscribeIfBlocChanged();
  }

  void _resubscribeIfBlocChanged() {
    final current = widget.bloc ?? context.read<B>();
    if (identical(current, _bloc)) return;
    _unsubscribe();
    _bloc = current;
    _subscribe();
  }

  void _subscribe() {
    _subscription = _bloc.effects.listen((effect) {
      if (mounted) widget.onEffect(context, effect);
    });
  }

  void _unsubscribe() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
