import 'dart:async';

import 'package:core_testing/core_testing.dart';

/// Golden tests tolerate anti-aliasing noise between machines (see
/// [defaultGoldenTolerance]).
Future<void> testExecutable(FutureOr<void> Function() testMain) => runWithTolerantGoldens(testMain);
