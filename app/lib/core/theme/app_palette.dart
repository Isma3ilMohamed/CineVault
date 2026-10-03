import 'package:flutter/painting.dart';

/// Primitive color tokens: every raw color the app uses, named by what it is,
/// not by where it is used.
///
/// Nothing outside the theme reads these. Widgets use the semantic layer:
/// `context.appColors` (AppColors) and `Theme.of(context).colorScheme`, which
/// map roles (brand, rating, placeholder...) to these values per theme.
abstract final class AppPalette {
  static const Color red500 = Color(0xFFE50914);
  static const Color gold500 = Color(0xFFFFB800);

  /// Near-black blues behind the dark theme, darkest first.
  static const Color ink950 = Color(0xFF0F0F14);
  static const Color ink900 = Color(0xFF1A1A23);
  static const Color ink800 = Color(0xFF252530);

  /// Off-whites behind the light theme.
  static const Color mist50 = Color(0xFFF8F8F8);
  static const Color mist100 = Color(0xFFF0F0F3);

  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black50 = Color(0x80000000);
}
