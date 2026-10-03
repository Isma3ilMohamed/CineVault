import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';

/// Base for rule tests: the package under test sits at
/// `packages/features/movie_details`, like a real feature package, and the
/// packages the rules care about are stubbed.
abstract class FeatureRuleTest extends AnalysisRuleTest {
  @override
  bool get addFlutterPackageDep => true;

  @override
  String get testPackageRootPath =>
      '$workspaceRootPath/packages/features/movie_details';

  @override
  void setUp() {
    newPackage('bloc').addFile('lib/bloc.dart', 'class Bloc<E, S> {}');
    newPackage('flutter_bloc').addFile('lib/flutter_bloc.dart', '''
class BlocProvider<T> { const BlocProvider({Object? create, Object? child}); }
class MultiBlocProvider { const MultiBlocProvider(); }
''');
    newPackage('go_router').addFile('lib/go_router.dart', 'class GoRouter {}');
    newPackage('get_it').addFile('lib/get_it.dart', 'class GetIt {}');
    newPackage('core_base')
      ..addFile('lib/core_base.dart', 'mixin EffectEmitter {}')
      ..addFile(
        'lib/widgets.dart',
        'class BlocEffectListener { const BlocEffectListener(); }',
      );
    super.setUp();
    // Sibling files that test sources import by relative path.
    for (final sibling in [
      'src/movie_details_contract.dart',
      'src/movie_details_bloc.dart',
      'src/widgets/movie_details_bloc.dart',
    ]) {
      newFile('$testPackageLibPath/$sibling', '');
    }
  }

  /// Writes [code] to `lib/<relativePath>` in the feature package and asserts
  /// that exactly the snippets in [flagged] are reported (first occurrence of
  /// each).
  Future<void> expectLints(
    String relativePath,
    String code,
    List<String> flagged,
  ) async {
    final path = '$testPackageLibPath/$relativePath';
    final content = '// ignore_for_file: unused_import, unused_element\n$code';
    newFile(path, content);
    await assertDiagnosticsInFile(path, [
      for (final snippet in flagged)
        lint(content.indexOf(snippet), snippet.length),
    ]);
  }
}
