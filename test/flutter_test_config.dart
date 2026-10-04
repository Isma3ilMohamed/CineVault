import 'dart:async';

import 'helpers/tolerant_goldens.dart';

/// Golden tests tolerate anti-aliasing noise between machines (see
/// [defaultGoldenTolerance]).
Future<void> testExecutable(FutureOr<void> Function() testMain) => runWithTolerantGoldens(testMain);
