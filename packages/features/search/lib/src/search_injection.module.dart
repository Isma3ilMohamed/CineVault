// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:domain/domain.dart' as _i494;
import 'package:injectable/injectable.dart' as _i526;
import 'package:search/src/search_bloc.dart' as _i752;

class SearchPackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i752.SearchBloc>(
      () => _i752.SearchBloc(
        searchMovies: gh<_i494.SearchMovies>(),
        getRecentSearches: gh<_i494.GetRecentSearches>(),
        saveRecentSearch: gh<_i494.SaveRecentSearch>(),
        clearRecentSearches: gh<_i494.ClearRecentSearches>(),
      ),
    );
  }
}
