import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'theme_reveal_overlay.dart';

/// ببساطة كدا: utility بيـ orchestrate الـ circular reveal animation
///
/// Usage:
///   final controller = ThemeRevealController(boundaryKey);
///   await controller.reveal(
///     context: context,
///     tapPosition: tapOffset,
///     onThemeSwitch: () => cubit.setThemeMode(newMode),
///   );
///
/// الـ boundaryKey لازم يكون على RepaintBoundary حوالين الـ MaterialApp
/// عشان نقدر نلتقط الـ UI الحالي كصورة.
class ThemeRevealController {
  final GlobalKey boundaryKey;

  ThemeRevealController(this.boundaryKey);

  /// بياخد snapshot للـ UI الحالي، بيبدل الـ theme، وبيعمل animate للـ reveal
  ///
  /// onThemeSwitch: الـ callback اللي بيغير الـ theme (synchronous)
  Future<void> reveal({
    required BuildContext context,
    required Offset tapPosition,
    required VoidCallback onThemeSwitch,
  }) async {
    final boundary = boundaryKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary) {
      // مفيش boundary — نعدي الـ animation ونـ switch مباشرة
      onThemeSwitch();
      return;
    }

    // Step 1: capture screenshot (old theme)
    final ui.Image image;
    try {
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);
      image = await boundary.toImage(pixelRatio: pixelRatio);
    } catch (_) {
      // لو fail، نعدي الـ animation
      onThemeSwitch();
      return;
    }

    if (!context.mounted) {
      image.dispose();
      return;
    }

    // Step 2: show overlay
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

    // Step 3: switch theme — هيعيد build لكل الـ app تحت الـ overlay
    // الـ overlay الـ screenshot ثابتة فمفيش flicker
    onThemeSwitch();
  }
}
