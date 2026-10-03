import 'package:flutter/material.dart';

/// Shows a dialog whose content closes itself through the `close` callback it
/// receives, so feature code never touches `Navigator` (see the
/// `no_navigation_in_features` lint).
Future<void> showAppDialog({
  required BuildContext context,
  required Widget Function(BuildContext context, VoidCallback close) builder,
  Color barrierColor = Colors.black87,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: barrierColor,
    builder: (dialogContext) => builder(dialogContext, () => Navigator.of(dialogContext).pop()),
  );
}
