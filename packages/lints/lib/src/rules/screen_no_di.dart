import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/feature_file.dart';
import 'package:cine_vault_lints/src/import_rules.dart';

/// The Screen binds state to the Content; it never looks anything up. The
/// Route gets the bloc from DI, the Screen reads it from the BlocProvider.
class ScreenNoDi extends AnalysisRule {
  ScreenNoDi()
    : super(
        name: 'screen_no_di',
        description: 'Screen files must not use dependency injection.',
      );

  static const LintCode code = LintCode(
    'screen_no_di',
    'Screen files must not use dependency injection.',
    correctionMessage:
        'Get the bloc in the Route and read it here with context.read().',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addImportDirective(
      this,
      BannedImportVisitor(
        rule: this,
        context: context,
        roles: const {FeatureFileRole.screen},
        bannedPrefixes: const ['package:get_it/', 'package:injectable/'],
      ),
    );
  }
}
