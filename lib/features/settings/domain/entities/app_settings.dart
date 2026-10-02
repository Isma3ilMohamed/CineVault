import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({required this.themeMode, this.locale});

  const AppSettings.defaults() : themeMode = ThemeMode.dark, locale = null;
  final ThemeMode themeMode;
  final Locale? locale; // null → follows device

  AppSettings copyWith({ThemeMode? themeMode, Locale? locale, bool clearLocale = false}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : (locale ?? this.locale),
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
