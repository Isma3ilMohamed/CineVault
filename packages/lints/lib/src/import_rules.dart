import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:cine_vault_lints/src/feature_file.dart';

/// Reports imports that a file with one of [roles] must not have.
///
/// An import is banned when its URI starts with one of [bannedPrefixes] or
/// ends with one of [bannedSuffixes].
class BannedImportVisitor extends SimpleAstVisitor<void> {
  BannedImportVisitor({
    required this.rule,
    required this.context,
    required this.roles,
    this.bannedPrefixes = const [],
    this.bannedSuffixes = const [],
  });

  final AnalysisRule rule;
  final RuleContext context;
  final Set<FeatureFileRole> roles;
  final List<String> bannedPrefixes;
  final List<String> bannedSuffixes;

  @override
  void visitImportDirective(ImportDirective node) {
    final path = context.currentUnit?.file.path;
    if (path == null || !roles.contains(featureFileRole(path))) return;

    final uri = node.uri.stringValue;
    if (uri == null) return;
    final banned =
        bannedPrefixes.any(uri.startsWith) || bannedSuffixes.any(uri.endsWith);
    if (banned) rule.reportAtNode(node.uri);
  }
}
