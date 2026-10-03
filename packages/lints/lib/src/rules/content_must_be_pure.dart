import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/feature_file.dart';
import 'package:cine_vault_lints/src/import_rules.dart';

/// `*_content.dart` and `widgets/` only draw: state and callbacks in, nothing
/// else. No bloc, no DI, no navigation, no knowledge of the other layers.
class ContentMustBePure extends AnalysisRule {
  ContentMustBePure()
    : super(
        name: 'content_must_be_pure',
        description: 'Content and widget files must not depend on state management, DI or routing.',
      );

  static const LintCode code = LintCode(
    'content_must_be_pure',
    'Content and widget files only draw: they must not import state management, DI or routing.',
    correctionMessage:
        'Take the state and callbacks as constructor parameters instead.',
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
        roles: const {FeatureFileRole.content, FeatureFileRole.widget},
        bannedPrefixes: const [
          'package:bloc/',
          'package:flutter_bloc/',
          'package:provider/',
          'package:get_it/',
          'package:go_router/',
          'package:core_base/',
        ],
        bannedSuffixes: const [
          '_bloc.dart',
          '_cubit.dart',
          '_route.dart',
          '_screen.dart',
        ],
      ),
    );
  }
}
