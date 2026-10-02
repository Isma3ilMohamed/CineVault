import 'dart:async';

import 'package:cine_vault/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:cine_vault/features/settings/presentation/widgets/theme_reveal_controller.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MorePage extends StatelessWidget {
  const MorePage({required this.themeBoundaryKey, super.key});

  /// RepaintBoundary around the root MaterialApp, snapshotted for the theme reveal.
  final GlobalKey themeBoundaryKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.moreTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFE50914),
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _SectionHeader(text: l10n.moreAppearance),
          _ThemeToggleTile(boundaryKey: themeBoundaryKey),
          const Divider(height: 32),
          _SectionHeader(text: l10n.moreLanguage),
          const _LanguageTiles(),
          const Divider(height: 32),
          _SectionHeader(text: l10n.moreAbout),
          const _AboutTiles(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
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

class _ThemeToggleTile extends StatelessWidget {
  const _ThemeToggleTile({required this.boundaryKey});
  final GlobalKey boundaryKey;

  Future<void> _handleTap(BuildContext context, Offset position) async {
    final cubit = context.read<SettingsCubit>();
    final isDark = cubit.state.themeMode == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;

    await ThemeRevealController(boundaryKey).reveal(
      context: context,
      tapPosition: position,
      onThemeSwitch: () => cubit.setThemeMode(newMode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeMode = context.select<SettingsCubit, ThemeMode>((c) => c.state.themeMode);
    final isDark = themeMode == ThemeMode.dark;

    return _TapPositionDetector(
      onTap: (position) => _handleTap(context, position),
      child: ListTile(
        leading: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
        title: Text(l10n.moreTheme),
        subtitle: Text(isDark ? l10n.moreThemeDark : l10n.moreThemeLight),
        trailing: Switch(
          value: isDark,
          onChanged: null, // Visual only: the row handles taps so we get the tap position.
        ),
      ),
    );
  }
}

class _TapPositionDetector extends StatelessWidget {
  const _TapPositionDetector({required this.child, required this.onTap});
  final Widget child;
  final ValueChanged<Offset> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) => onTap(details.globalPosition),
      child: child,
    );
  }
}

class _LanguageTiles extends StatelessWidget {
  const _LanguageTiles();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = context.select<SettingsCubit, Locale?>((c) => c.state.locale);

    // null → system. We show the active language based on what's resolved.
    final activeCode = currentLocale?.languageCode ?? Localizations.localeOf(context).languageCode;

    return RadioGroup<String>(
      groupValue: activeCode,
      onChanged: (code) {
        if (code == null) return;
        unawaited(context.read<SettingsCubit>().setLocale(Locale(code)));
      },
      child: Column(
        children: [
          RadioListTile<String>(title: Text(l10n.moreLanguageEnglish), value: 'en'),
          RadioListTile<String>(title: Text(l10n.moreLanguageArabic), value: 'ar'),
        ],
      ),
    );
  }
}

class _AboutTiles extends StatelessWidget {
  const _AboutTiles();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline_rounded),
          title: Text(l10n.moreAboutVersion('1.0.0')),
        ),
        ListTile(leading: const Icon(Icons.movie_outlined), title: Text(l10n.moreAboutTmdb)),
      ],
    );
  }
}
