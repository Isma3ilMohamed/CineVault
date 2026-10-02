import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/genre.dart';
import '../../domain/usecases/get_genres.dart';

/// ببساطة كدا: Global cache للـ TMDB genres
/// - بيتحمل مرة واحدة لما الـ app يشتغل
/// - بيتعرض `Map<int, String>` للـ O(1) lookup من movie.genreIds → names
/// - لو الـ fetch فشل، الـ state بيفضل فاضي — الـ UI بيخفي الـ chips silently
class GenresCubit extends Cubit<Map<int, String>> {
  final GetGenres getGenres;

  GenresCubit({required this.getGenres}) : super(const {});

  /// Load مرة واحدة. لو حصل error silently stays at empty map.
  Future<void> load() async {
    if (state.isNotEmpty) return; // already loaded
    final result = await getGenres(const NoParams());
    if (result case Ok(:final value)) {
      emit({for (final Genre g in value) g.id: g.name});
    }
  }

  /// Helper للـ UI: بيترجم list of ids لـ list of names
  List<String> namesFor(List<int> ids) {
    return ids
        .map((id) => state[id])
        .whereType<String>()
        .toList();
  }
}
