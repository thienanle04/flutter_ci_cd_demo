import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App environment configuration.
///
/// - **Deployment** (`APP_ENV`): pass `--dart-define=APP_ENV=dev|staging|main`
///   in CI, or set `APP_ENV` in `.env.local` for local runs.
/// - **OpenWeather**: pass `--dart-define=OPENWEATHER_API_KEY=...` in CI/CD to
///   keep secrets masked. Locally, you can use a `.env.local` file for convenience.
///
/// `String.fromEnvironment` values are fixed at compile time; to assert multiple
/// `APP_ENV` values, run `flutter test` / `flutter build` with different
/// `--dart-define` flags (see CI matrix).
final class AppEnv {
  static const String _apiKeyDefine = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
  );
  static const String _baseUrlDefine = String.fromEnvironment(
    'OPENWEATHER_BASE_URL',
    defaultValue: '',
  );
  static const String _appEnvDefine = String.fromEnvironment(
    'APP_ENV',
    defaultValue: '',
  );

  /// One of `dev`, `staging`, or `main`. Unknown values are treated as `dev`.
  static String get appEnv {
    final fromDefine = _appEnvDefine.trim();
    if (fromDefine.isNotEmpty) {
      return _normalizeAppEnv(fromDefine);
    }
    if (dotenv.isInitialized) {
      final fromFile = (dotenv.env['APP_ENV'] ?? '').trim();
      if (fromFile.isNotEmpty) {
        return _normalizeAppEnv(fromFile);
      }
    }
    return 'dev';
  }

  static bool get isMainDeployment => appEnv == 'main';

  static String get openWeatherApiKey {
    final fromDefine = _apiKeyDefine.trim();
    if (fromDefine.isNotEmpty) return fromDefine;
    if (!dotenv.isInitialized) return '';
    return (dotenv.env['OPENWEATHER_API_KEY'] ?? '').trim();
  }

  static String get openWeatherBaseUrl {
    final fromDefine = _baseUrlDefine.trim();
    if (fromDefine.isNotEmpty) return fromDefine;
    if (!dotenv.isInitialized) return 'https://api.openweathermap.org/data/2.5';
    return (dotenv.env['OPENWEATHER_BASE_URL'] ??
            'https://api.openweathermap.org/data/2.5')
        .trim();
  }

  static String _normalizeAppEnv(String raw) {
    switch (raw.toLowerCase()) {
      case 'staging':
        return 'staging';
      case 'main':
        return 'main';
      case 'dev':
        return 'dev';
      default:
        return 'dev';
    }
  }
}
