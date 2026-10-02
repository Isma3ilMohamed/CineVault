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

  String? get fullProfileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : null;

  @override
  List<Object?> get props => [id, name, character, profilePath, order];
}
