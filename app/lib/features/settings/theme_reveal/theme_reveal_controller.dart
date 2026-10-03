import 'dart:ui' as ui;

import 'package:cine_vault/features/settings/theme_reveal/theme_reveal_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// [boundaryKey] is the key of the RepaintBoundary wrapping the MaterialApp
/// (see `ThemeRevealBoundary`), snapshotted before the theme switches. Without
/// it the theme switches without the animation.
class ThemeRevealController {
  ThemeRevealController(this.boundaryKey);
  final GlobalKey? boundaryKey;

  /// [onThemeSwitch] must switch the theme synchronously.
  Future<void> reveal({
    required BuildContext context,
    required Offset tapPosition,
    required VoidCallback onThemeSwitch,
  }) async {
    final boundary = boundaryKey?.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary) {
      onThemeSwitch();
      return;
    }

    final ui.Image image;
    try {
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);
      image = await boundary.toImage(pixelRatio: pixelRatio);
    } on Object catch (_) {
      // Snapshot failed: switch without the reveal animation.
      onThemeSwitch();
      return;
    }

    if (!context.mounted) {
      image.dispose();
      return;
    }

    final overlayState = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => ThemeRevealOverlay(
        oldThemeImage: image,
        center: tapPosition,
        onCompleted: () => entry.remove(),
      ),
    );
    overlayState.insert(entry);

    // Switch only after the snapshot overlay is inserted, so the rebuild
    // happens hidden beneath it and there is no flicker.
    onThemeSwitch();
  }
}
