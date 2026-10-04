import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Share of pixels that may differ before a golden test fails: 0.1%.
///
/// Different machines anti-alias edges slightly differently (the CI runner
/// and a developer Mac disagree on 0.00-0.03% of pixels), which is noise, not
/// a regression. Layout bugs still fail: an overflow throws a FlutterError in
/// the test itself, and real visual changes touch far more pixels.
const double defaultGoldenTolerance = 0.001;

/// Runs [testMain] with golden comparisons that accept differences up to
/// [tolerance]. Call it from a package's `test/flutter_test_config.dart`:
///
/// ```dart
/// Future<void> testExecutable(FutureOr<void> Function() testMain) =>
///     runWithTolerantGoldens(testMain);
/// ```
Future<void> runWithTolerantGoldens(
  FutureOr<void> Function() testMain, {
  double tolerance = defaultGoldenTolerance,
}) async {
  final comparator = goldenFileComparator;
  if (comparator is LocalFileComparator) {
    // Same directory as the test file, so golden paths resolve as before.
    goldenFileComparator = TolerantGoldenComparator(
      comparator.basedir.resolve('flutter_test_config.dart'),
      tolerance: tolerance,
    );
  }
  await testMain();
}

/// [LocalFileComparator] that passes when at most [tolerance] of the pixels
/// differ. `--update-goldens` still writes exact files.
class TolerantGoldenComparator extends LocalFileComparator {
  TolerantGoldenComparator(super.testFile, {required this.tolerance});

  /// Share of pixels (0-1) that may differ.
  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    try {
      if (result.passed || result.diffPercent <= tolerance) return true;
      final message = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(message);
    } finally {
      result.dispose();
    }
  }
}
