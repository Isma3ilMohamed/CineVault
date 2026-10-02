import '../../../movies/domain/entities/movie.dart';
import '../repositories/favorites_repository.dart';

/// ببساطة كدا: stream لكل الأفلام المفضلة — newest first
/// بيتستخدم في FavoritesPage
///
/// ملاحظة: مش UseCase التقليدي لأنه Stream بدون Result
/// (الـ error handling هيتعمل جوه الـ Bloc عبر addError/listen)
class WatchFavorites {
  final FavoritesRepository repository;

  const WatchFavorites(this.repository);

  Stream<List<Movie>> call() => repository.watchFavorites();
}
