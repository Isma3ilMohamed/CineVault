import 'package:cine_vault/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';

/// Entry point of the settings screen.
///
/// Provides no bloc: the screen edits the app-wide `SettingsCubit`, which the
/// app provides above MaterialApp. It has no exits either, so there is no
/// navigation file.
class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) => const SettingsScreen();
}
