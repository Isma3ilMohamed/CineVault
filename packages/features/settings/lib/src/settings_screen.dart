import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/src/settings_content.dart';
import 'package:settings/src/settings_cubit.dart';
import 'package:settings/src/theme_reveal/theme_reveal_controller.dart';

/// Binds the app-wide [SettingsCubit] to [SettingsContent]. Owns the theme
/// reveal animation, which is UI only.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.themeBoundaryKey, super.key});

  final GlobalKey themeBoundaryKey;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) => SettingsContent(
        settings: settings,
        onThemeTap: (tapPosition) {
          final next = settings.themeMode == AppThemeMode.dark
              ? AppThemeMode.light
              : AppThemeMode.dark;
          unawaited(
            ThemeRevealController(themeBoundaryKey).reveal(
              context: context,
              tapPosition: tapPosition,
              onThemeSwitch: () => cubit.setThemeMode(next),
            ),
          );
        },
        onLanguageSelected: (code) => unawaited(cubit.setLanguage(code)),
      ),
    );
  }
}
