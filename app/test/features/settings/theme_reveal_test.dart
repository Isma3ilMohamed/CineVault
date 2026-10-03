import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/data/repositories/settings_repository.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/settings/settings.dart';
import 'package:cine_vault/features/settings/view/theme_reveal/theme_reveal_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() => registerFallbackValue(AppThemeMode.dark));

  Future<SettingsCubit> pumpSettings(WidgetTester tester, {required bool withBoundary}) async {
    final repository = _MockSettingsRepository();
    when(() => repository.saveThemeMode(any())).thenAnswer((_) async => const Ok(null));
    final cubit = SettingsCubit(
      settingsRepository: repository,
      initial: const AppSettings.defaults(),
    );
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: const [
            SettingsLocalizations.delegate,
            CoreUiLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: withBoundary ? (_, child) => ThemeRevealBoundary(child: child!) : null,
          home: const SettingsPage(),
        ),
      ),
    );
    return cubit;
  }

  testWidgets('inside ThemeRevealBoundary, the toggle animates the switch', (tester) async {
    final cubit = await pumpSettings(tester, withBoundary: true);

    // The snapshot (toImage) is real async work, so let it run outside fake time.
    await tester.runAsync(() async {
      await tester.tap(find.byType(Switch));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();

    expect(find.byType(ThemeRevealOverlay), findsOneWidget);
    expect(cubit.state.themeMode, AppThemeMode.light);
    await tester.pumpAndSettle();
    expect(find.byType(ThemeRevealOverlay), findsNothing);
  });

  testWidgets('without the boundary, the toggle still switches the theme', (tester) async {
    final cubit = await pumpSettings(tester, withBoundary: false);

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(find.byType(ThemeRevealOverlay), findsNothing);
    expect(cubit.state.themeMode, AppThemeMode.light);
  });
}
