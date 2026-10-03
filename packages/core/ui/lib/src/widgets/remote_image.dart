import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_ui/src/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Network image with the app's shimmer placeholder and fallback.
///
/// Every remote image goes through here, so tests can replace all of them at
/// once with [RemoteImageScope] (no network or platform plugins in tests).
class RemoteImage extends StatelessWidget {
  const RemoteImage({
    required this.url,
    super.key,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.movie_outlined,
  });

  /// Null renders the fallback directly.
  final String? url;
  final BoxFit fit;
  final IconData fallbackIcon;

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

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (_, _) => Shimmer.fromColors(
        baseColor: colors.shimmerBase,
        highlightColor: colors.shimmerHighlight,
        child: ColoredBox(color: colors.shimmerBase),
      ),
      errorWidget: (_, _, _) => fallback,
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
