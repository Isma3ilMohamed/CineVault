import 'package:cine_vault/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Semantic color tokens: roles that Material's ColorScheme has no slot for,
/// mapped to [AppPalette] primitives per theme.
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
    brand: AppPalette.red500,
    rating: AppPalette.gold500,
    imagePlaceholder: AppPalette.grey900,
    shimmerBase: AppPalette.grey800,
    shimmerHighlight: AppPalette.grey700,
    scrim: AppPalette.black50,
  );

  static const light = AppColors(
    brand: AppPalette.red500,
    rating: AppPalette.gold500,
    imagePlaceholder: AppPalette.grey300,
    shimmerBase: AppPalette.grey300,
    shimmerHighlight: AppPalette.grey100,
    scrim: AppPalette.black50,
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
