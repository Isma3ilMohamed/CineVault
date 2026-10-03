import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:settings/src/l10n/generated/settings_localizations.dart';

/// Pure UI for the settings screen.
class SettingsContent extends StatelessWidget {
  const SettingsContent({
    required this.settings,
    required this.onThemeTap,
    required this.onLanguageSelected,
    super.key,
    this.appVersion = '1.0.0',
  });

  final AppSettings settings;

  /// Global tap position: the theme reveal grows from there.
  final ValueChanged<Offset> onThemeTap;
  final ValueChanged<String> onLanguageSelected;
  final String appVersion;

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
            title: Text(l10n.moreAboutVersion(appVersion)),
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
