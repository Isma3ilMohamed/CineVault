import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/feature_file.dart';
import 'package:cine_vault_lints/src/import_rules.dart';

/// `*_bloc.dart`, `*_contract.dart` and `*_navigation.dart` are plain Dart:
/// they can be unit-tested without Flutter and never touch widgets.
class BlocMustBePureDart extends AnalysisRule {
  BlocMustBePureDart()
    : super(
        name: 'bloc_must_be_pure_dart',
        description:
            'Bloc, contract and navigation files must not depend on Flutter.',
      );

  static const LintCode code = LintCode(
    'bloc_must_be_pure_dart',
    'Bloc, contract and navigation files must be pure Dart and must not import Flutter.',
    correctionMessage:
        "Use 'package:bloc' and 'package:core_base/core_base.dart' instead.",
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
        roles: const {
          FeatureFileRole.bloc,
          FeatureFileRole.contract,
          FeatureFileRole.navigation,
        },
        bannedPrefixes: const [
          'dart:ui',
          'package:flutter/',
          'package:flutter_bloc/',
          'package:go_router/',
          'package:core_base/widgets.dart',
        ],
      ),
    );
  }
}
