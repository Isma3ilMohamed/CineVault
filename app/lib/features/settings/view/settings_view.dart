import 'dart:async';

import 'package:cine_vault/features/settings/cubit/settings_cubit.dart';
import 'package:cine_vault/features/settings/l10n/generated/settings_localizations.dart';
import 'package:cine_vault/features/settings/view/theme_reveal/theme_reveal_boundary.dart';
import 'package:cine_vault/features/settings/view/theme_reveal/theme_reveal_controller.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The settings UI, bound to the app-wide [SettingsCubit]. Owns the theme
/// reveal animation, which is UI only.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) => _SettingsBody(
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

/// Draws the settings for one [AppSettings].
class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.settings,
    required this.onThemeTap,
    required this.onLanguageSelected,
  });

  // TODO(phase-9): read from the build (package_info) with the constants in step 4.
  static const String _appVersion = '1.0.0';

  final AppSettings settings;

  /// Global tap position: the theme reveal grows from there.
  final ValueChanged<Offset> onThemeTap;
  final ValueChanged<String> onLanguageSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = SettingsLocalizations.of(context);
    // Following the device: show the language the app actually resolved to.
    final activeLanguage = settings.languageCode ?? Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.moreTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.appColors.brand,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _SectionHeader(l10n.moreAppearance),
          _ThemeTile(isDark: settings.themeMode == AppThemeMode.dark, onTap: onThemeTap),
          const Divider(height: 32),
          _SectionHeader(l10n.moreLanguage),
          RadioGroup<String>(
            groupValue: activeLanguage,
            onChanged: (code) {
              if (code != null) onLanguageSelected(code);
            },
            child: Column(
              children: [
                RadioListTile<String>(title: Text(l10n.moreLanguageEnglish), value: 'en'),
                RadioListTile<String>(title: Text(l10n.moreLanguageArabic), value: 'ar'),
              ],
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(l10n.moreAbout),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(l10n.moreAboutVersion(_appVersion)),
          ),
          ListTile(leading: const Icon(Icons.movie_outlined), title: Text(l10n.moreAboutTmdb)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.isDark, required this.onTap});

  final bool isDark;
  final ValueChanged<Offset> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = SettingsLocalizations.of(context);
    // The whole row takes the tap (with its position); the switch only shows the value.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) => onTap(details.globalPosition),
      child: ListTile(
        leading: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
        title: Text(l10n.moreTheme),
        subtitle: Text(isDark ? l10n.moreThemeDark : l10n.moreThemeLight),
        trailing: Switch(value: isDark, onChanged: null),
      ),
    );
  }
}
