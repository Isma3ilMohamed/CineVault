import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/genre.dart';
import '../../domain/usecases/get_genres.dart';

/// If the fetch fails the state stays empty and the UI hides genre chips.
class GenresCubit extends Cubit<Map<int, String>> {
  final GetGenres getGenres;

  GenresCubit({required this.getGenres}) : super(const {});

  Future<void> load() async {
    if (state.isNotEmpty) return;
    final result = await getGenres(const NoParams());
    if (result case Ok(:final value)) {
      emit({for (final Genre g in value) g.id: g.name});
    }
  }

  List<String> namesFor(List<int> ids) {
    return ids
        .map((id) => state[id])
        .whereType<String>()
        .toList();
  }
}
