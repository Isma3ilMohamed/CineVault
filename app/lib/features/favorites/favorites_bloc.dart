import 'package:bloc/bloc.dart';
import 'package:cine_vault/features/favorites/favorites_contract.dart';
import 'package:core_base/core_base.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
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
