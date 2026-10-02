import 'dart:async';

import 'package:cine_vault/features/favorites/domain/usecases/watch_favorites.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

/// An empty list is emitted as FavoritesLoaded rather than a separate state,
/// to keep UI transitions smooth.
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required this.watchFavorites}) : super(const FavoritesInitial()) {
    on<FavoritesSubscribed>(_onSubscribed);
    on<_FavoritesUpdated>(_onUpdated);
  }
  final WatchFavorites watchFavorites;

  StreamSubscription<List<Movie>>? _subscription;

  Future<void> _onSubscribed(FavoritesSubscribed event, Emitter<FavoritesState> emit) async {
    await _subscription?.cancel();
    _subscription = watchFavorites().listen((movies) => add(_FavoritesUpdated(movies)));
  }

  void _onUpdated(_FavoritesUpdated event, Emitter<FavoritesState> emit) {
    emit(FavoritesLoaded(movies: event.movies));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
