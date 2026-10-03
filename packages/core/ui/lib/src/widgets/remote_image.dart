import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_ui/src/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Network image with the app's shimmer placeholder and fallback.
///
/// Every remote image goes through here, so tests can replace all of them at
/// once with [RemoteImageScope] (no network or platform plugins in tests).
///
/// Images are decoded at the size they are shown at, not at their full
/// resolution: a decoded image costs width x height x 4 bytes of memory
/// whatever its file size (see [decodeWidth]).
class RemoteImage extends StatelessWidget {
  const RemoteImage({
    required this.url,
    super.key,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.movie_outlined,
    this.sourceAspectRatio,
  });

  /// Null renders the fallback directly.
  final String? url;
  final BoxFit fit;
  final IconData fallbackIcon;

  /// Width / height of the source image when known (e.g.
  /// `TmdbImages.backdropAspectRatio`), so a cover-fit image is decoded large
  /// enough to fill its box without upscaling.
  final double? sourceAspectRatio;

  /// The pixel width to decode at, or null to decode at full size (unbounded
  /// width).
  ///
  /// With `BoxFit.cover` an image wider than its box is scaled by height, so
  /// it needs `boxHeight * aspectRatio` pixels of width, more than the box
  /// width. Only the width is constrained, so the aspect ratio is kept.
  static int? decodeWidth({
    required BoxConstraints constraints,
    required double devicePixelRatio,
    double? sourceAspectRatio,
  }) {
    if (!constraints.hasBoundedWidth) return null;
    var width = constraints.maxWidth;
    if (sourceAspectRatio != null && constraints.hasBoundedHeight) {
      width = math.max(width, constraints.maxHeight * sourceAspectRatio);
    }
    return (width * devicePixelRatio).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final override = RemoteImageScope.maybeOf(context);
    if (override != null) return override(url);

    final colors = context.appColors;
    final fallback = ColoredBox(
      color: colors.imagePlaceholder,
      child: Center(child: Icon(fallbackIcon, color: Colors.white24, size: 40)),
    );
    final imageUrl = url;
    if (imageUrl == null) return fallback;

    return LayoutBuilder(
      builder: (context, constraints) => CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        memCacheWidth: decodeWidth(
          constraints: constraints,
          devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
          sourceAspectRatio: sourceAspectRatio,
        ),
        placeholder: (_, _) => Shimmer.fromColors(
          baseColor: colors.shimmerBase,
          highlightColor: colors.shimmerHighlight,
          child: ColoredBox(color: colors.shimmerBase),
        ),
        errorWidget: (_, _, _) => fallback,
      ),
    );
  }
}

/// Replaces every [RemoteImage] below it, e.g. with a flat color in golden tests.
class RemoteImageScope extends InheritedWidget {
  const RemoteImageScope({required this.builder, required super.child, super.key});

  final Widget Function(String? url) builder;

  static Widget Function(String? url)? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RemoteImageScope>()?.builder;

  @override
  bool updateShouldNotify(RemoteImageScope oldWidget) => builder != oldWidget.builder;
}
