// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/english_comments_only.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(() => defineReflectiveTests(EnglishCommentsOnlyTest));
}

@reflectiveTest
class EnglishCommentsOnlyTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = EnglishCommentsOnly();
    super.setUp();
  }

  // The Arabic sample is built from code points so this file stays English.
  static final _arabic = String.fromCharCodes([0x0645, 0x062B, 0x0627, 0x0644]);

  Future<void> test_arabic_line_and_doc_comments() => expectLints(
    'src/x.dart',
    '''
// $_arabic
const a = 0;

/// Doc $_arabic
const b = 0;
''',
    ['// $_arabic', '/// Doc $_arabic'],
  );

  Future<void> test_arabic_strings_are_not_comments() =>
      expectLints('src/x.dart', '''
// English is fine.
const a = '$_arabic';
''', []);
}
