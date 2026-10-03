import 'package:equatable/equatable.dart';

/// `order` is the TMDB billing order (lower = more prominent).
class CastMember extends Equatable {
  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    required this.order,
    this.profilePath,
  });
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  @override
  List<Object?> get props => [id, name, character, profilePath, order];
}
