import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../bloc/search_bloc.dart';
import '../widgets/recent_searches_list.dart';
import '../widgets/search_results_grid.dart';

/// ببساطة كدا: صفحة البحث
/// - TextField في AppBar متركز عليه أوتوماتيك
/// - تحت: recents (لو مفيش query)، spinner، results، أو empty/error
///
/// الـ Bloc بيتعمل في الـ router ومعاه SearchStarted event
/// لتحميل الـ recents.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // نفتح الـ keyboard بعد أول frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    context.read<SearchBloc>().add(SearchQueryChanged(value));
  }

  void _onClear() {
    _controller.clear();
    context.read<SearchBloc>().add(const SearchCleared());
    _focusNode.requestFocus();
  }

  void _onRecentTap(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.collapsed(offset: query.length);
    context.read<SearchBloc>().add(RecentSearchTapped(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: _SearchField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onQueryChanged,
          onClear: _onClear,
        ),
        titleSpacing: 0,
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return switch (state) {
            SearchIdle(:final recentSearches) => RecentSearchesList(
                searches: recentSearches,
                onTap: _onRecentTap,
                onClearAll: () => context
                    .read<SearchBloc>()
                    .add(const RecentSearchesCleared()),
              ),
            SearchLoading() => const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              ),
            SearchLoaded(
              :final results,
              :final isLoadingMore,
              :final hasReachedMax,
            ) =>
              SearchResultsGrid(
                movies: results,
                isLoadingMore: isLoadingMore,
                hasReachedMax: hasReachedMax,
                onLoadMore: () =>
                    context.read<SearchBloc>().add(const SearchLoadMore()),
                onMovieTap: (movie, heroTag) => context.push(
                  '/movie/${movie.id}',
                  extra: {'heroTag': heroTag},
                ),
              ),
            SearchEmpty(:final query) => _EmptyResults(query: query),
            SearchError(:final message) => _ErrorView(
                message: message,
                onRetry: () =>
                    context.read<SearchBloc>().add(const SearchRetried()),
              ),
          };
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      style: TextStyle(color: onSurface, fontSize: 16),
      cursorColor: const Color(0xFFE50914),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).searchHint,
        hintStyle: TextStyle(color: onSurface.withValues(alpha: 0.4)),
        border: InputBorder.none,
        filled: false,
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: onSurface.withValues(alpha: 0.55),
              ),
              onPressed: onClear,
            );
          },
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final String query;

  const _EmptyResults({required this.query});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.searchNothingFound(query),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.55),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: onSurface.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context).tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
