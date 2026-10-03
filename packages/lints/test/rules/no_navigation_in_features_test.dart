// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/no_navigation_in_features.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(
    () => defineReflectiveTests(NoNavigationInFeaturesTest),
  );
}

@reflectiveTest
class NoNavigationInFeaturesTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = NoNavigationInFeatures();
    super.setUp();
  }

  Future<void> test_importing_go_router_even_in_the_route() => expectLints(
    'src/movie_details_route.dart',
    "import 'package:go_router/go_router.dart';",
    ["'package:go_router/go_router.dart'"],
  );

  Future<void> test_using_navigator() => expectLints(
    'src/movie_details_content.dart',
    '''
import 'package:flutter/widgets.dart';
void close(BuildContext context) => Navigator.of(context);
''',
    ['Navigator'],
  );

  Future<void> test_callbacks_are_fine() =>
      expectLints('src/movie_details_route.dart', '''
import 'package:flutter/widgets.dart';
class MovieDetailsRoute { const MovieDetailsRoute({required this.onBack}); final VoidCallback onBack; }
''', []);
}
