import 'package:equatable/equatable.dart';

/// ببساطة كدا: video marketing للفيلم (trailer, teaser, clip, featurette...)
/// - site: "YouTube" عادةً — نقدر نعرضه
/// - key: الـ YouTube video id
/// - type: "Trailer" عادةً الأهم
class Video extends Equatable {
  final String id;
  final String key;
  final String site;
  final String name;
  final String type;
  final bool official;

  const Video({
    required this.id,
    required this.key,
    required this.site,
    required this.name,
    required this.type,
    required this.official,
  });

  bool get isYouTube => site.toLowerCase() == 'youtube';
  bool get isTrailer => type.toLowerCase() == 'trailer';

  @override
  List<Object> get props => [id, key, site, name, type, official];
}
