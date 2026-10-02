import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';

/// ببساطة كدا: shell بـ bottom nav — 3 tabs (Home, Favorites, More)
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        indicatorColor:
            const Color(0xFFE50914).withValues(alpha: 0.25),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon:
                const Icon(Icons.home_rounded, color: Color(0xFFE50914)),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border_rounded),
            selectedIcon:
                const Icon(Icons.favorite_rounded, color: Color(0xFFE50914)),
            label: l10n.tabFavorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz_rounded),
            selectedIcon: const Icon(
              Icons.more_horiz_rounded,
              color: Color(0xFFE50914),
            ),
            label: l10n.tabMore,
          ),
        ],
      ),
    );
  }
}
