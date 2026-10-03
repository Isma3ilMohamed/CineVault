import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/feature_file.dart';

/// Features never navigate themselves: the Route receives callbacks and the
/// navigation package decides where they lead.
class NoNavigationInFeatures extends AnalysisRule {
  NoNavigationInFeatures()
    : super(
        name: 'no_navigation_in_features',
        description:
            'Feature packages must not use go_router or Navigator directly.',
      );

  static const LintCode code = LintCode(
    'no_navigation_in_features',
    'Features must not navigate directly.',
    correctionMessage: 'Emit a NavigationEffect and let the Route call the callback it was given.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry
      ..addImportDirective(this, visitor)
      ..addSimpleIdentifier(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  static const _routerPackages = ['package:go_router/', 'package:auto_route/'];

  bool get _isFeatureFile {
    final path = context.currentUnit?.file.path;
    return path != null && featureFileRole(path) != null;
  }

  @override
  void visitImportDirective(ImportDirective node) {
    if (!_isFeatureFile) return;
    final uri = node.uri.stringValue;
    if (uri != null && _routerPackages.any(uri.startsWith)) {
      rule.reportAtNode(node.uri);
    }
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    final element = node.element;
    if (element is! ClassElement || element.name != 'Navigator') return;
    final libraryUri = element.library.uri.toString();
    if (!libraryUri.startsWith('package:flutter/')) return;
    if (_isFeatureFile) rule.reportAtNode(node);
  }
}
