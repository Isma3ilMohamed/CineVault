import 'package:cine_vault/app/di.dart';
import 'package:cine_vault/core/constants/app_info.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/favorites/favorites.dart';
import 'package:cine_vault/features/settings/settings.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:cine_vault/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class CineVaultApp extends StatefulWidget {
  const CineVaultApp({super.key});

  @override
  State<CineVaultApp> createState() => _CineVaultAppState();
}

class _CineVaultAppState extends State<CineVaultApp> {
  // Created once, never in build(): rebuilding it on a theme or locale change
  // would re-create its global navigator keys and reset navigation to home.
  final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // App-wide singletons owned by GetIt, so `.value`: the provider must not close them.
        BlocProvider<FavoriteIdsCubit>.value(value: getIt<FavoriteIdsCubit>()),
        BlocProvider<SettingsCubit>.value(value: getIt<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: AppInfo.name,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.flutterThemeMode,
            locale: settings.locale, // null → follows system
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            routerConfig: _router,
            builder: (context, child) =>
                ThemeRevealBoundary(child: child ?? const SizedBox.shrink()),
          );
        },
      ),
    );
  }
}
