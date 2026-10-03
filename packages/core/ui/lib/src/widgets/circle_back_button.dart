import 'package:core_ui/src/l10n/generated/core_ui_localizations.dart';
import 'package:core_ui/src/theme/app_colors.dart';
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
          tooltip: CoreUiLocalizations.of(context).back,
          icon: const BackButtonIcon(),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
