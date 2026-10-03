import 'package:cine_vault/core/widgets/movie_ui/l10n/generated/movie_ui_localizations.dart';
import 'package:domain/domain.dart';
import 'package:flutter/widgets.dart';

extension MovieCategoryLabel on MovieCategory {
  /// Section and screen title for this category, e.g. "Top Rated".
  String label(BuildContext context) {
    final l10n = MovieUiLocalizations.of(context);
    return switch (this) {
      MovieCategory.trending => l10n.categoryTrending,
      MovieCategory.popular => l10n.categoryPopular,
      MovieCategory.topRated => l10n.categoryTopRated,
      MovieCategory.nowPlaying => l10n.categoryNowPlaying,
      MovieCategory.upcoming => l10n.categoryUpcoming,
    };
  }
}
