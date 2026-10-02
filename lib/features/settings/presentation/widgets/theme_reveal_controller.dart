import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'theme_reveal_overlay.dart';

/// [boundaryKey] must be on a RepaintBoundary wrapping the MaterialApp so the
/// current UI can be snapshotted before the theme switches.
class ThemeRevealController {
  final GlobalKey boundaryKey;

  ThemeRevealController(this.boundaryKey);

  /// [onThemeSwitch] must switch the theme synchronously.
  Future<void> reveal({
    required BuildContext context,
    required Offset tapPosition,
    required VoidCallback onThemeSwitch,
  }) async {
    final boundary = boundaryKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary) {
      onThemeSwitch();
      return;
    }

    final ui.Image image;
    try {
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);
      image = await boundary.toImage(pixelRatio: pixelRatio);
    } catch (_) {
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
