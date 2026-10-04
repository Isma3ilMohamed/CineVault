import 'package:bloc/bloc.dart';
import 'package:cine_vault/data/repositories/favorites_repository.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_bloc.freezed.dart';
part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required this.favoritesRepository}) : super(const FavoritesState.initial()) {
    on<FavoritesStarted>(
      // emit.forEach cancels the storage subscription when the bloc closes.
      (_, emit) =>
          emit.forEach(favoritesRepository.watchFavorites(), onData: FavoritesState.loaded),
    );
  }

  final FavoritesRepository favoritesRepository;
}
