// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/no_build_helper_methods.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(() => defineReflectiveTests(NoBuildHelperMethodsTest));
}

@reflectiveTest
class NoBuildHelperMethodsTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = NoBuildHelperMethods();
    super.setUp();
  }

  Future<void> test_private_method_returning_a_widget() => expectLints(
    'src/movie_details_content.dart',
    '''
import 'package:flutter/widgets.dart';
class A extends StatelessWidget {
  Text _buildTitle() => const Text('x');
  @override
  Widget build(BuildContext context) => _buildTitle();
}
''',
    ['_buildTitle'],
  );

  Future<void> test_private_top_level_function_returning_a_widget() =>
      expectLints(
        'src/widgets/x.dart',
        '''
import 'package:flutter/widgets.dart';
Widget _header() => const SizedBox();
''',
        ['_header'],
      );

  Future<void> test_build_and_public_or_non_widget_helpers_are_fine() =>
      expectLints('src/movie_details_content.dart', '''
import 'package:flutter/widgets.dart';
class A extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget local() => const SizedBox();
    return local();
  }
  String _title() => 'x';
}
''', []);
}
