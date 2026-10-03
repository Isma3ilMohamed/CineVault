// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/max_file_lines.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(() => defineReflectiveTests(MaxFileLinesTest));
}

@reflectiveTest
class MaxFileLinesTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = MaxFileLines();
    super.setUp();
  }

  String _lines(int count) =>
      [for (var i = 0; i < count; i++) 'const c$i = 0;'].join('\n');

  Future<void> test_long_file() async {
    final path = '$testPackageLibPath/src/long.dart';
    newFile(path, _lines(MaxFileLines.maxLines + 1));
    await assertDiagnosticsInFile(path, [lint(0, 0)]);
  }

  Future<void> test_file_at_the_limit_is_fine() async {
    final path = '$testPackageLibPath/src/ok.dart';
    newFile(path, _lines(MaxFileLines.maxLines));
    await assertNoDiagnosticsInFile(path);
  }
}
