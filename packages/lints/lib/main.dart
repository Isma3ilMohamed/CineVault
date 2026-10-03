import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:cine_vault_lints/src/rules/bloc_must_be_pure_dart.dart';
import 'package:cine_vault_lints/src/rules/content_must_be_pure.dart';
import 'package:cine_vault_lints/src/rules/english_comments_only.dart';
import 'package:cine_vault_lints/src/rules/max_file_lines.dart';
import 'package:cine_vault_lints/src/rules/no_build_helper_methods.dart';
import 'package:cine_vault_lints/src/rules/no_hardcoded_colors.dart';
import 'package:cine_vault_lints/src/rules/no_navigation_in_features.dart';
import 'package:cine_vault_lints/src/rules/provider_only_in_route.dart';
import 'package:cine_vault_lints/src/rules/screen_no_di.dart';

/// Entry point loaded by the analysis server (see `plugins:` in the root
/// analysis_options.yaml).
final plugin = CineVaultLintsPlugin();

class CineVaultLintsPlugin extends Plugin {
  @override
  String get name => 'cine_vault_lints';

  @override
  void register(PluginRegistry registry) {
    // Warning rules: enabled by default, and they fail `flutter analyze`.
    registry
      ..registerWarningRule(ContentMustBePure())
      ..registerWarningRule(BlocMustBePureDart())
      ..registerWarningRule(ProviderOnlyInRoute())
      ..registerWarningRule(NoNavigationInFeatures())
      ..registerWarningRule(ScreenNoDi())
      // General readability rules: every hand-written file, not only features.
      ..registerWarningRule(MaxFileLines())
      ..registerWarningRule(NoBuildHelperMethods())
      ..registerWarningRule(NoHardcodedColors())
      ..registerWarningRule(EnglishCommentsOnly());
  }
}
