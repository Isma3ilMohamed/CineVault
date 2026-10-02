import 'package:equatable/equatable.dart';

/// ببساطة كدا: TMDB genre مع id + name
/// Entity pure — pure Dart بدون JSON parsing
class Genre extends Equatable {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
