/// Whether the file at [path] is hand-written library code of the workspace:
/// under `lib/` of a package in `packages/` or of the app in `app/`, and not
/// generated (`*.g.dart`, `*.freezed.dart`, `generated/`).
///
/// The general readability rules (not tied to the feature anatomy) check
/// these files.
bool isHandWrittenSource(String path) {
  final normalized = path.replaceAll(r'\', '/');
  final inWorkspace =
      normalized.contains('/packages/') || normalized.contains('/app/');
  if (!inWorkspace || !normalized.contains('/lib/')) return false;
  if (normalized.contains('/packages/lints/')) return false;
  if (normalized.contains('/generated/')) return false;
  return !_generatedSuffixes.any(normalized.endsWith);
}

const _generatedSuffixes = [
  '.g.dart',
  '.freezed.dart',
  '.gr.dart',
  '.config.dart',
  '.module.dart',
];
