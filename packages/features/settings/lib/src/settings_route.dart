import 'package:flutter/material.dart';
import 'package:settings/src/settings_screen.dart';

/// Entry point of the settings screen.
///
/// Provides no bloc: the screen edits the app-wide `SettingsCubit`, which the
/// app provides above MaterialApp. It has no exits either, so there is no
/// navigation file.
class SettingsRoute extends StatelessWidget {
  const SettingsRoute({required this.themeBoundaryKey, super.key});

  /// RepaintBoundary around the whole app, snapshotted for the theme reveal.
  final GlobalKey themeBoundaryKey;

  @override
  Widget build(BuildContext context) => SettingsScreen(themeBoundaryKey: themeBoundaryKey);
}
