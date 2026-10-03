import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:cine_vault_lints/src/source_file.dart';

/// Code comments are in English, so anyone can read them. User-facing text
/// lives in the ARB files, not in comments or string literals.
class EnglishCommentsOnly extends AnalysisRule {
  EnglishCommentsOnly()
    : super(
        name: 'english_comments_only',
        description: 'Comments must be written in English.',
      );

  static const LintCode code = LintCode(
    'english_comments_only',
    'Comments must be written in English.',
    correctionMessage: 'Rewrite the comment in English.',
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

  /// Arabic script blocks (basic, supplement, extended, presentation forms).
  static final _arabic = RegExp('[؀-ۿݐ-ݿࢠ-ࣿﭐ-﷿ﹰ-﻿]');

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final path = context.currentUnit?.file.path;
    if (path == null || !isHandWrittenSource(path)) return;

    Token? token = node.beginToken;
    while (token != null) {
      Token? comment = token.precedingComments;
      while (comment != null) {
        if (_arabic.hasMatch(comment.lexeme)) rule.reportAtToken(comment);
        comment = comment.next;
      }
      if (token.isEof) break;
      token = token.next;
    }
  }
}
