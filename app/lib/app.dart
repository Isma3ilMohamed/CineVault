import 'package:cine_vault/core/di/injection.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:home/home.dart';
import 'package:movie_details/movie_details.dart';
import 'package:movie_ui/movie_ui.dart';
import 'package:navigation/navigation.dart';
import 'package:search/search.dart';
import 'package:settings/settings.dart';

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
            title: 'CineVault',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.flutterThemeMode,
            locale: settings.locale, // null → follows system
            supportedLocales: CoreUiLocalizations.supportedLocales,
            localizationsDelegates: const [
              CoreUiLocalizations.delegate,
              MovieUiLocalizations.delegate,
              NavigationLocalizations.delegate,
              HomeLocalizations.delegate,
              MovieDetailsLocalizations.delegate,
              SearchLocalizations.delegate,
              FavoritesLocalizations.delegate,
              SettingsLocalizations.delegate,
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
