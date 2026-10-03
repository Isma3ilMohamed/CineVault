import 'package:flutter/widgets.dart';

/// Wraps the whole app (MaterialApp's `builder`) in the RepaintBoundary that
/// the theme reveal snapshots, and makes its key available below it.
///
/// This keeps the key out of the router: the settings screen finds it with
/// [ThemeRevealBoundary.keyOf].
class ThemeRevealBoundary extends StatefulWidget {
  const ThemeRevealBoundary({required this.child, super.key});

  final Widget child;

  /// The boundary's key, or null when the app is not wrapped (e.g. in tests);
  /// the reveal then switches the theme without animating.
  static GlobalKey? keyOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_BoundaryKeyScope>()?.boundaryKey;

  @override
  State<ThemeRevealBoundary> createState() => _ThemeRevealBoundaryState();
}

class _ThemeRevealBoundaryState extends State<ThemeRevealBoundary> {
  final GlobalKey _boundaryKey = GlobalKey(debugLabel: 'theme_reveal_boundary');

  @override
  Widget build(BuildContext context) {
    return _BoundaryKeyScope(
      boundaryKey: _boundaryKey,
      child: RepaintBoundary(key: _boundaryKey, child: widget.child),
    );
  }
}

class _BoundaryKeyScope extends InheritedWidget {
  const _BoundaryKeyScope({required this.boundaryKey, required super.child});

  final GlobalKey boundaryKey;

  @override
  bool updateShouldNotify(_BoundaryKeyScope oldWidget) => boundaryKey != oldWidget.boundaryKey;
}
