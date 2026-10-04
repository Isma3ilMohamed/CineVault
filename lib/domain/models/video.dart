import 'package:equatable/equatable.dart';

/// `key` is the video id on `site` (usually YouTube).
class Video extends Equatable {
  const Video({
    required this.id,
    required this.key,
    required this.site,
    required this.name,
    required this.type,
    required this.official,
  });
  final String id;
  final String key;
  final String site;
  final String name;
  final String type;
  final bool official;

  bool get isYouTube => site.toLowerCase() == 'youtube';
  bool get isTrailer => type.toLowerCase() == 'trailer';

  @override
  List<Object> get props => [id, key, site, name, type, official];
}
