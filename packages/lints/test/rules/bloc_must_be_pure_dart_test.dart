// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/bloc_must_be_pure_dart.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(() => defineReflectiveTests(BlocMustBePureDartTest));
}

@reflectiveTest
class BlocMustBePureDartTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = BlocMustBePureDart();
    super.setUp();
  }

  Future<void> test_bloc_importing_flutter() => expectLints(
    'src/movie_details_bloc.dart',
    "import 'package:flutter/widgets.dart';",
    ["'package:flutter/widgets.dart'"],
  );

  Future<void> test_contract_importing_flutter_bloc() => expectLints(
    'src/movie_details_contract.dart',
    "import 'package:flutter_bloc/flutter_bloc.dart';",
    ["'package:flutter_bloc/flutter_bloc.dart'"],
  );

  Future<void> test_navigation_importing_core_base_widgets() => expectLints(
    'src/movie_details_navigation.dart',
    "import 'package:core_base/widgets.dart';",
    ["'package:core_base/widgets.dart'"],
  );

  Future<void> test_bloc_using_pure_packages_is_fine() =>
      expectLints('src/movie_details_bloc.dart', '''
import 'package:bloc/bloc.dart';
import 'package:core_base/core_base.dart';
import 'movie_details_contract.dart';
''', []);

  Future<void> test_content_may_import_flutter() => expectLints(
    'src/movie_details_content.dart',
    "import 'package:flutter/widgets.dart';",
    [],
  );
}
