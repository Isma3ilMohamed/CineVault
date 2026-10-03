// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/no_hardcoded_colors.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(NoHardcodedColorsTest);
    defineReflectiveTests(NoHardcodedColorsInThemeTest);
  });
}

@reflectiveTest
class NoHardcodedColorsTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = NoHardcodedColors();
    super.setUp();
  }

  Future<void> test_color_literal_in_a_feature() => expectLints(
    'src/movie_details_content.dart',
    '''
import 'package:flutter/widgets.dart';
const red = Color(0xFFE50914);
''',
    ['Color(0xFFE50914)'],
  );
}

/// The theme is where the tokens are defined, so literals are allowed there.
@reflectiveTest
class NoHardcodedColorsInThemeTest extends FeatureRuleTest {
  @override
  String get testPackageRootPath => '$workspaceRootPath/packages/core/ui';

  @override
  void setUp() {
    rule = NoHardcodedColors();
    super.setUp();
  }

  Future<void> test_color_literal_in_the_theme_is_fine() =>
      expectLints('src/theme/app_colors.dart', '''
import 'package:flutter/widgets.dart';
const red = Color(0xFFE50914);
''', []);
}
