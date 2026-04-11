import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'domain/di/service_locator.dart';
import 'presentation/weather/pages/weather_page.dart';
import 'presentation/weather/stores/i_weather_store.dart';
import 'presentation/weather/stores/weather_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional local env file (do not commit). CI should use --dart-define.
  try {
    await dotenv.load(fileName: '.env.local');
  } catch (_) {}

  await initServiceLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<IWeatherStore>(
      create: (_) => sl<WeatherStore>(),
      child: MaterialApp(
        title: 'Weather CI/CD Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const WeatherPage(),
      ),
    );
  }
}
