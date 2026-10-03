import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'favorites_bloc.freezed.dart';
part 'favorites_event.dart';
part 'favorites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required this.watchFavorites}) : super(const FavoritesState.initial()) {
    on<FavoritesStarted>(
      // emit.forEach cancels the storage subscription when the bloc closes.
      (_, emit) => emit.forEach(watchFavorites(), onData: FavoritesState.loaded),
    );
  }

  final WatchFavorites watchFavorites;
}
