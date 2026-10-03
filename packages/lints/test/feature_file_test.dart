import 'package:cine_vault_lints/src/feature_file.dart';
import 'package:test/test.dart';

void main() {
  const root = '/repo/packages/features/movie_details/lib/src';

  test('derives the role from the file suffix', () {
    expect(
      featureFileRole('$root/movie_details_route.dart'),
      FeatureFileRole.route,
    );
    expect(
      featureFileRole('$root/movie_details_navigation.dart'),
      FeatureFileRole.navigation,
    );
    expect(
      featureFileRole('$root/movie_details_screen.dart'),
      FeatureFileRole.screen,
    );
    expect(
      featureFileRole('$root/movie_details_content.dart'),
      FeatureFileRole.content,
    );
    expect(
      featureFileRole('$root/movie_details_contract.dart'),
      FeatureFileRole.contract,
    );
    expect(
      featureFileRole('$root/movie_details_bloc.dart'),
      FeatureFileRole.bloc,
    );
  });

  test(
    'files under widgets/ are widgets unless their suffix says otherwise',
    () {
      expect(
        featureFileRole('$root/widgets/cast_row.dart'),
        FeatureFileRole.widget,
      );
      expect(
        featureFileRole('$root/widgets/poster_content.dart'),
        FeatureFileRole.content,
      );
    },
  );

  test('other files in a feature package are "other"', () {
    expect(
      featureFileRole(
        '/repo/packages/features/movie_details/lib/movie_details.dart',
      ),
      FeatureFileRole.other,
    );
  });

  test('files outside feature packages are not checked', () {
    expect(
      featureFileRole(
        '/repo/lib/features/movies/presentation/pages/home_page.dart',
      ),
      isNull,
    );
    expect(
      featureFileRole('/repo/packages/core/base/lib/src/effect_emitter.dart'),
      isNull,
    );
    expect(
      featureFileRole('/repo/packages/features/movie_details/test/x_bloc.dart'),
      isNull,
    );
  });

  test('handles Windows separators', () {
    expect(
      featureFileRole(
        r'C:\repo\packages\features\movie_details\lib\src\x_bloc.dart',
      ),
      FeatureFileRole.bloc,
    );
  });
}
