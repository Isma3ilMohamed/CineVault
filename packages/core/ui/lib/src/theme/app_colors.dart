import 'package:flutter/material.dart';

/// Brand and semantic colors that Material's ColorScheme has no slot for.
///
/// Read with `context.appColors`. Registered on both themes in `AppTheme`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brand,
    required this.rating,
    required this.imagePlaceholder,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.scrim,
  });

  /// CineVault red: logo, primary actions, loading indicators.
  final Color brand;

  /// Star icon next to ratings.
  final Color rating;

  /// Background behind images that are missing or failed to load.
  final Color imagePlaceholder;

  final Color shimmerBase;
  final Color shimmerHighlight;

  /// Translucent dark layer for controls drawn over images (back button, badges).
  final Color scrim;

  static const dark = AppColors(
    brand: Color(0xFFE50914),
    rating: Color(0xFFFFB800),
    imagePlaceholder: Color(0xFF212121),
    shimmerBase: Color(0xFF424242),
    shimmerHighlight: Color(0xFF616161),
    scrim: Color(0x80000000),
  );

  static const light = AppColors(
    brand: Color(0xFFE50914),
    rating: Color(0xFFFFB800),
    imagePlaceholder: Color(0xFFE0E0E0),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    scrim: Color(0x80000000),
  );

  @override
  AppColors copyWith({
    Color? brand,
    Color? rating,
    Color? imagePlaceholder,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? scrim,
  }) {
    return AppColors(
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      brand: Color.lerp(brand, other.brand, t)!,
      rating: Color.lerp(rating, other.rating, t)!,
      imagePlaceholder: Color.lerp(imagePlaceholder, other.imagePlaceholder, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>() ?? AppColors.dark;
}
