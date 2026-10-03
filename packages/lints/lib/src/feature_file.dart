/// The role a file plays inside a feature package, derived from its name.
///
/// See "Feature Anatomy" in ARCHITECTURE_NOTES.md.
enum FeatureFileRole {
  /// `*_route.dart`: entry and exit point (provides the bloc, maps navigation).
  route,

  /// `*_navigation.dart`: UI-originated navigation effects.
  navigation,

  /// `*_screen.dart`: binds bloc state to the content.
  screen,

  /// `*_content.dart`: pure UI.
  content,

  /// `*_contract.dart`: state, events and effects.
  contract,

  /// `*_bloc.dart` or `*_cubit.dart`: the view model (or app-wide state).
  bloc,

  /// Anything under `widgets/`: building blocks of the content, pure as well.
  widget,

  /// Any other file in a feature package (barrels, helpers).
  other,
}

/// The role of the file at [path], or `null` when it is not inside a feature
/// package (`packages/features/<name>/lib/`).
///
/// Only feature packages are checked, so code that has not been migrated to
/// the feature anatomy yet is left alone.
FeatureFileRole? featureFileRole(String path) {
  final normalized = path.replaceAll(r'\', '/');
  final featuresIndex = normalized.indexOf('/packages/features/');
  if (featuresIndex == -1) return null;
  if (!normalized.substring(featuresIndex).contains('/lib/')) return null;

  final fileName = normalized.substring(normalized.lastIndexOf('/') + 1);
  for (final (suffix, role) in _suffixes) {
    if (fileName.endsWith(suffix)) return role;
  }
  if (normalized.contains('/widgets/')) return FeatureFileRole.widget;
  return FeatureFileRole.other;
}

const List<(String, FeatureFileRole)> _suffixes = [
  ('_route.dart', FeatureFileRole.route),
  ('_navigation.dart', FeatureFileRole.navigation),
  ('_screen.dart', FeatureFileRole.screen),
  ('_content.dart', FeatureFileRole.content),
  ('_contract.dart', FeatureFileRole.contract),
  ('_bloc.dart', FeatureFileRole.bloc),
  ('_cubit.dart', FeatureFileRole.bloc),
];
