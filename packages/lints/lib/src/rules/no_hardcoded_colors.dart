import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/source_file.dart';

/// Colors are design tokens: defined once in `core_ui`'s theme and read with
/// `context.appColors` or `Theme.of(context)`. A `Color(0xFF...)` anywhere
/// else is a token that will drift.
class NoHardcodedColors extends AnalysisRule {
  NoHardcodedColors()
    : super(
        name: 'no_hardcoded_colors',
        description: 'Colors must come from the theme, not Color literals.',
      );

  static const LintCode code = LintCode(
    'no_hardcoded_colors',
    'Hardcoded color: colors are defined only in core_ui/theme.',
    correctionMessage: 'Use context.appColors or Theme.of(context), or add a token to AppColors.',
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

  /// Where the tokens are defined: the app's theme folder (and the old
  /// core_ui package path, kept for the rule's own tests).
  static const _themeDirectories = [
    '/lib/core/theme/',
    '/packages/core/ui/lib/src/theme/',
  ];

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final path = context.currentUnit?.file.path;
    if (path == null || !isHandWrittenSource(path)) return;
    final normalized = path.replaceAll(r'\', '/');
    if (_themeDirectories.any(normalized.contains)) return;

    final element = node.constructorName.type.element;
    if (element == null || element.name != 'Color') return;
    final library = element.library?.uri.toString() ?? '';
    if (library == 'dart:ui' || library.startsWith('package:flutter/')) {
      rule.reportAtNode(node);
    }
  }
}
