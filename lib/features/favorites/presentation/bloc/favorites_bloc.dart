import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../movies/domain/entities/movie.dart';
import '../../domain/usecases/watch_favorites.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

/// ببساطة كدا: bloc لصفحة الـ Favorites
/// - بيشترك في watchFavorites stream على FavoritesSubscribed
/// - كل snapshot بيحول إلى FavoritesLoaded state
///
/// Empty vs Loaded: الـ UI بيشوف `movies.isEmpty` على الـ loaded state
/// (مش state منفصلة عشان الـ transitions تكون smoother)
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final WatchFavorites watchFavorites;

  StreamSubscription<List<Movie>>? _subscription;

  FavoritesBloc({required this.watchFavorites})
      : super(const FavoritesInitial()) {
    on<FavoritesSubscribed>(_onSubscribed);
    on<_FavoritesUpdated>(_onUpdated);
  }

  Future<void> _onSubscribed(
    FavoritesSubscribed event,
    Emitter<FavoritesState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = watchFavorites().listen(
      (movies) => add(_FavoritesUpdated(movies)),
    );
  }

  void _onUpdated(
    _FavoritesUpdated event,
    Emitter<FavoritesState> emit,
  ) {
    emit(FavoritesLoaded(movies: event.movies));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
