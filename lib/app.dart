import 'package:cine_vault/core/di/injection_container.dart';
import 'package:cine_vault/core/router/app_router.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
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
import 'package:search/search.dart';
import 'package:settings/settings.dart';

class CineVaultApp extends StatefulWidget {
  const CineVaultApp({super.key});

  @override
  State<CineVaultApp> createState() => _CineVaultAppState();
}

class _CineVaultAppState extends State<CineVaultApp> {
  final GlobalKey _themeBoundaryKey = GlobalKey(debugLabel: 'theme_boundary');

  // Created once, never in build(): rebuilding it on theme/locale change re-creates
  // its static GlobalKeys (duplicate GlobalKey error) and resets navigation to /home.
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.router(_themeBoundaryKey);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // App-wide singletons owned by GetIt, so `.value`: the provider must not close them.
        BlocProvider<FavoriteIdsCubit>.value(value: sl<FavoriteIdsCubit>()),
        BlocProvider<SettingsCubit>.value(value: sl<SettingsCubit>()),
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
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              CoreUiLocalizations.delegate,
              MovieUiLocalizations.delegate,
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
            builder: (context, child) {
              return RepaintBoundary(
                key: _themeBoundaryKey,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
