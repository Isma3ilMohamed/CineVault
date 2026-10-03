import 'package:bloc/bloc.dart';
import 'package:core_base/core_base.dart';
import 'package:domain/domain.dart';
import 'package:favorites/src/favorites_contract.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState>
    with EventGuard<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required this.watchFavorites}) : super(const FavoritesState.initial()) {
    on<FavoritesStarted>(
      // emit.forEach cancels the storage subscription when the bloc closes.
      (_, emit) => emit.forEach(watchFavorites(), onData: FavoritesState.loaded),
    );
  }

  final WatchFavorites watchFavorites;

  @override
  bool isEventAllowed(FavoritesEvent event, FavoritesState state) => switch ((state, event)) {
    (FavoritesInitial(), FavoritesStarted()) => true,
    _ => false,
  };
}
