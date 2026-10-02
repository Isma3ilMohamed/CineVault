import 'dart:async';

import 'package:cine_vault/core/di/injection_container.dart';
import 'package:cine_vault/core/router/app_router.dart';
import 'package:cine_vault/core/theme/app_theme.dart';
import 'package:cine_vault/features/favorites/presentation/cubit/favorite_ids_cubit.dart';
import 'package:cine_vault/features/movies/presentation/cubit/genres_cubit.dart';
import 'package:cine_vault/features/settings/domain/entities/app_settings.dart';
import 'package:cine_vault/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
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
        BlocProvider<FavoriteIdsCubit>(create: (_) => sl<FavoriteIdsCubit>()),
        BlocProvider<SettingsCubit>.value(value: sl<SettingsCubit>()),
        BlocProvider<GenresCubit>(
          create: (_) {
            // Fire-and-forget: lookups return empty until loaded, then the UI
            // re-renders via context.select.
            final cubit = sl<GenresCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'CineVault',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            locale: settings.locale, // null → follows system
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
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
