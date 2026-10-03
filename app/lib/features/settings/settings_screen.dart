import 'dart:async';

import 'package:cine_vault/features/settings/settings_content.dart';
import 'package:cine_vault/features/settings/settings_cubit.dart';
import 'package:cine_vault/features/settings/theme_reveal/theme_reveal_boundary.dart';
import 'package:cine_vault/features/settings/theme_reveal/theme_reveal_controller.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Binds the app-wide [SettingsCubit] to [SettingsContent]. Owns the theme
/// reveal animation, which is UI only.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            ThemeRevealController(ThemeRevealBoundary.keyOf(context)).reveal(
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
