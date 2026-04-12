import 'package:flutter_ci_cd_demo/core/config/app_env.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

/// Note: `String.fromEnvironment` (e.g. `APP_ENV`, `OPENWEATHER_API_KEY`) is
/// resolved at compile time. This file only covers the `flutter_dotenv`
/// branches when defines are empty in this test binary. Different `APP_ENV`
/// compile values are exercised by the CI matrix (`flutter test
/// --dart-define=APP_ENV=...`).
void main() {
  group('AppEnv with dotenv', () {
    tearDown(() {
      dotenv.clean();
    });

    test(
      'openWeatherApiKey reads from dotenv when compile-time define is empty',
      () {
        dotenv.testLoad(fileInput: 'OPENWEATHER_API_KEY=from_dotenv\n');

        expect(AppEnv.openWeatherApiKey, 'from_dotenv');
      },
    );

    test(
      'openWeatherBaseUrl reads from dotenv when compile-time define is empty',
      () {
        dotenv.testLoad(
          fileInput: 'OPENWEATHER_BASE_URL=https://example.test/api\n',
        );

        expect(AppEnv.openWeatherBaseUrl, 'https://example.test/api');
      },
    );

    test(
      'appEnv reads APP_ENV from dotenv when compile-time define is empty',
      () {
        dotenv.testLoad(fileInput: 'APP_ENV=staging\n');

        expect(AppEnv.appEnv, 'staging');
      },
    );

    test('appEnv normalizes unknown APP_ENV in dotenv to dev', () {
      dotenv.testLoad(fileInput: 'APP_ENV=unknown-flavor\n');

      expect(AppEnv.appEnv, 'dev');
    });
  });
}
