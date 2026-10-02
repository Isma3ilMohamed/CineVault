import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/genre.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_genres.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// If the fetch fails the state stays empty and the UI hides genre chips.
class GenresCubit extends Cubit<Map<int, String>> {
  GenresCubit({required this.getGenres}) : super(const {});
  final GetGenres getGenres;

  Future<void> load() async {
    if (state.isNotEmpty) return;
    final result = await getGenres(const NoParams());
    if (result case Ok(:final value)) {
      emit({for (final Genre g in value) g.id: g.name});
    }
  }

  List<String> namesFor(List<int> ids) {
    return ids.map((id) => state[id]).whereType<String>().toList();
  }
}
