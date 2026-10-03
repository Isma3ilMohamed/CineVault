import 'package:flutter/material.dart';
import 'package:navigation/src/l10n/generated/navigation_localizations.dart';

/// Shown for a location that matches no route or has invalid parameters
/// (e.g. `/movie/abc`).
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(NavigationLocalizations.of(context).routeNotFound)),
    );
  }
}
