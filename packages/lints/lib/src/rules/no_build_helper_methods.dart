import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/source_file.dart';

/// `Widget _buildHeader()` hides a widget inside a method: it has no name in
/// the widget tree, cannot be const and rebuilds with its parent. A private
/// widget class reads the same and does neither.
class NoBuildHelperMethods extends AnalysisRule {
  NoBuildHelperMethods()
    : super(
        name: 'no_build_helper_methods',
        description: 'Private methods and functions must not return widgets.',
      );

  static const LintCode code = LintCode(
    'no_build_helper_methods',
    "'{0}' builds a widget in a helper method.",
    correctionMessage: 'Turn it into a private widget class.',
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
      ..addMethodDeclaration(this, visitor)
      ..addFunctionDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitMethodDeclaration(MethodDeclaration node) => _check(
    node.name.lexeme,
    node.returnType?.type,
    () => rule.reportAtToken(node.name, arguments: [node.name.lexeme]),
  );

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    // Local functions (closures inside build) are fine.
    if (node.parent is! CompilationUnit) return;
    _check(
      node.name.lexeme,
      node.returnType?.type,
      () => rule.reportAtToken(node.name, arguments: [node.name.lexeme]),
    );
  }

  void _check(String name, DartType? returnType, void Function() report) {
    if (!name.startsWith('_')) return;
    final path = context.currentUnit?.file.path;
    if (path == null || !isHandWrittenSource(path)) return;
    if (returnType is InterfaceType && _isWidget(returnType)) report();
  }

  static bool _isWidget(InterfaceType type) =>
      [type, ...type.allSupertypes].any(
        (t) =>
            t.element.name == 'Widget' &&
            (t.element.library.uri.toString().startsWith('package:flutter/')),
      );
}
