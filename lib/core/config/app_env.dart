import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App environment configuration.
///
/// - In CI/CD, pass `--dart-define=OPENWEATHER_API_KEY=...` to keep secrets masked.
/// - Locally, you can use a `.env.local` file (not committed) for convenience.
final class AppEnv {
  static const String _apiKeyDefine = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
  );
  static const String _baseUrlDefine = String.fromEnvironment(
    'OPENWEATHER_BASE_URL',
    defaultValue: '',
  );

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
}
