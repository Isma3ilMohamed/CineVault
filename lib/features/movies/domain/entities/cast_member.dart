import 'package:equatable/equatable.dart';

/// ببساطة كدا: ممثل/ة في فيلم معين
/// - character: الشخصية اللي بيلعبها (زي "Cooper")
/// - order: ترتيب الـ credits (الأقل = أهم)
class CastMember extends Equatable {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  /// TMDB profile image URL (w185 size)
  String? get fullProfileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w185$profilePath'
      : null;

  @override
  List<Object?> get props => [id, name, character, profilePath, order];
}
