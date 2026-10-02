import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../movies/domain/entities/movie.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/watch_favorite_ids.dart';

/// ببساطة كدا: global cubit بيحتفظ بـ `Set<int>` للـ favorite ids
/// - بيشترك في watchFavoriteIds stream
/// - كل MovieCard و MovieDetailsPage بيسمعوا من هنا
/// - لما حد يدوس على heart، بنطلب ToggleFavorite والـ stream بيعدل الـ state
///
/// Compare مع Kee:
///   class FavoriteIdsViewModel : ViewModel() {
///     val ids: `StateFlow<Set<Int>>` = repo.watchIds().stateIn(...)
///   }
///
/// ليه Cubit مش Bloc؟
/// الـ input الوحيد هو "toggle" — event واحد بسيط. Cubit أخف.
class FavoriteIdsCubit extends Cubit<Set<int>> {
  final WatchFavoriteIds watchFavoriteIds;
  final ToggleFavorite toggleFavoriteUseCase;

  StreamSubscription<Set<int>>? _subscription;

  FavoriteIdsCubit({
    required this.watchFavoriteIds,
    required this.toggleFavoriteUseCase,
  }) : super(const <int>{}) {
    _subscription = watchFavoriteIds().listen(
      (ids) => emit(ids),
      onError: (_) {
        // silent — الـ state بيفضل كما هو
      },
    );
  }

  bool contains(int movieId) => state.contains(movieId);

  Future<void> toggle(Movie movie) async {
    // optimistic: نحدث الـ state قبل ما الـ storage يكمل
    // لو فشل، الـ stream هيرجعها لحالتها الصحيحة
    final current = state;
    final next = current.contains(movie.id)
        ? (current.difference({movie.id}))
        : (current.union({movie.id}));
    emit(next);

    await toggleFavoriteUseCase(ToggleFavoriteParams(movie: movie));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
