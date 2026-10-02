import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// ببساطة كدا: الـ overlay اللي بيعمل circular reveal animation
/// زي تيليجرام — الـ inner circle = الـ theme الجديد (المكشوف)،
/// الـ outer = الـ theme القديم (الـ screenshot ده).
///
/// الفكرة:
///   1. قبل ما الـ theme يتغير، بنلتقط صورة للـ UI الحالي (من RepaintBoundary)
///   2. بنحطها في overlay فوق كل حاجة
///   3. بنغير الـ theme (الـ MaterialApp يعيد build تحت الـ overlay)
///   4. بنعمل animate لـ ClipPath — circle بيكبر من tap position
///   5. الـ circle بيتـ cut out من الـ screenshot → الـ new theme بيبان
///   6. لما الـ animation يخلص، نشيل الـ overlay
///
/// Inverse ClipPath:
///   - نرسم كل الشاشة (rectangle)
///   - نرسم circle داخل النقطة اللي المستخدم ضغط عليها
///   - PathFillType.evenOdd → الـ circle يبقى فاضي (transparent)
///   - كل ما الـ circle يكبر، الـ hole يكبر → الـ theme الجديد يبان أكتر
class ThemeRevealOverlay extends StatefulWidget {
  final ui.Image oldThemeImage;
  final Offset center;
  final Duration duration;
  final VoidCallback onCompleted;

  const ThemeRevealOverlay({
    super.key,
    required this.oldThemeImage,
    required this.center,
    required this.onCompleted,
    this.duration = const Duration(milliseconds: 650),
  });

  @override
  State<ThemeRevealOverlay> createState() => _ThemeRevealOverlayState();
}

class _ThemeRevealOverlayState extends State<ThemeRevealOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onCompleted();
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.oldThemeImage.dispose();
    super.dispose();
  }

  double _maxRadius(Size size) {
    // أكبر مسافة من الـ center لأي corner
    final dx = [widget.center.dx, size.width - widget.center.dx]
        .reduce((a, b) => a > b ? a : b);
    final dy = [widget.center.dy, size.height - widget.center.dy]
        .reduce((a, b) => a > b ? a : b);
    return Offset(dx, dy).distance * 1.05; // slight overshoot
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxRadius = _maxRadius(size);

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final radius = _animation.value * maxRadius;
          return ClipPath(
            clipper: _InverseCircleClipper(
              center: widget.center,
              radius: radius,
            ),
            child: SizedBox.expand(
              child: RawImage(
                image: widget.oldThemeImage,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Clipper بينحت circle من الـ rectangle بتاع الـ screen
/// الـ evenOdd fill rule بيخلي الـ circle area transparent
class _InverseCircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  _InverseCircleClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(_InverseCircleClipper oldClipper) =>
      oldClipper.radius != radius || oldClipper.center != center;
}
