import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Shown for a location that matches no route or has invalid parameters
/// (e.g. `/movie/abc`).
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(AppLocalizations.of(context).routeNotFound)),
    );
  }
}
