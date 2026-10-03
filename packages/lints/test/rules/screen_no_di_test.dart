// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/screen_no_di.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(() => defineReflectiveTests(ScreenNoDiTest));
}

@reflectiveTest
class ScreenNoDiTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = ScreenNoDi();
    super.setUp();
  }

  Future<void> test_screen_importing_get_it() => expectLints(
    'src/movie_details_screen.dart',
    "import 'package:get_it/get_it.dart';",
    ["'package:get_it/get_it.dart'"],
  );

  Future<void> test_route_may_use_get_it() => expectLints(
    'src/movie_details_route.dart',
    "import 'package:get_it/get_it.dart';",
    [],
  );
}
