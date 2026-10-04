import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Borderless search input for the app bar, with a clear button once it has text.
class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      style: TextStyle(color: onSurface, fontSize: 16),
      cursorColor: context.appColors.brand,
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
              icon: Icon(Icons.close_rounded, color: onSurface.withValues(alpha: 0.55)),
              onPressed: onClear,
            );
          },
        ),
      ),
    );
  }
}
