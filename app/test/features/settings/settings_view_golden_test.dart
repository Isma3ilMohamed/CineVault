import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/features/settings/settings.dart';
import 'package:cine_vault/features/settings/view/settings_view.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Both themes in English and Arabic (RTL). Regenerate with
/// `flutter test --update-goldens`.
void main() {
  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final mode in const [AppThemeMode.dark, AppThemeMode.light]) {
      final name = '${mode.name}_${locale.languageCode}';
      testWidgets(name, (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _GoldenApp(
            locale: locale,
            settings: AppSettings(themeMode: mode),
          ),
        );

        await expectLater(find.byType(SettingsView), matchesGoldenFile('goldens/$name.png'));
      });
    }
  }
}

class _MockSettingsCubit extends MockCubit<AppSettings> implements SettingsCubit {}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.locale, required this.settings});

  final Locale locale;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final cubit = _MockSettingsCubit();
    when(() => cubit.state).thenReturn(settings);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.flutterThemeMode,
      locale: locale,
      supportedLocales: SettingsLocalizations.supportedLocales,
      localizationsDelegates: const [
        SettingsLocalizations.delegate,
        CoreUiLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: BlocProvider<SettingsCubit>.value(value: cubit, child: const SettingsView()),
    );
  }
}
