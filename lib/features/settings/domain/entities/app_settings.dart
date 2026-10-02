import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// ببساطة كدا: الإعدادات اللي بنخزنها
/// - themeMode: light/dark/system
/// - locale: اللغة الحالية (null = system default)
class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final Locale? locale;

  const AppSettings({
    required this.themeMode,
    this.locale,
  });

  /// الـ defaults لما المستخدم يفتح التطبيق أول مرة
  const AppSettings.defaults()
      : themeMode = ThemeMode.dark,
        locale = null; // null → follows device

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : (locale ?? this.locale),
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
