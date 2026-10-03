// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/content_must_be_pure.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(() => defineReflectiveTests(ContentMustBePureTest));
}

@reflectiveTest
class ContentMustBePureTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = ContentMustBePure();
    super.setUp();
  }

  Future<void> test_content_importing_flutter_bloc() => expectLints(
    'src/movie_details_content.dart',
    "import 'package:flutter_bloc/flutter_bloc.dart';",
    ["'package:flutter_bloc/flutter_bloc.dart'"],
  );

  Future<void> test_widget_importing_the_bloc_and_router() => expectLints(
    'src/widgets/cast_row.dart',
    '''
import 'package:go_router/go_router.dart';
import 'movie_details_bloc.dart';
''',
    ["'package:go_router/go_router.dart'", "'movie_details_bloc.dart'"],
  );

  Future<void> test_content_importing_core_base_widgets() => expectLints(
    'src/movie_details_content.dart',
    "import 'package:core_base/widgets.dart';",
    ["'package:core_base/widgets.dart'"],
  );

  Future<void> test_content_importing_flutter_and_contract_is_fine() =>
      expectLints('src/movie_details_content.dart', '''
import 'package:flutter/widgets.dart';
import 'movie_details_contract.dart';
''', []);

  Future<void> test_screen_may_import_flutter_bloc() => expectLints(
    'src/movie_details_screen.dart',
    "import 'package:flutter_bloc/flutter_bloc.dart';",
    [],
  );
}
