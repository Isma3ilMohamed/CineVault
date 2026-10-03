import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/features/search/l10n/generated/search_localizations.dart';
import 'package:cine_vault/features/search/search_contract.dart';
import 'package:cine_vault/features/search/widgets/recent_searches_list.dart';
import 'package:cine_vault/features/search/widgets/search_field.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

/// Pure UI for every [SearchState].
///
/// Stateful only for the text field's controller and focus, which are UI
/// state: the bloc never sees them.
class SearchContent extends StatefulWidget {
  const SearchContent({
    required this.state,
    required this.favoriteButton,
    required this.onBack,
    required this.onQueryChanged,
    required this.onCleared,
    required this.onRecentTap,
    required this.onClearRecents,
    required this.onRetry,
    required this.onLoadMore,
    required this.onMovieTap,
    super.key,
  });

  final SearchState state;
  final FavoriteButtonBuilder favoriteButton;
  final VoidCallback onBack;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onCleared;
  final ValueChanged<String> onRecentTap;
  final VoidCallback onClearRecents;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final void Function(Movie movie, String heroTag) onMovieTap;

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    _focusNode.requestFocus();
    widget.onCleared();
  }

  void _searchRecent(String query) {
    _controller.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
    widget.onRecentTap(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: widget.onBack),
        title: SearchField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onQueryChanged,
          onClear: _clear,
        ),
        titleSpacing: 0,
      ),
      body: switch (widget.state) {
        SearchIdle(:final recentSearches) => RecentSearchesList(
          searches: recentSearches,
          onTap: _searchRecent,
          onClearAll: widget.onClearRecents,
        ),
        SearchLoading() => Center(child: CircularProgressIndicator(color: context.appColors.brand)),
        SearchLoaded(:final results, :final isLoadingMore, :final hasReachedMax) => MovieGrid(
          movies: results,
          heroTagPrefix: 'search',
          favoriteButton: widget.favoriteButton,
          onMovieTap: widget.onMovieTap,
          isLoadingMore: isLoadingMore,
          onLoadMore: hasReachedMax ? null : widget.onLoadMore,
        ),
        SearchEmpty(:final query) => _NothingFound(query: query),
        SearchError(:final failure) => ErrorView(
          message: failure.localizedMessage(context),
          retryLabel: CoreUiLocalizations.of(context).tryAgain,
          onRetry: widget.onRetry,
        ),
      },
    );
  }
}

class _NothingFound extends StatelessWidget {
  const _NothingFound({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 72, color: onSurface.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              SearchLocalizations.of(context).searchNothingFound(query),
              textAlign: TextAlign.center,
              style: TextStyle(color: onSurface.withValues(alpha: 0.55), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
