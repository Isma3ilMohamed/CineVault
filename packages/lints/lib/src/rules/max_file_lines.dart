import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/source_file.dart';

/// A file longer than [maxLines] is doing too much: split the Content into
/// `widgets/`, or the class into smaller ones.
class MaxFileLines extends AnalysisRule {
  MaxFileLines()
    : super(
        name: 'max_file_lines',
        description: 'Files must not be longer than $maxLines lines.',
      );

  static const maxLines = 250;

  static const LintCode code = LintCode(
    'max_file_lines',
    'This file has {0} lines; the limit is $maxLines.',
    correctionMessage:
        'Move parts into their own files (for UI, under widgets/).',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addCompilationUnit(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final path = context.currentUnit?.file.path;
    if (path == null || !isHandWrittenSource(path)) return;
    final lines = node.lineInfo.lineCount;
    if (lines > MaxFileLines.maxLines) {
      // On the first line, so the warning points at the file, not at code.
      rule.reportAtOffset(0, 0, arguments: [lines]);
    }
  }
}
