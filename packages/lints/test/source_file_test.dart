import 'package:cine_vault_lints/src/source_file.dart';
import 'package:test/test.dart';

void main() {
  test('hand-written lib code of packages and the app is checked', () {
    expect(
      isHandWrittenSource(
        '/r/packages/features/home/lib/src/home_content.dart',
      ),
      isTrue,
    );
    expect(
      isHandWrittenSource('/r/packages/shared/movie_ui/lib/movie_ui.dart'),
      isTrue,
    );
    expect(isHandWrittenSource('/r/app/lib/main.dart'), isTrue);
  });

  test('tests, generated code and the plugin itself are not', () {
    expect(
      isHandWrittenSource('/r/packages/features/home/test/home_test.dart'),
      isFalse,
    );
    expect(
      isHandWrittenSource(
        '/r/packages/features/home/lib/src/home_contract.freezed.dart',
      ),
      isFalse,
    );
    expect(isHandWrittenSource('/r/app/lib/di/injection.config.dart'), isFalse);
    expect(
      isHandWrittenSource('/r/packages/core/ui/lib/src/l10n/generated/x.dart'),
      isFalse,
    );
    expect(isHandWrittenSource('/r/packages/lints/lib/main.dart'), isFalse);
  });
}
