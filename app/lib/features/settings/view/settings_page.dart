import 'package:cine_vault/features/settings/view/settings_view.dart';
import 'package:flutter/material.dart';

/// Settings entry. Provides no bloc: the view edits the app-wide
/// `SettingsCubit`, which the app provides above MaterialApp.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => const SettingsView();
}
