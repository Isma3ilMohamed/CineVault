import 'package:cine_vault/core/theme/app_colors.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Back button that stays readable over images.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: context.appColors.scrim,
        child: IconButton(
          tooltip: AppLocalizations.of(context).back,
          icon: const BackButtonIcon(),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
