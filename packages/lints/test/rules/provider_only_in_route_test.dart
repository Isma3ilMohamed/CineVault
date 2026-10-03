// test_reflective_loader discovers test cases by their `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:cine_vault_lints/src/rules/provider_only_in_route.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../feature_rule_test_base.dart';

void main() {
  defineReflectiveSuite(() => defineReflectiveTests(ProviderOnlyInRouteTest));
}

@reflectiveTest
class ProviderOnlyInRouteTest extends FeatureRuleTest {
  @override
  void setUp() {
    rule = ProviderOnlyInRoute();
    super.setUp();
  }

  Future<void> test_bloc_provider_in_screen() => expectLints(
    'src/movie_details_screen.dart',
    '''
import 'package:flutter_bloc/flutter_bloc.dart';
Object build() => BlocProvider<int>(create: 1);
''',
    ['BlocProvider<int>'],
  );

  Future<void> test_effect_listener_in_other_file() => expectLints(
    'src/helpers.dart',
    '''
import 'package:core_base/widgets.dart';
Object build() => const BlocEffectListener();
''',
    ['BlocEffectListener'],
  );

  Future<void> test_providers_in_route_are_fine() =>
      expectLints('src/movie_details_route.dart', '''
import 'package:core_base/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
Object build() => BlocProvider<int>(child: const BlocEffectListener());
''', []);

  Future<void> test_same_name_from_another_library_is_fine() =>
      expectLints('src/movie_details_screen.dart', '''
class BlocProvider { const BlocProvider(); }
Object build() => const BlocProvider();
''', []);
}
