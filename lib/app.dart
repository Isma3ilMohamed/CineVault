import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/favorites/presentation/cubit/favorite_ids_cubit.dart';
import 'features/movies/presentation/cubit/genres_cubit.dart';
import 'features/settings/domain/entities/app_settings.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'l10n/generated/app_localizations.dart';

/// ببساطة كدا: root widget
///
/// مهم: الـ GoRouter بيتعمل مرة واحدة في `initState` ومش بيتعاد.
/// لو عملناه جوه build، كل BlocBuilder rebuild (theme/locale change)
/// هيعمل router جديد بنفس الـ GlobalKeys الـ static → duplicate GlobalKey error،
/// وكمان هيرجع الـ navigation للـ initialLocation ('/home') مع كل تغيير.
///
/// الـ pattern: stateful widget يمسك الـ router + key، والـ MaterialApp
/// بيتـ rebuild بس بقيم theme/locale الجديدة.
class CineVaultApp extends StatefulWidget {
  const CineVaultApp({super.key});

  @override
  State<CineVaultApp> createState() => _CineVaultAppState();
}

class _CineVaultAppState extends State<CineVaultApp> {
  final GlobalKey _themeBoundaryKey =
      GlobalKey(debugLabel: 'theme_boundary');

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
          // fire-and-forget load — lookups return empty until loaded,
          // at which point UI re-renders via context.select
          create: (_) => sl<GenresCubit>()..load(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'CineVault',
            debugShowCheckedModeBanner: false,
            // Themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            // Localization
            locale: settings.locale, // null → follows system
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            // Reuse the same router across rebuilds (stable, keeps nav state)
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
