import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/feature_file.dart';

/// A feature provides its bloc and consumes its effects in one place: the
/// Route. Everything below it receives state and callbacks.
class ProviderOnlyInRoute extends AnalysisRule {
  ProviderOnlyInRoute()
    : super(
        name: 'provider_only_in_route',
        description: 'Bloc providers and effect listeners may only be created in *_route.dart.',
      );

  static const LintCode code = LintCode(
    'provider_only_in_route',
    "'{0}' may only be created in the feature's *_route.dart.",
    correctionMessage:
        'Move it to the Route and pass state and callbacks down.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addInstanceCreationExpression(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  static const _restrictedTypes = {
    'BlocProvider',
    'MultiBlocProvider',
    'RepositoryProvider',
    'MultiRepositoryProvider',
    'BlocEffectListener',
  };

  static const _restrictedLibraries = [
    'package:flutter_bloc/',
    'package:provider/',
    'package:core_base/',
  ];

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final path = context.currentUnit?.file.path;
    if (path == null) return;
    final role = featureFileRole(path);
    if (role == null || role == FeatureFileRole.route) return;

    final type = node.constructorName.type;
    final element = type.element;
    if (element == null || !_restrictedTypes.contains(element.name)) return;
    final libraryUri = element.library?.uri.toString() ?? '';
    if (!_restrictedLibraries.any(libraryUri.startsWith)) return;

    rule.reportAtNode(type, arguments: [element.name!]);
  }
}
